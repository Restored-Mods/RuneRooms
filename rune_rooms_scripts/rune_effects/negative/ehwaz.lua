local EhwazNegative = {}

local TRAPDOOR_REPLACE_CHANCE = 0.3
local REPLACEABLE_GRID_TYPES = {
    GridEntityType.GRID_PILLAR,
    GridEntityType.GRID_POOP,
    GridEntityType.GRID_ROCK,
    GridEntityType.GRID_ROCKB,
    GridEntityType.GRID_ROCKT,
    GridEntityType.GRID_ROCK_ALT,
    GridEntityType.GRID_ROCK_BOMB,
    GridEntityType.GRID_ROCK_GOLD,
    GridEntityType.GRID_ROCK_SPIKED,
    GridEntityType.GRID_ROCK_SS,
}
local REPLACEABLE_GRID_XML_TYPES = {
    [TSIL.Enums.GridEntityXMLType.PILLAR] = true,
    [TSIL.Enums.GridEntityXMLType.POOP] = true,
    [TSIL.Enums.GridEntityXMLType.POOP_BLACK] = true,
    [TSIL.Enums.GridEntityXMLType.POOP_CHARMING] = true,
    [TSIL.Enums.GridEntityXMLType.POOP_CORN] = true,
    [TSIL.Enums.GridEntityXMLType.POOP_GOLDEN] = true,
    [TSIL.Enums.GridEntityXMLType.POOP_RAINBOW] = true,
    [TSIL.Enums.GridEntityXMLType.POOP_RED] = true,
    [TSIL.Enums.GridEntityXMLType.POOP_WHITE] = true,
    [TSIL.Enums.GridEntityXMLType.ROCK] = true,
    [TSIL.Enums.GridEntityXMLType.BLOCK] = true,
    [TSIL.Enums.GridEntityXMLType.ROCK_TINTED] = true,
    [TSIL.Enums.GridEntityXMLType.ROCK_ALT] = true,
    [TSIL.Enums.GridEntityXMLType.ROCK_BOMB] = true,
    [TSIL.Enums.GridEntityXMLType.ROCK_SPIKED] = true,
}


local function ReplaceGridEntities()
    local gridEntities = TSIL.GridEntities.GetGridEntities(table.unpack(REPLACEABLE_GRID_TYPES))

    TSIL.Utils.Tables.ForEach(gridEntities, function (_, gridEntity)
        local rng = TSIL.RNG.NewRNG(gridEntity.Desc.SpawnSeed)

        if rng:RandomFloat() >= 0.3 then return end

        TSIL.GridEntities.SpawnGridEntity(
            GridEntityType.GRID_TRAPDOOR,
            TSIL.Enums.TrapdoorVariant.NORMAL,
            gridEntity:GetGridIndex(),
            true
        )
    end)
end


function EhwazNegative:OnNewRoom()
    if not RuneRooms:IsNegativeEffectActive(RuneRooms.Enums.RuneEffect.EHWAZ) then return end

    ReplaceGridEntities()
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED,
    EhwazNegative.OnNewRoom
)


function EhwazNegative:OnEhwazNegativeActivation()
    ReplaceGridEntities()
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallbacks.POST_GAIN_NEGATIVE_RUNE_EFFECT,
    EhwazNegative.OnEhwazNegativeActivation,
    RuneRooms.Enums.RuneEffect.EHWAZ
)