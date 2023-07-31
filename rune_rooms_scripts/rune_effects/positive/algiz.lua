local PositiveAlgiz = {}


function PositiveAlgiz:OnNewRoom()
    if not RuneRooms:IsPositiveEffectActive(RuneRooms.Enums.RuneEffect.ALGIZ) then return end
    if not Game():GetRoom():IsFirstVisit() then return end

    local players = TSIL.Players.GetPlayers()

    for _, player in ipairs(players) do
        player:UseActiveItem(
            CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
            UseFlag.USE_NOANIM
        )
    end
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED,
    PositiveAlgiz.OnNewRoom
)