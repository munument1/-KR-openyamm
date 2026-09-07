#include "game/tables/SpellTable.h"

#include <doctest/doctest.h>

using namespace OpenYAMM::Game;

TEST_CASE("Localized spell display fields preserve the English gameplay lookup key")
{
    SpellTable spellTable;
    REQUIRE(spellTable.loadFromRows({
        {"5", "5", "Haste", "none", "가속", "주문 시전과 공격 뒤 회복 시간을 줄입니다."},
    }));

    const SpellEntry *pSpell = spellTable.findByName("Haste");
    REQUIRE(pSpell != nullptr);
    CHECK(pSpell->name == "Haste");
    CHECK(pSpell->shortName == "가속");
    CHECK(pSpell->description == "주문 시전과 공격 뒤 회복 시간을 줄입니다.");
    CHECK(spellTable.findByName("가속") == nullptr);
}
