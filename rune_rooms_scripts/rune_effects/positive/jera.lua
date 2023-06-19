local JeraPositive = {}


---@param player EntityPlayer
function JeraPositive:OnPeffectUpdate(player)
    if not RuneRooms:IsPositiveEffectActive(RuneRooms.Enums.RuneEffect.JERA) then return end

    RuneRooms.Libs.HiddenItemManager:CheckStack(
        player,
        CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW,
        1
    )
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    JeraPositive.OnPeffectUpdate
)