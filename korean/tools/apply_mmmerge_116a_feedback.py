#!/usr/bin/env python3
"""Apply reviewed MMMerge 1.0.16a player-feedback corrections.

This pass is deliberately source-aware.  It normalizes lore terms and a small
set of item/stat/skill strings only when their English source establishes the
intended meaning, then synchronizes the corrected catalog values back into the
generated engine overlay used by the game.
"""

from __future__ import annotations

import argparse
import csv
import io
import json
import re
from collections import Counter
from pathlib import Path


ITEM_EXACT_OVERRIDES: dict[tuple[int, str], str] = {
    (121, "Notes"): "정교하게 제작된 드래곤 가죽 벨트는 마법을 담는 데 사용됩니다. 이 벨트는 금으로 장식되어 있으며 얇은 시에르탈 띠로 둘러싸여 있습니다.",
    (821, "Notes"): "경이의 시대에 만들어진 이 단검은, 이보다 더 날카롭거나 더 강인한 날을 가진 무기를 만들 수 없을 정도로 뛰어납니다.",
    (832, "Notes"): "사형 집행인들이 선호하는 처형 도구에서 이름을 따온 참수자의 장대도끼는 처형 과정에서 발생하는 지저분하고 당황스러운 실수를 줄이기 위해 더 긴 날을 가지고 있습니다.",
    (2024, "Notes"): "전통적으로 최고 드루이드가 휴대하던 멀린은 종교 교리 분쟁 중에 분실되었지만, 사용자가 언제든 끌어낼 수 있는 주문력의 저장소 역할을 합니다. 멀린은 공격 회복 속도를 높이는 마법이 걸려 있어 일반 지팡이보다 훨씬 빠르게 적에게 공격을 퍼붓습니다. (특수 능력: 빠른 공격 회복 속도, 주문력 +40)",
}

TIME_OF_WONDERS_VARIANTS = (
    "불가사의한 시대",
    "불가사의의 시대",
    "경이로운 시대",
)

SILENCE_VARIANTS = (
    "대침묵의 시대",
    "대침묵의 사건",
    "대침묵",
    "대재앙",
)

MEKORIG_VARIANTS = (
    "메코리그 더 블라인드",
    "맹인 메코리그",
    "눈먼 메코리그",
)


def _replace(text: str, old: str, new: str, counts: Counter[str]) -> str:
    amount = text.count(old)
    if amount:
        text = text.replace(old, new)
        counts[f"{old} -> {new}"] += amount
    return text


def correct_catalog_entry(entry: dict, counts: Counter[str]) -> bool:
    source_name = Path(str(entry.get("source_file", ""))).name
    source = str(entry.get("source", ""))
    field = str(entry.get("field", ""))
    translation = entry.get("translation", "")
    if not isinstance(translation, str) or not translation:
        return False

    before = translation

    if source_name == "items.txt":
        try:
            item_id = int(entry.get("record_id"))
        except (TypeError, ValueError):
            item_id = -1

        override = ITEM_EXACT_OVERRIDES.get((item_id, field))
        if override is not None:
            translation = override
        else:
            if "Time of Wonders" in source:
                for variant in TIME_OF_WONDERS_VARIANTS:
                    translation = _replace(translation, variant, "경이의 시대", counts)

            if re.search(r"\bSilence\b", source, flags=re.IGNORECASE):
                for variant in SILENCE_VARIANTS:
                    translation = _replace(translation, variant, "침묵의 시대", counts)

            if "Mekorig the Blind" in source:
                for variant in MEKORIG_VARIANTS:
                    translation = _replace(translation, variant, "장님 메코리그", counts)

            # Jadamean/Antagarichan here are provenance adjectives for gems.
            # Keep the Korean '-산' form consistent with Enroth-origin gems.
            if 177 <= item_id <= 186 and "Jadamean" in source:
                corrected = re.sub(r"제이덤(?!산)", "제이덤산", translation)
                if corrected != translation:
                    counts["제이덤 -> 제이덤산 (Jadamean gem)"] += 1
                translation = corrected
            if 988 <= item_id <= 998 and "Antagarichan" in source:
                corrected = re.sub(r"안타개릭(?!산)", "안타개릭산", translation)
                if corrected != translation:
                    counts["안타개릭 -> 안타개릭산 (Antagarichan gem)"] += 1
                translation = corrected

    elif source_name == "stats.txt":
        record_id = str(entry.get("record_id", ""))
        if record_id == "Shoot Bonus":
            if field == "DisplayName":
                translation = "원거리 공격 보너스"
            elif field == "Description":
                translation = _replace(translation, "사격 보너스", "원거리 공격 보너스", counts)
        elif record_id == "Shoot Damage":
            if field == "DisplayName":
                translation = "원거리 피해"
            elif field == "Description":
                translation = _replace(translation, "사격 피해", "원거리 피해", counts)

    elif source_name == "skill_des.txt":
        if str(entry.get("record_id", "")) == "Shield" and field == "GrandMaster":
            translation = "방패 주문 효과 상시 부여"

    elif source_name == "special_item_enchants.txt":
        if str(entry.get("record_id", "")) == "2":
            if field == "DisplayDescription":
                translation = "모든 능력치 +10."
            elif field == "DisplaySuffix":
                translation = "[신]"

    if translation == before:
        return False

    entry["translation"] = translation
    note = str(entry.get("note", "")).strip()
    marker = "MMMerge 1.0.16a player-feedback review applied."
    if marker not in note:
        entry["note"] = f"{note} {marker}".strip()
    counts["catalog entries changed"] += 1
    return True


def _sync_tabular(
    path: Path,
    catalog: dict,
    source_name: str,
    field_to_header: dict[str, str],
) -> int:
    if not path.is_file():
        return 0

    wanted: dict[tuple[str, str], str] = {}
    allowed = set(field_to_header)
    for entry in catalog.get("entries", []):
        if Path(str(entry.get("source_file", ""))).name != source_name:
            continue
        field = str(entry.get("field", ""))
        value = entry.get("translation", "")
        if field in allowed and isinstance(value, str):
            wanted[(str(entry.get("record_id")), field)] = value

    text = path.read_text(encoding="utf-8-sig")
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))
    header_index = None
    columns: dict[str, int] = {}
    for index, row in enumerate(rows):
        if not row:
            continue
        candidate = {field: (row.index(header) if header in row else -1) for field, header in field_to_header.items()}
        if any(column >= 0 for column in candidate.values()):
            header_index = index
            columns = candidate
            break
    if header_index is None:
        raise ValueError(f"Could not find header in {path}")

    changed = 0
    for row in rows[header_index + 1:]:
        if not row:
            continue
        record_id = row[0].strip()
        for field, column in columns.items():
            if column <= 0:
                continue
            value = wanted.get((record_id, field))
            if value is None:
                continue
            while len(row) <= column:
                row.append("")
            if row[column] != value:
                row[column] = value
                changed += 1

    output = io.StringIO(newline="")
    csv.writer(output, delimiter="\t", quotechar='"', quoting=csv.QUOTE_MINIMAL, lineterminator="\n").writerows(rows)
    path.write_text(output.getvalue(), encoding="utf-8", newline="")
    return changed


def synchronize_overlay(repo_root: Path, catalog: dict) -> int:
    overlay_root = repo_root / "korean" / "overlay" / "engine" / "data_tables"
    changed = 0
    changed += _sync_tabular(
        overlay_root / "items.txt",
        catalog,
        "items.txt",
        {"Name": "Name", "NotIdentifiedName": "Not identified name", "Notes": "Notes"},
    )
    changed += _sync_tabular(
        overlay_root / "english" / "stats.txt",
        catalog,
        "stats.txt",
        {"Description": "Description", "DisplayName": "LocalizedName"},
    )
    changed += _sync_tabular(
        overlay_root / "english" / "skill_des.txt",
        catalog,
        "skill_des.txt",
        {
            "Description": "Description",
            "Normal": "Normal",
            "Expert": "Expert",
            "Master": "Master",
            "GrandMaster": "GrandMaster",
            "DisplayName": "LocalizedName",
        },
    )

    # This table has no stable numeric record-id column in the generated file,
    # so synchronize the reviewed record by exact localized display text.
    special_path = overlay_root / "special_item_enchants.txt"
    if special_path.is_file():
        text = special_path.read_text(encoding="utf-8-sig")
        replacements = (
            ("7대 능력치 모두 +10.", "모든 능력치 +10."),
            ("[신들]", "[신]"),
        )
        original = text
        for old, new in replacements:
            text = text.replace(old, new)
        if text != original:
            changed += 1
            special_path.write_text(text, encoding="utf-8", newline="")
    return changed


def validate(catalog: dict) -> None:
    errors: list[str] = []
    for entry in catalog.get("entries", []):
        source_name = Path(str(entry.get("source_file", ""))).name
        if source_name != "items.txt":
            continue
        source = str(entry.get("source", ""))
        translation = str(entry.get("translation", ""))
        if "Time of Wonders" in source and any(v in translation for v in TIME_OF_WONDERS_VARIANTS):
            errors.append(f"{entry.get('key')}: stale Time of Wonders wording")
        if re.search(r"\bSilence\b", source, flags=re.IGNORECASE) and any(v in translation for v in SILENCE_VARIANTS):
            errors.append(f"{entry.get('key')}: stale Silence wording")
        if "Mekorig the Blind" in source and any(v in translation for v in MEKORIG_VARIANTS):
            errors.append(f"{entry.get('key')}: stale Mekorig wording")
    if errors:
        raise ValueError("MMMerge 1.0.16a feedback validation failed:\n" + "\n".join(errors[:100]))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    args = parser.parse_args()
    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / "korean" / "translations" / "catalog.json"
    if not catalog_path.is_file():
        print("MMMerge 1.0.16a feedback: catalog not present; skipping generated-overlay pass")
        return 0

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    counts: Counter[str] = Counter()
    for entry in catalog.get("entries", []):
        correct_catalog_entry(entry, counts)
    validate(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    overlay_changes = synchronize_overlay(repo_root, catalog)
    print(f"MMMerge 1.0.16a feedback: {counts['catalog entries changed']} catalog entries, {overlay_changes} overlay sync changes")
    for label, count in sorted(counts.items()):
        if label != "catalog entries changed":
            print(f"  {label}: {count}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
