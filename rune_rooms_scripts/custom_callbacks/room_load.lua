local RoomLoad = {}

local HasLoadedRooms = false
local NeedsToRestart = false

function RoomLoad:OnGameStart()
    if HasLoadedRooms then return end
    HasLoadedRooms = true

    local level = Game():GetLevel()
    local currentRoomIdx = level:GetCurrentRoomIndex()

    Isaac.RunCallback(RuneRooms.Enums.CustomCallback.ROOM_LOAD)

    NeedsToRestart = true
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