-- MMMerge global supplement: MM6 quest follower behavior and topic overlays.

local enrothGrandmasterTeacherTopics = {
    {npc = 1043, slot = 3, topic = 302}, -- GM Staff
    {npc = 837, slot = 3, topic = 305}, -- GM Sword
    {npc = 995, slot = 3, topic = 308}, -- GM Dagger
    {npc = 817, slot = 3, topic = 311, qbit = 1051}, -- GM Axe
    {npc = 991, slot = 3, topic = 314}, -- GM Spear
    {npc = 973, slot = 3, topic = 317}, -- GM Bow
    {npc = 874, slot = 3, topic = 320}, -- GM Mace
    {npc = 830, slot = 3, topic = 329}, -- GM Leather
    {npc = 811, slot = 3, topic = 332}, -- GM Chain
    {npc = 808, slot = 3, topic = 335}, -- GM Plate
    {npc = 890, slot = 4, topic = 338}, -- GM Fire
    {npc = 965, slot = 4, topic = 341}, -- GM Air
    {npc = 829, slot = 4, topic = 344}, -- GM Water
    {npc = 894, slot = 3, topic = 347}, -- GM Earth
    {npc = 923, slot = 4, topic = 350}, -- GM Spirit
    {npc = 858, slot = 3, topic = 353}, -- GM Mind
    {npc = 840, slot = 4, topic = 356}, -- GM Body
    {npc = 1057, slot = 3, topic = 359}, -- GM Light
    {npc = 1040, slot = 3, topic = 362}, -- GM Dark
    {npc = 814, slot = 3, topic = 377}, -- GM Merchant
    {npc = 996, slot = 3, topic = 380}, -- GM Repair
    {npc = 972, slot = 3, topic = 383}, -- GM Bodybuilding
    {npc = 1014, slot = 3, topic = 386}, -- GM Meditation
    {npc = 842, slot = 3, topic = 389}, -- GM Perception
    {npc = 875, slot = 3, topic = 395}, -- GM Disarm Trap
    {npc = 1114, slot = 3, topic = 405}, -- Expert Armsmaster
    {npc = 860, slot = 3, topic = 406}, -- Master Armsmaster
    {npc = 860, slot = 4, topic = 407}, -- GM Armsmaster
    {npc = 819, slot = 3, topic = 413}, -- GM Alchemy
    {npc = 809, slot = 4, topic = 416}, -- GM Learning
    {npc = 870, slot = 3, topic = 374}, -- GM Identify Item
    {npc = 915, slot = 3, topic = 973}, -- GM Blaster
    {npc = 966, slot = 4, topic = 326}, -- GM Shield
}

local function applyEnrothGrandmasterTeacherTopic(entry)
    if entry.qbit and not IsQBitSet(QBit(entry.qbit)) then
        evt.SetNPCTopic(entry.npc, entry.slot, 0)
        return
    end
    evt.SetNPCTopic(entry.npc, entry.slot, entry.topic)
end

local function applyEnrothGrandmasterTeacherTopics()
    for _, entry in ipairs(enrothGrandmasterTeacherTopics) do
        applyEnrothGrandmasterTeacherTopic(entry)
    end
end

RegisterGlobalOnLoadEvent(65300, "MMerge Enroth grandmaster teacher topics", function()
    applyEnrothGrandmasterTeacherTopics()
end)

RegisterGlobalNpcEnterHook(65301, "MMerge Enroth grandmaster teacher topics", function(context)
    for _, entry in ipairs(enrothGrandmasterTeacherTopics) do
        if context.npcId == entry.npc then
            applyEnrothGrandmasterTeacherTopic(entry)
        end
    end
end)

RegisterGlobalEvent(1358, "I lost it", function()
    MM6.RecoverLostItem()
end)

AppendGlobalEvent(1327, function()
    MM6.RemoveQuestFollowerUnless(1699, 796)
end)

AppendGlobalEvent(1344, function()
    MM6.AddQuestFollower(796)
end)

AppendGlobalEvent(1346, function()
    MM6.RemoveQuestFollowerUnless(1701, 802)
end)

AppendGlobalEvent(1347, function()
    MM6.RemoveQuestFollower(802)
end)

-- MM6 original promotion scripts only iterate four party members. OpenYAMM/MMerge parties can have a fifth member.
local mm6PromotionPlayers = {Players.Member0, Players.Member1, Players.Member2, Players.Member3, Players.Member4}

local function promoteMM6Party(requiredClassId, promotedClassId, promotionQBitId, honoraryQBitId)
    for _, player in ipairs(mm6PromotionPlayers) do
        evt.ForPlayer(player)
        if IsAtLeast(ClassId, requiredClassId) then
            SetValue(ClassId, promotedClassId)
            SetQBit(QBit(promotionQBitId))
        else
            SetQBit(QBit(honoraryQBitId))
        end
    end
end

ReplaceGlobalEvent(1327, "Legacy event 1327", function()
    if not IsQBitSet(QBit(1699)) then -- Replacement for NPCs 11 ver. 6
        evt.SetMessage("I know there is a shortage of damsels in distress, but this quest is the traditional test.\nI really can't bend the rules here.\nKeep looking... I'm sure you'll find someone.\nIf it helps, I hear Melody Silver, daughter of the noble John Silver, is being held captive by ruffians on the Island of Mist.")
        MM6.RemoveQuestFollowerUnless(1699, 796)
        return
    end
    evt.SetMessage("I have heard stories of the daring rescue, and I am delighted that you have returned with Miss Silver.\nI shall arrange to have her returned to her family at once.\nExemplary work!\nI hereby officially promote all paladins to the status of crusader, and all non-paladins to honorary crusaders!")
    promoteMM6Party(26, 27, 1635, 1636) -- Crusader / Honorary Crusader
    AddValue(Gold, 5000)
    ClearQBit(QBit(1699)) -- Replacement for NPCs 11 ver. 6
    ClearQBit(QBit(1112)) -- Rescue a Damsel in Distress and return with her to Wilbur Humphrey in Castle Ironfist. - Paul
    AddValue(131307, 2)
    evt.ForPlayer(Players.All)
    AddValue(Experience, 15000)
    evt.SetNPCTopic(789, 1, 1328) -- Wilbur Humphrey topic 1: Heroes
    MM6.RemoveQuestFollowerUnless(1699, 796)
end)

ReplaceGlobalEvent(1329, "Legacy event 1329", function()
    evt.ForPlayer(Players.All)
    if not HasItem(2075) then -- Dragon Claw
        evt.SetMessage("There is no use returning to me to talk about your quest.")
        return
    end
    evt.SetMessage("Well done!\nOne less horrible monster in the world is a good thing.\nI hereby officially promote all crusaders to heroes, and all honorary crusaders to the status of honorary hero! May you long continue to live up to the title!")
    AddValue(Experience, 30000)
    RemoveItem(2075) -- Dragon Claw
    ClearQBit(QBit(1209)) -- Quest item bits for seer
    promoteMM6Party(27, 28, 1637, 1638) -- Hero / Honorary Hero
    AddValue(327915, 5)
    ClearQBit(QBit(1113)) -- Slay Longfang Witherhide in his cave near Castle Darkmoor and return to Wilbur Humphrey in Castle Ironfist. - Paul
    evt.SetNPCTopic(789, 1, 1330) -- Wilbur Humphrey topic 1: Heroes
end)

ReplaceGlobalEvent(1349, "Legacy event 1349", function()
    if not IsQBitSet(QBit(1130)) then -- NPC
        evt.SetMessage("The temple I asked you to rebuild still stands in ruins.\nThe people are deprived of their rightful religious solace, and you return to me empty-handed.\nLeave here and complete your mission!\n")
        return
    end
    evt.SetMessage("Excellent work!\nThe temple has been rebuilt and the affront to the gods eased.\nFor this service, I am happy to promote all clerics to priests, and I grant honorary priest status to all non-clerics.\nCongratulations! ")
    ClearQBit(QBit(1129)) -- Hire a Stonecutter and a Carpenter, bring them to Temple Stone in Free Haven to repair the Temple, and then return to Lord Anthony Stone at Castle Stone. - NPC
    evt.SetNPCTopic(801, 1, 1350) -- Anthony Stone topic 1: High Priests
    AddValue(131307, 2)
    evt.ForPlayer(Players.All)
    AddValue(Experience, 15000)
    promoteMM6Party(4, 5, 1647, 1648) -- Priest / Honorary Priest
end)

ReplaceGlobalEvent(1351, "Legacy event 1351", function()
    evt.ForPlayer(Players.All)
    if IsQBitSet(QBit(1132)) then -- NPC
        evt.SetMessage("You are successful!\nIt looks like I will have to keep my promise and make more irregular, early promotions.\nI do so with pleasure.\nI hereby promote all priests to high priests, and all honorary priests to honorary high priests.")
        promoteMM6Party(5, 6, 1649, 1650) -- High Priest / Honorary High Priest
        AddValue(327915, 5)
        ClearQBit(QBit(1131)) -- Take the Sacred Chalice from the monks in their island temple east of Free Haven, return it to Temple Stone in Free Haven, and then return to Lord Stone at Castle Stone. - NPC
        evt.ForPlayer(Players.All)
        AddValue(Experience, 30000)
        evt.SetNPCTopic(801, 1, 1352) -- Anthony Stone topic 1: High Priests
    elseif HasItem(2054) then -- Sacred Chalice
        evt.SetMessage("I see that you have recovered the chalice!\nGood work, but you still need to ensconce it in the temple.\nTake it there at once and return to me for your promotion!")
    else
        evt.SetMessage("The monks still have the chalice, and our temple is still without it.\nWhy do you delay?")
    end
end)

ReplaceGlobalEvent(1371, "Legacy event 1371", function()
    evt.SetMessage("You have done well in finding the Fountain.\nIt's location and powers are a secret, do not spread its location around.\nNow, let me show you the secrets of the wizard.")
    evt.ForPlayer(Players.All)
    AddValue(Experience, 15000)
    promoteMM6Party(42, 43, 1639, 1640) -- Wizard / Honorary Wizard
    AddValue(131307, 2)
    ClearQBit(QBit(1135)) -- Drink from the Fountain of Magic and return to Lord Albert Newton in Mist. - NPC
    evt.SetNPCTopic(790, 1, 1372) -- Albert Newton topic 1: Master Wizards
end)

ReplaceGlobalEvent(1373, "Legacy event 1373", function()
    evt.ForPlayer(Players.All)
    if not HasItem(2077) then -- Crystal of Terrax
        evt.SetMessage("I'm sorry, but I still haven't remembered exactly what it is you need.\nI know you need to search Corlagon's Estate.\n ")
        return
    end
    evt.SetMessage("Great news!\nI remember what you need to find!\nThe Crystal of Terrax!\nOh, you seem to have found it already.\nWell, perfect!\nI can train you to master wizards, then.\nThe first arch mage, Terrax, used this Crystal to master the elements.\nFire, earth, water, and air all formed together to make it, and from analyzing it he learned a great deal about elemental magic.\nIn addition, its effect on light led him to his discoveries of light and dark magic.\nSince that time, the study of this crystal has guided every new master wizard.\nLet me show you the secrets of the crystal. ")
    AddValue(Experience, 30000)
    promoteMM6Party(43, 46, 1641, 1642) -- Archmage / Honorary Archmage
    AddValue(327915, 5)
    ClearQBit(QBit(1136)) -- Retrieve the Crystal of Terrax and return to Lord Albert Newton in Mist. - NPC
    evt.ForPlayer(Players.All)
    RemoveItem(2077) -- Crystal of Terrax
    ClearQBit(QBit(1210)) -- Quest item bits for seer
    evt.SetNPCTopic(790, 1, 1353) -- Albert Newton topic 1: Arch Mages
end)

ReplaceGlobalEvent(1382, "Legacy event 1382", function()
    evt.SetMessage("Congratulations!\nThe nomination may not seem important, but we have a tradition that must be followed for this promotion.\nAs a cavalier, you need to understand that the traditions and values of the people need to be defended.\nI gladly promote you to the rank of cavalier!")
    ClearQBit(QBit(1138)) -- Get Knight's nomination from Chadwick and return to Lord Osric Temper at Castle Temper. - NPC
    AddValue(131307, 2)
    evt.ForPlayer(Players.All)
    AddValue(Experience, 15000)
    promoteMM6Party(16, 17, 1643, 1644) -- Cavalier / Honorary Cavalier
    evt.SetNPCTopic(791, 1, 1383) -- Osric Temper topic 1: Champions
    evt.SetNPCTopic(792, 0, 1380) -- Chadwick Blackpoole topic 0: Cavaliers
end)

ReplaceGlobalEvent(1384, "Legacy event 1384", function()
    evt.ForPlayer(Players.All)
    if not HasItem(2128) then -- Discharge Papers
        evt.SetMessage("You're not scared of the Warlord, are you?\nHis terror needs to be put to an end.\nYou can't become champion hiding underneath your bed or standing around looking at the walls... you need to go out and DO it!")
        return
    end
    evt.SetMessage("Good job!\nExcellent!\nI wasn't sure you'd make it back alive.\nKergmond had more potential than I realized, but you're certainly more than a match for an army of Kergmonds.\nYou've proven yourselves worthy of the rank of champion. You must not be afraid to take up arms to defend what is right.\nMay your enemies fear your approach and your allies rally behind your courage. And now, I promote you to the rank of champion! ")
    promoteMM6Party(17, 19, 1645, 1646) -- Champion / Honorary Champion
    AddValue(327915, 5)
    ClearQBit(QBit(1139)) -- Defeat the Warlord and bring proof to Osric Temper - NPC
    evt.ForPlayer(Players.All)
    AddValue(Experience, 40000)
    RemoveItem(2128) -- Discharge Papers
    ClearQBit(QBit(1211)) -- Quest item bits for seer
    evt.SetNPCTopic(791, 1, 1385) -- Osric Temper topic 1: Champions
end)

ReplaceGlobalEvent(1405, "Legacy event 1405", function()
    evt.ForPlayer(Players.All)
    if not HasItem(2106) then -- Dragon Tower Keys
        evt.SetMessage("No key...No reward.")
        return
    end
    evt.SetMessage("Very good!\nYou got the key, and hopefully slew a large number of those loathsome beasts.\nI hereby promote all archers to the status of warrior mage, and all non-archers to honorary warrior mage.")
    promoteMM6Party(0, 1, 1655, 1656) -- Battle Mage / Honorary Battle Mage
    ClearQBit(QBit(1145)) -- Retrieve the key to the Dragon Towers from Icewind Keep south of Whitecap, and bring it to Lord Stromgard at Castle Stromgard. - NPC
    AddValue(131307, 2)
    evt.ForPlayer(Players.All)
    AddValue(Experience, 15000)
    evt.SetNPCTopic(800, 1, 1406) -- Erik Von Stromgard topic 1: Master Archers
end)

ReplaceGlobalEvent(1413, "Legacy event 1413", function()
    if IsQBitSet(QBit(1180)) then -- NPC
        if IsQBitSet(QBit(1181)) then -- NPC
            if IsQBitSet(QBit(1182)) then -- NPC
                if IsQBitSet(QBit(1183)) then -- NPC
                    if IsQBitSet(QBit(1184)) then -- NPC
                        if not IsQBitSet(QBit(1185)) then -- NPC
                            evt.SetMessage("Hmm.\nNot all of the towers have been reset.\nThey are easy to find, if a bit long in getting to.\nThe easiest is in Whitecap to the west of us.")
                            return
                        end
                        evt.SetMessage("I knew my faith in you was well placed!\nYou have fixed a major problem in our kingdom, not to mention doing yourself a favor...It's now safe to fly above towns.\nIt is my pleasure to promote all warrior mages to master archers, and all honorary warrior mages to honorary master archers.\n")
                        AddValue(327915, 5)
                        ClearQBit(QBit(1146)) -- Reset all of the Dragon Towers at each town and return to Lord Stromgard in Castle Stromgard. - NPC
                        evt.ForPlayer(Players.All)
                        AddValue(Experience, 40000)
                        promoteMM6Party(1, 2, 1657, 1658) -- Warrior Mage / Honorary Warrior Mage
                        evt.SetNPCTopic(800, 1, 1407) -- Erik Von Stromgard topic 1: Master Archers
                        return
                    end
                end
            end
        end
    end
    evt.SetMessage("Hmm.\nNot all of the towers have been reset.\nThey are easy to find, if a bit long in getting to.\nThe easiest is in Whitecap to the west of us.")
end)

ReplaceGlobalEvent(1678, "Legacy event 1678", function()
    evt.SetMessage("<Loretta Fleise contacts you via a telepathy spell> Welcome to the Ceremony of the Sun.\nStand ye in the circle of life and face the north while no shadows stretch before thee.\nMeditate upon this truth:\n'Money is everything.\nI have no truer a friend than money...' <grinning> Just kidding.\nNow, close your eyes, and meditate as you stand at the center of the world and time for just this one, sublime moment... <long, silent pause>\nOpen your eyes.\nI hereby promote all druids to great druids and all non-druids to honorary druids. <Loretta fades away> ")
    promoteMM6Party(12, 13, 1651, 1652) -- Great Druid / Honorary Great Druid
    AddValue(131307, 2)
    evt.ForPlayer(Players.All)
    ClearQBit(QBit(1142)) -- Visit the Altar of the Sun in the circle of stones north of Silver Cove on an equinox or solstice (HINT: March 20th is an equinox). - NPC
    SetQBit(QBit(1197)) -- NPC
    AddValue(Experience, 15000)
    evt.SetNPCTopic(1090, 0, 0) -- Loretta Fleise topic 0 cleared
    evt.SetNPCTopic(799, 1, 1397) -- Loretta Fleise topic 1: Arch Druids
end)

ReplaceGlobalEvent(1679, "Legacy event 1679", function()
    evt.SetMessage("<Loretta Fleise contacts you via a telepathy spell> Welcome to the Ceremony of the Moon.\nStand ye before the altar of the Moon facing south.\nClose your eyes and meditate upon the Circle of Seasons and the Wheel of Life.\n<long, silent pause>\nOpen your eyes, my friends.\nI hereby promote all great druids to arch druids, and all honorary great druids to honorary arch druids.\n<Loretta fades away> ")
    promoteMM6Party(13, 15, 1653, 1654) -- Arch Druid / Honorary Arch Druid
    AddValue(327915, 5)
    evt.ForPlayer(Players.All)
    ClearQBit(QBit(1143)) -- Visit the Altar of the Moon in the Temple of the Moon at midnight of a full moon. - NPC
    SetQBit(QBit(1198)) -- NPC
    AddValue(Experience, 40000)
    evt.SetNPCTopic(1091, 0, 0) -- Loretta Fleise topic 0 cleared
    evt.SetNPCTopic(799, 1, 1399) -- Loretta Fleise topic 1: Arch Druids
end)

ReplaceGlobalEvent(1426, "Legacy event 1426", function()
    MM6.SellCollectorItem(
        2082,
        461,
        2000,
        0,
        "This one's a little dirty, but I suppose it will do.\nHere is the gold I promised you for it.\nThanks for your help!",
        "As part of the effort to rebuild the Temple here in Free Haven, I'm collecting temple gongs.\nIf you have any gongs, I'll pay you 2000 gold for each of them.")
end)

ReplaceGlobalEvent(1427, "Legacy event 1427", function()
    MM6.SellCollectorItem(
        2085,
        462,
        1000,
        5,
        "Hmm...",
        "I'm looking for bones to use in my rituals.\nI prefer bones from humans or humanoids, but I suppose I can make do with whatever you find.\nI'm willing to pay up to 1000 gold for bones that I can use.")
end)

ReplaceGlobalEvent(1428, "Legacy event 1428", function()
    MM6.SellCollectorItem(
        2090,
        463,
        5,
        0,
        "Thank you!",
        "Many people aren't able to visit the circus, so I'm collecting circus prizes to give away to those not able to visit it themselves.\nI'll buy lodestones for 5 gold each if you want to part with them.")
end)

ReplaceGlobalEvent(1429, "Legacy event 1429", function()
    MM6.SellCollectorItem(
        2091,
        464,
        10,
        0,
        "Thanks!\nDon't tell my daughter about this, I want to surprise her.\nHere's the 10 gold.",
        "My daughter wants to go to the circus, but we never have the time when the circus is near here.\nI'd love to give her a bunch of the pretty harpy feathers for her.\nI'll take any harpy feathers you have for 10 gold each.")
end)

ReplaceGlobalEvent(1430, "Legacy event 1430", function()
    MM6.SellCollectorItem(
        2092,
        465,
        1000,
        0,
        "Thanks!\nI can't wait to take this to Abdul's Desert Resort and see what I get!\nOh, here's the money I owe you.",
        "I've heard that you can get really nifty things from Abdul's Desert Resort if you pay with golden pyramids.\nI'm hoping to go there one day, and I want to stock up on the pyramids now.\nI'll take any golden pyramids you have for 1000 gold.")
end)

ReplaceGlobalEvent(1431, "Legacy event 1431", function()
    MM6.SellCollectorItem(
        2093,
        466,
        300,
        0,
        "My favorite!\nThanks for the wine!\nHere's 300 gold, it's well worth the price.",
        "My favorite wine is the stuff they give you for winning at the circus.")
end)

ReplaceGlobalEvent(1432, "Legacy event 1432", function()
    MM6.SellCollectorItem(
        2096,
        467,
        500,
        0,
        "I don't believe I have a tooth like this one yet, here's 500 gold.",
        "I have an incredible teeth collection, but I'm always looking for more.\nIf you find a tooth I don't have in my collection, I'll pay you 500 gold for it.")
end)

ReplaceGlobalEvent(1433, "Legacy event 1433", function()
    MM6.SellCollectorItem(
        2097,
        468,
        25,
        0,
        "Hurray!",
        "I have been to the circus three times, and I can't win anything.\nAll I really want are the nifty four leaf clovers they use as prizes there.\nI'll pay 25 gold for any four leaf clover you bring me.")
end)

ReplaceGlobalEvent(1434, "Legacy event 1434", function()
    MM6.SellCollectorItem(
        2102,
        469,
        500,
        0,
        "This will do nicely!\nThank you for the amber, here is the 500 gold I promised you.",
        "I've heard it's possible to find large chunks of amber in a series of caves north of Castle Ironfist.\nI never have the time to leave Free Haven, but I'd love to get my hands on some of that amber.\nI'll pay 500 gold for any piece of amber.")
end)

ReplaceGlobalEvent(1625, "Legacy event 1625", function()
    MM6.SellCollectorItem(
        2094,
        0,
        300,
        0,
        "Excellent specimen!",
        "I am a collector of rare and exotic creatures, and I make a living by selling some of these creatures as pets.\nCurrently, cobras are in great demand, and I don't have many cobras left to sell.\nTherefore, I'm willing to pay handsomely for any cobra eggs you might have.\nRemember, if you find any cobra eggs, I'll give you the best prices.")
end)

AppendGlobalEvent(1631, function(continueStep)
    if continueStep ~= nil then
        return
    end

    MM6.RemoveQuestFollowerUnless(1702, 893)
end)

AppendGlobalEvent(1634, function(continueStep)
    if continueStep ~= nil then
        return
    end

    MM6.AddQuestFollower(893)
end)

AppendGlobalEvent(1638, function(continueStep)
    if continueStep ~= nil then
        return
    end

    MM6.RemoveQuestFollower(978)
end)

AppendGlobalEvent(1640, function(continueStep)
    if continueStep ~= nil then
        return
    end

    MM6.AddQuestFollower(978)
end)

AppendGlobalEvent(1642, function(continueStep)
    if continueStep ~= nil then
        return
    end

    MM6.RemoveQuestFollower(980)
end)

AppendGlobalEvent(1645, function(continueStep)
    if continueStep ~= nil then
        return
    end

    MM6.RemoveQuestFollowerUnless(1705, 940)
end)

AppendGlobalEvent(1646, function(continueStep)
    if continueStep ~= nil then
        return
    end

    MM6.AddQuestFollower(940)
end)

ReplaceGlobalEvent(1331, "Legacy event 1331", function()
    evt.SimpleMessage("The palace is deadly dull, and everyone tells me what to do.\nBeing royalty isn't really worth much and no one will let me go outside the walls while my father is gone.\nI haven't left the castle for months!\nAnyway, you people look pretty important.\nWhat if you helped me sneak out and stay with you for a couple of days?\nI can't give you much in return yet, but I'll owe you a favor.\nSomeday I'll be able to repay you.\nI am the prince, after all!\nI'll go out the secret door and meet you outside.")
    MM6.StartNicolaiQuest()
end)

ReplaceGlobalEvent(1333, "Legacy event 1333", function(continueStep)
    if continueStep ~= nil then
        return
    end

    MM6.KidnapNicolai(true)
end)

ReplaceGlobalEvent(1334, "Legacy event 1334", function()
    evt.SimpleMessage("Um.\nHi. <smiling weakly> Would you believe I got lost and these nice people were taking me home?\nNo?\nI guess I wouldn't either.\nI suppose it's time we got back to the castle, then.")
    MM6.RecoverNicolaiAtCircus()
end)
