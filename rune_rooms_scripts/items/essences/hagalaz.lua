local HagalazEssence = {}

local HagalazItem = RuneRooms.Enums.ITEMS.HAGALAZ_ESSENCE

---@param player EntityPlayer
function HagalazEssence:OnRangeCache(player)
    local numItems = player:GetCollectibleNum(HagalazItem)
    --TODO: Add the range correctly
    player.TearRange = player.TearRange + numItems * 3
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    HagalazEssence.OnRangeCache,
    CacheFlag.CACHE_RANGE
)