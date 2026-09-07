#!/usr/bin/env python3
from __future__ import annotations

import argparse
import ast
import json
import re
from collections import Counter
from pathlib import Path

LITERAL_RE = re.compile(r'"((?:\\.|[^"\\])*)"')
PAIR_RE = re.compile(r'\{\s*"((?:\\.|[^"\\])*)"\s*,\s*"((?:\\.|[^"\\])*)"\s*\}')
WORD_RE = re.compile(r'[A-Za-z]+')
HANGUL_RE = re.compile(r'[가-힣]')

SOURCE_SUFFIXES = {'.cpp', '.h', '.hpp', '.inc'}
EXCLUDED_PARTS = {
    'tests', 'test', 'tools', 'third_party', 'external', 'generated', 'build',
}

INTERNAL_FILE_PREFIXES = (
    'game/content/',
    'game/debug/',
    'game/maps/IndoorSceneYml.cpp',
    'game/maps/OutdoorSceneYml.cpp',
    'game/maps/MapItemSourceYml.cpp',
    'game/maps/MapPresentation.cpp',
    'game/outdoor/HeadlessOutdoorDiagnostics.cpp',
    'game/outdoor/OutdoorLightingData.cpp',
    'game/outdoor/OutdoorNavigationData.cpp',
    'game/outdoor/OutdoorRenderData.cpp',
    'game/scenario/',
    'game/data/GameDataLoader.cpp',
    'game/tables/HouseTable.cpp',
    'game/tables/ItemTable.cpp',
    'game/tables/MergedBaseTables.cpp',
    'game/tables/SpellTable.cpp',
    'game/tables/SpriteTables.cpp',
    'game/tables/SurfaceMaterialTable.cpp',
    'game/audio/SoundCatalog.cpp',
)

INTERNAL_LINE_MARKERS = (
    '#include', 'GAMEPLAY_DEBUG_TRACE', 'std::cout', 'std::cerr', 'spdlog',
    'logger.', 'Log::', 'assert(', 'static_assert(', 'throw ', 'TODO', 'FIXME',
    'm_debugConsole.', '.description =', '.usage =', 'lastActivationResult',
    'errorMessage =', 'itemNameEquals(', 'itemNameContains(', 'isHouseType(',
    'm_lastStatus =', 'trace <<', 'out <<', 'traceInputPromptQuoted(',
)
INTERNAL_TEXT_MARKERS = (
    ' reason=', ' item_id=', ' source_id=', ' actor_', ' status=',
    'runtime init', 'runtime apply', 'held_item_changed', 'dialogue_',
    'actor_dialog_', 'item_inspect ', 'bgfx ', 'SDL_', 'avcodec_',
    'avformat_', 'settings.ini', 'Usage:', 'Known regression',
    'parse error', 'Parse error', 'out of range for', 'unsupported opcode',
    'missing required', 'failed to parse', 'Failed to parse',
)
PLAYER_SINK_MARKERS = (
    'setStatusBarEvent', 'setStatus', 'statusBar', 'statusText', 'hover', 'Hover',
    'dialog', 'Dialog', 'message', 'Message', 'title', 'Title', 'label', 'Label',
    'description', 'Description', 'drawText', 'renderText', 'displayText',
    'tooltip', 'Tooltip', 'prompt', 'Prompt', 'certificate.', 'endingText',
    'characterLine', 'scoreLine', 'totalTimeLine', 'renderHud', 'drawScreenText',
)

DEDICATED_DISPLAY = {
    'Only two additional skills can be selected.',
    'Character name cannot be empty.',
    'Create Party cannot be completed unless you have assigned all characters 2 extra skills and have spent all of your bonus points.',
}


def decode_cpp(raw: str) -> str:
    try:
        return ast.literal_eval('"' + raw + '"')
    except (SyntaxError, ValueError):
        return raw


def implementation_literal(text: str) -> bool:
    t = text.strip()
    if len(t) < 2:
        return True
    if '/' in t or '\\' in t:
        return True
    if re.search(r'\.(cpp|h|hpp|inc|txt|lua|yml|yaml|png|bmp|lod|odm|blv|wav|smk|vid|ttf|otf)$', t, re.I):
        return True
    if re.fullmatch(r'[A-Za-z0-9_:\-.]+', t) and ' ' not in t and len(WORD_RE.findall(t)) != 1:
        return True
    if t.startswith(('game/', 'ui/', 'engine/', 'assets/', 'fonts/')):
        return True
    return False


def source_files(root: Path) -> list[Path]:
    out: list[Path] = []
    game = root / 'game'
    for path in game.rglob('*'):
        if not path.is_file() or path.suffix not in SOURCE_SUFFIXES:
            continue
        rel = path.relative_to(root)
        if any(part.lower() in EXCLUDED_PARTS for part in rel.parts):
            continue
        out.append(path)
    return sorted(out)


def collect_coverage(root: Path) -> tuple[set[str], set[str]]:
    coverage_files = [
        root / 'game/ui/GameplayHudCommon.cpp',
        root / 'game/ui/KoreanRuntimeTextOverrides.h',
        root / 'game/ui/KoreanDecorationText.h',
        root / 'game/ui/screens/NewGameScreen.cpp',
        root / 'game/ui/screens/NewGameScreen.h',
    ]
    exact: set[str] = set()
    components: set[str] = set()

    for path in coverage_files:
        if not path.exists():
            continue
        content = path.read_text(encoding='utf-8')
        for match in PAIR_RE.finditer(content):
            key = decode_cpp(match.group(1)).strip()
            value = decode_cpp(match.group(2)).strip()
            if HANGUL_RE.search(value):
                exact.add(key)
        if path.name == 'KoreanRuntimeTextOverrides.h':
            # Dynamic runtime localization is largely expressed through startsWith/
            # endsWith/between fragments. Normalize whitespace here so source
            # fragments match localizer fragments after stripping.
            for match in LITERAL_RE.finditer(content):
                value = decode_cpp(match.group(1)).strip()
                if len(WORD_RE.findall(value)) >= 1 and not HANGUL_RE.search(value):
                    components.add(value)

    return exact, components


def coverage_kind(text: str, exact: set[str], components: set[str]) -> str:
    if text in exact:
        return 'exact_override'
    if text in DEDICATED_DISPLAY:
        return 'dedicated_display'
    if text in components:
        return 'dynamic_override_component'
    # Adjacent C++ string literals split some exact display strings across lines.
    if len(text) >= 8 and any(text in covered for covered in exact):
        return 'exact_override_component'
    return 'uncovered'


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', default='.')
    parser.add_argument('--json-out', default='runtime-display-audit.json')
    parser.add_argument('--tsv-out', default='runtime-display-audit.tsv')
    args = parser.parse_args()

    root = Path(args.root).resolve()
    files = source_files(root)
    exact, components = collect_coverage(root)
    rows: list[dict[str, object]] = []

    for path in files:
        rel = path.relative_to(root).as_posix()
        # Do not audit the localizers themselves as source English debt.
        if rel in {
            'game/ui/GameplayHudCommon.cpp',
            'game/ui/KoreanRuntimeTextOverrides.h',
            'game/ui/KoreanDecorationText.h',
            'game/ui/MenuScreenKoreanText.inc',
        }:
            continue
        internal_file = rel.startswith(INTERNAL_FILE_PREFIXES)
        lines = path.read_text(encoding='utf-8', errors='replace').splitlines()
        for lineno, line in enumerate(lines, 1):
            stripped = line.strip()
            if any(marker in stripped for marker in INTERNAL_LINE_MARKERS):
                continue
            player_sink = any(marker in stripped for marker in PLAYER_SINK_MARKERS)
            for match in LITERAL_RE.finditer(line):
                text = decode_cpp(match.group(1)).strip()
                words = WORD_RE.findall(text)
                if not words or HANGUL_RE.search(text) or implementation_literal(text):
                    continue
                # Single-word literals are useful only when they are passed directly
                # to a likely player-facing text sink. This catches labels such as
                # "Name" without flooding the report with semantic lookup keys.
                if len(words) == 1 and not player_sink:
                    continue
                if any(marker in text for marker in INTERNAL_TEXT_MARKERS):
                    continue
                if len(words) >= 2 and ' ' not in text and not any(ch in text for ch in '.!?'):
                    continue

                coverage = coverage_kind(text, exact, components)
                confidence = 'high' if player_sink and not internal_file else 'medium'
                if coverage != 'uncovered':
                    confidence = 'covered'

                rows.append({
                    'file': rel,
                    'line': lineno,
                    'literal': text,
                    'coverage': coverage,
                    'confidence': confidence,
                    'source_line': stripped,
                })

    dedup = {(r['file'], r['line'], r['literal']): r for r in rows}
    rows = sorted(dedup.values(), key=lambda r: (
        r['coverage'] != 'uncovered',
        r['confidence'] != 'high',
        r['file'], r['line'], r['literal']))

    uncovered = [r for r in rows if r['coverage'] == 'uncovered']
    high = [r for r in uncovered if r['confidence'] == 'high']
    medium = [r for r in uncovered if r['confidence'] == 'medium']
    covered = [r for r in rows if r['coverage'] != 'uncovered']

    result = {
        'format': 6,
        'scanned_files': len(files),
        'candidate_occurrences': len(rows),
        'covered_occurrences': len(covered),
        'uncovered_occurrences': len(uncovered),
        'high_confidence_uncovered_occurrences': len(high),
        'high_confidence_unique_literals': len({r['literal'] for r in high}),
        'medium_confidence_uncovered_occurrences': len(medium),
        'medium_confidence_unique_literals': len({r['literal'] for r in medium}),
        'rows': rows,
    }
    Path(args.json_out).write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')

    with Path(args.tsv_out).open('w', encoding='utf-8', newline='') as f:
        f.write('confidence\tcoverage\tfile\tline\tliteral\tsource_line\n')
        for r in rows:
            values = [
                str(r['confidence']), str(r['coverage']), str(r['file']), str(r['line']),
                str(r['literal']).replace('\t', ' ').replace('\n', '\\n'),
                str(r['source_line']).replace('\t', ' ').replace('\n', ' '),
            ]
            f.write('\t'.join(values) + '\n')

    print(f"SCANNED_FILES={result['scanned_files']}")
    print(f"CANDIDATE_OCCURRENCES={result['candidate_occurrences']}")
    print(f"COVERED_OCCURRENCES={result['covered_occurrences']}")
    print(f"UNCOVERED_OCCURRENCES={result['uncovered_occurrences']}")
    print(f"HIGH_UNCOVERED_OCCURRENCES={result['high_confidence_uncovered_occurrences']}")
    print(f"HIGH_UNIQUE_LITERALS={result['high_confidence_unique_literals']}")
    print(f"MEDIUM_UNCOVERED_OCCURRENCES={result['medium_confidence_uncovered_occurrences']}")
    print(f"MEDIUM_UNIQUE_LITERALS={result['medium_confidence_unique_literals']}")

    counts = Counter(r['file'] for r in high)
    print('--- HIGH CONFIDENCE BY FILE ---')
    for file, count in counts.most_common():
        print(f'{count:4d}\t{file}')
    print('--- HIGH CONFIDENCE UNIQUE LITERALS ---')
    seen: set[str] = set()
    for r in high:
        literal = str(r['literal'])
        if literal in seen:
            continue
        seen.add(literal)
        print(f"{r['file']}:{r['line']}\t{literal}")
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
