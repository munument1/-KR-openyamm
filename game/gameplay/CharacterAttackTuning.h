#pragma once

namespace OpenYAMM::Game
{
enum class BlasterSkillScalingMode
{
    Default,
    ScalingDamage,
};

struct CharacterAttackTuning
{
    BlasterSkillScalingMode blasterSkillScaling = BlasterSkillScalingMode::Default;
    int blasterMinimumRecoveryTicks = 0;
};
}
