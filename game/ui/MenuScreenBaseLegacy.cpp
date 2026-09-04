#include "game/ui/MenuScreenBase.h"
#include "engine/BgfxContext.h"
#include "engine/ImageAssetLoader.h"
#include "game/render/TextureFiltering.h"
#include "game/ui/UiLayoutManager.h"

#include <SDL3/SDL.h>
#include <bx/math.h>

#include <algorithm>
#include <array>
#include <cctype>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <optional>
#include <string>
#include <vector>

// This file is a preserved copy of the upstream MenuScreenBase.cpp implementation.
// Its method names are remapped by MenuScreenBase.cpp so the Korean UTF-8 wrapper can
// delegate all legacy-only text and resource behavior without duplicating that logic.
#include "game/ui/MenuScreenBaseLegacyBody.inc"
