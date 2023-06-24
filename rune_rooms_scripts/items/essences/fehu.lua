local FehuEssence = {}

local MIDAS_TEAR_CHANCE = 0.25
local PENNY_REPLACE_CHANCE = 0.25
---@type {chance: number, value: CoinSubType}[]
local POSSIBLE_COINS = {
    {chance = 50, value = CoinSubType.COIN_DOUBLEPACK},
    {chance = 30, value = CoinSubType.COIN_NICKEL},
    {chance = 10, value = CoinSubType.COIN_DIME},
    {chance = 5, value = CoinSubType.COIN_LUCKYPENNY}
}
local FehuItem = RuneRooms.Enums.Item.FEHU_ESSENCE

---@param player EntityPlayer
function FehuEssence:OnLuckCache(player)
    local numItems = player:GetCollectibleNum(FehuItem)
    player.Luck = player.Luck + numItems * 1
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    FehuEssence.OnLuckCache,
    CacheFlag.CACHE_LUCK
)


---@param tear EntityTear
function FehuEssence:OnTearInit(tear)
    local player = TSIL.Players.GetPlayerFromEntity(tear)
    if not player then return end
    if not player:HasCollectible(FehuItem) then return end

    local rng = player:GetCollectibleRNG(FehuItem)
    if rng:RandomFloat() >= MIDAS_TEAR_CHANCE then return end

    RuneRooms:MakeTearMidas(tear)
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_TEAR_INIT,
    FehuEssence.OnTearInit
)


---@param type EntityType
---@param variant integer
---@param subtype integer
---@param seed any
function FehuEssence:PreEntitySpawn(type, variant, subtype, _, _, _, seed)
    if not TSIL.Players.DoesAnyPlayerHasItem(FehuItem) then return end

    if type ~= EntityType.ENTITY_PICKUP then return end
    if variant ~= PickupVariant.PICKUP_COIN then return end
    if subtype ~= CoinSubType.COIN_PENNY then return end

    local rng = TSIL.RNG.NewRNG(seed)
    if rng:RandomFloat() >= PENNY_REPLACE_CHANCE then return end

    local newSubtype = TSIL.Random.GetRandomElementFromWeightedList(rng, POSSIBLE_COINS)
    return {type, variant, newSubtype, rng:Next()}
end
RuneRooms:AddCallback(
    ModCallbacks.MC_PRE_ENTITY_SPAWN,
    FehuEssence.PreEntitySpawn
)