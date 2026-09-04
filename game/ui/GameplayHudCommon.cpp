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
#include "game/ui/KoreanRuntimeTextOverrides.h"

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
#include <unordered_map>
#include <utility>
#include <vector>

#include "game/ui/GameplayHudKoreanAtlas.inc"

struct GameplayHudCommonKoreanRaw
{
    using SubmitTexturedQuadFn = GameplayHudCommon::SubmitTexturedQuadFn;
    using FindHudFontFn = GameplayHudCommon::FindHudFontFn;
    using EnsureHudFontColorFn = GameplayHudCommon::EnsureHudFontColorFn;
    using RenderHudFontLayerFn = GameplayHudCommon::RenderHudFontLayerFn;

    static float measureHudTextWidth(const GameplayHudFontData &font, const std::string &text);
    static std::string clampHudTextToWidth(const GameplayHudFontData &font, const std::string &text, float maxWidth);
    static std::vector<std::string> wrapHudTextToWidth(
        const GameplayHudFontData &font,
        const std::string &text,
        float maxWidth);
    static void renderHudFontLayer(
        const GameplayHudFontData &font,
        bgfx::TextureHandle textureHandle,
        const std::string &text,
        float textX,
        float textY,
        float fontScale,
        const SubmitTexturedQuadFn &submitTexturedQuad);
    static void renderLayoutLabel(
        const UiLayoutManager::LayoutElement &layout,
        const GameplayResolvedHudLayoutElement &resolved,
        const std::string &label,
        const FindHudFontFn &findHudFont,
        const EnsureHudFontColorFn &ensureHudFontColor,
        const RenderHudFontLayerFn &renderHudFontLayer);
};

#define GameplayHudCommon GameplayHudCommonKoreanRaw
#include "game/ui/GameplayHudKoreanText.inc"
#undef GameplayHudCommon

namespace OpenYAMM::Game
{
namespace
{
bool startsWith(const std::string &text, const std::string &prefix)
{
    return text.size() >= prefix.size() && text.compare(0, prefix.size(), prefix) == 0;
}

bool endsWith(const std::string &text, const std::string &suffix)
{
    return text.size() >= suffix.size()
        && text.compare(text.size() - suffix.size(), suffix.size(), suffix) == 0;
}

void replaceAll(std::string &text, const std::string &from, const std::string &to)
{
    if (from.empty())
    {
        return;
    }

    size_t position = 0;
    while ((position = text.find(from, position)) != std::string::npos)
    {
        text.replace(position, from.size(), to);
        position += to.size();
    }
}

std::string localizedSkillDisplayName(const std::string &name)
{
    static const std::unordered_map<std::string, std::string> Names = {
        {"Staff", "스태프"},
        {"Sword", "검"},
        {"Dagger", "단검"},
        {"Axe", "도끼"},
        {"Spear", "창"},
        {"Bow", "활"},
        {"Mace", "메이스"},
        {"Blaster", "블래스터"},
        {"Shield", "방패"},
        {"Leather Armor", "가죽 갑옷"},
        {"Chain Armor", "사슬 갑옷"},
        {"Plate Armor", "판금 갑옷"},
        {"Fire Magic", "화염 마법"},
        {"Air Magic", "대기 마법"},
        {"Water Magic", "물 마법"},
        {"Earth Magic", "대지 마법"},
        {"Spirit Magic", "영혼 마법"},
        {"Mind Magic", "정신 마법"},
        {"Body Magic", "신체 마법"},
        {"Light Magic", "빛 마법"},
        {"Dark Magic", "어둠 마법"},
        {"Dark Elf Ability", "다크 엘프 능력"},
        {"Vampire Ability", "뱀파이어 능력"},
        {"Dragon Ability", "드래곤 능력"},
        {"Identify Item", "아이템 식별"},
        {"Merchant", "상술"},
        {"Repair Item", "아이템 수리"},
        {"Body Building", "체력 단련"},
        {"Bodybuilding", "체력 단련"},
        {"Meditation", "명상"},
        {"Perception", "지각"},
        {"Regeneration", "재생"},
        {"Disarm Traps", "함정 해제"},
        {"Dodging", "회피"},
        {"Unarmed", "맨손 전투"},
        {"Identify Monster", "몬스터 식별"},
        {"Armsmaster", "무술"},
        {"Stealing", "소매치기"},
        {"Alchemy", "연금술"},
        {"Learning", "학습"},
        {"Throwing Weapons", "투척 무기"},
    };

    const auto iterator = Names.find(name);
    return iterator != Names.end() ? iterator->second : name;
}

std::string localizedTravelDuration(const std::string &duration)
{
    if (endsWith(duration, " days"))
    {
        return duration.substr(0, duration.size() - 5) + "일";
    }
    if (endsWith(duration, " day"))
    {
        return duration.substr(0, duration.size() - 4) + "일";
    }
    return duration;
}

std::string localizedGameplayHudText(const std::string &text)
{
    if (text.empty())
    {
        return text;
    }

    if (const std::optional<std::string> overrideText = KoreanRuntimeText::koreanRuntimeTextOverride(text))
    {
        return *overrideText;
    }

    if (endsWith(text, " [disabled]"))
    {
        return localizedGameplayHudText(text.substr(0, text.size() - 11)) + " [사용 불가]";
    }

    static const std::unordered_map<std::string, std::string> Exact = {
        {"Sell", "판매"},
        {"Identify", "감정"},
        {"Repair", "수리"},
        {"Rules", "규칙"},
        {"Victory Conditions", "승리 조건"},
        {"Play", "플레이"},
        {"Learn Skills", "기술 배우기"},
        {"Play Arcomage", "아르코메이지 플레이"},
        {"Deposit", "입금"},
        {"Withdraw", "출금"},
        {"Buy Standard", "일반 물품 구매"},
        {"Buy Special", "특별 물품 구매"},
        {"Display Equipment", "장비 보기"},
        {"Buy Spellbooks", "마법서 구매"},
        {"Pay Fine", "벌금 납부"},
        {"Bounty Hunt", "현상금 사냥"},
        {"Price Fixing", "가격 담합"},
        {"Train", "훈련"},
        {"Sorry, come back another day", "죄송하지만 다른 날 다시 오세요."},
        {"Answer: _", "답변: _"},
        {"You can't rest here!", "여기서는 쉴 수 없습니다!"},
        {"There are hostile enemies near!", "주변에 적이 있어 쉴 수 없습니다!"},
        {"This house does not buy equipment.", "이곳에서는 장비를 매입하지 않습니다."},
        {"This house cannot identify items.", "이곳에서는 아이템을 감정할 수 없습니다."},
        {"This house cannot repair items.", "이곳에서는 아이템을 수리할 수 없습니다."},
        {"Your packs are already full enough.", "식량이 이미 충분합니다."},
        {"You must be a member of this guild to study here.", "여기서 배우려면 이 길드의 회원이어야 합니다."},
        {"You do not owe a fine.", "납부할 벌금이 없습니다."},
        {"You must have your own card deck to play here.", "여기서 게임하려면 개인 카드 덱이 필요합니다."},
        {"No skills are available here for this character.", "이 캐릭터가 여기서 배울 수 있는 기술이 없습니다."},
        {"Choose an Arcomage option.", "아르코메이지 메뉴를 선택하세요."},
        {"This house refuses service after the theft.", "도난 사건 때문에 이곳에서는 서비스를 제공하지 않습니다."},
        {"This house refuses service because of your reputation.", "당신의 평판 때문에 이곳에서는 서비스를 제공하지 않습니다."},
        {"Healing is not offered here.", "이곳에서는 치료 서비스를 제공하지 않습니다."},
        {"No character is selected.", "캐릭터가 선택되지 않았습니다."},
        {"Donations are not accepted here.", "이곳에서는 기부를 받지 않습니다."},
        {"Thank You", "감사합니다."},
        {"Refreshing!", "상쾌하군요!"},
        {"You have served one year in prison.", "감옥에서 1년의 형기를 마쳤습니다."},
        {"No character is selected for training.", "훈련할 캐릭터가 선택되지 않았습니다."},
        {"Training is not available right now.", "지금은 훈련할 수 없습니다."},
        {"That lesson is not available.", "그 기술은 여기서 배울 수 없습니다."},
        {"You don't have enough gold.", "골드가 부족합니다."},
        {"This service is not implemented yet.", "이 서비스는 아직 구현되지 않았습니다."},
        {"That route is not available.", "이 이동 경로는 이용할 수 없습니다."},
        {"Travel is unavailable right now.", "지금은 이동할 수 없습니다."},
        {"Arcomage uses the house deck. Build your tower, destroy theirs, or win on resources.",
            "아르코메이지는 이곳의 카드 덱을 사용합니다. 자신의 탑을 높이거나 상대의 탑을 무너뜨리거나 자원을 충분히 모으면 승리합니다."},
        {"Arcomage victory conditions depend on the inn. This tavern flow is not implemented yet.",
            "아르코메이지 승리 조건은 여관마다 다릅니다. 이 여관 기능은 아직 구현되지 않았습니다."},
        {"Arcomage play is not implemented yet.", "아르코메이지 플레이는 아직 구현되지 않았습니다."},
        {"You are not carrying any gold.", "소지한 골드가 없습니다."},
        {"You do not have any gold in the bank.", "은행에 맡긴 골드가 없습니다."},
        {"With your skills, you should be working here as a teacher\n\nSorry, but we are unable to train you.",
            "당신의 실력이라면 이곳에서 교관으로 일해야 할 정도입니다.\n\n죄송하지만 더 이상 훈련해 드릴 수 없습니다."},
        {"Well, If Loretta's got a new scheme, count me in!\nBut you better get all the other companies to sign up!",
            "좋아, 로레타가 새 계획을 세웠다면 나도 끼지!\n하지만 다른 회사들도 전부 동의하게 만들어야 해!"},
    };

    if (const auto iterator = Exact.find(text); iterator != Exact.end())
    {
        return iterator->second;
    }

    if (startsWith(text, "Balance: "))
    {
        return "잔액: " + text.substr(9) + "골드";
    }

    if (startsWith(text, "This place is open from "))
    {
        std::string hours = text.substr(24);
        replaceAll(hours, " to ", " ~ ");
        replaceAll(hours, "AM", "시(오전)");
        replaceAll(hours, "PM", "시(오후)");
        return "영업시간: " + hours;
    }

    if (startsWith(text, "Learn ") && endsWith(text, " gold"))
    {
        const size_t forPosition = text.rfind(" for ");
        if (forPosition != std::string::npos && forPosition > 6)
        {
            const std::string skillName = text.substr(6, forPosition - 6);
            const std::string price = text.substr(forPosition + 5, text.size() - (forPosition + 5) - 5);
            return localizedSkillDisplayName(skillName) + " 배우기: " + price + "골드";
        }
    }

    if (startsWith(text, "Heal ") && endsWith(text, " gold"))
    {
        return "치료: " + text.substr(5, text.size() - 10) + "골드";
    }
    if (startsWith(text, "Donate ") && endsWith(text, " gold"))
    {
        return "기부: " + text.substr(7, text.size() - 12) + "골드";
    }
    if (startsWith(text, "Rent room for ") && endsWith(text, " gold"))
    {
        return "방 빌리기: " + text.substr(14, text.size() - 19) + "골드";
    }

    if (startsWith(text, "Fill packs to ") && endsWith(text, " gold"))
    {
        const size_t daysPosition = text.find(" days for ", 14);
        if (daysPosition != std::string::npos)
        {
            const std::string days = text.substr(14, daysPosition - 14);
            const size_t priceStart = daysPosition + 10;
            const std::string price = text.substr(priceStart, text.size() - priceStart - 5);
            return "식량 " + days + "일분 채우기: " + price + "골드";
        }
    }

    if (startsWith(text, "Current Fine: ") && endsWith(text, " gold"))
    {
        return "현재 벌금: " + text.substr(14, text.size() - 19) + "골드";
    }

    if (startsWith(text, "Train to level ") && endsWith(text, " gold"))
    {
        const size_t forPosition = text.find(" for ", 15);
        if (forPosition != std::string::npos)
        {
            const std::string level = text.substr(15, forPosition - 15);
            const size_t priceStart = forPosition + 5;
            const std::string price = text.substr(priceStart, text.size() - priceStart - 5);
            return "레벨 " + level + "까지 훈련: " + price + "골드";
        }
    }

    if (startsWith(text, "You need ") && text.find(" more experience to train to level ") != std::string::npos)
    {
        const size_t marker = text.find(" more experience to train to level ");
        const std::string experience = text.substr(9, marker - 9);
        const std::string level = text.substr(marker + 35);
        return "레벨 " + level + " 훈련까지 경험치 " + experience + "이 더 필요합니다.";
    }

    struct NeedGoldPattern
    {
        const char *suffix;
        const char *koreanPurpose;
    };
    static const std::array<NeedGoldPattern, 7> NeedGoldPatterns = {{
        {" gold for healing.", "치료하려면 "},
        {" gold to donate here.", "기부하려면 "},
        {" gold to rent a room.", "방을 빌리려면 "},
        {" gold for provisions.", "식량을 구입하려면 "},
        {" gold for a drink.", "술을 마시려면 "},
        {" gold for a tip.", "팁을 주려면 "},
        {" gold for training.", "훈련하려면 "},
    }};
    if (startsWith(text, "You need "))
    {
        for (const NeedGoldPattern &pattern : NeedGoldPatterns)
        {
            const std::string suffix = pattern.suffix;
            if (endsWith(text, suffix))
            {
                const std::string price = text.substr(9, text.size() - 9 - suffix.size());
                return std::string(pattern.koreanPurpose) + price + "골드가 필요합니다.";
            }
        }
    }

    if (startsWith(text, "The temple staff cannot treat ") && endsWith(text, "'s condition."))
    {
        const std::string name = text.substr(30, text.size() - 30 - 13);
        return "사원에서는 " + name + "의 상태를 치료할 수 없습니다.";
    }
    if (startsWith(text, "The temple staff says ") && endsWith(text, " is already well."))
    {
        const std::string name = text.substr(22, text.size() - 22 - 17);
        return "사원에서는 " + name + "이(가) 이미 건강하다고 합니다.";
    }
    if (startsWith(text, "The temple restores ") && endsWith(text, " gold."))
    {
        const size_t forPosition = text.rfind(" for ");
        if (forPosition != std::string::npos)
        {
            const std::string name = text.substr(20, forPosition - 20);
            const std::string price = text.substr(forPosition + 5, text.size() - (forPosition + 5) - 6);
            return "사원에서 " + name + "을(를) 치료했습니다. 비용: " + price + "골드.";
        }
    }

    if (startsWith(text, "The innkeeper fills your packs to ") && endsWith(text, " days."))
    {
        const std::string days = text.substr(34, text.size() - 34 - 6);
        return "여관 주인이 식량을 " + days + "일분까지 채워 주었습니다.";
    }

    if (text.find(" is now level ") != std::string::npos && endsWith(text, " skill points!"))
    {
        const size_t levelMarker = text.find(" is now level ");
        const size_t earnedMarker = text.find(" and has earned ", levelMarker + 14);
        if (earnedMarker != std::string::npos)
        {
            const std::string name = text.substr(0, levelMarker);
            const std::string level = text.substr(levelMarker + 14, earnedMarker - (levelMarker + 14));
            const std::string points = text.substr(earnedMarker + 16, text.size() - (earnedMarker + 16) - 14);
            return name + "의 레벨이 " + level + "이(가) 되었고 기술 점수 " + points + "점을 얻었습니다!";
        }
    }

    if (text.find(" cannot learn ") != std::string::npos && endsWith(text, " here."))
    {
        const size_t marker = text.find(" cannot learn ");
        const std::string name = text.substr(0, marker);
        const std::string skill = text.substr(marker + 14, text.size() - (marker + 14) - 6);
        return name + "은(는) 여기서 " + localizedSkillDisplayName(skill) + "을(를) 배울 수 없습니다.";
    }

    if (text.find(" learns ") != std::string::npos && endsWith(text, " gold."))
    {
        const size_t learnsMarker = text.find(" learns ");
        const size_t forMarker = text.rfind(" for ");
        if (forMarker != std::string::npos && forMarker > learnsMarker)
        {
            const std::string name = text.substr(0, learnsMarker);
            const std::string skill = text.substr(learnsMarker + 8, forMarker - (learnsMarker + 8));
            const std::string price = text.substr(forMarker + 5, text.size() - (forMarker + 5) - 6);
            return name + "이(가) " + localizedSkillDisplayName(skill) + "을(를) 배웠습니다. 비용: " + price + "골드.";
        }
    }

    if (startsWith(text, "Deposited ") && endsWith(text, " gold."))
    {
        return text.substr(10, text.size() - 10 - 6) + "골드를 입금했습니다.";
    }
    if (startsWith(text, "Withdrew ") && endsWith(text, " gold."))
    {
        return text.substr(10, text.size() - 10 - 6) + "골드를 출금했습니다.";
    }

    if (startsWith(text, "It will take ") && endsWith(text, "."))
    {
        const size_t travelMarker = text.find(" to travel to ", 13);
        if (travelMarker != std::string::npos)
        {
            const std::string duration = text.substr(13, travelMarker - 13);
            const std::string destination = text.substr(travelMarker + 14, text.size() - (travelMarker + 14) - 1);
            return destination + "까지 이동하는 데 " + localizedTravelDuration(duration) + "이 걸립니다.";
        }
    }

    if (endsWith(text, " gold"))
    {
        const size_t firstTo = text.find(" to ");
        const size_t forMarker = text.rfind(" for ");
        if (firstTo != std::string::npos && forMarker != std::string::npos && firstTo < forMarker)
        {
            const std::string duration = text.substr(0, firstTo);
            const std::string localizedDuration = localizedTravelDuration(duration);
            if (localizedDuration != duration)
            {
                const std::string destination = text.substr(firstTo + 4, forMarker - (firstTo + 4));
                const std::string price = text.substr(forMarker + 5, text.size() - (forMarker + 5) - 5);
                return destination + "까지 " + localizedDuration + ": " + price + "골드";
            }
        }
    }

    return text;
}
}

float GameplayHudCommon::measureHudTextWidth(const GameplayHudFontData &font, const std::string &text)
{
    return GameplayHudCommonKoreanRaw::measureHudTextWidth(font, localizedGameplayHudText(text));
}

std::string GameplayHudCommon::clampHudTextToWidth(
    const GameplayHudFontData &font,
    const std::string &text,
    float maxWidth)
{
    return GameplayHudCommonKoreanRaw::clampHudTextToWidth(font, localizedGameplayHudText(text), maxWidth);
}

std::vector<std::string> GameplayHudCommon::wrapHudTextToWidth(
    const GameplayHudFontData &font,
    const std::string &text,
    float maxWidth)
{
    return GameplayHudCommonKoreanRaw::wrapHudTextToWidth(font, localizedGameplayHudText(text), maxWidth);
}

void GameplayHudCommon::renderHudFontLayer(
    const GameplayHudFontData &font,
    bgfx::TextureHandle textureHandle,
    const std::string &text,
    float textX,
    float textY,
    float fontScale,
    const SubmitTexturedQuadFn &submitTexturedQuad)
{
    GameplayHudCommonKoreanRaw::renderHudFontLayer(
        font,
        textureHandle,
        localizedGameplayHudText(text),
        textX,
        textY,
        fontScale,
        submitTexturedQuad);
}

void GameplayHudCommon::renderLayoutLabel(
    const UiLayoutManager::LayoutElement &layout,
    const GameplayResolvedHudLayoutElement &resolved,
    const std::string &label,
    const FindHudFontFn &findHudFont,
    const EnsureHudFontColorFn &ensureHudFontColor,
    const RenderHudFontLayerFn &renderHudFontLayer)
{
    GameplayHudCommonKoreanRaw::renderLayoutLabel(
        layout,
        resolved,
        localizedGameplayHudText(label),
        findHudFont,
        ensureHudFontColor,
        renderHudFontLayer);
}
} // namespace OpenYAMM::Game
