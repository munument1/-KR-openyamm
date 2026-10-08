# OpenYAMM

> **한국어판 릴리즈 보류:** 원본 `1d7c42c4` (1.2 준비)까지 엔진을 동기화했습니다.
> 게임 번역은 `korean-localization` 브랜치에서 별도로 관리하며 용어 통일·누락 재검토가 필요합니다.
> `KOREAN_RELEASE_HOLD=true` 동안 정기·수동·태그 빌드의 공개 게시를 막습니다.
> 아래 최신 원본 문서의 영어 부분도 아직 번역 재검토 전입니다.
> 재검토 근거와 이식 충돌 목록은 [한국어판 재번역 상태](docs/KOREAN_RETRANSLATION_STATUS.md)에 정리했습니다.

OpenYAMM은 **Open Yet Another Might and Magic**의 약자로, MMMerge에서 영감을 받아 개발된
Might and Magic VI, VII, VIII의 현대적인 C++ 재구현 프로젝트입니다. 엔진은 처음에
Might and Magic VIII을 기반으로 시작했습니다.

원작의 게임 데이터와 플레이 감각은 유지하면서, 현대적인 렌더링·오디오·UI·저장/불러오기 기능과
도구 및 에디터 지원을 제공하는 깔끔하고 유지보수 가능한 크로스 플랫폼 엔진을 만드는 것이 목표입니다.

## 현재 상태

OpenYAMM에서는 Might and Magic VI, VII, VIII을 플레이할 수 있으며, 게임 간 대륙 이동도 지원합니다.
Windows, Linux, Android 빌드를 지원합니다.

주요 이야기, 전직, 퀘스트, 게임 시스템, 주문, 이동, 대화, 상점, 건물, 상자, 전투, 투사체, 인벤토리,
파티 상태, 저장/불러오기, 오디오, 동영상 및 UI 시스템이 구현되어 있습니다. 현재도 활발히 개발 중이며,
완성도 개선, 호환성, 개발 도구 및 에디터 작업이 계속 진행되고 있습니다.

## 주요 기능

- HD textures, items, equipment, portraits, and interface backgrounds
- HD MM6 monsters
- New Obsidian HUD, menus, inventory, dialogue, and journal screens
- Indoor and outdoor water with reflections, lightmaps, and shadows
- Modeled MM6 ships and HD decorations
- Enemy health bars, floating damage, and party recovery indicators
- Android touch controls and context actions

## Screenshots

**New HUD**

![Obsidian gameplay HUD with a five-character party](res/showcase/gameplay-hud.webp)

**HD items and inventory**

![God Lich inventory and equipped paperdoll](res/showcase/inventory.webp)

**Water and reflections**

![Outdoor water with bridge and sailboat reflections](res/showcase/water-shoreline.webp)

**HD MM6 monsters**

![HD MM6 hydra variants](res/showcase/creatures-hydras.webp)

**Android touch controls**

![Android gameplay in New Sorpigal with touch controls](res/showcase/android-gameplay.webp)

<details>
<summary>More interface screenshots</summary>

**Main menu**

![New main menu](res/showcase/main-menu.webp)

**Quest journal**

![Quest journal with restored fonts and navigation icons](res/showcase/journal-quests.webp)

**HD equipment**

![HD plate armor and inventory items](res/showcase/equipment-plate.webp)

**MM6 Town Portal**

![HD Enroth Town Portal map](res/showcase/town-portal-mm6.webp)

**MM8 Town Portal**

![HD Jadame Town Portal map](res/showcase/town-portal-mm8.webp)

**Recovery indicator and enemy health bars**

![Party recovery indicator after an attack, with goblin health bars](res/showcase/hud-recovery-combat.webp)

</details>

<details>
<summary>More rendering and combat screenshots</summary>

**Indoor water**

![Water and reflections in the Tomb of VARN](res/showcase/water-varn.webp)

**Lightmaps and shadows**

![Lightmaps and shadows around buildings and a timber gate](res/showcase/lighting-street.webp)

**HD decorations**

![HD flowers, trees, and stonework in New Sorpigal](res/showcase/world-decorations.webp)

**Modeled MM6 ships**

![Modeled MM6 ships at the harbor](res/showcase/world-ships.webp)

**HD MM6 dragon**

![HD MM6 red dragon](res/showcase/creatures-dragon.webp)

**Floating damage**

![Floating damage number above a Thunder Lizard](res/showcase/combat-floating-damage.webp)

</details>

<details>
<summary>More Android screenshots</summary>

**Shop interaction**

![Touch targeting and the shop interaction button](res/showcase/android-shop.webp)

**NPC interaction**

![NPC target highlight and the conversation button](res/showcase/android-npc.webp)

</details>

## 에셋

개발용 에셋은 다음 경로에서 불러옵니다.

```text
assets_dev/
```

기본 개발 디렉터리 구성은 다음과 같습니다.

```text
assets_dev/
  engine/             shared tables, scripts and presentation
  worlds/mm6/         world-local maps and presentation
  worlds/mm7/
  worlds/mm8/
  worlds/mmmerge/     Merge-specific maps
```

런타임 패키지는 다음 경로 아래에 ZIP 압축 파일로 배포할 수 있습니다.

```text
assets/
```

엔진은 TXT 게임 데이터 테이블, BMP 계열 이미지, WAV 효과음, MP3/FLAC 음악, OGV 동영상처럼
실용적인 원본 에셋 형식을 유지합니다. 오래된 아카이브 및 동영상 컨테이너 형식은 런타임용 형식으로
대체됩니다.

Runtime assets and the prebuilt Android sprite profile are stored directly
in Git, so a normal clone can build and launch against `assets_dev` and CI can package
Android without texture encoding or Git LFS. The lossless sprite inputs, creature
master bank, original extractions and editor assets are optional local authoring
data. See [asset storage and optional review tools](tools/ASSET_STORAGE.md).
The MM9 world payload is currently local and is excluded from the portable checkout.

## Building

The engine uses C++20, SDL3, bgfx, PhysicsFS, FFmpeg, and Lua. Gameplay tables
use tab-separated text, and scene and UI layouts use YAML.

Requirements:

- CMake 3.22 or newer
- C++20 compiler
- Git and Python 3.11 or newer
- standard native build tools for your platform

CMake fetches and builds the project dependencies, including Lua 5.4. A separate
system Lua development package is not required.

Configure and build:

```sh
cmake -S . -B build
cmake --build build --target openyamm -j25
```

실행:

```sh
./build/game/openyamm
```

테스트 빌드 및 실행:

```sh
cmake --build build --target openyamm_unit_tests -j25
./build/tests/openyamm_unit_tests
```

에디터 빌드:

```sh
cmake -S . -B build -DOPENYAMM_BUILD_EDITOR=ON
cmake --build build --target openyamm-editor -j25
```

에디터 실행:

```sh
./build/editor/openyamm-editor
```

## Visual Checks

For repeatable visual checks, see [Desktop runs and native screenshot tours](tools/RUN_GAME.md).
The game can save PNGs directly through bgfx, including the HUD, on Wayland or X11. Use the debug
console command `screenshot [name]`, launch-time capture settings, or a YAML tour to capture several
camera poses in one run. Ready-to-run MM6/MM7/MM8 water viewpoints are in
[`tools/screenshot_tours/`](tools/screenshot_tours/).

## Nightly Builds

The [Package builds](https://github.com/pjasicek/openyamm/actions/workflows/nightly.yml) GitHub Actions workflow
builds unsigned Windows x64, x86_64 Flatpak, and signed Android arm64 packages every day at 03:27 UTC. After all
packages pass structural and checksum checks, the workflow uploads complete packages to Nextcloud and updates the
[nightly prerelease](https://github.com/pjasicek/openyamm/releases/tag/nightly) with download links and checksums.
Public release links are published once a public Nextcloud folder share is configured.
See [Nextcloud publishing setup](packaging/NEXTCLOUD.md) for the repository secrets and public folder share.
The same workflow can be run manually,
with publishing optionally disabled so the packages remain short-lived workflow artifacts.

`main` 브랜치에 푸시할 때마다 Windows x64, x86_64 Flatpak, Android arm64용 패키지 빌드도 각각 실행됩니다.
해당 커밋의 Actions 페이지에서 `Package builds` 실행을 열면 SHA 이름의 아티팩트를 내려받을 수 있습니다.
커밋 아티팩트는 하루 동안 보관되며, 예약 빌드는 계속해서 순차 갱신형 나이틀리 프리릴리스를 업데이트합니다.

Windows에서는 ZIP을 푼 뒤 `openyamm.exe`를 실행합니다. Flatpak 번들은 다음 명령으로 설치하거나 갱신합니다.

```sh
flatpak install --user --reinstall OpenYAMM-nightly-x86_64.flatpak
```

Android 6.0 이상을 사용하는 arm64 기기에서는 `OpenYAMM-nightly-android-arm64.apk`를 내려받아 실행하면
나이틀리를 설치하거나 갱신할 수 있습니다. APK를 여는 데 사용한 브라우저 또는 파일 관리자에서 앱 설치를
허용하라는 안내가 표시될 수 있습니다.

나이틀리 패키지는 개발 중인 스냅샷이므로 불안정할 수 있습니다. 사용하기 전에 기존 저장 파일을 백업하는
것이 좋습니다. 패키지에 포함된 게임 에셋의 배포에는 Windows 배포 문서에 설명된 에셋 배포 권한이 적용됩니다.

## 태그 릴리스

Pushing a canonical `X.Y` tag, such as `1.0`, runs the same validated package builds. With public Nextcloud
publishing configured, it creates a normal GitHub release for that tag. The release links to versioned
Windows, Flatpak, and signed Android packages on Nextcloud and contains their SHA256 files.
The Android version name matches the tag; its monotonically increasing version code is calculated as
`major * 10000 + minor * 100` (`1.0` becomes `10000`).

릴리스용 태그를 만들기 전에 워크플로 변경 사항이 해당 커밋에 포함되어 있어야 합니다.

```sh
git tag -a 1.0 -m "OpenYAMM 1.0"
git push origin 1.0
```

워크플로는 정식 형식이 아닌 버전을 거부하며, 태그 릴리스를 프리릴리스로 표시하지 않고, 같은 태그의 기존
릴리스를 덮어쓰지 않습니다.

## 주요 CMake 옵션

```text
OPENYAMM_BUILD_EDITOR=ON      에디터 대상 빌드
OPENYAMM_BUILD_TOOLS=ON       에셋 및 데이터 도구 빌드
OPENYAMM_BUILD_TESTS=ON       단위 테스트 빌드
OPENYAMM_DEV_ASSETS_DIR=...   개발용 에셋 디렉터리 변경
OPENYAMM_USE_SYSTEM_SDL3=ON   시스템에 설치된 SDL3 패키지 사용
```

## 저장소 구성

```text
engine/              shared runtime systems
game/                game application and gameplay systems
editor/              editor application
tools/               asset cooking, reusable review apps and development tools
tests/               unit and regression tests
assets_dev/          development asset root
assets_cooked/android/sprites_new/  prebuilt Android creature GPU packages
assets_source/       optional authoring banks (local; selected binaries can use LFS)
assets_editor_dev/   optional local editor asset root
level_generation/    optional local generation projects (excluded from Git)
reference/           local behavioral/data references (excluded from Git and LFS)
res/                 README screenshots
```

## 라이선스

OpenYAMM's original source code, build scripts, tests, and documentation are licensed under the
**GNU General Public License, version 3 or later** (`GPL-3.0-or-later`), unless otherwise stated.
Copyright (C) 2026 Petr Jasicek (pjasicek).

See [LICENSE](LICENSE) for the full license and [COPYRIGHT](COPYRIGHT) for the attribution and scope.
Distributors must preserve the applicable copyright notices and make the corresponding source available
as required by the GPL. OpenYAMM is provided without warranty.

Third-party dependencies retain their own licenses. Original Might and Magic assets, imported game data,
and their converted or restored versions are not covered by the OpenYAMM code license; their distribution
requires the appropriate rights from their respective rights holders.

## 에디터 화면

![에디터 화면 1](res/editor_1.webp)
![에디터 화면 2](res/editor_2.webp)

## 감사의 말

OpenYAMM은 Might and Magic 커뮤니티가 오랜 기간 쌓아 온 작업과 연구를 바탕으로 만들어졌습니다.
다음 분들께 감사드립니다.

- OpenEnroth 개발팀
- Rodril 및 모든 MMMerge 기여자
