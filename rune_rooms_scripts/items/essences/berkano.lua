local BerkanoEssence = {}

local BerkanoItem = RuneRooms.Enums.Item.BERKANO_ESSENCE

---@param player EntityPlayer
function BerkanoEssence:OnFireDelayCache(player)
    local numItems = player:GetCollectibleNum(BerkanoItem)
    --TODO: Add the tears correctly
    player.MaxFireDelay = player.MaxFireDelay - numItems * 0.3
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    BerkanoEssence.OnFireDelayCache,
    CacheFlag.CACHE_FIREDELAY
)