local RuneEffects = {}

TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.ACTIVE_POSITIVE_EFFECTS,
    0,
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.ACTIVE_NEGATIVE_EFFECTS,
    0,
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.FORCED_RUNE_EFFECT,
    -1,
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

local SortedEffects

---Returns the rune effect for the current floor
---@return RuneEffect
function RuneRooms:GetRuneEffectForFloor()
    local forcedEffect = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.FORCED_RUNE_EFFECT
    )

    if forcedEffect >= 0 then
        return forcedEffect
    end

    if not SortedEffects then
        SortedEffects = {}

        for _, value in pairs(RuneRooms.Enums.RuneEffect) do
            SortedEffects[#SortedEffects+1] = value
        end

        table.sort(SortedEffects)
    end

    local rng = RuneRooms.Helpers:GetStageRNG()

    return TSIL.Random.GetRandomElementsFromTable(SortedEffects, 1, rng)[1]
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
    Isaac.DebugString("[RuneRooms] Succesfully activated positive " .. runeEffect .. " effect")
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
            RuneRooms.Enums.CustomCallback.POST_GAIN_POSITIVE_RUNE_EFFECT,
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
            RuneRooms.Enums.CustomCallback.POST_GAIN_NEGATIVE_RUNE_EFFECT,
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
    RuneRooms.Enums.CustomCallback.ON_CUSTOM_CMD,
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
    RuneRooms.Enums.CustomCallback.ON_CUSTOM_CMD,
    RuneEffects.OnActivateBadCommand,
    "bad"
)


function RuneEffects:OnForceRuneEffect(_, runeName)
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

    if runeName == "none" then
        effect = -1
    end

    if not effect then
        print("Failed to find " .. runeName .. " rune.")
        return true
    end

    if effect == -1 then
        print("Succesfully set rune effect for the floor to default")
    else
        print("Succesfully set rune effect for the floor to " .. runeName)
    end

    TSIL.SaveManager.SetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.FORCED_RUNE_EFFECT,
        effect
    )

    return true
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallback.ON_CUSTOM_CMD,
    RuneEffects.OnForceRuneEffect,
    "seteffect"
)