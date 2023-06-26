RuneRooms.Enums = {}

RuneRooms.Enums.Item = {
    ALGIZ_ESSENCE   = Isaac.GetItemIdByName("Essence of Algiz"),
    ANSUZ_ESSENCE   = Isaac.GetItemIdByName("Essence of Ansuz"),
    BERKANO_ESSENCE = Isaac.GetItemIdByName("Essence of Berkano"),
    DAGAZ_ESSENCE   = Isaac.GetItemIdByName("Essence of Dagaz"),
    EHWAZ_ESSENCE   = Isaac.GetItemIdByName("Essence of Ehwaz"),
    FEHU_ESSENCE    = Isaac.GetItemIdByName("Essence of Fehu"),
    GEBO_ESSENCE    = Isaac.GetItemIdByName("Essence of Gebo"),
    HAGALAZ_ESSENCE = Isaac.GetItemIdByName("Essence of Hagalaz"),
    INGWAZ_ESSENCE  = Isaac.GetItemIdByName("Essence of Ingwaz"),
    JERA_ESSENCE    = Isaac.GetItemIdByName("Essence of Jera"),
    KENAZ_ESSENCE   = Isaac.GetItemIdByName("Essence of Kenaz"),
    OTHALA_ESSENCE  = Isaac.GetItemIdByName("Essence of Othala"),
    PERTHRO_ESSENCE = Isaac.GetItemIdByName("Essence of Perthro"),
    SOWILO_ESSENCE  = Isaac.GetItemIdByName("Essence of Sowilo"),
}


---@enum RuneEffect
RuneRooms.Enums.RuneEffect = {
    ALGIZ   = 1<<0,
    ANSUZ   = 1<<1,
    BERKANO = 1<<2,
    DAGAZ   = 1<<3,
    EHWAZ   = 1<<4,
    FEHU    = 1<<5,
    GEBO    = 1<<6,
    HAGALAZ = 1<<7,
    INGWAZ  = 1<<8,
    JERA    = 1<<9,
    KENAZ   = 1<<10,
    OTHALA  = 1<<11,
    PERTHRO = 1<<12,
    SOWILO  = 1<<13,
}


RuneRooms.Enums.PickupVariant = {
    DOUBLE_LOCKED_CHEST = Isaac.GetEntityVariantByName("Double Locked Chest"),
    DOUBLE_BOMB_CHEST   = Isaac.GetEntityVariantByName("Double Bomb Chest"),
}


RuneRooms.Enums.EffectVariant = {
    SMOKE_CLOUD = Isaac.GetEntityVariantByName("Rune Rooms Smoke Screen")
}


RuneRooms.Enums.GenericPropVariant = {
    GIANT_RUNE_CRYSTAL  = Isaac.GetEntityVariantByName("Giant Rune Crystal"),
    RUNE_PAD            = Isaac.GetEntityVariantByName("Rune Pad"),
}


RuneRooms.Enums.SaveKey = {
    HIDDEN_ITEM_MANAGER_DATA        = "HIDDEN_ITEM_MANAGER_DATA",
    MINIMAPI_DATA                   = "MINIMAPI_DATA",

    GIANT_CRYSTAL_DATA              = "GIANT_CRYSTAL_DATA",
    RUNE_PAD_DATA                   = "RUNE_PAD_DATA",

    ACTIVE_POSITIVE_EFFECTS         = "ACTIVE_POSITIVE_EFFECTS",
    ACTIVE_NEGATIVE_EFFECTS         = "ACTIVE_NEGATIVE_EFFECTS",

    POSITIVE_FEHU_RNG_PER_PLAYER    = "POSITIVE_FEHU_RNG_PER_PLAYER",
    NEGATIVE_FEHU_RNG_PER_PLAYER    = "NEGATIVE_FEHU_RNG_PER_PLAYER",
    REPLACED_DOUBLE_CLOSED_CHESTS   = "REPLACED_DOUBLE_CLOSED_CHESTS",
    ROOMS_USED_ISAACS_SOUL          = "ROOMS_USED_ISAACS_SOUL",
    LOWEST_HEALTH_ENEMY             = "LOWEST_HEALTH_ENEMY",
    ROOMS_SPAWNED_SLOT              = "ROOMS_SPAWNED_SLOT",
    BERKANO_FAMILIAR_POSITIONS      = "BERKANO_FAMILIAR_POSITIONS",
    REMOVE_CURSES_NEXT_FLOOR        = "REMOVE_CURSES_NEXT_FLOOR",
    LAST_KILLED_ENEMY               = "LAST_KILLED_ENEMY",
    DEAD_FRIENDLY_ENEMY             = "DEAD_FRIENDLY_ENEMY",
    FREE_SLOT_USES_PER_PLAYER       = "FREE_SLOT_USES_PER_PLAYER"
}


---@enum RuneRoomsCustomCallback
RuneRooms.Enums.CustomCallback = {
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

    --Called whenever a chest changes to the opened subtype.
    --Won't be called if a chest spawns an item.
    --
    --Params:
    --
    -- * chest - EntityPickup
    --
    --Optional args:
    --
    -- * pickupVariant - PickupVariant
    POST_CHEST_OPENED = {},

    --Called either from the `MC_NEW_ROOM` callback or the `MC_POST_UPDATE` callback,
    --the first frame a generic prop is available.
    --
    --Params:
    --
    -- * genericProp - Entity
    --
    --Optional args:
    --
    -- * genericPropVariant - GenericPropVariant
    POST_GENERIC_PROP_INIT = {},

    --Called from the `MC_POST_UPDATE` callback for each generic prop in the room.
    --
    --Params:
    --
    -- * genericProp - Entity
    --
    --Optional args:
    --
    -- * genericPropVariant - GenericPropVariant
    POST_GENERIC_PROP_UPDATE = {},

    --Called whenever a custom tear flag is added to a tear.
    --
    --Params:
    --
    -- * tear - EntityTear
    -- * tearFlag - CustomTearFlag
    --
    --Optional args:
    --
    -- * tearFlag - CustomTearFlag
    POST_CUSTOM_TEAR_FLAG_ADDED = {},

    --Called whenever a custom tear flag is removed from a tear.
    --
    --Params:
    --
    -- * tear - EntityTear
    -- * tearFlag - CustomTearFlag
    --
    --Optional args:
    --
    -- * tearFlag - CustomTearFlag
    POST_CUSTOM_TEAR_FLAG_REMOVED = {}
}


RuneRooms.Enums.SoundEffect = {
    RUNE_CRYSTAL_EXPLOSION = Isaac.GetSoundIdByName("Rune Crystal Explosion")
}


---@enum Achievement
RuneRooms.Enums.Achievement = {
    CONFESSIONAL    = 1,
    CRANE_GAME      = 2,
    HELL_GAME       = 3,
    ROTTEN_BEGGAR   = 4,
}


RuneRooms.Enums.ItemPool = {}


---@enum CustomTearFlag
RuneRooms.Enums.TearFlag = {
    --Turns hit enemies into gold (midas effect)
    MIDAS = 1 << 0,

    --Leaves blood creep on impact
    BLOOD_CREEP = 1 << 1,
}