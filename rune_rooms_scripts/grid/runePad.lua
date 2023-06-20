local RunePad = {}

local RUNE_PAD_SPRITE_SHEET = "gfx/grid/grid_rune_pad_"


TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.RUNE_PAD_DATA,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)
TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.INITIALIZED_RUNE_PADS,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param runePad Entity
local function GetRunePadData(runePad)
    local padsData = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.RUNE_PAD_DATA
    )
    local padIndex = RuneRooms.Helpers:GetCustomGridIndex(runePad)

    if not padsData[padIndex] then
        padsData[padIndex] = {
            activated = false
        }
    end

    return padsData[padIndex]
end


---@param giantCrystal Entity
local function IsRunePadInitialized(giantCrystal)
    local ptrHash = GetPtrHash(giantCrystal)
    local initializedGiantCrystals = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.INITIALIZED_RUNE_PADS
    )
    local isInitialized = initializedGiantCrystals[ptrHash] ~= nil
    initializedGiantCrystals[ptrHash] = true

    return isInitialized
end


local function AreAllRunePadsActivated()
    local runePads = Isaac.FindByType(
        EntityType.ENTITY_GENERIC_PROP,
        RuneRooms.Enums.GenericPropVariant.RUNE_PAD
    )

    return TSIL.Utils.Tables.All(runePads, function (_, runePad)
        local data = GetRunePadData(runePad)
        return data.activated
    end)
end


local function ActivateGiantRuneCrystals()
    local runeCrystals = Isaac.FindByType(
        EntityType.ENTITY_GENERIC_PROP,
        RuneRooms.Enums.GenericPropVariant.GIANT_RUNE_CRYSTAL
    )

    TSIL.Utils.Tables.ForEach(runeCrystals, function (_, runeCrystal)
        RuneRooms:ActivateGiantCrystal(runeCrystal)
    end)
end


---@param runePad Entity
local function OnRunePadInit(runePad)
    if IsRunePadInitialized(runePad) then return end

    runePad.DepthOffset = -80
    runePad.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    local runeEffect = RuneRooms:GetRuneEffectForFloor()
    local sprite = runePad:GetSprite()
    local spriteSheet = RUNE_PAD_SPRITE_SHEET .. RuneRooms.Constants.RUNE_NAMES[runeEffect] .. ".png"
    for i = 0, sprite:GetLayerCount()-1, 1 do
        sprite:ReplaceSpritesheet(i, spriteSheet)
    end
    sprite:LoadGraphics()

    local data = GetRunePadData(runePad)
    local anim = "IdleOff"
    if data.activated then
        anim = "IdleOn"
    end
    sprite:Play(anim, true)
end


---@param runePad Entity
local function OnRunePadUpdate(runePad)
    local data = GetRunePadData(runePad)
    local sprite = runePad:GetSprite()

    if not data.activated and sprite:IsPlaying("IdleOff") then
        local room = Game():GetRoom()
        local closestPlayer = Game():GetNearestPlayer(runePad.Position)

        local padGridIndex = room:GetGridIndex(runePad.Position)
        local playerGridIndex = room:GetGridIndex(closestPlayer.Position)

        if padGridIndex == playerGridIndex then
            sprite:Play("TurnOn", true)
        end
    end

    if sprite:IsFinished("TurnOn") then
        data.activated = true
        sprite:Play("IdleOn", true)

        if AreAllRunePadsActivated() then
            ActivateGiantRuneCrystals()
        end
    end
end


function RunePad:OnNewRoom()
    local runePads = Isaac.FindByType(
        EntityType.ENTITY_GENERIC_PROP,
        RuneRooms.Enums.GenericPropVariant.RUNE_PAD
    )

    TSIL.Utils.Tables.ForEach(runePads, function (_, runePad)
        OnRunePadInit(runePad)
    end)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED,
    RunePad.OnNewRoom
)


function RunePad:OnUpdate()
    local runePads = Isaac.FindByType(
        EntityType.ENTITY_GENERIC_PROP,
        RuneRooms.Enums.GenericPropVariant.RUNE_PAD
    )

    TSIL.Utils.Tables.ForEach(runePads, function (_, runePad)
        if runePad.FrameCount == 1 then
            OnRunePadInit(runePad)
        end

        OnRunePadUpdate(runePad)
    end)
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    RunePad.OnUpdate
)