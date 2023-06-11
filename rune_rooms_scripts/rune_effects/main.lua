TSIL.Utils.Tables.ForEach(RuneRooms.Constants.RUNE_NAMES, function (_, name)
    include("rune_rooms_scripts.rune_effects.negative." .. name)
    include("rune_rooms_scripts.rune_effects.positive." .. name)
end)


---Returns the rune effect for the current floor
---@return RuneEffect
function RuneRooms:GetRuneEffectForFloor()
    local rng = RuneRooms.Helpers:GetStageRNG()

    return TSIL.Random.GetRandomElementsFromTable(RuneRooms.Enums.RuneEffect, 1, rng)[1]
end