local RunePool = {}


function RunePool:PreGetCollectible(pool, decrease, seed)
    if not RuneRooms.Helpers:IsRuneRoom() then return end

    if ItemPoolType.POOL_TREASURE then
        local newItem = TSIL.CustomItemPools.GetCollectible(
            RuneRooms.Enums.ItemPool.RUNE_ROOM_POOL,
            decrease,
            seed
        )

        if newItem ~= CollectibleType.COLLECTIBLE_NULL then
            return newItem
        end
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_PRE_GET_COLLECTIBLE,
    RunePool.PreGetCollectible
)