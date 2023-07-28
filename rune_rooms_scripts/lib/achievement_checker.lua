local AchievementChecker = {}

local trinketPerAchievement = {}
for _, id in pairs(RuneRooms.Constants.TRINKET_PER_ACHIEVEMENT) do
    trinketPerAchievement[id] = true
end

local function RemoveAchievementTrinkets()
    local itemPool = Game():GetItemPool()

    for trinket, _ in pairs(trinketPerAchievement) do
        itemPool:RemoveTrinket(trinket)
    end
end

RuneRooms:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
    RemoveAchievementTrinkets()
end)

local antiRecursion

RuneRooms:AddCallback(ModCallbacks.MC_GET_TRINKET, function (_, trinket)
    if trinketPerAchievement[trinket] and not antiRecursion then
        antiRecursion = true

        RemoveAchievementTrinkets()

        local itemPool = Game():GetItemPool()
        local new = itemPool:GetTrinket()

        antiRecursion = false

        return new
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