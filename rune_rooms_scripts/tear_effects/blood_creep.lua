local BloodCreepTears = {}

local BIG_CREEP_ANIM = "BigBlood0"
local NUM_BIG_CREEP_ANIMS = 6

---@param entity Entity
function BloodCreepTears:OnTearRemove(entity)
    local tear = entity:ToTear()

    if not RuneRooms:HasCustomTearFlag(tear, RuneRooms.Enums.TearFlag.BLOOD_CREEP) then return end

    local creep = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.PLAYER_CREEP_RED,
        0,
        tear.Position
    )

    local animToPlay = TSIL.Random.GetRandomInt(1, NUM_BIG_CREEP_ANIMS, creep.InitSeed)

    creep:Update()
    local sprite = creep:GetSprite()
    sprite:Play(BIG_CREEP_ANIM .. animToPlay, true)
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    BloodCreepTears.OnTearRemove,
    EntityType.ENTITY_TEAR
)