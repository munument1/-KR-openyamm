# Cutscene subtitle runtime review

This note records the evidence used to classify the actual OpenYAMM runtime cutscene OGV set for Korean subtitles.

## Runtime inventory

- Runtime OGV files reviewed: 32
- `subtitle_ready`: 18
- `no_audio`: 2
- `no_dialogue`: 11
- `review_required`: 1 (`mm8/skeltrans`)

The inventory is based on `assets_dev/worlds/*/videos/Cutscenes`, runtime movie references, legacy `data/Anims` source media, `ffprobe` metadata, repeated ASR passes, and direct runtime-frame review. A legacy BIK/SMK filename alone is not treated as proof that a subtitle is needed.

## Final reviewed subtitle additions

The final reviewed batch adds Korean SRT files for:

- MM7 `intro post`
- MM8 `DragonHunters`
- MM8 `dragonsrevenge`
- MM8 `wingame`

These were cross-checked with independent ASR passes and runtime frames. Game dialogue and established in-project terminology were used where available instead of inventing names or wording from machine transcription.

## Confirmed no-dialogue movies

These files contain an audio stream, but runtime-frame review and repeated speech audits show music/effects/visual-only content with no spoken dialogue requiring an SRT:

- MM6 `6losegame`
- MM6 `credits`
- MM6 `mm6end2`
- MM7 `endgame 2 evil`
- MM8 `intro`
- MM8 `JVC`
- MM8 `LoseGame`
- MM8 `nightshade`
- MM8 `NWC`
- MM8 `SaveMino`
- MM8 `Subcut`

MM6 `archie` and `noarchie` remain separately classified as `no_audio` because they have no audio stream at all.

## Remaining review item

`mm8/skeltrans` remains `review_required`. Its main speech is stable across ASR passes:

- `Too late for you, I'm afraid.`
- `But you will be the last.`
- `This blasphemy will be ended.`

The final short utterance is not stable. Independent large-v3 decoding produced conflicting candidates, including `Now, for our escape.` and an implausible `Now, for honesty.`. The video shows the Skeleton Transformer exploding at that moment, but visual context is not being used to guess the missing words. No SRT is published until the original line can be independently verified.

## Packaging and regression checks

`korean/tools/test_cutscene_subtitles.py` now accepts and validates the explicit `no_dialogue` state, while continuing to require that:

- every runtime OGV appears exactly once in `coverage.json`;
- every `subtitle_ready` SRT is valid UTF-8 with valid SRT timing inside the movie duration;
- `no_audio` entries actually have no audio stream;
- `no_dialogue` entries have audio but no subtitle files;
- reviewed SRT files are included in the corresponding world overlay ZIP;
- map-event overlay regeneration does not remove sibling `subtitles/` assets before packaging.

Temporary media/ASR audit workflows used for this review were removed after the evidence was collected.
