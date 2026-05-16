#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd)

avd_name=${OPENYAMM_AVD_NAME:-openyamm_api35}
package_name=${OPENYAMM_ANDROID_PACKAGE:-org.openyamm.android}
java_home=${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}
emulator_partition_mb=${OPENYAMM_EMULATOR_PARTITION_MB:-16384}
emulator_wipe_data=${OPENYAMM_EMULATOR_WIPE_DATA:-0}
build_release_apk=${OPENYAMM_BUILD_RELEASE_APK:-1}
uninstall_on_signature_mismatch=${OPENYAMM_ANDROID_UNINSTALL_ON_SIGNATURE_MISMATCH:-1}
apk_path="${repo_root}/android/app-release.apk"

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
export PATH="${JAVA_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}"

adb_bin="${ANDROID_HOME}/platform-tools/adb"
emulator_bin="${ANDROID_HOME}/emulator/emulator"

if [[ ! -x "${adb_bin}" ]]; then
    echo "adb not found: ${adb_bin}" >&2
    echo "Set ANDROID_HOME or android/local.properties to your Android SDK path." >&2
    exit 1
fi

if [[ ! -x "${emulator_bin}" ]]; then
    echo "emulator not found: ${emulator_bin}" >&2
    echo "Install it with: sdkmanager --install emulator" >&2
    exit 1
fi

device_serial()
{
    "${adb_bin}" devices | awk 'NR > 1 && $2 == "device" { print $1; exit }'
}

wait_for_boot()
{
    local serial="$1"
    local boot_completed=""

    echo "Waiting for Android boot completion on ${serial}..."
    for _ in $(seq 1 180); do
        boot_completed=$("${adb_bin}" -s "${serial}" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' || true)
        if [[ "${boot_completed}" == "1" ]]; then
            return 0
        fi
        sleep 1
    done

    echo "Timed out waiting for emulator boot completion." >&2
    return 1
}

install_apk()
{
    local serial="$1"
    local install_output=""

    if install_output=$("${adb_bin}" -s "${serial}" install -r "${apk_path}" 2>&1); then
        echo "${install_output}"
        return 0
    fi

    echo "${install_output}" >&2

    if [[ "${uninstall_on_signature_mismatch}" == "1" ]] \
        && grep -q "INSTALL_FAILED_UPDATE_INCOMPATIBLE" <<<"${install_output}"; then
        echo "Installed package has a different signing key; uninstalling ${package_name} and retrying..." >&2
        "${adb_bin}" -s "${serial}" uninstall "${package_name}" >/dev/null || true
        "${adb_bin}" -s "${serial}" install "${apk_path}"
        return 0
    fi

    return 1
}

check_release_device_abi()
{
    local serial="$1"
    local device_abis=""

    device_abis=$("${adb_bin}" -s "${serial}" shell getprop ro.product.cpu.abilist 2>/dev/null | tr -d '\r' || true)

    if [[ ",${device_abis}," == *",arm64-v8a,"* ]]; then
        return 0
    fi

    echo "Release APK is arm64-v8a only, but ${serial} supports: ${device_abis:-unknown}" >&2
    echo "Use an arm64 emulator/device for release testing, or use android/run_debug_emulator.sh on x86_64." >&2
    return 1
}

echo "ANDROID_HOME=${ANDROID_HOME}"
echo "JAVA_HOME=${JAVA_HOME}"

if [[ "${build_release_apk}" == "1" ]]; then
    "${script_dir}/build_release_apk.sh"
elif [[ ! -f "${apk_path}" ]]; then
    echo "Release APK not found: ${apk_path}" >&2
    echo "Run android/build_release_apk.sh first, or set OPENYAMM_BUILD_RELEASE_APK=1." >&2
    exit 1
fi

serial=$(device_serial || true)
if [[ -z "${serial}" ]]; then
    echo "No running Android device/emulator found; starting AVD '${avd_name}'..."

    if ! "${emulator_bin}" -list-avds | grep -Fxq "${avd_name}"; then
        echo "AVD '${avd_name}' does not exist." >&2
        echo "Create it with:" >&2
        echo "  avdmanager create avd -n ${avd_name} -k \"system-images;android-35;google_apis;x86_64\" -d pixel_7" >&2
        exit 1
    fi

    emulator_args=(
        -avd "${avd_name}"
        -netdelay none
        -netspeed full
        -partition-size "${emulator_partition_mb}"
    )

    if [[ "${emulator_wipe_data}" == "1" ]]; then
        emulator_args+=(-wipe-data -no-snapshot-load)
    fi

    nohup "${emulator_bin}" "${emulator_args[@]}" >"${repo_root}/android/emulator-${avd_name}.log" 2>&1 &

    "${adb_bin}" wait-for-device
    serial=$(device_serial || true)
fi

if [[ -z "${serial}" ]]; then
    echo "No booted Android device/emulator is available." >&2
    exit 1
fi

wait_for_boot "${serial}"
check_release_device_abi "${serial}"

echo "Using device ${serial}"
echo "Installing ${apk_path}..."
install_apk "${serial}"

echo "Launching ${package_name}..."
"${adb_bin}" -s "${serial}" logcat -c
"${adb_bin}" -s "${serial}" shell monkey -p "${package_name}" 1 >/dev/null

echo "Following logs. Press Ctrl-C to stop."
"${adb_bin}" -s "${serial}" logcat -v time -s OpenYAMM SDL AndroidRuntime DEBUG libc
