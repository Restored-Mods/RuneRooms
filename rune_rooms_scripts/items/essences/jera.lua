local JeraEssence = {}

local JeraItem = RuneRooms.Enums.ITEMS.JERA_ESSENCE

---@param player EntityPlayer
function JeraEssence:OnSpeedCache(player)
    local numItems = player:GetCollectibleNum(JeraItem)
    player.MoveSpeed = player.MoveSpeed + numItems * 0.15
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    JeraEssence.OnSpeedCache,
    CacheFlag.CACHE_SPEED
)