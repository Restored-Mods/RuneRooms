local BerkanoNegative = {}


---@param npc EntityNPC
function BerkanoNegative:OnNPCDeath(npc)
    if not RuneRooms:IsNegativeEffectActive(RuneRooms.Enums.RuneEffect.BERKANO) then return end

    local cantSpawnEnemies = TSIL.Entities.GetEntityData(
        RuneRooms,
        npc,
        "CantSpawnBerkanoEnemies"
    )
    if cantSpawnEnemies then return end

    local rng = TSIL.RNG.NewRNG(npc.InitSeed)

    local numEnemies = TSIL.Random.GetRandomInt(1, 2, rng)
    for _ = 1, numEnemies, 1 do
        local type = EntityType.ENTITY_FLY
        if rng:RandomFloat() > 0.5 then
            type = EntityType.ENTITY_SPIDER
        end

        local distance = TSIL.Random.GetRandomFloat(0, 15)
        local angle = TSIL.Random.GetRandomInt(0, 360, rng)
        local posOffset = Vector.FromAngle(angle):Resized(distance)

        local enemy = TSIL.Entities.Spawn(
            type,
            0,
            0,
            npc.Position + posOffset
        )
        enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

        TSIL.Entities.SetEntityData(
            RuneRooms,
            enemy,
            "CantSpawnBerkanoEnemies",
            true
        )
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    BerkanoNegative.OnNPCDeath
)