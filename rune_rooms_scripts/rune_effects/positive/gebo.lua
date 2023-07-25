local GeboPositive = {}

local SLOT_SPAWN_CHANCE = 0.4
local POSSIBLE_SLOTS = {
    TSIL.Enums.SlotVariant.SLOT_MACHINE,
	TSIL.Enums.SlotVariant.BLOOD_DONATION_MACHINE,
	TSIL.Enums.SlotVariant.FORTUNE_TELLING_MACHINE,
	TSIL.Enums.SlotVariant.BEGGAR,
	TSIL.Enums.SlotVariant.DEVIL_BEGGAR,
	TSIL.Enums.SlotVariant.SHELL_GAME,
	TSIL.Enums.SlotVariant.KEY_BEGGAR,
	TSIL.Enums.SlotVariant.DONATION_MACHINE,
	TSIL.Enums.SlotVariant.BOMB_BEGGAR,
	TSIL.Enums.SlotVariant.RESTOCK_MACHINE,
	TSIL.Enums.SlotVariant.GREED_DONATION_MACHINE,
	TSIL.Enums.SlotVariant.DRESSING_TABLE,
	TSIL.Enums.SlotVariant.BATTERY_BEGGAR,
	TSIL.Enums.SlotVariant.HELL_GAME,
	TSIL.Enums.SlotVariant.CRANE_GAME,
	TSIL.Enums.SlotVariant.CONFESSIONAL,
	TSIL.Enums.SlotVariant.ROTTEN_BEGGAR,
}
local ACHIEVEMENT_PER_SLOT = {
    [TSIL.Enums.SlotVariant.HELL_GAME] = RuneRooms.Enums.Achievement.HELL_GAME,
	[TSIL.Enums.SlotVariant.CRANE_GAME] = RuneRooms.Enums.Achievement.CRANE_GAME,
	[TSIL.Enums.SlotVariant.CONFESSIONAL] = RuneRooms.Enums.Achievement.CONFESSIONAL,
	[TSIL.Enums.SlotVariant.ROTTEN_BEGGAR] = RuneRooms.Enums.Achievement.ROTTEN_BEGGAR,
}
---@type table<SlotVariant, fun(): boolean>
local CAN_SPAWN_PER_SLOT = {}


---Adds a slot that may spawn with the positive Gebo rune room effect
---@param slotVariant SlotVariant | integer
---@param canSpawn fun(): boolean @ Default: Can always spawn
function RuneRooms.API:AddPossibleSlotToSpawn(slotVariant, canSpawn)
    POSSIBLE_SLOTS[#POSSIBLE_SLOTS+1] = slotVariant
    CAN_SPAWN_PER_SLOT[slotVariant] = canSpawn
end


TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.ROOMS_SPAWNED_SLOT,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)


function GeboPositive:OnNewRoom()
    if not RuneRooms:IsPositiveEffectActive(RuneRooms.Enums.RuneEffect.GEBO) then return end

    local roomDesc = TSIL.Rooms.GetRoomDescriptor()
    local roomData = roomDesc.Data

    if roomData.Type ~= RoomType.ROOM_DEFAULT then return end

    local roomIndex = roomDesc.ListIndex
    local roomsSpawnedSlot = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.ROOMS_SPAWNED_SLOT
    )

    if roomsSpawnedSlot[roomIndex] then return end
    roomsSpawnedSlot[roomIndex] = true

    local rng = TSIL.RNG.NewRNG(roomDesc.SpawnSeed)

    if rng:RandomFloat() >= SLOT_SPAWN_CHANCE then return end

    local slotsToSpawn = TSIL.Utils.Tables.Filter(POSSIBLE_SLOTS, function (_, slotVariant)
        local achievement = ACHIEVEMENT_PER_SLOT[slotVariant]
        if not achievement then
            local canSpawn = CAN_SPAWN_PER_SLOT[slotVariant]
            if not canSpawn then
                return true
            end

            return canSpawn()
        end

        return RuneRooms.Libs.AchievementChecker:IsAchievementUnlocked(achievement)
    end)
    local slotVariant = TSIL.Random.GetRandomElementsFromTable(slotsToSpawn, 1, rng)[1]

    local room = Game():GetRoom()
    local centerPos = room:GetCenterPos()
    local freePos = room:FindFreePickupSpawnPosition(centerPos, 0, true)

    TSIL.Entities.Spawn(
        EntityType.ENTITY_SLOT,
        slotVariant,
        0,
        freePos
    )
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    GeboPositive.OnNewRoom
)