local SmokeScreen = {}


function SmokeScreen:OnSmokeScreenInit(effect)
    effect.SpriteScale = Vector(15, 15)
    effect.DepthOffset = 6000

    local color = Color(1, 1, 1, 0, 0, 0, 0)
    color:SetColorize(0, 1, 0, 1)
    effect.Color = color
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_EFFECT_INIT,
    SmokeScreen.OnSmokeScreenInit,
    RuneRooms.Enums.EffectVariant.SMOKE_CLOUD
)


---@param effect EntityEffect
---@param newAlpha number
function SetSmokeCloudAlpha(effect, newAlpha)
    local color = Color(1, 1, 1, newAlpha, 0, 0, 0)
    color:SetColorize(0, 1, 0, 1)

    effect.Color = color
end


---@param effect EntityEffect
function SmokeScreen:OnSmokeScreenUpdate(effect)
    if effect.Timeout <= 0 then
        if effect.Color.A <= 0 then
            effect:Remove()
            return
        end

        SetSmokeCloudAlpha(effect, effect.Color.A - 0.1)
    elseif effect.Color.A < 0.8 then
        SetSmokeCloudAlpha(effect, effect.Color.A + 0.1)
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    SmokeScreen.OnSmokeScreenUpdate,
    RuneRooms.Enums.EffectVariant.SMOKE_CLOUD
)