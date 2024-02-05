local RoomLoad = {}

local HasLoadedRooms = false
local NeedsToRestart = false

if not REPENTOGON then
    ---@param isContinue boolean
    function RoomLoad:OnGameStart(isContinue)
        if HasLoadedRooms then return end
        HasLoadedRooms = true

        local level = Game():GetLevel()
        local currentRoomIdx = level:GetCurrentRoomIndex()

        Isaac.RunCallback(RuneRooms.Enums.CustomCallback.ROOM_LOAD)

        NeedsToRestart = not isContinue
        Game():StartRoomTransition(currentRoomIdx, Direction.NO_DIRECTION, RoomTransitionAnim.FADE)
    end
    RuneRooms:AddPriorityCallback(
        ModCallbacks.MC_POST_GAME_STARTED,
        CallbackPriority.IMPORTANT,
        RoomLoad.OnGameStart
    )


    function RoomLoad:OnNewRoom()
        if NeedsToRestart then
            NeedsToRestart = false
            Isaac.ExecuteCommand("restart")
        end
    end
    RuneRooms:AddPriorityCallback(
        ModCallbacks.MC_POST_NEW_ROOM,
        CallbackPriority.IMPORTANT,
        RoomLoad.OnNewRoom
    )
end