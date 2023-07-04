local Shield = {}

local DURATION_TO_BLINK = 30

local ShieldSpritePerPlayer = {}

TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.SHIELD_DURATION_PER_PLAYER,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

---Adds a shield similar to the one given by Book of Shadows to a
---player for a custom duration.
---@param player EntityPlayer
---@param duration integer In frames
function RuneRooms:AddShieldInvincibility(player, duration)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local shieldDurationPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.SHIELD_DURATION_PER_PLAYER
    )

    shieldDurationPerPlayer[playerIndex] = duration
end


---Checks if a player has the custom shield invincibility.
---@param player EntityPlayer
---@return boolean
function RuneRooms:HasShieldInvincibility(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local shieldDurationPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.SHIELD_DURATION_PER_PLAYER
    )

    return shieldDurationPerPlayer[playerIndex] ~= nil
end


---@param player EntityPlayer
---@return Sprite
local function GetShieldSprite(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local sprite = ShieldSpritePerPlayer[playerIndex]

    if not sprite then
        sprite = Sprite()
        sprite:Load("gfx/AlgizShield.anm2", true)
        sprite:Play("Idle", true)

        ShieldSpritePerPlayer[playerIndex] = sprite
    end

    return sprite
end


---@param player EntityPlayer
local function UpdateShieldSprite(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local shieldDurationPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.SHIELD_DURATION_PER_PLAYER
    )

    local shieldDuration = shieldDurationPerPlayer[playerIndex]

    local sprite = GetShieldSprite(player)
    local currentAnim = sprite:GetAnimation()

    if shieldDuration <= DURATION_TO_BLINK and currentAnim == "Idle" then
        sprite:Play("Blink", true)
    elseif shieldDuration >= DURATION_TO_BLINK and currentAnim == "Blink" then
        sprite:Play("Idle", true)
    end

    sprite:Update()
end


---@param player EntityPlayer
local function DecreaseShieldDuration(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local shieldDurationPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.SHIELD_DURATION_PER_PLAYER
    )

    local shieldDuration = shieldDurationPerPlayer[playerIndex]

    local newShieldDuration = shieldDuration - 1

    if newShieldDuration <= 0 then
        newShieldDuration = nil
    end

    shieldDurationPerPlayer[playerIndex] = newShieldDuration
end


---@param player EntityPlayer
function Shield:OnPeffectUpdate(player)
    if not RuneRooms:HasShieldInvincibility(player) then return end

    UpdateShieldSprite(player)

    DecreaseShieldDuration(player)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_PEFFECT_UPDATE_REORDERED,
    Shield.OnPeffectUpdate
)


---@param player EntityPlayer
function Shield:OnPlayerRender(player)
    if not RuneRooms:HasShieldInvincibility(player) then return end

    local sprite = GetShieldSprite(player)
    sprite.Scale = TSIL.Vector.CopyVector(player.SpriteScale)

    local renderPos = Isaac.WorldToScreen(player.Position)
    sprite:Render(renderPos)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_RENDER_REORDERED,
    Shield.OnPlayerRender
)


---@param entity Entity
function Shield:OnPlayerDamage(entity)
    local player = entity:ToPlayer()

    if RuneRooms:HasShieldInvincibility(player) then
        return false
    end
end
RuneRooms:AddPriorityCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    CallbackPriority.IMPORTANT,
    Shield.OnPlayerDamage,
    EntityType.ENTITY_PLAYER
)