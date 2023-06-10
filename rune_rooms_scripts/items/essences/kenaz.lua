local KenazEssence = {}

local KenazItem = RuneRooms.Enums.ITEMS.KENAZ_ESSENCE

---@param player EntityPlayer
---@param firstTime boolean
function KenazEssence:OnKenazPickup(player, _, firstTime)
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B and not firstTime then return end

    player:AddRottenHearts(1)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    KenazEssence.OnKenazPickup,
    {
        nil,
        nil,
        KenazItem
    }
)