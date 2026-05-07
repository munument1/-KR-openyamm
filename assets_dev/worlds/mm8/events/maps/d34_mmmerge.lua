-- MMMerge supplement: leaving the submarine pen does not require the pirate key.

ReplaceMapEvent(451, "Enter the Submarine", function()
    evt.MoveToMap(7097, -1117, -639, 1536, 0, 0, 0, 1, "d06.blv")
end, "Enter the Submarine")
