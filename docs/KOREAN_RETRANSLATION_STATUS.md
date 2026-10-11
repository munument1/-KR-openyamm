# 한국어판 최신화 및 릴리즈 보류 — 2026-10-11

## 현재 기준

- 엔진 기본 브랜치: 공식 `pjasicek/openyamm`의 `059808fb06aa57ad57392a876339042f57f1b002`까지 동기화. 1.2 준비 커밋이며 정식 1.2 릴리즈 완료를 뜻하지 않는다.
- 이전 기본 브랜치 `d8784fcef5ce5ad6c0e48777bf2fd468415b2ae6` 이후 upstream 27개 커밋 반영(2026-10-11 기준, 추가 4개 포함).
- 2026-10-11 추가 동기화 내용: 3D 모델/텍스처 쿠커, 하늘·구름·날씨 자산, 렌더링·영상 설정 및 Flatpak 빌드 소스 반영. 새 UI 문자열은 한국어 브랜치 이식 시 다시 추출해야 한다.
- 기존 한국어 번역은 `korean-localization`의 `2710d61781c3e4ce2a0298af09ebd300d4d34e61`에 그대로 보존했다. 해당 번역 브랜치는 최신 엔진에 아직 이식하지 않았다.
- 새 번역, 기존 번역 교체, 새 릴리즈 및 기존 릴리즈 파일 교체는 수행하지 않았다.
- 저장소 변수 `KOREAN_RELEASE_HOLD=true` 동안 `Package builds`의 공개 게시 작업을 차단한다. 정기·수동·태그 실행 모두 적용된다. 빌드 아티팩트는 검증용으로 남길 수 있다.
- 수동 실행의 `publish_release` 기본값은 `false`다. 사용자가 릴리즈 재개를 요청하고 번역 검수가 끝난 뒤에만 보류를 해제한다.

## 번역 상태 확인 결과

기존 `korean/translations/ko.po`에는 헤더 제외 25,324개 항목이 있고 빈 `msgstr`은 없다.
같은 영어 원문에 서로 다른 번역이 연결된 검토 후보는 323개다.
전체 문맥과 번역 값은 [후보 목록](korean-translation-review-candidates.json)에 보존했다.

| 원문 | 기존 번역 후보 |
| --- | --- |
| Town Portal | 도시 귀환 / 마을 포탈 |
| Rogue | 도적 / 로그 |
| Instructor | 강사 / 교관 |
| Armor Class | 방어도 / 방어력 |

후보 개수는 확정 오류 개수가 아니다. 같은 원문도 문맥에 따라 다른 번역이 필요할 수 있다.
빈 번역이 없다는 결과 역시 게임 전체 번역 완료나 화면상 누락 없음의 증거가 아니다.
원문 카탈로그 밖의 하드코딩 문장, 동적 결합, 실제 로더 경로, 새로운 upstream 문자열은 별도 점검해야 한다.
기존 번역 브랜치의 `korean/reviews/PRE_RELEASE_AUDIT.md`에도 화면별 미검수 항목이 남아 있다.

## 기존 번역 브랜치 시험 이식에서 충돌한 파일

기존 번역 브랜치와 최신 기본 브랜치를 시험 병합했을 때 아래 21개 파일이 충돌했다.
시험 병합은 취소했고 번역 브랜치를 변경하지 않았다.
특히 폰트 구조와 한국어 오버레이 우선순위, HUD·캐릭터 생성 화면은 코드 이식과 실제 화면 검증이 필요하다.
생성 Lua 이벤트는 직접 수정하지 않고 exporter 또는 명시적 overlay에서 처리한다.

```text
.github/workflows/nightly.yml
CMakeLists.txt
README.md
android/app/build.gradle
android/gradle.properties
engine/AssetFileSystem.cpp
game/events/EventDialogContent.cpp
game/gameplay/GameMechanics.cpp
game/gameplay/GameplayDialogController.cpp
game/gameplay/NpcFollowerRuntime.cpp
game/gameplay/NpcFollowerRuntime.h
game/items/PriceCalculator.cpp
game/party/Party.cpp
game/ui/GameplayHudCommon.cpp
game/ui/GameplayHudCommon.h
game/ui/GameplayHudOverlaySupport.cpp
game/ui/GameplayHudRenderer.cpp
game/ui/GameplayPartyOverlayRenderer.cpp
game/ui/screens/LoadGameScreen.cpp
game/ui/screens/NewGameScreen.cpp
tests/AssetFileSystemTests.cpp
```

## 재번역 전 작업 순서

1. 최신 엔진의 실제 표시 문자열과 활성 데이터 경로를 다시 추출한다.
2. 기존 PO·overlay·런타임 치환을 번역 메모리로 보존하고, 신규·수정·삭제 원문을 분리한다.
3. 용어집을 먼저 확정한 뒤 후보 323개를 문맥별로 검토한다.
4. 최신 폰트·오버레이·UI 구조에 필요한 한국어 지원을 이식한다.
5. placeholder, 논리 키, 데이터 수치, 생성 파일 경계를 검증한다.
6. MM6/MM7/MM8 화면과 Windows x64·Android arm64 실행 검수가 끝난 뒤 릴리즈를 재개한다.

이번 검증은 upstream 커밋 포함 여부, 공개 게시 차단 조건, YAML·shell 구문,
런타임 패키징 및 조명 의존성 도구의 회귀 검사 범위다. 최신 한국어판의 네이티브 빌드·실제 화면 검수 완료를 주장하지 않는다.
