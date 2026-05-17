#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

avd_name=${OPENYAMM_AVD_NAME:-openyamm_api35}
system_image=${OPENYAMM_AVD_SYSTEM_IMAGE:-system-images;android-35;google_apis;x86_64}
device_profile=${OPENYAMM_AVD_DEVICE:-pixel_7}
java_home=${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}
emulator_partition_mb=${OPENYAMM_EMULATOR_PARTITION_MB:-16384}
install_system_image=${OPENYAMM_AVD_INSTALL_SYSTEM_IMAGE:-0}

usage()
{
    cat >&2 <<EOF
Usage: $0 [--install-system-image]

Deletes and recreates an Android emulator AVD from scratch.

Environment:
  OPENYAMM_AVD_NAME                 AVD name. Default: openyamm_api35
  OPENYAMM_AVD_SYSTEM_IMAGE         System image package.
                                    Default: system-images;android-35;google_apis;x86_64
  OPENYAMM_AVD_DEVICE               Device profile. Default: pixel_7
  OPENYAMM_EMULATOR_PARTITION_MB    Data partition size in MiB. Default: 16384
  OPENYAMM_AVD_INSTALL_SYSTEM_IMAGE Set to 1 to install the system image first.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --install-system-image)
            install_system_image=1
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
export PATH="${JAVA_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:\
${ANDROID_HOME}/emulator:${PATH}"

adb_bin="${ANDROID_HOME}/platform-tools/adb"
emulator_bin="${ANDROID_HOME}/emulator/emulator"
avdmanager_bin="${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager"
sdkmanager_bin="${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager"

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

if [[ ! -x "${avdmanager_bin}" ]]; then
    echo "avdmanager not found: ${avdmanager_bin}" >&2
    echo "Install Android command line tools and set ANDROID_HOME correctly." >&2
    exit 1
fi

if [[ ! -x "${sdkmanager_bin}" ]]; then
    echo "sdkmanager not found: ${sdkmanager_bin}" >&2
    echo "Install Android command line tools and set ANDROID_HOME correctly." >&2
    exit 1
fi

if [[ "${install_system_image}" == "1" ]]; then
    echo "Installing emulator and ${system_image}..."
    "${sdkmanager_bin}" --install "emulator" "${system_image}"
fi

system_image_installed()
{
    "${sdkmanager_bin}" --list_installed 2>/dev/null \
        | awk -F'|' -v image="${system_image}" '
            {
                gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1)
                if ($1 == image) {
                    found = 1
                }
            }
            END {
                exit found ? 0 : 1
            }'
}

if ! system_image_installed; then
    echo "System image is not installed: ${system_image}" >&2
    echo "Install it with:" >&2
    echo "  $0 --install-system-image" >&2
    echo "or:" >&2
    echo "  sdkmanager --install \"emulator\" \"${system_image}\"" >&2
    exit 1
fi

echo "ANDROID_HOME=${ANDROID_HOME}"
echo "JAVA_HOME=${JAVA_HOME}"
echo "Recreating AVD '${avd_name}' from ${system_image} using device '${device_profile}'..."

while read -r serial state; do
    if [[ "${serial}" != emulator-* || "${state}" != "device" ]]; then
        continue
    fi

    running_avd=$("${adb_bin}" -s "${serial}" emu avd name 2>/dev/null | tr -d '\r' | head -n 1 || true)

    if [[ "${running_avd}" == "${avd_name}" ]]; then
        echo "Stopping running emulator ${serial} for AVD '${avd_name}'..."
        "${adb_bin}" -s "${serial}" emu kill >/dev/null || true
        sleep 2
    fi
done < <("${adb_bin}" devices | awk 'NR > 1 { print $1, $2 }')

if "${emulator_bin}" -list-avds | grep -Fxq "${avd_name}"; then
    echo "Deleting existing AVD '${avd_name}'..."
    "${avdmanager_bin}" delete avd -n "${avd_name}" >/dev/null || true
fi

avd_root="${ANDROID_AVD_HOME:-${HOME}/.android/avd}"
avd_dir="${avd_root}/${avd_name}.avd"
avd_ini="${avd_root}/${avd_name}.ini"

if [[ -e "${avd_dir}" || -e "${avd_ini}" ]]; then
    echo "Removing leftover AVD files under ${avd_root}..."
    rm -rf "${avd_dir}" "${avd_ini}"
fi

echo "Creating AVD '${avd_name}'..."
printf 'no\n' | "${avdmanager_bin}" create avd \
    -n "${avd_name}" \
    -k "${system_image}" \
    -d "${device_profile}" \
    --force >/dev/null

config_ini="${avd_dir}/config.ini"

if [[ -f "${config_ini}" ]]; then
    if grep -q '^disk\.dataPartition\.size=' "${config_ini}"; then
        sed -i "s/^disk\\.dataPartition\\.size=.*/disk.dataPartition.size=${emulator_partition_mb}M/" "${config_ini}"
    else
        printf '\ndisk.dataPartition.size=%sM\n' "${emulator_partition_mb}" >>"${config_ini}"
    fi
else
    echo "AVD config not found after creation: ${config_ini}" >&2
    exit 1
fi

echo "Created clean AVD '${avd_name}'."
echo "Data partition size: ${emulator_partition_mb}M"
echo "Start it with:"
echo "  android/run_debug_emulator.sh"
echo "or:"
echo "  android/run_release_emulator.sh"
