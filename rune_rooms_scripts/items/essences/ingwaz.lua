local IngwazEssence = {}

local IngwazItem = RuneRooms.Enums.Item.INGWAZ_ESSENCE


function IngwazEssence:PreEntitySpawn(type, variant, _, _, _, _, seed)
    if not TSIL.Players.DoesAnyPlayerHasItem(IngwazItem) then return end

    if type ~= EntityType.ENTITY_PICKUP then return end
    if variant ~= PickupVariant.PICKUP_LOCKEDCHEST then return end

    return {
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_ETERNALCHEST,
        ChestSubType.CHEST_CLOSED,
        seed
    }
end
RuneRooms:AddCallback(
    ModCallbacks.MC_PRE_ENTITY_SPAWN,
    IngwazEssence.PreEntitySpawn
)