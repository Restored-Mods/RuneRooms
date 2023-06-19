local AchievementChecker = {}


RuneRooms:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
    local itemPool = Game():GetItemPool()

    for trinket, _ in pairs(RuneRooms.Constants.TRINKET_PER_ACHIEVEMENT) do
        itemPool:RemoveTrinket(trinket)
    end
end)


RuneRooms:AddCallback(ModCallbacks.MC_GET_TRINKET, function (_, trinket)
    if RuneRooms.Constants.TRINKET_PER_ACHIEVEMENT[trinket] then
        local itemPool = Game():GetItemPool()
        return itemPool:GetTrinket()
    end
end)


---Helper function to check if a vanilla achievement is unlocked.
---@param achievement Achievement
---@return boolean
function AchievementChecker:IsAchievementUnlocked(achievement)
    local trinket = RuneRooms.Constants.TRINKET_PER_ACHIEVEMENT[achievement]

    local itemConfig = Isaac.GetItemConfig()
    local trinketInfo = itemConfig:GetTrinket(trinket)

    return trinketInfo:IsAvailable()
end


RuneRooms.Libs.AchievementChecker = AchievementChecker