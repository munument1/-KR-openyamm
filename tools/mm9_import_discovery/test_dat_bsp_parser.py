#!/usr/bin/env python3
from __future__ import annotations

import struct
import sys
import tempfile
import unittest
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from convert_abc_model import (
    AbcModel,
    AnimBinding,
    Face,
    FaceVertex,
    Lod,
    ModelAnimation,
    NodeInfo,
    Piece,
    SocketInfo,
    Transform,
    Vertex,
    scale_abc_model,
)
from transcode_mm9_dat_to_blv import (
    build_blv_mechanisms,
    build_indoor_mechanism_face_override_lines,
    build_leaf_grid_layout,
    build_spatial_grid_layout,
    metadata_light_radius,
)
from generate_mm9_events import (
    find_source_sound_path,
    load_scene_classic_event_face_ids,
    map_lua_text,
    synthetic_mm9_sound_bytes,
)
from classify_mm9_maps import MapMetrics, classify_metrics
from transcode_mm9_dat_to_odm import (
    BinaryReader,
    DatWorld,
    FACE_ATTRIBUTE_ANIMATED,
    FACE_ATTRIBUTE_CLICKABLE,
    FACE_ATTRIBUTE_FLUID,
    FACE_ATTRIBUTE_HAS_HINT,
    FACE_ATTRIBUTE_INVISIBLE,
    FACE_ATTRIBUTE_SECRET,
    FACE_ATTRIBUTE_UNTOUCHABLE,
    LT_SURFACE_FLAG_INVISIBLE,
    DiskVert,
    LtFloorTriangle,
    ObjectProperty,
    OdmBModel,
    OdmEntity,
    OdmFace,
    OdmVertex,
    PBlockTableSummary,
    Plane,
    Poly,
    Surface,
    UserPortal,
    WorldBsp,
    WorldInfo,
    WorldObject,
    WorldLeaf,
    abc_static_model_half_dims_lt,
    abc_static_model_translation_lt,
    bake_abc_model_instance,
    build_navigation_bytes,
    build_navigation_records,
    build_render_data_bytes,
    build_sprite_animation_index,
    build_surface_animation_lines,
    build_texture_size_index,
    build_mechanism_lines,
    build_outdoor_mechanism_interactive_face_lines,
    build_mm9_party_start_point_lines,
    build_classic_party_start_entities,
    build_mm9_light_lines,
    build_floor_support_triangles,
    classify_face_attributes,
    classify_face_role,
    decode_mm9_v66_lightmap,
    export_mm9_lights,
    export_mm9_party_start_points,
    floor_y_near_position_lt,
    is_plant_foliage_texture,
    is_plant_model_source,
    is_rail_helper_texture,
    is_green_screen_helper_texture,
    is_skipped_world_model_name,
    should_skip_face_role,
    mechanism_event_id,
    navigation_mechanisms_by_bmodel,
    move_position_to_floor_lt,
    parse_spr_frame_paths,
    read_world_objects,
    read_leaf,
    read_node,
    read_user_portal,
    resolve_sprite_animation_frames,
    transform_model_vertex_to_odm,
    transcode_geometry,
    uv_float_to_i16,
    write_scene_yml as write_odm_scene_yml,
)


def dummy_poly() -> Poly:
    return Poly(
        center=(0.0, 0.0, 0.0),
        lightmap_width=0,
        lightmap_height=0,
        unknown_flag=0,
        unknown_list=[],
        surface_index=0,
        plane_index=0,
        disk_verts=[],
    )


def dummy_world_bsp(name: str, polies: list[Poly] | None = None, leaves: list[WorldLeaf] | None = None) -> WorldBsp:
    return WorldBsp(
        name=name,
        textures=[],
        points=[],
        point_normals=[],
        planes=[],
        surfaces=[],
        polies=polies or [],
        leaves=leaves or [],
        nodes=[],
        user_portals=[],
        min_box=(0.0, 0.0, 0.0),
        max_box=(0.0, 0.0, 0.0),
        world_translation=(0.0, 0.0, 0.0),
        root_node_index=0,
        section_count=0,
        counts={},
        pblock_table=PBlockTableSummary(
            dim_a=0,
            dim_b=0,
            dim_c=0,
            min_box=(0.0, 0.0, 0.0),
            max_box=(0.0, 0.0, 0.0),
            record_count=0,
        ),
    )


def object_property(name: str, value: object) -> ObjectProperty:
    return ObjectProperty(
        name=name,
        code=0,
        flags=0,
        declared_data_length=0,
        raw_data=b"",
        value=value,
    )


def dummy_dat_world(objects: list[WorldObject]) -> DatWorld:
    return DatWorld(
        path=Path("dummy.dat"),
        version=66,
        object_data_pos=0,
        render_data_pos=0,
        world_model_pos=0,
        world_info=WorldInfo(
            properties="",
            light_map_grid_size=0.0,
            extents_min=(0.0, 0.0, 0.0),
            extents_max=(0.0, 0.0, 0.0),
        ),
        world_models=[],
        objects=objects,
    )


class DatBspParserTests(unittest.TestCase):
    def test_mm9_v66_lightmap_decoder_expands_rgb555_runs(self) -> None:
        encoded = struct.pack("<HHB", 0x7C00, 0x83E0, 3)

        self.assertEqual(
            decode_mm9_v66_lightmap(encoded),
            [0xFFFF0000, 0xFF00FF00, 0xFF00FF00, 0xFF00FF00],
        )

    def test_bootcamp_classifies_as_outdoor_despite_portal_helpers(self) -> None:
        recommendation, confidence, reason = classify_metrics(MapMetrics(
            map_id="bootcamp",
            dat_file="BOOTCAMP.dat",
            current_export="blv+bsp.yml",
            model_count=168,
            object_count=591,
            source_polies=16450,
            visible_candidate_polies=5018,
            helper_polies=10555,
            terrain_polies=4080,
            sky_water_polies=0,
            invisible_polies=0,
            visbsp_polies=2015,
            physicsbsp_polies=8540,
            visbsp_leaves=937,
            visbsp_leaf_entries=0,
            user_portals=10,
            total_leaves=0,
            total_leaf_entries=0,
            largest_model_name="PhysicsBSP",
            largest_model_polies=8540,
            recommendation="",
            confidence="",
            reason="",
        ))

        self.assertEqual(recommendation, "outdoor_like")
        self.assertEqual(confidence, "high")
        self.assertIn("known MM9 exterior", reason)

    def test_physics_bsp_is_hidden_but_collidable(self) -> None:
        attributes = classify_face_attributes("PhysicsBSP", "LEVELTEXTURES/MISC/INVISIBLE", LT_SURFACE_FLAG_INVISIBLE)

        self.assertTrue(attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertFalse(attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(
            classify_face_role("PhysicsBSP", "LEVELTEXTURES/MISC/INVISIBLE", LT_SURFACE_FLAG_INVISIBLE).collision_role,
            "physics_hull",
        )

    def test_baked_model_nan_uv_sanitizes_to_zero(self) -> None:
        self.assertEqual(uv_float_to_i16(float("nan"), 256), 0)
        self.assertEqual(uv_float_to_i16(float("inf"), 256), 0)
        self.assertEqual(uv_float_to_i16(-float("inf"), 256), 0)

    def test_physics_bsp_with_visible_texture_renders_and_collides(self) -> None:
        role = classify_face_role("PhysicsBSP", "TEXTURES\\A2Thjorgaard\\walls\\thjorgatewall.dtx", 0)

        self.assertFalse(role.attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertFalse(role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(role.collision_role, "physics_hull")
        self.assertEqual(role.render_role, "visible")

    def test_vis_bsp_and_ai_helpers_are_hidden_and_untouchable(self) -> None:
        vis_attributes = classify_face_attributes("VisBSP", "STONE", 0)
        ai_attributes = classify_face_attributes("AITrk01", "STONE", 0)

        self.assertTrue(is_skipped_world_model_name("VisBSP"))
        self.assertTrue(vis_attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertTrue(vis_attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertTrue(ai_attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertTrue(ai_attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(classify_face_role("VisBSP", "STONE", 0).collision_role, "visibility_helper")

    def test_mm9_navigation_helpers_keep_ai_barriers_for_cooked_navigation(self) -> None:
        self.assertTrue(is_skipped_world_model_name("AITrk47"))
        self.assertFalse(is_skipped_world_model_name("AIBarrier3"))
        barrier_role = classify_face_role("AIBarrier3", "STONE", 0)
        self.assertEqual(barrier_role.collision_role, "ai_barrier")
        self.assertTrue(barrier_role.attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertTrue(barrier_role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertTrue(is_rail_helper_texture("RAIL.dtx"))
        self.assertTrue(is_rail_helper_texture("TEXTURES\\LevelTextures\\Misc\\RAIL.dtx"))

    def test_mm9_green_screen_helper_faces_are_skipped_from_classic_export(self) -> None:
        self.assertTrue(is_green_screen_helper_texture("greenscreen.dtx"))
        self.assertTrue(is_green_screen_helper_texture("TEXTURES\\LevelTextures\\Misc\\greenscreen.dtx"))
        self.assertFalse(is_green_screen_helper_texture("TEXTURES\\A2Thjorgaard\\walls\\thjorgatewall.dtx"))

    def test_mm9_skybox_world_models_are_skipped_from_classic_export(self) -> None:
        self.assertTrue(is_skipped_world_model_name("TOD_Sky0"))
        self.assertTrue(is_skipped_world_model_name("SkyBox0"))
        self.assertFalse(is_skipped_world_model_name("SkyBridge"))

    def test_invisible_world_faces_are_hidden_but_collidable(self) -> None:
        attributes = classify_face_attributes("CastleWall", "LEVELTEXTURES/MISC/INVISIBLE", 0)

        self.assertTrue(attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertFalse(attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(
            classify_face_role("CastleWall", "LEVELTEXTURES/MISC/INVISIBLE", 0).collision_role,
            "invisible_collision",
        )

    def test_perception_brushes_are_secret_faces(self) -> None:
        role = classify_face_role("PerceptionBrush7", "LEVELTEXTURES/MISC/INVISIBLE", LT_SURFACE_FLAG_INVISIBLE)

        self.assertTrue(role.attributes & FACE_ATTRIBUTE_SECRET)
        self.assertTrue(role.attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertFalse(role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(role.collision_role, "secret_perception")

    def test_sprite_water_faces_are_visible_fluid(self) -> None:
        role = classify_face_role("Ocean", "Sprites\\Water\\Ocean4.spr", 0)

        self.assertTrue(role.attributes & FACE_ATTRIBUTE_FLUID)
        self.assertTrue(role.attributes & FACE_ATTRIBUTE_ANIMATED)
        self.assertFalse(role.attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertFalse(role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(role.collision_role, "water_surface")
        self.assertEqual(role.render_role, "visible")

    def test_water_marker_faces_stay_hidden(self) -> None:
        role = classify_face_role("BlueWater2", "TEXTURES\\LevelTextures\\Terrain\\WaterMarker.dtx", 0)

        self.assertTrue(role.attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertTrue(role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(role.collision_role, "water_marker")
        self.assertTrue(should_skip_face_role(role))

    def test_blue_water_helpers_are_skipped_even_when_surface_is_invisible(self) -> None:
        role = classify_face_role("BlueWater0", "TEXTURES\\LevelTextures\\Misc\\Invisible.dtx", LT_SURFACE_FLAG_INVISIBLE)

        self.assertTrue(role.attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertTrue(role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(role.collision_role, "water_helper")
        self.assertTrue(should_skip_face_role(role))

    def test_sky_marker_faces_are_skipped_from_classic_export(self) -> None:
        role = classify_face_role("PhysicsBSP", "TEXTURES\\Skybox\\SkyMarker.dtx", 0)

        self.assertTrue(role.attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertTrue(role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(role.collision_role, "sky_marker")
        self.assertTrue(should_skip_face_role(role))

    def test_tree_foliage_renders_without_collision_but_bark_collides(self) -> None:
        branch_role = classify_face_role("Tree001", "skins/props/PlantsandTrees/TreeBranch5.dtx", 0)
        bark_role = classify_face_role("Tree001", "skins/props/PlantsandTrees/TreeBark3.dtx", 0)

        self.assertTrue(is_plant_foliage_texture("skins/props/PlantsandTrees/TreeBranch5.dtx"))
        self.assertTrue(branch_role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertFalse(branch_role.attributes & FACE_ATTRIBUTE_INVISIBLE)
        self.assertEqual(branch_role.collision_role, "visual_non_collision")
        self.assertEqual(branch_role.render_role, "visible")
        self.assertFalse(is_plant_foliage_texture("skins/props/PlantsandTrees/TreeBark3.dtx"))
        self.assertFalse(bark_role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(bark_role.collision_role, "world_geometry")

    def test_baked_plant_model_sources_can_split_bark_from_foliage(self) -> None:
        self.assertTrue(is_plant_model_source("models/props/PlantsandTrees/Tree05.abc"))
        self.assertTrue(is_plant_model_source("Models\\Props\\PlantsandTrees\\Bush01.abc"))
        self.assertFalse(is_plant_model_source("models/props/Furniture/Table01.abc"))

        bark_role = classify_face_role(
            "MM9_static_prop_413_Prop6",
            "skins/props/PlantsandTrees/TreeBark3.dtx",
            0,
        )
        branch_role = classify_face_role(
            "MM9_static_prop_413_Prop6",
            "skins/props/PlantsandTrees/TreeBranch4.dtx",
            0,
        )

        self.assertFalse(bark_role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(bark_role.collision_role, "world_geometry")
        self.assertTrue(branch_role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE)
        self.assertEqual(branch_role.collision_role, "visual_non_collision")

    def test_mm9_light_defaults_match_lithtech_object_runtime(self) -> None:
        light_object = WorldObject(
            name="Light",
            data_length=0,
            properties=[
                object_property("Name", "TorchLight"),
                object_property("Pos", [10.0, 20.0, 30.0]),
                object_property("LightRadius", 100.0),
                object_property("LightColor", [20, 40, 80]),
            ],
        )

        lights, stats = export_mm9_lights(dummy_dat_world([light_object]), 2.0)

        self.assertEqual(stats["light_objects"], 1)
        self.assertEqual(len(lights), 1)
        self.assertEqual(lights[0].position, (20, 60, 40))
        self.assertEqual(lights[0].radius, 200)
        self.assertTrue(lights[0].light_objects)
        self.assertTrue(lights[0].fast_light_objects)
        self.assertFalse(lights[0].static_object_light_eligible)

    def test_mm9_static_light_eligibility_requires_slow_object_light(self) -> None:
        light_object = WorldObject(
            name="Light",
            data_length=0,
            properties=[
                object_property("Pos", [0.0, 0.0, 0.0]),
                object_property("FastLightObjects", 0),
                object_property("LightColor", [200, 100, 50]),
                object_property("BrightScale", 0.5),
            ],
        )

        lights, stats = export_mm9_lights(dummy_dat_world([light_object]), 1.0)
        light_lines = build_mm9_light_lines(lights)

        self.assertEqual(stats["light_static_object_eligible"], 1)
        self.assertTrue(lights[0].static_object_light_eligible)
        self.assertEqual(lights[0].effective_color, (100, 50, 25))
        self.assertIn("    static_object_light_eligible: true", light_lines)

    def test_blv_static_light_radius_is_clamped_to_metadata_int16(self) -> None:
        self.assertEqual(metadata_light_radius(38400), 32767)
        self.assertEqual(metadata_light_radius("nan"), 0)

    def test_mm9_party_start_points_export_classic_pose(self) -> None:
        start_object = WorldObject(
            name="StartPoint",
            data_length=0,
            properties=[
                object_property("Name", "StartPointTerrain"),
                object_property("Pos", [-3136.0, 88.0, 1280.0]),
                object_property("Rotation", [0.0, 0.8726646304130554, 0.0, 0.0]),
                object_property("TeamNbr", 0),
                object_property("PlayerNbr", 0),
                object_property("MovePlayerToFloor", 1),
            ],
        )

        starts, stats = export_mm9_party_start_points(dummy_dat_world([start_object]), 2.56)
        start_lines = build_mm9_party_start_point_lines(starts)

        self.assertEqual(stats["party_start_points"], 1)
        self.assertEqual(starts[0].position, (-8028, 3277, 225))
        self.assertEqual(starts[0].direction_yaw_units, 1764)
        self.assertTrue(starts[0].move_player_to_floor)
        self.assertIn("    source_name: \"StartPointTerrain\"", start_lines)
        self.assertIn("    position: {x: -8028, y: 3277, z: 225}", start_lines)

    def test_mm9_party_start_points_emit_classic_party_start_entity(self) -> None:
        first_start = WorldObject(
            name="StartPoint",
            data_length=0,
            properties=[
                object_property("Name", "DockExit"),
                object_property("Pos", [1.0, 2.0, 3.0]),
                object_property("Rotation", [0.0, 0.0, 0.0, 0.0]),
            ],
        )
        default_start = WorldObject(
            name="StartPoint",
            data_length=0,
            properties=[
                object_property("Name", "StartPoint0"),
                object_property("Pos", [-10.0, 20.0, 30.0]),
                object_property("Rotation", [0.0, 3.1415927, 0.0, 0.0]),
            ],
        )

        starts, _ = export_mm9_party_start_points(dummy_dat_world([first_start, default_start]), 2.56)
        entities = build_classic_party_start_entities(starts)

        self.assertEqual(len(entities), 1)
        self.assertEqual(entities[0].name, "party start")
        self.assertEqual((entities[0].x, entities[0].y, entities[0].z), (-26, 77, 51))
        self.assertEqual(entities[0].facing, 180)

    def test_transcode_geometry_preserves_source_ngon_faces(self) -> None:
        quad_poly = Poly(
            center=(0.5, 0.0, 0.5),
            lightmap_width=0,
            lightmap_height=0,
            unknown_flag=0,
            unknown_list=[],
            surface_index=0,
            plane_index=0,
            disk_verts=[
                DiskVert(0, b""),
                DiskVert(1, b""),
                DiskVert(2, b""),
                DiskVert(3, b""),
            ],
        )
        model = dummy_world_bsp("Quad", [quad_poly])
        model.textures = ["LEVELTEXTURES/STONE/QUAD"]
        model.points = [
            (0.0, 0.0, 0.0),
            (1.0, 0.0, 0.0),
            (1.0, 0.0, 1.0),
            (0.0, 0.0, 1.0),
        ]
        model.planes = [Plane((0.0, 1.0, 0.0), 0.0)]
        model.surfaces = [
            Surface(
                uv_origin=(0.0, 0.0, 0.0),
                uv_u=(1.0, 0.0, 0.0),
                uv_v=(0.0, 0.0, 1.0),
                texture_index=0,
                unknown=0,
                flags=0,
                unknown2=0,
                texture_flags=0,
            )
        ]
        dat_world = dummy_dat_world([])
        dat_world.world_models = [model]

        bmodels, _, stats, _ = transcode_geometry(dat_world, 1.0, {}, None)

        self.assertEqual(len(bmodels), 1)
        self.assertEqual(len(bmodels[0].faces), 1)
        self.assertEqual(len(bmodels[0].faces[0].vertex_indices), 4)
        self.assertEqual(stats["preserved_source_ngon_faces"], 1)
        self.assertEqual(stats["triangulated_polies"], 0)

    def test_transcode_geometry_triangulates_repeated_index_ngons(self) -> None:
        repeated_poly = Poly(
            center=(0.5, 0.0, 0.5),
            lightmap_width=0,
            lightmap_height=0,
            unknown_flag=0,
            unknown_list=[],
            surface_index=0,
            plane_index=0,
            disk_verts=[
                DiskVert(0, b""),
                DiskVert(1, b""),
                DiskVert(2, b""),
                DiskVert(3, b""),
                DiskVert(0, b""),
                DiskVert(2, b""),
            ],
        )
        model = dummy_world_bsp("RepeatedNgon", [repeated_poly])
        model.textures = ["LEVELTEXTURES/STONE/REPEAT"]
        model.points = [
            (0.0, 0.0, 0.0),
            (1.0, 0.0, 0.0),
            (1.0, 0.0, 1.0),
            (0.0, 0.0, 1.0),
        ]
        model.planes = [Plane((0.0, 1.0, 0.0), 0.0)]
        model.surfaces = [
            Surface(
                uv_origin=(0.0, 0.0, 0.0),
                uv_u=(1.0, 0.0, 0.0),
                uv_v=(0.0, 0.0, 1.0),
                texture_index=0,
                unknown=0,
                flags=0,
                unknown2=0,
                texture_flags=0,
            )
        ]
        dat_world = dummy_dat_world([])
        dat_world.world_models = [model]

        bmodels, _, stats, _ = transcode_geometry(dat_world, 1.0, {}, None)

        self.assertEqual(len(bmodels), 1)
        self.assertGreater(len(bmodels[0].faces), 1)
        self.assertTrue(all(len(face.vertex_indices) == 3 for face in bmodels[0].faces))
        self.assertEqual(stats["preserved_source_ngon_faces"], 0)
        self.assertEqual(stats["triangulated_polies"], 1)

    def test_parse_mm9_spr_frame_paths(self) -> None:
        sprite_path = Path("mm9/extracted/SPRITES/SPRITES/WATER/OCEAN4.spr")
        if not sprite_path.exists():
            self.skipTest("MM9 extracted water sprite is not available")

        frames_per_second, frames = parse_spr_frame_paths(sprite_path)

        self.assertEqual(frames_per_second, 15)
        self.assertGreaterEqual(len(frames), 10)
        self.assertTrue(frames[0].lower().endswith("ocean4_00013.dtx"))

    def test_direct_mm9_water_frame_resolves_to_owning_sprite_animation(self) -> None:
        extracted_root = Path("mm9/extracted")
        sprite_path = extracted_root / "SPRITES/SPRITES/WATER/OCEAN4.spr"
        if not sprite_path.exists():
            self.skipTest("MM9 extracted water sprite is not available")

        sprite_index = build_sprite_animation_index(extracted_root)
        texture_sizes = build_texture_size_index(extracted_root)
        frames = resolve_sprite_animation_frames(
            sprite_index,
            texture_sizes,
            "SpriteTextures\\Water\\Ocean\\Ocean4_00013.dtx",
        )

        self.assertEqual(len(frames), 19)
        self.assertEqual(frames[0]["frames_per_second"], 15)
        self.assertTrue(str(frames[-1]["source_texture"]).lower().endswith("ocean4_00012.dtx"))

    def test_surface_animation_yaml_uses_sprite_frames_per_second(self) -> None:
        lines = build_surface_animation_lines({
            "WATER00001": {
                "animation_frames_per_second": 15,
                "animation_frames": [
                    {"alias": "WATER00002"},
                    {"alias": "WATER00003"},
                ],
            },
        })

        self.assertEqual(lines, [
            '  - texture: "WATER00001"',
            "    frames_per_second: 15",
            "    frames:",
            '      - "WATER00002"',
            '      - "WATER00003"',
        ])

    def test_scale_abc_model_scales_only_world_distance_values(self) -> None:
        model = AbcModel(
            name="test",
            version=13,
            command_string="",
            internal_radius=5.0,
            lod_distances=[10.0],
            pieces=[
                Piece(
                    name="piece",
                    material_index=0,
                    specular_power=0.0,
                    specular_scale=0.0,
                    lod_weight=1.0,
                    lods=[
                        Lod(
                            faces=[],
                            vertices=[
                                Vertex(
                                    position=(1.0, 2.0, 3.0),
                                    normal=(0.0, 1.0, 0.0),
                                    weights=[],
                                )
                            ],
                        )
                    ],
                )
            ],
            nodes=[
                NodeInfo(
                    name="root",
                    index=0,
                    flags=0,
                    child_count=0,
                    bind_matrix=np.identity(4, dtype=np.float32),
                )
            ],
            animations=[
                ModelAnimation(
                    name="idle",
                    interpolation_time_ms=0,
                    keyframes=[],
                    node_transforms=[
                        [
                            Transform(
                                translation=(4.0, 5.0, 6.0),
                                rotation=(0.0, 0.0, 0.0, 1.0),
                            )
                        ]
                    ],
                )
            ],
            sockets=[
                SocketInfo(
                    name="socket",
                    node_index=0,
                    rotation=(0.0, 0.0, 0.0, 1.0),
                    translation=(7.0, 8.0, 9.0),
                )
            ],
            anim_bindings=[AnimBinding(name="binding", extents=(10.0, 11.0, 12.0), origin=(13.0, 14.0, 15.0))],
        )
        model.nodes[0].bind_matrix[:3, 3] = np.array([16.0, 17.0, 18.0], dtype=np.float32)

        scale_abc_model(model, 2.0)

        self.assertEqual(model.internal_radius, 10.0)
        self.assertEqual(model.lod_distances, [20.0])
        self.assertEqual(model.pieces[0].lods[0].vertices[0].position, (2.0, 4.0, 6.0))
        self.assertEqual(model.pieces[0].lods[0].vertices[0].normal, (0.0, 1.0, 0.0))
        self.assertEqual(model.animations[0].node_transforms[0][0].translation, (8.0, 10.0, 12.0))
        self.assertEqual(model.animations[0].node_transforms[0][0].rotation, (0.0, 0.0, 0.0, 1.0))
        self.assertEqual(model.sockets[0].translation, (14.0, 16.0, 18.0))
        self.assertEqual(model.sockets[0].rotation, (0.0, 0.0, 0.0, 1.0))
        self.assertEqual(model.anim_bindings[0].extents, (20.0, 22.0, 24.0))
        self.assertEqual(model.anim_bindings[0].origin, (26.0, 28.0, 30.0))
        np.testing.assert_array_equal(model.nodes[0].bind_matrix[:3, 3], np.array([32.0, 34.0, 36.0]))

    def test_baked_model_transform_applies_abc_anim_binding_origin(self) -> None:
        vertex = transform_model_vertex_to_odm(
            (1.0, 2.0, 3.0),
            [0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0],
            1.0,
            1.0,
            (4.0, 5.0, 6.0),
        )

        self.assertEqual((vertex.x, vertex.y, vertex.z), (5, 9, 7))

    def test_baked_model_visual_offset_lifts_exported_z(self) -> None:
        model = AbcModel(
            name="tree",
            version=13,
            command_string="",
            internal_radius=0.0,
            lod_distances=[],
            pieces=[
                Piece(
                    name="bark",
                    material_index=0,
                    specular_power=0.0,
                    specular_scale=0.0,
                    lod_weight=0.0,
                    lods=[
                        Lod(
                            faces=[
                                Face([
                                    FaceVertex((0.0, 0.0), 0),
                                    FaceVertex((1.0, 0.0), 1),
                                    FaceVertex((0.0, 1.0), 2),
                                ])
                            ],
                            vertices=[
                                Vertex((0.0, -2.0, 0.0), (0.0, 1.0, 0.0), []),
                                Vertex((1.0, -2.0, 0.0), (0.0, 1.0, 0.0), []),
                                Vertex((0.0, -2.0, 1.0), (0.0, 1.0, 0.0), []),
                            ],
                        )
                    ],
                )
            ],
            nodes=[],
            animations=[],
            sockets=[],
            anim_bindings=[],
        )

        bmodel = bake_abc_model_instance(
            model,
            7,
            "Prop",
            "Tree",
            "models/props/PlantsandTrees/Tree05.abc",
            "skins/props/PlantsandTrees/TreeBark3.dtx",
            [0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0],
            1.0,
            1.0,
            {},
            {},
            {},
            set(),
            99,
            (0.0, 2.0, 0.0),
        )

        self.assertEqual([vertex.z for vertex in bmodel.vertices], [0, 0, 0])

    def test_abc_static_model_helpers_use_first_anim_binding_when_world_missing(self) -> None:
        model = AbcModel(
            name="test",
            version=13,
            command_string="",
            internal_radius=0.0,
            lod_distances=[],
            pieces=[],
            nodes=[],
            animations=[],
            sockets=[],
            anim_bindings=[
                AnimBinding(name="Static_Model", extents=(10.0, 20.0, 30.0), origin=(1.0, 2.0, 3.0))
            ],
        )

        self.assertEqual(abc_static_model_translation_lt(model), (1.0, 2.0, 3.0))
        self.assertEqual(abc_static_model_half_dims_lt(model), (10.0, 20.0, 30.0))

    def test_abc_static_model_helpers_prefer_world_anim_binding(self) -> None:
        model = AbcModel(
            name="test",
            version=13,
            command_string="",
            internal_radius=0.0,
            lod_distances=[],
            pieces=[],
            nodes=[],
            animations=[],
            sockets=[],
            anim_bindings=[
                AnimBinding(name="Static_Model", extents=(10.0, 20.0, 30.0), origin=(1.0, 2.0, 3.0)),
                AnimBinding(name="World", extents=(40.0, 50.0, 60.0), origin=(4.0, 5.0, 6.0)),
            ],
        )

        self.assertEqual(abc_static_model_translation_lt(model), (4.0, 5.0, 6.0))
        self.assertEqual(abc_static_model_half_dims_lt(model), (40.0, 50.0, 60.0))

    def test_move_position_to_floor_uses_lithtech_y_up_dims(self) -> None:
        triangle = LtFloorTriangle((
            (-10.0, 0.0, -10.0),
            (10.0, 0.0, -10.0),
            (-10.0, 0.0, 10.0),
        ))

        moved, status = move_position_to_floor_lt([0.0, 100.0, 0.0], (1.0, 25.0, 1.0), [triangle])

        self.assertEqual(status, "snapped")
        self.assertAlmostEqual(moved[1], 25.1)

    def test_near_floor_query_finds_terrain_above_embedded_prop(self) -> None:
        triangle = LtFloorTriangle((
            (-10.0, 100.0, -10.0),
            (10.0, 100.0, -10.0),
            (-10.0, 100.0, 10.0),
        ))

        floor_y = floor_y_near_position_lt([0.0, 40.0, 0.0], [triangle], max_vertical_distance=128.0)

        self.assertEqual(floor_y, 100.0)

    def test_floor_support_triangles_skip_navigation_and_water_helpers(self) -> None:
        dat_world = DatWorld(
            path=Path("test.dat"),
            version=66,
            object_data_pos=0,
            render_data_pos=0,
            world_model_pos=0,
            world_info=WorldInfo("", 0.0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0)),
            world_models=[
                WorldBsp(
                    name="Geometry",
                    textures=["STONE"],
                    points=[(0.0, 0.0, 0.0), (10.0, 0.0, 0.0), (0.0, 0.0, 10.0)],
                    point_normals=[],
                    planes=[],
                    surfaces=[Surface((0.0, 0.0, 0.0), (1.0, 0.0, 0.0), (0.0, 0.0, 1.0), 0, 0, 0, 0, 0)],
                    polies=[
                        Poly(
                            center=(0.0, 0.0, 0.0),
                            lightmap_width=0,
                            lightmap_height=0,
                            unknown_flag=0,
                            unknown_list=[],
                            surface_index=0,
                            plane_index=0,
                            disk_verts=[DiskVert(0, b""), DiskVert(1, b""), DiskVert(2, b"")],
                        )
                    ],
                    leaves=[],
                    nodes=[],
                    user_portals=[],
                    min_box=(0.0, 0.0, 0.0),
                    max_box=(0.0, 0.0, 0.0),
                    world_translation=(0.0, 0.0, 0.0),
                    root_node_index=0,
                    section_count=0,
                    counts={},
                    pblock_table=PBlockTableSummary(0, 0, 0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 0),
                ),
                WorldBsp(
                    name="AITrk0",
                    textures=["STONE"],
                    points=[(0.0, 5.0, 0.0), (10.0, 5.0, 0.0), (0.0, 5.0, 10.0)],
                    point_normals=[],
                    planes=[],
                    surfaces=[Surface((0.0, 0.0, 0.0), (1.0, 0.0, 0.0), (0.0, 0.0, 1.0), 0, 0, 0, 0, 0)],
                    polies=[
                        Poly(
                            center=(0.0, 0.0, 0.0),
                            lightmap_width=0,
                            lightmap_height=0,
                            unknown_flag=0,
                            unknown_list=[],
                            surface_index=0,
                            plane_index=0,
                            disk_verts=[DiskVert(0, b""), DiskVert(1, b""), DiskVert(2, b"")],
                        )
                    ],
                    leaves=[],
                    nodes=[],
                    user_portals=[],
                    min_box=(0.0, 0.0, 0.0),
                    max_box=(0.0, 0.0, 0.0),
                    world_translation=(0.0, 0.0, 0.0),
                    root_node_index=0,
                    section_count=0,
                    counts={},
                    pblock_table=PBlockTableSummary(0, 0, 0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 0),
                ),
            ],
            objects=[],
        )

        self.assertEqual(len(build_floor_support_triangles(dat_world)), 1)

    def test_read_leaf_preserves_portal_payload_and_packed_polygon_entries(self) -> None:
        data = bytearray()
        data += struct.pack("<H", 1)
        data += struct.pack("<HH", 0xFFFF, 3)
        data += b"abc"
        data += struct.pack("<I", 2)
        data += struct.pack("<II", 0x00060032, 0x00FF0031)
        data += struct.pack("<I", 0x12345678)

        leaf = read_leaf(BinaryReader(bytes(data)))

        self.assertEqual(leaf.count, 1)
        self.assertIsNone(leaf.index)
        self.assertEqual(len(leaf.portal_data), 1)
        self.assertEqual(leaf.portal_data[0].portal_id, 0xFFFF)
        self.assertEqual(leaf.portal_data[0].contents, b"abc")
        self.assertEqual(leaf.polygon_entries, [0x00060032, 0x00FF0031])
        self.assertEqual(leaf.polygon_ref_indices(), [6, 255])
        self.assertEqual(
            [(polygon_ref.world_model_index, polygon_ref.poly_index) for polygon_ref in leaf.polygon_refs()],
            [(0x32, 6), (0x31, 255)],
        )
        self.assertEqual(leaf.unknown, 0x12345678)

    def test_read_leaf_index_reference_variant(self) -> None:
        data = struct.pack("<HHII", 0xFFFF, 42, 0, 0x90ABCDEF)

        leaf = read_leaf(BinaryReader(data))

        self.assertEqual(leaf.count, 0xFFFF)
        self.assertEqual(leaf.index, 42)
        self.assertEqual(leaf.portal_data, [])
        self.assertEqual(leaf.polygon_entries, [])
        self.assertEqual(leaf.unknown, 0x90ABCDEF)

    def test_read_node_preserves_child_indices(self) -> None:
        data = struct.pack("<IHII", 436, 0xFFFF, 1, 0xFFFFFFFE)

        node = read_node(BinaryReader(data))

        self.assertEqual(node.poly_index, 436)
        self.assertEqual(node.leaf_index, 0xFFFF)
        self.assertEqual(node.front_index, 1)
        self.assertEqual(node.back_index, 0xFFFFFFFE)

    def test_read_user_portal_uses_mm9_v66_layout(self) -> None:
        data = bytearray()
        data += struct.pack("<H", 17)
        data += b"MiddleDoorPortal5"
        data += struct.pack("<IHffffff", 0, 0x20E0, 10.0, -4962.0, 36.0, 60.0, 0.0, 128.0)

        portal = read_user_portal(BinaryReader(bytes(data)))

        self.assertEqual(portal.name, "MiddleDoorPortal5")
        self.assertEqual(portal.unknown_int_1, 0)
        self.assertEqual(portal.unknown_int_2, 0)
        self.assertEqual(portal.unknown_short, 0x20E0)
        self.assertEqual(portal.center, (10.0, -4962.0, 36.0))
        self.assertEqual(portal.dims, (60.0, 0.0, 128.0))

    def test_read_world_objects_preserves_unknown_property_raw_bytes(self) -> None:
        object_payload = bytearray()
        object_payload += struct.pack("<H", 6)
        object_payload += b"Object"
        object_payload += struct.pack("<I", 1)
        object_payload += struct.pack("<H", 7)
        object_payload += b"Mystery"
        object_payload += struct.pack("<BIH", 128, 0x1234, 3)
        object_payload += b"xyz"
        data = bytearray()
        data += struct.pack("<I", 1)
        data += struct.pack("<H", len(object_payload))
        data += object_payload

        objects = read_world_objects(BinaryReader(bytes(data)))

        self.assertEqual(len(objects), 1)
        self.assertEqual(len(objects[0].properties), 1)
        prop = objects[0].properties[0]
        self.assertEqual(prop.name, "Mystery")
        self.assertEqual(prop.code, 128)
        self.assertEqual(prop.flags, 0x1234)
        self.assertEqual(prop.declared_data_length, 3)
        self.assertEqual(prop.raw_data, b"xyz")
        self.assertFalse(prop.decoded)
        self.assertIsNone(prop.value)

    def test_spatial_grid_layout_emits_native_rooms_and_portal_link(self) -> None:
        bmodel = OdmBModel(name="test")
        bmodel.vertices = [
            OdmVertex(0, 0, 0),
            OdmVertex(100, 0, 0),
            OdmVertex(0, 100, 0),
            OdmVertex(1000, 0, 0),
            OdmVertex(1100, 0, 0),
            OdmVertex(1000, 100, 0),
        ]
        bmodel.faces = [
            OdmFace(
                vertex_indices=[0, 1, 2],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=0,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            ),
            OdmFace(
                vertex_indices=[3, 4, 5],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=0,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            ),
        ]

        layout = build_spatial_grid_layout([bmodel], 2, "STONE")

        self.assertEqual(len(layout.rooms), 2)
        self.assertEqual(sum(len(room.triangles) for room in layout.rooms), 2)
        self.assertEqual(len(layout.portals), 1)
        self.assertEqual(layout.portals[0].front_room_id, 0)
        self.assertEqual(layout.portals[0].back_room_id, 1)

    def test_blv_layout_skips_non_runtime_helper_faces(self) -> None:
        bmodel = OdmBModel(name="test")
        bmodel.vertices = [
            OdmVertex(0, 0, 0),
            OdmVertex(100, 0, 0),
            OdmVertex(0, 100, 0),
            OdmVertex(200, 0, 0),
            OdmVertex(300, 0, 0),
            OdmVertex(200, 100, 0),
        ]
        bmodel.faces = [
            OdmFace(
                vertex_indices=[0, 1, 2],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=0,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            ),
            OdmFace(
                vertex_indices=[3, 4, 5],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=FACE_ATTRIBUTE_INVISIBLE | FACE_ATTRIBUTE_UNTOUCHABLE,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            ),
        ]
        bmodel.source_collision_role_for_face = ["world_geometry", "visibility_helper"]

        layout = build_spatial_grid_layout([bmodel], 1, "STONE")

        self.assertEqual(len(layout.rooms), 1)
        self.assertEqual(len(layout.rooms[0].triangles), 1)

    def test_leaf_grid_layout_uses_decoded_leaf_polygon_refs(self) -> None:
        bmodel = OdmBModel(name="test", source_model_index=1)
        bmodel.vertices = [
            OdmVertex(0, 0, 0),
            OdmVertex(100, 0, 0),
            OdmVertex(0, 100, 0),
            OdmVertex(1000, 0, 0),
            OdmVertex(1100, 0, 0),
            OdmVertex(1000, 100, 0),
        ]
        bmodel.faces = [
            OdmFace(
                vertex_indices=[0, 1, 2],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=0,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            ),
            OdmFace(
                vertex_indices=[3, 4, 5],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=0,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            ),
        ]
        bmodel.source_poly_for_face = [0, 1]
        dat_world = DatWorld(
            path=Path("test.dat"),
            version=66,
            object_data_pos=0,
            render_data_pos=0,
            world_model_pos=0,
            world_info=WorldInfo("", 0.0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0)),
            world_models=[
                dummy_world_bsp(
                    "VisBSP",
                    leaves=[
                        WorldLeaf(0, None, [], [(0 << 16) | 1], 0),
                        WorldLeaf(0, None, [], [(1 << 16) | 1], 0),
                    ],
                ),
                dummy_world_bsp("Geometry", polies=[dummy_poly(), dummy_poly()]),
            ],
            objects=[],
        )

        layout = build_leaf_grid_layout(dat_world, [bmodel], 2, "STONE")

        self.assertEqual(layout.diagnostics["sector_mode"], "leaf_grid")
        self.assertEqual(layout.diagnostics["valid_leaf_polygon_refs"], 2)
        self.assertEqual(layout.diagnostics["matched_leaf_polygon_refs"], 2)
        self.assertEqual(layout.diagnostics["unassigned_source_triangles"], 0)
        self.assertEqual(len(layout.rooms), 2)
        self.assertEqual(len(layout.portals), 1)

    def test_leaf_grid_layout_adds_mm9_user_portal_hints(self) -> None:
        left = OdmBModel(name="left", source_model_index=1)
        left.vertices = [
            OdmVertex(-1000, 0, 0),
            OdmVertex(-900, 0, 0),
            OdmVertex(-1000, 100, 0),
        ]
        left.faces = [
            OdmFace(
                vertex_indices=[0, 1, 2],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=0,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            )
        ]
        left.source_poly_for_face = [0]
        right = OdmBModel(name="right", source_model_index=2)
        right.vertices = [
            OdmVertex(900, 0, 0),
            OdmVertex(1000, 0, 0),
            OdmVertex(900, 100, 0),
        ]
        right.faces = [
            OdmFace(
                vertex_indices=[0, 1, 2],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=0,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            )
        ]
        right.source_poly_for_face = [0]
        dat_world = DatWorld(
            path=Path("test.dat"),
            version=66,
            object_data_pos=0,
            render_data_pos=0,
            world_model_pos=0,
            world_info=WorldInfo("", 0.0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0)),
            world_models=[
                dummy_world_bsp(
                    "VisBSP",
                    leaves=[
                        WorldLeaf(0, None, [], [(0 << 16) | 1], 0),
                        WorldLeaf(0, None, [], [(0 << 16) | 2], 0),
                    ],
                ),
                dummy_world_bsp("Left", polies=[dummy_poly()]),
                dummy_world_bsp("Right", polies=[dummy_poly()]),
            ],
            objects=[],
        )
        dat_world.world_models[0].user_portals = [
            UserPortal(
                name="DoorPortal",
                center=(0.0, 0.0, 0.0),
                dims=(0.0, 64.0, 64.0),
                unknown_int_1=0,
                unknown_int_2=0,
                unknown_short=0,
            )
        ]

        layout = build_leaf_grid_layout(dat_world, [left, right], 2, "STONE", 1.0)

        self.assertEqual(layout.diagnostics["dat_user_portals"], 1)
        self.assertEqual(layout.diagnostics["dat_user_portals_emitted"], 1)
        self.assertTrue(any(portal.source_kind == "mm9_user_portal" for portal in layout.portals))

    def test_outdoor_mechanism_faces_get_classic_event_cogs(self) -> None:
        mechanism_object = WorldObject(
            name="Door",
            data_length=0,
            properties=[object_property("Name", "MineCartDoor")],
        )
        bmodel = OdmBModel(name="MineCartDoor", source_model_name="MineCartDoor")
        bmodel.faces = [
            OdmFace(
                vertex_indices=[0, 1, 2],
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="STONE",
                bitmap_index=0,
                polygon_type=0,
                attributes=FACE_ATTRIBUTE_INVISIBLE | FACE_ATTRIBUTE_HAS_HINT,
                plane_normal=(0, 0, 0),
                plane_distance=0,
            )
        ]

        lines, stats = build_outdoor_mechanism_interactive_face_lines(
            dummy_dat_world([mechanism_object]),
            [bmodel],
        )

        event_id = mechanism_event_id(0)
        legacy_attributes = FACE_ATTRIBUTE_CLICKABLE
        self.assertEqual(stats["mechanism_event_faces"], 1)
        self.assertEqual(stats["mechanism_event_face_mechanisms"], 1)
        self.assertIn(f"    legacy_attributes: {legacy_attributes}", lines)
        self.assertIn(f"    cog_number: {event_id}", lines)
        self.assertIn(f"    cog_triggered_number: {event_id}", lines)

    def test_outdoor_buttons_and_switches_are_interactive_mechanisms(self) -> None:
        button = WorldObject(
            name="Button",
            data_length=0,
            properties=[
                object_property("Name", "Button1"),
                object_property("MoveDir", [0.0, 0.0, -1.0]),
                object_property("MoveDist", 3.0),
                object_property("Speed", 20.0),
            ],
        )
        switch = WorldObject(
            name="Switch",
            data_length=0,
            properties=[
                object_property("Name", "SwitchLever0"),
                object_property("RotationPoint", [1.0, 2.0, 3.0]),
                object_property("RotationAngles", [0.0, 0.0, 35.0]),
                object_property("Speed", 20.0),
                object_property("OpenAway", True),
            ],
        )
        button_model = OdmBModel(name="Button1", source_model_name="Button1")
        switch_model = OdmBModel(name="SwitchLever0", source_model_name="SwitchLever0")
        for model in (button_model, switch_model):
            model.faces = [
                OdmFace(
                    vertex_indices=[0, 1, 2],
                    texture_us=[0, 0, 0],
                    texture_vs=[0, 0, 0],
                    texture_alias="STONE",
                    bitmap_index=0,
                    polygon_type=0,
                    attributes=0,
                    plane_normal=(0, 0, 0),
                    plane_distance=0,
                )
            ]

        world = dummy_dat_world([button, switch])
        mechanism_lines, mechanism_stats = build_mechanism_lines(world, [button_model, switch_model], 2.56)
        face_lines, face_stats = build_outdoor_mechanism_interactive_face_lines(
            world,
            [button_model, switch_model],
        )

        self.assertEqual(mechanism_stats["mechanisms_linear"], 1)
        self.assertEqual(mechanism_stats["mechanisms_rotating"], 1)
        self.assertIn('    kind: "linear_button"', mechanism_lines)
        self.assertIn('    kind: "rotating_switch"', mechanism_lines)
        self.assertIn(f"    event_id: {mechanism_event_id(0)}", mechanism_lines)
        self.assertIn(f"    event_id: {mechanism_event_id(1)}", mechanism_lines)
        self.assertIn("      open_away: true", mechanism_lines)
        self.assertEqual(face_stats["mechanism_event_face_mechanisms"], 2)
        self.assertIn(f"    cog_number: {mechanism_event_id(0)}", face_lines)
        self.assertIn(f"    cog_number: {mechanism_event_id(1)}", face_lines)

    def test_outdoor_dynamic_geometry_excludes_audit_only_mechanisms(self) -> None:
        door = WorldObject(
            name="Door",
            data_length=0,
            properties=[
                object_property("Name", "Door0"),
                object_property("MoveDir", [1.0, 0.0, 0.0]),
                object_property("MoveDist", 100.0),
            ],
        )
        invisible_brush = WorldObject(
            name="InvisibleBrush",
            data_length=0,
            properties=[object_property("Name", "Collision0")],
        )
        continuous_rotating_brush = WorldObject(
            name="RotatingBrush",
            data_length=0,
            properties=[
                object_property("Name", "Spinner0"),
                object_property("ZAxisRevTime", 0.75),
            ],
        )
        bmodels = [
            OdmBModel(name="Door0", source_model_name="Door0"),
            OdmBModel(name="Collision0", source_model_name="Collision0"),
            OdmBModel(name="Spinner0", source_model_name="Spinner0"),
        ]

        mechanisms = navigation_mechanisms_by_bmodel(
            dummy_dat_world([door, invisible_brush, continuous_rotating_brush]),
            bmodels,
        )

        self.assertEqual(mechanisms, {0: 900000})

    def test_outdoor_scene_empty_interactive_faces_are_nested_yaml_list(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            scene_path = Path(temp_dir) / "empty.scene.yml"
            write_odm_scene_yml(
                scene_path,
                "empty.odm",
                "empty.mm9.yml",
                [],
                [],
                [],
                [],
                [],
                [],
            )

            text = scene_path.read_text(encoding="utf-8")

        self.assertIn('scene_profile: "bmodel_world"', text)
        self.assertIn('  location_type: "exterior"', text)
        self.assertIn("bmodel_faces:\n  interactive_faces:\n    []", text)

    def test_outdoor_scene_can_emit_enclosed_location_semantics(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            scene_path = Path(temp_dir) / "enclosed.scene.yml"
            write_odm_scene_yml(
                scene_path,
                "enclosed.odm",
                "enclosed.mm9.yml",
                [],
                [],
                [],
                [],
                [],
                [],
                location_type="enclosed",
            )

            text = scene_path.read_text(encoding="utf-8")

        self.assertIn('scene_profile: "bmodel_world"', text)
        self.assertIn('  location_type: "enclosed"', text)

    def test_outdoor_scene_regeneration_does_not_touch_authored_overlay(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            scene_path = Path(temp_dir) / "regenerated.scene.yml"
            authored_path = Path(temp_dir) / "regenerated_authored.scene.yml"
            authored_text = (
                "format_version: 1\n"
                "kind: outdoor_scene_overlay\n"
                "authored_content:\n"
                "  actors: []\n"
            )
            authored_path.write_text(authored_text, encoding="utf-8")

            write_odm_scene_yml(
                scene_path,
                "regenerated.odm",
                "regenerated.mm9.yml",
                [],
                [],
                [],
                [],
                [],
                [],
            )

            regenerated_authored_text = authored_path.read_text(encoding="utf-8")

        self.assertEqual(regenerated_authored_text, authored_text)

    def test_indoor_compiled_door_faces_get_matching_classic_event_cogs(self) -> None:
        door_lines = [
            "    - door_id: 900123",
            "      face_ids: [7, 9]",
        ]

        lines, stats = build_indoor_mechanism_face_override_lines(door_lines)

        event_id = mechanism_event_id(123)
        self.assertEqual(stats["mechanism_event_faces"], 2)
        self.assertEqual(stats["mechanism_event_face_mechanisms"], 1)
        self.assertIn("    - face_index: 7", lines)
        self.assertIn("    - face_index: 9", lines)
        self.assertIn(f"      cog_number: {event_id}", lines)
        self.assertIn(f"      cog_triggered: {event_id}", lines)

    def test_scene_classic_event_face_ids_are_loaded_from_actual_face_cogs(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            scene_path = Path(temp_dir) / "map.scene.yml"
            scene_path.write_text(
                """format_version: 1
kind: "indoor_scene"
bmodel_faces:
  interactive_faces:
    - cog_number: 30001
initial_state:
  face_attribute_overrides:
    - cog_number: 30002
    - face_index: 7
""",
                encoding="utf-8",
            )

            event_ids = load_scene_classic_event_face_ids(scene_path)

        self.assertEqual(event_ids, {30001, 30002})

    def test_indoor_rotating_mechanism_exports_temporary_vertical_door(self) -> None:
        mechanism_object = WorldObject(
            name="RotatingDoor",
            data_length=0,
            properties=[
                object_property("Name", "TempleRotator"),
                object_property("RotationPoint", [0.0, 0.0, 0.0]),
                object_property("RotationAngles", [0.0, 90.0, 0.0]),
                object_property("Speed", 90.0),
            ],
        )
        bmodel = OdmBModel(name="TempleRotator", source_model_name="TempleRotator")
        bmodel.vertices = [
            OdmVertex(0, 0, 0),
            OdmVertex(0, 0, 256),
        ]

        mechanisms = build_blv_mechanisms(dummy_dat_world([mechanism_object]), [bmodel], 2.56)

        self.assertEqual(len(mechanisms), 1)
        self.assertEqual(mechanisms[0].kind, "rotating_door_as_lift")
        self.assertEqual(mechanisms[0].move_axis, (0.0, 0.0, 1.0))
        self.assertEqual(mechanisms[0].move_distance, 272.0)

    def test_generated_mm9_lua_registers_classic_mechanism_event_handlers(self) -> None:
        event_data = {
            "mechanisms": [
                {
                    "source_object_index": 42,
                    "source_class": "Door",
                    "source_name": "TempleDoor",
                    "mechanism": {"kind": "linear_door"},
                    "classic_runtime": {
                        "target_kind": "indoor_door",
                        "door_id": 900042,
                    },
                    "classic_event_face": {
                        "event_id": mechanism_event_id(42),
                        "hint": "TempleDoor",
                    },
                    "activation": {"double_door_name": "TempleDoorPartner"},
                    "sounds": [
                        {
                            "phase": "open_start",
                            "sound_name": "door/doormetal_open02.wav",
                            "position": {"x": 10, "y": 20, "z": 30},
                        }
                    ],
                },
                {
                    "source_object_index": 43,
                    "source_class": "Door",
                    "source_name": "TempleDoorPartner",
                    "mechanism": {"kind": "linear_door"},
                    "classic_runtime": {
                        "target_kind": "indoor_door",
                        "door_id": 900043,
                    },
                    "activation": {"double_door_name": "TempleDoor"},
                },
            ]
        }

        lua_text = map_lua_text("temple", {}, event_data)

        self.assertIn("event_id = 30042", lua_text)
        self.assertIn("classic_door_id = 900042", lua_text)
        self.assertIn('double_door_name = "TempleDoorPartner"', lua_text)
        self.assertIn("name = \"door/doormetal_open02.wav\"", lua_text)
        self.assertIn("evt.PlaySoundName(sound.name, sound.x or 0, sound.y or 0, sound.z or 0)", lua_text)
        self.assertIn("[30042] = { kind = \"open_door\", source = \"mm9_mechanism\", targetName = \"TempleDoor\" }", lua_text)
        self.assertIn("RegisterEvent(30042, \"TempleDoor\", function()", lua_text)
        self.assertIn("map.triggerMechanism(42, 2)", lua_text)
        self.assertIn("local partner = map.resolveMechanism(mechanism.double_door_name)", lua_text)
        self.assertIn("map.triggerResolvedMechanism(partner, resolved_action)", lua_text)

    def test_sound_lookup_falls_back_to_source_basename(self) -> None:
        source_path = Path("mm9/extracted/SOUNDS/SOUNDS/EVENTS/METALGEARWORKS.wav")
        source_index = {
            "events/metalgearworks.wav": source_path,
            "metalgearworks.wav": source_path,
            "metalgearworks": source_path,
        }

        self.assertEqual(find_source_sound_path(source_index, "Environmental/metalgearworks.wav"), source_path)

    def test_sound_lookup_uses_known_mm9_source_aliases(self) -> None:
        source_path = Path("mm9/extracted/SOUNDS/SOUNDS/ANIMSOUNDS/DRAGON/HOP.wav")
        source_index = {
            "animsounds/dragon/hop.wav": source_path,
            "animsounds/dragon/hop": source_path,
        }

        self.assertEqual(find_source_sound_path(source_index, "AnimSounds/DragonRedhop.wav"), source_path)

    def test_missing_mm9_music_note_sounds_are_generated_as_wav(self) -> None:
        wav_bytes = synthetic_mm9_sound_bytes("music/a#2.wav")

        self.assertIsNotNone(wav_bytes)
        self.assertTrue(wav_bytes.startswith(b"RIFF"))
        self.assertIn(b"WAVE", wav_bytes[:16])
        self.assertGreater(len(wav_bytes), 1000)

    def test_ai_barrier_is_retained_as_hidden_navigation_geometry(self) -> None:
        role = classify_face_role("AIBarrier17", "invisible.dtx", 0)

        self.assertFalse(is_skipped_world_model_name("AIBarrier17"))
        self.assertEqual(role.collision_role, "ai_barrier")
        self.assertEqual(role.render_role, "hidden")
        self.assertNotEqual(role.attributes & FACE_ATTRIBUTE_UNTOUCHABLE, 0)

    def test_navigation_cooker_deduplicates_coincident_floor_faces(self) -> None:
        bmodels: list[OdmBModel] = []
        for name, role in (("Terrain0", "world_geometry"), ("PhysicsBSP", "physics_hull")):
            bmodel = OdmBModel(name=name)
            bmodel.vertices = [
                OdmVertex(0, 0, 0),
                OdmVertex(128, 0, 0),
                OdmVertex(128, 128, 0),
                OdmVertex(0, 128, 0),
            ]
            bmodel.faces = [OdmFace(
                vertex_indices=[0, 1, 2, 3],
                texture_us=[0, 0, 0, 0],
                texture_vs=[0, 0, 0, 0],
                texture_alias="floor",
                bitmap_index=0,
                polygon_type=3,
                attributes=0,
                plane_normal=(0, 0, 65536),
                plane_distance=0,
            )]
            bmodel.source_collision_role_for_face = [role]
            bmodels.append(bmodel)

        records, stats = build_navigation_records(dummy_dat_world([]), bmodels)

        self.assertEqual(len(records), 1)
        self.assertEqual(stats["navigation_floor_facets"], 1)
        self.assertEqual(stats["navigation_duplicate_facets_removed"], 1)
        self.assertEqual(stats["navigation_floor_components"], 1)

    def test_navigation_binary_is_compact_and_bound_to_odm_bytes(self) -> None:
        bmodel = OdmBModel(name="Terrain0")
        bmodel.vertices = [OdmVertex(0, 0, 0), OdmVertex(64, 0, 0), OdmVertex(0, 64, 0)]
        bmodel.faces = [OdmFace(
            vertex_indices=[0, 1, 2],
            texture_us=[0, 0, 0],
            texture_vs=[0, 0, 0],
            texture_alias="floor",
            bitmap_index=0,
            polygon_type=3,
            attributes=0,
            plane_normal=(0, 0, 65536),
            plane_distance=0,
        )]
        bmodel.source_collision_role_for_face = ["world_geometry"]

        navigation_bytes, stats = build_navigation_bytes(b"synthetic odm", dummy_dat_world([]), [bmodel])

        self.assertEqual(navigation_bytes[:8], b"OYMNAV1\0")
        self.assertEqual(len(navigation_bytes), 48 + 24)
        self.assertEqual(struct.unpack_from("<I", navigation_bytes, 40)[0], 1)
        self.assertEqual(stats["navigation_cooked_facets"], 1)

    def test_navigation_cooker_marks_safe_coplanar_triangle_pairs(self) -> None:
        bmodel = OdmBModel(name="Terrain0")
        bmodel.vertices = [
            OdmVertex(0, 0, 0),
            OdmVertex(128, 0, 0),
            OdmVertex(128, 128, 0),
            OdmVertex(0, 128, 0),
        ]
        bmodel.faces = [
            OdmFace(
                vertex_indices=indices,
                texture_us=[0, 0, 0],
                texture_vs=[0, 0, 0],
                texture_alias="floor",
                bitmap_index=0,
                polygon_type=3,
                attributes=0,
                plane_normal=(0, 0, 65536),
                plane_distance=0,
            )
            for indices in ([0, 1, 2], [0, 2, 3])
        ]
        bmodel.source_collision_role_for_face = ["world_geometry", "world_geometry"]

        records, stats = build_navigation_records(dummy_dat_world([]), [bmodel])

        self.assertEqual(len(records), 2)
        self.assertEqual(records[0][6], 0)
        self.assertEqual(records[1][6], 1)
        self.assertEqual(stats["navigation_coplanar_triangle_pairs_merged"], 1)

    def test_render_cooker_assigns_static_cells_and_separates_mechanisms(self) -> None:
        static_model = OdmBModel(name="Static")
        static_model.vertices = [
            OdmVertex(-5000, 0, 0),
            OdmVertex(-4000, 0, 0),
            OdmVertex(-4000, 1000, 0),
        ]
        static_model.faces = [OdmFace(
            vertex_indices=[0, 1, 2],
            texture_us=[0, 0, 0],
            texture_vs=[0, 0, 0],
            texture_alias="stone",
            bitmap_index=0,
            polygon_type=3,
            attributes=0,
            plane_normal=(0, 0, 65536),
            plane_distance=0,
        )]
        static_model.source_surface_flags_for_face = [0x00000008]
        mechanism = OdmBModel(name="Door")
        mechanism.vertices = [
            OdmVertex(0, 0, 0),
            OdmVertex(100, 0, 0),
            OdmVertex(100, 0, 200),
        ]
        mechanism.faces = [OdmFace(
            vertex_indices=[0, 1, 2],
            texture_us=[0, 0, 0],
            texture_vs=[0, 0, 0],
            texture_alias="door",
            bitmap_index=0,
            polygon_type=1,
            attributes=0,
            plane_normal=(0, 65536, 0),
            plane_distance=0,
        )]

        render_bytes, stats = build_render_data_bytes(
            b"synthetic odm",
            [static_model, mechanism],
            {1: 42},
        )

        self.assertEqual(render_bytes[:8], b"OYMREN1\0")
        self.assertEqual(len(render_bytes), 48 + 2 * 24)
        self.assertEqual(struct.unpack_from("<h", render_bytes, 64)[0], -2)
        self.assertEqual(struct.unpack_from("<I", render_bytes, 48 + 20)[0], 2)
        self.assertEqual(struct.unpack_from("<I", render_bytes, 48 + 24 + 20)[0], 1)
        self.assertEqual(stats["render_static_faces"], 1)
        self.assertEqual(stats["render_dynamic_faces"], 1)
        self.assertEqual(stats["render_translucent_faces"], 1)
        self.assertEqual(stats["render_static_cells"], 1)


if __name__ == "__main__":
    unittest.main()
