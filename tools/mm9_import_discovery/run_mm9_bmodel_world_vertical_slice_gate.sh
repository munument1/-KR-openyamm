#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
openyamm_binary="${1:-${repository_root}/build/game/openyamm}"
temporary_directory="$(mktemp -d)"
trap 'rm -rf "${temporary_directory}"' EXIT

cd "${repository_root}"

python3 tools/mm9_import_discovery/check_mm9_bmodel_world_package.py

run_diagnostic()
{
    local output_name="$1"
    shift
    "${openyamm_binary}" --world mm9 "$@" > "${temporary_directory}/${output_name}.txt"
    cat "${temporary_directory}/${output_name}.txt"
}

require_output()
{
    local output_name="$1"
    local expected_text="$2"
    grep -Fq "${expected_text}" "${temporary_directory}/${output_name}.txt"
}

run_diagnostic mine_load --headless-profile-map-load-full thjoradmine.odm
require_output mine_load 'outdoor actors: total=3 map_delta=2 spawn=1 textured=3 missing=0'
require_output mine_load 'Headless load profile complete: map="Thjorad Mine" file=thjoradmine.odm'

run_diagnostic city_load --headless-profile-map-load-full thjorgard.odm
require_output city_load 'outdoor actors: total=4 map_delta=3 spawn=1 textured=4 missing=0'
require_output city_load 'Headless load profile complete: map="Thjorgard" file=thjorgard.odm'

run_diagnostic mine_navigation --headless-dump-outdoor-navigation thjoradmine.odm
require_output mine_navigation 'Outdoor cooked navigation: map="thjoradmine.odm"'
require_output mine_navigation 'render_cells=57'

run_diagnostic mine_chest --headless-open-event thjoradmine.odm 32000
require_output mine_chest 'active chest #0'
require_output mine_chest 'item=1 "Iron Longsword"'

run_diagnostic city_chest --headless-open-event thjorgard.odm 32010
require_output city_chest 'active chest #0'
require_output city_chest 'item=1 "Iron Longsword"'

run_diagnostic mine_exit --headless-open-event thjoradmine.odm 32001
require_output mine_exit 'dialog title="Thjorgard"'

run_diagnostic city_exit --headless-open-event thjorgard.odm 32011
require_output city_exit 'dialog title="Thjorad Mine"'

run_diagnostic city_npc --headless-open-actor thjorgard.odm 2
require_output city_npc 'npc=1224'
require_output city_npc 'dialog title="Kira Stonepath"'

run_diagnostic linear_mechanism --headless-open-event thjoradmine.odm 30584
require_output linear_mechanism 'affected mechanisms=900584'

run_diagnostic rotating_mechanism --headless-open-event thjoradmine.odm 30589
require_output rotating_mechanism 'affected mechanisms=900589'

run_diagnostic mine_linear_save \
    --headless-verify-outdoor-save-roundtrip thjoradmine.odm 32000 30584
require_output mine_linear_save 'mechanism=900584 mechanism_open=yes geometry_restored=yes'

run_diagnostic mine_rotating_save \
    --headless-verify-outdoor-save-roundtrip thjoradmine.odm 32000 30589
require_output mine_rotating_save 'mechanism=900589 mechanism_open=yes geometry_restored=yes'

run_diagnostic city_save \
    --headless-verify-outdoor-save-roundtrip thjorgard.odm 32010 30391
require_output city_save 'mechanism=900391 mechanism_open=yes geometry_restored=yes'

run_diagnostic mine_actor --headless-simulate-actor thjoradmine.odm 0 120 0.05 -500
require_output mine_actor 'saw_walking_anim=yes'
require_output mine_actor 'saw_movement=yes'

run_diagnostic city_actor --headless-simulate-actor thjorgard.odm 0 120 0.05 -500
require_output city_actor 'saw_walking_anim=yes'
require_output city_actor 'saw_movement=yes'

echo "MM9 BModel-world vertical slices valid: maps=2"
