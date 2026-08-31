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
    tools.mm9_import_discovery.test_mm9_scr_to_lua \
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
require_output load 'outdoor actors: total=11 map_delta=11 spawn=0 textured=11 missing=0'
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

run_diagnostic world_item_floor --headless-verify-outdoor-world-item-floor bootcamp.odm
require_output world_item_floor \
    'Outdoor world-item floor valid: map="bootcamp.odm" item_z=1291 support_z=1290 terrain_z=0 settled=yes'

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
require_output fight_switch 'actor 9 invisible=no hostile=no'
require_output fight_switch 'actor 10 invisible=no hostile=no'
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

run_diagnostic old_man --headless-open-actor bootcamp.odm 0
require_output old_man 'name="Old Man" npc=0 mm9Rude=436 mm9Object=207 yawUnits=0 immobile=yes'
require_output old_man 'face_toward_party=yes'
require_output old_man 'dialog title="Old Man"'

run_diagnostic old_man_found_player --headless-open-event bootcamp.odm 56207
require_output old_man_found_player 'pending MM9 RUDE=436'
require_output old_man_found_player 'dialog title="Old Man"'
require_output old_man_found_player "We'd like to start our training."

run_diagnostic tavern_keeper --headless-open-actor bootcamp.odm 1
require_output tavern_keeper 'name="Thorkatla the Indiscreet" npc=0 mm9Rude=101 mm9Object=209 yawUnits=511 immobile=yes'
require_output tavern_keeper 'dialog title="Thorkatla the Indiscreet"'

run_diagnostic shopkeeper --headless-open-actor bootcamp.odm 2
require_output shopkeeper "name=\"Dearbhorgaill A'Washadi\" npc=0 mm9Rude=204 mm9Object=210 yawUnits=1542 immobile=yes"
require_output shopkeeper "dialog title=\"Dearbhorgaill A'Washadi\""

run_diagnostic banker --headless-open-actor bootcamp.odm 3
require_output banker "name=\"Fiachna A'Lanth\" npc=0 mm9Rude=206 mm9Object=211 yawUnits=1021 immobile=yes"
require_output banker "dialog title=\"Fiachna A'Lanth\""

run_diagnostic dialogue_actor_stationary \
    --headless-simulate-actor bootcamp.odm 0 30 0.1 3000
require_output dialogue_actor_stationary 'actor=0 start_pos=(25969,-7045,1413)'
require_output dialogue_actor_stationary 'saw_walking_anim=no saw_movement=no'

run_diagnostic actor_pursuit \
    --headless-simulate-actor bootcamp.odm 9 100 0.1 3000 30563
require_output actor_pursuit 'pre_event=30563'
require_output actor_pursuit 'saw_walking_anim=yes'
require_output actor_pursuit 'saw_movement=yes'
require_output actor_pursuit 'saw_actor_target=yes'
require_output actor_pursuit 'start_hostile=no'
require_output actor_pursuit 'target_actor=10'
require_output actor_pursuit 'target_monster=9230'

run_diagnostic actor_counterattack \
    --headless-simulate-actor bootcamp.odm 10 100 0.1 3000 30563
require_output actor_counterattack 'pre_event=30563'
require_output actor_counterattack 'saw_walking_anim=yes'
require_output actor_counterattack 'saw_movement=yes'
require_output actor_counterattack 'saw_actor_target=yes'
require_output actor_counterattack 'start_hostile=no'
require_output actor_counterattack 'target_actor=9'
require_output actor_counterattack 'target_monster=9158'

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

echo "MM9 Bootcamp playable slice valid: supported_mechanisms=27 chests=5 actors=11"
