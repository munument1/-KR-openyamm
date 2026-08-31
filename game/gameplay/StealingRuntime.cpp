#include "game/gameplay/StealingRuntime.h"

#include "game/gameplay/ReputationRuntime.h"

#include <algorithm>
#include <array>
#include <cmath>

namespace OpenYAMM::Game
{
namespace
{
constexpr int BaseFine = 50;
constexpr std::array<int, 5> BaseRecoveryTicksByMastery = {120, 120, 110, 100, 90};

int masteryIndex(SkillMastery mastery)
{
    return std::clamp<int>(static_cast<int>(mastery), 0, 4);
}

int speedStatisticEffect(const Character &member)
{
    const int speed = static_cast<int>(member.speed)
        + member.permanentBonuses.speed
        + member.magicalBonuses.speed;

    if (speed >= 500) return 30;
    if (speed >= 400) return 25;
    if (speed >= 300) return 20;
    if (speed >= 200) return 15;
    if (speed >= 100) return 10;
    if (speed >= 50) return 5;
    return 0;
}

int luckStatisticEffect(const Character &member)
{
    const int luck = static_cast<int>(member.luck)
        + member.permanentBonuses.luck
        + member.magicalBonuses.luck;

    if (luck >= 100) return 10;
    if (luck >= 50) return 5;
    if (luck >= 25) return 2;
    return 0;
}

int shopStealBound(const StealingAttemptInput &input)
{
    if (input.itemReputationRequirement > 0)
    {
        return input.itemReputationRequirement;
    }

    if (input.itemValue > 0)
    {
        return std::min(static_cast<int>(std::ceil(static_cast<double>(input.itemValue) / 100.0)), 50);
    }

    return 0;
}
}

int stealingTotalSkill(const Character &member)
{
    const CharacterSkill *pSkill = member.findSkill("Stealing");

    if (pSkill == nullptr || pSkill->level == 0 || pSkill->mastery == SkillMastery::None)
    {
        return 0;
    }

    int masteryBonus = 0;

    switch (pSkill->mastery)
    {
        case SkillMastery::Expert:
            masteryBonus = 1;
            break;
        case SkillMastery::Master:
            masteryBonus = 2;
            break;
        case SkillMastery::Grandmaster:
            masteryBonus = 4;
            break;
        case SkillMastery::Normal:
        case SkillMastery::None:
        default:
            break;
    }

    int result = static_cast<int>(pSkill->level) + static_cast<int>(pSkill->level) * masteryBonus;
    const auto thieveryBonusIt = member.itemSkillBonuses.find("Thievery");

    if (thieveryBonusIt != member.itemSkillBonuses.end() && thieveryBonusIt->second > 0)
    {
        result *= 2;
    }

    return result;
}

int stealingRecoveryTicks(const Character &member)
{
    const CharacterSkill *pSkill = member.findSkill("Stealing");
    const SkillMastery mastery = pSkill != nullptr ? pSkill->mastery : SkillMastery::None;
    return std::max(0, BaseRecoveryTicksByMastery[masteryIndex(mastery)] - speedStatisticEffect(member));
}

StealingAttemptResult resolveStealingAttempt(const Character &member, const StealingAttemptInput &input)
{
    StealingAttemptResult result = {};
    const CharacterSkill *pRawSkill = member.findSkill("Stealing");

    if (pRawSkill == nullptr || pRawSkill->level == 0 || pRawSkill->mastery == SkillMastery::None)
    {
        return result;
    }

    result.handled = true;
    result.recoverySeconds = static_cast<float>(stealingRecoveryTicks(member)) / 30.0f;
    const int stealing = stealingTotalSkill(member);
    int bound = 0;

    if (input.targetKind == StealingTargetKind::Shop)
    {
        bound = shopStealBound(input);

        if (stealing >= bound && bound > 0 && static_cast<int>(input.successRoll % (stealing + 1)) >= bound)
        {
            if (!input.inventoryHasRoom)
            {
                result.outcome = StealingOutcomeKind::NoInventoryRoom;
                return result;
            }

            result.outcome = StealingOutcomeKind::Success;
            result.stoleItem = true;
            result.reputationDelta = 1;
            return result;
        }
    }
    else
    {
        const int mastery = std::max(1, masteryIndex(pRawSkill->mastery));

        if (input.distanceSquared > 20000 * mastery * mastery)
        {
            result.outcome = StealingOutcomeKind::TooFar;
            return result;
        }

        bound = std::max(1, static_cast<int>(std::ceil(static_cast<double>(std::max(0, input.monsterLevel)) / 10.0)));

        if (stealing < bound)
        {
            result.outcome = StealingOutcomeKind::InsufficientSkill;
        }
        else if (static_cast<int>(input.successRoll % (stealing + 1)) >= bound)
        {
            if (!input.hasLoot)
            {
                result.outcome = StealingOutcomeKind::NothingToSteal;
                result.reputationDelta = input.reputationSensitiveTarget ? 1 : 0;
                return result;
            }

            result.outcome = StealingOutcomeKind::Success;
            result.stoleItem = true;
            result.reputationDelta = input.reputationSensitiveTarget ? 1 : 0;
            return result;
        }
    }

    const int caughtPool = std::max(1, luckStatisticEffect(member) + stealing + input.invisibilitySkill) + 1;
    const int caughtBound = input.targetKind == StealingTargetKind::Shop
        ? (bound == 0 ? 3 : bound + 1)
        : bound + 1;

    if (static_cast<int>(input.caughtRoll % caughtPool) < caughtBound)
    {
        result.outcome = StealingOutcomeKind::FailedCaught;
        result.caught = true;
        result.breakInvisibility = true;
        result.reputationDelta = input.reputationSensitiveTarget ? 2 : 0;
        result.fineDelta = input.reputationSensitiveTarget
            ? BaseFine + (input.targetKind == StealingTargetKind::Shop ? std::max(0, input.itemValue) : 0)
            : 0;
    }
    else
    {
        result.outcome = StealingOutcomeKind::FailedUncaught;
        result.reputationDelta = input.reputationSensitiveTarget ? 1 : 0;
    }

    return result;
}

void applyStealingAttemptResult(
    IGameplayWorldRuntime &worldRuntime,
    Party *pParty,
    const StealingAttemptResult &result)
{
    addStoredCurrentLocationReputation(worldRuntime, result.reputationDelta);

    if (pParty != nullptr && result.fineDelta > 0)
    {
        pParty->addFineGold(result.fineDelta);
    }

    if (pParty != nullptr && result.recoverySeconds > 0.0f)
    {
        pParty->applyRecoveryToActiveMember(result.recoverySeconds);
    }

    if (pParty != nullptr
        && result.breakInvisibility
        && pParty->hasPartyBuff(PartyBuffId::Invisibility))
    {
        pParty->clearPartyBuff(PartyBuffId::Invisibility);
    }
}
}
