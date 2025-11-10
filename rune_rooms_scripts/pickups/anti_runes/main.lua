local Runes = {}

include("rune_rooms_scripts.pickups.anti_runes.gebo.main")

local GiantBookColors = {
	["poof2"] = Color(0, 0, 0, 0.8, 0, 0, 0),
	["poof"] = Color(0.2, 0.1, 0.3, 1, 0, 0, 0),
	["bg"] = Color(0.117, 0.0117, 0.2, 1, 0, 0, 0),
}

local function Shuffle(list)
    local size, shuffled  = #list, list
    for i = size, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    return shuffled
end

--ripairs stuff from revel
function ripairs_it(t,i)
    i=i-1
    local v=t[i]
    if v==nil then return v end
    return i,v
end
function ripairs(t)
    return ripairs_it, t, #t+1
end

local function GetMaxCollectibleID()
    return Isaac.GetItemConfig():GetCollectibles().Size -1
end

local function GetMaxTrinketID()
    return Isaac.GetItemConfig():GetTrinkets().Size -1
end

local function magicchalk_3f(player)
	local magicchalk = Isaac.GetItemIdByName("Magic Chalk")
	return magicchalk > 0 and player:HasCollectible(magicchalk)
end

local function PlaySND(sound, rng)
	if not rng then
		rng = RNG()
		rng:SetSeed(math.max(1, Isaac.GetFrameCount()), 35)
	end
	if Options.AnnouncerVoiceMode == 2 or Options.AnnouncerVoiceMode == 0 and rng:RandomInt(4) == 0 then
		SFXManager():Play(sound, 1, 0)
	end
end

local function playGiantBook(gfx, sfx, p, rng)
	if REPENTOGON then
		ItemOverlay.Show(Isaac.GetGiantBookIdByName(gfx), 0, p)
		PlaySND(sfx, rng)
	else
		local sound = nil
		if Options.AnnouncerVoiceMode == 2 or Options.AnnouncerVoiceMode == 0 and rng:RandomInt(4) == 0 then
			sound = sfx
		end
		local bookAPI = RuneRooms:GetCustomVanillaGiantbookAPI()
		if GiantBookAPI and bookAPI == 1 then
			GiantBookAPI.playGiantBook(
				"Appear",
				gfx .. ".png",
				GiantBookColors["poof"],
				GiantBookColors["bg"],
				GiantBookColors["poof2"],
				sound
			)
		elseif bookAPI ~= 1 or not GiantBookAPI then
			if ScreenAPI and bookAPI == 2 then
				ScreenAPI.PlayGiantbook("gfx/ui/giantbook/" .. gfx .. ".png", "Appear", p, Isaac.GetItemConfig():GetCard(Isaac.GetCardIdByName(gfx)), GiantBookColors)
			end
			if sound then
				SFXManager():Play(sound, 1, 0)
			end
		end
	end
end

function Runes:UseGebo(gebo, player, useflags)
	local rng = player:GetCardRNG(gebo)
	playGiantBook("Gebo", RuneRooms.Enums.SoundEffect.RUNE_GEBO, player, rng)
	local slots = {}
	for _, slot in ripairs(Isaac.GetRoomEntities()) do
		if Gebo.IsGeboSlot(slot) then
			table.insert(slots, slot)
		end
	end
	for _, slot in ipairs(slots) do
		if slot:GetSprite():GetAnimation() ~= "Broken" and slot:GetSprite():GetAnimation() ~= "Death" then
			if Gebo.GetGeboSlot(slot).REPENTOGON then
				if not Gebo.GetData(slot).GeboUses then
					Gebo.GetData(slot).GeboUses = 0
				end
				Gebo.GetData(slot).GeboUses = Gebo.GetData(slot).GeboUses + Gebo.GetGeboSlot(slot).Plays
			else
				if not Gebo.GetData(slot).Gebo then
					local rng = slot:GetDropRNG()
					Gebo.GetData(slot).Gebo = { Uses = Gebo.GetGeboSlot(slot).Plays, rng = rng, Player = player }
				else
					Gebo.GetData(slot).Gebo.Uses = Gebo.GetData(slot).Gebo.Uses + Gebo.GetGeboSlot(slot).Plays
				end
			end
		end
	end
	if magicchalk_3f(player) and rng:RandomInt(2) == 0 and #slots > 0 then
		local slot = slots[rng:RandomInt(#slots) + 1]
		if Gebo.IsGeboSlot(slot) then
			local rng = slot:GetDropRNG()
			local newslot = Isaac.Spawn(
				slot.Type,
				slot.Variant,
				slot.SubType,
				Game():GetRoom():FindFreeTilePosition(slot.Position, 9999),
				Vector.Zero,
				nil
			)
			if Gebo.GetGeboSlot(slot).REPENTOGON then
				Gebo.GetData(newslot).GeboUses = Gebo.GetGeboSlot(slot).Plays
			else
				Gebo.GetData(newslot).Gebo = { Uses = Gebo.GetGeboSlot(slot).Plays, rng = rng, Player = player }
			end
			SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0, false)
		end
	end
end
RuneRooms:AddCallback(ModCallbacks.MC_USE_CARD, Runes.UseGebo, RuneRooms.Enums.Runes.GEBO)

function Runes:UseKenaz(kenaz, player, useflags)
	local rng = player:GetCardRNG(kenaz)
	playGiantBook("Kenaz", RuneRooms.Enums.SoundEffect.RUNE_KENAZ, player, rng)
	player:AddCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, 0, false, 0, 0)
	player:RemoveCollectible(CollectibleType.COLLECTIBLE_TOXIC_SHOCK, true, 0, true)
	if magicchalk_3f(player) then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_BEAN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	end
end
RuneRooms:AddCallback(ModCallbacks.MC_USE_CARD, Runes.UseKenaz, RuneRooms.Enums.Runes.KENAZ)

function Runes:UseFehu(fehu, player, useflags)
	local rng = player:GetCardRNG(fehu)
	playGiantBook("Fehu", RuneRooms.Enums.SoundEffect.RUNE_FEHU, player, rng)
	local entities = {}
	for _, e in pairs(Isaac.GetRoomEntities()) do
		if
			e:IsActiveEnemy(false)
			and e:IsEnemy()
			and e:IsVulnerableEnemy()
			and not EntityRef(e).IsCharmed
			and not EntityRef(e).IsFriendly
		then
			table.insert(entities, e)
		end
	end
	local div = magicchalk_3f(player) and 1 or 2
	entities = Shuffle(entities)
	for i = 1, math.ceil(#entities / div) do
		entities[i]:AddMidasFreeze(EntityRef(player), 300 / div)
	end
	Game():GetRoom():TurnGold()
end
RuneRooms:AddCallback(ModCallbacks.MC_USE_CARD, Runes.UseFehu, RuneRooms.Enums.Runes.FEHU)

function Runes:UseOthala(othala, player, useflags)
	local data = player:GetData()
	local rng = player:GetCardRNG(othala)
	playGiantBook("Othala", RuneRooms.Enums.SoundEffect.RUNE_OTHALA, player, rng)
	if REPENTOGON then
		local itemConfig = Isaac.GetItemConfig()
		local history = player:GetHistory()
		---@type table
		local collectHistory = history:GetCollectiblesHistory()

		local itemsTable = collectHistory
		local index, item, collectConfig
		local itemsToGet = magicchalk_3f(player) and 2 or 1
		for _ = 1, itemsToGet do
			repeat
				index = rng:RandomInt(rng:RandomInt(#itemsTable)) + 1
				item = itemsTable[index]:GetItemID()
				collectConfig = itemConfig:GetCollectible(item)
				if
					collectConfig.Hidden
					or collectConfig.Type == ItemType.ITEM_ACTIVE
					or collectConfig:HasTags(ItemConfig.TAG_QUEST)
				then
					table.remove(itemsTable, index)
					index = nil
				end
			until index or #itemsTable == 0
			if index then
				if not data.OthalaClone then
					data.OthalaClone = {}
				end
				table.insert(data.OthalaClone, item)
			end
			index = nil
		end
	else
		if player:GetCollectibleCount() > 0 then
			local playersItems = {}
			for item = 1, GetMaxCollectibleID() do
				local itemConfig = Isaac.GetItemConfig():GetCollectible(item)
				if
					player:HasCollectible(item)
					and itemConfig.Type ~= ItemType.ITEM_ACTIVE
					and itemConfig.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST
					and not itemConfig.Hidden
				then
					for _ = 1, player:GetCollectibleNum(item, true) do
						table.insert(playersItems, item)
					end
				end
			end
			playersItems = Shuffle(playersItems)
			if #playersItems > 0 then
				local randomItem = player:GetCardRNG(othala):RandomInt(#playersItems) + 1
				--player:AddCollectible(playersItems[randomItem])
				data.OthalaClone = {}
				table.insert(data.OthalaClone, playersItems[randomItem])
			end
			if magicchalk_3f(player) then
				if #playersItems > 0 then
					local randomItem = player:GetCardRNG(othala):RandomInt(#playersItems) + 1
					table.insert(data.OthalaClone, playersItems[randomItem])
				end
			end
		end
	end
end
RuneRooms:AddCallback(ModCallbacks.MC_USE_CARD, Runes.UseOthala, RuneRooms.Enums.Runes.OTHALA)

local function PickingUp(player)
	local s = player:GetSprite()
	if s:GetAnimation():sub(1, 8) == "PickWalk" then
		return true
	end
	return false
end

function Runes:OthalaDuplicatePickup(player)
	local data = player:GetData()
	if data.OthalaClone then
		if not PickingUp(player) and not player.QueuedItem.Item then
			player:AnimateCollectible(data.OthalaClone[1], "UseItem", "PlayerPickup")
			SFXManager():Play(SoundEffect.SOUND_POWERUP1, 1, 0)
			player:QueueItem(Isaac.GetItemConfig():GetCollectible(data.OthalaClone[1]))
			table.remove(data.OthalaClone, 1)
		end
		if #data.OthalaClone == 0 then
			data.OthalaClone = nil
		end
	end
end
RuneRooms:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Runes.OthalaDuplicatePickup)

function Runes:UseSowilo(sowilo, player, useflags)
	local rng = player:GetCardRNG(sowilo)
	playGiantBook("Sowilo", RuneRooms.Enums.SoundEffect.RUNE_SOWILO, player, rng)

	if magicchalk_3f(player) then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	else
		player:UseActiveItem(CollectibleType.COLLECTIBLE_D7, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	end
end
RuneRooms:AddCallback(ModCallbacks.MC_USE_CARD, Runes.UseSowilo, RuneRooms.Enums.Runes.SOWILO)

function Runes:UseIngwaz(ingwaz, player, useflags)
	local entities = Isaac:GetRoomEntities()
	local rng = player:GetCardRNG(ingwaz)
	playGiantBook("Ingwaz", RuneRooms.Enums.SoundEffect.RUNE_INGWAZ, player, rng)
	for i = 1, #entities do
		if entities[i]:ToPickup() then
			if
				(entities[i].Variant >= 50 and 60 >= entities[i].Variant)
				or entities[i].Variant == PickupVariant.PICKUP_REDCHEST
				or entities[i].Variant == PickupVariant.PICKUP_MOMSCHEST
			then
				entities[i]:ToPickup():TryOpenChest(player)
			end
			if RepentancePlusMod then
				if entities[i].Variant == RepentancePlusMod.CustomPickups.FLESH_CHEST then
					RepentancePlusMod.openFleshChest(entities[i])
				elseif entities[i].Variant == RepentancePlusMod.CustomPickups.SCARLET_CHEST then
					RepentancePlusMod.openScarletChest(entities[i])
				elseif entities[i].Variant == RepentancePlusMod.CustomPickups.BLACK_CHEST then
					RepentancePlusMod.openBlackChest(entities[i])
				end
			end
		end
	end

	if magicchalk_3f(player) then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
	end
end
RuneRooms:AddCallback(ModCallbacks.MC_USE_CARD, Runes.UseIngwaz, RuneRooms.Enums.Runes.INGWAZ)