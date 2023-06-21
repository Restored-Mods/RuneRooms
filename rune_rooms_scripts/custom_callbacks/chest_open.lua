local ChestOpenedCallback = {}


---@param chest EntityPickup
local function CheckIfOpened(chest)
    local subtype = chest.SubType
    local previousSubtype = TSIL.Entities.GetEntityData(
        RuneRooms,
        chest,
        "PreviousSubtype"
    )

    if not previousSubtype then
        previousSubtype = subtype
    end

    if subtype == ChestSubType.CHEST_OPENED and previousSubtype ~= ChestSubType.CHEST_OPENED then
        Isaac.RunCallbackWithParam(
            RuneRooms.Enums.CustomCallback.POST_CHEST_OPENED,
            chest.Variant,
            chest
        )
    end

    TSIL.Entities.SetEntityData(
        RuneRooms,
        chest,
        "PreviousSubtype",
        subtype
    )
end


---@param pickup EntityPickup
function ChestOpenedCallback:OnPickupUpdate(pickup)
    if not TSIL.Pickups.IsChest(pickup) then return end

    CheckIfOpened(pickup)
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_PICKUP_UPDATE,
    ChestOpenedCallback.OnPickupUpdate
)