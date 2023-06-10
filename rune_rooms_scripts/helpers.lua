RuneRooms.Helpers = {}


---Helper function to check if the players are currently in a rune room
---@return boolean
function RuneRooms.Helpers:IsInRuneRoom()
    local roomDescriptor = TSIL.Rooms.GetRoomDescriptor()
    local roomData = roomDescriptor.Data

    if roomData.Type ~= RoomType.ROOM_DICE then return false end
    return TSIL.Utils.Tables.IsIn(RuneRooms.Constants.RUNE_ROOMS_IDS, roomData.Variant)
end