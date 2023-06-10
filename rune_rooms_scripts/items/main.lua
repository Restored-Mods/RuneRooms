TSIL.Utils.Tables.ForEach(RuneRooms.Constants.RUNE_NAMES, function (_, name)
    require("rune_rooms_scripts.items.essences." .. name)
end)