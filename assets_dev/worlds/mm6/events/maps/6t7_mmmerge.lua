-- MMMerge map supplement: Superior Temple of Baa door perception check.

ReplaceMapEvent(1, "Door", function()
    evt.ForPlayer(Players.Current)

    if evt.CheckSkill(const.Skills.Perception, const.SkillCheck.Novice, 8) then
        evt.SetDoorState(1, DoorAction.Close)
        return
    end

    evt.DamagePlayer(Players.Current, const.Damage.Fire, 50)
end, "Door")
