local AnsuzPositive = {}


---@param player EntityPlayer
function AnsuzPositive:OnPeffectUpdate(player)
    if not RuneRooms:IsPositiveEffectActive(RuneRooms.Enums.RuneEffect.ANSUZ) then return end

    RuneRooms.Libs.HiddenItemManager:CheckStack(
        player,
        CollectibleType.COLLECTIBLE_MERCURIUS,
        1
    )
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    AnsuzPositive.OnPeffectUpdate
)