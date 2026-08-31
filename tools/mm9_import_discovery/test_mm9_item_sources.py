#!/usr/bin/env python3
from __future__ import annotations

import struct
import sys
import unittest
from dataclasses import dataclass
from pathlib import Path
from typing import Any


TOOLS_DIR = Path(__file__).resolve().parent
REPOSITORY_ROOT = TOOLS_DIR.parent.parent
sys.path.insert(0, str(TOOLS_DIR))

from mm9_item_sources import (  # noqa: E402
    Mm9ItemIdMap,
    Mm9ItemSourceError,
    build_mm9_item_source_manifest,
    integral_property,
    mm9_qbit,
    parse_spawn_properties,
)
from transcode_mm9_dat_to_odm import read_dat_world  # noqa: E402


@dataclass
class FakeProperty:
    name: str
    value: Any
    code: int = 5
    raw_data: bytes = b""
    decoded: bool = True


@dataclass
class FakeObject:
    name: str
    properties: list[FakeProperty]


class Mm9ItemSourceUnitTests(unittest.TestCase):
    def test_integral_property_decodes_mm9_float_bit_pattern(self) -> None:
        raw_data = struct.pack("<f", 75.0)
        raw_value = struct.unpack("<I", raw_data)[0]
        source = FakeObject("BonePile", [FakeProperty("DiseaseChance", raw_value, 6, raw_data)])

        self.assertEqual(integral_property(source, "DiseaseChance"), 75)

    def test_qbit_translation_uses_global_mm9_range(self) -> None:
        self.assertEqual(mm9_qbit(128), 90128)
        with self.assertRaises(Mm9ItemSourceError):
            mm9_qbit(-1)

    def test_spawn_object_parser_preserves_all_treasure_fields(self) -> None:
        class_name, values = parse_spawn_properties(
            "TreasureBag TreasureLevel 4;TreasureType0_7 3;Gold 25;Item1 371;Random 1",
            "test spawn",
        )

        self.assertEqual(class_name, "TreasureBag")
        self.assertEqual(values, {
            "treasurelevel": "4",
            "treasuretype0_7": "3",
            "gold": "25",
            "item1": "371",
            "random": "1",
        })


class Mm9ItemSourceCensusTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.item_ids = Mm9ItemIdMap.load(
            REPOSITORY_ROOT / "assets_dev/worlds/mm9/state/item_ids.yml"
        )
        world_root = REPOSITORY_ROOT / "mm9/extracted/WORLDS/WORLDS"
        cls.manifests = []
        cls.object_count = 0
        for dat_path in sorted(world_root.glob("*.dat")):
            dat_world = read_dat_world(dat_path)
            cls.object_count += len(dat_world.objects)
            cls.manifests.append(build_mm9_item_source_manifest(
                dat_path.stem,
                dat_world.objects,
                cls.item_ids,
                1.0,
            ))

    def test_shipped_map_native_item_source_census(self) -> None:
        containers = [source for manifest in self.manifests for source in manifest.loot_containers]
        bone_piles = [source for manifest in self.manifests for source in manifest.searchable_loot_props]
        actor_loot = [source for manifest in self.manifests for source in manifest.actor_loot_overrides]
        spawned = [source for manifest in self.manifests for source in manifest.spawned_loot_containers]
        mechanisms = [source for manifest in self.manifests for source in manifest.persistent_item_mechanisms]
        world_items = [source for manifest in self.manifests for source in manifest.world_items]
        barrels = [source for manifest in self.manifests for source in manifest.barrels]

        self.assertEqual(len(self.manifests), 45)
        self.assertEqual(self.object_count, 32288)
        self.assertEqual(sum(source.kind == "chest" for source in containers), 163)
        self.assertEqual(sum(source.kind == "treasure_bag" for source in containers), 4)
        self.assertEqual(len(bone_piles), 77)
        self.assertEqual(len(spawned), 22)
        self.assertEqual(len(mechanisms), 33)
        self.assertEqual(sum(source.procedural_death_loot for source in actor_loot), 1911)
        self.assertEqual(len(world_items), 67)
        self.assertEqual(sum(bool(source.on_pickup_event) for source in world_items), 11)
        self.assertEqual(len(barrels), 55)
        self.assertEqual(len({source.provenance.source_id for source in barrels}), 55)
        self.assertTrue(all(30000 <= source.interaction_event_id <= 65535 for source in barrels))

    def test_bone_piles_and_bags_keep_distinct_native_semantics(self) -> None:
        containers = [source for manifest in self.manifests for source in manifest.loot_containers]
        bone_piles = [source for manifest in self.manifests for source in manifest.searchable_loot_props]
        authored_bags = [source for source in containers if source.kind == "treasure_bag"]

        self.assertEqual({source.random_treasure_level for source in bone_piles}, {0, 1, 2, 3, 4})
        self.assertEqual({source.disease_chance for source in bone_piles}, {0, 50, 75})
        self.assertEqual({source.source_disease_power for source in bone_piles}, {0, 1})
        self.assertTrue(all(source.loot_rolls == 1 for source in bone_piles))
        self.assertTrue(all(source.keep_visual_after_search for source in bone_piles))
        self.assertTrue(all(source.remove_when_empty for source in authored_bags))
        self.assertTrue(all(source.should_repopulate for source in authored_bags))

    def test_container_ids_are_dense_and_source_sorted_per_map(self) -> None:
        for manifest in self.manifests:
            containers = manifest.loot_containers
            self.assertEqual([source.container_id for source in containers], list(range(len(containers))))
            self.assertEqual(
                [source.provenance.source_object_index for source in containers],
                sorted(source.provenance.source_object_index for source in containers),
            )

    def test_world_items_and_authored_bags_are_excluded_from_baked_geometry(self) -> None:
        excluded = {
            (manifest.map_id, object_index)
            for manifest in self.manifests
            for object_index in manifest.excluded_baked_object_indices()
        }
        world_items = {
            (manifest.map_id, source.provenance.source_object_index)
            for manifest in self.manifests
            for source in manifest.world_items
        }
        authored_bags = {
            ("inventastorca", 394),
            ("inventastorca", 395),
            ("sturmfordcity", 1392),
            ("sturmfordcity", 1393),
        }
        self.assertEqual(excluded, world_items | authored_bags)
        self.assertEqual(len(excluded), 71)

    def test_drangheim_promotion_pickups_use_declarative_qbit_policies(self) -> None:
        manifest = next(manifest for manifest in self.manifests if manifest.map_id == "drangheim")
        by_index = {source.provenance.source_object_index: source for source in manifest.world_items}

        self.assertEqual(by_index[26].item_id, 10371)
        self.assertEqual(by_index[26].required_qbits, (90128,))
        self.assertEqual(by_index[26].forbidden_qbits, (90130,))
        self.assertEqual(by_index[26].set_qbits, (90130,))
        self.assertEqual(by_index[25].set_qbits, (90131,))
        self.assertEqual(by_index[27].set_qbits, (90132,))
        self.assertEqual(by_index[28].item_id, 419)
        self.assertEqual(
            tuple((grant.raw_mm9_item_id, grant.item_id) for grant in by_index[28].grant_items),
            ((347, 419), (560, 10560)),
        )

    def test_tasar_skillbook_props_preserve_source_random_and_blade_semantics(self) -> None:
        manifest = next(manifest for manifest in self.manifests if manifest.map_id == "tasaracademy")
        by_index = {source.provenance.source_object_index: source for source in manifest.world_items}

        self.assertEqual(set(by_index), {692, 693, 694, 695, 697, 700, 701})
        for object_index in (692, 693, 694, 700, 701):
            self.assertEqual(by_index[object_index].random_item_pool, tuple(range(10285, 10307)))
            self.assertEqual(by_index[object_index].item_id, 0)
        self.assertEqual(by_index[695].raw_primary_item_id, 285)
        self.assertEqual(by_index[695].item_id, 10285)
        self.assertEqual(by_index[695].provenance.script_name.casefold(), "skillbook.scr")
        self.assertEqual(by_index[695].provenance.script_params, "Blade")

    def test_bootcamp_spell_scroll_replacements_preserve_authored_positions(self) -> None:
        manifest = next(manifest for manifest in self.manifests if manifest.map_id == "bootcamp")
        by_index = {source.provenance.source_object_index: source for source in manifest.world_items}
        expected = {
            218: (548, 379, (9832.0, 562.5, -2424.0)),
            219: (523, 311, (9860.0, 562.5, -2444.0)),
            220: (511, 317, (9884.0, 562.5, -2424.0)),
            223: (532, 306, (10412.0, 562.5, -2420.0)),
            224: (555, 334, (10428.0, 562.5, -2444.0)),
            225: (547, 314, (10452.0, 562.5, -2424.0)),
        }

        for object_index, (raw_item_id, item_id, position) in expected.items():
            source = by_index[object_index]
            self.assertEqual(source.raw_primary_item_id, raw_item_id)
            self.assertEqual(source.item_id, item_id)
            self.assertEqual(source.provenance.source_position_lt, position)
            self.assertEqual(source.on_pickup_event, "")
            self.assertTrue(source.consume_on_success)

    def test_known_broken_item_references_remain_visible(self) -> None:
        unresolved = [
            source
            for manifest in self.manifests
            for source in manifest.unresolved_item_references
        ]
        self.assertEqual(
            {source.raw_mm9_item_id for source in unresolved},
            {
                254, 318, 319, 320, 327, 332, 333, 334, 335, 346, 349, 350, 386,
                415, 420, 421, 422, 510, 518, 519, 530, 538, 552, 553, 554,
            },
        )
        self.assertEqual(len(unresolved), 25)

    def test_wizardslab_missing_item_is_reviewed_without_fabricating_a_pickup(self) -> None:
        manifest = next(manifest for manifest in self.manifests if manifest.map_id == "wizardslab")

        self.assertEqual(
            {source.provenance.source_object_index for source in manifest.world_items},
            {877},
        )
        unresolved = next(
            source
            for source in manifest.unresolved_item_references
            if source.source_object_index == 592
        )
        self.assertEqual(unresolved.raw_mm9_item_id, 386)
        self.assertFalse(unresolved.blocks_generation)
        self.assertNotIn(592, manifest.excluded_baked_object_indices())
        manifest.require_resolved_item_references()

    def test_all_imported_fixed_container_item_slots_have_canonical_ids(self) -> None:
        fixed_items = [
            item
            for manifest in self.manifests
            for source in (*manifest.loot_containers, *manifest.spawned_loot_containers)
            for item in source.fixed_items
        ]

        self.assertEqual(len(fixed_items), 30)
        self.assertTrue(all(item.raw_mm9_item_id > 0 for item in fixed_items))
        self.assertTrue(all(item.item_id > 0 for item in fixed_items))


if __name__ == "__main__":
    unittest.main()
