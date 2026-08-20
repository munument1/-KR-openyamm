#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
openyamm_binary="${1:-${repository_root}/build/game/openyamm}"
temporary_directory="$(mktemp -d)"
trap 'rm -rf "${temporary_directory}"' EXIT

cd "${repository_root}"

python3 tools/mm9_import_discovery/generate_mm9_events.py --only-map bootcamp --check-idempotent
python3 tools/mm9_import_discovery/check_mm9_bmodel_world_package.py
python3 -m unittest \
    tools.mm9_import_discovery.test_dat_bsp_parser.DatBspParserTests.test_generated_mm9_lua_registers_classic_mechanism_event_handlers \
    tools.mm9_import_discovery.test_dat_bsp_parser.DatBspParserTests.test_outdoor_buttons_and_switches_are_interactive_mechanisms

cmp assets_dev/worlds/mm9/maps/bootcamp.scene.yml \
    assets_editor_dev/worlds/mm9/maps/bootcamp.scene.yml
cmp assets_dev/worlds/mm9/maps/bootcamp_authored.scene.yml \
    assets_editor_dev/worlds/mm9/maps/bootcamp_authored.scene.yml
cmp assets_dev/worlds/mm9/events/maps/bootcamp.lua \
    assets_editor_dev/worlds/mm9/events/maps/bootcamp.lua
cmp assets_dev/worlds/mm9/events/maps/bootcamp_authored.lua \
    assets_editor_dev/worlds/mm9/events/maps/bootcamp_authored.lua

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

run_mechanism_event()
{
    local output_name="$1"
    local event_id="$2"
    local expected_mechanisms="$3"
    run_diagnostic "${output_name}" --headless-open-event bootcamp.odm "${event_id}"
    require_output "${output_name}" "affected mechanisms=${expected_mechanisms}"
}

run_diagnostic load --headless-profile-map-load-full bootcamp.odm
require_output load 'outdoor actors: total=6 map_delta=6 spawn=0 textured=6 missing=0'
ocean_animation_output='Headless surface animation: texture="oceabym7ai" frames=19 length_ticks=162 '
ocean_animation_output+='first_transition_ticks=9 frame_before=0 frame_after=1'
require_output load "${ocean_animation_output}"
water_animation_output='Headless surface animation: texture="wate1xksqp" frames=10 length_ticks=85 '
water_animation_output+='first_transition_ticks=9 frame_before=0 frame_after=1'
require_output load "${water_animation_output}"
require_output load 'Headless load profile complete: map="Ravensford" file=bootcamp.odm'

run_diagnostic navigation --headless-dump-outdoor-navigation bootcamp.odm
require_output navigation 'Outdoor cooked navigation: map="bootcamp.odm"'
require_output navigation 'cooked_facets=22924'
require_output navigation 'dynamic_facets=201'
require_output navigation 'render_dynamic_faces=245'
require_output navigation 'render_translucent_faces=443'
require_output navigation 'render_cells=56'

run_mechanism_event monster_door_1 30005 '900005,900006'
require_output monster_door_1 'open-away mechanism=900005 direction=-1'
require_output monster_door_1 'open-away mechanism=900006 direction=1'
run_mechanism_event monster_door_2 30006 '900006,900005'
run_mechanism_event bar_flap_1 30050 '900050,900051'
run_mechanism_event bar_flap_2 30051 '900051,900050'
run_mechanism_event rotating_door_0 30066 '900066,900067'
run_mechanism_event rotating_door_1 30067 '900067,900066'
run_mechanism_event new_house_door_1 30167 '900167,900168'
run_mechanism_event new_house_door_0 30168 '900168,900167'
run_mechanism_event training_door_1 30178 '900178,900179'
run_mechanism_event training_door_0 30179 '900179,900178'
run_mechanism_event rotating_door_2 30180 '900180'
run_mechanism_event switch_lever_0 30197 '900197'
run_mechanism_event portcullis_lever 30199 '900199'
run_mechanism_event timer_lever_03a 30203 '900203'
run_mechanism_event button_1 30204 '900204'
run_mechanism_event sliding_door_0 30565 '900565,900566'
run_mechanism_event sliding_door_1 30566 '900566,900565'
run_mechanism_event sliding_door_2 30567 '900567,900568'
run_mechanism_event sliding_door_3 30568 '900568,900567'
run_mechanism_event museum_door_2 30569 '900569,900570'
run_mechanism_event museum_door_3 30570 '900570,900569'
run_mechanism_event museum_door_0 30571 '900571,900572'
run_mechanism_event museum_door_1 30572 '900572,900571'
run_mechanism_event store_door_left 30587 '900587,900589'
run_mechanism_event store_door_right 30589 '900589,900587'

run_diagnostic door_passage \
    --headless-verify-outdoor-mechanism-passage bootcamp.odm 900565
require_output door_passage 'name="Door0"'
require_output door_passage 'mechanism=900565 event=30565'
require_output door_passage 'closed_blocked=yes open_passed=yes'

run_diagnostic fight_switch --headless-open-event bootcamp.odm 30563
require_output fight_switch 'actor 0 invisible=no hostile=no'
require_output fight_switch 'actor 1 invisible=no hostile=no'
require_output fight_switch 'affected mechanisms=900563'
require_output fight_switch 'status="The Bootcamp fight begins."'

run_diagnostic chest_switch --headless-open-event bootcamp.odm 30564
require_output chest_switch 'affected mechanisms=900564'
require_output chest_switch 'status="The Bootcamp treasure chests are ready."'

run_diagnostic switch_reset --headless-open-event bootcamp.odm 30563 0.5
require_output switch_reset 'mechanism 900563 state=closed moving=no distance=0'
require_output switch_reset 'mechanism 900564 state=closed moving=no distance=0'

for chest_id in 0 1 2 3 4
do
    event_id=$((32000 + chest_id))
    run_diagnostic "chest_${chest_id}" --headless-open-event bootcamp.odm "${event_id}"
    require_output "chest_${chest_id}" "active chest #${chest_id}"
    require_output "chest_${chest_id}" 'entries=1'
done

run_diagnostic guide --headless-open-actor bootcamp.odm 2
require_output guide 'name="Ravensford Guide" npc=1224'
require_output guide 'dialog title="Ravensford Guide"'

run_diagnostic actor_pursuit \
    --headless-simulate-actor bootcamp.odm 0 100 0.1 3000 30563
require_output actor_pursuit 'pre_event=30563'
require_output actor_pursuit 'saw_walking_anim=yes'
require_output actor_pursuit 'saw_movement=yes'
require_output actor_pursuit 'saw_actor_target=yes'
require_output actor_pursuit 'target_actor=1'
require_output actor_pursuit 'target_monster=414'

run_diagnostic actor_counterattack \
    --headless-simulate-actor bootcamp.odm 1 100 0.1 3000 30563
require_output actor_counterattack 'pre_event=30563'
require_output actor_counterattack 'saw_walking_anim=yes'
require_output actor_counterattack 'saw_movement=yes'
require_output actor_counterattack 'saw_actor_target=yes'
require_output actor_counterattack 'target_actor=0'
require_output actor_counterattack 'target_monster=413'

run_diagnostic hostile_troglodyte \
    --headless-simulate-actor bootcamp.odm 3 100 0.1 3000 30563
require_output hostile_troglodyte 'actor=3 start_pos=(34588,6972,1264) pre_event=30563 start_hostile=yes'
require_output hostile_troglodyte 'saw_walking_anim=yes'
require_output hostile_troglodyte 'saw_movement=yes'

run_diagnostic exit --headless-open-event bootcamp.odm 32010
require_output exit 'dialog title="Isle of Ashes"'

run_diagnostic rotating_save_roundtrip \
    --headless-verify-outdoor-save-roundtrip bootcamp.odm 32000 30180
require_output rotating_save_roundtrip 'actor_dead=yes chest=0 chest_item=3 mechanism=900180'
require_output rotating_save_roundtrip 'mechanism_open=yes geometry_restored=yes'

run_diagnostic linear_save_roundtrip \
    --headless-verify-outdoor-save-roundtrip bootcamp.odm 32000 30563
require_output linear_save_roundtrip 'actor_dead=yes chest=0 chest_item=3 mechanism=900563'
require_output linear_save_roundtrip 'mechanism_open=yes geometry_restored=yes'

echo "MM9 Bootcamp playable slice valid: supported_mechanisms=27 chests=5 actors=6"
