#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd)

package_name=${OPENYAMM_ANDROID_PACKAGE:-org.openyamm.android}
java_home=${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}
duration_seconds=${OPENYAMM_SIMPLEPERF_DURATION:-30}
sample_frequency=${OPENYAMM_SIMPLEPERF_FREQUENCY:-1000}
event_name=${OPENYAMM_SIMPLEPERF_EVENT:-task-clock:u}
serial=${ANDROID_SERIAL:-}
build_apk=${OPENYAMM_BUILD_RELEASE_APK:-1}
install_apk=${OPENYAMM_ANDROID_INSTALL_APK:-1}
launch_app=${OPENYAMM_ANDROID_LAUNCH_APP:-1}
clear_data=${OPENYAMM_ANDROID_CLEAR_DATA:-0}
repack_assets=${OPENYAMM_REPACK_ASSETS:-0}
output_root=${OPENYAMM_SIMPLEPERF_OUTPUT_DIR:-"${repo_root}/android/profile-output"}
apk_path="${repo_root}/android/app-release.apk"

usage()
{
    cat >&2 <<EOF
Usage: $0 [options]

Options:
  --serial SERIAL       Use a specific adb device serial.
  --duration SECONDS    Recording duration. Default: ${duration_seconds}.
  --frequency HZ        Sampling frequency. Default: ${sample_frequency}.
  --event EVENT         simpleperf event. Default: ${event_name}.
  --output-dir DIR      Output directory root. Default: ${output_root}.
  --repack-assets       Repack assets before building the APK.
  --no-build            Use the existing android/app-release.apk.
  --no-install          Do not install the APK before profiling.
  --no-launch           Profile the already-running app process.
  --clear-data          Clear OpenYAMM app data before launch.
  -h, --help            Show this help.

Environment:
  OPENYAMM_ANDROID_KEYSTORE_PASSWORD and OPENYAMM_ANDROID_KEY_PASSWORD are used by build_release_apk.sh.
  OPENYAMM_SIMPLEPERF_DURATION, OPENYAMM_SIMPLEPERF_FREQUENCY, and OPENYAMM_SIMPLEPERF_EVENT set defaults.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --serial)
            serial="${2:-}"
            if [[ -z "${serial}" ]]; then
                echo "--serial requires a value." >&2
                exit 1
            fi
            shift 2
            ;;
        --duration)
            duration_seconds="${2:-}"
            if [[ -z "${duration_seconds}" ]]; then
                echo "--duration requires a value." >&2
                exit 1
            fi
            shift 2
            ;;
        --frequency)
            sample_frequency="${2:-}"
            if [[ -z "${sample_frequency}" ]]; then
                echo "--frequency requires a value." >&2
                exit 1
            fi
            shift 2
            ;;
        --event)
            event_name="${2:-}"
            if [[ -z "${event_name}" ]]; then
                echo "--event requires a value." >&2
                exit 1
            fi
            shift 2
            ;;
        --output-dir)
            output_root="${2:-}"
            if [[ -z "${output_root}" ]]; then
                echo "--output-dir requires a value." >&2
                exit 1
            fi
            shift 2
            ;;
        --repack-assets)
            repack_assets=1
            shift
            ;;
        --no-build)
            build_apk=0
            shift
            ;;
        --no-install)
            install_apk=0
            shift
            ;;
        --no-launch)
            launch_app=0
            shift
            ;;
        --clear-data)
            clear_data=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

read_local_sdk_dir()
{
    local local_properties="${script_dir}/local.properties"

    if [[ ! -f "${local_properties}" ]]; then
        return 1
    fi

    sed -n 's/^sdk\.dir=//p' "${local_properties}" | tail -n 1
}

local_sdk_dir=$(read_local_sdk_dir || true)
sdk_dir=""

if [[ -n "${local_sdk_dir}" && -d "${local_sdk_dir}" ]]; then
    sdk_dir="${local_sdk_dir}"
elif [[ -n "${ANDROID_HOME:-}" && -d "${ANDROID_HOME}" ]]; then
    sdk_dir="${ANDROID_HOME}"
elif [[ -n "${ANDROID_SDK_ROOT:-}" && -d "${ANDROID_SDK_ROOT}" ]]; then
    sdk_dir="${ANDROID_SDK_ROOT}"
elif [[ -d "${HOME}/android-sdk" ]]; then
    sdk_dir="${HOME}/android-sdk"
elif [[ -n "${local_sdk_dir}" ]]; then
    sdk_dir="${local_sdk_dir}"
elif [[ -n "${ANDROID_HOME:-}" ]]; then
    sdk_dir="${ANDROID_HOME}"
elif [[ -n "${ANDROID_SDK_ROOT:-}" ]]; then
    sdk_dir="${ANDROID_SDK_ROOT}"
else
    sdk_dir="${HOME}/android-sdk"
fi

export JAVA_HOME="${java_home}"
export ANDROID_HOME="${sdk_dir}"
export ANDROID_SDK_ROOT="${sdk_dir}"
export PATH="${JAVA_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

adb_bin="${ANDROID_HOME}/platform-tools/adb"

if [[ ! -x "${adb_bin}" ]]; then
    echo "adb not found: ${adb_bin}" >&2
    echo "Set ANDROID_HOME or android/local.properties to your Android SDK path." >&2
    exit 1
fi

find_ndk_dir()
{
    if [[ -n "${ANDROID_NDK_HOME:-}" && -d "${ANDROID_NDK_HOME}" ]]; then
        echo "${ANDROID_NDK_HOME}"
        return 0
    fi

    if [[ -n "${ANDROID_NDK_ROOT:-}" && -d "${ANDROID_NDK_ROOT}" ]]; then
        echo "${ANDROID_NDK_ROOT}"
        return 0
    fi

    if [[ -d "${ANDROID_HOME}/ndk/28.2.13676358" ]]; then
        echo "${ANDROID_HOME}/ndk/28.2.13676358"
        return 0
    fi

    find "${ANDROID_HOME}/ndk" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort -V | tail -n 1
}

ndk_dir=$(find_ndk_dir || true)
simpleperf_dir="${ndk_dir}/simpleperf"
app_profiler="${simpleperf_dir}/app_profiler.py"
report_html="${simpleperf_dir}/report_html.py"
host_simpleperf="${simpleperf_dir}/bin/linux/x86_64/simpleperf"

if [[ -z "${ndk_dir}" || ! -f "${app_profiler}" || ! -x "${host_simpleperf}" ]]; then
    echo "NDK simpleperf not found under: ${ndk_dir:-<none>}" >&2
    echo "Install the NDK with sdkmanager or set ANDROID_NDK_HOME." >&2
    exit 1
fi

python_for_app_profiler=""
for python_candidate in python3.12 python3.11 python3.10 python3.9 python3 python; do
    if command -v "${python_candidate}" >/dev/null 2>&1; then
        python_for_app_profiler="${python_candidate}"
        break
    fi
done

if [[ -z "${python_for_app_profiler}" ]]; then
    echo "Python not found; simpleperf scripts require Python." >&2
    exit 1
fi

python_for_report_html=""
for python_candidate in python3.12 python3.11 python3.10 python3.9; do
    if command -v "${python_candidate}" >/dev/null 2>&1; then
        python_for_report_html="${python_candidate}"
        break
    fi
done

physical_device_serial()
{
    "${adb_bin}" devices | awk 'NR > 1 && $2 == "device" && $1 !~ /^emulator-/ { print $1; exit }'
}

if [[ -z "${serial}" ]]; then
    serial=$(physical_device_serial || true)
fi

if [[ -z "${serial}" ]]; then
    echo "No physical USB Android device found." >&2
    echo "Connect a phone, enable USB debugging, authorize the PC, then run: ${adb_bin} devices" >&2
    exit 1
fi

device_state=$("${adb_bin}" -s "${serial}" get-state 2>/dev/null | tr -d '\r' || true)
if [[ "${device_state}" != "device" ]]; then
    echo "Device ${serial} is not ready: ${device_state:-unknown}" >&2
    exit 1
fi

device_abis=$("${adb_bin}" -s "${serial}" shell getprop ro.product.cpu.abilist 2>/dev/null | tr -d '\r' || true)
if [[ ",${device_abis}," != *",arm64-v8a,"* ]]; then
    echo "Device ${serial} does not report arm64-v8a support: ${device_abis:-unknown}" >&2
    exit 1
fi

echo "ANDROID_HOME=${ANDROID_HOME}"
echo "ANDROID_NDK_HOME=${ndk_dir}"
echo "JAVA_HOME=${JAVA_HOME}"
echo "Using physical device: ${serial}"
echo "Device ABIs: ${device_abis}"

if [[ "${build_apk}" == "1" ]]; then
    build_args=()
    if [[ "${repack_assets}" == "1" ]]; then
        build_args+=(--repack-assets)
    fi

    echo "Building profileable arm64 release APK..."
    OPENYAMM_ANDROID_PROFILEABLE=1 \
        OPENYAMM_ANDROID_RELEASE_ABIS=arm64-v8a \
        "${script_dir}/build_release_apk.sh" "${build_args[@]}"
elif [[ ! -f "${apk_path}" ]]; then
    echo "APK not found: ${apk_path}" >&2
    echo "Run android/build_release_apk.sh first, or omit --no-build." >&2
    exit 1
fi

if [[ "${install_apk}" == "1" ]]; then
    echo "Installing ${apk_path}..."
    install_output=$("${adb_bin}" -s "${serial}" install -r "${apk_path}" 2>&1) || {
        echo "${install_output}" >&2
        if grep -q "INSTALL_FAILED_UPDATE_INCOMPATIBLE" <<<"${install_output}"; then
            echo "Installed package has a different signing key; uninstalling ${package_name} and retrying..." >&2
            "${adb_bin}" -s "${serial}" uninstall "${package_name}" >/dev/null || true
            "${adb_bin}" -s "${serial}" install "${apk_path}"
        else
            exit 1
        fi
    }
    echo "${install_output}"
fi

if [[ "${clear_data}" == "1" ]]; then
    echo "Clearing ${package_name} app data..."
    "${adb_bin}" -s "${serial}" shell pm clear "${package_name}" >/dev/null
fi

native_lib_dir=$(find "${repo_root}/android/app/build/intermediates/cxx/RelWithDebInfo" \
    -path "*/obj/arm64-v8a" -type d 2>/dev/null | sort | tail -n 1)

if [[ -z "${native_lib_dir}" || ! -d "${native_lib_dir}" ]]; then
    echo "Unstripped arm64 native library directory not found." >&2
    echo "Build the release APK first, or run without --no-build." >&2
    exit 1
fi

timestamp=$(date +%Y%m%d-%H%M%S)
output_dir="${output_root}/${timestamp}"
mkdir -p "${output_dir}"

record_options="-e ${event_name} -f ${sample_frequency} -g --duration ${duration_seconds}"
export ANDROID_SERIAL="${serial}"

if [[ "${launch_app}" == "1" ]]; then
    echo "Force-stopping ${package_name} before profiling launch..."
    "${adb_bin}" -s "${serial}" shell am force-stop "${package_name}" >/dev/null || true
fi

echo "Recording simpleperf profile for ${duration_seconds}s..."
echo "Record options: ${record_options}"
echo "Output: ${output_dir}"

(
    cd "${output_dir}"
    if [[ "${launch_app}" == "1" ]]; then
        "${python_for_app_profiler}" "${app_profiler}" \
            -p "${package_name}" \
            --launch \
            -r "${record_options}" \
            -lib "${native_lib_dir}" \
            -o "${output_dir}/perf.data" \
            --ndk_path "${ndk_dir}" \
            --disable_adb_root
    else
        pid=$("${adb_bin}" -s "${serial}" shell pidof "${package_name}" 2>/dev/null | tr -d '\r' || true)
        if [[ -z "${pid}" ]]; then
            echo "No running process for ${package_name}; remove --no-launch or launch the app manually." >&2
            exit 1
        fi

        "${python_for_app_profiler}" "${app_profiler}" \
            --pid "${pid}" \
            -r "${record_options}" \
            -lib "${native_lib_dir}" \
            -o "${output_dir}/perf.data" \
            --ndk_path "${ndk_dir}" \
            --disable_adb_root
    fi
)

if [[ ! -f "${output_dir}/perf.data" ]]; then
    echo "simpleperf did not produce ${output_dir}/perf.data" >&2
    exit 1
fi

echo "Generating text report..."
"${host_simpleperf}" report \
    -i "${output_dir}/perf.data" \
    --symfs "${output_dir}/binary_cache" \
    --children \
    -g \
    --percent-limit 0.25 \
    -o "${output_dir}/report.txt" || true

if [[ -n "${python_for_report_html}" ]]; then
    echo "Generating HTML report..."
    (
        cd "${output_dir}"
        "${python_for_report_html}" "${report_html}" \
            -i perf.data \
            -o report.html \
            --source_dirs "${repo_root}" \
            --add_source_code \
            --ndk_path "${ndk_dir}" \
            --no_browser
    ) || echo "HTML report generation failed; text report is still available." >&2
else
    echo "Skipping HTML report: simpleperf report_html.py requires Python 3.9+." >&2
fi

echo "Profile complete:"
echo "  perf.data: ${output_dir}/perf.data"
echo "  text:      ${output_dir}/report.txt"
if [[ -f "${output_dir}/report.html" ]]; then
    echo "  html:      ${output_dir}/report.html"
fi
