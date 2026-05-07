-- MMMerge global supplement: MM6 quest follower behavior.

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

ReplaceGlobalEvent(1426, "Legacy event 1426", function()
    MM6.SellCollectorItem(2082, 461, 2000, 0, "This one's a little dirty, but I suppose it will do.\nHere is the gold I promised you for it.\nThanks for your help!", "As part of the effort to rebuild the Temple here in Free Haven, I'm collecting temple gongs.\nIf you have any gongs, I'll pay you 2000 gold for each of them.")
end)

ReplaceGlobalEvent(1427, "Legacy event 1427", function()
    MM6.SellCollectorItem(2085, 462, 1000, 5, "Hmm...", "I'm looking for bones to use in my rituals.\nI prefer bones from humans or humanoids, but I suppose I can make do with whatever you find.\nI'm willing to pay up to 1000 gold for bones that I can use.")
end)

ReplaceGlobalEvent(1428, "Legacy event 1428", function()
    MM6.SellCollectorItem(2090, 463, 5, 0, "Thank you!", "Many people aren't able to visit the circus, so I'm collecting circus prizes to give away to those not able to visit it themselves.\nI'll buy lodestones for 5 gold each if you want to part with them.")
end)

ReplaceGlobalEvent(1429, "Legacy event 1429", function()
    MM6.SellCollectorItem(2091, 464, 10, 0, "Thanks!\nDon't tell my daughter about this, I want to surprise her.\nHere's the 10 gold.", "My daughter wants to go to the circus, but we never have the time when the circus is near here.\nI'd love to give her a bunch of the pretty harpy feathers for her.\nI'll take any harpy feathers you have for 10 gold each.")
end)

ReplaceGlobalEvent(1430, "Legacy event 1430", function()
    MM6.SellCollectorItem(2092, 465, 1000, 0, "Thanks!\nI can't wait to take this to Abdul's Desert Resort and see what I get!\nOh, here's the money I owe you.", "I've heard that you can get really nifty things from Abdul's Desert Resort if you pay with golden pyramids.\nI'm hoping to go there one day, and I want to stock up on the pyramids now.\nI'll take any golden pyramids you have for 1000 gold.")
end)

ReplaceGlobalEvent(1431, "Legacy event 1431", function()
    MM6.SellCollectorItem(2093, 466, 300, 0, "My favorite!\nThanks for the wine!\nHere's 300 gold, it's well worth the price.", "My favorite wine is the stuff they give you for winning at the circus.")
end)

ReplaceGlobalEvent(1432, "Legacy event 1432", function()
    MM6.SellCollectorItem(2096, 467, 500, 0, "I don't believe I have a tooth like this one yet, here's 500 gold.", "I have an incredible teeth collection, but I'm always looking for more.\nIf you find a tooth I don't have in my collection, I'll pay you 500 gold for it.")
end)

ReplaceGlobalEvent(1433, "Legacy event 1433", function()
    MM6.SellCollectorItem(2097, 468, 25, 0, "Hurray!", "I have been to the circus three times, and I can't win anything.\nAll I really want are the nifty four leaf clovers they use as prizes there.\nI'll pay 25 gold for any four leaf clover you bring me.")
end)

ReplaceGlobalEvent(1434, "Legacy event 1434", function()
    MM6.SellCollectorItem(2102, 469, 500, 0, "This will do nicely!\nThank you for the amber, here is the 500 gold I promised you.", "I've heard it's possible to find large chunks of amber in a series of caves north of Castle Ironfist.\nI never have the time to leave Free Haven, but I'd love to get my hands on some of that amber.\nI'll pay 500 gold for any piece of amber.")
end)

ReplaceGlobalEvent(1625, "Legacy event 1625", function()
    MM6.SellCollectorItem(2094, 0, 300, 0, "Excellent specimen!", "I am a collector of rare and exotic creatures, and I make a living by selling some of these creatures as pets.\nCurrently, cobras are in great demand, and I don't have many cobras left to sell.\nTherefore, I'm willing to pay handsomely for any cobra eggs you might have.\nRemember, if you find any cobra eggs, I'll give you the best prices.")
end)

AppendGlobalEvent(1631, function(continueStep)
    if continueStep ~= nil then return end
    MM6.RemoveQuestFollowerUnless(1702, 893)
end)

AppendGlobalEvent(1634, function(continueStep)
    if continueStep ~= nil then return end
    MM6.AddQuestFollower(893)
end)

AppendGlobalEvent(1638, function(continueStep)
    if continueStep ~= nil then return end
    MM6.RemoveQuestFollower(978)
end)

AppendGlobalEvent(1640, function(continueStep)
    if continueStep ~= nil then return end
    MM6.AddQuestFollower(978)
end)

AppendGlobalEvent(1642, function(continueStep)
    if continueStep ~= nil then return end
    MM6.RemoveQuestFollower(980)
end)

AppendGlobalEvent(1645, function(continueStep)
    if continueStep ~= nil then return end
    MM6.RemoveQuestFollowerUnless(1705, 940)
end)

AppendGlobalEvent(1646, function(continueStep)
    if continueStep ~= nil then return end
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
