RuneRooms = RegisterMod("Rune Rooms", 1)

local myFolder = "rune_rooms_loi"
local LOCAL_TSIL = require(myFolder .. ".TSIL")
LOCAL_TSIL.Init(myFolder)

include("rune_rooms_scripts.enums")
include("rune_rooms_scripts.constants")
include("rune_rooms_scripts.helpers")

RuneRooms.Libs = {}
include("rune_rooms_scripts.lib.hidden_item_manager")

include("rune_rooms_scripts.grid.main")
include("rune_rooms_scripts.items.main")
include("rune_rooms_scripts.room.main")
include("rune_rooms_scripts.rune_effects.main")

print("Rune Rooms loaded. Use \"rune help\" to get information about commands.")


RuneRooms:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function (_, cmd, params)
    if cmd == "rune" then
        local tokens = TSIL.Utils.String.Split(params, " ")
        tokens = TSIL.Utils.Tables.Map(tokens, function (_, token)
            return string.lower(token)
        end)

        local found = Isaac.RunCallbackWithParam(
            RuneRooms.Enums.CustomCallbacks.ON_CUSTOM_CMD,
            tokens[1],
            table.unpack(tokens)
        )

        if not found then
            print("Command " .. tokens[1] .. " not found.")
            print("Type \"rune help\" to get information about commands.")
        end
    end
end)


RuneRooms:AddCallback(RuneRooms.Enums.CustomCallbacks.ON_CUSTOM_CMD, function ()
    print("rune help - Shows this message.")
    print("rune good [rune_effect] - Activates the good effect of a rune for the current level.")
    print("rune bad [rune_effect] - Activates the good effect of a rune for the current level.")
    print("rune ehwazmode [mode] - Changes how the positive effect of ehwaz works")

    return true
end, "help")


--local mod = RegisterMod("Rune Rooms", 1);

-- local json = require("json")
-- local loadingOverlay = false

-- local data = {run = {activated = false, effect = 1, visitedRooms = {}, lastDevilDealPlayer = nil, runified = false, visited = false}, persistent = {spawnChance = 0.5}}

-- local randomOverlay = 1
-- local algizBossTimer = -1
-- local function getDoors(roomType)
--     local game = Game()
--     local room = game:GetRoom()
--     local doors = {}
--     do
--         local i = 0
--         while i < 8 do
--             do
--                 local door = room:GetDoor(i)
--                 if door == nil then
--                     goto __continue5
--                 end
--                 if roomType == nil then
--                     table.insert(doors, door)
--                 elseif door:IsRoomType(roomType) then
--                     table.insert(doors, door)
--                 end
--             end
--             ::__continue5::
--             i = i + 1
--         end
--     end
--     return doors
-- end

-- --MinimapAPI compatibility
-- if MinimapAPI then
--   local rr_sprite = Sprite()
--   rr_sprite:Load("gfx/ui/minimapapi/runerooms_minimapicon.anm2", true)
--   rr_sprite:SetFrame("CustomIconRuneRooms", 0)
--   MinimapAPI:AddIcon("RuneRooms", rr_sprite)
-- end

-- --Rooms settings
-- local Settings = {
--     ActivationRange = 80,
--     EhwazTrapDoorPosition = Vector(153, 208),
--     EhwazCrawlspacePosition = Vector(476, 208),
--     RedKeysToSpawn = {2, 5},
--     SpidersToSpawn = 3,
--     FliesToSpawn = 3
-- }

-- --Rune rooms effects descriptions
-- local runeEffects = {
--     {Id = 1, Name = "Hagalaz", Description = "Destroy all rocks for the rest of the floor"},
--     {Id = 2, Name = "Ehwaz", Description = "Spawns three trapdoors, which goes to the next floor, a crawlspace, and the secret shop respectively#All locked doors are automatically unlocked"},
--     {Id = 3, Name = "Dagaz", Description = "Gives all players 2 soul hearts and removes all curses for the floor"},
--     {Id = 4, Name = "Ansuz", Description = "Reveals the floor's layout#Reveals all secret room entrances for the floor # Red doors leading to the Ultra Secret Room are unlocked"},
--     {
--         Id = 5,
--         Name = "Berkano",
--         Description = ((("Clearing a room spawns " .. tostring(Settings.FliesToSpawn)) .. " blue flies and ") .. tostring(Settings.SpidersToSpawn)) .. " blue spiders"
--     },
--     {Id = 6, Name = "Algiz", Description = "Gives all players a shield for 10 seconds upon entering a room"},
--     {Id = 7, Name = "Kenaz", Description = "Poisons all enemies upon entering a room"},
--     {Id = 8, Name = "Fehu", Description = "All enemies get the {{Collectible202}} Midas Touch effect for 3 seconds upon entering a room"},
--     {Id = 9, Name = "Ingwaz", Description = "All locked doors and chests are automatically opened"},
--     {Id = 10, Name = "Sowilo", Description = "All rooms cleared prior to activating this will reroll it's enemies once, allowing more pickups to be farmed#Does not apply to surprise mini boss rooms or boss rooms at the end of the floor"},
--     {Id = 11, Name = "Jera", Description = "Pickups are doubled for the floor"},
--     {Id = 12, Name = "Perthro", Description = "Rerolls all pedestals and pickups on the floor"},
--     {Id = 13, Name = "Gebo", Description = "You have {{Collectible64}} Steam Sale and {{Collectible376}} Restock effects for the floor (?)"},
--     {Id = 14, Name = "Othala", Description = "Every player randomly gets 2-3 of their existing items duplicated permanently"},
--     {Id = 15, Name = "Black rune", Description = "Upon entering a new room, all enemies will take 10 damage. All future pickups dropped will be replaced with blue flies and future pedestals will have a 50% of being consumed and giving you a stats up. The effect lasts for the entire floor"}
-- }

-- local runeEffectsSpa = {
--     {Id = 1, Name = "Hagalaz", Description = "Se destruyen todas las rocas del piso"},
--     {Id = 2, Name = "Ehwaz", Description = "Genera 3 trampillas, Darán al siguiente piso, a un espacio subterraneo o una tienda secreta#Todas las puertas cerradas se abrirán"},
--     {Id = 3, Name = "Dagaz", Description = "{{SoulHeart}} Da 2 corazones de alma a los jugadores y remueve todas las maldiciones del piso"},
--     {Id = 4, Name = "Ansuz", Description = "Muestra todo el piso#Revela todas las entradas a salas secretas del piso#Las puertas rojas hacia la sala Ultra Secreta se abrirán"},
--     {
--         Id = 5,
--         Name = "Berkano",
--         Description = ((("Limpiar una sala generará" .. tostring(Settings.FliesToSpawn)) .. " moscas azules y ") .. tostring(Settings.SpidersToSpawn)) .. " arañas azules"
--     },
--     {Id = 6, Name = "Algiz", Description = "Da a los jugadores un escudo de 10 segundos al entrar a una nueva sala"},
--     {Id = 7, Name = "Kenaz", Description = "Envenena a todos los enemigos al entrar a una sala"},
--     {Id = 8, Name = "Fehu", Description = "Aplica el efecto del {{Collectible202}} Toque de midas a todos los enemigos al entrar a una sala"},
--     {Id = 9, Name = "Ingwaz", Description = "Todos los cofres y puertas cerradas se abrirán"},
--     {Id = 10, Name = "Sowilo", Description = "Todas las salas completadas después de activar este efecto reiniciarán a sus enemigos, permitiendo conseguir más recolectab;es#No aplica a salas de minijefes o los jefes al final del piso"},
--     {Id = 11, Name = "Jera", Description = "Los recolectables se duplican durante todo el piso"},
--     {Id = 12, Name = "Perthro", Description = "Cambia todos los pedestales y recolectables en el piso"},
--     {Id = 13, Name = "Gebo", Description = "Tendrás el efecto de la {{Collectible64}} oferta de Steam y {{Collectible376}} Reabastecimiento durante la sala (?)"},
--     {Id = 14, Name = "Othala", Description = "Cada jugador recibirá 2-3 objetos duplicados de su inventario de forma permanente"},
--     {Id = 15, Name = "Runa Negra", Description = "Al entrar a una sala, todos los enemigos recibirán 10 puntos de daño#Todos los recolectables generados se convertirán en moscas azules y todo pedestal futuro tendrá 50% de posibilidad de ser consumido, otorgando un aumento de estadísticas#El efecto dura todo el piso"}
-- }

-- local runeEffectsRu = {
--     {Id = 1, Name = "Хагалаз", Description = "Разрушает все камни на всём этаже"},
--     {Id = 2, Name = "Эваз", Description = "Создает 3 люка, которые ведут на следующий этаж, в сокровищницу и секретный магазин#Все закрытые двери становятся открытыми"},
--     {Id = 3, Name = "Дагаз", Description = "Даёт всем игрокам по 2 синих сердца и снимает все проклятия на этаже"},
--     {Id = 4, Name = "Ансуз", Description = "Отображает схему этажа#Открывает все проходы в секретные комнаты на этаже#Красные двери, ведущие в ультра секретную комнату, открыты"},
--     {
--         Id = 5,
--         Name = "Беркано",
--         Description = ((("Зачистив комнату призывает " .. tostring(Settings.FliesToSpawn)) .. " синих мух и ") .. tostring(Settings.SpidersToSpawn)) .. " синих пауков"
--     },
--     {Id = 6, Name = "Альгиз", Description = "Дает всем игрокам щит на 10 секунды при входе в комнату"},
--     {Id = 7, Name = "Кеназ", Description = "Отравляет всех врагов при входе в комнату"},
--     {Id = 8, Name = "Феху", Description = "Все враги получают эффект {{Collectible202}} Прикосновения Мидаса на 3 секунды при входе в комнату"},
--     {Id = 9, Name = "Ингваз", Description = "Все закрытые двери и сундуки автоматически открываются"},
--     {Id = 10, Name = "Совило", Description = "Все комнаты, зачищенные до активации, будут перебрасывать врагов один раз, позволяя собирать больше пикапов#Не применяется к комнатам с внезапными мини-боссами или комнатам с боссами в конце этажа"},
--     {Id = 11, Name = "Йера", Description = "Предметов становится в два раза больше на этаже"},
--     {Id = 12, Name = "Пертро", Description = "Меняет все пьедесталы и предметы на этаже"},
--     {Id = 13, Name = "Гебо", Description = "Эффекты {{Collectible64}} Распродажи в Стиме и {{Collectible376}} Пополнения на этаже (?)"},
--     {Id = 14, Name = "Отала", Description = "Каждый игрок навсегда получает копии 2-3 случайных своих существующих предметов"},
--     {Id = 15, Name = "Черная руна", Description = "При входе в новую комнату все враги получат 10 единиц урона. Все будущие предметы будут заменены синими мухами, а будущие пьедесталы будут потребляться на 50% и давать вам повышение характеристик. Эффект сохраняется на весь этаж"}
-- }

-- local runeFloorEffect = {Type = Isaac.GetEntityTypeByName("Rune Room Floor"), Variant = Isaac.GetEntityVariantByName("Rune Room Floor")}
-- local runeRoomOverlay

-- if StageAPI then
--     runeRoomOverlay = {
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay1.anm2", Vector(0.3,0),nil,Vector(1326,429)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay2.anm2", Vector(-0.3,0),nil,Vector(1324,429)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay3.anm2", Vector(-0.3,0),nil,Vector(1325,429)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay4.anm2", Vector(0,-0.3),nil,Vector(1324,702)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay5.anm2", Vector(0,0.4),nil,Vector(663,1402)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay6.anm2", Vector(0.3,0),nil,Vector(1326,702)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay7.anm2", Vector(-0.3,0),nil,Vector(1326,702)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay8.anm2", Vector(0,-0.4),nil,Vector(1170,858)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay9.anm2", Vector(0,0.4),nil,Vector(1170,858)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay10.anm2", Vector(0,0.3),nil,Vector(1169,857)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay11.anm2", Vector(0.5,0),nil,Vector(1952,578)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay12.anm2", Vector(0,-0.5),nil,Vector(976,1155)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay13.anm2", Vector(-0.5,0),nil,Vector(1951,578)),
--                             StageAPI.Overlay("gfx/overlays/runeRoomOverlay14.anm2", Vector(0,-0.4),nil,Vector(976,1155))
--                         }
-- end

-- local function renderDoors()
--     for ____, door in ipairs(getDoors()) do
--         if door.CurrentRoomType == RoomType.ROOM_DICE and not (door.TargetRoomType == RoomType.ROOM_SUPERSECRET or door.TargetRoomType == RoomType.ROOM_SECRET) 
--         or door.TargetRoomType == RoomType.ROOM_DICE and not (door.CurrentRoomType == RoomType.ROOM_SECRET or door.CurrentRoomType == RoomType.ROOM_SUPERSECRET) then
--             if data.run.effect > 0 then
--                 local sprite = door:GetSprite()
--                 sprite:ReplaceSpritesheet(0, "gfx/grid/door_runeRoom.png")
--                 sprite:ReplaceSpritesheet(1, "gfx/grid/door_runeRoom.png")
--                 sprite:ReplaceSpritesheet(2, "gfx/grid/door_runeRoom.png")
--                 sprite:ReplaceSpritesheet(3, "gfx/grid/door_runeRoom.png")
--                 sprite:ReplaceSpritesheet(4, "gfx/grid/door_runeRoom.png")
--                 sprite:LoadGraphics()
--             else
--                 local sprite = door:GetSprite()
--                 sprite:ReplaceSpritesheet(0, "gfx/grid/door_00_diceroomdoor.png")
--                 sprite:ReplaceSpritesheet(1, "gfx/grid/door_00_diceroomdoor.png")
--                 sprite:ReplaceSpritesheet(2, "gfx/grid/door_00_diceroomdoor.png")
--                 sprite:ReplaceSpritesheet(3, "gfx/grid/door_00_diceroomdoor.png")
--                 sprite:ReplaceSpritesheet(4, "gfx/grid/door_00_diceroomdoor.png")
--                 sprite:LoadGraphics()
--             end
--         end
--     end
-- end

-- local function RoomIcon()
--     do
--         local i = 1
--         while i <= 200 do
--             local currentDesc = Game():GetLevel():GetRoomByIdx(i)
--             local ____currentDesc_Data_Type_8 = currentDesc.Data
--             if ____currentDesc_Data_Type_8 ~= nil then
--                 ____currentDesc_Data_Type_8 = ____currentDesc_Data_Type_8.Type
--             end
--             if ____currentDesc_Data_Type_8 == RoomType.ROOM_DICE then
--                 local ____MinimapAPI_GetRoomByIdx_result_10 = MinimapAPI
--                 if ____MinimapAPI_GetRoomByIdx_result_10 ~= nil then
--                     ____MinimapAPI_GetRoomByIdx_result_10 = ____MinimapAPI_GetRoomByIdx_result_10:GetRoomByIdx(i)
--                 end
--                 local room = ____MinimapAPI_GetRoomByIdx_result_10
--                 if room ~= nil and data.run.effect > 0 then
--                     room.PermanentIcons = {"RuneRoom"}
--                 else
--                     room.PermanentIcons = {MinimapAPI:GetRoomTypeIconID(RoomType.ROOM_DICE)}
--                 end
--             end
--             i = i + 1
--         end
--     end
-- end

-- --Save
-- function mod:saveRun(isSaving)
-- 	if isSaving then
-- 		local save = {}
--         save.activated = data.run.activated
--         save.effect = data.run.effect
--         save.runified = data.run.runified
--         save.visited = data.run.visited
--         if data.run.lastDevilDealPlayer then
--             save.lastDevilDealPlayer = data.run.lastDevilDealPlayer
--         end
--         if #data.run.visitedRooms>0 then
--             save.visitedRooms = json.encode(data.run.visitedRooms)
--         end
--         mod:SaveData(json.encode(save))
-- 	end
-- end

-- --Load
-- function mod:loadRun(isContinuing)
--     if isContinuing and mod:HasData() then
-- 		local loading = json.decode(mod:LoadData())
--         data.run.activated = loading.activated
--         data.run.effect = loading.effect
--         data.run.runified = loading.runified
--         data.run.visited = loading.visited
--         if loading.lastDevilDealPlayer then
--             data.run.lastDevilDealPlayer = json.decode(loading.lastDevilDealPlayer)
--         end
--         if loading.visitedRooms then
--             data.run.visitedRooms = json.decode(loading.visitedRooms)
--         end
-- 	end
--     if data.run.effect > 0 then
--         if MinimapAPI then
--             RoomIcon()
--         end
--         renderDoors()
--         if Game():GetRoom():GetType() ~= RoomType.ROOM_DICE then
--             local rng = RNG()
--             rng:SetSeed(Random(),1)
--             randomOverlay = rng:RandomInt(#runeRoomOverlay)+1
--             runeRoomOverlay[randomOverlay]:SetAlpha(0)
--         else
--             loadingOverlay = true
--         end
--     end
-- end

-- --Room Icon
-- local runeRoomSprite = Sprite()
-- runeRoomSprite:Load("gfx/ui/minimapapi/runerooms_minimapicon.anm2", true)
-- if MinimapAPI ~= nil then
--     MinimapAPI:AddIcon("RuneRoom", runeRoomSprite, "CustomIconRuneRooms", 0, nil)
-- end


-- --Get players
-- local function getPlayers(performExclusions)
--     if performExclusions == nil then
--         performExclusions = false
--     end
--     local game = Game()
--     local players = {}
--     do
--         local i = 0
--         while i < game:GetNumPlayers() do
--             do
--                 local player = Isaac.GetPlayer(i)
--                 if player == nil then
--                     goto __continue53
--                 end
--                 if player.Parent ~= nil then
--                     goto __continue53
--                 end
--                 local character = player:GetPlayerType()
--                 if performExclusions and (character == PlayerType.PLAYER_ESAU or character == PlayerType.PLAYER_THESOUL_B) then
--                     goto __continue53
--                 end
--                 table.insert(players,player)
--             end
--             ::__continue53::
--             i = i + 1
--         end
--     end
--     return players
-- end

-- --Get effects
-- local function getEffects(matchingVariant, matchingSubType)
--     if matchingVariant == nil then
--         matchingVariant = -1
--     end
--     if matchingSubType == nil then
--         matchingSubType = -1
--     end
--     local entities = Isaac.FindByType(EntityType.ENTITY_EFFECT, matchingVariant, matchingSubType)
--     local effects = {}
--     for ____, entity in ipairs(entities) do
--         local effect = entity:ToEffect()
--         if effect ~= nil then
--             table.insert(effects,effect)
--         end
--     end
--     return effects
-- end

-- --Find closest player
-- local function getPlayerCloserThan(position, distance)
--     for ____, player in ipairs(getPlayers()) do
--         if player.Position:Distance(position) <= distance then
--             return player
--         end
--     end
--     return nil
-- end

-- --Find closest entity
-- local function anyEntityCloserThan(entities, position, distance)
--     for ____, entity in ipairs(entities) do
--         if position:Distance(entity.Position) <= distance then
--             return true
--         end
--     end
--     return false
-- end

-- --Find position
-- local function findFreePosition(startingPosition)
--     local game = Game()
--     local room = game:GetRoom()
--     local heavenDoors = getEffects(nil, EffectVariant.HEAVEN_LIGHT_DOOR, 0)
--     do
--         local i = 0
--         while i < 100 do
--             do
--                 local position = room:FindFreePickupSpawnPosition(startingPosition, i)
--                 local closePlayer = getPlayerCloserThan(position, 40)
--                 if closePlayer ~= nil then
--                     goto __continue3
--                 end
--                 local isCloseHeavenDoor = anyEntityCloserThan(heavenDoors, position, 40)
--                 if isCloseHeavenDoor then
--                     goto __continue3
--                 end
--                 return position
--             end
--             ::__continue3::
--             i = i + 1
--         end
--     end
--     return room:FindFreePickupSpawnPosition(startingPosition)
-- end

-- --Algiz
-- local function algizEffect()
--     local room = Game():GetRoom()
--     if room:GetType() == RoomType.ROOM_BOSS then
--         algizBossTimer = 1
--     end
--     if not room:IsClear() then
--         for ____, player in ipairs(getPlayers()) do
--             if not player:IsCoopGhost() then
--                 player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
--             end
--         end
--     end
-- end

-- --Morphing Dice room to Rune Room
-- local function morphDiceRoom()
--     local room = Game():GetRoom()
--     if StageAPI then
--         local runebackdrop = StageAPI.BackdropHelper({Walls = {data.run.effect}}, "gfx/backdrop/runeroom_", ".png")
--         StageAPI.GridGfx:SetGrid("gfx/grid/rocks_rune.png", GridEntityType.GRID_ROCK)
--         if data.run.effect == 15 then
--             StageAPI.GridGfx:SetGrid("gfx/grid/rocks_depths.png", GridEntityType.GRID_ROCK)
--         end
--         local roomGfx = StageAPI.RoomGfx(runebackdrop, StageAPI.GridGfx)
--         StageAPI.ChangeRoomGfx(roomGfx)
--     end
--     for ____, floor in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR)) do
--         floor:Remove()
--     end
--     local runeFloors = Isaac.Spawn(EntityType.ENTITY_EFFECT,runeFloorEffect.Variant,0,room:GetCenterPos(),Vector.Zero,nil):ToEffect()
--     if EID and not data.run.activated then
--         EID:addEntity(EntityType.ENTITY_EFFECT,runeFloorEffect.Variant,0, "Rune Effect: "..runeEffects[data.run.effect].Name, runeEffects[data.run.effect].Description)
--         EID:addEntity(EntityType.ENTITY_EFFECT,runeFloorEffect.Variant,0, "Эффект руны: "..runeEffectsRu[data.run.effect].Name, runeEffectsRu[data.run.effect].Description,"ru")
-- 		EID:addEntity(EntityType.ENTITY_EFFECT,runeFloorEffect.Variant,0, "Sala Rúnica: "..runeEffectsSpa[data.run.effect].Name, runeEffectsSpa[data.run.effect].Description, "spa")
--     end
--     local sprite = runeFloors:GetSprite()
--     if data.run.effect == 15 then
--         sprite:ReplaceSpritesheet(0,"gfx/effects/blackruneFloor.png")
--         sprite:LoadGraphics()
--     end
--     sprite:Play(data.run.effect, true)
--     runeFloors.DepthOffset = -200
-- end

-- --Grid functions for hagalaz
-- local function isGrid(grid,gridEntityTypes) --Lua variant instead of IsaacScript function
-- 	for _,thisgrid in ipairs(gridEntityTypes) do
-- 		if grid == thisgrid then
-- 			return true		
-- 		end
-- 	end
-- 	return false
-- end

-- local function getGridEntities(...)
--     local gridEntityTypes = {...}
--     local game = Game()
--     local room = game:GetRoom()
--     local gridSize = room:GetGridSize()
--     local gridEntities = {}
--     do
--         local gridIndex = 0
--         while gridIndex < gridSize do
--             do
--                 local gridEntity = room:GetGridEntity(gridIndex)
--                 if gridEntity == nil then
--                     goto __continue7
--                 end
--                 if #gridEntityTypes == 0 then
--                     table.insert(gridEntities, gridEntity)
--                 else
--                     local thisGridEntityType = gridEntity:GetType()
--                     if isGrid(thisGridEntityType,gridEntityTypes) then
--                         table.insert(gridEntities, gridEntity)
--                     end
--                 end
--             end
--             ::__continue7::
--             gridIndex = gridIndex + 1
--         end
--     end
--     return gridEntities
-- end

-- --Hagalaz
-- local function hagalazEffect()
--     for ____, grid in ipairs(getGridEntities()) do
--         if grid:ToRock() ~= nil then
--             grid:Destroy(true)
--         end
--     end
-- end

-- --Ehwaz
-- local function spawnTrapDoors()
--     Game():GetRoom():TrySpawnSecretShop(true)
--     Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, findFreePosition(Settings.EhwazTrapDoorPosition), true)
--     Isaac.GridSpawn(GridEntityType.GRID_STAIRS, 0, findFreePosition(Settings.EhwazCrawlspacePosition), true)
-- end

-- --Open Sesame
-- local function tryUnlockDoors()
--     if not Game():GetRoom():IsClear() then
--         return
--     end
--     for ____, door in ipairs(getDoors()) do
--         if door:IsLocked() then
--             door:TryUnlock(Isaac.GetPlayer(0), true)
--         end
--     end
-- end

-- --Kenaz
-- local function kenazEffect()
--     Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, 0, false, nil, nil)
--     Isaac.GetPlayer(0):RemoveCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, nil, nil, true)
-- end

-- --Fehu
-- local function fehuEffect()
--     for ____, enemy in ipairs(Isaac.GetRoomEntities()) do
--         if enemy:IsEnemy() and enemy:IsVulnerableEnemy() then
--             enemy:AddMidasFreeze(EntityRef(nil), 30 * 3)
--         end
--     end
-- end
	
-- --Lua variant instead of IsaacScript function to get chest variant
-- local function isChest(pickup)
-- 	local CHEST_PICKUP_VARIANTS = {PickupVariant.PICKUP_CHEST, PickupVariant.PICKUP_BOMBCHEST, PickupVariant.PICKUP_SPIKEDCHEST, PickupVariant.PICKUP_ETERNALCHEST, PickupVariant.PICKUP_MIMICCHEST, PickupVariant.PICKUP_OLDCHEST, PickupVariant.PICKUP_WOODENCHEST, PickupVariant.PICKUP_MEGACHEST, PickupVariant.PICKUP_HAUNTEDCHEST, PickupVariant.PICKUP_LOCKEDCHEST, PickupVariant.PICKUP_REDCHEST, PickupVariant.PICKUP_MOMSCHEST}    
-- 	for _,chest in ipairs(CHEST_PICKUP_VARIANTS) do
-- 		if pickup.Variant == chest then
-- 			return true		
-- 		end
-- 	end
-- 	return false
-- end

-- local function isInList(isin,list)
-- 	for _,item in ipairs(list) do
-- 		if isin == item then
-- 			return true		
-- 		end
-- 	end
-- 	return false
-- end

-- --Ingwaz
-- local function ingwazEffect()
--     tryUnlockDoors()
--     for ____, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
--         if isChest(pickup) then
--             pickup:ToPickup():TryOpenChest()
--         end
--     end
-- end

-- --Sowilo
-- local function sowiloEffect()
--     local room = Game():GetRoom()
--     local level = Game():GetLevel()
--     local roomDescriptor = level:GetCurrentRoomDesc()
--     local visitedCount = roomDescriptor.VisitedCount
--     local listIndex = roomDescriptor.ListIndex
--     local willAdd = true
--     if not data.run.activated and not roomDescriptor.SurpriseMiniboss and not room:IsCurrentRoomLastBoss() then
--         for ____, info in ipairs(data.run.visitedRooms) do
--             if info.Index == listIndex then
--                 willAdd = false
--                 break
--             end
--         end
--         if willAdd then
--             table.insert(data.run.visitedRooms, {Index = listIndex, VisitCount = visitedCount})
--         end
--     end
--     if data.run.activated then
--         local willRespawn = false
--         for ____, info in ipairs(data.run.visitedRooms) do
--              if info.Index == roomDescriptor.ListIndex and info.VisitCount == roomDescriptor.VisitedCount - 1 then   
--                 willRespawn = true
--                 break
--             end
--         end
--         if willRespawn then
--             Game():GetRoom():RespawnEnemies()
--         end
--     end
-- end

-- --Jera and Perthro
-- local function GetMaxCollectibleID()
--     return Isaac.GetItemConfig():GetCollectibles().Size - 1
-- end

-- local function GetMaxTrinketID()
--     return Isaac.GetItemConfig():GetTrinkets().Size - 1
-- end

-- local function GetMaxCardID()
--     return Isaac.GetItemConfig():GetCards().Size - 1
-- end

-- local function Shuffle(list)
-- 	local size, shuffled  = #list, list
--     for i = size, 2, -1 do
-- 		local j = math.random(i)
-- 		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
-- 	end
--     return shuffled
-- end

-- local function getCards(rng)
-- 	local pickup = {variant=nil,subtype=nil}
-- 		pickup.variant = PickupVariant.PICKUP_TAROTCARD
-- 		pickup.subtype = rng:RandomInt(GetMaxCardID()) + 1
-- 	return pickup
-- end

-- local function getPills(rng)
-- 	local pickup = {variant=nil,subtype=nil}
-- 	pickup.variant = PickupVariant.PICKUP_PILL
-- 	pickup.subtype = rng:RandomInt(PillColor.NUM_PILLS) + 1
-- 	if rng:RandomFloat() <= 0.05 then
-- 		pickup.subtype = PillColor.PILL_GIANT_FLAG + pickup.subtype
-- 	end
-- 	return pickup
-- end

-- local function getBombs(rng)
-- 	local pickup = {variant=nil,subtype=nil}
-- 	pickup.variant = PickupVariant.PICKUP_BOMB
-- 	pickup.subtype = rng:RandomInt(6) + 1
-- 	return pickup
-- end

-- local function getKeys(rng)
-- 	local pickup = {variant=nil,subtype=nil}
-- 	pickup.variant = PickupVariant.PICKUP_KEY
--     pickup.subtype = rng:RandomInt(4) + 1
-- 	return pickup
-- end

-- local function getCoins(rng)
-- 	local pickup = {variant=nil,subtype=nil}
-- 	pickup.variant = PickupVariant.PICKUP_COIN
--     pickup.subtype = rng:RandomInt(7) + 1
-- 	return pickup
-- end

-- local function getBatteries(rng)
-- 	local pickup = {variant=nil,subtype=nil}
-- 	pickup.variant = PickupVariant.PICKUP_LIL_BATTERY
-- 	pickup.subtype = rng:RandomInt(4) + 1
--     return pickup
-- end

-- local function getHearts(rng)
-- 	local pickup = {variant=nil,subtype=nil}
-- 	pickup.variant = PickupVariant.PICKUP_HEART
-- 	pickup.subtype = rng:RandomInt(7) + 1
-- 	return pickup
-- end

-- local function MyRandomPickup(rng)
-- 	local pickup = {variant=nil,subtype=nil}
--     local randPickup = {getCards,getBatteries,getCoins,getKeys,getBombs,getPills,getHearts}
--     randPickup = Shuffle(randPickup)
--     local fn = randPickup[rng:RandomInt(#randPickup)+1]
--     pickup = fn(rng)
-- 	return pickup
-- end

-- local function jeraPerthroBlackEffect()
--     local level = Game():GetLevel()
--     local roomDescriptor = level:GetCurrentRoomDesc()
--     local visitedCount = roomDescriptor.VisitedCount
--     local listIndex = roomDescriptor.ListIndex
--     local willAdd = true
--     if data.run.activated then
--         for ____, info in ipairs(data.run.visitedRooms) do
--             if info.Index == listIndex then
--                 willAdd = false
--                 break
--             end
--         end
--         if willAdd then
--             if data.run.effect == 11 then
--                 Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_DIPLOPIA, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
--             end
--             if data.run.effect == 12 then
--                 for _,pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
--                     pickup = pickup:ToPickup()
--                     local rng = RNG()
--                     rng:SetSeed(Random(),1)
--                     if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE or pickup.Variant == PickupVariant.PICKUP_TRINKET then
--                         local number = pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and GetMaxCollectibleID() or GetMaxTrinketID()
--                         pickup:Morph(pickup.Type,pickup.Variant,rng:RandomInt(number) + 1,true)
--                     else
--                         local pickups = {10,20,30,40,50,51,52,53,54,55,56,57,58,60,69,70,90,300,360}
--                         pickups = Shuffle(pickups)
--                         local newpickup = {variant = nil,subtype = nil}
--                         newpickup.variant = pickups[rng:RandomInt(#pickups)+1]
--                         if newpickup.variant < 41 or pickup.variant == 70 or pickup.variant == 90 or pickup.variant == 300 then
--                             newpickup = MyRandomPickup(rng)
--                         else
--                             newpickup.subtype = 0
--                         end
--                         pickup:Morph(pickup.Type,newpickup.variant,newpickup.subtype,true)
--                     end
--                 end
--             end
--             if data.run.effect == 15 then
--                 local rng = RNG()
--                 rng:SetSeed(Random(),1)
--                 local pickups = {10,20,30,40,50,51,52,53,54,55,56,57,58,60,69,70,90,300,350,360}
--                 for _,pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
--                     pickup = pickup:ToPickup()
--                     if not pickup:IsShopItem() then
--                         if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
--                             pickup:Remove()
--                             Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,pickup.Position,Vector.Zero,nil)
--                         elseif isInList(pickup.Variant,pickups) then
--                             pickup:Remove()
--                             Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.BLUE_FLY,0,pickup.Position,Vector.Zero,Isaac.GetPlayer(rng:RandomInt(Game():GetNumPlayers())))
--                         end
--                     end
--                 end
--             end
--             table.insert(data.run.visitedRooms, {Index = listIndex, VisitCount = visitedCount})
--         end
--     end
-- end

-- --Othala
-- local function othalaEffect()
--     local game = Game()
--     for p = 1, game:GetNumPlayers() do
--         local player = Isaac.GetPlayer(p-1)
--         if player:GetCollectibleCount() > 0 and not player:IsCoopGhost() then
--             local playersItems = {}
--             for item = 1,GetMaxCollectibleID() do
--                 local itemConf = Isaac.GetItemConfig():GetCollectible(item)
--                 if player:HasCollectible(item) and itemConf.Type ~= ItemType.ITEM_ACTIVE 
--                 and (itemConf.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST)
--                 then
--                     table.insert(playersItems,item)
--                 end
--             end
--             playersItems = Shuffle(playersItems)
--             if #playersItems > 1 then
--                 local rng = RNG()
--                 rng:SetSeed(Random(),1)
--                 for i = 1,rng:RandomInt(2)+2 do
--                     rng:SetSeed(Random(),1)
--                     local randomItem = rng:RandomInt(#playersItems)+1
--                     player:AddCollectible(playersItems[randomItem])
--                     table.remove(playersItems,randomItem)
--                 end
--             elseif #playersItems == 1 then
--                 player:AddCollectible(playersItems[1])
--             end
--         end
--     end
-- end

-- local function geboEffect()
--     if data.run.effect == 13 then
--         for _,pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
--             pickup = pickup:ToPickup()
--             if pickup:IsShopItem() then
--                 if pickup.Price > 0 and pickup.AutoUpdatePrice then
--                     local isSteamSale = false
--                     for _,player in ipairs(getPlayers()) do
--                         if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
--                             isSteamSale = true
--                         end
--                     end
--                     if not isSteamSale then
--                         pickup.AutoUpdatePrice = false
--                         pickup.Price = math.floor(pickup.Price/2) > 0 and math.floor(pickup.Price/2) or 1
--                     end
--                 elseif pickup.Price < 0 and pickup.Price > -4 then
--                     local highhp = 0
--                     if not data.run.lastDevilDealPlayer then
--                         for _,player in ipairs(getPlayers()) do
--                             if highhp < player:GetMaxHearts() + player:GetBoneHearts() then
--                                 local bones = 0
--                                 if player:GetPlayerType() ~= PlayerType.PLAYER_BLACKJUDAS and 
--                                 player:GetPlayerType() ~= PlayerType.PLAYER_JUDAS_B and 
--                                 player:GetPlayerType() ~= PlayerType.PLAYER_XXX and 
--                                 player:GetPlayerType() ~= PlayerType.PLAYER_XXX_B and 
--                                 player:GetPlayerType() ~= PlayerType.PLAYER_BETHANY_B and 
--                                 player:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B then
--                                     bones = player:GetBoneHearts()
--                                 end
--                                 highhp = player:GetMaxHearts() + bones
--                             end
--                         end
--                     else
--                         local bones = 0
--                         if player:GetPlayerType() ~= PlayerType.PLAYER_BLACKJUDAS and 
--                         player:GetPlayerType() ~= PlayerType.PLAYER_JUDAS_B and 
--                         player:GetPlayerType() ~= PlayerType.PLAYER_XXX and 
--                         player:GetPlayerType() ~= PlayerType.PLAYER_XXX_B and 
--                         player:GetPlayerType() ~= PlayerType.PLAYER_BETHANY_B and 
--                         player:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B then
--                             bones =  data.run.lastDevilDealPlayer:GetBoneHearts()
--                         end
--                         highhp =  data.run.lastDevilDealPlayer:GetMaxHearts() + bones
--                     end
--                     if (pickup.Price == -1 or pickup.Price == -2 or pickup.Price == -4) and highhp > 0 and pickup.AutoUpdatePrice then
--                         pickup.AutoUpdatePrice = false
--                         pickup.Price = -1
--                     elseif highhp == 0 and not pickup.AutoUpdatePrice then
--                         pickup.AutoUpdatePrice = true
--                     end
--                 end
--             end
--         end
--     end
-- end

-- local function geboDevilPickupEffect(_,pickup,entity)
--     if data.run.effect == 13 then
--         if entity.Type == EntityType.ENTITY_PLAYER then
--             local player = entity:ToPlayer()
--             if pickup:IsShopItem() and not player:IsCoopGhost() and pickup.Price > -4 and pickup.Price < 0 then
--                 for _,pickups in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
--                     if pickups.Price > -4 and pickups.Price < 0 then
--                         pickups = pickups:ToPickup()
--                         pickups.AutoUpdatePrice = true
--                     end
--                 end
--                 data.run.lastDevilDealPlayer = player
--             end
--         end
--     end
-- end


-- --Dagaz
-- local function dagazEffect()
--     local level = Game():GetLevel()
--     for ____, player in ipairs(getPlayers()) do
--         if not player:IsCoopGhost() then
--             player:AddSoulHearts(6)
--         end
--     end
--     level:RemoveCurses(level:GetCurses())
-- end

-- --Ansus
-- local function ansuzEffect()
--     local level = Game():GetLevel()
--     local rooms = level:GetRooms()
--     level:SetCanSeeEverything(true)
--     do
--         local i = 1
--         while i <= 200 do
--             local currentDesc = level:GetRoomByIdx(i)
--             if currentDesc.Data ~= nil then
--                 currentDesc.DisplayFlags = 1 | 4
--             end
--             i = i + 1
--         end
--     end
--     do
--         local i = 1
--         while i <= math.random(Settings.RedKeysToSpawn[1], Settings.RedKeysToSpawn[2]) do
--             Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, findFreePosition(Isaac.GetRandomPosition()), Vector.Zero, nil)
--             i = i + 1
--         end
--     end
--     level:UpdateVisibility()
-- end

-- --Unlocking chest when Ingwaz effect is active
-- function mod:pickupInit()
--     if data.run.activated and data.run.effect == 9 then
--         ingwazEffect()
--     end
-- end

-- --Berkano
-- local function berkanoEffect()
--     for ____, player in ipairs(getPlayers()) do
--         if not player:IsCoopGhost() then
--             do
--                 local i = 1
--                 while i <= Settings.SpidersToSpawn do
--                     player:AddBlueSpider(player.Position)
--                     i = i + 1
--                 end
--             end
--             player:AddBlueFlies(Settings.FliesToSpawn, player.Position, nil)
--         end
--     end
-- end

-- --Room cleared
-- function mod:roomClear()
--     if data.run.activated then
--         repeat
--             local ____switch57 = data.run.effect
--             local ____cond57 = ____switch57 == 2
--             if ____cond57 then
--                 tryUnlockDoors()
--                 break
--             end
--             ____cond57 = ____cond57 or ____switch57 == 5
--             if ____cond57 then
--                 berkanoEffect()
--                 break
--             end
--             ____cond57 = ____cond57 or ____switch57 == 9
--             if ____cond57 then
--                 tryUnlockDoors()
--                 break
--             end
--             do
--                 break
--             end
--         until true
--     end
-- end

-- --new room effect
-- function mod:newRoom()
--     print(data.run.effect)
--     if data.run.effect > 0 then
--         local room = Game():GetRoom()
--         local effectInformation = runeEffects[data.run.effect]
--         local overlay = runeRoomOverlay[randomOverlay]
--         if effectInformation.Id == 10 and not data.run.activated then
--             sowiloEffect()
--         end
--         if room:GetType() == RoomType.ROOM_DICE then
--             data.run.runified = true
--             morphDiceRoom()
--             if not data.run.visited and overlay then
--                 data.run.visited = true
--                 overlay:Fade(80,0,1)
--             end
--         elseif data.run.visited and overlay then
--             overlay:Fade(80,80,-1)
--             data.run.visited = false
--         elseif overlay then
--             overlay:Fade(1,1,-1)
--         end
--         if data.run.activated then
--             repeat
--                 local ____switch31 = effectInformation.Id
--                 local ____cond31 = ____switch31 == 1
--                 if ____cond31 then
--                     hagalazEffect()
--                     break
--                 end
--                 ____cond31 = ____cond31 or ____switch31 == 2
--                 if ____cond31 then
--                     tryUnlockDoors()
--                     break
--                 end
--                 ____cond31 = ____cond31 or ____switch31 == 6
--                 if ____cond31 then
--                     algizEffect()
--                     break
--                 end
--                 ____cond31 = ____cond31 or ____switch31 == 7
--                 if ____cond31 then
--                     kenazEffect()
--                     break
--                 end
--                 ____cond31 = ____cond31 or ____switch31 == 8
--                 if ____cond31 then
--                     fehuEffect()
--                     break
--                 end
--                 ____cond31 = ____cond31 or ____switch31 == 9
--                 if ____cond31 then
--                     ingwazEffect()
--                     break
--                 end
--                 ____cond31 = ____cond31 or ____switch31 == 10
--                 if ____cond31 then
--                     sowiloEffect()
--                     break
--                 end
--                 ____cond31 = ____cond31 or ____switch31 == 11 or ____switch31 == 12 or ____switch31 == 15
--                 if ____cond31 then
--                     if ____switch31 == 15 then
--                         Game():ShakeScreen(5)
--                     end
--                     jeraPerthroBlackEffect()
--                     break
--                 end
--                 ____cond31 = ____cond31 or ____switch31 == 13
--                 if ____cond31 then
--                     geboEffect()
--                     break
--                 end
--                 do
--                     break
--                 end
--             until true
--         end
--         renderDoors()
--     else
--         local overlay = runeRoomOverlay[1]
--         overlay:Fade(5,5,-1)
--     end
-- end

-- --Reset floor values
-- function mod:newLevel()
--     data.run.activated = false
--     data.run.visitedRooms = {}
--     local rng = RNG()
--     rng:SetSeed(Random(),1)

--     if rng:RandomInt(3) == 1 then
--         data.run.effect = rng:RandomInt(#runeEffects)+1
--         randomOverlay = rng:RandomInt(#runeRoomOverlay)+1
--         runeRoomOverlay[randomOverlay]:Fade(1,1,-1)
--         RoomIcon()
--         renderDoors()
--     else
--         data.run.effect = 0
--         if randomOverlay > 0 then
--             runeRoomOverlay[randomOverlay]:Fade(1,1,-1)
--         end
--         randomOverlay = 0
--         renderDoors()
--     end
--     if randomOverlay > 0 then
--         runeRoomOverlay[randomOverlay]:Fade(1,1,-1)
--     end
--     data.run.runified = false
--     data.run.lastDevilDealPlayer = nil
-- end


-- --Update rune effect
-- function mod:effectUpdate(runeFloor)
--     local room = Game():GetRoom()
--     if room:GetType() == RoomType.ROOM_DICE and data.run.runified then
--         if not data.run.activated then
--             for ____, player in ipairs(getPlayers()) do
--                 if player.Position:Distance(room:GetCenterPos()) <= Settings.ActivationRange and not player:IsCoopGhost() then
--                     Game():ShakeScreen(45)
--                     Game():Darken(1, 45)
--                     data.run.activated = true
--                     repeat
--                         local ____switch47 = data.run.effect
--                         local ____cond47 = ____switch47 == 1
--                         if ____cond47 then
--                             hagalazEffect()
--                             break
--                         end
--                         ____cond47 = ____cond47 or ____switch47 == 2
--                         if ____cond47 then
--                             spawnTrapDoors()
--                             break
--                         end
--                         ____cond47 = ____cond47 or ____switch47 == 3
--                         if ____cond47 then
--                             dagazEffect()
--                             break
--                         end
--                         ____cond47 = ____cond47 or ____switch47 == 4
--                         if ____cond47 then
--                             ansuzEffect()
--                             break
--                         end
--                         ____cond47 = ____cond47 or ____switch47 == 11 or ____switch47 == 12 or ____switch47 == 15
--                         if ____cond47 then
--                             jeraPerthroBlackEffect()
--                             break
--                         end
--                         ____cond47 = ____cond47 or ____switch47 == 14
--                         if ____cond47 then
--                             othalaEffect()
--                             break
--                         end
--                         do
--                             break
--                         end
--                     until true
--                     break
--                 end
--             end
--         end
--     end
--     if data.run.activated then
--         if data.run.effect == 6 then 
--             if algizBossTimer == 1 and not room:IsClear() then
--                 algizBossTimer = -1
--                 for _,player in ipairs(getPlayers()) do
--                     if not player:IsCoopGhost() then
--                         player:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
--                     end
--                 end
--             end
--         end
--         if data.run.effect == 13 then
--             geboEffect()
--         end
--     end
-- end


-- function mod:RoomOverlay()
--     if StageAPI then
--         local overlay = runeRoomOverlay[randomOverlay]
--         if data.run.effect > 0 and randomOverlay > 0 then
--             if not Game():IsPaused() then
--                 overlay:Update()
--             end
--             overlay:Render(true,nil,true)
--             if loadingOverlay and Game:GetRoom():GetType() == RoomType.ROOM_DICE then
--                 loadingOverlay = false
--                 overlay:Fade(1,0,1)
--             end
--         end
--     end
-- end

-- mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RoomOverlay)
-- mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.newRoom)
-- mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.effectUpdate)
-- mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.newLevel)
-- mod:AddCallback(ModCallbacks.MC_POST_UPDATE, geboEffect)
-- mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, geboDevilPickupEffect, PickupVariant.PICKUP_COLLECTIBLE)
-- --mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, tryUnlockDoors)
-- mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.roomClear)
-- mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.pickupInit)
-- mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.saveRun)
-- mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.loadRun)
