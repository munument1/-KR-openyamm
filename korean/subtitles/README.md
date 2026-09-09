# Korean cutscene subtitles

OpenYAMM Korean builds can load UTF-8 SRT subtitles for full-screen cutscenes.

Place subtitle files in the active world's Korean overlay:

- `korean/overlay/worlds/mm6/subtitles/<VideoStem>.srt`
- `korean/overlay/worlds/mm7/subtitles/<VideoStem>.srt`
- `korean/overlay/worlds/mm8/subtitles/<VideoStem>.srt`
- `korean/overlay/worlds/mmmerge/subtitles/<VideoStem>.srt`

The SRT filename must match the cutscene video stem used by the runtime. The
loader also tries a lowercase filename. Standard `HH:MM:SS,mmm -->
HH:MM:SS,mmm` timing is supported, UTF-8 Korean text is rendered centered near
the bottom of the displayed video, and long lines are wrapped with UTF-8-aware
measurement.

The original SMK/BIK files under `data/Anims/*` are source media. Runtime video
playback uses converted video assets, so subtitles are intentionally kept as a
small Korean overlay instead of re-encoding or modifying the original movies.

## Coverage and review policy

`coverage.json` tracks every actual runtime OGV under
`assets_dev/worlds/*/videos/Cutscenes`. Each entry has one of these states:

- `subtitle_ready`: a reviewed Korean SRT is committed and package-tested.
- `no_audio`: `ffprobe` found no audio stream, so no SRT is required.
- `review_required`: speech or audio exists, but the transcript/timing is not
  reliable enough yet to publish a subtitle.

`source_inventory.json`, `media_probe.json`, and `asr_draft.json` are audit
inputs, not translation authority. Machine ASR is used to locate speech and
draft timing only. Low-confidence or missing ASR is never converted into guessed
Korean subtitle text.

The subtitle integration test verifies that coverage contains every runtime OGV,
that ready SRT files are valid UTF-8 with valid timing inside the video duration,
and that every ready SRT is actually included in the corresponding world overlay
ZIP. MMmerge-only movie variants may keep a duplicate SRT in the mmmerge overlay
when needed by the mounted-world asset layout.
