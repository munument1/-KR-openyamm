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

inline void replaceAll(std::string &text, const std::string &from, const std::string &to)
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
        {"Adventurer", "모험가"},
    };
    const auto it = Names.find(name);
    return it != Names.end() ? it->second : name;
}

inline std::string promotionClassList(const std::string &names)
{
    std::string result;
    size_t start = 0;
    while (start < names.size())
    {
        const size_t comma = names.find(", ", start);
        const size_t alternative = names.find(" or ", start);
        const size_t end = comma < alternative ? comma : alternative;
        if (end == std::string::npos)
        {
            result += className(names.substr(start));
            break;
        }
        result += className(names.substr(start, end - start));
        result += end == alternative ? " 또는 " : ", ";
        start = end + (end == alternative ? 4 : 2);
    }
    return result;
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

inline std::string localizedTargetControlSuffix(const std::string &text)
{
    struct ControlSuffix
    {
        const char *english;
        const char *korean;
    };
    static constexpr ControlSuffix Suffixes[] = {
        {"  LMB cast  Esc cancel", "  좌클릭 시전  Esc 취소"},
        {"  Drag target  Spell button cast  Pause cancel", "  대상 드래그  주문 버튼 시전  일시정지 버튼 취소"},
        {"  Tap portrait  Pause cancel", "  초상화 탭  일시정지 버튼 취소"},
        {"  Tap target  Pause cancel", "  대상 탭  일시정지 버튼 취소"},
    };
    for (const ControlSuffix &suffix : Suffixes)
    {
        const std::string english = suffix.english;
        if (endsWith(text, english))
        {
            return text.substr(0, text.size() - english.size()) + suffix.korean;
        }
    }
    return text;
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
        {"Spell canceled", "주문이 취소되었습니다"},
        {"Unknown attack spell", "알 수 없는 공격 주문입니다"},
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
        {"OK", "확인"},
        {"Close", "닫기"},
        {"Yes", "예"},
        {"No", "아니요"},
        {"Join", "합류"},
        {"Dismiss", "해산"},
        {"Back", "뒤로"},
        {"Talk", "대화"},
        {"Loot", "전리품 획득"},
        {"Enter", "들어가기"},
        {"Press", "누르기"},
        {"Use", "사용"},
        {"Exit", "나가기"},
        {"Travel", "이동"},
        {"Passage", "통로"},
        {"Teleport", "순간이동"},
        {"Fountain", "분수"},
        {"Well", "우물"},
        {"Shrine", "성소"},
        {"Obelisk", "오벨리스크"},
        {"Boost", "강화"},
        {"Read", "읽기"},
        {"News", "소식"},
        {"Profession", "직업"},
        {"Done!", "완료했습니다!"},
        {"You already have enough followers.", "이미 충분한 동료가 있습니다."},
        {"Enter/Space/E/Esc close", "Enter/Space/E/Esc 닫기"},
        {"Up/Down select  Enter/Space accept  E/Esc close", "위/아래 선택  Enter/Space 확인  E/Esc 닫기"},
        {"Type amount  Enter accept  E/Esc cancel", "금액 입력  Enter 확인  E/Esc 취소"},
        {"Unavailable.", "이용할 수 없습니다."},
        {"Fountains", "분수"},
        {"Miscellaneous", "기타"},
        {"Notes", "기록"},
        {"Story", "이야기"},
        {"Available", "사용 가능"},
        {"Empty", "비어 있음"},
        {"Stolen", "훔친 물건"},
        {"Broken", "파손됨"},
        {"Bricks", "벽돌"},
        {"Gems", "보석"},
        {"Recruits", "신병"},
        {"Free", "무료"},
        {"Autosave", "자동 저장"},
        {"Quicksave", "빠른 저장"},
        {"None", "없음"},
        {"N/A", "해당 없음"},
        {"Wand", "마법봉"},
        {"INF", "무한"},
        {"Grand", "그랜드"},
        {"Good", "양호"},
        {"Eradicated", "소멸"},
        {"Petrified", "석화"},
        {"Dead", "사망"},
        {"Unconscious", "의식불명"},
        {"Paralyzed", "마비"},
        {"Asleep", "수면"},
        {"Insane", "광기"},
        {"Afraid", "공포"},
        {"Diseased", "질병"},
        {"Poisoned", "중독"},
        {"Weak", "쇠약"},
        {"Cursed", "저주"},
        {"Drunk", "만취"},
        {"Only two additional skills can be selected.", "추가 기술은 두 개만 선택할 수 있습니다."},
        {"Character name cannot be empty.", "캐릭터 이름을 입력해야 합니다."},
        {"Might", "힘"},
        {"Intellect", "지능"},
        {"Personality", "인격"},
        {"Endurance", "체력"},
        {"Accuracy", "적중률"},
        {"Speed", "속도"},
        {"Luck", "운"},
        {"Staff", "스태프"},
        {"Sword", "검"},
        {"Dagger", "단검"},
        {"Axe", "도끼"},
        {"Spear", "창"},
        {"Bow", "활"},
        {"Throwing Weapons", "투척 무기"},
        {"Mace", "메이스"},
        {"Blaster", "블래스터"},
        {"Shield", "방패"},
        {"Leather", "가죽 갑옷"},
        {"Leather Armor", "가죽 갑옷"},
        {"Chain", "사슬 갑옷"},
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
        {"Lizardman Peasant", "리자드맨 농민"},
        {"Lizardman Guard", "리자드맨 경비병"},
        {"Dark Elf Peasant", "다크 엘프 농민"},
        {"Dark Elf Guard", "다크 엘프 경비병"},
        {"Ogre Peasant", "오우거 농민"},
        {"Wererat Peasants", "웨어랫 농민"},
        {"Troll Peasant", "트롤 농민"},
        {"Dragon Hunter", "드래곤 사냥꾼"},
        {"Necromancer Peasant", "강령술사 농민"},
        {"Cleric Peasant", "성직자 농민"},
        {"Regnan Peasant", "레그나 농민"},
        {"Minotaur Peasant", "미노타우로스 농민"},
        {"Pick", "줍기"},
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
        {"Not identified", "미감정 아이템"},
        {"SP Cost", "주문 포인트 소모"},
        {"Active Spells:", "활성 주문:"},
        {"Stunned", "기절"},
        {"Slow", "둔화"},
        {"Shrunk", "축소"},
        {"Hammerhands", "망치손"},
        {"Haste", "가속"},
        {"Stoneskin", "돌 피부"},
        {"Bless", "축복"},
        {"Fate", "운명"},
        {"Heroism", "영웅심"},
        {"Charmed", "매혹"},
        {"Berserk", "광폭화"},
        {"Enslaved", "정신 지배"},
        {"Controlled", "조종됨"},
        {"Reanimated", "되살아남"},
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
        {"Congratulations!", "축하합니다!"},
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
    // Translate known display terms inside generated UI sentences, without
    // interpreting player names or recursively rewriting arbitrary prose.
    const auto displayTerm = [](const std::string &term)
    {
        const auto it = Exact.find(term);
        return it != Exact.end() ? it->second : term;
    };

    if (const std::optional<std::string> mercenary = generatedMercenary(text))
    {
        return mercenary;
    }
    if (const std::optional<std::string> shop = shopPhrase(text))
    {
        return shop;
    }

    if (startsWith(text, "Select actor for ")) return localizedTargetControlSuffix("대상 몬스터 선택: " + text.substr(17));
    if (startsWith(text, "Select character for ")) return localizedTargetControlSuffix("대상 캐릭터 선택: " + text.substr(21));
    if (startsWith(text, "Select ground point for ")) return localizedTargetControlSuffix("지면 대상 선택: " + text.substr(24));
    if (startsWith(text, "Select target for ")) return localizedTargetControlSuffix("대상 선택: " + text.substr(18));
    if (startsWith(text, "Select item for ")) return localizedTargetControlSuffix("아이템 대상 선택: " + text.substr(16));

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
    if (startsWith(text, "Pick (") && endsWith(text, ")"))
        return "줍기 (" + between(text, "Pick (", ")") + ")";
    if (startsWith(text, "Loot (") && endsWith(text, ")"))
        return "전리품 획득 (" + between(text, "Loot (", ")") + ")";
    if (startsWith(text, "Open Chest (") && endsWith(text, ")"))
        return "상자 열기 (" + between(text, "Open Chest (", ")") + ")";
    if (startsWith(text, "Drop ")) return "버리기: " + text.substr(5);
    if (startsWith(text, "Dropped ")) return "버렸습니다: " + text.substr(8);
    if (startsWith(text, "Cast ")) return "시전: " + text.substr(5);
    if (startsWith(text, "Identified ") && endsWith(text, "."))
        return "감정 완료: " + between(text, "Identified ", ".") + ".";
    if (startsWith(text, "Repaired ") && endsWith(text, "."))
        return "수리 완료: " + between(text, "Repaired ", ".") + ".";
    if (startsWith(text, "Stole ") && endsWith(text, "."))
        return "훔쳤습니다: " + between(text, "Stole ", ".") + ".";
    if (startsWith(text, "Sold ") && endsWith(text, " gold."))
    {
        const size_t price = text.rfind(" for ");
        if (price != std::string::npos)
        {
            return "판매 완료: " + text.substr(5, price - 5) + " ("
                + text.substr(price + 5, text.size() - (price + 5) - 6) + "골드).";
        }
    }
    if (startsWith(text, "You found something (") && endsWith(text, ")!"))
        return "무언가를 발견했습니다 (" + between(text, "You found something (", ")!") + ")!";
    if (startsWith(text, "You have won ") && endsWith(text, " gold!"))
        return between(text, "You have won ", " gold!") + "골드를 획득해 승리했습니다!";
    if (startsWith(text, "House #")) return "건물 #" + text.substr(7);
    if (startsWith(text, "NPC #")) return "NPC #" + text.substr(5);
    if (startsWith(text, "Save ")) return "저장 " + text.substr(5);
    if (startsWith(text, "Beacon ")) return "봉화 " + text.substr(7);
    if (endsWith(text, " remaining")) return text.substr(0, text.size() - 10) + " 남음";
    if (startsWith(text, "The follower ") && endsWith(text, " left the followers."))
        return text.substr(13, text.size() - 13 - 20) + "이(가) 동료에서 떠났습니다.";

    if (startsWith(text, "Can't drop ")) return text.substr(11) + "은(는) 버릴 수 없습니다";
    if (startsWith(text, "picked up ")) return text.substr(10) + "을(를) 주웠습니다";

    if (startsWith(text, "This month's bounty is ") && endsWith(text, " gold."))
    {
        const size_t reward = text.rfind(" for ");
        if (reward != std::string::npos && reward > 23)
        {
            return "이번 달 현상금 대상: " + text.substr(23, reward - 23) + " (보상: "
                + text.substr(reward + 5, text.size() - (reward + 5) - 6) + "골드)";
        }
    }
    if (startsWith(text, "You eliminated ") && endsWith(text, " gold."))
    {
        const size_t reward = text.rfind(". Your reward is ");
        if (reward != std::string::npos && reward > 15)
        {
            return text.substr(15, reward - 15) + " 처치 완료. 보상: "
                + text.substr(reward + 17, text.size() - (reward + 17) - 6) + "골드.";
        }
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

    if (text.find(" gains +2 ") != std::string::npos && endsWith(text, "!"))
    {
        const size_t marker = text.find(" gains +2 ");
        static const std::unordered_map<std::string, std::string> Attributes = {
            {"Might", "힘"}, {"Intellect", "지능"}, {"Personality", "인격"},
            {"Endurance", "체력"}, {"Accuracy", "적중률"}, {"Speed", "속도"}, {"Luck", "운"},
        };
        const std::string attribute = text.substr(marker + 10, text.size() - (marker + 10) - 1);
        if (const auto it = Attributes.find(attribute); it != Attributes.end())
        {
            return text.substr(0, marker) + "의 " + it->second + "이(가) 2 증가했습니다!";
        }
    }
    if (endsWith(text, " becomes diseased, but gains an item!"))
    {
        return text.substr(0, text.size() - 37) + "은(는) 질병에 걸렸지만 아이템을 얻었습니다!";
    }

    if (endsWith(text, " (Permanent)"))
    {
        const size_t bonusMarker = text.rfind(" +");
        if (bonusMarker != std::string::npos)
        {
            static const std::unordered_map<std::string, std::string> PermanentAttributes = {
                {"Might", "힘"}, {"Intellect", "지능"}, {"Personality", "인격"},
                {"Endurance", "체력"}, {"Accuracy", "적중률"}, {"Speed", "속도"}, {"Luck", "운"},
                {"Fire Resistance", "화염 저항"}, {"Air Resistance", "대기 저항"},
                {"Water Resistance", "물 저항"}, {"Earth Resistance", "대지 저항"},
                {"Spirit Resistance", "영혼 저항"}, {"Mind Resistance", "정신 저항"},
                {"Body Resistance", "신체 저항"}, {"Light Resistance", "빛 저항"},
                {"Dark Resistance", "어둠 저항"}, {"Magic Resistance", "마법 저항"},
                {"Physical Resistance", "물리 저항"},
            };
            const std::string attribute = text.substr(0, bonusMarker);
            if (const auto it = PermanentAttributes.find(attribute); it != PermanentAttributes.end())
            {
                return it->second + text.substr(bonusMarker, text.size() - bonusMarker - 12) + " (영구)";
            }
        }
    }

    if (startsWith(text, "That player is "))
    {
        static const std::unordered_map<std::string, std::string> Conditions = {
            {"Cursed", "저주 상태입니다"},
            {"Weak", "쇠약 상태입니다"},
            {"Asleep", "잠들어 있습니다"},
            {"Afraid", "겁에 질려 있습니다"},
            {"Drunk", "만취 상태입니다"},
            {"Insane", "광기 상태입니다"},
            {"Poisoned", "중독 상태입니다"},
            {"Diseased", "질병 상태입니다"},
            {"Paralyzed", "마비 상태입니다"},
            {"Unconscious", "의식불명 상태입니다"},
            {"Dead", "사망 상태입니다"},
            {"Petrified", "석화 상태입니다"},
            {"Eradicated", "소멸 상태입니다"},
            {"Zombie", "좀비 상태입니다"},
            {"not active", "지금 행동할 수 없습니다"},
        };
        const std::string condition = text.substr(15);
        if (const auto it = Conditions.find(condition); it != Conditions.end())
        {
            return "그 캐릭터는 " + it->second;
        }
        return "그 캐릭터는 " + condition;
    }
    if (endsWith(text, " can not be used that way")) return text.substr(0, text.size() - 25) + ": 그런 방식으로 사용할 수 없습니다";
    if (startsWith(text, "You don't have the skill to learn ")) return "필요한 기술이 부족합니다: " + text.substr(34);
    if (startsWith(text, "You already know the ") && endsWith(text, " spell")) return "이미 알고 있는 주문입니다: " + between(text, "You already know the ", " spell");
    if (startsWith(text, "You already know the ")) return "이미 알고 있습니다: " + text.substr(21);
    if (startsWith(text, "You already know one or more skills in ")) return "이미 배운 기술이 포함되어 있습니다: " + text.substr(39);
    if (startsWith(text, "This character cannot learn the skills in ")) return "이 캐릭터는 해당 기술을 배울 수 없습니다: " + text.substr(42);
    if (startsWith(text, "Learned the skills in ")) return "기술을 습득했습니다: " + text.substr(22);
    if (startsWith(text, "Learned ")) return "기술 습득: " + text.substr(8);

    // Genie lamp rewards. Source semantics confirm permanent stat/resistance changes.
    if (startsWith(text, "+") && endsWith(text, " Might Permanent")) return "힘 +" + between(text, "+", " Might Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Intellect Permanent")) return "지능 +" + between(text, "+", " Intellect Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Personality Permanent")) return "인격 +" + between(text, "+", " Personality Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Endurance Permanent")) return "체력 +" + between(text, "+", " Endurance Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Accuracy Permanent")) return "적중률 +" + between(text, "+", " Accuracy Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Speed Permanent")) return "속도 +" + between(text, "+", " Speed Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Luck Permanent")) return "운 +" + between(text, "+", " Luck Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Gold")) return "골드 +" + between(text, "+", " Gold");
    if (startsWith(text, "+") && endsWith(text, " Food")) return "식량 +" + between(text, "+", " Food");
    if (startsWith(text, "+") && endsWith(text, " Skill Points")) return "기술 점수 +" + between(text, "+", " Skill Points");
    if (startsWith(text, "+") && endsWith(text, " Experience")) return "경험치 +" + between(text, "+", " Experience");
    if (startsWith(text, "+") && endsWith(text, " Fire Permanent")) return "화염 저항 +" + between(text, "+", " Fire Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Air Permanent")) return "대기 저항 +" + between(text, "+", " Air Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Water Permanent")) return "물 저항 +" + between(text, "+", " Water Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Earth Permanent")) return "대지 저항 +" + between(text, "+", " Earth Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Mind Permanent")) return "정신 저항 +" + between(text, "+", " Mind Permanent") + " (영구)";
    if (startsWith(text, "+") && endsWith(text, " Body Permanent")) return "신체 저항 +" + between(text, "+", " Body Permanent") + " (영구)";

    // Deck of Fate rewards.
    if (startsWith(text, "+") && endsWith(text, " Might!")) return "힘 +" + between(text, "+", " Might!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Intellect!")) return "지능 +" + between(text, "+", " Intellect!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Personality!")) return "인격 +" + between(text, "+", " Personality!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Endurance!")) return "체력 +" + between(text, "+", " Endurance!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Accuracy!")) return "적중률 +" + between(text, "+", " Accuracy!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Speed!")) return "속도 +" + between(text, "+", " Speed!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Luck!")) return "운 +" + between(text, "+", " Luck!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Fire Resistance!")) return "화염 저항 +" + between(text, "+", " Fire Resistance!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Air Resistance!")) return "대기 저항 +" + between(text, "+", " Air Resistance!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Water Resistance!")) return "물 저항 +" + between(text, "+", " Water Resistance!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Earth Resistance!")) return "대지 저항 +" + between(text, "+", " Earth Resistance!") + "!";
    if (startsWith(text, "+") && endsWith(text, " Body Resistance!")) return "신체 저항 +" + between(text, "+", " Body Resistance!") + "!";

    // House, temple, tavern, training and transport display text.
    if (text == "Selected: no character") return "선택된 캐릭터: 없음";
    if (startsWith(text, "Selected: ") && text.find(" the ") != std::string::npos)
    {
        const size_t split = text.find(" the ", 10);
        return "선택: " + text.substr(10, split - 10) + " (" + className(text.substr(split + 5)) + ")";
    }
    if (startsWith(text, "This place is open from ") && text.find(" to ") != std::string::npos)
    {
        const size_t split = text.find(" to ", 24);
        const std::string open = text.substr(24, split - 24);
        const std::string close = text.substr(split + 4);
        const auto koreanTime = [](const std::string &value)
        {
            if (endsWith(value, "AM")) return std::string("오전 ") + value.substr(0, value.size() - 2) + "시";
            if (endsWith(value, "PM")) return std::string("오후 ") + value.substr(0, value.size() - 2) + "시";
            return value;
        };
        return "영업시간: " + koreanTime(open) + " ~ " + koreanTime(close);
    }
    if (text == "Well, If Loretta's got a new scheme, count me in!\nBut you better get all the other companies to sign up!")
        return "로레타에게 새 계획이 있다면 나도 끼지!\n하지만 다른 회사들도 전부 참여하게 해야 해!";
    if (text == "Refreshing!") return "상쾌하군요!";
    if (startsWith(text, "Heal ") && endsWith(text, " gold")) return "치료 - " + between(text, "Heal ", " gold") + "골드";
    if (startsWith(text, "Donate ") && endsWith(text, " gold")) return "기부 - " + between(text, "Donate ", " gold") + "골드";
    if (startsWith(text, "Rent room for ") && endsWith(text, " gold")) return "숙박 - " + between(text, "Rent room for ", " gold") + "골드";
    if (startsWith(text, "Fill packs to ") && text.find(" days for ") != std::string::npos && endsWith(text, " gold"))
    {
        const size_t split = text.find(" days for ", 14);
        return "식량 " + text.substr(14, split - 14) + "일분 채우기 - " + text.substr(split + 10, text.size() - (split + 10) - 5) + "골드";
    }
    if (text == "With your skills, you should be working here as a teacher\n\nSorry, but we are unable to train you.")
        return "당신 정도의 실력이라면 여기서 교관으로 일해야겠군요.\n\n죄송하지만 더 이상 훈련해 드릴 수 없습니다.";
    if (startsWith(text, "You need ") && text.find(" more experience to train to level ") != std::string::npos)
    {
        const std::string middle = " more experience to train to level ";
        const size_t split = text.find(middle, 9);
        return "레벨 " + text.substr(split + middle.size()) + " 훈련까지 경험치 " + text.substr(9, split - 9) + "이 더 필요합니다.";
    }
    if (startsWith(text, "Train to level ") && text.find(" for ") != std::string::npos && endsWith(text, " gold"))
    {
        const size_t split = text.find(" for ", 15);
        return "레벨 " + text.substr(15, split - 15) + " 훈련 - " + text.substr(split + 5, text.size() - (split + 5) - 5) + "골드";
    }
    if (startsWith(text, "Current Fine: ") && endsWith(text, " gold")) return "현재 벌금: " + between(text, "Current Fine: ", " gold") + "골드";
    if (startsWith(text, "The temple staff cannot treat ") && endsWith(text, "'s condition.")) return "사원에서는 " + between(text, "The temple staff cannot treat ", "'s condition.") + "의 상태를 치료할 수 없습니다.";
    if (startsWith(text, "The temple staff says ") && endsWith(text, " is already well.")) return between(text, "The temple staff says ", " is already well.") + ": 이미 치료가 필요하지 않습니다.";
    if (startsWith(text, "You need ") && endsWith(text, " gold for healing.")) return "치료하려면 " + between(text, "You need ", " gold for healing.") + "골드가 필요합니다.";
    if (startsWith(text, "The temple restores ") && text.find(" for ") != std::string::npos && endsWith(text, " gold."))
    {
        const size_t split = text.rfind(" for ");
        return "치료 완료: " + text.substr(20, split - 20) + " (" + text.substr(split + 5, text.size() - (split + 5) - 6) + "골드)";
    }
    if (startsWith(text, "You need ") && endsWith(text, " gold to donate here.")) return "기부하려면 " + between(text, "You need ", " gold to donate here.") + "골드가 필요합니다.";
    if (startsWith(text, "You need ") && endsWith(text, " gold to rent a room.")) return "방을 빌리려면 " + between(text, "You need ", " gold to rent a room.") + "골드가 필요합니다.";
    if (startsWith(text, "You need ") && endsWith(text, " gold for provisions.")) return "식량을 구입하려면 " + between(text, "You need ", " gold for provisions.") + "골드가 필요합니다.";
    if (startsWith(text, "The innkeeper fills your packs to ") && endsWith(text, " days.")) return "여관 주인이 식량을 " + between(text, "The innkeeper fills your packs to ", " days.") + "일분까지 채워 주었습니다.";
    if (startsWith(text, "You need ") && endsWith(text, " gold for a drink.")) return "술을 마시려면 " + between(text, "You need ", " gold for a drink.") + "골드가 필요합니다.";
    if (startsWith(text, "You need ") && endsWith(text, " gold for a tip.")) return "팁을 주려면 " + between(text, "You need ", " gold for a tip.") + "골드가 필요합니다.";
    if (startsWith(text, "You need ") && endsWith(text, " gold for training.")) return "훈련하려면 " + between(text, "You need ", " gold for training.") + "골드가 필요합니다.";
    if (text.find(" is now level ") != std::string::npos && text.find(" and has earned ") != std::string::npos && endsWith(text, " skill points!"))
    {
        const size_t level = text.find(" is now level ");
        const size_t earned = text.find(" and has earned ", level + 14);
        return text.substr(0, level) + ": 레벨 " + text.substr(level + 14, earned - (level + 14)) + " 달성, 기술 점수 " + text.substr(earned + 16, text.size() - (earned + 16) - 14) + " 획득!";
    }
    if (text.find(" cannot learn ") != std::string::npos && endsWith(text, " here."))
    {
        const size_t split = text.find(" cannot learn ");
        return text.substr(0, split) + ": 여기서는 배울 수 없는 기술입니다: "
            + displayTerm(text.substr(split + 14, text.size() - (split + 14) - 6));
    }
    if (text.find(" learns ") != std::string::npos && text.find(" for ") != std::string::npos && endsWith(text, " gold."))
    {
        const size_t learns = text.find(" learns ");
        const size_t price = text.rfind(" for ");
        return text.substr(0, learns) + ": " + displayTerm(text.substr(learns + 8, price - (learns + 8)))
            + " 습득 (" + text.substr(price + 5, text.size() - (price + 5) - 6) + "골드)";
    }
    if (startsWith(text, "Learn ") && text.find(" for ") != std::string::npos && endsWith(text, " gold"))
    {
        const size_t price = text.rfind(" for ");
        return displayTerm(text.substr(6, price - 6)) + " 배우기 - "
            + text.substr(price + 5, text.size() - (price + 5) - 5) + "골드";
    }
    if (startsWith(text, "It will take ") && text.find(" to travel to ") != std::string::npos && endsWith(text, "."))
    {
        const size_t split = text.find(" to travel to ", 13);
        std::string duration = text.substr(13, split - 13);
        if (endsWith(duration, " day")) duration = duration.substr(0, duration.size() - 4) + "일";
        else if (endsWith(duration, " days")) duration = duration.substr(0, duration.size() - 5) + "일";
        return text.substr(split + 14, text.size() - (split + 14) - 1) + "까지 이동하는 데 " + duration + "이 걸립니다.";
    }

    if (startsWith(text, "Your current fine is ") && endsWith(text, " gold.")) return "현재 벌금은 " + text.substr(21, text.size() - 21 - 6) + "골드입니다.";
    if (startsWith(text, "You need ") && endsWith(text, " gold to pay your fine.")) return "벌금을 납부하려면 " + between(text, "You need ", " gold to pay your fine.") + "골드가 필요합니다.";
    if (startsWith(text, "Welcome to ")) return text.substr(11) + "에 오신 것을 환영합니다.";

    if (text == "You failed to steal it.") return "훔치기에 실패했습니다.";
    if (text == "Sorry, come back another day.") return "죄송하지만 다른 날 다시 오십시오.";
    if (text == "MM9 dialogue action 0 is unresolved.") return "MM9 대화 동작 0은 아직 처리되지 않았습니다.";
    if (text == "You do not have enough gold.") return "골드가 부족합니다.";
    if (startsWith(text, "Become ") && text.find(" in ") != std::string::npos && text.find(" for ") != std::string::npos && endsWith(text, " gold"))
    {
        const size_t inPos = text.find(" in ", 7);
        const size_t forPos = text.rfind(" for ");
        const std::string rank = text.substr(7, inPos - 7);
        const std::string rankKo = rank == "Expert" ? "전문가" : rank == "Master" ? "마스터" : rank == "Grandmaster" ? "그랜드마스터" : rank;
        return displayTerm(text.substr(inPos + 4, forPos - (inPos + 4))) + " " + rankKo + " 승급 - "
            + text.substr(forPos + 5, text.size() - (forPos + 5) - 5) + "골드";
    }
    if (text.find(" is now a ") != std::string::npos && text.find(" in ") != std::string::npos && endsWith(text, "."))
    {
        const size_t rankPos = text.find(" is now a ");
        const size_t inPos = text.find(" in ", rankPos + 10);
        const std::string rank = text.substr(rankPos + 10, inPos - (rankPos + 10));
        if (rank == "Expert" || rank == "Master" || rank == "Grandmaster")
        {
            const std::string rankKo = rank == "Expert" ? "전문가" : rank == "Master" ? "마스터" : "그랜드마스터";
            return text.substr(0, rankPos) + ": "
                + displayTerm(text.substr(inPos + 4, text.size() - (inPos + 4) - 1))
                + " " + rankKo + " 승급 완료.";
        }
    }

    if (startsWith(text, "You have to be promoted to ") && endsWith(text, " to learn this skill."))
        return "이 기술을 배우려면 다음 직업으로 승급해야 합니다: "
            + promotionClassList(between(text, "You have to be promoted to ", " to learn this skill."));
    if (startsWith(text, "This skill level can not be learned by the ") && endsWith(text, " class."))
        return className(between(text, "This skill level can not be learned by the ", " class."))
            + ": 이 직업은 해당 숙련 등급을 배울 수 없습니다.";
    if (text.find(" is now a ") != std::string::npos)
    {
        const size_t marker = text.find(" is now a ");
        return text.substr(0, marker) + "이(가) 이제 " + className(text.substr(marker + 10)) + "이(가) 되었습니다.";
    }

    if (startsWith(text, "Do you wish to leave ") && endsWith(text, "?")) return text.substr(21, text.size() - 22) + "을(를) 떠나시겠습니까?";
    if (startsWith(text, "Do you wish to enter ") && endsWith(text, "?")) return text.substr(21, text.size() - 22) + "에 들어가시겠습니까?";
    if (startsWith(text, "Join guild for ") && endsWith(text, " gold"))
        return "길드 가입: " + between(text, "Join guild for ", " gold") + "골드";

    if (startsWith(text, "Skill bonus: +")) return "기술 보너스: +" + text.substr(14);
    if (startsWith(text, "Skill bonus: ")) return "기술 보너스: " + text.substr(13);
    if (startsWith(text, "Hit Points : ")) return "생명력: " + text.substr(13);
    if (startsWith(text, "Spell Points : ")) return "주문 포인트: " + text.substr(15);
    if (startsWith(text, "Quick Spell: ")) return "빠른 주문: " + text.substr(13);
    if (startsWith(text, "Awards earned: ")) return "획득한 업적: " + text.substr(15);
    if (startsWith(text, "Skill Points: ")) return "기술 점수: " + text.substr(14);

    if (startsWith(text, "Normal: ")) return "일반: " + text.substr(8);
    if (startsWith(text, "Expert: ")) return "전문가: " + text.substr(8);
    if (startsWith(text, "Master: ")) return "마스터: " + text.substr(8);
    if (startsWith(text, "Grandmaster: ")) return "그랜드마스터: " + text.substr(13);
    if (startsWith(text, "Grand Master: ")) return "그랜드마스터: " + text.substr(14);
    if (startsWith(text, "Casting ")) return "시전 중: " + text.substr(8);
    if (startsWith(text, "Special: "))
    {
        std::string result = "특수 효과: " + text.substr(9);
        replaceAll(result, "\nSet: ", "\n세트: ");
        replaceAll(result, ", active)", ", 활성)");
        replaceAll(result, ", inactive)", ", 비활성)");
        return result;
    }
    if (startsWith(text, "Set: "))
    {
        std::string result = "세트: " + text.substr(5);
        replaceAll(result, ", active)", ", 활성)");
        replaceAll(result, ", inactive)", ", 비활성)");
        return result;
    }
    if (startsWith(text, "Power: ")) return "위력: " + text.substr(7);
    if (startsWith(text, "Value: ")) return "가치: " + text.substr(7);
    if (startsWith(text, "Duration:"))
    {
        std::string result = "지속 시간:" + text.substr(9);
        replaceAll(result, ":yr", "년");
        replaceAll(result, ":mo", "개월");
        replaceAll(result, ":dy", "일");
        replaceAll(result, ":hr", "시간");
        replaceAll(result, ":mn", "분");
        return result;
    }
    if (startsWith(text, "Attack: ") || startsWith(text, "Shoot: ") || startsWith(text, "Charges: ")
        || startsWith(text, "Armor: ") || startsWith(text, "Broken   "))
    {
        std::string result = text;
        replaceAll(result, "Broken", "파손");
        replaceAll(result, "Attack: ", "공격: ");
        replaceAll(result, "Shoot: ", "사격: ");
        replaceAll(result, "Damage: ", "피해: ");
        replaceAll(result, "Charges: ", "충전 횟수: ");
        replaceAll(result, "Armor: ", "방어력: ");
        return result;
    }

    // WinGameCertificate uses NAME the Level NUMBER CLASS. Match the final marker
    // so a player-created name containing the same words remains intact.
    const size_t certificateLevel = text.rfind(" the Level ");
    if (certificateLevel != std::string::npos && certificateLevel > 0)
    {
        const size_t levelStart = certificateLevel + 11;
        const size_t levelEnd = text.find_first_not_of("0123456789", levelStart);
        if (levelEnd != std::string::npos && levelEnd > levelStart
            && text[levelEnd] == ' ' && levelEnd + 1 < text.size())
        {
            return text.substr(0, certificateLevel) + " - 레벨 " + text.substr(levelStart, levelEnd - levelStart)
                + " " + className(text.substr(levelEnd + 1));
        }
    }
    if (startsWith(text, "Your score: ")) return "점수: " + text.substr(12);
    if (startsWith(text, "Total Time: "))
    {
        std::string result = "총 시간: " + text.substr(12);
        // Plurals must be replaced before singulars, or an English trailing 's' survives.
        replaceAll(result, " Years", "년");
        replaceAll(result, " Year", "년");
        replaceAll(result, " Months", "개월");
        replaceAll(result, " Month", "개월");
        replaceAll(result, " Days", "일");
        replaceAll(result, " Day", "일");
        return result;
    }
    if (startsWith(text, "Quick save failed: ")) return "빠른 저장 실패: " + text.substr(19);
    if (startsWith(text, "Quick load failed: ")) return "빠른 불러오기 실패: " + text.substr(19);
    if ((endsWith(text, " AM") || endsWith(text, " PM")) && text.find(':') != std::string::npos)
    {
        const bool afternoon = endsWith(text, " PM");
        return std::string(afternoon ? "오후 " : "오전 ") + text.substr(0, text.size() - 3);
    }
    static constexpr const char *MonthNames[] = {
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December",
    };
    for (size_t monthIndex = 0; monthIndex < 12; ++monthIndex)
    {
        const std::string marker = " " + std::string(MonthNames[monthIndex]) + " ";
        const size_t month = text.find(marker);
        if (month != std::string::npos
            && text.find(' ') == month
            && text.find(' ', month + marker.size()) == std::string::npos)
        {
            return text.substr(month + marker.size()) + "년 " + std::to_string(monthIndex + 1)
                + "월 " + text.substr(0, month) + "일";
        }
    }
    if (startsWith(text, "Talk ") && endsWith(text, " Gold"))
        return "대화 " + between(text, "Talk ", " Gold") + "골드";
    if (endsWith(text, " Gold")) return text.substr(0, text.size() - 5) + "골드";

    return std::nullopt;
}
} // namespace KoreanRuntimeText
} // namespace OpenYAMM::Game
