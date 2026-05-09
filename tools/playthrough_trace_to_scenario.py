#!/usr/bin/env python3

from __future__ import annotations

import argparse
import base64
import json
import re
import shlex
import sys
import zlib
from pathlib import Path
from typing import Any


TRACE_PREFIX = "[GameplayTrace]"
SCENARIO_PREFIX = "[Scenario]"

NOISE_PREFIXES = (
    "Average FPS ",
    "Status text set ",
    "GameAudioSystem:",
    "IndoorRenderer:",
    "OutdoorRenderer:",
    "Actor render hitch:",
    "[MapLoadTiming]",
)

NOISE_CONTAINS = (
    "outdoor actors:",
    "moving mechanism face rebuild",
)

BUG_MARKERS = (
    "bug",
    "buug",
    "wrong",
)

VOLATILE_MAP_VARS = {
    # Tomb of VARN's main power timer toggles this ambient state independently of player actions.
    ("pyramid.blv", "4"),
    # Tomb of VARN's main power timer also mutates this transient power-failure counter.
    ("pyramid.blv", "5"),
    # The Hive flush sequence uses these as short-lived scheduled state between pressure/event callbacks.
    ("hive.blv", "21"),
    ("hive.blv", "22"),
}

VOLATILE_NAMED_GLOBAL_VARS = {
    # Cross-continent intro scheduling is initialized around load/map transitions and can be absent in the save
    # snapshot before the map scripts re-seed it. It is useful trace context but not a stable replay assertion.
    "mmerge.crosscontinents.meettime",
}


def normalized_map_name(value: str) -> str:
    return value.strip().lower()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Convert a noisy hand-recorded OpenYAMM playthrough trace into a sanitized scenario YAML draft. "
            "The output is an authoring aid, not a final runnable scenario."
        )
    )
    parser.add_argument("input", type=Path, help="Raw playthrough notes, for example tests/playthrough_scenarios/mm6.txt")
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        help="Output YAML draft path. Defaults to stdout.",
    )
    parser.add_argument("--id", default="mm6.main_story.draft", help="Scenario id to write into the draft.")
    parser.add_argument("--title", default="MM6 main story draft from recorded trace", help="Scenario title.")
    parser.add_argument("--world", default="mm6", help="Scenario world id.")
    parser.add_argument("--mode", default="hybrid", choices=("faithful", "hybrid", "unitized"), help="Scenario mode.")
    parser.add_argument(
        "--keep-duplicates",
        action="store_true",
        help="Keep repeated topic/trace entries that are normally collapsed as manual-click noise.",
    )
    parser.add_argument(
        "--include-bug-notes",
        action="store_true",
        help="Keep comment lines that look like bug notes. They are ignored by default.",
    )
    parser.add_argument(
        "--write-normalized-notes",
        type=Path,
        help=(
            "Write a sanitized playthrough note file that keeps GameplayTrace rows but rewrites free-form comments "
            "as explicit [Scenario] directives."
        ),
    )
    return parser.parse_args()


def read_text(path: Path) -> str:
    data = path.read_bytes()

    try:
        return data.decode("utf-8")
    except UnicodeDecodeError:
        return data.decode("cp1252", errors="replace")


def parse_trace(line: str) -> tuple[str, dict[str, str]] | None:
    if TRACE_PREFIX not in line:
        return None

    body = line.split(TRACE_PREFIX, 1)[1].strip()
    if not body:
        return None

    try:
        tokens = shlex.split(body)
    except ValueError:
        tokens = body.split()

    if not tokens:
        return None

    event = tokens[0]
    fields: dict[str, str] = {}

    for token in tokens[1:]:
        if "=" not in token:
            continue

        key, value = token.split("=", 1)
        fields[key] = value

    return event, fields


def parse_key_values(tokens: list[str]) -> dict[str, str]:
    fields: dict[str, str] = {}

    for token in tokens:
        if "=" not in token:
            continue

        key, value = token.split("=", 1)
        fields[key] = value

    return fields


def parse_scenario_directive(line: str) -> tuple[str, dict[str, str]] | None:
    if not line.startswith(SCENARIO_PREFIX):
        return None

    body = line[len(SCENARIO_PREFIX) :].strip()
    if not body:
        return None

    try:
        tokens = shlex.split(body)
    except ValueError:
        tokens = body.split()

    if not tokens:
        return None

    return tokens[0], parse_key_values(tokens[1:])


def is_noise(line: str) -> bool:
    stripped = line.strip()
    if not stripped:
        return True

    if stripped.startswith(NOISE_PREFIXES):
        return True

    lower = stripped.lower()
    return any(token in lower for token in NOISE_CONTAINS)


def looks_like_bug_note(line: str) -> bool:
    stripped = line.strip().lower().lstrip("- ")
    return any(marker in stripped for marker in BUG_MARKERS)


def is_volatile_map_var_changed(event: str, fields: dict[str, str]) -> bool:
    if event != "map_var_changed":
        return False

    map_name = normalized_map_name(fields.get("map", ""))
    index = fields.get("index", "")
    return (map_name, index) in VOLATILE_MAP_VARS


def is_volatile_named_global_var_changed(event: str, fields: dict[str, str]) -> bool:
    if event != "named_global_var_changed":
        return False

    return fields.get("name", "").strip().lower() in VOLATILE_NAMED_GLOBAL_VARS


def hive_named_map_var_combat_step(
    line_number: int,
    event: str,
    fields: dict[str, str],
    state: dict[str, Any],
) -> dict[str, Any] | None:
    if event != "named_map_var_changed":
        return None

    if normalized_map_name(fields.get("map", "")) != "hive.blv" or fields.get("current") != "1":
        return None

    name = fields.get("name", "")
    if name == "HiveReactorKilled":
        state["hive_post_combat_mechanism_triggers_remaining"] = 5
        return {
            "source_line": line_number,
            "combat_loot": {
                "scene_kind": "indoor",
                "map": "hive.blv",
                "actor_index": 0,
                "monster_id": 647,
                "name": "Hive Reactor",
            },
        }

    if name == "HiveQueenKilled":
        state["hive_post_combat_mechanism_triggers_remaining"] = 0
        return {
            "source_line": line_number,
            "combat_loot": {
                "scene_kind": "indoor",
                "map": "hive.blv",
                "actor_index": 1,
                "monster_id": 646,
                "name": "Hive Queen",
            },
        }

    return None


def int_or_text(value: str) -> int | float | str | bool:
    if value == "true":
        return True
    if value == "false":
        return False
    if value == "none":
        return "none"

    if re.fullmatch(r"-?\d+", value):
        try:
            return int(value)
        except ValueError:
            return value

    if re.fullmatch(r"-?\d+\.\d+", value):
        try:
            return float(value)
        except ValueError:
            return value

    return value


def select_fields(fields: dict[str, str], keys: tuple[str, ...]) -> dict[str, Any]:
    selected: dict[str, Any] = {}
    for key in keys:
        if key in fields:
            selected[key] = int_or_text(fields[key])
    return selected


def is_generated_mercenary_dialog_action(action: dict[str, Any]) -> bool:
    return action.get("kind") == "house_resident" and action.get("id") in range(303, 311)


def typed_fields(fields: dict[str, str]) -> dict[str, Any]:
    return {key: int_or_text(value) for key, value in fields.items()}


def update_last_game_minutes(fields: dict[str, str], state: dict[str, Any]) -> None:
    if "game_minutes" not in fields:
        return

    value = int_or_text(fields["game_minutes"])
    if isinstance(value, (int, float)):
        state["last_game_minutes"] = float(value)


def recorded_game_minutes_for_step(event: str, fields: dict[str, str]) -> Any | None:
    key = "before_game_minutes" if event == "game_time_advanced" else "game_minutes"
    if key not in fields:
        return None

    value = int_or_text(fields[key])
    return value if isinstance(value, (int, float)) else None


def attach_recorded_game_minutes(step: Any, event: str, fields: dict[str, str]) -> Any:
    game_minutes = recorded_game_minutes_for_step(event, fields)
    if game_minutes is None:
        return step

    def attach_one(item: Any) -> None:
        if not isinstance(item, dict):
            return

        for key, value in item.items():
            if key in ("source_line", "note", "todo"):
                continue
            if isinstance(value, dict) and "game_minutes" not in value:
                value["game_minutes"] = game_minutes
                return

    if isinstance(step, list):
        for item in step:
            attach_one(item)
    else:
        attach_one(step)

    return step


def update_current_map_display_from_fields(fields: dict[str, str], state: dict[str, Any]) -> None:
    for key in ("target", "destination_name", "map"):
        value = fields.get(key, "")
        if value and not looks_like_map_file(value):
            state["current_map_display"] = value
            return


def trace_map_matches_current(fields: dict[str, str], state: dict[str, Any]) -> bool:
    trace_map = fields.get("map", "")

    if not trace_map:
        return True

    current_map_file = str(state.get("current_map_file", ""))
    current_map_display = str(state.get("current_map_display", ""))

    if current_map_file and trace_map.lower() == current_map_file.lower():
        return True

    if current_map_display and trace_map.lower() == current_map_display.lower():
        return True

    return not current_map_file and not current_map_display


def out_of_current_map_observation(event: str, line_number: int, fields: dict[str, str]) -> dict[str, Any]:
    return {
        "source_line": line_number,
        "trace_observation": {
            "event": event,
            "fields": typed_fields(fields),
            "note": "not converted to an assertion because the trace map did not match the current recorded map",
        },
    }


def replay_map_key_for_fields(fields: dict[str, str], state: dict[str, Any]) -> str:
    trace_map = fields.get("map", "")
    if trace_map and looks_like_map_file(trace_map):
        return normalized_map_name(trace_map)

    current_map_file = str(state.get("current_map_file", ""))
    if current_map_file:
        return normalized_map_name(current_map_file)

    return normalized_map_name(trace_map)


def corpse_quest_loot_key(fields: dict[str, str], state: dict[str, Any]) -> tuple[str, str, str] | None:
    actor_or_corpse_index = fields.get("actor_index", "") or fields.get("corpse_index", "")
    item_id = fields.get("item_id", "")
    if not actor_or_corpse_index or not item_id:
        return None

    return replay_map_key_for_fields(fields, state), str(actor_or_corpse_index), str(item_id)


def is_synthetic_combat_looted_corpse_item(fields: dict[str, str], state: dict[str, Any]) -> bool:
    key = corpse_quest_loot_key(fields, state)
    if key is None:
        return False

    synthetic_keys = state.get("synthetic_combat_looted_corpse_items")
    return isinstance(synthetic_keys, set) and key in synthetic_keys


def combat_looted_corpse_observation(
    event: str,
    line_number: int,
    fields: dict[str, str],
) -> dict[str, Any]:
    return {
        "source_line": line_number,
        "trace_observation": {
            "event": event,
            "fields": typed_fields(fields),
            "note": (
                "not converted to a replay assertion because the same corpse quest item was already handled "
                "by a synthetic combat_loot step"
            ),
        },
    }


def state_dump_event_parts(event: str) -> tuple[str, str] | None:
    match = re.fullmatch(r"state_dump_(save|load_file|load_applied)_(.+)", event)
    if not match:
        return None

    return match.group(1), match.group(2)


def encode_state_dump_records(records: list[dict[str, Any]]) -> str:
    raw = json.dumps(records, separators=(",", ":"), sort_keys=True).encode("utf-8")
    return base64.b64encode(zlib.compress(raw, level=9)).decode("ascii")


def state_dump_bundle_step(bundle: dict[str, Any], end_line: int | None = None) -> dict[str, Any] | None:
    records = bundle.get("records", [])
    if not records:
        return None

    counts: dict[str, int] = {}
    for record in records:
        kind = str(record.get("kind", "unknown"))
        counts[kind] = counts.get(kind, 0) + 1

    last_source_line = end_line if end_line is not None else int(records[-1].get("source_line", bundle["source_line"]))
    return {
        "source_line": bundle["source_line"],
        "trace_observation": {
            "event": "state_dump_bundle",
            "phase": bundle["phase"],
            "path": bundle.get("path", ""),
            "first_source_line": bundle["source_line"],
            "last_source_line": last_source_line,
            "record_count": len(records),
            "counts": dict(sorted(counts.items())),
            "encoding": "base64+zlib+json",
            "data": encode_state_dump_records(records),
        },
    }


def actor_interaction_index(step: dict[str, Any]) -> Any | None:
    payload = step.get("interact_actor")
    if not isinstance(payload, dict):
        return None

    return payload.get("actor_index")


def parse_triplet(value: str) -> tuple[Any, Any, Any] | None:
    text = value.strip()
    if text.startswith("(") and text.endswith(")"):
        text = text[1:-1]

    parts = [part.strip() for part in text.split(",")]
    if len(parts) != 3:
        return None

    return int_or_text(parts[0]), int_or_text(parts[1]), int_or_text(parts[2])


def pose_from_trace_fields(fields: dict[str, str]) -> dict[str, Any] | None:
    triplet = parse_triplet(fields.get("party", ""))
    if triplet is None:
        return None

    pose: dict[str, Any] = {
        "x": triplet[0],
        "y": triplet[1],
        "z": triplet[2],
    }

    if "map" in fields:
        pose["map"] = fields["map"]
    if "yaw" in fields:
        pose["yaw"] = int_or_text(fields["yaw"])
    if "pitch" in fields:
        pose["pitch"] = int_or_text(fields["pitch"])

    return pose


def looks_like_map_file(value: str) -> bool:
    return value.lower().endswith((".odm", ".blv"))


def normalize_pose_map_for_replay(pose: dict[str, Any], state: dict[str, Any]) -> None:
    map_name = str(pose.get("map", ""))
    current_map_file = str(state.get("current_map_file", ""))

    if map_name and looks_like_map_file(map_name):
        return

    if current_map_file:
        pose["map"] = current_map_file


def normalize_step_map_for_replay(step: dict[str, Any], state: dict[str, Any]) -> None:
    map_name = str(step.get("map", ""))
    current_map_file = str(state.get("current_map_file", ""))

    if map_name and looks_like_map_file(map_name):
        return

    if current_map_file:
        step["map"] = current_map_file


def sanitized_checkpoint_name(path: str, fallback: str) -> str:
    if not path:
        return fallback

    name = Path(path).stem or fallback
    name = re.sub(r"[^A-Za-z0-9_]+", "_", name).strip("_")
    return name or fallback


def movement_segment_step(line_number: int, segment: dict[str, Any], state: dict[str, Any]) -> dict[str, Any] | None:
    meta = segment.get("meta")
    start = segment.get("start")
    stop = segment.get("stop")

    if not isinstance(meta, dict) or not isinstance(start, dict) or not isinstance(stop, dict):
        return None

    start_pose = pose_from_trace_fields({key: str(value) for key, value in start.items()})
    stop_pose = pose_from_trace_fields({key: str(value) for key, value in stop.items()})

    if start_pose is None or stop_pose is None:
        return {
            "source_line": line_number,
            "todo": {
                "kind": "movement_segment",
                "reason": "movement segment is missing parseable start or stop party pose",
                "meta": meta,
                "start": start,
                "expect_stop": stop,
            },
        }

    normalize_pose_map_for_replay(start_pose, state)
    normalize_pose_map_for_replay(stop_pose, state)

    return {
        "source_line": line_number,
        "movement_segment": {
            "input": meta.get("input", "forward"),
            "duration_ms": int_or_text(str(meta.get("duration_ms", 0))),
            "delta_game_minutes": int_or_text(str(meta.get("delta_game_minutes", 0))),
            "start": start_pose,
            "expect_stop": stop_pose,
            "tolerance_xy": 16,
            "tolerance_z": 16,
            "actor_collision": False,
            "actor_ai": False,
            "raw_start": start,
            "raw_stop": stop,
        },
    }


def manual_line_to_step(line_number: int, line: str, include_bug_notes: bool) -> dict[str, Any] | None:
    text = line.strip()
    if not text:
        return None

    if is_noise(text):
        return None

    if looks_like_bug_note(text) and not include_bug_notes:
        return None

    normalized = text.lower().strip("- ")

    if normalized == "new game":
        return {
            "source_line": line_number,
            "new_game_flow": {
                "continent": "TODO",
                "party": "TODO",
                "source_note": text,
            },
        }

    if normalized.startswith("select "):
        return {
            "source_line": line_number,
            "todo": {
                "kind": "new_game_selection",
                "note": text,
            },
        }

    if normalized.startswith("create party"):
        return {
            "source_line": line_number,
            "todo": {
                "kind": "party_creation",
                "note": text,
            },
        }

    if normalized.startswith("ensure "):
        item_match = re.search(r"item id (\d+)", normalized)
        assertion: dict[str, Any] = {"source_note": text}
        if item_match:
            assertion["inventory_any_member"] = [{"item_id": int(item_match.group(1))}]
        return {
            "source_line": line_number,
            "assert": assertion,
        }

    if normalized in ("close dialog", "close dialogue"):
        return {
            "source_line": line_number,
            "press_action": {
                "action": "escape",
                "source_note": text,
            },
        }

    if normalized.startswith(("move ", "move to ", "moveto", "goto ", "go to ")):
        return {
            "source_line": line_number,
            "todo": {
                "kind": "route_shortcut",
                "suggested_step": "move_to_or_travel",
                "note": text,
                "reason": "manual note predates enhanced map/pose trace; resolve to map, pose, or travel command",
            },
        }

    if normalized.startswith(("enter ", "(enter ")):
        return {
            "source_line": line_number,
            "todo": {
                "kind": "enter_or_transition",
                "note": text,
            },
        }

    return {
        "source_line": line_number,
        "note": text,
    }


def scenario_directive_to_step(line_number: int, action: str, fields: dict[str, str]) -> dict[str, Any] | None:
    if action == "skip":
        return None

    if action == "new_game":
        return {
            "source_line": line_number,
            "new_game_flow": select_fields(fields, ("continent", "party", "source_note")),
        }

    if action == "assert_starting_items":
        return {
            "source_line": line_number,
            "assert": {
                "starting_items": True,
                "source_note": fields.get("note", "assert starting items"),
            },
        }

    if action == "assert_inventory":
        assertion = select_fields(fields, ("item_id", "owner", "source", "note"))
        return {
            "source_line": line_number,
            "assert": {
                "inventory": [assertion],
            },
        }

    if action == "close_dialog":
        return {
            "source_line": line_number,
            "press_action": {
                "action": "escape",
                "source_note": fields.get("note", "close dialogue"),
            },
        }

    if action == "travel":
        return {
            "source_line": line_number,
            "travel": select_fields(fields, ("target", "map", "method", "reason", "shortcut")),
        }

    if action == "load_map":
        return {
            "source_line": line_number,
            "load_map": select_fields(fields, ("target", "map", "scene_kind", "reason")),
        }

    if action == "enter":
        return {
            "source_line": line_number,
            "enter_door_at": select_fields(fields, ("target", "method", "reason", "note")),
        }

    if action == "save_checkpoint":
        return {
            "source_line": line_number,
            "save_checkpoint": fields.get("name", "checkpoint"),
        }

    if action == "load_checkpoint":
        return {
            "source_line": line_number,
            "load_checkpoint": fields.get("name", "checkpoint"),
        }

    if action == "save_game":
        return {
            "source_line": line_number,
            "save_game": fields.get("name", "recorded_save"),
        }

    if action == "load_game":
        return {
            "source_line": line_number,
            "load_game": fields.get("name", "recorded_save"),
        }

    if action == "advance_game_time":
        return {
            "source_line": line_number,
            "advance_game_time": select_fields(fields, ("until", "days", "months", "reason")),
        }

    if action == "setup_shortcut":
        return {
            "source_line": line_number,
            "setup_shortcut": {key: int_or_text(value) for key, value in fields.items()},
        }

    if action == "combat_loot":
        return {
            "source_line": line_number,
            "combat_loot": {key: int_or_text(value) for key, value in fields.items()},
        }

    if action == "route_note":
        return {
            "source_line": line_number,
            "note": fields.get("text", ""),
        }

    return {
        "source_line": line_number,
        "todo": {
            "kind": "unknown_scenario_directive",
            "action": action,
            "fields": {key: int_or_text(value) for key, value in fields.items()},
        },
    }


def dialog_state_from_fields(fields: dict[str, str]) -> dict[str, Any]:
    dialog = select_fields(
        fields,
        (
            "active",
            "house_dialog",
            "source_id",
            "title",
            "house_title",
            "line_count",
            "text_hash",
            "action_count",
        ),
    )

    actions_json = fields.get("actions_json", "[]")

    try:
        raw_actions = json.loads(actions_json)
    except json.JSONDecodeError:
        raw_actions = []
        dialog["actions_json_parse_error"] = actions_json

    actions: list[dict[str, Any]] = []

    if isinstance(raw_actions, list):
        for action in raw_actions:
            if not isinstance(action, dict):
                continue

            action_fields: dict[str, Any] = {}

            for key in ("index", "kind", "id", "secondary_id", "enabled", "text_only", "label"):
                if key not in action:
                    continue

                value = action[key]
                if isinstance(value, bool):
                    action_fields[key] = value
                elif isinstance(value, (int, float)):
                    action_fields[key] = int_or_text(str(value))
                else:
                    action_fields[key] = value

            if is_generated_mercenary_dialog_action(action_fields):
                action_fields.pop("label", None)

            actions.append(action_fields)

    dialog["actions"] = actions
    return dialog


def consume_dialog_close_state(state: dict[str, Any]) -> dict[str, Any] | None:
    pending = state.get("pending_dialog_close_states")

    if isinstance(pending, list) and pending:
        return pending.pop(0)

    return None


def trace_to_step(
    line_number: int,
    event: str,
    fields: dict[str, str],
    state: dict[str, Any],
    keep_duplicates: bool,
) -> dict[str, Any] | None:
    if event == "trace_session_begin":
        return {
            "source_line": line_number,
            "note": "trace_session_begin " + " ".join(
                f"{key}={value}" for key, value in sorted(fields.items())
            ),
        }

    if event == "dialog_state":
        dialog = dialog_state_from_fields(fields)
        reason = fields.get("reason", "")

        if reason == "before_topic_clicked":
            state["pending_topic_dialog_state"] = dialog
            if state.pop("pending_auto_dialog_after_arrival", False) and fields.get("source_id") == "803":
                return {
                    "source_line": line_number,
                    "speak_npc": {
                        "map": str(state.get("current_map_file", "")),
                        "source_id": int_or_text(fields.get("source_id", "803")),
                        "title": fields.get("title", ""),
                        "reason": "replay recorded automatic Verdant dialog opened by evt.SpeakNPC after map arrival",
                    },
                }
        elif reason == "before_dialog_close":
            pending = state.setdefault("pending_dialog_close_states", [])
            if isinstance(pending, list):
                pending.append(dialog)

        return None

    if event == "input_prompt_opened":
        state["pending_input_prompt_effects"] = []
        prompt = select_fields(
            fields,
            ("event_id", "continue_step", "correct_step", "text_id", "prompt", "answer_count"),
        )
        prompt_map = fields.get("map", "")
        if prompt_map and not looks_like_map_file(prompt_map) and state.get("current_map_file", ""):
            prompt_map = str(state.get("current_map_file", ""))

        return {
            "source_line": line_number,
            "assert": {
                "map": int_or_text(prompt_map) if prompt_map else state.get("current_map_file", ""),
                "input_prompt": prompt,
            },
        }

    if event == "input_prompt_answered":
        prompt = select_fields(
            fields,
            ("event_id", "continue_step", "correct_step", "text_id", "prompt", "answer_count"),
        )
        expect = select_fields(fields, ("matched", "selected_continue_step"))
        answer_step = {
            "source_line": line_number,
            "answer_input": {
                "text": int_or_text(fields.get("answer", "")),
                "expect_before": {
                    "input_prompt": prompt,
                },
                "expect": expect,
            },
        }
        pending_effects = state.pop("pending_input_prompt_effects", [])
        if isinstance(pending_effects, list) and pending_effects:
            return [answer_step, *pending_effects]
        return answer_step

    if event == "trace_marker":
        return {
            "source_line": line_number,
            "note": "manual trace marker " + str(int_or_text(fields.get("index", "0"))),
        }

    if event == "menu_action":
        return {
            "source_line": line_number,
            "note": "menu_action " + " ".join(
                f"{key}={value}" for key, value in sorted(fields.items())
            ),
        }

    if event == "load_game_screen_opened":
        return {
            "source_line": line_number,
            "note": "load_game_screen_opened " + " ".join(
                f"{key}={value}" for key, value in sorted(fields.items())
            ),
        }

    if event == "new_game_screen_opened":
        state["new_game_source"] = fields.get("source", "unknown")
        return None

    if event == "new_game_continent_selected":
        state["new_game_continent"] = select_fields(
            fields,
            ("continent_id", "continent_key", "continent_name"),
        )
        return None

    if event == "new_game_party_created":
        state["new_game_party_created"] = select_fields(
            fields,
            ("continent_id", "continent_key", "continent_name", "member_count"),
        )
        flow = dict(state.get("new_game_continent", {}))
        flow.update(state["new_game_party_created"])
        flow["source"] = state.get("new_game_source", "unknown")
        return {
            "source_line": line_number,
            "new_game_flow": flow,
        }

    if event == "new_game_party_member":
        return {
            "source_line": line_number,
            "assert": {
                "new_game_party_member": select_fields(
                    fields,
                    (
                        "member_index",
                        "name",
                        "class",
                        "role",
                        "race_id",
                        "sex_id",
                        "portrait_id",
                        "voice_id",
                        "might",
                        "intellect",
                        "personality",
                        "endurance",
                        "accuracy",
                        "speed",
                        "luck",
                    ),
                ),
            },
        }

    if event == "new_game_party_skill":
        return {
            "source_line": line_number,
            "assert": {
                "new_game_party_skill": select_fields(fields, ("member_index", "name", "level", "mastery")),
            },
        }

    if event in ("new_game_starting", "new_game_started"):
        return {
            "source_line": line_number,
            "assert": {
                event: select_fields(
                    fields,
                    ("continent_id", "continent_note", "map", "start_override", "member_count", "party"),
                ),
            },
        }

    if event == "movement_segment":
        sequence = str(fields.get("sequence", "0"))
        movement_segments = state.setdefault("movement_segments", {})
        segment = {}
        movement_segments[sequence] = segment
        segment["meta"] = typed_fields(fields)
        return movement_segment_step(line_number, segment, state)

    if event == "movement_segment_snapshot":
        sequence = str(fields.get("sequence", "0"))
        label = fields.get("label", "")
        movement_segments = state.setdefault("movement_segments", {})
        segment = movement_segments.setdefault(sequence, {})
        snapshot = select_fields(
            fields,
            (
                "map",
                "scene_kind",
                "party",
                "yaw",
                "pitch",
                "game_minutes",
                "tick_ms",
                "forward_held",
                "run_walk_modifier",
                "turbo",
                "shift",
                "ctrl",
                "alt",
                "held_item_active",
                "held_item_id",
                "outdoor_running",
                "outdoor_flying",
                "outdoor_water_walk",
                "outdoor_feather_fall",
                "outdoor_airborne",
                "outdoor_support_kind",
                "outdoor_support_bmodel",
                "outdoor_support_face",
                "indoor_grounded",
                "indoor_sector",
                "indoor_eye_sector",
                "indoor_support_face",
            ),
        )

        if label == "start":
            segment["start"] = snapshot
            return None

        if label == "stop":
            segment["stop"] = snapshot
            return movement_segment_step(line_number, segment, state)

        return {
            "source_line": line_number,
            "todo": {
                "kind": "movement_segment_snapshot",
                "sequence": int_or_text(sequence),
                "label": label,
                "snapshot": snapshot,
            },
        }

    if event == "movement_segment_status":
        return {
            "source_line": line_number,
            "todo": {
                "kind": "movement_segment_status",
                **select_fields(fields, ("sequence", "accepted", "reason", "armed", "has_start", "has_stop")),
            },
        }

    if event == "game_time_advanced":
        return {
            "source_line": line_number,
            "advance_game_time": select_fields(
                fields,
                (
                    "source",
                    "mode",
                    "minutes",
                    "before_game_minutes",
                    "after_game_minutes",
                    "game_minutes",
                ),
            ),
        }

    if event == "held_item_changed":
        state["changed_since_topic"] = True
        pending_quest_held_item_id = state.get("pending_quest_held_item_id")
        quest_like_item_ids_seen = state.setdefault("quest_like_item_ids_seen", set())
        if (
            fields.get("active") == "false"
            and (
                fields.get("item_id") == pending_quest_held_item_id
                or fields.get("item_id") in quest_like_item_ids_seen
            )
        ):
            state["pending_quest_held_item_id"] = None
            return {
                "source_line": line_number,
                "assert": {
                    "held_item": select_fields(fields, ("active", "item_id", "quantity", "grid", "source")),
                },
            }

        return {
            "source_line": line_number,
            "trace_observation": {
                "event": event,
                "fields": typed_fields(fields),
                "note": "held-item UI state is transient; quest/item acquisition is asserted through item_received",
            },
        }

    if event in ("save_game_written", "save_game_failed"):
        if event == "save_game_failed":
            return {
                "source_line": line_number,
                "todo": {
                    "kind": "save_game_failed",
                    **select_fields(fields, ("path", "map", "reason")),
                },
            }

        return {
            "source_line": line_number,
            "save_game": sanitized_checkpoint_name(fields.get("path", ""), "recorded_save"),
        }

    if event in ("load_game_started", "load_game_applied", "load_game_failed"):
        if event == "load_game_failed":
            return {
                "source_line": line_number,
                "todo": {
                    "kind": "load_game_failed",
                    **select_fields(fields, ("path", "map", "reason")),
                },
            }

        if event == "load_game_started":
            return {
                "source_line": line_number,
                "load_game": {
                    "name": sanitized_checkpoint_name(fields.get("path", ""), "recorded_save"),
                    "path": fields.get("path", ""),
                },
            }

        return {
            "source_line": line_number,
            "trace_observation": {
                "event": "load_game_applied",
                "fields": select_fields(fields, ("path", "map", "scene_kind", "game_minutes")),
            },
        }

    state_dump_match = re.fullmatch(r"state_dump_(save|load_file|load_applied)_(.+)", event)
    if state_dump_match:
        phase = state_dump_match.group(1)
        kind = state_dump_match.group(2)

        if kind in ("begin", "end"):
            return {
                "source_line": line_number,
                "note": f"state_dump_{phase}_{kind} path={fields.get('path', '')}",
            }

        if kind == "qbit":
            return {
                "source_line": line_number,
                "assert": {
                    "qbit_set": [int_or_text(fields.get("id", "TODO"))],
                },
            }

        if kind == "party_award":
            award = select_fields(fields, ("member_index", "award_id"))
            if "award_id" in award:
                award["id"] = award.pop("award_id")

            return {
                "source_line": line_number,
                "assert": {
                    "award_acquired": [award],
                },
            }

        if kind in ("party_inventory", "party_equipped"):
            if fields.get("quest_like") != "true":
                return None

            assertion_name = "inventory" if kind == "party_inventory" else "equipped_item"
            return {
                "source_line": line_number,
                "assert": {
                    assertion_name: [
                        select_fields(
                            fields,
                            (
                                "item_id",
                                "item_name",
                                "member_index",
                                "grid",
                                "slot",
                                "quantity",
                                "identified",
                                "broken",
                                "stolen",
                                "standard_enchant_id",
                                "special_enchant_id",
                                "artifact_id",
                                "charges",
                            ),
                        )
                    ],
                },
            }

        if kind in ("map_var", "named_map_var", "named_global_var", "party_event_var", "hireling"):
            return {
                "source_line": line_number,
                "assert": {
                    f"state_dump_{kind}": select_fields(
                        fields,
                        (
                            "map",
                            "scene_kind",
                            "index",
                            "name",
                            "id",
                            "value",
                            "npc_id",
                            "profession_id",
                            "weekly_cost",
                        ),
                    ),
                },
            }

        if kind in ("party", "party_member", "party_skill"):
            return {
                "source_line": line_number,
                "assert": {
                    f"state_dump_{kind}": typed_fields(fields),
                },
            }

        return {
            "source_line": line_number,
            "assert": {
                f"state_dump_{kind}": typed_fields(fields),
            },
        }

    if is_volatile_map_var_changed(event, fields) or is_volatile_named_global_var_changed(event, fields):
        return {
            "source_line": line_number,
            "trace_observation": {
                "event": event,
                "fields": typed_fields(fields),
                "note": "timer/bootstrap-driven variable; not converted to a hard replay assertion",
            },
        }

    hive_combat_step = hive_named_map_var_combat_step(line_number, event, fields, state)
    if hive_combat_step is not None:
        state["changed_since_topic"] = True
        return hive_combat_step

    if event in ("map_var_changed", "decor_var_changed", "named_map_var_changed", "named_global_var_changed"):
        state["changed_since_topic"] = True
        return {
            "source_line": line_number,
            "assert": {
                event: select_fields(
                    fields,
                    ("map", "scene_kind", "operation", "index", "name", "previous", "current"),
                ),
            },
        }

    if event == "actor_quest_item_death":
        state["changed_since_topic"] = True
        combat_loot = select_fields(
            fields,
            (
                "scene_kind",
                "map",
                "actor_index",
                "actor_id",
                "monster_id",
                "name",
                "delivery",
                "pos",
                "item_id",
                "item_name",
                "quest_like",
            ),
        )
        normalize_step_map_for_replay(combat_loot, state)

        if fields.get("delivery") == "corpse":
            key = corpse_quest_loot_key(fields, state)
            if key is not None:
                synthetic_keys = state.setdefault("synthetic_combat_looted_corpse_items", set())
                if isinstance(synthetic_keys, set):
                    synthetic_keys.add(key)

        return {
            "source_line": line_number,
            "combat_loot": combat_loot,
        }

    if event in ("corpse_contains_quest_item", "chest_contains_quest_item", "world_item_spawned"):
        state["changed_since_topic"] = True
        if fields.get("quest_like") == "false":
            return None

        if fields.get("item_id"):
            state.setdefault("quest_like_item_ids_seen", set()).add(fields.get("item_id"))

        if event == "chest_contains_quest_item" and not trace_map_matches_current(fields, state):
            return out_of_current_map_observation(event, line_number, fields)

        observation = select_fields(
            fields,
            (
                "scene_kind",
                "map",
                "actor_index",
                "actor_id",
                "monster_id",
                "name",
                "corpse_index",
                "chest_id",
                "world_item_index",
                "item_id",
                "item_name",
                "quest_like",
                "pos",
                "grid",
            ),
        )
        observation_map = str(observation.get("map", ""))
        current_map_file = str(state.get("current_map_file", ""))
        if observation_map and not looks_like_map_file(observation_map) and current_map_file:
            observation["map"] = current_map_file

        return {
            "source_line": line_number,
            "assert": {
                event: observation,
            },
        }

    if event == "chest_opened":
        state["changed_since_topic"] = True
        if not trace_map_matches_current(fields, state):
            return out_of_current_map_observation(event, line_number, fields)

        return {
            "source_line": line_number,
            "assert": {
                "chest_opened": select_fields(
                    fields,
                    ("scene_kind", "map", "chest_id"),
                ),
            },
        }

    if event == "chest_contains_item":
        state["changed_since_topic"] = True
        if fields.get("quest_like") != "true":
            return None

        if not trace_map_matches_current(fields, state):
            return out_of_current_map_observation(event, line_number, fields)

        item_visible = select_fields(
            fields,
            (
                "scene_kind",
                "map",
                "chest_id",
                "item_id",
                "item_name",
                "quest_like",
                "grid",
            ),
        )
        item_visible["source"] = "chest"
        return {
            "source_line": line_number,
            "assert": {
                "item_visible": item_visible,
            },
        }

    if event == "actor_dialog_started":
        state["changed_since_topic"] = True
        return {
            "source_line": line_number,
            "assert": {
                "actor_dialog_started": select_fields(
                    fields,
                    (
                        "kind",
                        "map",
                        "npc_id",
                        "source_id",
                        "host_house_id",
                        "actor_index",
                        "party",
                        "yaw",
                        "pitch",
                    ),
                ),
            },
        }

    if event in ("map_transition_requested", "map_transition_confirmed", "map_transition_canceled"):
        state["changed_since_topic"] = True
        destination_map = fields.get("destination_map", "")
        if event != "map_transition_canceled" and destination_map and looks_like_map_file(destination_map):
            state["pending_explicit_map_load"] = destination_map

        assertion = {
            "source_line": line_number,
            "assert": {
                event: select_fields(
                    fields,
                    (
                        "source_kind",
                        "source_id",
                        "action_id",
                        "event_id",
                        "route_index",
                        "confirmation_required",
                        "destination_map",
                        "destination_name",
                        "travel_days",
                        "use_start_position",
                        "pos",
                        "direction_degrees",
                    ),
                ),
            },
        }

        if event == "map_transition_requested" and fields.get("source_kind") == "map_boundary":
            return [
                {
                    "source_line": line_number,
                    "setup_shortcut": {
                        "kind": "map_transition_prompt",
                        "source_id": int_or_text(fields.get("source_id", "TODO")),
                    },
                },
                assertion,
            ]

        return assertion

    if event == "pose_snapshot":
        pose = pose_from_trace_fields(fields)
        if pose is not None:
            return {
                "source_line": line_number,
                "set_pose": pose,
                "note": "recorded pose snapshot " + fields.get("label", ""),
            }

        return {
            "source_line": line_number,
            "todo": {
                "kind": "pose_snapshot",
                "snapshot": select_fields(fields, ("label", "map", "scene_kind", "party", "yaw", "pitch")),
            },
        }

    if event == "actor_inspect":
        actor_visible = select_fields(
            fields,
            (
                "world",
                "map",
                "actor_index",
                "name",
                "monster_id",
                "current_hp",
                "max_hp",
                "group",
                "dead",
                "party",
                "yaw",
                "pitch",
                "actor_pos",
            ),
        )
        normalize_step_map_for_replay(actor_visible, state)
        return {
            "source_line": line_number,
            "trace_observation": {
                "event": "actor_inspect",
                "fields": actor_visible,
                "note": "RMB actor inspect is diagnostic metadata; quest-critical actors are asserted through combat/loot traces",
            },
        }

    if event == "topic_clicked":
        signature = (
            fields.get("kind", ""),
            fields.get("source_id", ""),
            fields.get("action_id", ""),
            fields.get("secondary_id", ""),
            fields.get("selection_index", ""),
        )
        if not keep_duplicates and state.get("last_topic_signature") == signature and not state.get("changed_since_topic"):
            state["pending_topic_dialog_state"] = None
            return None

        topic_step = {
            "source_line": line_number,
            "select_topic": select_fields(
                fields,
                (
                    "kind",
                    "source_id",
                    "action_id",
                    "secondary_id",
                    "selection_index",
                    "house_dialog",
                    "enabled",
                    "label",
                ),
            ),
        }
        pending_topic_dialog = state.pop("pending_topic_dialog_state", None)

        if isinstance(pending_topic_dialog, dict):
            topic_step["select_topic"]["expect_before"] = {
                "dialog": pending_topic_dialog,
            }

        steps = []
        last_topic = state.get("last_topic", {})
        if (
            fields.get("kind") == "house_resident"
            and last_topic.get("kind") == "npc_topic"
            and last_topic.get("house_dialog") == "false"
        ):
            press_action = {
                "action": "cancel_dialog",
                "note": "return from recorded NPC dialog to parent house dialog",
            }
            close_dialog = consume_dialog_close_state(state)

            if isinstance(close_dialog, dict):
                press_action["expect_before"] = {
                    "dialog": close_dialog,
                }

            steps.append(
                {
                    "source_line": line_number,
                    "press_action": press_action,
                }
            )

        steps.append(topic_step)
        state["last_topic_signature"] = signature
        state["last_topic"] = fields.copy()
        state["changed_since_topic"] = False
        return steps

    if event == "interact":
        update_current_map_display_from_fields(fields, state)

        if fields.get("can_activate") != "true":
            return {
                "source_line": line_number,
                "trace_observation": {
                    "event": event,
                    "fields": typed_fields(fields),
                    "note": "not converted to a replay action because the recorded interaction could not activate",
                },
            }

        step_name = "interact_target"
        if fields.get("kind") == "actor":
            step_name = "interact_actor"

        interaction = select_fields(
            fields,
            (
                "method",
                "map",
                "scene_kind",
                "has_hit",
                "can_activate",
                "kind",
                "target_kind",
                "target_index",
                "face_index",
                "triggered_event",
                "trigger",
                "actor_index",
                "name",
                "npc_id",
                "group",
                "friendly",
                "world_item_index",
                "item_id",
                "sprite_id",
                "source_index",
                "distance",
                "hit",
            ),
        )
        interaction_map = str(interaction.get("map", ""))
        current_map_file = str(state.get("current_map_file", ""))
        if interaction_map and not looks_like_map_file(interaction_map) and current_map_file:
            interaction["map"] = current_map_file

        pose = pose_from_trace_fields(fields)
        if pose is not None:
            normalize_pose_map_for_replay(pose, state)
            interaction["pose"] = pose

        step = {
            "source_line": line_number,
            step_name: interaction,
        }

        if pose is None:
            step["todo"] = "add set_pose/face or replace target ids with stable aliases before this becomes final"

        return step

    if event == "house_extra_exit":
        state["changed_since_topic"] = True
        destination_map = fields.get("destination_map", "")
        if destination_map and looks_like_map_file(destination_map):
            state["pending_explicit_map_load"] = destination_map

        exit_step = select_fields(
            fields,
            (
                "source_id",
                "action_id",
                "label",
                "destination_map",
                "destination_name",
                "destination_map_id",
                "required_qbit",
                "pos",
            ),
        )
        exit_step["method"] = "house_service"
        exit_step["map"] = fields.get("destination_map", "TODO")
        exit_step["target"] = fields.get("destination_name", fields.get("label", "TODO"))
        return {
            "source_line": line_number,
            "enter_door_at": exit_step,
        }

    if event == "console_debug_map_load_travel":
        if fields.get("map"):
            state["current_map_file"] = fields["map"]
        update_current_map_display_from_fields(fields, state)
        load_step = select_fields(
            fields,
            (
                "target",
                "map",
                "map_id",
                "scene_kind",
                "start_override",
                "pos",
                "direction_degrees",
            ),
        )
        load_step["method"] = "debug_console_map_load_travel"
        load_step["reason"] = "recorded route used debug console map load/travel shortcut"
        return {
            "source_line": line_number,
            "load_map": load_step,
        }

    if event == "map_loaded":
        map_name = fields.get("map", "TODO")
        previous_map_name = str(state.get("current_map_file", ""))
        pending_explicit_map_load = str(state.get("pending_explicit_map_load", ""))
        matches_pending_explicit_load = (
            pending_explicit_map_load
            and normalized_map_name(pending_explicit_map_load) == normalized_map_name(map_name)
        )

        if looks_like_map_file(map_name):
            state["current_map_file"] = map_name
        if matches_pending_explicit_load:
            state["pending_explicit_map_load"] = ""
        update_current_map_display_from_fields(fields, state)
        if fields.get("source") == "debug_console":
            return None

        if (
            previous_map_name
            and looks_like_map_file(previous_map_name)
            and looks_like_map_file(map_name)
            and normalized_map_name(previous_map_name) != normalized_map_name(map_name)
            and not matches_pending_explicit_load
        ):
            load_step = {
                "map": map_name,
                "scene_kind": fields.get("scene_kind", "TODO"),
                "target": map_name,
                "method": "observed_map_load",
                "reason": (
                    "recorded map_loaded changed maps without an explicit converted transition; "
                    "using a load shortcut for an untraced teleport/session continuation"
                ),
            }
            if "game_minutes" in fields:
                load_step["game_minutes"] = int_or_text(fields["game_minutes"])
            return {
                "source_line": line_number,
                "load_map": load_step,
            }

        return {
            "source_line": line_number,
            "assert": {
                "map_loaded": map_name,
                "scene_kind": fields.get("scene_kind", "TODO"),
                **({"game_minutes": int_or_text(fields["game_minutes"])} if "game_minutes" in fields else {}),
            },
        }

    if event == "map_arrived":
        if fields.get("map") and looks_like_map_file(fields["map"]):
            state["current_map_file"] = fields["map"]
        update_current_map_display_from_fields(fields, state)
        if (
            normalized_map_name(fields.get("previous_map", "")) == "hive.blv"
            and normalized_map_name(fields.get("map", "")) == "oute3.odm"
        ):
            state["pending_auto_dialog_after_arrival"] = True
        return {
            "source_line": line_number,
            "assert": {
                "map_arrived": select_fields(
                    fields,
                    (
                        "previous_map",
                        "map",
                        "same_map",
                        "source_kind",
                        "source_id",
                        "action_id",
                        "event_id",
                        "destination_name",
                        "use_start_position",
                        "pos",
                        "direction_degrees",
                    ),
                )
            },
        }

    if event in ("qbit_set", "qbit_cleared"):
        state["changed_since_topic"] = True
        key = "qbit_set" if event == "qbit_set" else "qbit_clear"
        return {
            "source_line": line_number,
            "assert": {
                key: [int_or_text(fields.get("id", "TODO"))],
            },
        }

    if event in ("award_acquired", "award_cleared"):
        state["changed_since_topic"] = True
        key = "award_acquired" if event == "award_acquired" else "award_cleared"
        return {
            "source_line": line_number,
            "assert": {
                key: [select_fields(fields, ("id", "member_index", "scope"))],
            },
        }

    if event == "hireling_hired":
        state["changed_since_topic"] = True
        return {
            "source_line": line_number,
            "assert": {
                "follower_hired": [select_fields(fields, ("npc_id", "profession_id", "weekly_cost"))],
            },
        }

    if event == "hireling_left":
        state["changed_since_topic"] = True
        return {
            "source_line": line_number,
            "assert": {
                "follower_left": [select_fields(fields, ("npc_id", "profession_id", "weekly_cost"))],
            },
        }

    if event == "item_received":
        state["changed_since_topic"] = True
        if fields.get("quest_like") != "true":
            return None

        if fields.get("destination") == "held":
            state["pending_quest_held_item_id"] = fields.get("item_id")
            state.setdefault("quest_like_item_ids_seen", set()).add(fields.get("item_id"))

        if fields.get("source") == "event" and fields.get("item_id") in ("2170", "2171", "2172", "2173"):
            state["suppress_next_memory_crystal_dialog_cancel"] = True

        return {
            "source_line": line_number,
            "assert": {
                "item_received": select_fields(
                    fields,
                    (
                        "destination",
                        "source",
                        "item_id",
                        "item_name",
                        "quest_like",
                        "grid",
                        "corpse_index",
                        "loot_item_index",
                        "world_item_index",
                        "member_index",
                    ),
                ),
            },
        }

    if event == "gold_received":
        return None

    if event == "item_inspect":
        item_visible = select_fields(
            fields,
            (
                "item_id",
                "item_name",
                "quest_like",
                "source",
                "map",
                "scene_kind",
                "party",
                "yaw",
                "pitch",
                "member_index",
                "grid",
                "equipment_slot",
                "world_item_index",
                "loot_item_index",
            ),
        )
        normalize_step_map_for_replay(item_visible, state)

        if fields.get("quest_like") != "true":
            return {
                "source_line": line_number,
                "trace_observation": {
                    "event": event,
                    "fields": typed_fields({**fields, "map": str(item_visible.get("map", fields.get("map", "")))}),
                    "note": "not converted to an assertion because the inspected item is not quest-like",
                },
            }

        return {
            "source_line": line_number,
            "assert": {
                "item_visible": item_visible,
            },
        }

    if event == "mechanism_triggered":
        remaining_hive_post_combat_triggers = int(state.get("hive_post_combat_mechanism_triggers_remaining", 0))
        if remaining_hive_post_combat_triggers > 0:
            state["hive_post_combat_mechanism_triggers_remaining"] = remaining_hive_post_combat_triggers - 1
            return {
                "source_line": line_number,
                "trace_observation": {
                    "event": event,
                    "fields": typed_fields(fields),
                    "note": "post-reactor mechanism already reaches final state during scenario combat advance",
                },
            }

        return {
            "source_line": line_number,
            "assert_mechanism": select_fields(
                fields,
                (
                    "kind",
                    "id",
                    "action",
                    "raw_action",
                    "previous_state",
                    "new_state",
                    "was_moving",
                    "moving",
                    "door_slot",
                    "move_length",
                    "open_speed",
                    "close_speed",
                    "model",
                    "bmodel_index",
                    "move_time_ms",
                    "delta",
                    "move_party",
                ),
            ),
        }

    if event == "mechanism_stopped":
        return {
            "source_line": line_number,
            "assert_mechanism": select_fields(fields, ("id", "state", "was_moving")),
        }

    if event == "mechanism_completed":
        return {
            "source_line": line_number,
            "wait_until": {
                "timeout_runtime_seconds": round(float(fields.get("elapsed_seconds", "0")) + 0.5, 3),
                "assert": {
                    "mechanism": select_fields(
                        fields,
                        (
                            "kind",
                            "id",
                            "state",
                            "door_slot",
                            "move_length",
                            "open_speed",
                            "close_speed",
                            "model",
                            "bmodel_index",
                            "move_time_ms",
                            "delta",
                            "move_party",
                        ),
                    )
                },
            },
        }

    if event == "pressure_plate_triggered":
        pressure = select_fields(
            fields,
            (
                "world",
                "event_id",
                "face_index",
                "bmodel_index",
            ),
        )
        signature = (
            str(pressure.get("world", "")),
            str(pressure.get("event_id", "")),
            str(pressure.get("face_index", "")),
            str(pressure.get("bmodel_index", "")),
        )
        if state.get("last_pressure_plate_signature") == signature:
            pressure["force_replay"] = True
        state["last_pressure_plate_signature"] = signature

        return {
            "source_line": line_number,
            "assert": {
                "pressure_plate_triggered": pressure,
            },
        }

    if event == "dialogue_canceled":
        if state.pop("suppress_next_memory_crystal_dialog_cancel", False):
            consume_dialog_close_state(state)
            return {
                "source_line": line_number,
                "trace_observation": {
                    "event": "dialogue_canceled",
                    "fields": typed_fields(fields),
                    "note": "ignored stale memory-crystal pickup dialog recorded before the event was corrected",
                },
            }

        expected = select_fields(fields, ("kind", "active_source_id", "house_dialog", "action_count"))
        steps = []
        last_topic = state.get("last_topic", {})
        if (
            fields.get("kind") == "house_service"
            and last_topic.get("kind") == "npc_topic"
            and last_topic.get("house_dialog") == "false"
        ):
            press_action = {
                "action": "cancel_dialog",
                "note": "return from recorded NPC dialog to parent house dialog",
            }
            close_dialog = consume_dialog_close_state(state)

            if isinstance(close_dialog, dict):
                press_action["expect_before"] = {
                    "dialog": close_dialog,
                }

            steps.append(
                {
                    "source_line": line_number,
                    "press_action": press_action,
                }
            )

        press_action = {
            "action": "cancel_dialog",
            "expect": {
                "dialogue_canceled": expected,
            },
        }
        close_dialog = consume_dialog_close_state(state)

        if isinstance(close_dialog, dict):
            press_action["expect_before"] = {
                "dialog": close_dialog,
            }

        steps.extend([
            {
                "source_line": line_number,
                "press_action": press_action,
            },
            {
                "source_line": line_number,
                "assert": {
                    "dialogue_canceled": expected,
                },
            },
        ])
        state["last_topic"] = {}
        return steps

    return {
        "source_line": line_number,
        "trace_observation": {
            "event": event,
            "fields": typed_fields(fields),
        },
    }


def convert(path: Path, args: argparse.Namespace) -> dict[str, Any]:
    text = read_text(path)
    steps: list[dict[str, Any]] = []
    state: dict[str, Any] = {
        "last_topic_signature": None,
        "changed_since_topic": False,
        "pending_debug_map_load_effects": [],
        "debug_console_map_loaded_seen": False,
        "state_dump_bundle": None,
        "pending_actor_interaction": None,
        "pending_topic_dialog_state": None,
        "pending_dialog_close_states": [],
    }

    def append_step(step: Any) -> None:
        if isinstance(step, list):
            steps.extend(step)
        elif step:
            steps.append(step)

    def flush_pending_actor_interaction() -> None:
        pending = state.get("pending_actor_interaction")
        if pending:
            steps.append(pending)
            state["pending_actor_interaction"] = None

    def flush_pending_debug_map_load_effects() -> None:
        pending = state.get("pending_debug_map_load_effects", [])
        if pending:
            steps.extend(pending)
            pending.clear()

    def flush_state_dump_bundle(end_line: int | None = None) -> None:
        bundle = state.get("state_dump_bundle")
        if not isinstance(bundle, dict):
            return

        step = state_dump_bundle_step(bundle, end_line)
        if step:
            steps.append(step)
        state["state_dump_bundle"] = None

    for line_number, line in enumerate(text.splitlines(), start=1):
        stripped = line.strip()
        directive = parse_scenario_directive(stripped)
        trace = parse_trace(stripped)

        if trace:
            event, fields = trace
            update_last_game_minutes(fields, state)
            state_dump_parts = state_dump_event_parts(event)

            if state_dump_parts:
                phase, kind = state_dump_parts

                if kind == "begin":
                    flush_pending_actor_interaction()
                    flush_pending_debug_map_load_effects()
                    flush_state_dump_bundle(line_number - 1)
                    state["state_dump_bundle"] = {
                        "source_line": line_number,
                        "phase": phase,
                        "path": fields.get("path", ""),
                        "records": [],
                    }
                    continue

                if kind == "end":
                    flush_pending_debug_map_load_effects()
                    flush_state_dump_bundle(line_number)
                    continue

                bundle = state.get("state_dump_bundle")
                if not isinstance(bundle, dict) or bundle.get("phase") != phase:
                    flush_pending_debug_map_load_effects()
                    flush_state_dump_bundle(line_number - 1)
                    bundle = {
                        "source_line": line_number,
                        "phase": phase,
                        "path": fields.get("path", ""),
                        "records": [],
                    }
                    state["state_dump_bundle"] = bundle

                bundle["records"].append(
                    {
                        "source_line": line_number,
                        "kind": kind,
                        "fields": typed_fields(fields),
                    }
                )
                continue

            if event == "map_loaded" and fields.get("source") == "debug_console":
                state["debug_console_map_loaded_seen"] = True
                continue

            if event == "console_debug_map_load_travel" and state.get("debug_console_map_loaded_seen"):
                flush_pending_actor_interaction()
                step = trace_to_step(line_number, event, fields, state, args.keep_duplicates)
                step = attach_recorded_game_minutes(step, event, fields)
                append_step(step)
                flush_pending_debug_map_load_effects()
                state["debug_console_map_loaded_seen"] = False
                continue

            if event not in ("qbit_set", "qbit_cleared"):
                flush_pending_debug_map_load_effects()

            state["debug_console_map_loaded_seen"] = False

        if directive:
            flush_pending_actor_interaction()
            flush_state_dump_bundle(line_number - 1)
            flush_pending_debug_map_load_effects()
            action, fields = directive
            step = scenario_directive_to_step(line_number, action, fields)
        elif trace:
            event, fields = trace

            if (
                event == "corpse_contains_quest_item"
                and fields.get("quest_like") == "true"
                and is_synthetic_combat_looted_corpse_item(fields, state)
            ):
                state["pending_actor_interaction"] = None
                step = combat_looted_corpse_observation(event, line_number, fields)
                step = attach_recorded_game_minutes(step, event, fields)
                append_step(step)
                continue

            if (
                event == "item_received"
                and fields.get("source") == "corpse"
                and fields.get("quest_like") == "true"
                and is_synthetic_combat_looted_corpse_item(fields, state)
            ):
                step = combat_looted_corpse_observation(event, line_number, fields)
                step = attach_recorded_game_minutes(step, event, fields)
                append_step(step)
                continue

            if event == "gold_received":
                pending = state.get("pending_actor_interaction")
                corpse_index = int_or_text(fields.get("corpse_index", ""))
                if pending and fields.get("source") == "corpse" and actor_interaction_index(pending) == corpse_index:
                    state["pending_actor_interaction"] = None
                else:
                    flush_pending_actor_interaction()

                step = trace_to_step(line_number, event, fields, state, args.keep_duplicates)
                step = attach_recorded_game_minutes(step, event, fields)
                append_step(step)
                continue

            if event in ("item_received", "corpse_contains_quest_item") and fields.get("quest_like") == "true":
                flush_pending_actor_interaction()
            elif event not in ("item_received", "corpse_contains_quest_item"):
                flush_pending_actor_interaction()

            step = trace_to_step(line_number, event, fields, state, args.keep_duplicates)
            step = attach_recorded_game_minutes(step, event, fields)

            prompt_effect_events = {
                "map_var_changed",
                "decor_var_changed",
                "named_map_var_changed",
                "named_global_var_changed",
                "qbit_set",
                "qbit_cleared",
                "award_acquired",
                "item_received",
                "held_item_changed",
                "mechanism_triggered",
            }
            pending_prompt_effects = state.get("pending_input_prompt_effects")
            if isinstance(pending_prompt_effects, list) and event in prompt_effect_events:
                pending_prompt_effects.append(step)
                continue

            if event in ("qbit_set", "qbit_cleared"):
                state["pending_debug_map_load_effects"].append(step)
                continue

            if (
                event == "interact"
                and fields.get("kind") == "actor"
                and isinstance(step, dict)
                and "interact_actor" in step
            ):
                flush_pending_actor_interaction()
                state["pending_actor_interaction"] = step
                continue
        else:
            flush_pending_actor_interaction()
            flush_state_dump_bundle(line_number - 1)
            flush_pending_debug_map_load_effects()
            step = manual_line_to_step(line_number, stripped, args.include_bug_notes)

        append_step(step)

    flush_pending_actor_interaction()
    flush_state_dump_bundle()
    flush_pending_debug_map_load_effects()

    return {
        "id": args.id,
        "title": args.title,
        "world": args.world,
        "mode": args.mode,
        "tags": [args.world, "draft", "playthrough_trace"],
        "source": {
            "path": str(path),
            "note": "Generated draft. Sanitize aliases, poses, shortcuts, and checkpoints before using as a runnable scenario.",
        },
        "steps": steps,
    }


def quote_directive_value(value: str) -> str:
    if re.fullmatch(r"[A-Za-z0-9_./:+-]+", value):
        return value

    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def scenario_line(action: str, **fields: str) -> str:
    tokens = [SCENARIO_PREFIX, action]

    for key, value in fields.items():
        tokens.append(f"{key}={quote_directive_value(value)}")

    return " ".join(tokens)


def normalize_manual_line(line: str, save_state: dict[str, int]) -> str | None:
    text = line.strip()
    if not text or is_noise(text) or looks_like_bug_note(text):
        return None

    normalized = text.lower().strip("- ")

    travel_targets: dict[str, tuple[str, str]] = {
        "bootleg bay": ("Bootleg Bay", "outc1.odm"),
        "free haven": ("Free Haven", "outc2.odm"),
        "frozen highlands": ("Frozen Highlands", "outd2.odm"),
        "kriegspier": ("Kriegspire", "outb1.odm"),
        "kriegspire": ("Kriegspire", "outb1.odm"),
        "white cap": ("White Cap", "outa1.odm"),
        "silver cove": ("Silver Cove", "outd1.odm"),
        "new sorpigal": ("New Sorpigal", "oute3.odm"),
        "castle ironfist": ("Castle Ironfist", "outd3.odm"),
        "mire of the damned": ("Mire of the Damned", "outa2.odm"),
        "blackshire": ("Blackshire", "outb2.odm"),
        "silver helm outpost": ("Silver Helm Outpost", "6d07.blv"),
        "superior temple of baa": ("Superior Temple of Baa", "6t7.blv"),
        "supreme baa temple": ("Superior Temple of Baa", "6t7.blv"),
    }

    if normalized == "new game":
        return scenario_line("new_game", continent="enroth", party="mm6_story_any", source_note=text)

    if normalized in ("select enroth", "create party", "start"):
        return None

    if normalized == "ensure starting items":
        return scenario_line("assert_starting_items", note=text)

    if normalized.startswith("ensure "):
        item_match = re.search(r"item id (\d+)", normalized)
        if item_match:
            return scenario_line("assert_inventory", item_id=item_match.group(1), owner="any_member", note=text)
        return scenario_line("route_note", text=text)

    if normalized in ("close dialog", "close dialogue"):
        return scenario_line("close_dialog", note=text)

    if normalized == "(enter sewer)":
        return scenario_line("enter", target="Free Haven Sewer", method="house_service", note=text)

    if normalized == "save game":
        save_state["save"] += 1
        save_state["last_save"] = save_state["save"]
        return scenario_line("save_checkpoint", name=f"manual_save_{save_state['save']}")

    if normalized == "load game":
        checkpoint = save_state.get("last_save", save_state["save"])
        return scenario_line("load_checkpoint", name=f"manual_save_{checkpoint}")

    if normalized == "wait until april":
        return scenario_line(
            "advance_game_time",
            until="April",
            reason="Nicolai circus availability gate",
        )

    if "item_id=2126" in normalized:
        return scenario_line(
            "assert_inventory",
            item_id="2126",
            owner="any_member",
            source="corpse_or_ground_loot",
            note="message scroll from Flambeaux route",
        )

    if "train 10 levels" in normalized:
        return scenario_line(
            "setup_shortcut",
            kind="train_levels",
            member_index="0",
            levels="10",
            expected_level="11",
            reason="route speed; training mechanics should be covered separately",
        )

    if "perception level 4 expert" in normalized:
        return scenario_line(
            "setup_shortcut",
            kind="set_skill",
            member_index="0",
            skill="perception",
            level="4",
            mastery="expert",
            reason="route speed; guild/trainer flow should be covered separately",
        )

    if "supreme baa temple" in normalized:
        return scenario_line(
            "load_map",
            target="Superior Temple of Baa",
            map="6t7.blv",
            scene_kind="indoor",
            reason="manual route shortcut to recorded dungeon segment",
        )

    if "likely kill" in normalized:
        return scenario_line(
            "combat_loot",
            target="Priest of Baa",
            expected_item_id="2187",
            note=text,
            method="manual_kill_then_loot",
            reason="script should turn this actor into a lootable monster that drops the key",
        )

    if "maybe this guy had the key" in normalized:
        return scenario_line(
            "combat_loot",
            target="Priest of Baa",
            expected_item_id="2112",
            note=text,
            method="manual_kill_then_loot",
            reason="script should turn this actor into a lootable monster that drops the key",
        )

    if normalized.startswith(("move ", "move to ", "moveto", "goto ", "go to ")):
        method = "route_shortcut"
        if "odm travel" in normalized:
            method = "odm_edge"
        elif "by foot" in normalized:
            method = "map_transition"

        target_text = normalized
        for prefix in ("move to ", "moveto ", "goto ", "go to ", "move "):
            if target_text.startswith(prefix):
                target_text = target_text[len(prefix) :]
                break

        target_text = target_text.replace(" by odm travel", "").replace(" by foot", "").strip()
        target, map_name = travel_targets.get(target_text, (target_text.title(), "TODO"))

        if target_text == "silver helm outpost":
            return scenario_line(
                "load_map",
                target="Silver Helm Outpost",
                map="6d07.blv",
                scene_kind="indoor",
                reason="manual route shortcut to recorded dungeon segment",
            )

        return scenario_line(
            "travel",
            target=target,
            map=map_name,
            method=method,
            shortcut="true",
            reason="manual route note predates enhanced map/pose trace",
        )

    return scenario_line("route_note", text=text)


def write_normalized_notes(input_path: Path, output_path: Path) -> None:
    save_state = {"save": 0, "last_save": 0}
    output_lines: list[str] = []

    for line in read_text(input_path).splitlines():
        stripped = line.strip()
        if parse_trace(stripped) or parse_scenario_directive(stripped):
            output_lines.append(stripped)
            continue

        normalized = normalize_manual_line(stripped, save_state)
        if normalized:
            output_lines.append(normalized)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(output_lines) + "\n", encoding="utf-8")


def yaml_scalar(value: Any) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    if value is None:
        return "null"

    text = str(value)
    if text == "":
        return '""'

    if re.fullmatch(r"[A-Za-z0-9_./:+-]+", text) and text not in ("true", "false", "null", "none"):
        return text

    escaped = text.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def render_yaml(value: Any, indent: int = 0) -> list[str]:
    prefix = " " * indent

    if isinstance(value, dict):
        lines: list[str] = []
        for key, child in value.items():
            if child == []:
                lines.append(f"{prefix}{key}: []")
                continue
            if child == {}:
                lines.append(f"{prefix}{key}: {{}}")
                continue

            if isinstance(child, (dict, list)):
                lines.append(f"{prefix}{key}:")
                lines.extend(render_yaml(child, indent + 2))
            else:
                lines.append(f"{prefix}{key}: {yaml_scalar(child)}")
        return lines

    if isinstance(value, list):
        lines = []
        for child in value:
            if isinstance(child, dict):
                child_items = list(child.items())
                if not child_items:
                    lines.append(f"{prefix}- {{}}")
                    continue

                first_key, first_value = child_items[0]
                if isinstance(first_value, (dict, list)):
                    lines.append(f"{prefix}- {first_key}:")
                    lines.extend(render_yaml(first_value, indent + 4))
                else:
                    lines.append(f"{prefix}- {first_key}: {yaml_scalar(first_value)}")

                for key, nested in child_items[1:]:
                    if isinstance(nested, (dict, list)):
                        lines.append(f"{prefix}  {key}:")
                        lines.extend(render_yaml(nested, indent + 4))
                    else:
                        lines.append(f"{prefix}  {key}: {yaml_scalar(nested)}")
            elif isinstance(child, list):
                lines.append(f"{prefix}-")
                lines.extend(render_yaml(child, indent + 2))
            else:
                lines.append(f"{prefix}- {yaml_scalar(child)}")
        return lines

    return [f"{prefix}{yaml_scalar(value)}"]


def main() -> int:
    args = parse_args()

    if args.write_normalized_notes:
        write_normalized_notes(args.input, args.write_normalized_notes)
        return 0

    document = convert(args.input, args)
    output = "\n".join(render_yaml(document)) + "\n"

    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(output, encoding="utf-8")
    else:
        sys.stdout.write(output)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
