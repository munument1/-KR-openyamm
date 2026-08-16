#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(CDPATH= cd -- "${script_dir}/.." && pwd)

assets_dev_dir="${repo_root}/assets_dev"
assets_dir="${repo_root}/assets"
temp_dir=$(mktemp -d)

cleanup()
{
    rm -rf "${temp_dir}"
}

trap cleanup EXIT

if ! command -v zip >/dev/null 2>&1; then
    echo "zip not found. Install the zip package first." >&2
    exit 1
fi

package_asset_root()
{
    local source_dir="$1"
    local output_zip="$2"
    local label="$3"
    local temp_zip="${temp_dir}/${label}.zip"

    if [[ ! -d "${source_dir}" ]]; then
        echo "Missing asset source directory: ${source_dir}" >&2
        exit 1
    fi

    mkdir -p "$(dirname -- "${output_zip}")"

    echo "Repacking ${label}: ${source_dir} -> ${output_zip}"
    (
        cd "${source_dir}"
        find . -mindepth 1 \
            \( -path "./_legacy" -o -path "./_legacy/*" \) -prune \
            -o -printf "%P\n" \
            | LC_ALL=C sort \
            | zip -q -X -n .ogv -@ "${temp_zip}"
    )

    mv "${temp_zip}" "${output_zip}"
    du -h "${output_zip}"
}

package_asset_root "${assets_dev_dir}/engine" "${assets_dir}/engine.zip" "engine"
package_asset_root "${assets_dev_dir}/worlds/mm6" "${assets_dir}/worlds/mm6.zip" "mm6"
package_asset_root "${assets_dev_dir}/worlds/mm7" "${assets_dir}/worlds/mm7.zip" "mm7"
package_asset_root "${assets_dev_dir}/worlds/mm8" "${assets_dir}/worlds/mm8.zip" "mm8"
package_asset_root "${assets_dev_dir}/worlds/mmmerge" "${assets_dir}/worlds/mmmerge.zip" "mmmerge"
