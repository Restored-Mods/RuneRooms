local HagalazPositive = {}


---@param gridEntity GridEntity
---@return boolean
local function CanBeDestroyed(gridEntity)
    if gridEntity:ToRock() then
        return true
    end

    if gridEntity:ToPoop() then
        return true
    end

    return false
end


function HagalazPositive:OnNewRoom()
    if not RuneRooms:IsPositiveEffectActive(RuneRooms.Enums.RuneEffect.HAGALAZ) then return end

    local gridEntities = TSIL.GridEntities.GetGridEntities()
    local rocks = TSIL.Utils.Tables.Filter(gridEntities, function (_, gridEntity)
        return CanBeDestroyed(gridEntity)
    end)
    TSIL.Utils.Tables.ForEach(rocks, function (_, rock)
        rock:Destroy(true)
    end)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED,
    HagalazPositive.OnNewRoom
)