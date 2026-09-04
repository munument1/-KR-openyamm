#include "game/ui/GameplayHudCommon.h"

#define loadHudFont loadHudFontLegacy
#define measureHudTextWidth measureHudTextWidthLegacy
#define clampHudTextToWidth clampHudTextToWidthLegacy
#define wrapHudTextToWidth wrapHudTextToWidthLegacy
#define renderHudFontLayer renderHudFontLayerLegacy
#define renderLayoutLabel renderLayoutLabelLegacy
#include "game/ui/GameplayHudCommonLegacy.cpp"
#undef renderLayoutLabel
#undef renderHudFontLayer
#undef wrapHudTextToWidth
#undef clampHudTextToWidth
#undef measureHudTextWidth
#undef loadHudFont

#include "game/ui/Utf8Text.h"

#define STBTT_STATIC
#define STB_TRUETYPE_IMPLEMENTATION
#include <stb/stb_truetype.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstddef>
#include <iostream>
#include <optional>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "game/ui/GameplayHudKoreanAtlas.inc"
#include "game/ui/GameplayHudKoreanText.inc"
