local DagazNegative = {}

local EXTRA_CHAMPION_CHANCE = 0.4

---@param npc EntityNPC
function DagazNegative:OnNPCInit(npc)
    if not RuneRooms:IsNegativeEffectActive(RuneRooms.Enums.RuneEffect.DAGAZ) then return end

    if not npc:IsChampion() and npc:IsActiveEnemy() then
        local rng = TSIL.RNG.NewRNG(npc.InitSeed)

        if rng:RandomFloat() >= EXTRA_CHAMPION_CHANCE then return end

        ---@diagnostic disable-next-line: param-type-mismatch
        npc:MakeChampion(npc.InitSeed, -1, true)
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    DagazNegative.OnNPCInit
)