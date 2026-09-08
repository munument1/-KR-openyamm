#!/usr/bin/env python3
"""Localize map-event hover labels in the Korean world overlays.

OpenYAMM's Lua exporter stores the hover/status hint as the second string passed
to RegisterEvent().  Those labels are separate from KO_MapStrings and therefore
can remain English even when the map's messages are translated.  This pass uses
already-reviewed catalog translations first, then a small reviewed vocabulary
for generic world objects/actions.  If a source map has no overlay yet, it is
copied only when at least one event label needs localization, so the localized
hover path covers every current runtime map rather than only maps touched by
KO_MapStrings.
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
from collections import defaultdict
from pathlib import Path

REGISTER_RE = re.compile(r'(RegisterEvent\([^,\n]+,\s*)"((?:\\.|[^"\\])*)"')
TAIL_RE = re.compile(r'(end,\s*)"((?:\\.|[^"\\])*)"(\s*\))')
LATIN_RE = re.compile(r"[A-Za-z]")

PREFERRED = {
    "Blackshire": "블랙셔",
    "New Sorpigal": "뉴 소르피갈",
    "Zephyr": "제퍼",
    "Sanctuary": "성소",
    "The Proving Grounds": "시험장",
    "Guild of Mind": "정신 마법 길드",
    "Apothecary": "약제상",
    "Placeholder": "자리 표시자",
    "Mist": "미스트",
}

GENERIC = {
    "Door": "문", "Chest": "상자", "Button": "버튼", "Lever": "레버",
    "Cabinet": "장식장", "Fruit Tree": "과일나무", "Bookcase": "책장",
    "Switch": "스위치", "Bookshelf": "책장", "Obelisk": "오벨리스크",
    "Drink from Fountain": "분수에서 마시기", "Drink from the Well": "우물에서 마시기",
    "Drink from the well": "우물에서 마시기", "Wooden Door": "나무 문",
    "Burial niche": "매장 벽감", "Well": "우물", "Suspicious Floor": "수상한 바닥",
    "Altar": "제단", "Bag": "가방", "Breach Chest Trap": "상자 함정",
    "Drink from Well.": "우물에서 마시기", "Crystal.": "수정", "Ore Vein": "광맥",
    "Take a Drink": "마시기", "Door.": "문", "Cage": "우리", "Open Crate": "상자 열기",
    "Sack": "자루", "Bed": "침대", "Enter the Cave": "동굴 들어가기", "Plaque": "명판",
    "Sign": "표지판", "Desk": "책상", "Drink from the Fountain": "분수에서 마시기",
    "Gold vein": "금 광맥", "Drink from Fountain.": "분수에서 마시기",
    "Drink from the fountain": "분수에서 마시기", "Magic Door": "마법의 문",
    "Pedestal": "받침대", "Rock": "바위", "Lift": "승강기", "Switch.": "스위치",
    "A Cave": "동굴", "Buoy": "부표", "Docks": "부두", "Drink from Trough.": "구유에서 마시기",
    "Gems": "보석", "Guilds": "길드", "Key Hole": "열쇠구멍", "Mine": "광산",
    "Pirate Ship": "해적선", "Sealed Crate": "봉인된 상자", "Stables": "마구간",
    "Stone Face": "돌 얼굴", "Teleporter": "순간이동 장치", "Wine Rack": "와인 선반",
    "Breach Jumper": "브리치 이동 장치", "Chest.": "상자", "Cylinder": "원통",
    "Double Door": "양문", "Drink": "마시기", "Enter Breach Basement": "브리치 지하실 들어가기",
    "Enter Escaton's Crystal": "에스카톤의 수정 들어가기", "Enter Fort Riverstride": "리버스트라이드 요새 들어가기",
    "Enter the Submarine": "잠수함 들어가기", "Gate": "문", "Glowing dinosaur bones": "빛나는 공룡 뼈",
    "Hut": "오두막", "Ironfist Castle": "아이언피스트 성", "Leave the Cave": "동굴 나가기",
    "Old bones.": "오래된 뼈", "Podium": "연단", "Pool": "웅덩이", "Shops": "상점",
    "Shrine of Fire": "화염의 성소", "Submarine": "잠수함", "Wall": "벽",
    "Altar of Fire": "화염의 제단", "Altar of Might": "힘의 제단", "Anvil": "모루",
    "Barrel": "나무통", "Breach Friend Hint": "브리치 단서", "Breach Library Cache": "브리치 숨겨진 물품",
    "Breach Swordsman Alarm": "브리치 경보", "Cart": "수레", "Closed Breach House": "닫힌 브리치 건물",
    "Dock": "부두", "Door ": "문", "East": "동쪽", "Enter Castle Gryphonheart": "그리폰하트 성 들어가기",
    "Enter Castle Harmondale": "하몬데일 성 들어가기", "Enter the Dragon's Cave": "드래곤 동굴 들어가기",
    "Enter The Temple of the Moon": "달의 신전 들어가기", "Exit.": "나가기",
    "Leave Castle Harmondale": "하몬데일 성 나가기", "Leave the Arena": "투기장 나가기",
    "Leave the Grand Temple of the Sun": "태양의 대신전 나가기", "North ": "북쪽",
    "Poisoned Spike": "독 묻은 가시", "Portrait": "초상화", "Return To The Breach": "브리치로 돌아가기",
    "Runaway Chaos Capture": "도망친 혼돈 포획", "Runaway Chaos Riddle": "도망친 혼돈의 수수께끼",
    "Shrine of Air": "공기의 성소", "Shrine of Earth": "대지의 성소", "Shrine of Magic": "마법의 성소",
    "Shrine of Might": "힘의 성소", "Shrine of Water": "물의 성소", "Special Trash Heap": "특수 쓰레기 더미",
    "The door will not budge": "문이 꼼짝하지 않는다", "Torch": "횃불", "Tower": "탑",
    "Troll's Inn": "트롤의 여관", "Unstable rock": "불안정한 바위", "VARN의 우물": "VARN의 우물",
}


def lua_unescape(text: str) -> str:
    return text.replace(r"\\", "\0").replace(r'\"', '"').replace("\0", "\\")


def lua_escape(text: str) -> str:
    return text.replace("\\", r"\\").replace('"', r'\"')


def catalog_translations(catalog: dict) -> dict[str, str]:
    candidates: dict[str, set[str]] = defaultdict(set)
    for entry in catalog.get("entries", []):
        source = entry.get("source")
        translation = entry.get("translation")
        if isinstance(source, str) and source and isinstance(translation, str) and translation:
            candidates[source].add(translation)
    result = {source: next(iter(values)) for source, values in candidates.items() if len(values) == 1}
    result.update(PREFERRED)
    return result


def resolve_label(label: str, exact: dict[str, str]) -> str | None:
    if not LATIN_RE.search(label):
        return label
    if label in GENERIC:
        return GENERIC[label]
    if label in exact:
        return exact[label]

    stripped = label.strip()
    if stripped != label:
        resolved = resolve_label(stripped, exact)
        if resolved is not None:
            return resolved

    # Exporter/internal mechanism hints are user-visible only as a mechanism
    # name; expose a useful Korean object label instead of implementation IDs.
    if stripped.startswith("Operate "):
        lower = stripped.casefold()
        if "button" in lower:
            return "버튼"
        if "door" in lower:
            return "문"
        if "elev" in lower:
            return "승강기"
        return "장치"

    for prefix, suffix in (("Enter ", " 들어가기"), ("Leave ", " 나가기")):
        if stripped.startswith(prefix):
            place = stripped[len(prefix):]
            place_translation = exact.get(place) or GENERIC.get(place) or PREFERRED.get(place)
            if place_translation:
                return place_translation + suffix

    return None


def labels_in_text(text: str) -> list[str]:
    return [lua_unescape(match.group(2)) for match in REGISTER_RE.finditer(text)]


def synchronize_text(text: str, exact: dict[str, str], source_name: str) -> tuple[str, int, list[str]]:
    replacements: dict[str, str] = {}
    unresolved: list[str] = []
    for label in labels_in_text(text):
        resolved = resolve_label(label, exact)
        if resolved is None:
            unresolved.append(f"{source_name}: {label}")
        elif resolved != label:
            replacements[label] = resolved

    def replace_register(match: re.Match[str]) -> str:
        label = lua_unescape(match.group(2))
        translated = replacements.get(label)
        if translated is None:
            return match.group(0)
        return match.group(1) + '"' + lua_escape(translated) + '"'

    output = REGISTER_RE.sub(replace_register, text)
    # Some generated events repeat the same display hint in the optional tail.
    def replace_tail(match: re.Match[str]) -> str:
        label = lua_unescape(match.group(2))
        translated = replacements.get(label)
        if translated is None:
            return match.group(0)
        return match.group(1) + '"' + lua_escape(translated) + '"' + match.group(3)
    output = TAIL_RE.sub(replace_tail, output)
    return output, len(replacements), unresolved


def synchronize(repo_root: Path, catalog: dict) -> tuple[int, int, int]:
    exact = catalog_translations(catalog)
    source_worlds = repo_root / "assets_dev" / "worlds"
    overlay_worlds = repo_root / "korean" / "overlay" / "worlds"
    changed_labels = 0
    copied_files = 0
    scanned_files = 0
    unresolved: list[str] = []

    for world_dir in sorted(source_worlds.iterdir() if source_worlds.is_dir() else []):
        source_maps = world_dir / "events" / "maps"
        if not source_maps.is_dir():
            continue
        overlay_maps = overlay_worlds / world_dir.name / "events" / "maps"
        for source_path in sorted(source_maps.glob("*.lua")):
            overlay_path = overlay_maps / source_path.name
            path = overlay_path if overlay_path.is_file() else source_path
            text = path.read_text(encoding="utf-8-sig")
            labels = labels_in_text(text)
            if not labels:
                continue
            output, file_changed, file_unresolved = synchronize_text(text, exact, str(source_path.relative_to(repo_root)))
            unresolved.extend(file_unresolved)
            scanned_files += 1
            if file_changed:
                if not overlay_path.is_file():
                    overlay_path.parent.mkdir(parents=True, exist_ok=True)
                    copied_files += 1
                overlay_path.write_text(output, encoding="utf-8", newline="")
                changed_labels += file_changed

    if unresolved:
        preview = "\n".join(unresolved[:100])
        raise ValueError(f"Untranslated RegisterEvent hover labels remain ({len(unresolved)}):\n{preview}")
    return changed_labels, copied_files, scanned_files


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    args = parser.parse_args()
    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / "korean" / "translations" / "catalog.json"
    if not catalog_path.is_file():
        print("Map event-label sync: catalog not present; skipping")
        return 0
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    changed, copied, scanned = synchronize(repo_root, catalog)
    print(f"Map event-label sync: {changed} label group(s), {copied} new overlay file(s), {scanned} source map(s) scanned")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
