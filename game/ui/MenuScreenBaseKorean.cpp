#include "game/ui/MenuScreenBase.h"

#define shutdownSharedResources shutdownSharedResourcesLegacy
#define ensureFont ensureFontLegacy
#define drawText drawTextLegacy
#define measureTextWidth measureTextWidthLegacy
#include "game/ui/MenuScreenBase.cpp"
#undef measureTextWidth
#undef drawText
#undef ensureFont
#undef shutdownSharedResources

#include "game/ui/Utf8Text.h"
#include "game/ui/KoreanRuntimeTextOverrides.h"

#define STBTT_STATIC
#define STB_TRUETYPE_IMPLEMENTATION
#include <stb/stb_truetype.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

#include "game/ui/MenuScreenKoreanText.inc"
