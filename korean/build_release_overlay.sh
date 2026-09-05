#!/usr/bin/env bash
set -euo pipefail

mmmerge_root="${1:-_mmmerge}"
output_root="${2:-dist/korean-release-overlay}"

python3 korean/tools/build_translation_catalog.py \
    --mmmerge-root "$mmmerge_root" \
    --fail-on-placeholder-mismatch
python3 korean/tools/extend_npc_names_catalog.py \
    --mmmerge-root "$mmmerge_root" \
    --fail-on-review
python3 korean/tools/extend_npc_dialogue_catalog.py --mmmerge-root "$mmmerge_root"
python3 korean/tools/apply_catalog_overrides.py \
    --overrides korean/translations/dialogue_overrides.json \
    --fail-on-review
python3 korean/tools/extend_misc_catalog.py --mmmerge-root "$mmmerge_root"
python3 korean/tools/apply_catalog_overrides.py \
    --overrides korean/translations/misc_overrides.json \
    --fail-on-review
python3 korean/tools/extend_place_mon_catalog.py \
    --mmmerge-root "$mmmerge_root" \
    --fail-on-review
python3 korean/tools/extend_stats_skills_catalog.py --fail-on-review
python3 korean/tools/extend_legacy_text_catalog.py \
    --mmmerge-root "$mmmerge_root" \
    --fail-on-review
python3 korean/tools/normalize_class_overlay.py
python3 korean/tools/extend_house_catalog.py \
    --mmmerge-root "$mmmerge_root" \
    --fail-on-review
python3 korean/tools/extend_npc_runtime_catalog.py \
    --mmmerge-root "$mmmerge_root" \
    --fail-on-review
python3 korean/tools/extend_transition_history_catalog.py --mmmerge-root "$mmmerge_root"
python3 korean/tools/apply_catalog_overrides.py \
    --overrides korean/translations/transition_history_overrides.json \
    --fail-on-review
python3 korean/tools/extend_item_enchant_catalog.py \
    --mmmerge-root "$mmmerge_root" \
    --fail-on-review
python3 korean/tools/extend_arcomage_catalog.py --fail-on-review
python3 korean/tools/build_map_string_overlays.py \
    --mmmerge-root "$mmmerge_root" \
    --fail-on-review

python3 korean/tools/stage_korean_font.py --output korean/overlay/engine/fonts

python3 korean/build_patch.py --output "$output_root"
python3 -m json.tool korean/translations/catalog.json >/dev/null

python3 - <<'PY'
import json
from pathlib import Path

catalog = json.loads(Path("korean/translations/catalog.json").read_text(encoding="utf-8"))
summary = catalog["summary"]
if summary["translated"] != summary["entries"]:
    raise SystemExit(f"Incomplete Korean catalog: {summary}")
if summary["untranslated"] != 0 or summary["needs_review"] != 0:
    raise SystemExit(f"Korean catalog still needs review: {summary}")
print(f"Korean catalog complete: {summary['translated']}/{summary['entries']}")
PY

for required in \
    "$output_root/korean/engine.zip" \
    "$output_root/korean/worlds/mm6.zip" \
    "$output_root/korean/worlds/mm7.zip" \
    "$output_root/korean/worlds/mm8.zip" \
    "$output_root/korean/worlds/mmmerge.zip"; do
    test -s "$required"
done

unzip -Z1 "$output_root/korean/engine.zip" > "$output_root/engine-contents.txt"
grep -Fxq 'fonts/KoreanFallback.ttf' "$output_root/engine-contents.txt"
grep -Fxq 'fonts/Galmuri-OFL.txt' "$output_root/engine-contents.txt"
grep -Fxq 'data_tables/english/Global.txt' "$output_root/engine-contents.txt"
grep -Fxq 'data_tables/english/quests.txt' "$output_root/engine-contents.txt"

echo "Korean release overlay ready: $output_root"
