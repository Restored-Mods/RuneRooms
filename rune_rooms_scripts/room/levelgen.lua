local LevelGen = {}

--Chance of rune room to replace a vault
local RUNE_ROOM_SPAWN_CHANCE = 1


---@return integer?
local function GetVaultRoom()
    local level = Game():GetLevel()
    local rooms = level:GetRooms()

    for i = 0, rooms.Size-1, 1 do
        local room = rooms:Get(i)
        if room.Data.Type == RoomType.ROOM_TREASURE then
            return room.GridIndex
        end
    end

    return nil
end


---@param rng RNG
local function GetRandomRuneRoomData(rng)
    local chosenRoomID = TSIL.Random.GetRandomElementsFromTable(RuneRooms.Constants.RUNE_ROOMS_IDS, 1, rng)[1]

    Isaac.ExecuteCommand("goto s.chest." .. chosenRoomID)

    local level = Game():GetLevel()
    local currentRoomIdx = level:GetCurrentRoomIndex()

    local newData = TSIL.Rooms.GetRoomData(GridRooms.ROOM_DEBUG_IDX)

    Game():StartRoomTransition(currentRoomIdx, Direction.NO_DIRECTION, RoomTransitionAnim.FADE)

    return newData
end


---@param index integer
---@param roomData RoomConfig_Room
local function ReplaceRoom(index, roomData)
    local level = Game():GetLevel()

    local writeableRoom = level:GetRoomByIdx(index, -1)
    writeableRoom.Data = roomData
end


function LevelGen:OnNewLevel()
    local rng = RuneRooms.Helpers:GetStageRNG()

    if rng:RandomFloat() >= RUNE_ROOM_SPAWN_CHANCE then return end

    local vaultRoomIndex = GetVaultRoom()
    if not vaultRoomIndex then return end

    if RuneRooms.Helpers:IsRuneRoom(vaultRoomIndex) then return end

    local newData = GetRandomRuneRoomData(rng)

    ReplaceRoom(vaultRoomIndex, newData)

    RuneRooms.Helpers:RunInNRenderFrames(RuneRooms.ReplaceRuneDoorSprites, 2)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_LEVEL_REORDERED,
    LevelGen.OnNewLevel
)