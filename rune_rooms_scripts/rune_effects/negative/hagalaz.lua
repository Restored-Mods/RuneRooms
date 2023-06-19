local HagalazNegative = {}

local SPIKE_ROCK_REPLACE_CHANCE = 0.3


local function ReplaceGridEntities()
    local rocks = TSIL.GridSpecific.GetRocks()

    TSIL.Utils.Tables.ForEach(rocks, function (_, rock)
        local rng = TSIL.RNG.NewRNG(rock.Desc.SpawnSeed)

        if rng:RandomFloat() >= SPIKE_ROCK_REPLACE_CHANCE then return end

        TSIL.GridEntities.SpawnGridEntity(
            GridEntityType.GRID_ROCK_SPIKED,
            0,
            rock:GetGridIndex(),
            true
        )
    end)
end


function HagalazNegative:OnNewRoom()
    if not RuneRooms:IsNegativeEffectActive(RuneRooms.Enums.RuneEffect.HAGALAZ) then return end

    ReplaceGridEntities()
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED,
    HagalazNegative.OnNewRoom
)


function HagalazNegative:OnHagalazNegativeActivation()
    ReplaceGridEntities()
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallbacks.POST_GAIN_NEGATIVE_RUNE_EFFECT,
    HagalazNegative.OnHagalazNegativeActivation,
    RuneRooms.Enums.RuneEffect.HAGALAZ
)