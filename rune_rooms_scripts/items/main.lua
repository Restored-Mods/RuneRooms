TSIL.Utils.Tables.ForEach(RuneRooms.Constants.RUNE_NAMES, function (_, name)
    include("rune_rooms_scripts.items.essences." .. name)
end)