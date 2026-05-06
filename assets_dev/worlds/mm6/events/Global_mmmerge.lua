-- MMMerge global supplement: MM6 quest follower behavior.

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
