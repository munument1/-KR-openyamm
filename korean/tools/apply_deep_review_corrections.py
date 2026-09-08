#!/usr/bin/env python3
"""Apply second-pass Korean review corrections to generated OpenYAMM overlays.

This pass handles corrections that are too context-sensitive for a blind global
replacement: canonical stat terminology, item name/description consistency,
reagent wording, and reviewed artifact/relic effect descriptions.

The script is intentionally post-generation. English source columns and
semantic/runtime keys are never modified.
"""

from __future__ import annotations

import argparse
import csv
import io
import json
from collections import Counter
from pathlib import Path


BROKEN_WORD_REPLACEMENTS: tuple[tuple[str, str], ...] = (
    ("갑작스러행운", "갑작스러운"),
    ("영광스러행운", "영광스러운"),
    ("날카로행운", "날카로운"),
    ("아름다행운", "아름다운"),
    ("가까행운", "가까운"),
    ("불행운하게", "불운하게"),
    ("불행운의", "불운의"),
    ("기행운", "기운"),
)

TABLE_REPLACEMENTS: dict[str, tuple[tuple[str, str], ...]] = {
    "standard_item_enchants.txt": (
        ("지력", "지능"),
        ("정확도", "적중률"),
        ("행운", "운"),
    ),
    "special_item_enchants.txt": (
        ("지력", "지능"),
        ("정확도", "적중률"),
        ("행운", "운"),
        ("신체 피해", "육체 피해"),
        ("신체 저항", "육체 저항"),
    ),
    "stats.txt": (
        ("대기 저항", "공기 저항"),
        ("대기 기반", "공기 기반"),
        ("신체 저항", "육체 저항"),
        ("신체 기반", "육체 기반"),
        ("장착한 활로", "장착한 원거리 무기로"),
    ),
    "skill_des.txt": (
        ("대기 마법", "공기 마법"),
        ("신체 마법", "육체 마법"),
        ("화염/대지/대기/물", "화염/대지/공기/물"),
        ("물건을 사거나 팔 때", "아이템을 사거나 팔 때"),
    ),
    "spells.txt": (
        ("신체 마법", "육체 마법"),
        ("신체 피해", "육체 피해"),
        ("신체 저항", "육체 저항"),
        ("신체 보호", "육체 보호"),
        ("저항력", "저항"),
    ),
}

# Exact reviewed item fields. Keep the canonical Korean item name in the prose
# instead of transliterating the English name a second, inconsistent way.
ITEM_FIELD_OVERRIDES: dict[tuple[int, str], str] = {
    (179, "Notes"): "꿀처럼 달콤한 오렌지색의 제이덤산 황수정입니다. 보석으로서의 품질은 좋지만 마법적인 효능은 없으니, 팔아버리는 편이 좋겠습니다.",
    (208, "Name"): "독말풀",
    (208, "Notes"): "연금술적 성질을 지닌 재료인 독말풀은 파란색 물약을 만드는 데 사용할 수 있습니다. (사용하려면 독말풀을 집어 들고 빈 물약 병 위에 마우스 오른쪽 버튼을 클릭하세요.)",
    (209, "Notes"): "연금술적 성질을 지닌 재료인 드래곤 터틀의 송곳니는 파란색 물약을 만드는 데 사용할 수 있습니다. (사용하려면 송곳니를 집어 들고 빈 물약 병 위에 마우스 오른쪽 버튼을 클릭하세요.)",
    (222, "Notes"): "생명력을 10 + 물약 효능만큼 회복합니다. (마시려면 물약을 집어 들고 캐릭터 초상화를 오른쪽 클릭하십시오. 물약 두 개를 섞으려면 물약을 집어 들고 다른 물약 위에 오른쪽 클릭하십시오.)",
    (507, "Notes"): "(모든 능력치 +10, 육체 피해 10-20) 위대한 뱀파이어 코르부는 낮 시간 동안 자신의 무덤을 지키기 위해 산 인간들을 이용했다고 전해진다. 노예 주문에 묶인 이 불쌍한 영혼들은 이 강력한 미늘창을 들고 순찰을 돌았다. 코르부가 불가사의하게 사라지고 노예 주문이 풀리자, 이 무기들 중 일부가 세상에 나타났다.",
    (512, "Notes"): "(적중률 +50, 빠른 공격 회복 속도, 활 기술 +4) 수많은 위대한 궁수 영웅들의 이야기가 전해지지만, 그중에서도 브레넌 모랜드만큼 뛰어난 영웅은 없었다. 그는 양궁 대회에서 300보 거리에서 동전을 꿰뚫었다는 전설이 있다. 이제 그의 활을 들고 보면, 그 전설이 과연 사람 덕분이었을지 아니면 활 덕분이었을지 궁금해진다.",
    (515, "Notes"): "(빠른 공격 회복 속도, 속도 +15, 적중률 +15, 기사) 블랙샤이어 갑옷 제작자 길드의 각 대장장은 자신의 지위를 증명하기 위해 걸작 판금 갑옷 한 벌을 제작합니다. 길드원이 이러한 갑옷 한 벌을 제작하는 데 10년에서 20년이 걸리는 것은 드문 일이 아닙니다.",
    (518, "Notes"): "(속도 +30, 빠른 공격 회복 속도, 수면 면역) 제1차 엔로스 왕위 계승 전쟁에서 제리코 아이언피스트가 왕위를 차지했을 때, 그는 소식을 전하기 위해 전령들을 보냈습니다. 전령들에게는 이 부츠가 지급되었는데, 이는 소식이 신속하게 퍼져나가 광범위한 내란을 조속히 종식시키기 위한 것이었습니다.",
    (525, "Notes"): "(화염 피해 10-20, 느린 공격 회복 속도, 속도 -20) 대암살자 데메트리 라젠이 마침내 재판정에 섰을 때, 그의 피부는 영구적인 마법으로 인해 비정상적으로 단단해진 것으로 밝혀졌습니다. 일반 칼로는 그를 베지 못했기에, 엔로스 법원이 선고한 사형을 집행하기 위해 '종결'이라는 검이 만들어졌습니다.",
    (535, "Notes"): "(물 마법, 연금술 기술 +5, 지능 +40, 체력 -20) 프리헤이븐 연금술사 길드의 잃어버린 유물인 이 반지는 사라지기 전까지 길드장의 인장이었습니다. 착용자의 에너지를 많이 소모하기 때문에 가장 강력한 물약을 제조할 때만 착용해야 했습니다.",
    (1007, "Notes"): "특이한 성질을 지닌 마법의 시약. 피르나 뿌리는 파란색 물약을 만드는 데 사용할 수 있습니다. (사용하려면 시약을 집어 들고 빈 물약 병 위에 마우스 오른쪽 버튼을 클릭하세요.)",
    (1016, "Name"): "악마의 체액 약병",
    (1016, "Notes"): "특이한 성질을 지닌 마법의 시약. 악마의 체액은 노란색 물약을 만드는 데 사용할 수 있습니다. (사용하려면 시약을 집어 들고 빈 물약 병 위에 마우스 오른쪽 버튼을 클릭하세요.)",
    (1021, "Notes"): "특이한 성질을 지닌 마법의 시약. 현자의 돌은 촉매를 만드는 데 사용할 수 있습니다. (사용하려면 시약을 집어 들고 빈 물약 병 위에 마우스 오른쪽 버튼을 클릭하세요.)",
    (1303, "Notes"): "(힘 +40, 전기 피해 6-15) 믿을 수 없을 정도로 가벼운 양손검인 철깃털은 소유자의 힘을 증가시켜 거대한 무기를 더욱 쉽게 휘두를 수 있도록 해줍니다. 이 조합 덕분에 거의 한 손으로도 검을 사용할 수 있지만, 칼날의 거대한 크기가 유일한 문제점입니다.",
    (1308, "Notes"): "(명중 시 폭발, 화염 저항 +50) 강력한 무기임에도 불구하고, 파쇄자는 한 사람이 오랫동안 휘두르는 경우가 드뭅니다. 칼날이 부딪히면 엄청난 화염이 뿜어져 나오는데, 무기가 제공하는 마법적인 화염 방어력만으로는 사용자를 화염 폭발로부터 완전히 보호하기에 충분하지 않습니다.",
    (1309, "Notes"): "(언데드 처치, 마비 면역, 화염 피해 3-18) 구울베인은 150여 년 전 태양교회가 달교회가 만들어낸 끊임없이 증가하는 언데드 무리를 소탕하기 위한 노력의 일환으로 제작되었습니다. 강력한 무기이지만, 이는 단 하나의 무기일 뿐이며 언데드는 무수히 많습니다. 태양교회는 서기 1083년에 멸망했습니다.",
    (1310, "Notes"): "(언데드 사냥, 드래곤 사냥, 악마 사냥) 교수대는 말 그대로 냉혹한 무기로, 괴물의 시대를 끝내고 인간의 시대를 열기 위해 눈먼 메코리그가 만들었다. 고귀한 의도였지만, 결과는 그다지 좋지 않았다. 교수대는 종종 수년 동안 사라졌다가 야심 찬 모험가들에 의해 드래곤의 보물창고에서 재발견되곤 한다. 이 무기의 강력한 힘에 매료된 모험가들은 종종 교수대를 다른 드래곤의 보물창고로 옮기지만, 그곳에서도 또다시 수년 동안 사라지곤 한다.",
    (1311, "Notes"): "레그나 '제국' 건국 당시 하렉 1세의 명령으로 제작된 샤렐은 그의 아내인 샤렐 왕비의 이름을 따서 명명되었습니다. 이 창은 서기 590년 하렉 1세가 독살당한 뒤 이어진 혼란기에 레그나의 유일한 에라시아 전초기지에 남겨졌습니다.",
    (1312, "Notes"): "(적중률 +50, 물 피해 9-12) 궁수의 꿈. 율리시스는 화살이 필요 없으며, 활시위를 당기면 얼음 화살이 생성되어 발사됩니다. 기원은 알려지지 않았지만, 양식으로 보아 엘프족이 만든 것으로 추정됩니다.",
    (1314, "Notes"): "(속도 +40, 물 마법) 착용자의 반사 신경과 속도를 향상시켜 주는 이 부츠의 진정한 기능은 물 마법 사용을 용이하게 하여 여행을 빠르게 하는 것입니다. 이 부츠를 신는 자는 위대한 운명을 맞이하지만, 반드시 명예를 얻는 것은 아닙니다. 이 부츠의 이전 소유자들은 온갖 말썽을 일으켰습니다.",
    (1315, "Notes"): "(정신 마법, 어둠 마법) 통치자의 반지는 서기 744년, 나이곤의 마법사 집단 수석 연금술사 조슈아 스톰이 제작했습니다. 본질적으로 악한 유물은 아니지만, 이 반지는 오직 지배하고 정복하기 위한 목적으로 만들어졌습니다.",
    (1316, "Notes"): "(힘 +150, 지능 -40, 인격 -40, 속도 -40) 매시는 최초의 오우거가 신들에게 그 어떤 것보다 강한 무기를 달라고 기도한 것에 대한 응답이라고 전해집니다. 이에 분노한 신들은 최초의 오우거에게 매시라는 저주를 내렸고, 그 이후 모든 오우거는 그 저주의 낙인, 즉 강하지만 느리고 둔하며 어리석음을 지니게 되었습니다. 어쨌든, 이제 매시는 당신의 것입니다.",
    (1318, "Notes"): "(도둑질 기술 +5, 함정 해제 기술 +5, 물 위 걷기, 운 +50, 모든 저항 -10) 이 가죽 갑옷은 레그나의 군주이자 끝없는 바다의 황제인 하렉 1세를 위해 레그나 무기고에서 특별히 제작되었습니다. 이 갑옷은 하렉과 같은 영광스러운 해적이 바랄 수 있는 모든 것을 갖추고 있었지만, 독으로부터는 보호해 주지 못했습니다. 레그나의 위대한 초대 황제는 이 갑옷을 입고 저녁 식사 직후 아내의 손에 독살당해 사망했습니다.",
    (1319, "Notes"): "(함정 해제 기술 +5, 독 피해 8, 엘프 학살, 악) 수 세기 동안 암살자들 사이에서 비밀리에 전해져 온 올드 닉은 약 200년 전 인간과 엘프 연합군이 암살자 길드를 공격했던 '새벽 전투' 중에 역사의 기록에서 자취를 감췄습니다. 올드 닉이 흑사병보다 더 많은 사람을 죽였다는 이야기가 전해집니다. 이제 당신은 이 사악한 무기를 손에 넣었으니 우물에 던져버리려는 겁니까?",
    (1320, "Notes"): "(힘 +100, 체력 +100, 방어력 -15) 어먹의 원래 이름은 세월 속에 잊혔지만, 날은 여전히 마법처럼 날카롭고 본래의 힘도 모두 간직하고 있습니다. 소유자는 엄청난 힘과 활력을 얻지만, 그 대가로 적절한 공포심을 잃게 됩니다. 어먹을 휘두르는 자는 전투에서 공격을 피하는 데 그다지 신경 쓰지 않습니다.",
    (1323, "Notes"): "(빛 마법, 인격 +15, 힘 +15, 운 -40, 선함) 서기 870년부터 태양 교회의 최고 성물 전달자이자 신성한 통로였던 탈레돈이 소유했던 이 강력한 투구는 아마도 881년 그의 갑작스러운 죽음에 일조했을 것입니다. 물건에 마법을 너무 많이 부여하면 부정적인 기운이 배어 나온다고 합니다. 이 경우 그 부정적인 기운이 착용자를 극도로 불운하게 만들었습니다. 당대 가장 강력한 인물 중 하나였던 노련한 외교관이자 군인, 그리고 사제였던 탈레돈은 스테드윅에서 길을 건너던 중 폭주하는 농민의 마차 바퀴에 깔려 사망했습니다.",
    (1326, "Notes"): "(힘 +75, 속도 -40) 다른 많은 유사 아이템과 마찬가지로, 타이탄의 허리띠는 착용자의 힘을 증가시키는 대신 속도를 감소시킵니다. 이 유물의 유일한 차이점은 그 감소폭이 훨씬 크다는 것입니다.",
    (1328, "Notes"): "(적중률 +150, 활 기술 +5, 방어력 -25) 명장 대장장이 이반 셀빙은 이 석궁을 자신의 외동딸 아니아의 이름을 따서 지었으며, 자신이 만든 것 중 두 번째로 훌륭한 작품이라고 칭했습니다. 이 석궁을 사용하는 궁수는 목표물을 거의 빗맞히지 않지만, 집중력과 느리고 신중한 움직임 때문에 오히려 쉽게 표적이 되기도 합니다.",
    (1330, "Notes"): "(영혼 마법, 힘 +75, 공기 저항 -50) 이 망치는 위대한 맹인 메코리그가 메코리그 주조소의 수장으로 재임하며 세계 최고의 마법 장비를 만들어낼 때 사용했던 바로 그 망치입니다. 이 망치는 원소와 연결되어 있어 사용자는 원소 마법에 취약하지만, 망치가 제공하는 향상된 자기 능력과 힘을 생각하면 감수할 만한 가치가 있습니다.",
    (2021, "Notes"): "토르의 기원은 시간의 흐름 속에 묻혀버렸지만, 이 강력한 야만족의 무기는 군사 역사가들에게는 잘 알려져 있습니다. 이 무기는 수 세기 동안 여러 주인의 손에 의해 전투에서 사용되었으며, 마지막으로 등장한 것은 서기 902년 시멘가르드 전투였습니다. 이 망치의 위력은 너무나 강력해서 적을 사용자로부터 수 미터 뒤로 날려버릴 수 있습니다. (특수 능력: 명중한 적을 밀쳐냄)",
    (2025, "Notes"): "퍼시벌은 912년 궁수 길드에서 당시 개발 중이던 마법 부여 과정의 시제품으로 제작되었습니다. 하지만 길드 회관에서 의문의 화재가 발생하여 개발 계획이 무산되고, 더 많은 퍼시벌을 만드는 데 필요한 희귀 재료들이 모두 소실되었습니다. 길드는 이 손실에서 회복하지 못하고 918년에 퍼시벌을 엘프족에게 팔았습니다. 이후 퍼시벌은 여러 차례 주인이 바뀌었습니다. (특수 능력: 빠른 공격 회복 속도, 명중 시 폭발)",
    (2027, "Notes"): "고대 기사의 이름을 딴 펠리노어는 착용자에게 비정상적으로 강력한 체력을 부여하여 심각한 부상도 몇 시간 만에 회복할 수 있게 합니다. 이 갑옷은 상당히 무겁지만, 전투 중 공격을 받아도 빠르게 자세를 회복할 수 있게 해줍니다. (특수 능력: 체력 +30, 회복 속도 증가, 생명력 재생)",
    (2035, "Notes"): "연쇄살인범의 소원에 따라 저승에서 내려왔다고 전해지는 강력한 무기입니다. 면도날처럼 날카로운 칼날은 끔찍한 상처를 입히고, 끊임없이 산성 액체를 흘립니다. 무시무시한 무기일 뿐만 아니라, 이 검은 함정을 해제하는 데 탁월한 도둑의 지혜와 함정에서 벗어나는 데 악마의 행운을 부여합니다. 하데스는 사용자의 힘을 천천히, 그리고 끊임없이 흡수합니다. (특수 능력: 독 피해 +20, 운 +20, 도둑질 +20, 시간이 지남에 따라 생명력 감소)",
    (2038, "Notes"): "실용적인 무기라기보다는 마법적인 호기심에 가까운 크로노스는 사용자의 생명력을 엄청나게 증가시키는 반면, 운은 그 절반만큼 감소시킵니다. (특수 능력: 생명력 +100, 운 -50)",
    (2040, "Notes"): "천둥의 위력을 지닌 아르테미스는 마법으로 충전된 전기 화살을 발사합니다. 강력한 활이지만, 사용자는 주의해야 합니다. 원소 마법이 활에 끌리는 듯하며, 활에 맞으면 더욱 큰 피해를 입힙니다. (특수 능력: 전기 피해 +20, 원소 저항 -10)",
    (2043, "Notes"): "전설에 따르면 이 방패는 무시무시한 메두사들의 요새에서 싸우고자 하는 한 남자에게 신들이 선물한 것이라고 합니다. 방패는 반사 재질로 되어 있어 메두사의 석화 시선으로부터 사용자를 보호합니다. 또한 원거리 투사체 피해를 줄이는 마법이 걸려 있지만, 방패가 매우 무거워 사용자의 움직임을 다소 느리게 합니다. (특수 능력: 석화 면역, 원거리 투사체 피해 절반, 운 +20, 속도 -20)",
    (2047, "Notes"): "오랜 세월 동안 어리석은 자들의 욕망과 갈망을 불러일으켰던 이 아름다운 반지는 피부를 매끄럽게 하고 목소리를 맑게 하며 착용자의 외모를 극적으로 개선할 뿐만 아니라 인격까지 향상시켜 줍니다. 하지만 이 반지는 불운의 저주를 품고 있어, 착용자는 반지를 발견한 직후 비극적인 사고로 죽음을 맞이하는 경우가 많습니다. (특수 능력: 인격 +100, 운 -40)",
    (2049, "Notes"): "때때로 '바보의 부적'이라고도 불리는 이 기묘한 유물은 대침묵의 시대 이전부터 존재해 왔으며, 착용자의 활력, 마법 에너지, 행운을 극적으로 증가시키지만, 그 대가로 인격이 저하됩니다. 이 부적을 착용하는 동안 얼굴은 무표정해지고, 눈빛은 공허해지며, 목소리는 단조로워집니다. (특수 능력: 생명력 +50, 주문력 +50, 운 +50, 인격 -50)",
}

# The English source and the current name both say Wyrm Spitter. Keep this as
# a regression guard because one report suggested the different word Splitter.
WYRM_SPITTER_ID = 506

GEM_STYLE_VARIANTS: tuple[tuple[str, str], ...] = (
    ("보석으로서의 품질은 좋지만, 마법적인 효능은 없으니 팔아버리는 게 나을지도 몰라요.",
     "보석으로서의 품질은 좋지만 마법적인 효능은 없으니, 팔아버리는 편이 좋겠습니다."),
    ("보석으로서의 품질은 좋지만 마법적인 효능은 없으니, 차라리 파시는 게 나을지도 모르겠네요.",
     "보석으로서의 품질은 좋지만 마법적인 효능은 없으니, 팔아버리는 편이 좋겠습니다."),
    ("보석으로서의 품질은 좋지만 마법적인 효능은 없으니 팔아버리는 게 나을지도 모릅니다.",
     "보석으로서의 품질은 좋지만 마법적인 효능은 없으니, 팔아버리는 편이 좋겠습니다."),
)


def replace_all(text: str, replacements: tuple[tuple[str, str], ...], counts: Counter[str]) -> str:
    result = text
    for source, target in replacements:
        count = result.count(source)
        if count:
            result = result.replace(source, target)
            counts[source] += count
    return result


def item_context_corrections(source: str, translation: str, counts: Counter[str]) -> str:
    result = replace_all(translation, BROKEN_WORD_REPLACEMENTS, counts)
    result = replace_all(result, GEM_STYLE_VARIANTS, counts)

    # These are safe when the English source explicitly identifies the stat.
    if "Intellect" in source:
        result = replace_all(result, (("지력", "지능"),), counts)
    if "Accuracy" in source:
        result = replace_all(result, (("정확도", "적중률"),), counts)
    if "Luck" in source:
        result = replace_all(result, (("행운 +", "운 +"), ("행운 -", "운 -")), counts)
    if "Resistance" in source or "Resistances" in source:
        result = replace_all(result, (("모든 저항력", "모든 저항"),), counts)
    if "Body" in source:
        result = replace_all(result, (("신체 피해", "육체 피해"), ("신체 저항", "육체 저항")), counts)
    if "Earth" in source:
        result = replace_all(result, (("흙 마법", "대지 마법"),), counts)

    # Upstream reagent prose often says "pick the herb up" even for stones,
    # vials, fangs, etc. Korean uses the neutral gameplay term 시약.
    if "reagent" in source.lower():
        result = replace_all(result, (("마법의 재료", "마법의 시약"),), counts)
        for phrase in ("약초를 줍고", "허브를 줍고", "허브를 채취한 후", "약초를 채취한 후"):
            result = replace_all(result, ((phrase, "시약을 집어 들고"),), counts)

    return result


def correct_catalog_entry(entry: dict) -> tuple[bool, Counter[str]]:
    translation = entry.get("translation", "")
    if not isinstance(translation, str) or not translation:
        return False, Counter()

    counts: Counter[str] = Counter()
    source_name = Path(str(entry.get("source_file", ""))).name
    source = str(entry.get("source", ""))
    field = str(entry.get("field", ""))
    try:
        record_id = int(entry.get("record_id"))
    except (TypeError, ValueError):
        record_id = -1

    corrected = replace_all(translation, BROKEN_WORD_REPLACEMENTS, counts)
    corrected = replace_all(corrected, TABLE_REPLACEMENTS.get(source_name, ()), counts)

    if source_name == "items.txt":
        corrected = item_context_corrections(source, corrected, counts)
        override = ITEM_FIELD_OVERRIDES.get((record_id, field))
        if override is not None and corrected != override:
            counts[f"item:{record_id}:{field}"] += 1
            corrected = override

    # Dragon Turtle is the canonical creature name in monster_data.txt.
    if "Dragon Turtle" in source:
        corrected = replace_all(corrected, (("용거북", "드래곤 터틀"),), counts)

    if corrected == translation:
        return False, counts

    entry["translation"] = corrected
    note = str(entry.get("note", "")).strip()
    review_note = "MMMerge 1.0.14/1.0.16 deep terminology and item review applied."
    if review_note not in note:
        entry["note"] = f"{note} {review_note}".strip()
    return True, counts


def correct_items_tsv(text: str) -> tuple[str, Counter[str]]:
    rows = list(csv.reader(io.StringIO(text, newline=""), delimiter="\t", quotechar='"'))
    counts: Counter[str] = Counter()
    if len(rows) < 2:
        return text, counts

    header_index = next((i for i, row in enumerate(rows) if row and row[0] == "Item #"), None)
    if header_index is None:
        raise ValueError("items.txt header row was not found")
    header = rows[header_index]
    name_column = header.index("Name")
    notes_column = header.index("Notes")

    for row in rows[header_index + 1:]:
        if not row or not row[0].strip().isdigit():
            continue
        item_id = int(row[0].strip())
        while len(row) <= notes_column:
            row.append("")

        # The generated TSV no longer carries the English note next to the
        # Korean note, so exact item overrides are authoritative here.
        for field, column in (("Name", name_column), ("Notes", notes_column)):
            override = ITEM_FIELD_OVERRIDES.get((item_id, field))
            if override is not None and row[column] != override:
                row[column] = override
                counts[f"item:{item_id}:{field}"] += 1

        for column in range(len(row)):
            row[column] = replace_all(row[column], BROKEN_WORD_REPLACEMENTS, counts)
            row[column] = replace_all(row[column], GEM_STYLE_VARIANTS, counts)

        # Context-safe mechanical terminology in the generated item table.
        row[notes_column] = replace_all(
            row[notes_column],
            (("신체 피해", "육체 피해"), ("신체 저항", "육체 저항"), ("흙 마법", "대지 마법"), ("모든 저항력", "모든 저항")),
            counts,
        )

    output = io.StringIO(newline="")
    csv.writer(
        output,
        delimiter="\t",
        quotechar='"',
        quoting=csv.QUOTE_MINIMAL,
        lineterminator="\n",
    ).writerows(rows)
    return output.getvalue(), counts


def correct_overlay_text(path: Path, text: str) -> tuple[str, Counter[str]]:
    counts: Counter[str] = Counter()
    if path.name == "items.txt":
        return correct_items_tsv(text)

    corrected = replace_all(text, BROKEN_WORD_REPLACEMENTS, counts)
    corrected = replace_all(corrected, TABLE_REPLACEMENTS.get(path.name, ()), counts)
    return corrected, counts


def validate_catalog(catalog: dict) -> None:
    errors: list[str] = []
    by_item_field: dict[tuple[int, str], str] = {}

    for entry in catalog.get("entries", []):
        translation = entry.get("translation", "")
        if not isinstance(translation, str):
            continue
        for broken, _ in BROKEN_WORD_REPLACEMENTS:
            if broken in translation:
                errors.append(f"{entry.get('key', '<unknown>')}: broken bulk-replacement form {broken!r}")

        source_name = Path(str(entry.get("source_file", ""))).name
        if source_name == "items.txt":
            try:
                item_id = int(entry.get("record_id"))
            except (TypeError, ValueError):
                item_id = -1
            by_item_field[(item_id, str(entry.get("field", "")))] = translation

    for key, expected in ITEM_FIELD_OVERRIDES.items():
        actual = by_item_field.get(key)
        if actual != expected:
            errors.append(f"items.txt {key}: expected reviewed translation {expected!r}, got {actual!r}")

    wyrm_name = by_item_field.get((WYRM_SPITTER_ID, "Name"))
    if wyrm_name != "웜 스피터":
        errors.append(f"Wyrm Spitter regression: expected '웜 스피터', got {wyrm_name!r}")

    if errors:
        raise ValueError("Deep Korean review validation failed:\n" + "\n".join(errors[:80]))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=None)
    parser.add_argument("--catalog", default="korean/translations/catalog.json")
    parser.add_argument("--engine-overlay-root", default="korean/overlay/engine")
    parser.add_argument("--world-overlay-root", default="korean/overlay/worlds")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve() if args.repo_root else Path(__file__).resolve().parents[2]
    catalog_path = repo_root / args.catalog
    engine_overlay_root = repo_root / args.engine_overlay_root
    world_overlay_root = repo_root / args.world_overlay_root

    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    changed_entries = 0
    changed_files = 0
    total_counts: Counter[str] = Counter()

    for entry in catalog.get("entries", []):
        changed, counts = correct_catalog_entry(entry)
        changed_entries += int(changed)
        total_counts.update(counts)

    validate_catalog(catalog)
    catalog_path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    overlay_paths: list[Path] = []
    if engine_overlay_root.exists():
        overlay_paths.extend(sorted(engine_overlay_root.rglob("*.txt")))
    if world_overlay_root.exists():
        overlay_paths.extend(sorted(world_overlay_root.rglob("*.lua")))

    for path in overlay_paths:
        original = path.read_text(encoding="utf-8-sig")
        corrected, counts = correct_overlay_text(path, original)
        total_counts.update(counts)
        if corrected != original:
            path.write_text(corrected, encoding="utf-8", newline="")
            changed_files += 1

    print(f"DEEP_REVIEW_CHANGED_ENTRIES={changed_entries}")
    print(f"DEEP_REVIEW_CHANGED_FILES={changed_files}")
    print(f"DEEP_REVIEW_TOTAL_REPLACEMENTS={sum(total_counts.values())}")
    for key, value in sorted(total_counts.items()):
        if value:
            print(f"{key}: {value}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
