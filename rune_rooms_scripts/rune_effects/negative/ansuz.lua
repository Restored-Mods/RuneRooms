local AnsuzNegative = {}


function AnsuzNegative:OnAnsuzPositiveEffect()
    local player = Isaac.GetPlayer()

    ---@diagnostic disable-next-line: param-type-mismatch
    player:UsePill(PillEffect.PILLEFFECT_AMNESIA, PillColor.PILL_NULL, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD | UseFlag.USE_NOCOSTUME)
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallbacks.POST_GAIN_NEGATIVE_RUNE_EFFECT,
    AnsuzNegative.OnAnsuzPositiveEffect,
    RuneRooms.Enums.RuneEffect.ANSUZ
)