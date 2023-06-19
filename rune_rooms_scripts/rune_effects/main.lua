local RuneEffects = {}

TSIL.Utils.Tables.ForEach(RuneRooms.Constants.RUNE_NAMES, function (_, name)
    include("rune_rooms_scripts.rune_effects.negative." .. name)
    include("rune_rooms_scripts.rune_effects.positive." .. name)
end)


TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.ACTIVE_POSITIVE_EFFECTS,
    0,
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.ACTIVE_NEGATIVE_EFFECTS,
    0,
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)


---Returns the rune effect for the current floor
---@return RuneEffect
function RuneRooms:GetRuneEffectForFloor()
    local rng = RuneRooms.Helpers:GetStageRNG()

    return TSIL.Random.GetRandomElementsFromTable(RuneRooms.Enums.RuneEffect, 1, rng)[1]
end


---Helper function to check if a rune's positive effect is active
---@param runeEffect RuneEffect
function RuneRooms:IsPositiveEffectActive(runeEffect)
    local positiveEffects = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.ACTIVE_POSITIVE_EFFECTS
    )
    return TSIL.Utils.Flags.HasFlags(positiveEffects, runeEffect)
end


---Helper function to check if a rune's negative effect is active
---@param runeEffect RuneEffect
function RuneRooms:IsNegativeEffectActive(runeEffect)
    local negativeEffects = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.ACTIVE_NEGATIVE_EFFECTS
    )
    return TSIL.Utils.Flags.HasFlags(negativeEffects, runeEffect)
end


---Helper function to check if a rune's positive effect is active
---@param runeEffect RuneEffect
function RuneRooms:ActivatePositiveEffect(runeEffect)
    local hadEffectPreviously = RuneRooms:IsPositiveEffectActive(runeEffect)

    local positiveEffects = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.ACTIVE_POSITIVE_EFFECTS
    )

    TSIL.SaveManager.SetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.ACTIVE_POSITIVE_EFFECTS,
        TSIL.Utils.Flags.AddFlags(positiveEffects, runeEffect)
    )

    if not hadEffectPreviously then
        Isaac.RunCallbackWithParam(
            RuneRooms.Enums.CustomCallbacks.POST_GAIN_POSITIVE_RUNE_EFFECT,
            runeEffect,
            runeEffect
        )
    end
end


---Helper function to check if a rune's positive effect is active
---@param runeEffect RuneEffect
function RuneRooms:ActivateNegativeEffect(runeEffect)
    local hadEffectPreviously = RuneRooms:IsNegativeEffectActive(runeEffect)

    local negativeEffects = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.ACTIVE_NEGATIVE_EFFECTS
    )

    TSIL.SaveManager.SetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.ACTIVE_NEGATIVE_EFFECTS,
        TSIL.Utils.Flags.AddFlags(negativeEffects, runeEffect)
    )

    if not hadEffectPreviously then
        Isaac.RunCallbackWithParam(
            RuneRooms.Enums.CustomCallbacks.POST_GAIN_NEGATIVE_RUNE_EFFECT,
            runeEffect,
            runeEffect
        )
    end
end


function RuneEffects:OnActivateGoodCommand(_, runeName)
    if not runeName then
        print("You need to provide a rune name as argument #1.")
        return true
    end

    local effect
    for runeEffect, name in pairs(RuneRooms.Constants.RUNE_NAMES) do
        if runeName == name then
            effect = runeEffect
        end
    end

    if not effect then
        print("Failed to find " .. runeName .. " rune.")
        return true
    end

    RuneRooms:ActivatePositiveEffect(effect)
    print("Succesfully activated positive " .. runeName .. " effect")

    return true
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallbacks.ON_CUSTOM_CMD,
    RuneEffects.OnActivateGoodCommand,
    "good"
)


function RuneEffects:OnActivateBadCommand(_, runeName)
    if not runeName then
        print("You need to provide a rune name as argument #1.")
        return true
    end

    local effect
    for runeEffect, name in pairs(RuneRooms.Constants.RUNE_NAMES) do
        if runeName == name then
            effect = runeEffect
        end
    end

    if not effect then
        print("Failed to find " .. runeName .. " rune.")
        return true
    end

    RuneRooms:ActivateNegativeEffect(effect)
    print("Succesfully activated negative " .. runeName .. " effect")

    return true
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallbacks.ON_CUSTOM_CMD,
    RuneEffects.OnActivateBadCommand,
    "bad"
)