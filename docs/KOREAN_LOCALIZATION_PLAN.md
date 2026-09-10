# OpenYAMM Korean Localization Plan

This branch is the Korean localization branch for OpenYAMM.

## Fixed distribution rules

The Korean project does **not** redistribute the full OpenYAMM runtime or the full MM6/MM7/MM8 asset packages.

Release artifacts must contain only files that are new or changed by the Korean localization and are intended to be layered over an official OpenYAMM build.

Supported targets are limited to:

- Windows x64
- Android arm64

Flatpak/Linux packages are outside the Korean release scope.

## Games in scope

OpenYAMM provides a shared engine for:

- Might and Magic VI
- Might and Magic VII
- Might and Magic VIII
- MMMerge compatibility data used by the shared runtime

The Korean localization is therefore maintained as one project, with world-specific data kept separate where the upstream package layout separates it.

MM9 development data is not part of the Korean localization target at this stage.

## Runtime overlay layout

Korean assets are authored under `korean/overlay/` and packaged as small ZIP overlays:

```text
korean/
  engine.zip
  worlds/
    mm6.zip
    mm7.zip
    mm8.zip
    mmmerge.zip
```

The intended installed locations are:

### Windows x64

```text
OpenYAMM/
  openyamm.exe
  assets/
    engine.zip
    worlds/
      mm6.zip
      mm7.zip
      mm8.zip
      mmmerge.zip
    korean/
      engine.zip
      worlds/
        mm6.zip
        mm7.zip
        mm8.zip
        mmmerge.zip
```

### Android arm64

The official APK remains the source of the large base assets. Korean overlay packages are intended to live in the app-specific external files directory:

```text
Android/data/org.openyamm.android/files/
  korean/
    engine.zip
    worlds/
      mm6.zip
      mm7.zip
      mm8.zip
      mmmerge.zip
```

OpenYAMM must mount the Korean engine overlay ahead of the official engine package and mount the Korean active-world overlay ahead of the official active-world package. World switching must remount the corresponding Korean world overlay.

## Why separate world overlays

MM6, MM7 and MM8 reuse many logical asset paths. A single root-level replacement archive would allow one game's translated table to shadow another game's table.

Keeping `mm6.zip`, `mm7.zip` and `mm8.zip` separate follows upstream's package boundaries and allows the active world to select the correct localized data.

## Text localization

Much of the game text is already available as plain text/TSV data, including NPC dialogue, topics, quests, items, spells, skills, autonotes and awards. These tables should be translated in place inside the Korean world overlays while preserving IDs, columns, placeholders and script-sensitive tokens.

Map events are Lua and should only be edited when user-visible strings are actually embedded in scripts or when Korean grammar requires a runtime-specific adjustment.

## Font and Unicode strategy

The current HUD font renderer is byte-oriented and based on 256-glyph legacy bitmap fonts. UTF-8 Korean therefore requires an engine-side compatibility layer.

The preferred strategy is:

1. Keep the original legacy `.FNT` path for existing Latin text.
2. Decode UI strings as UTF-8 code points rather than individual bytes.
3. Add a supplemental Unicode/Hangul glyph atlas for Korean code points.
4. Make measuring, clamping, wrapping and rendering UTF-8 safe.
5. For Korean/CJK text, allow line breaking by code point when a run without spaces exceeds the available width.

This avoids replacing the entire legacy font system and minimizes regressions in existing MM6/MM7/MM8 layouts.

## Release model

Normal Korean releases should contain only:

- Korean overlay ZIPs that changed
- any small bootstrap/runtime binary patch required for Korean Unicode or overlay mounting
- patch metadata/checksums/install instructions

They must not contain the upstream multi-gigabyte MM6/MM7/MM8 media packages.

For Android, if an upstream official APK does not yet support external Korean overlays, the preferred distribution is a small binary patch against the matching official APK rather than redistributing the complete APK. Once overlay support is available in an official build, Korean content updates should require only the external Korean ZIPs.
