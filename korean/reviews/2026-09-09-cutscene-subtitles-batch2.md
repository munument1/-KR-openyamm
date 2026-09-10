# Cutscene subtitle review — batch 2

Date: 2026-09-09

This batch promotes four MM7 runtime movies from `review_required` to
`subtitle_ready`: `7intro`, `endgame 1 good`, `mm3 people good`, and
`mm3 people evil`.

## Evidence policy

- Timing comes from the actual OpenYAMM OGV files in
  `assets_dev/worlds/mm7/videos/Cutscenes`.
- The existing `faster-whisper base.en` audit was independently re-run with
  `small.en`; these four movies produced closely matching dialogue and timing.
- Proper names, locations, factions, and established Korean terms were checked
  against the current Korean translation catalog before authoring.
- External series references were used only to corroborate names/lore where ASR
  predictably confused proper nouns. They were not used as timing sources.
- Uncertain movies remain `review_required`; rescue-pass hallucinations such as
  generic “Thanks for watching” text were explicitly rejected.

## Term decisions

- Corak → 코락
- Sheltem → 쉘템
- Resurectra → 레저렉트라 (current NPC display name)
- Kastore → 카스토어
- Ancients → 고대인
- Kreegan → 크리건
- The Silence → 침묵
- Control Cube → 제어 큐브
- Harmondale → 하몬데일
- Castle Harmondale → 하몬데일 성
- Emerald Island → 에메랄드 섬
- Scavenger Hunt → 보물찾기

`Web Station Beta-5` and `Spinward Rim` do not currently have catalog entries;
this batch renders them descriptively as `웹 스테이션 베타-5` and
`스핀워드 림` rather than inventing a different lore term.

## Corroborating references

- Might and Magic Wiki: Kalik / Piridak introduction summaries and spelling.
- Might and Magic Wiki / Wikipedia: MM7 Lincoln, Corak, Kreegan, and Light-ending
  context.
- GameMeca Korean series retrospective: established Korean renderings `코락` and
  `쉘템`.

The SRT text itself is a Korean localization of the speech in the repository's
runtime media, not a transcription copied from an external page.
