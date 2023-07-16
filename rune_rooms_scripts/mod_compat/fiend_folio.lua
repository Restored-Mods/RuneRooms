RuneRooms:AddModCompat("FiendFolio", function ()
    local PIT_SPRITE_FF = "gfx/grid/grid_pit_rune.png"

    RuneRooms:AddCallback(
        RuneRooms.Enums.CustomCallback.PRE_GET_RUNE_PIT_SPRITE,
        function ()
            return PIT_SPRITE_FF
        end
    )
end)