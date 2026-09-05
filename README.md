# OpenYAMM 0.11 한국어판

이 저장소는 **OpenYAMM 0.11의 한국어판**입니다. OpenYAMM은 *Open Yet Another Might and Magic*의 약자로,
Might and Magic VI, VII, VIII을 현대적인 C++로 다시 구현한 프로젝트입니다. MMMerge에서 영감을 받았으며,
Might and Magic VIII을 기반으로 시작한 엔진 위에서 동작합니다.

원작의 게임 데이터와 플레이 감각은 유지하면서 현대적인 렌더링, 오디오, UI, 저장·불러오기, 도구 및
에디터 기능을 제공하는 깔끔하고 유지보수 가능한 크로스 플랫폼 엔진을 만드는 것이 목표입니다.

한국어판은 게임 내 텍스트와 플레이어에게 표시되는 런타임 UI를 한국어로 제공하며, 한국어 입력과
한글 글꼴 표시를 지원합니다.

한글 글꼴은 [갈무리11](https://github.com/quiple/galmuri) 2.40.4를 사용합니다. 원본 12px 픽셀 격자에
맞춰 메뉴와 게임 화면의 한글을 렌더링하며, 배포 패키지에 SIL Open Font License를 함께 포함합니다.
이미지에 새겨진 영어 제목·장식 문구는 원본을 유지합니다.

## 현재 상태

Might and Magic VI, VII, VIII을 플레이할 수 있으며 게임 간 대륙 이동도 지원합니다. Windows, Linux,
Android 빌드를 제공합니다.

주요 이야기, 전직, 퀘스트, 게임 시스템, 주문, 이동, 대화, 상점, 건물, 상자, 전투, 투사체, 인벤토리,
파티 상태, 저장·불러오기, 오디오, 동영상 및 UI 시스템이 구현되어 있습니다. 다듬기, 호환성, 개발 도구와
에디터 작업은 계속 진행 중입니다.

## 주요 기능

- C++20 코드베이스
- SDL3 기반 플랫폼·입력·오디오 계층
- bgfx 렌더러
- PhysicsFS 에셋 파일 시스템
- FFmpeg 기반 동영상 재생
- Lua 기반 이벤트 스크립트
- 탭으로 구분된 게임 데이터 테이블
- YAML 장면 및 UI 레이아웃 데이터
- 게임 시스템 단위·회귀 테스트
- 게임 텍스트 및 런타임 UI 한국어화
- UTF-8 한국어 이름 입력 및 한글 글꼴 지원

## 에셋

개발용 에셋은 다음 경로에서 불러옵니다.

```text
assets_dev/
```

기본 개발 디렉터리 구성은 다음과 같습니다.

```text
assets_dev/
  Anims/
  Data/
  Music/
```

배포용 런타임 패키지는 다음 경로 아래에 ZIP 압축 파일로 둘 수 있습니다.

```text
assets/
```

엔진은 TXT 게임 데이터, BMP 계열 이미지, WAV 효과음, MP3/FLAC 음악, OGV 동영상처럼 실용적인 원본
형식을 유지합니다. 오래된 아카이브와 동영상 컨테이너 형식은 런타임용 형식으로 대체됩니다.

## 릴리스 내려받기

한국어판 배포 버전은 [GitHub Releases](https://github.com/munument1/-KR-openyamm/releases)에서 받을 수 있습니다.

`0.11-korean-r2`는 갈무리11과 캐릭터 생성 기술명 줄바꿈 수정에 이어, 기술 습득·승급 안내,
현상금·엔딩 문구, 행동 버튼의 한글 잘림, 저장·불러오기 날짜 표시를 수정한 한국어판 업데이트입니다.
이전 릴리스는 보존하며, Android 버전 코드도 올려 기존 앱 위에 갱신할 수 있게 합니다.

- `OpenYAMM-0.11-korean-r2-windows-x64.zip` — Windows x64
- `OpenYAMM-0.11-korean-r2-x86_64.flatpak` — Linux x86_64 Flatpak
- `OpenYAMM-0.11-korean-r2-android-arm64.apk` — Android arm64 서명 APK
- 각 패키지의 `.sha256` 파일 — 다운로드 무결성 확인용 체크섬

Windows에서는 ZIP을 푼 뒤 `openyamm.exe`를 실행합니다. Flatpak은 다음 명령으로 설치하거나 갱신합니다.

```sh
flatpak install --user --reinstall OpenYAMM-0.11-korean-r2-x86_64.flatpak
```

Android 6.0 이상의 arm64 기기에서는 APK를 내려받아 실행합니다. 브라우저 또는 파일 관리자에서 앱 설치를
허용하라는 안내가 표시될 수 있습니다.

배포 패키지는 개발 중인 버전일 수 있으므로 기존 저장 파일을 미리 백업하는 것이 좋습니다. 포함된 게임
에셋의 배포에는 Windows 배포 문서에 설명된 에셋 배포 권한이 적용됩니다.

## 빌드하기

필요한 도구:

- CMake 3.24 이상
- C++20 지원 컴파일러
- Lua 5.3 또는 5.4 개발 패키지
- 플랫폼별 표준 네이티브 빌드 도구

구성 및 빌드:

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

## 자동 패키징

`Package builds` GitHub Actions 워크플로는 Windows x64 ZIP, x86_64 Flatpak, 서명된 Android arm64 APK를
빌드합니다. 각 패키지의 구조와 SHA-256 체크섬 검사를 모두 통과한 경우에만 GitHub Release로 게시합니다.

한국어판 정식 릴리스 태그는 `X.Y-korean` 형식을 사용합니다.

```sh
git tag -a 0.11-korean -m "OpenYAMM 0.11-korean"
git push origin 0.11-korean
```

Android 버전 코드는 `major * 10000 + minor * 100`으로 계산합니다. 예를 들어 `0.11-korean`은 버전 코드
`1100`을 사용합니다. 이미 존재하는 같은 이름의 릴리스는 자동으로 덮어쓰지 않습니다.

## 주요 CMake 옵션

```text
OPENYAMM_BUILD_EDITOR=ON      에디터 대상 빌드
OPENYAMM_BUILD_TOOLS=ON       에셋 및 데이터 도구 빌드
OPENYAMM_BUILD_TESTS=ON       단위 테스트 대상 빌드
OPENYAMM_DEV_ASSETS_DIR=...   개발용 에셋 디렉터리 변경
OPENYAMM_USE_SYSTEM_SDL3=ON   시스템에 설치된 SDL3 사용
```

## 저장소 구성

```text
engine/              공용 런타임 시스템
game/                게임 애플리케이션 및 게임 시스템
editor/              에디터 애플리케이션
tools/               에셋 및 데이터 도구
tests/               단위·회귀 테스트
assets_dev/          개발용 에셋 루트
assets_editor_dev/   에디터 개발용 에셋 루트
res/                 README 스크린샷
```

## 라이선스

현재 별도의 라이선스가 선언되어 있지 않습니다.

## 게임 화면

![게임 화면 1](res/ss_1.webp)
![게임 화면 2](res/ss_2.webp)
![게임 화면 3](res/ss_3.webp)
![게임 화면 4](res/ss_4.webp)
![게임 화면 5](res/ss_5.webp)
![게임 화면 6](res/ss_6.webp)
![게임 화면 7](res/ss_7.webp)
![게임 화면 8](res/ss_8.webp)

## 에디터 화면

![에디터 화면 1](res/editor_1.webp)
![에디터 화면 2](res/editor_2.webp)

## 감사의 말

OpenYAMM은 Might and Magic 커뮤니티가 오랜 기간 쌓아 온 작업과 연구를 바탕으로 만들어졌습니다.
다음 분들께 감사드립니다.

- OpenEnroth 개발팀
- Rodril 및 모든 MMMerge 기여자
