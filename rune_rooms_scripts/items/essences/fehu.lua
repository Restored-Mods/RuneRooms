local FehuEssence = {}

local FehuItem = RuneRooms.Enums.Item.FEHU_ESSENCE

---@param player EntityPlayer
function FehuEssence:OnLuckCache(player)
    local numItems = player:GetCollectibleNum(FehuItem)
    player.Luck = player.Luck + numItems * 1
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    FehuEssence.OnLuckCache,
    CacheFlag.CACHE_LUCK
)