local EhwazEssence = {}

local EhwazItem = RuneRooms.Enums.Item.EHWAZ_ESSENCE

---@param player EntityPlayer
function EhwazEssence:OnShotSpeedCache(player)
    local numItems = player:GetCollectibleNum(EhwazItem)
    player.ShotSpeed = player.ShotSpeed + numItems * 0.3
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    EhwazEssence.OnShotSpeedCache,
    CacheFlag.CACHE_SHOTSPEED
)