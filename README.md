# OpenYAMM

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

- C++20 코드베이스
- SDL3 기반 플랫폼·입력·오디오 계층
- bgfx 렌더러
- PhysicsFS 에셋 파일 시스템
- FFmpeg 기반 동영상 재생
- Lua 기반 이벤트 스크립트
- 탭으로 구분된 게임 데이터 테이블
- YAML 장면 및 UI 레이아웃 데이터
- 게임 시스템 단위 테스트 및 회귀 테스트

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

런타임 패키지는 다음 경로 아래에 ZIP 압축 파일로 배포할 수 있습니다.

```text
assets/
```

엔진은 TXT 게임 데이터 테이블, BMP 계열 이미지, WAV 효과음, MP3/FLAC 음악, OGV 동영상처럼
실용적인 원본 에셋 형식을 유지합니다. 오래된 아카이브 및 동영상 컨테이너 형식은 런타임용 형식으로
대체됩니다.

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

## 나이틀리 빌드

[나이틀리 릴리스](https://github.com/pjasicek/openyamm/actions/workflows/nightly.yml) GitHub Actions 워크플로는
매일 03:27 UTC에 서명되지 않은 Windows x64, x86_64 Flatpak, 서명된 Android arm64 패키지를 빌드합니다.
모든 패키지가 구조 검사와 체크섬 검사를 통과하면 워크플로가 순차 갱신되는
[나이틀리 프리릴리스](https://github.com/pjasicek/openyamm/releases/tag/nightly)를 업데이트합니다.
같은 워크플로를 수동으로 실행할 수도 있으며, 게시를 비활성화하면 패키지는 단기 보관되는 워크플로
아티팩트로만 남습니다.

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

`0.7`처럼 정식 `X.Y` 태그를 푸시하면 동일한 검증 패키지 빌드가 실행되고 해당 태그의 일반 GitHub Release가
생성됩니다. 릴리스에는 버전이 붙은 Windows, Flatpak, 서명된 Android 패키지와 SHA256 파일이 포함됩니다.
Android 버전 이름은 태그와 같으며, 단조 증가하는 버전 코드는 `major * 10000 + minor * 100`으로 계산됩니다.
예를 들어 `0.7`은 `700`이 됩니다.

릴리스용 태그를 만들기 전에 워크플로 변경 사항이 해당 커밋에 포함되어 있어야 합니다.

```sh
git tag -a 0.7 -m "OpenYAMM 0.7"
git push origin 0.7
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
engine/              공용 런타임 시스템
game/                게임 애플리케이션 및 게임 시스템
editor/              에디터 애플리케이션
tools/               에셋 및 데이터 도구
tests/               단위 테스트 및 회귀 테스트
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
