#pragma once

#include <optional>
#include <string>
#include <unordered_map>

namespace OpenYAMM::Game
{
namespace KoreanRuntimeText
{
inline bool startsWith(const std::string &text, const std::string &prefix)
{
    return text.size() >= prefix.size() && text.compare(0, prefix.size(), prefix) == 0;
}

inline bool endsWith(const std::string &text, const std::string &suffix)
{
    return text.size() >= suffix.size()
        && text.compare(text.size() - suffix.size(), suffix.size(), suffix) == 0;
}

inline std::string between(const std::string &text, const std::string &prefix, const std::string &suffix)
{
    if (!startsWith(text, prefix) || !endsWith(text, suffix) || text.size() < prefix.size() + suffix.size())
    {
        return {};
    }
    return text.substr(prefix.size(), text.size() - prefix.size() - suffix.size());
}

inline std::string className(const std::string &name)
{
    static const std::unordered_map<std::string, std::string> Names = {
        {"Archer", "궁수"}, {"Warrior Mage", "전투 마법사"}, {"Master Archer", "명궁"}, {"Sniper", "저격수"},
        {"Cleric", "성직자"}, {"Priest", "사제"}, {"Priest of the Light", "빛의 사제"}, {"Priest of the Dark", "어둠의 사제"},
        {"Dark Elf", "다크 엘프"}, {"Patriarch", "족장"}, {"Dragon", "드래곤"}, {"Great Wyrm", "고룡"},
        {"Druid", "드루이드"}, {"Great Druid", "상급 드루이드"}, {"Warlock", "흑마법사"}, {"Arch Druid", "대드루이드"},
        {"Knight", "기사"}, {"Cavalier", "중기병"}, {"Champion", "챔피언"}, {"Black Knight", "흑기사"},
        {"Minotaur", "미노타우로스"}, {"Minotaur Lord", "미노타우로스 군주"}, {"Monk", "수도사"}, {"Initiate", "수련자"},
        {"Master", "달인"}, {"Ninja", "닌자"}, {"Paladin", "성기사"}, {"Crusader", "십자군"},
        {"Hero", "영웅"}, {"Villain", "악당"}, {"Ranger", "레인저"}, {"Hunter", "사냥꾼"},
        {"Bounty Hunter", "현상금 사냥꾼"}, {"Ranger Lord", "레인저 군주"}, {"Thief", "도둑"}, {"Rogue", "로그"},
        {"Assassin", "암살자"}, {"Spy", "첩자"}, {"Troll", "트롤"}, {"War Troll", "전투 트롤"},
        {"Vampire", "뱀파이어"}, {"Nosferatu", "노스페라투"}, {"Sorcerer", "소서러"}, {"Wizard", "마법사"},
        {"Necromancer", "강령술사"}, {"Lich", "리치"}, {"Arch Mage", "대마법사"}, {"Master Necromancer", "대강령술사"},
        {"High Priest", "대사제"}, {"Master Wizard", "마스터 위저드"}, {"Peasant", "농민"},
    };
    const auto it = Names.find(name);
    return it != Names.end() ? it->second : name;
}

inline std::string merchantProfession(const std::string &name)
{
    if (name == "armorer") return "갑옷 상인";
    if (name == "scholar") return "학자";
    if (name == "alchemist") return "연금술사";
    if (name == "merchant") return "상인";
    return name;
}

inline std::optional<std::string> generatedMercenary(const std::string &text)
{
    static const std::string Prefix = "Good tidings. I am ";
    static const std::string Tail =
        ". I'd love to see the world and taste the adventure, but it'd be foolish to go alone. Perhaps I could come with you?";
    if (!startsWith(text, Prefix) || !endsWith(text, Tail))
    {
        return std::nullopt;
    }

    const std::string core = text.substr(Prefix.size(), text.size() - Prefix.size() - Tail.size());
    const size_t comma = core.find(", ");
    if (comma == std::string::npos)
    {
        return std::nullopt;
    }
    const std::string name = core.substr(0, comma);
    const std::string descriptor = core.substr(comma + 2);

    struct Impression
    {
        const char *english;
        const char *korean;
    };
    static constexpr Impression Impressions[] = {
        {"apprentice ", "견습 "},
        {"skilled ", "숙련 "},
        {"well known ", "유명 "},
        {"masterful ", "달인 "},
        {"great ", "위대한 "},
    };
    for (const Impression &impression : Impressions)
    {
        const std::string english = impression.english;
        if (startsWith(descriptor, english))
        {
            const std::string profession = className(descriptor.substr(english.size()));
            return "반갑습니다. 나는 " + name + ", " + impression.korean + profession
                + "입니다. 세상을 보고 모험을 맛보고 싶지만 혼자 떠나는 건 어리석겠지요. 당신들과 함께해도 될까요?";
        }
    }
    return std::nullopt;
}

inline std::optional<std::string> shopPhrase(const std::string &text)
{
    const std::string junkPrefix = "Hmph. Looks like junk to me. <yawn> I suppose I could give you oh, say, ";
    const std::string junkSuffix = " gold pieces for it.";
    if (startsWith(text, junkPrefix) && endsWith(text, junkSuffix))
    {
        return "흠. 내 눈에는 고물로밖에 안 보이는군요. <하품> 그래도 "
            + between(text, junkPrefix, junkSuffix) + "골드 정도는 드릴 수 있겠네요.";
    }

    const std::string normalBuyPrefix = "Normally, I do my best to buy a ";
    const std::string normalBuyMiddle1 = " for ";
    const std::string normalBuyMiddle2 = " gold. But I can see you know it's worth ";
    const std::string normalBuySuffix = ". Agreed?";
    if (startsWith(text, normalBuyPrefix) && endsWith(text, normalBuySuffix))
    {
        const size_t m1 = text.find(normalBuyMiddle1, normalBuyPrefix.size());
        const size_t m2 = text.find(normalBuyMiddle2, m1 == std::string::npos ? 0 : m1 + normalBuyMiddle1.size());
        if (m1 != std::string::npos && m2 != std::string::npos)
        {
            const std::string item = text.substr(normalBuyPrefix.size(), m1 - normalBuyPrefix.size());
            const std::string listed = text.substr(m1 + normalBuyMiddle1.size(), m2 - (m1 + normalBuyMiddle1.size()));
            const std::string actual = text.substr(m2 + normalBuyMiddle2.size(), text.size() - (m2 + normalBuyMiddle2.size()) - normalBuySuffix.size());
            return "보통 " + item + "은(는) " + listed + "골드에 사려고 합니다. 하지만 실제 가치가 " + actual
                + "골드라는 걸 알고 계시는군요. 이 가격에 거래하시겠습니까?";
        }
    }

    const std::string usualPrefix = "Usually I try to buy something like this ";
    const std::string usualMiddle1 = " for ";
    const std::string usualMiddle2 = " gold. I'll give you ";
    const std::string usualSuffix = " for it.";
    if (startsWith(text, usualPrefix) && endsWith(text, usualSuffix))
    {
        const size_t m1 = text.find(usualMiddle1, usualPrefix.size());
        const size_t m2 = text.find(usualMiddle2, m1 == std::string::npos ? 0 : m1 + usualMiddle1.size());
        if (m1 != std::string::npos && m2 != std::string::npos)
        {
            const std::string item = text.substr(usualPrefix.size(), m1 - usualPrefix.size());
            const std::string listed = text.substr(m1 + usualMiddle1.size(), m2 - (m1 + usualMiddle1.size()));
            const std::string actual = text.substr(m2 + usualMiddle2.size(), text.size() - (m2 + usualMiddle2.size()) - usualSuffix.size());
            return "보통 이런 " + item + "은(는) " + listed + "골드 정도에 사지만, 당신에게는 " + actual + "골드를 드리겠습니다.";
        }
    }

    const std::string identifyPrefix = "Sorry, I can't identify a ";
    const std::string identifyMiddle = " because I'm a ";
    const std::string identifySuffix = ". I don't know anything about those.";
    if (startsWith(text, identifyPrefix) && endsWith(text, identifySuffix))
    {
        const size_t middle = text.find(identifyMiddle, identifyPrefix.size());
        if (middle != std::string::npos)
        {
            const std::string item = text.substr(identifyPrefix.size(), middle - identifyPrefix.size());
            const std::string profession = text.substr(middle + identifyMiddle.size(), text.size() - (middle + identifyMiddle.size()) - identifySuffix.size());
            return "죄송하지만 저는 " + merchantProfession(profession) + "이라 " + item + "을(를) 감정할 수 없습니다. 그 물건은 잘 모릅니다.";
        }
    }

    const std::string identifyPricePrefix = "I'll tell you what it is for ";
    const std::string identifyPriceSuffix = " gold pieces.";
    if (startsWith(text, identifyPricePrefix) && endsWith(text, identifyPriceSuffix))
    {
        return between(text, identifyPricePrefix, identifyPriceSuffix) + "골드에 감정해 드리겠습니다.";
    }

    const std::string repairUnknownPrefix = "Sorry, I have no idea how to fix a ";
    if (startsWith(text, repairUnknownPrefix) && endsWith(text, "."))
    {
        return "죄송하지만 " + between(text, repairUnknownPrefix, ".") + "은(는) 어떻게 수리하는지 모르겠습니다.";
    }

    const std::string nearPrefix = "This ";
    const std::string nearMiddle = " is nearly beyond repair. It will take a superhuman effort to fix it! I'll have to charge ";
    const std::string nearSuffix = " gold.";
    if (startsWith(text, nearPrefix) && endsWith(text, nearSuffix))
    {
        const size_t middle = text.find(nearMiddle, nearPrefix.size());
        if (middle != std::string::npos)
        {
            const std::string item = text.substr(nearPrefix.size(), middle - nearPrefix.size());
            const std::string price = text.substr(middle + nearMiddle.size(), text.size() - (middle + nearMiddle.size()) - nearSuffix.size());
            return "이 " + item + "은(는) 거의 수리 불능 상태군요. 고치려면 엄청난 작업이 필요합니다! 비용은 " + price + "골드입니다.";
        }
    }

    const std::string gluePrefix = "Hmmm. Nothing a little glue and polish won't fix, I warrant. My policy is to ask for ";
    const std::string glueMiddle = " gold, but I can go as low as ";
    if (startsWith(text, gluePrefix) && endsWith(text, "."))
    {
        const size_t middle = text.find(glueMiddle, gluePrefix.size());
        if (middle != std::string::npos)
        {
            const std::string listed = text.substr(gluePrefix.size(), middle - gluePrefix.size());
            const std::string actual = text.substr(middle + glueMiddle.size(), text.size() - (middle + glueMiddle.size()) - 1);
            return "흠, 접착제와 광택제만 있으면 고칠 수 있겠군요. 보통 " + listed + "골드를 받지만, " + actual + "골드까지 깎아 드리죠.";
        }
    }

    const std::string badMiddle1 = " is in bad shape, but it can be fixed. I usually want ";
    const std::string badMiddle2 = " gold, but for you I will charge a mere ";
    if (startsWith(text, "This ") && endsWith(text, "."))
    {
        const size_t m1 = text.find(badMiddle1, 5);
        const size_t m2 = text.find(badMiddle2, m1 == std::string::npos ? 0 : m1 + badMiddle1.size());
        if (m1 != std::string::npos && m2 != std::string::npos)
        {
            const std::string item = text.substr(5, m1 - 5);
            const std::string listed = text.substr(m1 + badMiddle1.size(), m2 - (m1 + badMiddle1.size()));
            const std::string actual = text.substr(m2 + badMiddle2.size(), text.size() - (m2 + badMiddle2.size()) - 1);
            return "이 " + item + "은(는) 상태가 나쁘지만 수리는 가능합니다. 보통 " + listed + "골드를 받지만 당신에게는 " + actual + "골드만 받겠습니다.";
        }
    }

    const std::string excellentPrefix = "An excellent choice! This ";
    const std::string excellentMiddle = " is of the finest quality. I am willing to virtually give it away for ";
    const std::string excellentSuffix = " gold.";
    if (startsWith(text, excellentPrefix) && endsWith(text, excellentSuffix))
    {
        const size_t middle = text.find(excellentMiddle, excellentPrefix.size());
        if (middle != std::string::npos)
        {
            const std::string item = text.substr(excellentPrefix.size(), middle - excellentPrefix.size());
            const std::string price = text.substr(middle + excellentMiddle.size(), text.size() - (middle + excellentMiddle.size()) - excellentSuffix.size());
            return "탁월한 선택입니다! 이 " + item + "은(는) 최고급 물건이지요. 거의 거저나 다름없는 " + price + "골드에 드리겠습니다.";
        }
    }

    const std::string sellPrefix = "I try to sell things like this ";
    const std::string sellMiddle1 = " for ";
    const std::string sellMiddle2 = " gold. But we both know it's really worth ";
    const std::string sellSuffix = ". So that's my price.";
    if (startsWith(text, sellPrefix) && endsWith(text, sellSuffix))
    {
        const size_t m1 = text.find(sellMiddle1, sellPrefix.size());
        const size_t m2 = text.find(sellMiddle2, m1 == std::string::npos ? 0 : m1 + sellMiddle1.size());
        if (m1 != std::string::npos && m2 != std::string::npos)
        {
            const std::string item = text.substr(sellPrefix.size(), m1 - sellPrefix.size());
            const std::string listed = text.substr(m1 + sellMiddle1.size(), m2 - (m1 + sellMiddle1.size()));
            const std::string actual = text.substr(m2 + sellMiddle2.size(), text.size() - (m2 + sellMiddle2.size()) - sellSuffix.size());
            return "이런 " + item + "은(는) 보통 " + listed + "골드에 내놓지만, 우리 둘 다 실제 가치가 " + actual + "골드라는 걸 알지요. 그게 제 가격입니다.";
        }
    }

    const std::string hardPrefix = "Ordinarily I sell things like this ";
    const std::string hardMiddle1 = " for ";
    const std::string hardMiddle2 = " gold. But you drive a hard bargain-- I'll sell it to you for ";
    if (startsWith(text, hardPrefix) && endsWith(text, "."))
    {
        const size_t m1 = text.find(hardMiddle1, hardPrefix.size());
        const size_t m2 = text.find(hardMiddle2, m1 == std::string::npos ? 0 : m1 + hardMiddle1.size());
        if (m1 != std::string::npos && m2 != std::string::npos)
        {
            const std::string item = text.substr(hardPrefix.size(), m1 - hardPrefix.size());
            const std::string listed = text.substr(m1 + hardMiddle1.size(), m2 - (m1 + hardMiddle1.size()));
            const std::string actual = text.substr(m2 + hardMiddle2.size(), text.size() - (m2 + hardMiddle2.size()) - 1);
            return "보통 이런 " + item + "은(는) " + listed + "골드에 팔지만 흥정을 잘하시는군요. " + actual + "골드에 드리겠습니다.";
        }
    }

    return std::nullopt;
}

inline std::optional<std::string> koreanRuntimeTextOverride(const std::string &text)
{
    if (text.empty())
    {
        return std::nullopt;
    }

    static const std::unordered_map<std::string, std::string> Exact = {
        {"The Adventurer's Inn", "모험가의 여관"},
        {"The Adventurer's Inn is empty.", "모험가의 여관에 아무도 없습니다."},
        {"That topic does not have an event yet.", "이 대화 주제에는 아직 이벤트가 없습니다."},
        {"Your packs are already full!", "식량이 이미 가득합니다!"},
        {"MM9 skill trainer topic is no longer valid.", "이 기술 교관 대화는 더 이상 유효하지 않습니다."},
        {"MM9 dialogue row is no longer valid.", "이 대화 항목은 더 이상 유효하지 않습니다."},
        {"That companion is not ready to join yet.", "그 동료는 아직 합류할 준비가 되지 않았습니다."},
        {"Recruitment is not available for this companion yet.", "이 동료는 아직 영입할 수 없습니다."},
        {"You're already a member of this guild.", "이미 이 길드의 회원입니다."},
        {"You don't have enough gold!", "골드가 부족합니다!"},
        {"That follower is not available.", "그 동료는 지금 이용할 수 없습니다."},
        {"I will join you.", "함께 가겠습니다."},
        {"How Much?", "얼마인가요?"},
        {"You can't rest in turn-based mode!", "턴제 모드에서는 쉴 수 없습니다!"},
        {"You are already resting.", "이미 휴식 중입니다."},
        {"You don't have enough food to rest.", "휴식에 필요한 식량이 부족합니다."},
        {"Cannot leave turn-based mode now.", "지금은 턴제 모드를 종료할 수 없습니다."},
        {"Turn-based mode", "턴제 모드"},
        {"Realtime mode", "실시간 모드"},
        {"Spell failed", "주문 실패"},
        {"Save Game", "게임 저장"},
        {"Finish current action", "현재 행동을 먼저 끝내십시오"},
        {"Unknown quick spell", "알 수 없는 빠른 주문"},
        {"No valid target exists!", "유효한 대상이 없습니다!"},
        {"Town Portal data missing", "도시 귀환 주문 데이터가 없습니다"},
        {"Choose Town Portal destination", "도시 귀환 목적지를 선택하십시오"},
        {"Choose Dimension Door destination", "차원문 목적지를 선택하십시오"},
        {"Set or recall beacon", "봉화를 설치하거나 귀환하십시오"},
        {"Spell cancelled", "주문이 취소되었습니다"},
        {"Dimension Door", "차원문"},
        {"Town Portal destinations unavailable", "도시 귀환 목적지를 사용할 수 없습니다"},
        {"Dimension Door destinations unavailable", "차원문 목적지를 사용할 수 없습니다"},
        {"current location", "현재 위치"},
        {"Setting beacon", "봉화 설치"},
        {"Spell not learned", "배우지 않은 주문입니다"},
        {"Can't set quick spell", "빠른 주문으로 지정할 수 없습니다"},
        {"Quick spell cleared", "빠른 주문을 해제했습니다"},
        {"Can't set attack spell", "공격 주문으로 지정할 수 없습니다"},
        {"Attack spell cleared", "공격 주문을 해제했습니다"},
        {"Select an item", "아이템을 선택하십시오"},
        {"Can't hire adventurer.", "모험가를 고용할 수 없습니다."},
        {"Dismissal failed.", "해산하지 못했습니다."},
        {"Can't do that", "그렇게 할 수 없습니다"},
        {"Can't equip that item there", "그 위치에는 이 아이템을 장착할 수 없습니다"},
        {"Can't equip that item", "이 아이템을 장착할 수 없습니다"},
        {"Save name already exists.", "같은 이름의 저장 파일이 이미 있습니다."},
        {"Press New Game again to abandon current progress.", "현재 진행을 포기하고 새 게임을 시작하려면 다시 누르십시오."},
        {"Press Quit again to exit.", "종료하려면 다시 누르십시오."},
        {"Pick Up", "줍기"},
        {"Open Chest", "상자 열기"},
        {"Open Door", "문 열기"},
        {"Use Lever", "레버 사용"},
        {"Drop Item", "아이템 버리기"},
        {"Use Switch", "스위치 사용"},
        {"Use Elevator", "승강기 사용"},
        {"Use Pedestal", "받침대 사용"},
        {"Identify Failed", "감정 실패"},
        {"Repair Failed", "수리 실패"},
        {"Already identified.", "이미 감정된 아이템입니다."},
        {"Nothing to repair.", "수리할 것이 없습니다."},
        {"The connector stone is recharging.", "연결석이 재충전 중입니다."},
        {"The connector stone calls Verdant.", "연결석이 버던트를 불러냅니다."},
        {"Spell data missing", "주문 데이터가 없습니다"},
        {"Unknown scroll spell", "알 수 없는 주문 두루마리입니다"},
        {"Wand already charged!", "마법봉은 이미 충전되어 있습니다!"},
        {"Mixed potion", "물약을 혼합했습니다"},
        {"Item can not be used that way", "아이템을 그런 방식으로 사용할 수 없습니다"},
        {"You can not do that while you are underwater!", "물속에서는 그렇게 할 수 없습니다!"},
        {"The skill could not be learned", "기술을 배울 수 없습니다"},
        {"+2 Skill Points!", "기술 점수 +2!"},
        {"There are hostile creatures nearby!", "주변에 적대적인 생물이 있습니다!"},
        {"This character can't summon any more monsters!", "이 캐릭터는 더 이상 몬스터를 소환할 수 없습니다!"},
        {"Item is not of high enough quality", "아이템의 품질이 충분히 높지 않습니다"},
        {"Can't cast Meteor Shower indoors!", "실내에서는 유성우를 시전할 수 없습니다!"},
        {"Can't cast Starburst indoors!", "실내에서는 별빛 폭발을 시전할 수 없습니다!"},
        {"Can not cast Fly indoors!", "실내에서는 비행을 시전할 수 없습니다!"},
        {"Can't cast Armageddon indoors!", "실내에서는 아마겟돈을 시전할 수 없습니다!"},
        {"Can't cast Inferno outdoors!", "실외에서는 지옥불을 시전할 수 없습니다!"},
        {"Can't cast Prismatic Light outdoors!", "실외에서는 프리즘 광선을 시전할 수 없습니다!"},
        {"Divine Intervention is blocked by equipped gear", "장착한 장비 때문에 신성한 개입을 시전할 수 없습니다"},
        {"Not skilled enough", "기술 수준이 부족합니다"},
        {"Not enough spell points", "주문 포인트가 부족합니다"},
        {"Need character target", "캐릭터 대상을 선택해야 합니다"},
        {"Select item target", "아이템 대상을 선택하십시오"},
        {"Need spell UI", "주문 선택 화면이 필요합니다"},
        {"Select the Item to Sell", "판매할 아이템을 선택하십시오"},
        {"Select the Item to Identify", "감정할 아이템을 선택하십시오"},
        {"Select the Item to Repair", "수리할 아이템을 선택하십시오"},
        {"LMB buy  RMB inspect  Esc close", "좌클릭 구매  우클릭 확인  Esc 닫기"},
        {"Potion Notes", "물약 기록"},
        {"Obelisk Notes", "오벨리스크 기록"},
        {"Seer Notes", "예언자 기록"},
        {"Teacher Locations", "교관 위치"},
        {"Day of Protection", "보호의 날"},
        {"Hour of Power", "힘의 시간"},
        {"Pain Reflection", "고통 반사"},
        {"Press Input", "입력하십시오"},
        {"Current Quests", "현재 퀘스트"},
        {"Lloyd's Beacon", "로이드의 봉화"},
        {"Set beacon here", "여기에 봉화 설치"},
        {"Broken item", "파손된 아이템"},
        {"SP Cost", "주문 포인트 소모"},
        {"Active Spells:", "활성 주문:"},
        {"Select item target  LMB cast  Esc cancel", "아이템 대상 선택  좌클릭 시전  Esc 취소"},
        {"Dark Grasp", "어둠의 손아귀"},
        {"Right-click a card to discard.", "카드를 버리려면 우클릭하십시오."},
        {"Arcomage ended in a draw.", "아르코메이지가 무승부로 끝났습니다."},
        {"You lost the Arcomage match.", "아르코메이지 대전에서 패배했습니다."},
        {"The bounty office is unavailable right now.", "지금은 현상금 사무소를 이용할 수 없습니다."},
        {"There is no bounty this month.", "이번 달에는 현상금 대상이 없습니다."},
        {"You have already claimed this bounty.", "이 현상금은 이미 수령했습니다."},
        {"Pack is Full!", "가방이 가득 찼습니다!"},
        {"You are burning!", "몸에 불이 붙었습니다!"},
        {"You are drowning!", "물에 빠져 숨이 막힙니다!"},
        {"You need Stealing skill.", "소매치기 기술이 필요합니다."},
        {"Too far away.", "너무 멀리 있습니다."},
        {"Nothing to steal.", "훔칠 것이 없습니다."},
        {"Caught stealing!", "도둑질하다 들켰습니다!"},
        {"No Armageddon casts left today", "오늘은 더 이상 아마겟돈을 시전할 수 없습니다"},
        {"Unknown item", "알 수 없는 아이템"},
        {"Sorry, I'm not interested in that item.", "죄송하지만 그 아이템에는 관심이 없습니다."},
        {"Nothing is for sale in that slot.", "그 칸에는 판매 중인 물건이 없습니다."},
        {"That item is unavailable.", "그 아이템은 이용할 수 없습니다."},
        {"Not enough gold.", "골드가 부족합니다."},
        {"Inventory full.", "인벤토리가 가득 찼습니다."},
        {"You need Stealing skill to steal that.", "그것을 훔치려면 소매치기 기술이 필요합니다."},
        {"Caught stealing.", "도둑질하다 들켰습니다."},
        {"No item there.", "그곳에는 아이템이 없습니다."},
        {"That item cannot be sold.", "그 아이템은 판매할 수 없습니다."},
        {"Could not take the item.", "아이템을 가져올 수 없습니다."},
        {"You don't have enough gold", "골드가 부족합니다"},
        {"Good as New!", "새것처럼 말끔합니다!"},
        {"This character does not know that skill.", "이 캐릭터는 그 기술을 배우지 않았습니다."},
        {"This character already knows that mastery.", "이 캐릭터는 이미 해당 숙련 등급을 익혔습니다."},
        {"You must have at least 50 base Intellect to learn Master Learning.", "학습을 마스터하려면 기본 지능이 50 이상이어야 합니다."},
        {"You must have at least 50 base Personality to learn Master Merchant.", "상술을 마스터하려면 기본 인격이 50 이상이어야 합니다."},
        {"You must have at least 50 base Endurance to learn Master Bodybuilding.", "체력 단련을 마스터하려면 기본 인내력이 50 이상이어야 합니다."},
        {"The requirements for this training are unmet.", "이 훈련의 요구 조건을 충족하지 못했습니다."},
        {"Do you wish to leave this area?", "이 지역을 떠나시겠습니까?"},
        {"Serve Sentence", "형기 복역"},
        {"More Info", "자세히"},
        {"NPC interaction UI is not implemented yet.", "NPC 상호작용 화면은 아직 구현되지 않았습니다."},
        {"Your fine has been paid.", "벌금을 모두 납부했습니다."},
        {"Excellent work! By thwarting the Destroyer of Worlds, you have pulled your world from the brink of unending oblivion. Not only may life continue, but a new peace reigns over Jadame. The mighty alliance you forged will see to the land's restoration and eventual prosperity.",
            "훌륭합니다! 세계의 파괴자를 저지하여 당신은 세계를 끝없는 망각의 벼랑에서 구해 냈습니다. 생명은 계속 이어질 수 있게 되었고 자데임에는 새로운 평화가 찾아왔습니다. 당신이 이룬 강력한 동맹은 이 땅을 복구하고 마침내 번영으로 이끌 것입니다."},
        {"Adventurer the Level 1 Adventurer", "모험가 - 레벨 1 모험가"},
        {"You feel high magic presence here.", "이곳에서 강한 마법의 기운이 느껴집니다."},
        {"Advanced time by 1 hour", "시간을 1시간 진행했습니다"},
        {"Time advance unavailable", "시간을 진행할 수 없습니다"},
        {"Quick save unavailable", "빠른 저장을 사용할 수 없습니다"},
        {"Quick save unavailable here", "여기서는 빠른 저장을 사용할 수 없습니다"},
        {"Quick save written", "빠른 저장을 완료했습니다"},
        {"Quick load unavailable", "빠른 불러오기를 사용할 수 없습니다"},
        {"Quick load applied", "빠른 불러오기를 완료했습니다"},
    };

    if (const auto it = Exact.find(text); it != Exact.end())
    {
        return it->second;
    }

    if (const std::optional<std::string> mercenary = generatedMercenary(text))
    {
        return mercenary;
    }
    if (const std::optional<std::string> shop = shopPhrase(text))
    {
        return shop;
    }

    if (startsWith(text, "Select actor for ")) return "대상 몬스터 선택: " + text.substr(17);
    if (startsWith(text, "Select character for ")) return "대상 캐릭터 선택: " + text.substr(21);
    if (startsWith(text, "Select ground point for ")) return "지면 대상 선택: " + text.substr(24);
    if (startsWith(text, "Select target for ")) return "대상 선택: " + text.substr(18);
    if (startsWith(text, "Select item for ")) return "아이템 대상 선택: " + text.substr(16);

    if (startsWith(text, "Dimension Door to ")) return text.substr(18) + "(으)로 차원문 이동";
    if (startsWith(text, "Town Portal to ")) return text.substr(15) + "(으)로 도시 귀환";
    if (startsWith(text, "Recall to ")) return text.substr(10) + "(으)로 귀환";
    if (startsWith(text, "Set beacon to ")) return text.substr(14) + "에 봉화 설치";
    if (startsWith(text, "Quick spell set to ")) return "빠른 주문 지정: " + text.substr(19);
    if (startsWith(text, "Attack spell set to ")) return "공격 주문 지정: " + text.substr(20);

    if (startsWith(text, "To confirm ") && endsWith(text, " dismissal press the button again..."))
    {
        const std::string name = text.substr(11, text.size() - 11 - 36);
        return name + "을(를) 해산하려면 버튼을 다시 누르십시오...";
    }
    if (endsWith(text, " dismissed.")) return text.substr(0, text.size() - 11) + "을(를) 해산했습니다.";
    if (endsWith(text, " waits at the Adventurer's Inn.")) return text.substr(0, text.size() - 31) + "은(는) 모험가의 여관에서 기다리고 있습니다.";
    if (endsWith(text, " joined the party.")) return text.substr(0, text.size() - 18) + "이(가) 파티에 합류했습니다.";
    if (endsWith(text, " is already following you.")) return text.substr(0, text.size() - 26) + "은(는) 이미 당신을 따라다니고 있습니다.";
    if (endsWith(text, " joined the followers.")) return text.substr(0, text.size() - 22) + "이(가) 동료로 합류했습니다.";
    if (startsWith(text, "The follower ") && endsWith(text, " left the followers."))
        return text.substr(13, text.size() - 13 - 20) + "이(가) 동료에서 떠났습니다.";

    if (startsWith(text, "Can't drop ")) return text.substr(11) + "은(는) 버릴 수 없습니다";
    if (startsWith(text, "picked up ")) return text.substr(10) + "을(를) 주웠습니다";

    if (startsWith(text, "This month's bounty is ")) return "이번 달 현상금 대상은 " + text.substr(23);
    if (startsWith(text, "You eliminated ") && text.find(". Your reward is ") != std::string::npos)
    {
        const size_t marker = text.find(". Your reward is ");
        return text.substr(15, marker - 15) + "을(를) 처치했습니다. 보상은 " + text.substr(marker + 17);
    }
    if (startsWith(text, "You found ") && endsWith(text, " gold!")) return text.substr(10, text.size() - 10 - 6) + "골드를 발견했습니다!";
    if (startsWith(text, "You found an item (") && endsWith(text, ")!")) return "아이템을 발견했습니다 (" + text.substr(19, text.size() - 21) + ")!";
    if (startsWith(text, "You found ") && text.find(" gold and an item (") != std::string::npos && endsWith(text, ")!"))
    {
        const size_t marker = text.find(" gold and an item (");
        const std::string gold = text.substr(10, marker - 10);
        const std::string item = text.substr(marker + 19, text.size() - (marker + 19) - 2);
        return gold + "골드와 아이템을 발견했습니다 (" + item + ")!";
    }

    if (startsWith(text, "That player is ")) return "그 캐릭터는 " + text.substr(15);
    if (endsWith(text, " can not be used that way")) return text.substr(0, text.size() - 25) + "은(는) 그런 방식으로 사용할 수 없습니다";
    if (startsWith(text, "You don't have the skill to learn ")) return text.substr(34) + "을(를) 배우기 위한 기술이 부족합니다";
    if (startsWith(text, "You already know the ")) return "이미 " + text.substr(21) + "을(를) 알고 있습니다";
    if (startsWith(text, "You already know one or more skills in ")) return text.substr(39) + " 계열의 기술을 이미 하나 이상 알고 있습니다";
    if (startsWith(text, "This character cannot learn the skills in ")) return "이 캐릭터는 " + text.substr(42) + " 계열 기술을 배울 수 없습니다";
    if (startsWith(text, "Learned the skills in ")) return text.substr(22) + " 계열 기술을 배웠습니다";

    if (startsWith(text, "Your current fine is ") && endsWith(text, " gold.")) return "현재 벌금은 " + text.substr(21, text.size() - 21 - 6) + "골드입니다.";
    if (startsWith(text, "Welcome to ")) return text.substr(11) + "에 오신 것을 환영합니다.";

    if (startsWith(text, "You have to be promoted to ") && endsWith(text, " to learn this skill."))
        return "이 기술을 배우려면 " + className(text.substr(27, text.size() - 27 - 21)) + "(으)로 승급해야 합니다.";
    if (startsWith(text, "This skill level can not be learned by the "))
        return text.substr(43) + "은(는) 이 숙련 등급을 배울 수 없습니다.";
    if (text.find(" is now a ") != std::string::npos)
    {
        const size_t marker = text.find(" is now a ");
        return text.substr(0, marker) + "이(가) 이제 " + className(text.substr(marker + 10)) + "이(가) 되었습니다.";
    }

    if (startsWith(text, "Do you wish to leave ") && endsWith(text, "?")) return text.substr(21, text.size() - 22) + "을(를) 떠나시겠습니까?";
    if (startsWith(text, "Do you wish to enter ") && endsWith(text, "?")) return text.substr(21, text.size() - 22) + "에 들어가시겠습니까?";
    if (startsWith(text, "Join guild for ")) return "길드 가입: " + text.substr(15);

    if (startsWith(text, "Skill bonus: +")) return "기술 보너스: +" + text.substr(14);
    if (startsWith(text, "Skill bonus: ")) return "기술 보너스: " + text.substr(13);
    if (startsWith(text, "Hit Points : ")) return "생명력: " + text.substr(13);
    if (startsWith(text, "Spell Points : ")) return "주문 포인트: " + text.substr(15);
    if (startsWith(text, "Quick Spell: ")) return "빠른 주문: " + text.substr(13);
    if (startsWith(text, "Awards earned: ")) return "획득한 업적: " + text.substr(15);
    if (startsWith(text, "Skill Points: ")) return "기술 점수: " + text.substr(14);

    if (startsWith(text, "Your score: ")) return "점수: " + text.substr(12);
    if (startsWith(text, "Total Time: ")) return "총 시간: " + text.substr(12);
    if (startsWith(text, "Quick save failed: ")) return "빠른 저장 실패: " + text.substr(19);
    if (startsWith(text, "Quick load failed: ")) return "빠른 불러오기 실패: " + text.substr(19);

    return std::nullopt;
}
} // namespace KoreanRuntimeText
} // namespace OpenYAMM::Game
