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
