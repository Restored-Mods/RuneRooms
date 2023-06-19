RuneRooms.Enums = {}

RuneRooms.Enums.Item = {
    HAGALAZ_ESSENCE = Isaac.GetItemIdByName("Essence of Hagalaz"),
    JERA_ESSENCE = Isaac.GetItemIdByName("Essence of Jera"),
    EHWAZ_ESSENCE = Isaac.GetItemIdByName("Essence of Ehwaz"),
    DAGAZ_ESSENCE = Isaac.GetItemIdByName("Essence of Dagaz"),
    ANSUZ_ESSENCE = Isaac.GetItemIdByName("Essence of Ansuz"),
    PERTHRO_ESSENCE = Isaac.GetItemIdByName("Essence of Perthro"),
    BERKANO_ESSENCE = Isaac.GetItemIdByName("Essence of Berkano"),
    ALGIZ_ESSENCE = Isaac.GetItemIdByName("Essence of Algiz"),
    GEBO_ESSENCE = Isaac.GetItemIdByName("Essence of Gebo"),
    KENAZ_ESSENCE = Isaac.GetItemIdByName("Essence of Kenaz"),
    FEHU_ESSENCE = Isaac.GetItemIdByName("Essence of Fehu"),
    OTHALA_ESSENCE = Isaac.GetItemIdByName("Essence of Othala"),
    INGWAZ_ESSENCE = Isaac.GetItemIdByName("Essence of Ingwaz"),
    SOWILO_ESSENCE = Isaac.GetItemIdByName("Essence of Sowilo"),
}


---@enum RuneEffect
RuneRooms.Enums.RuneEffect = {
    HAGALAZ = 1<<0,
    JERA = 1<<1,
    EHWAZ = 1<<2,
    DAGAZ = 1<<3,
    ANSUZ = 1<<4,
    PERTHRO = 1<<5,
    BERKANO = 1<<6,
    ALGIZ = 1<<7,
    GEBO = 1<<8,
    KENAZ = 1<<9,
    FEHU = 1<<10,
    OTHALA = 1<<11,
    INGWAZ = 1<<12,
    SOWILO = 1<<13,
}


RuneRooms.Enums.GenericPropVariant = {
    GIANT_RUNE_CRYSTAL = Isaac.GetEntityVariantByName("Giant Rune Crystal")
}


RuneRooms.Enums.SaveKey = {
    GIANT_CRYSTAL_DATA = "GIANT_CRYSTAL_DATA",
    INITIALIZED_GIANT_CRYSTALS = "INITIALIZED_GIANT_CRYSTALS",
    ACTIVE_POSITIVE_EFFECTS = "ACTIVE_POSITIVE_EFFECTS",
    ACTIVE_NEGATIVE_EFFECTS = "ACTIVE_NEGATIVE_EFFECTS",
    HIDDEN_ITEM_MANAGER_DATA = "HIDDEN_ITEM_MANAGER_DATA",
    POSITIVE_FEHU_RNG_PER_PLAYER = "POSITIVE_FEHU_RNG_PER_PLAYER",
    NEGATIVE_FEHU_RNG_PER_PLAYER = "NEGATIVE_FEHU_RNG_PER_PLAYER"
}


RuneRooms.Enums.CustomCallbacks = {
    --Called whenever a command that starts with "rune" is run in the console.
    --
    --Return true so the handler knows a command has been found and doesn't print the error message.
	--
	--Params:
	--
	-- * command - string
    -- * ... params - string
	--
	--Optional args:
	--
	-- * command - string
    ON_CUSTOM_CMD = {},

    --Called whenever a positive rune effect is added.
	--
	--Params:
	--
	-- * runeEffect - RuneEffect
	--
	--Optional args:
	--
	-- * runeEffect - RuneEffect
    POST_GAIN_POSITIVE_RUNE_EFFECT = {},

    --Called whenever a negative rune effect is added.
	--
	--Params:
	--
	-- * runeEffect - RuneEffect
	--
	--Optional args:
	--
	-- * runeEffect - RuneEffect
    POST_GAIN_NEGATIVE_RUNE_EFFECT = {},
}