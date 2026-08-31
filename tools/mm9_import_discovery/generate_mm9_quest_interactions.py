#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import json
import re
from collections import deque
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml

from mm9_scr_to_lua import parse_scr


MM9_QBIT_BASE = 90000
KEY_COLUMNS = {
    "required": (6, 8, 10, 12, 14),
    "granted": (15, 16, 17, 18, 19),
    "forbidden": (20, 21, 22, 23, 24),
    "removed": (25, 26, 27, 28, 29),
}


class StableDumper(yaml.SafeDumper):
    def ignore_aliases(self, data: Any) -> bool:
        return True


@dataclass(frozen=True)
class RudeRow:
    row_index: int
    rude_id: int
    node_id: int
    choice_slot: int
    next_node: int
    source_line: int
    required: tuple[int, ...]
    granted: tuple[int, ...]
    forbidden: tuple[int, ...]
    removed: tuple[int, ...]


def qbit(raw_key: str, source: str) -> int | None:
    try:
        value = int(raw_key)
    except ValueError as exception:
        raise ValueError(f"{source}: invalid quest key {raw_key!r}") from exception
    if value == 0:
        return None
    if value < 1 or value > 9999:
        raise ValueError(f"{source}: quest key {value} is outside 1-9999")
    return MM9_QBIT_BASE + value


def key_group(columns: list[str], indices: tuple[int, ...], source: str) -> tuple[int, ...]:
    result: list[int] = []
    for index in indices:
        value = qbit(columns[index], source)
        if value is not None and value not in result:
            result.append(value)
    return tuple(result)


def load_rude_file(path: Path) -> list[RudeRow]:
    with path.open(newline="", encoding="latin-1") as source_file:
        records = list(csv.reader(source_file))
    rows: list[RudeRow] = []
    for row_index, columns in enumerate(records):
        source_line = row_index + 1
        source = f"{path.as_posix()}:{source_line}"
        if len(columns) < 30:
            raise ValueError(f"{source}: expected at least 30 columns")
        try:
            rude_id = int(columns[0])
            node_id = int(columns[1])
            choice_slot = int(columns[2])
            next_node = int(columns[5])
        except ValueError as exception:
            raise ValueError(f"{source}: invalid row identity or action") from exception
        rows.append(RudeRow(
            row_index=row_index,
            rude_id=rude_id,
            node_id=node_id,
            choice_slot=choice_slot,
            next_node=next_node,
            source_line=source_line,
            required=key_group(columns, KEY_COLUMNS["required"], source),
            granted=key_group(columns, KEY_COLUMNS["granted"], source) if next_node >= -1 else (),
            forbidden=key_group(columns, KEY_COLUMNS["forbidden"], source),
            removed=key_group(columns, KEY_COLUMNS["removed"], source) if next_node >= -1 else (),
        ))
    return rows


def load_journal_stages(path: Path) -> list[dict[str, Any]]:
    stages: list[dict[str, Any]] = []
    for row in load_rude_file(path):
        if row.rude_id != 997 or row.node_id != 997:
            raise ValueError(f"{path.as_posix()}:{row.source_line}: unexpected journal RUDE identity")
        stages.append({
            "entry_qbit": MM9_QBIT_BASE + row.choice_slot,
            "required_qbits": list(row.required),
            "forbidden_qbits": list(row.forbidden),
            "provenance": {
                "source": "dialogue/rude/NPC997.rude",
                "source_line": row.source_line,
                "entry_id": row.choice_slot,
            },
        })
    return stages


def structural_paths(rude_id: int, rows: list[RudeRow]) -> dict[int, list[int]]:
    rows_by_node: dict[int, list[RudeRow]] = {}
    for row in rows:
        rows_by_node.setdefault(row.node_id, []).append(row)
    paths: dict[int, list[int]] = {rude_id: []}
    pending: deque[int] = deque([rude_id])
    while pending:
        node_id = pending.popleft()
        for row in rows_by_node.get(node_id, []):
            if row.next_node < 0 or row.next_node in paths:
                continue
            paths[row.next_node] = paths[node_id] + [row.source_line]
            pending.append(row.next_node)
    return paths


def remove_suffix(value: str, suffix: str) -> str:
    return value[:-len(suffix)] if suffix and value.endswith(suffix) else value


def scene_actor_bindings(path: Path) -> list[dict[str, int]]:
    bindings: list[dict[str, int]] = []
    actor_index = -1
    in_actors = False
    actor_indent = -1
    rude_id: int | None = None
    source_object_index: int | None = None

    def finish_actor() -> None:
        if rude_id is None or rude_id <= 0:
            return
        if source_object_index is None:
            raise ValueError(f"{path.as_posix()}: actor {actor_index} has RUDE {rude_id} without source identity")
        bindings.append({
            "actor_index": actor_index,
            "rude_id": rude_id,
            "source_object_index": source_object_index,
        })

    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.lstrip()
        indent = len(line) - len(stripped)
        if stripped == "actors:":
            in_actors = True
            actor_indent = indent + 2
            continue
        if in_actors and indent <= actor_indent - 2 and stripped and not stripped.startswith("#"):
            finish_actor()
            in_actors = False
            rude_id = None
            source_object_index = None
        if not in_actors:
            continue
        if indent == actor_indent and stripped.startswith("- "):
            finish_actor()
            actor_index += 1
            rude_id = None
            source_object_index = None
        elif indent == actor_indent + 2 and stripped.startswith("mm9_rude_id:"):
            rude_id = int(stripped.split(":", 1)[1].strip())
        elif indent == actor_indent + 2 and stripped.startswith("mm9_source_object_index:"):
            source_object_index = int(stripped.split(":", 1)[1].strip())
    if in_actors:
        finish_actor()
    return bindings


def raw_script_properties(path: Path, source_indices: set[int]) -> dict[int, dict[str, Any]]:
    result: dict[int, dict[str, Any]] = {}
    current_index: int | None = None
    current_property = ""
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped.startswith("- object_index:"):
            current_index = int(stripped.split(":", 1)[1].strip())
            current_property = ""
        elif current_index in source_indices and stripped in {'- name: "ScriptName"', '- name: "ScriptParams"'}:
            current_property = stripped.split('"', 2)[1]
        elif current_index in source_indices and current_property and stripped.startswith("value_json:"):
            yaml_value = yaml.safe_load(stripped.split(":", 1)[1].strip())
            try:
                result.setdefault(current_index, {})[current_property] = json.loads(yaml_value)
            except (json.JSONDecodeError, TypeError):
                result.setdefault(current_index, {})[current_property] = yaml_value
            current_property = ""
    return result


def load_bindings(maps_root: Path, raw_maps_root: Path) -> tuple[dict[int, list[dict[str, Any]]], list[dict[str, Any]]]:
    by_rude_id: dict[int, list[dict[str, Any]]] = {}
    all_bindings: list[dict[str, Any]] = []
    for scene_path in sorted(maps_root.glob("*.scene.yml")):
        if scene_path.name.endswith("_authored.scene.yml"):
            continue
        scene_bindings = scene_actor_bindings(scene_path)
        map_id = remove_suffix(scene_path.name, ".scene.yml")
        raw_path = raw_maps_root / f"{map_id}.raw_objects.yml"
        source_indices = {binding["source_object_index"] for binding in scene_bindings}
        raw_properties = raw_script_properties(raw_path, source_indices) if raw_path.is_file() else {}
        for actor in scene_bindings:
            rude_id = actor["rude_id"]
            source_object_index = actor["source_object_index"]
            actor_index = actor["actor_index"]
            properties = raw_properties.get(source_object_index, {})
            binding = {
                "map_id": map_id,
                "actor_index": actor_index,
                "source_object_index": source_object_index,
                "script_name": properties.get("ScriptName", ""),
                "script_params": properties.get("ScriptParams", ""),
                "provenance": {
                    "scene": f"maps/{scene_path.name}",
                    "raw_object": f"maps/{raw_path.name}" if raw_path.is_file() else "",
                },
            }
            by_rude_id.setdefault(rude_id, []).append(binding)
            all_bindings.append({"rude_id": rude_id, **binding})
    for bindings in by_rude_id.values():
        bindings.sort(key=lambda value: (value["map_id"], value["source_object_index"], value["actor_index"]))
    all_bindings.sort(key=lambda value: (value["map_id"], value["source_object_index"], value["actor_index"]))
    return by_rude_id, all_bindings


def stage_transitions(row: RudeRow, stages: list[dict[str, Any]]) -> tuple[list[int], list[int]]:
    starts: list[int] = []
    completes: list[int] = []
    granted = set(row.granted)
    removed = set(row.removed)
    for stage in stages:
        required = set(stage["required_qbits"])
        forbidden = set(stage["forbidden_qbits"])
        if granted.intersection(required) or removed.intersection(forbidden):
            starts.append(stage["entry_qbit"])
        if granted.intersection(forbidden) or removed.intersection(required):
            completes.append(stage["entry_qbit"])
    return starts, completes


def load_overrides(path: Path) -> tuple[dict[str, dict[str, Any]], list[dict[str, Any]]]:
    if not path.is_file():
        return {}, []
    document = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    overrides = document.get("overrides", [])
    result: dict[str, dict[str, Any]] = {}
    for override in overrides:
        interaction_id = override.get("interaction_id")
        reason = override.get("reason")
        if not isinstance(interaction_id, str) or not isinstance(reason, str) or not reason.strip():
            raise ValueError(f"{path.as_posix()}: every override needs interaction_id and reason")
        if interaction_id in result:
            raise ValueError(f"{path.as_posix()}: duplicate override {interaction_id}")
        result[interaction_id] = override
    scr_interactions = document.get("scr_interactions", [])
    if not isinstance(scr_interactions, list):
        raise ValueError(f"{path.as_posix()}: scr_interactions must be a sequence")
    seen_scr_ids: set[str] = set()
    for interaction in scr_interactions:
        interaction_id = interaction.get("interaction_id")
        source_candidate_id = interaction.get("source_candidate_id")
        reason = interaction.get("reason")
        if (not isinstance(interaction_id, str)
                or not isinstance(source_candidate_id, str)
                or not isinstance(reason, str)
                or not reason.strip()):
            raise ValueError(
                f"{path.as_posix()}: every SCR interaction needs interaction_id, source_candidate_id, and reason")
        if interaction_id in seen_scr_ids:
            raise ValueError(f"{path.as_posix()}: duplicate SCR interaction {interaction_id}")
        seen_scr_ids.add(interaction_id)
    return result, scr_interactions


def interaction_record(
    row: RudeRow,
    path_rows: list[int],
    starts: list[int],
    completes: list[int],
    bindings: list[dict[str, Any]],
    override: dict[str, Any] | None,
) -> dict[str, Any] | None:
    interaction_id = f"mm9.rude.{row.rude_id}.row.{row.source_line}"
    if override and override.get("classification") == "excluded":
        return None
    roles = (["offer"] if starts else []) + (["handoff"] if completes else [])
    if override and isinstance(override.get("roles"), list):
        roles = override["roles"]
    associated = sorted(set(starts + completes))
    record: dict[str, Any] = {
        "id": interaction_id,
        "rude_id": row.rude_id,
        "bindings": bindings,
        "journal_entries": associated,
        "roles": roles,
        "conditions": {
            "reachable_path_rows": path_rows,
            "row_required_qbits": list(row.required),
            "row_forbidden_qbits": list(row.forbidden),
            "available": {"activates_journal_entries": starts},
            "in_progress": {"active_journal_entries": completes, "row_not_yet_reachable": True},
            "ready": {"active_journal_entries": completes, "row_reachable": True},
        },
        "effects": {
            "granted_qbits": list(row.granted),
            "removed_qbits": list(row.removed),
        },
        "non_qbit_dependencies": [],
        "justification": "journal_condition_transition_from_reachable_ordinary_rude_row",
        "classification": "authored_override" if override else "generated",
        "provenance": {
            "source": f"dialogue/rude/NPC{row.rude_id}.rude",
            "source_line": row.source_line,
            "row_index": row.row_index,
            "node_id": row.node_id,
            "choice_slot": row.choice_slot,
        },
    }
    if override:
        record["override_reason"] = override["reason"]
        if isinstance(override.get("non_qbit_dependencies"), list):
            record["non_qbit_dependencies"] = override["non_qbit_dependencies"]
    return record


def callback_routine_lines(script_text: str, script_name: str, callback_routine: str) -> set[int]:
    program = parse_scr(script_text, script_name)
    pending = [callback_routine.lower()]
    visited: set[str] = set()
    source_lines: set[int] = set()
    while pending:
        routine = pending.pop()
        if routine in visited:
            continue
        visited.add(routine)
        for line in program.routines.get(routine, []):
            source_lines.add(line.number)
            match = re.match(r"^gosub\s+([A-Za-z_][A-Za-z0-9_]*)", line.code, re.IGNORECASE)
            if match:
                pending.append(match.group(1).lower())
    return source_lines


def scr_candidates(
    events_root: Path,
    scripts_root: Path,
    journal_keys: set[int],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    candidates: list[dict[str, Any]] = []
    exclusions: list[dict[str, Any]] = []
    for path in sorted(events_root.glob("*.events.yml")):
        text = path.read_text(encoding="utf-8")
        separator = "\ndialogue_callbacks:\n"
        if separator not in text:
            continue
        callback_text = text.split(separator, 1)[1].split("\nunresolved:", 1)[0]
        callback_document = yaml.safe_load("dialogue_callbacks:\n" + callback_text) or {}
        for callback in callback_document.get("dialogue_callbacks", []):
            script_name = str(callback.get("script_name", ""))
            relevant_operations: list[dict[str, Any]] = []
            script_path = scripts_root / script_name
            if not script_path.is_file():
                script_path = next(
                    (
                        candidate
                        for candidate in scripts_root.glob("*.scr")
                        if candidate.name.lower() == script_name.lower()
                    ),
                    script_path,
                )
            script_text = script_path.read_text(encoding="latin-1") if script_path.is_file() else ""
            reachable_lines = callback_routine_lines(
                script_text,
                script_path.name if script_path.is_file() else script_name,
                str(callback.get("callback_routine", "")),
            )
            unreachable_operations: list[dict[str, Any]] = []
            for source_line, source_text in enumerate(script_text.splitlines(), start=1):
                match = re.match(
                    r"^\s*(givekey|takekey)\s*,?\s*([0-9]+)(?:\s|,|;|$)",
                    source_text,
                    re.IGNORECASE,
                )
                if not match:
                    continue
                operation_qbit = MM9_QBIT_BASE + int(match.group(2))
                if operation_qbit in journal_keys:
                    operation = {
                        "command": match.group(1).lower(),
                        "qbit": operation_qbit,
                        "source_line": source_line,
                    }
                    if source_line in reachable_lines:
                        relevant_operations.append(operation)
                    else:
                        unreachable_operations.append(operation)
            candidate_id = f"mm9.scr.{remove_suffix(path.stem, '.events')}.{callback.get('source_object_index')}"
            if relevant_operations:
                candidates.append({
                    "id": candidate_id,
                    "map_id": remove_suffix(path.stem, ".events"),
                    "source_object_index": callback.get("source_object_index"),
                    "script_name": script_name,
                    "callback_routine": callback.get("callback_routine", ""),
                    "relevant_operations": relevant_operations,
                    "status": "unresolved",
                    "reason": "SCR control-flow predicates are not yet represented as pure marker metadata",
                    "provenance": {
                        "event_inventory": f"maps/{path.name}",
                        "source": script_path.as_posix() if script_path.is_file() else script_name,
                    },
                })
            if unreachable_operations:
                exclusions.append({
                    "id": candidate_id + ".unreachable_operations",
                    "reason": "journal-key operations are outside the registered RUDE-exit callback call graph",
                    "relevant_operations": unreachable_operations,
                    "provenance": {
                        "event_inventory": f"maps/{path.name}",
                        "source": script_path.as_posix() if script_path.is_file() else script_name,
                    },
                })
    return candidates, exclusions


def literal_scr_journal_keys(scripts_root: Path, journal_keys: set[int]) -> set[int]:
    result: set[int] = set()
    for path in sorted(scripts_root.glob("*.scr"), key=lambda value: value.name.lower()):
        for source_text in path.read_text(encoding="latin-1").splitlines():
            match = re.match(r"^\s*givekey\s*,?\s*([0-9]+)(?:\s|,|;|$)", source_text, re.IGNORECASE)
            if not match:
                continue
            operation_qbit = MM9_QBIT_BASE + int(match.group(1))
            if operation_qbit in journal_keys:
                result.add(operation_qbit)
    return result


def scr_interaction_record(
    authored: dict[str, Any],
    candidate: dict[str, Any],
    binding: dict[str, Any],
    stages: list[dict[str, Any]],
) -> dict[str, Any]:
    granted_qbits = authored.get("granted_qbits", [])
    removed_qbits = authored.get("removed_qbits", [])
    if not isinstance(granted_qbits, list) or not isinstance(removed_qbits, list):
        raise ValueError(f"{authored.get('interaction_id')}: SCR effects must be QBit sequences")
    source_qbits = {
        operation["qbit"]
        for operation in candidate["relevant_operations"]
    }
    if not set(granted_qbits + removed_qbits).issubset(source_qbits):
        raise ValueError(f"{authored.get('interaction_id')}: SCR effects do not match callback source operations")

    starts: list[int] = []
    completes: list[int] = []
    granted = set(granted_qbits)
    removed = set(removed_qbits)
    for stage in stages:
        required = set(stage["required_qbits"])
        forbidden = set(stage["forbidden_qbits"])
        if granted.intersection(required) or removed.intersection(forbidden):
            starts.append(stage["entry_qbit"])
        if granted.intersection(forbidden) or removed.intersection(required):
            completes.append(stage["entry_qbit"])
    if not starts and not completes:
        raise ValueError(f"{authored.get('interaction_id')}: SCR effects do not transition a journal stage")

    predicate = authored.get("predicate", {})
    required_qbits = predicate.get("required_qbits", [])
    forbidden_qbits = predicate.get("forbidden_qbits", [])
    any_required_qbits = predicate.get("any_required_qbits", [])
    minimum_gold = predicate.get("minimum_gold", 0)
    if (not isinstance(required_qbits, list)
            or not isinstance(forbidden_qbits, list)
            or not isinstance(any_required_qbits, list)
            or not isinstance(minimum_gold, int)
            or minimum_gold < 0):
        raise ValueError(f"{authored.get('interaction_id')}: invalid pure SCR predicate")
    non_qbit_dependencies = []
    if minimum_gold > 0:
        non_qbit_dependencies.append({"kind": "carried_gold", "minimum": minimum_gold})

    return {
        "id": authored["interaction_id"],
        "source_kind": "scr",
        "rude_id": binding["rude_id"],
        "bindings": [{key: value for key, value in binding.items() if key != "rude_id"}],
        "journal_entries": sorted(set(starts + completes)),
        "roles": (["offer"] if starts else []) + (["handoff"] if completes else []),
        "conditions": {
            "scr_predicate": {
                "required_qbits": required_qbits,
                "forbidden_qbits": forbidden_qbits,
                "any_required_qbits": any_required_qbits,
                "minimum_gold": minimum_gold,
            },
            "available": {"activates_journal_entries": starts},
            "in_progress": {"active_journal_entries": completes, "scr_predicate_not_met": True},
            "ready": {"active_journal_entries": completes, "scr_predicate_met": True},
        },
        "effects": {
            "granted_qbits": granted_qbits,
            "removed_qbits": removed_qbits,
        },
        "non_qbit_dependencies": non_qbit_dependencies,
        "justification": "authored_pure_predicate_for_dialogue_linked_scr_callback",
        "classification": "authored_override",
        "override_reason": authored["reason"],
        "provenance": {
            "source": candidate["provenance"]["source"],
            "source_lines": authored.get("source_lines", []),
            "event_inventory": candidate["provenance"]["event_inventory"],
            "callback_routine": candidate["callback_routine"],
        },
    }


def generate(
    rude_root: Path,
    maps_root: Path,
    raw_maps_root: Path,
    events_root: Path,
    scripts_root: Path,
    overrides_path: Path,
) -> tuple[dict[str, Any], dict[str, Any]]:
    stages = load_journal_stages(rude_root / "NPC997.rude")
    journal_keys = {
        value
        for stage in stages
        for value in stage["required_qbits"] + stage["forbidden_qbits"]
    }
    bindings_by_rude_id, all_bindings = load_bindings(maps_root, raw_maps_root)
    overrides, authored_scr_interactions = load_overrides(overrides_path)
    interactions: list[dict[str, Any]] = []
    exclusions: list[dict[str, Any]] = []
    unresolved: list[dict[str, Any]] = []
    normal_graph_count = 0
    normal_row_count = 0
    reachable_grant_rude_ids: set[int] = set()
    root_grant_rude_ids: set[int] = set()
    ordinary_granted_journal_keys: set[int] = set()
    seen_candidate_ids: set[str] = set()

    for path in sorted(rude_root.glob("NPC[0-9]*.rude"), key=lambda value: value.name.lower()):
        # NPC997 is the journal, NPC998 is the quest-history list, and NPC999 is the debug/status list.
        if path.name in {"NPC997.rude", "NPC998.rude", "NPC999.rude"}:
            continue
        rows = load_rude_file(path)
        if not rows:
            continue
        rude_id = rows[0].rude_id
        normal_graph_count += 1
        normal_row_count += len(rows)
        paths = structural_paths(rude_id, rows)
        for row in rows:
            if row.node_id not in paths or row.next_node < -1:
                continue
            relevant_grants = set(row.granted).intersection(journal_keys)
            if relevant_grants:
                reachable_grant_rude_ids.add(rude_id)
                ordinary_granted_journal_keys.update(relevant_grants)
                if row.node_id == rude_id:
                    root_grant_rude_ids.add(rude_id)
            starts, completes = stage_transitions(row, stages)
            if not starts and not completes:
                continue
            interaction_id = f"mm9.rude.{rude_id}.row.{row.source_line}"
            seen_candidate_ids.add(interaction_id)
            override = overrides.get(interaction_id)
            if override and override.get("classification") == "excluded":
                exclusions.append({
                    "id": interaction_id,
                    "reason": override["reason"],
                    "provenance": f"dialogue/rude/{path.name}:{row.source_line}",
                })
                continue
            record = interaction_record(
                row,
                paths[row.node_id],
                starts,
                completes,
                bindings_by_rude_id.get(rude_id, []),
                override,
            )
            if not bindings_by_rude_id.get(rude_id):
                exclusions.append({
                    "id": interaction_id,
                    "reason": "the RUDE graph has no imported actor, so no loaded NPC can own this marker",
                    "provenance": f"dialogue/rude/{path.name}:{row.source_line}",
                })
            elif record:
                interactions.append(record)

    unused_overrides = sorted(set(overrides).difference(seen_candidate_ids))
    if unused_overrides:
        raise ValueError("unused quest-interaction overrides: " + ", ".join(unused_overrides))

    scr_source_candidates, scr_source_exclusions = scr_candidates(events_root, scripts_root, journal_keys)
    exclusions.extend(scr_source_exclusions)
    source_candidates_by_id = {candidate["id"]: candidate for candidate in scr_source_candidates}
    authored_by_candidate: dict[str, list[dict[str, Any]]] = {}
    for authored in authored_scr_interactions:
        authored_by_candidate.setdefault(authored["source_candidate_id"], []).append(authored)
    unknown_scr_sources = sorted(set(authored_by_candidate).difference(source_candidates_by_id))
    if unknown_scr_sources:
        raise ValueError(
            "authored SCR interactions have no reachable source candidate: " + ", ".join(unknown_scr_sources))
    bindings_by_identity = {
        (binding["map_id"], binding["source_object_index"]): binding
        for binding in all_bindings
    }
    for candidate in scr_source_candidates:
        authored_records = authored_by_candidate.get(candidate["id"], [])
        excluded = [record for record in authored_records if record.get("classification") == "excluded"]
        classified = [record for record in authored_records if record.get("classification") != "excluded"]
        if excluded:
            if len(excluded) != 1 or classified:
                raise ValueError(f"{candidate['id']}: SCR candidate exclusion cannot be combined with classifications")
            exclusions.append({
                "id": candidate["id"],
                "reason": excluded[0]["reason"],
                "provenance": candidate["provenance"],
            })
            continue
        binding = bindings_by_identity.get((candidate["map_id"], candidate["source_object_index"]))
        if binding is None:
            unresolved.append({**candidate, "reason": "dialogue-linked SCR callback has no imported actor binding"})
            continue
        if not classified:
            unresolved.append(candidate)
            continue
        for authored in classified:
            interactions.append(scr_interaction_record(authored, candidate, binding, stages))

    literal_scr_keys = literal_scr_journal_keys(scripts_root, journal_keys)
    scr_only_journal_keys = literal_scr_keys.difference(ordinary_granted_journal_keys)
    interactions.sort(key=lambda value: value["id"])
    exclusions.sort(key=lambda value: value["id"])
    unresolved.sort(key=lambda value: value["id"])
    dependency_counts: dict[str, int] = {}
    for interaction in interactions:
        for dependency in interaction["non_qbit_dependencies"]:
            kind = str(dependency["kind"])
            dependency_counts[kind] = dependency_counts.get(kind, 0) + 1
    metadata = {
        "format_version": 1,
        "world": "mm9",
        "generated_by": "tools/mm9_import_discovery/generate_mm9_quest_interactions.py",
        "journal_stages": stages,
        "interactions": interactions,
    }
    report = {
        "format_version": 1,
        "world": "mm9",
        "generated_by": "tools/mm9_import_discovery/generate_mm9_quest_interactions.py",
        "inventory": {
            "normal_rude_graphs": normal_graph_count,
            "normal_dialogue_rows": normal_row_count,
            "reachable_journal_grant_rude_ids": len(reachable_grant_rude_ids),
            "root_journal_grant_rude_ids": len(root_grant_rude_ids),
            "journal_condition_raw_keys": len(journal_keys),
            "journal_keys_granted_by_ordinary_rude_rows": len(ordinary_granted_journal_keys),
            "journal_keys_granted_only_by_literal_scr": len(scr_only_journal_keys),
            "imported_dialogue_actor_bindings": len(all_bindings),
            "generated_interactions": len(interactions),
            "explicit_exclusions": len(exclusions),
            "unresolved_candidates": len(unresolved),
            "validated_non_qbit_dependencies": dict(sorted(dependency_counts.items())),
        },
        "binding_coverage": all_bindings,
        "explicit_exclusions": exclusions,
        "unresolved_candidates": unresolved,
    }
    return metadata, report


def yaml_text(document: dict[str, Any]) -> str:
    return yaml.dump(document, Dumper=StableDumper, sort_keys=False, allow_unicode=True, width=120)


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate deterministic MM9 NPC quest-interaction metadata.")
    parser.add_argument("--rude-root", type=Path, default=Path("assets_dev/worlds/mm9/dialogue/rude"))
    parser.add_argument("--maps-root", type=Path, default=Path("assets_dev/worlds/mm9/maps"))
    parser.add_argument("--raw-maps-root", type=Path, default=Path("assets_editor_dev/worlds/mm9/maps"))
    parser.add_argument("--events-root", type=Path, default=Path("assets_dev/worlds/mm9/maps"))
    parser.add_argument("--scripts-root", type=Path, default=Path("mm9/extracted/SCRIPTS/SCRIPTS"))
    parser.add_argument(
        "--overrides",
        type=Path,
        default=Path("tools/mm9_import_discovery/mm9_quest_interaction_overrides.yml"),
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("assets_dev/worlds/mm9/state/quest_interactions.yml"),
    )
    parser.add_argument(
        "--report",
        type=Path,
        default=Path("assets_dev/worlds/mm9/state/quest_interaction_coverage.yml"),
    )
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    try:
        metadata, report = generate(
            args.rude_root,
            args.maps_root,
            args.raw_maps_root,
            args.events_root,
            args.scripts_root,
            args.overrides,
        )
    except (OSError, ValueError, yaml.YAMLError) as exception:
        print(exception)
        return 1
    outputs = ((args.output, yaml_text(metadata)), (args.report, yaml_text(report)))
    if args.check:
        stale = [str(path) for path, text in outputs if not path.is_file() or path.read_text(encoding="utf-8") != text]
        if stale:
            print("stale generated MM9 quest-interaction files: " + ", ".join(stale))
            return 1
        print("MM9 quest-interaction metadata and coverage are current")
        return 0
    for path, text in outputs:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        print(f"wrote {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
