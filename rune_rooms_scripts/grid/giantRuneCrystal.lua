local GiantRuneCrystal = {}

local RUNE_SYMBOL_SPRITESHEET = "gfx/grid/rune_symbol_"


TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.GIANT_CRYSTAL_DATA,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)
TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.INITIALIZED_GIANT_CRYSTALS,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param giantCrystal Entity
local function GetGiantCrystalData(giantCrystal)
    local crystalsData = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.GIANT_CRYSTAL_DATA
    )
    local crystalIndex = RuneRooms.Helpers:GetCustomGridIndex(giantCrystal)

    if not crystalsData[crystalIndex] then
        crystalsData[crystalIndex] = {
            breakState = 1,
            activated = false
        }
    end

    return crystalsData[crystalIndex]
end


---@param giantCrystal Entity
local function IsGiantCrystalInitialized(giantCrystal)
    local ptrHash = GetPtrHash(giantCrystal)
    local initializedGiantCrystals = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.INITIALIZED_GIANT_CRYSTALS
    )
    local isInitialized = initializedGiantCrystals[ptrHash] ~= nil
    initializedGiantCrystals[ptrHash] = true

    return isInitialized
end


---@param giantCrystal Entity
function RuneRooms:DealDamageToGiantCrystal(giantCrystal)
    local data = GetGiantCrystalData(giantCrystal)
    if data.activated then return end
    if data.breakState == 5 then return end
    data.breakState = data.breakState + 1

    local sprite = giantCrystal:GetSprite()

    if data.breakState ~= 5 then
        local frame = sprite:GetFrame()
        sprite:Play("State" .. data.breakState .. "Symbol", true)
        sprite:SetFrame(frame)

        local runeEffect = RuneRooms:GetRuneEffectForFloor()
        RuneRooms:ActivateNegativeEffect(runeEffect)
    else
        sprite:Play("State5", true)
        giantCrystal.SortingLayer = SortingLayer.SORTING_BACKGROUND
        giantCrystal.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
end


---@param giantCrystal Entity
function RuneRooms:ActivateGiantCrystal(giantCrystal)
    local data = GetGiantCrystalData(giantCrystal)

    if data.breakState == 5 then return end
    if data.activated then return end

    data.activated = true
    local sprite = giantCrystal:GetSprite()
    sprite:Play("ActivateStart", true)
end


---@param giantCrystal Entity
local function OnGiantCrystalInit(giantCrystal)
    if IsGiantCrystalInitialized(giantCrystal) then return end

    local data = GetGiantCrystalData(giantCrystal)
    local runeEffect = RuneRooms:GetRuneEffectForFloor()

    local sprite = giantCrystal:GetSprite()
    local runeSpriteSheet = RUNE_SYMBOL_SPRITESHEET .. RuneRooms.Constants.RUNE_NAMES[runeEffect] .. ".png"
    sprite:ReplaceSpritesheet(2, runeSpriteSheet)
    sprite:LoadGraphics()

    if data.activated then
        sprite:Play("ActivateLoop", true)
    elseif data.breakState < 5 then
        sprite:Play("State" .. data.breakState .. "Symbol", true)
    else
        sprite:Play("State5", true)
        giantCrystal.SortingLayer = SortingLayer.SORTING_BACKGROUND
        giantCrystal.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
end


---@param giantCrystal Entity
local function OnGiantCrystalUpdate(giantCrystal)
    local sprite = giantCrystal:GetSprite()

    if sprite:IsFinished("ActivateStart") then
        sprite:Play("ActivateLoop", true)

        local runeEffect = RuneRooms:GetRuneEffectForFloor()
        RuneRooms:ActivatePositiveEffect(runeEffect)
    end
end


function GiantRuneCrystal:OnNewRoom()
    local giantRuneCrystals = Isaac.FindByType(
        EntityType.ENTITY_GENERIC_PROP,
        RuneRooms.Enums.GenericPropVariant.GIANT_RUNE_CRYSTAL
    )

    TSIL.Utils.Tables.ForEach(giantRuneCrystals, function (_, giantCrystal)
        OnGiantCrystalInit(giantCrystal)
    end)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED,
    GiantRuneCrystal.OnNewRoom
)


function GiantRuneCrystal:OnUpdate()
    local giantRuneCrystals = Isaac.FindByType(
        EntityType.ENTITY_GENERIC_PROP,
        RuneRooms.Enums.GenericPropVariant.GIANT_RUNE_CRYSTAL
    )

    TSIL.Utils.Tables.ForEach(giantRuneCrystals, function (_, giantCrystal)
        if giantCrystal.FrameCount == 1 then
            OnGiantCrystalInit(giantCrystal)
        end

        OnGiantCrystalUpdate(giantCrystal)
    end)
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    GiantRuneCrystal.OnUpdate
)


---@param bomb EntityBomb
function GiantRuneCrystal:OnBombExplode(bomb)
    local radius = TSIL.Bombs.GetBombRadiusFromDamage(bomb.ExplosionDamage)
    local closeEntities = Isaac.FindInRadius(bomb.Position, radius)

    local destroyableGiantCrystals = TSIL.Utils.Tables.Filter(closeEntities, function (_, entity)
        if entity.Type ~= EntityType.ENTITY_GENERIC_PROP then return false end
        if entity.Variant ~= RuneRooms.Enums.GenericPropVariant.GIANT_RUNE_CRYSTAL then return false end

        local data = GetGiantCrystalData(entity)
        return data.breakState ~= 5
    end)

    TSIL.Utils.Tables.ForEach(destroyableGiantCrystals, function (_, giantCrystal)
        RuneRooms:DealDamageToGiantCrystal(giantCrystal)
    end)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_BOMB_EXPLODED,
    GiantRuneCrystal.OnBombExplode
)