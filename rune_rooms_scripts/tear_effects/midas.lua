local MidasTears = {}

--TODO: Make it work with lasers
--TODO: Make it work with knifes
--TODO: Make it work with ludo

local MIDAS_FREEZE_DURATION = 30 * 4 -- 4 seconds at 30fps
local GOLDEN_COLOR = Color(0.9, 0.8, 0, 1, 0.8, 0.7, 0)


---@param tear EntityTear
local function MakeTearGolden(tear)
    tear:GetSprite().Color = GOLDEN_COLOR
end


---@param tear EntityTear
function MidasTears:OnMidasEffectAdded(tear)
    MakeTearGolden(tear)
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallback.POST_CUSTOM_TEAR_FLAG_ADDED,
    MidasTears.OnMidasEffectAdded,
    RuneRooms.Enums.TearFlag.MIDAS
)


---@param tear EntityTear
function MidasTears:OnTearInitLate(tear)
    if not RuneRooms:HasCustomTearFlag(tear, RuneRooms.Enums.TearFlag.MIDAS) then return end

    MakeTearGolden(tear)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_TEAR_INIT_LATE,
    MidasTears.OnTearInitLate
)


---@param tookDamage Entity
---@param source EntityRef
function MidasTears:OnEntityDamage(tookDamage, _, _, source)
    if not tookDamage:IsActiveEnemy(false) then return end
    if not tookDamage:IsVulnerableEnemy() then return end
    if tookDamage:IsInvincible() then return end

    if source.Type ~= EntityType.ENTITY_TEAR then return end

    local tear = source.Entity:ToTear()
    if not RuneRooms:HasCustomTearFlag(tear, RuneRooms.Enums.TearFlag.MIDAS) then return end

    tookDamage:AddMidasFreeze(source, MIDAS_FREEZE_DURATION)
end
RuneRooms:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    MidasTears.OnEntityDamage
)