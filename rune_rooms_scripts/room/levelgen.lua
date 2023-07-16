local LevelGen = {}

--Chance of rune room to replace a vault
local RUNE_ROOM_SPAWN_CHANCE = 0.2

local hasLoadedRuneRooms = false


local function GetRuneRoomData(roomID)
    Isaac.ExecuteCommand("goto s.chest." .. roomID)

    return TSIL.Rooms.GetRoomData(GridRooms.ROOM_DEBUG_IDX)
end


local function LoadRuneRooms()
    local level = Game():GetLevel()
    local currentRoomIdx = level:GetCurrentRoomIndex()

    for _, roomID in ipairs(RuneRooms.Constants.RUNE_ROOMS_IDS) do
        local data = GetRuneRoomData(roomID)
        RuneRooms.Constants.RUNE_ROOMS_DATAS[#RuneRooms.Constants.RUNE_ROOMS_DATAS+1] = data
    end

    Game():StartRoomTransition(currentRoomIdx, Direction.NO_DIRECTION, RoomTransitionAnim.FADE)

    hasLoadedRuneRooms = true

    Isaac.ExecuteCommand("restart")
end


---@return integer?
local function GetVaultRoom()
    local level = Game():GetLevel()
    local rooms = level:GetRooms()

    for i = 0, rooms.Size-1, 1 do
        local room = rooms:Get(i)
        if room.Data.Type == RoomType.ROOM_CHEST then
            return room.GridIndex
        end
    end

    return nil
end


---@param rng RNG
local function GetRandomRuneRoomData(rng)
    local newData = TSIL.Random.GetRandomElementsFromTable(RuneRooms.Constants.RUNE_ROOMS_DATAS, 1, rng)[1]

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
    if not hasLoadedRuneRooms then
        LoadRuneRooms()
        return
    end

    local rng = RuneRooms.Helpers:GetStageRNG()

    if rng:RandomFloat() >= RUNE_ROOM_SPAWN_CHANCE then return end

    local vaultRoomIndex = GetVaultRoom()
    if not vaultRoomIndex then return end

    if RuneRooms.Helpers:IsRuneRoom(vaultRoomIndex) then return end

    local newData = GetRandomRuneRoomData(rng)

    ReplaceRoom(vaultRoomIndex, newData)

    RuneRooms.Helpers:RunInNRenderFrames(RuneRooms.ReplaceRuneDoorSprites, 20)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_LEVEL_REORDERED,
    LevelGen.OnNewLevel
)