local RuneRoomPool = {}

---@type CustomItemPoolCollectible[]
local RUNE_RUNE_POOL_ITEMS = {
    {Collectible=CollectibleType.COLLECTIBLE_RUNE_BAG,          Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_CLEAR_RUNE,        Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_CRYSTAL_BALL,      Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_GLASS_CANNON,      Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_JAR_OF_WISPS,      Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_EVERYTHING_JAR,    Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_ANGELIC_PRISM,     Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_SHARD_OF_GLASS,    Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_CRACKED_ORB,       Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_GLASS_EYE,         Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_ISAACS_TEARS,      Weight=1, DecreaseBy=1, RemoveOn=0.1},
    {Collectible=CollectibleType.COLLECTIBLE_SACRED_ORB,        Weight=1, DecreaseBy=1, RemoveOn=0.1},
}

RuneRooms.Enums.ItemPool.RUNE_ROOM_POOL = TSIL.CustomItemPools.RegisterCustomItemPool(RUNE_RUNE_POOL_ITEMS)


function RuneRoomPool:OnGameStart()
    local collectibles = TSIL.CustomItemPools.GetCollectibleEntriesInItemPool(RuneRooms.Enums.ItemPool.RUNE_ROOM_POOL)

    local itemConfig = Isaac.GetItemConfig()

    for _, collectibleEntry in ipairs(collectibles) do
        local collectible = itemConfig:GetCollectible(collectibleEntry.Collectible)

        if not collectible:IsAvailable() then
            TSIL.CustomItemPools.RemoveCollectible(
                RuneRooms.Enums.ItemPool.RUNE_ROOM_POOL,
                collectible.ID
            )
        end
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    RuneRoomPool.OnGameStart
)