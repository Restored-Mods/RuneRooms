local OthalaPositive = {}


local function AddRandomItemForRoom(player)
    local roomDesc = TSIL.Rooms.GetRoomDescriptor()
    local rng = TSIL.RNG.NewRNG(roomDesc.SpawnSeed)

    local playerInventory = TSIL.Players.GetPlayerInventory(player, TSIL.Enums.InventoryType.COLLECTIBLE)
    if #playerInventory == 0 then return end

    local randomItem = TSIL.Random.GetRandomElementsFromTable(playerInventory, 1, rng)[1]
    local item = randomItem.Id

    RuneRooms.Libs.HiddenItemManager:AddForRoom(player, item, nil, 1)
end


local function AddRandomItemToPlayers()
    local players = TSIL.Players.GetPlayers()
    TSIL.Utils.Tables.ForEach(players, function (_, player)
        AddRandomItemForRoom(player)
    end)
end


function OthalaPositive:OnNewRoom()
    if not RuneRooms:IsPositiveEffectActive(RuneRooms.Enums.RuneEffect.OTHALA) then return end

    AddRandomItemToPlayers()
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    OthalaPositive.OnNewRoom
)


function OthalaPositive:OnOthalaPositiveActivation()
    AddRandomItemToPlayers()
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallbacks.POST_GAIN_POSITIVE_RUNE_EFFECT,
    OthalaPositive.OnOthalaPositiveActivation,
    RuneRooms.Enums.RuneEffect.OTHALA
)