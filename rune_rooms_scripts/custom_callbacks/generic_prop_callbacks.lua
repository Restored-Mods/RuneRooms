local GenericPropCallbacks = {}


---@param entity Entity
local function OnGenericPropInit(entity)
    local hasInitialized = TSIL.Entities.GetEntityData(
        RuneRooms,
        entity,
        "IsGenericPropInitialized"
    )
    if hasInitialized then return end

    TSIL.Entities.SetEntityData(
        RuneRooms,
        entity,
        "IsGenericPropInitialized",
        true
    )

    Isaac.RunCallbackWithParam(
        RuneRooms.Enums.CustomCallback.POST_GENERIC_PROP_INIT,
        entity.Variant,
        entity
    )
end


function GenericPropCallbacks:OnNewRoom()
    local entities = Isaac.FindByType(EntityType.ENTITY_GENERIC_PROP)

    TSIL.Utils.Tables.ForEach(entities, function (_, entity)
        OnGenericPropInit(entity)
    end)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED,
    GenericPropCallbacks.OnNewRoom
)


function GenericPropCallbacks:OnUpdate()
    local entities = Isaac.FindByType(EntityType.ENTITY_GENERIC_PROP)

    TSIL.Utils.Tables.ForEach(entities, function (_, entity)
        if entity.FrameCount == 1 then
            OnGenericPropInit(entity)
        end

        Isaac.RunCallbackWithParam(
            RuneRooms.Enums.CustomCallback.POST_GENERIC_PROP_UPDATE,
            entity.Variant,
            entity
        )
    end)
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    GenericPropCallbacks.OnUpdate
)