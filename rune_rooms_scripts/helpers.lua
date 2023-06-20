RuneRooms.Helpers = {}


---Helper function to check if a room is a rune room
---@param gridIndex integer? @Default: current room index
---@return boolean
function RuneRooms.Helpers:IsRuneRoom(gridIndex)
    local roomData = TSIL.Rooms.GetRoomData(gridIndex)

    if not roomData then return false end

    if roomData.Type ~= RoomType.ROOM_CHEST then return false end
    return TSIL.Utils.Tables.IsIn(RuneRooms.Constants.RUNE_ROOMS_IDS, roomData.Variant)
end


do
    local scheduledFunctions = {}

    ---Runs a function in a given number of render frames
    ---@param funct function
    ---@param frames integer
    function RuneRooms.Helpers:RunInNRenderFrames(funct, frames)
        scheduledFunctions[#scheduledFunctions+1] = {
            funct = funct,
            frames = frames
        }
    end

    RuneRooms:AddCallback(ModCallbacks.MC_POST_RENDER, function ()
        local temp = {}

        TSIL.Utils.Tables.ForEach(scheduledFunctions, function (_, scheduledFunction)
            scheduledFunction.frames = scheduledFunction.frames - 1

            if scheduledFunction.frames <= 0 then
                scheduledFunction.funct()
            else
                temp[#temp+1] = scheduledFunction
            end
        end)

        scheduledFunctions = temp
    end)

    RuneRooms:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function ()
        scheduledFunctions = {}
    end)
end


---Returns an rng object that's unique for each stage.
---@return RNG
function RuneRooms.Helpers:GetStageRNG()
    local level = Game():GetLevel()
    local seeds = Game():GetSeeds()
    local stageSeed = seeds:GetStageSeed(level:GetStage())

    return TSIL.RNG.NewRNG(stageSeed)
end


---Returns an rng object that's unique for each room in the level.
---@param gridIndex integer? @Default: current room index
---@return RNG
function RuneRooms.Helpers:GetRoomRNG(gridIndex)
    local stageRNG = RuneRooms.Helpers:GetStageRNG()

    local roomDescriptor = TSIL.Rooms.GetRoomDescriptor(gridIndex)
    local listIndex = roomDescriptor.ListIndex

    for _ = 1, listIndex, 1 do
        stageRNG:Next()
    end

    return TSIL.RNG.NewRNG(stageRNG:Next())
end


---Returns an unique index for custom "grid entities". This assumes that no two
---"grid entities" can occupy the same grid index.
---@param entity Entity
---@return string
function RuneRooms.Helpers:GetCustomGridIndex(entity)
    local room = Game():GetRoom()
    local gridIndex = room:GetGridIndex(entity.Position)

    local roomDesc = TSIL.Rooms.GetRoomDescriptor()
    local roomListIndex = roomDesc.ListIndex

    return roomListIndex .. "-" .. gridIndex
end