local DagazEssence = {}

local BURNING_RADIUS = 100
local BURNING_DURATION = 30 * 3
local DagazItem = RuneRooms.Enums.Item.DAGAZ_ESSENCE

TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.REMOVE_CURSES_NEXT_FLOOR,
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)


function DagazEssence:OnDagazPickup()
    TSIL.SaveManager.SetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.REMOVE_CURSES_NEXT_FLOOR,
        true
    )

    local level = Game():GetLevel()
    level:RemoveCurses(level:GetCurses())
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    DagazEssence.OnDagazPickup,
    {
        nil,
        nil,
        DagazItem
    }
)


function DagazEssence:OnCurseEval()
    local removeCurses = TSIL.SaveManager.GetPersistentVariable(
        RuneRooms,
        RuneRooms.Enums.SaveKey.REMOVE_CURSES_NEXT_FLOOR
    )

    if removeCurses then
        TSIL.SaveManager.SetPersistentVariable(
            RuneRooms,
            RuneRooms.Enums.SaveKey.REMOVE_CURSES_NEXT_FLOOR,
            false
        )

        return 0
    end
end
RuneRooms:AddPriorityCallback(
    ModCallbacks.MC_POST_CURSE_EVAL,
    CallbackPriority.LATE + 100,
    DagazEssence.OnCurseEval
)


---@param player EntityPlayer
function DagazEssence:OnPeffectUpdate(player)
    if not player:HasCollectible(DagazItem) then return end

    local closeEnemies = Isaac.FindInRadius(player.Position, BURNING_RADIUS, EntityPartition.ENEMY)
    TSIL.Utils.Tables.ForEach(closeEnemies, function (_, enemy)
        if not enemy:ToNPC() then return end

        enemy:AddBurn(EntityRef(player), BURNING_DURATION, player.Damage)
        TSIL.Entities.SetEntityData(
            RuneRooms,
            enemy,
            "IsBurningFromDagazEffect",
            true
        )
    end)
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    DagazEssence.OnPeffectUpdate
)


---@param npc EntityNPC
function DagazEssence:OnNPCUpdate(npc)
    local isBurningFromDagazEffect = TSIL.Entities.GetEntityData(
        RuneRooms,
        npc,
        "IsBurningFromDagazEffect"
    ) == true

    if isBurningFromDagazEffect and not npc:HasEntityFlags(EntityFlag.FLAG_BURN) then
        TSIL.Entities.SetEntityData(
            RuneRooms,
            npc,
            "IsBurningFromDagazEffect",
            false
        )
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_NPC_UPDATE,
    DagazEssence.OnNPCUpdate
)


---@param npc EntityNPC
function DagazEssence:OnNPCDeath(npc)
    local isBurningFromDagazEffect = TSIL.Entities.GetEntityData(
        RuneRooms,
        npc,
        "IsBurningFromDagazEffect"
    ) == true

    if isBurningFromDagazEffect then
        TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.CRACK_THE_SKY,
            0,
            npc.Position,
            Vector.Zero,
            Isaac.GetPlayer()   --IDK if this makes it scale with the player's damage or does some constant damage
        )
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    DagazEssence.OnNPCDeath
)