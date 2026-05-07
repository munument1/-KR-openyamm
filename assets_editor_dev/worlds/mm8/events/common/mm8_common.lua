MM8 = MM8 or {}

MM8.SeerRecoverableItems = {
    {Item = 539, QBit = 199}, -- Ebonest
    {Item = 540, QBit = 200}, -- Sword of Whistlebone
    {Item = 541, QBit = 201}, -- Axe of Balthazar
    {Item = 603, QBit = 202}, -- Urn of Ashes
    {Item = 604, QBit = 203}, -- Nightshade Brazier
    {Item = 605, QBit = 204}, -- Dragon Leader's Egg
    {Item = 606, QBit = 205}, -- Heart of Fire
    {Item = 607, QBit = 206}, -- Heart of Water
    {Item = 608, QBit = 207}, -- Heart of Air
    {Item = 609, QBit = 208}, -- Heart of Earth
    {Item = 610, QBit = 209}, -- Conflux Key
    {Item = 611, QBit = 210}, -- Lost Book of Kehl
    {Item = 612, QBit = 211}, -- Sarcophagus of Korbu
    {Item = 617, QBit = 212}, -- Power Stone
    {Item = 618, QBit = 213}, -- Power Stone
    {Item = 619, QBit = 214}, -- Pirate Leader's Key
    {Item = 620, QBit = 215}, -- Prison Key
    {Item = 621, QBit = 216}, -- Prison Key
    {Item = 623, QBit = 217}, -- Gem of Restoration
    {Item = 626, QBit = 218}, -- Prophecies of the Sun
    {Item = 627, QBit = 219}, -- Remains of Korbu
    {Item = 629, QBit = 220}, -- Ring of Keys
    {Item = 741, QBit = 221}, -- Dadeross' Letter to Fellmoon
    {Item = 742, QBit = 222}, -- Blackmail Letter
    {Item = 662, QBit = 224}, -- Cannonball of Dominion
    {Item = 616, QBit = 245}, -- Anointed Herb Potion
    {Item = 615, QBit = 246}, -- Drum of Victory
    {Item = 637, QBit = 247}, -- Bone of Doom
    {Item = 614, QBit = 248}, -- Vial of Grave Dirt
    {Item = 613, QBit = 249}, -- Puzzle Box
    {Item = 602, QBit = 282}, -- False Report
    {Item = 516, QBit = 283}, -- Eclipse
}

function MM8.RecoverLostItem()
    support.tryRecoverLostItem(MM8.SeerRecoverableItems)
end

RegisterGlobalEvent(705, "I lost it", function()
    MM8.RecoverLostItem()
end)
