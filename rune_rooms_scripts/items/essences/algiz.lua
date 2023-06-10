local AlgizEssence = {}

local AlgizItem = RuneRooms.Enums.ITEMS.ALGIZ_ESSENCE

---@param player EntityPlayer
---@param firstTime boolean
function AlgizEssence:OnAlgizPickup(player, _, firstTime)
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B and not firstTime then return end

    player:AddBoneHearts(1)
    player:AddHearts(2)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    AlgizEssence.OnAlgizPickup,
    {
        nil,
        nil,
        AlgizItem
    }
)