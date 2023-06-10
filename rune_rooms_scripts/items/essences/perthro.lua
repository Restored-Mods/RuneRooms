local PerthroEssence = {}

local PerthroItem = RuneRooms.Enums.ITEMS.PERTHRO_ESSENCE

---@param player EntityPlayer
function PerthroEssence:OnDamageCache(player)
    local numItems = player:GetCollectibleNum(PerthroItem)
    player.Damage = player.Damage + numItems * 0.5
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    PerthroEssence.OnDamageCache,
    CacheFlag.CACHE_DAMAGE
)