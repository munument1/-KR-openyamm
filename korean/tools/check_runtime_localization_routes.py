#!/usr/bin/env python3
"""Guard runtime-visible Korean localization routes that bypass table overlays."""

from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read(relative: str) -> str:
    return (ROOT / relative).read_text(encoding="utf-8")


def require(text: str, fragment: str, label: str) -> None:
    if fragment not in text:
        raise SystemExit(f"missing {label}: {fragment!r}")


def forbid(text: str, fragment: str, label: str) -> None:
    if fragment in text:
        raise SystemExit(f"unexpected {label}: {fragment!r}")


def main() -> int:
    runtime = read("game/ui/KoreanRuntimeTextOverrides.h")
    party_overlay = read("game/ui/GameplayPartyOverlayRenderer.cpp")
    hud_common = read("game/ui/GameplayHudCommon.cpp")
    ui_runtime = read("game/ui/GameplayUiRuntime.cpp")
    screen_runtime = read("game/gameplay/GameplayScreenRuntime.cpp")
    dialogue_renderer = read("game/ui/GameplayDialogueRenderer.cpp")
    arcomage = read("game/ui/screens/ArcomageScreen.cpp")

    # Concrete leaks found by runtime-source audit.
    require(runtime, 'if (text == "Ooops") return "이런!";', "potion-mixing failure localization")
    require(runtime, 'startsWith(text, "Deposited ")', "bank deposit localization")
    require(runtime, 'startsWith(text, "Withdrew ")', "bank withdrawal localization")
    require(runtime, 'startsWith(text, "Answer: ")', "typed event-answer localization")
    require(runtime, 'text.find(" needs ") != std::string::npos', "named-character experience requirement localization")
    require(runtime, 'text.find(" is eligible to train up to level ")', "named-character training eligibility localization")
    require(runtime, 'subject == "This character" ? std::string("이 캐릭터") : subject', "generic experience subject localization")

    # Rest screen time must be born Korean rather than relying on a fragile parser.
    require(party_overlay, 'hour24 >= 12 ? "오후" : "오전"', "Korean rest meridiem")
    require(party_overlay, '"%s %d:%02d"', "Korean rest time order")
    forbid(party_overlay, 'hour24 >= 12 ? "pm" : "am"', "English rest meridiem")

    # All ordinary HUD/dialogue text must pass through the common localizer before
    # measuring, wrapping and rendering. This prevents translated Korean from being
    # laid out using the width of the original English literal.
    require(hud_common, "localizedGameplayHudText(text)", "common HUD localization entry")
    require(hud_common, "GameplayHudCommon::measureHudTextWidth", "common HUD measurement route")
    require(hud_common, "GameplayHudCommon::wrapHudTextToWidth", "common HUD wrapping route")
    require(hud_common, "GameplayHudCommon::renderHudFontLayer", "common HUD render route")
    require(ui_runtime, "GameplayHudCommon::measureHudTextWidth", "UI runtime measurement delegation")
    require(ui_runtime, "GameplayHudCommon::wrapHudTextToWidth", "UI runtime wrapping delegation")
    require(ui_runtime, "GameplayHudCommon::renderHudFontLayer", "UI runtime render delegation")
    require(screen_runtime, "uiRuntime().measureHudTextWidth", "gameplay runtime measurement delegation")
    require(screen_runtime, "uiRuntime().wrapHudTextToWidth", "gameplay runtime wrapping delegation")
    require(screen_runtime, "uiRuntime().renderHudFontLayer", "gameplay runtime render delegation")
    require(dialogue_renderer, "renderHudFontLayer", "dialogue renderer common HUD route")

    # Arcomage is a direct-screen renderer and therefore needs its own display
    # boundary localization before width calculation and drawing.
    require(arcomage, "KoreanRuntimeText::koreanRuntimeTextOverride(text).value_or(text)", "Arcomage direct localization")
    require(arcomage, "localizedText", "Arcomage localized draw text")

    print("Korean runtime localization route checks passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
