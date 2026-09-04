# Korean patch workspace

This directory contains only Korean-localization sources and patch tooling. It must not contain copies of the complete upstream OpenYAMM game packages.

## Authoring layout

Place changed or translated files under:

```text
korean/overlay/
  engine/
    ... files that override engine.zip ...
  worlds/
    mm6/
      ... files that override worlds/mm6.zip ...
    mm7/
      ... files that override worlds/mm7.zip ...
    mm8/
      ... files that override worlds/mm8.zip ...
    mmmerge/
      ... files that override worlds/mmmerge.zip ...
```

The path inside each overlay directory must match the path inside the corresponding upstream runtime package.

Do not copy unchanged upstream files into the overlay tree.

## Build patch archives

From the repository root:

```sh
python korean/build_patch.py
```

Output:

```text
dist/korean-patch/
  manifest.json
  SHA256SUMS.txt
  korean/
    engine.zip                  # only when engine overrides exist
    worlds/
      mm6.zip                   # only when MM6 overrides exist
      mm7.zip                   # only when MM7 overrides exist
      mm8.zip                   # only when MM8 overrides exist
      mmmerge.zip               # only when MMMerge overrides exist
```

Empty overlay packages are not generated.

## Release targets

Only these targets are release targets for this localization:

- Windows x64
- Android arm64

No Linux/Flatpak Korean release artifact should be generated.

## Runtime source patches

Korean runtime source changes must remain narrowly scoped and smoke-tested on both release targets. Character creation name entry is UTF-8 aware: Hangul input is accepted by code point, the 15-character limit counts Unicode code points rather than UTF-8 bytes, and Backspace removes one complete UTF-8 code point.

Hard-coded runtime display overrides are added only after the English string is confirmed to reach a player-visible UI or status-message path. English logic keys remain unchanged; Korean text is substituted at the final display layer and covered by focused runtime QA before native smoke builds.

## Base-version rule

Any runtime binary patch must record the exact upstream OpenYAMM version/commit it targets. A binary patch must fail rather than silently apply to an unknown executable or APK.

Text-only overlay updates should remain independent from the large upstream media packages whenever possible.
