--Cannot make doors open outward only; they are `func_door_rotating`

local walkSpeed = 150
local runSpeed = 200

function HWSetAllPlayersSpeed()
	for _, ply in player.Iterator() do
		ply:SetWalkSpeed(walkSpeed)
		ply:SetRunSpeed(runSpeed)
	end
end

local HOUSE_1_COMPUTER_BUTTONS_ID = 3275
local playIntro
local HOUSE_1_BEDROOM_DOOR_ID = 3061
local HOUSE_1_BLOCKED_DOOR_ID = 3063
local HOUSE_1_PHONE_BUTTON_ID = 3199
local items = {
	--Golden coins
	{ ['id'] = 4061, ['glowName'] = 'coin01_glow',  ['name'] = 'House 1 Golden Coin' },
	{ ['id'] = 4063, ['glowName'] = 'coin01_glow1', ['name'] = 'House 2 Golden Coin' },
	{ ['id'] = 4064, ['glowName'] = 'coin01_glow2', ['name'] = 'Church Golden Coin' },
	{ ['id'] = 4066, ['glowName'] = 'coin01_glow3', ['name'] = 'Sewer Golden Coin' },
	{ ['id'] = 4069, ['glowName'] = 'coin01_glow4', ['name'] = 'House 5 Golden Coin' },
	{ ['id'] = 4071, ['glowName'] = 'coin01_glow5', ['name'] = 'House 6 Secret Golden Coin' },
	--Weapons
	{
		['id'] = 4173,
		['glowName'] = 'crowbar_glow',
		['modelName'] = 'knifemodel',
		['name'] = 'House 2 Weak Knife'
	},
	{
		['id'] = 4174,
		['glowName'] = 'pistol_glow',
		['modelName'] = 'pistolmodel',
		['name'] = 'Sewer Pistol'
	},
	{
		['id'] = 4178,
		['glowName'] = 'smg_glow',
		['modelName'] = 'smgmodel',
		['name'] = 'House 6 SMG'
	},
	--Keys
	{
		['id'] = 2060,
		['glowName'] = 'key02_glow',
		['modelName'] = 'key02_brush',
		['name'] = 'House 3 Church Key'
	},
	{
		['id'] = 3010,
		['glowName'] = 'sewerkey_glow',
		['modelName'] = 'sewerkey_brush',
		['name'] = 'Sewer Key',
	},
	{
		['id'] = 1773,
		['glowName'] = 'key01_glow',
		['modelName'] = 'key01_brush',
		['name'] = 'House 5 Mansion Key'
	},
	{
		['id'] = 2369,
		['glowName'] = 'key02_glow1',
		['modelName'] = 'key02_brush1',
		['name'] = 'House 5 Rusty Key'
	},
	{
		['id'] = 2458,
		['glowName'] = 'key02_glow3',
		['modelName'] = 'key02_brush3',
		['name'] = 'Unreality Hidden Key'
	},
	{
		['id'] = 2448,
		['glowName'] = 'key02_glow3',
		['modelName'] = 'key02_brush3',
		['name'] = 'Unreality Old Key'
	},
	{
		['id'] = 4273,
		['glowName'] = 'key69_glow',
		['modelName'] = 'key69_brush',
		['name'] = 'Unreality Nightmare Key'
	},
	{
		['id'] = 3405,
		['glowName'] = 'key02_glow4',
		['modelName'] = 'key02_brush4',
		['name'] = 'House 5 Mansion Gate Key'
	},
	--Sewer items
	{
		['id'] = 3581,
		['glowName'] = 'bomb_hint01_glow1',
		['modelName'] = 'bomb_model01',
		['name'] = 'Sewer Bomb'
	},
	{
		['id'] = 3585,
		['glowName'] = 'bomb_hint01_glow2',
		['modelName'] = 'detonator_model',
		['name'] = 'Sewer Detonator'
	}
}
local doorbells = {
	{ ['entName'] = 'doorbell01_button1', ['name'] = 'House 1 Ring Doorbell' },
	{ ['entName'] = 'doorbell01_button',  ['name'] = 'House 2 Ring Doorbell' },
	{ ['entName'] = 'doorbell01_button3', ['name'] = 'House 3 Ring Doorbell' },
	{ ['entName'] = 'doorbell01_button2', ['name'] = 'House 5 Ring Doorbell' },
	{ ['entName'] = 'doorbell01_button4', ['name'] = 'House 8 Ring Doorbell' }
}
local HOUSE_1_OBJECTIVE_TRIGGER_ID = 3301
local HOUSE_2_BREAK_LADDER_TRIGGER_ID = 2843
local HOUSE_2_FRONT_DOOR_ID = 3901
local npcGroups = {
	{ 'npc01' }, --House 2 Kill Indoor Zombie
	{ 'npc02' }, --House 2 Kill Outdoor Zombie
	{ 4202 },   --Church Kill Zombie
	--Unreality Kill Envy Hoods
	{ 'osaur',      'osaur2', 'osaur3' },
	{ 'smallzambie' }, --House 6 Secret Kill Zombie
	--House 6 Kill Upper Zombies
	{ 1510,         1508,     1509 },
	--House 6 Kill Lower Zombies
	{ 1514,         3343,     2586,    3344 }
}
local house2BoardIDs = { 3471, 3472, 3473 }
local CHURCH_GHOSTS_TRIGGER_ID = 2145
local churchGhostExplosions = {
	'zombie_of_doom_exp', 'zombie_of_doom_exp1', 'zombie_of_doom_exp2'
}
local CHURCH_JUMPSCARE_TRIGGER_ID = 3346
local SEWER_COIN_DOOR_ID = 2937
local SEWER_VENT_COVER_1_ID = 3477
local SEWER_VENT_COVER_2_ID = 3479
local SEWER_CAMERA_ZOMBIE_TRIGGER_ID = 3022
local SEWER_BOMB_DOOR_ID = 3679
local SEWER_BLOCKAGE_DOOR_ID = 3013
local sewerLockerJumpscared
local SEWER_BLOCKAGE_BUTTON_1_ID = 3578
local HOUSE_4_CHECKPOINT_BUTTON_ID = 2326
local UNREALITY_ENTRANCE_TRIGGER_ID = 2388
local unrealityWrathAmbush
local UNREALITY_HIDDEN_KEY_BREAKABLE_ID = 2455
local UNREALITY_LUST_CHAIN_BUTTON_ID = 3723
local UNREALITY_LUST_CHAIN_BREAKABLE_ID = 3708
local UNREALITY_SLOTH_ZOMBIE_TRIGGER_ID = 3636
local UNREALITY_ENVY_TRIGGER_ID = 3852
local UNREALITY_GLUTTONY_CHAIR_BUTTON_ID = 4263
local npcSpawner
local spawnedNPCs
local UNREALITY_SLOTH_CHAIN_BUTTON_ID = 3722
local unrealityLights = {
	{
		['itemName'] = 'Unreality Light to Exit',
		['locName'] = 'Unreality Open Way to Exit',
		['glowName'] = 'nightmare_glow2',
		['button'] = 3831,
	},
	{
		['itemName'] = 'Unreality Light to Wall',
		['locName'] = 'Unreality Open Way to Wall',
		['glowName'] = 'nightmare_glow3333',
		['button'] = 'bleh1',
	},
	{
		['itemName'] = 'Unreality Light to Envy',
		['locName'] = 'Unreality Open Way to Envy',
		['glowName'] = 'nightmare_glow1',
		['button'] = 'nightmare_btndoor1',
	},
	{
		['itemName'] = 'Unreality Light to Key',
		['locName'] = 'Unreality Open Way to Key',
		['glowName'] = 'nightmare_glow3',
		['button'] = 'nightmare_btndoor2',
	},
}
local HOUSE_5_MANSION_GATE_KEY_BREAKABLE_ID = 2467
local HOUSE_5_LEVER_BUTTON_ID = 2479
local COURTYARD_GATE_JUMPSCARE_TRIGGER_ID = 2585
local COURTYARD_YELLOW_SHED_BREAKABLE_ID = 2052
local COURTYARD_CITIZEN_JUMPSCARE_TRIGGER_ID = 2496
local HOUSE_6_SECRET_CHECKPOINT_BUTTON_ID = 2609
local HOUSE_6_SECRET_BOX_BUTTON_ID = 4085
local HOUSE_6_FRONT_DOOR_TRIGGER_ID = 1443
local HOUSE_6_LADDER_PADLOCK_ID = 2588
local HOUSE_6_LEVER_BUTTON_ID = 1506
local HOUSE_6_VENT_COVER_ID = 2616
local HOUSE_6_POT_ID = 1257
local house6FrontDoor
local HOUSE_6_FRONT_DOOR_INSIDE_BUTTON_ID = 4090
local LIARS_DOOR_ID = 4287

local apadvObj = {
	PostCfgLoad = function(self)
		for _, trigger in ipairs(ents.FindByClass('trigger_weapon_strip')) do
			trigger:Fire('Kill')
		end
		ents.FindByName('intro_fade')[1]:Fire('Kill')
		hook.Add('PlayerSpawn', 'HW_SetProgressiveSpeed', function(ply, trans)
			ply:SetWalkSpeed(walkSpeed)
			ply:SetRunSpeed(runSpeed)
		end)
		hook.Add('AcceptInput', 'HW_House1UseComputer', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:MapCreationID() ~= HOUSE_1_COMPUTER_BUTTONS_ID then return end
			APADV.SendMapLocation('House 1 Use Computer')
			hook.Remove('AcceptInput', 'HW_House1UseComputer')
		end)
		--Lock bedroom door until Archipelago has fully loaded
		ents.GetMapCreatedEntity(HOUSE_1_BEDROOM_DOOR_ID):Fire('Lock')
		ents.GetMapCreatedEntity(HOUSE_1_PHONE_BUTTON_ID):Fire('Lock')
		if APADV_ENTRNAME == 'House 1 Bedroom' then
			hook.Add('AcceptInput', 'HW_House1OpenBedroomDoor', function(ent, input, activ, callr)
				if not playIntro or input ~= 'Use' or ent:MapCreationID() ~= HOUSE_1_BEDROOM_DOOR_ID then return end
				local intro = ents.FindByName('trigger_intro')[1]
				intro:Fire('Trigger')
				local phoneGlow = ents.FindByName('intro_phone_glow')[1]
				phoneGlow:Fire('HideSprite')
				timer.Simple(24, function()
					phoneGlow:Fire('ShowSprite')
					ents.GetMapCreatedEntity(HOUSE_1_PHONE_BUTTON_ID):Fire('Unlock')
				end)
				hook.Remove('AcceptInput', 'HW_House1OpenBedroomDoor')
			end)
		end
		hook.Add('AcceptInput', 'HW_House1TryBlockedDoor', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:MapCreationID() ~= HOUSE_1_BLOCKED_DOOR_ID then return end
			APADV.SendMapLocation('House 1 Try Taped Door')
			hook.Remove('AcceptInput', 'HW_House1TryBlockedDoor')
		end)
		hook.Add('AcceptInput', 'HW_House1AnswerPhone', function(ent, input, activ, callr)
			if not IsValid(callr) or not (callr:MapCreationID() == HOUSE_1_PHONE_BUTTON_ID or callr:GetName() == 'phonecall_egg') then return end
			local entName = ent:GetName()
			if entName == 'phonecall' then
				APADV.SendMapLocation('House 1 Answer Phone')
			elseif entName == 'intro_frontdoor' then
				return true
			elseif entName == 'phonecall_eggsnd' then
				APADV.SendMapLocation('House 1 Answer Phone Again')
				hook.Remove('AcceptInput', 'HW_House1AnswerPhone')
			end
		end)
		if APADV_ENTRNAME ~= 'House 1 Bedroom' then
			hook.Add('AcceptInput', 'HW_House1OpenFrontDoor', function(ent, input, activ, callr)
				if not playIntro or input ~= 'Use' or ent:GetName() ~= 'intro_frontdoor' then return end
				ents.GetMapCreatedEntity(HOUSE_1_PHONE_BUTTON_ID):Fire('Unlock')
				ents.FindByName('intro_snd_phonering')[1]:Fire('PlaySound')
				hook.Remove('AcceptInput', 'HW_House1OpenFrontDoor')
			end)
		end
		hook.Add('AcceptInput', 'HW_GrabItems', function(ent, input, activ, callr)
			if input ~= 'Use' then return end
			for i, item in ipairs(items) do
				if ent:MapCreationID() == item.id then
					APADV.SendMapLocation(item.name)
					--Sewer items tend not to kill their models
					if string.StartsWith(item.name, 'Sewer') and item.modelName ~= nil then
						local model = ents.FindByName(item.modelName)[1]
						if model ~= nil then model:Fire('Kill') end
					end
					table.remove(items, i)
					if items[1] == nil then
						hook.Remove('AcceptInput', 'HW_GrabItems')
					end
					break
				end
			end
		end)
		hook.Add('AcceptInput', 'HW_RingDoorbells', function(ent, input, activ, callr)
			if input ~= 'Use' then return end
			for i, doorbell in ipairs(doorbells) do
				if ent:GetName() == doorbell.entName then
					APADV.SendMapLocation(doorbell.name)
					table.remove(doorbells, i)
					if doorbells[1] == nil then
						hook.Remove('AcceptInput', 'HW_RingDoorbells')
					end
					break
				end
			end
		end)
		hook.Add('AcceptInput', 'HW_House2BreakLadder', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:MapCreationID() ~= HOUSE_2_BREAK_LADDER_TRIGGER_ID then return end
			APADV.SendMapLocation('House 2 Break Ladder')
			hook.Remove('AcceptInput', 'HW_House2BreakLadder')
		end)
		ents.GetMapCreatedEntity(HOUSE_2_FRONT_DOOR_ID):Fire('Lock')
		for _, textName in ipairs({
			--Text entities (these contradict the Archipelago inventory) - Those that count Golden Coins left are still allowed
			'bomb_hint01_text2',
			'bomb_hint01_text3',
			'cp_text',
			'key01_text',
			'key02_text',
			'key02_text1',
			'key02_text2',
			'key02_text3',
			'key02_text4',
			'key69_text',
			'sewerkey_text',
			'txt_goldencoin',
			'txt_secretarea',
			'txt_secretcross',
			'txt_teamweapon1',
			'txt_teamweapon2',
			'txt_teamweapon3',
			--Weapon givers
			'lua_givecrowbar',
			'lua_givepistol',
			'lua_givesmg',
			'rel_givespawncrowbar',
			'rel_givespawnpistol',
			'rel_givespawnsmg'
		}) do
			ents.FindByName(textName)[1]:Fire('Kill')
		end
		gameevent.Listen('break_breakable')
		hook.Add('break_breakable', 'HW_House2BreakBoards', function(data)
			for i, boardID in ipairs(house2BoardIDs) do
				local board = ents.GetMapCreatedEntity(boardID)
				--`data.entindex` is not the same as map creation ID, and we cannot get the board's EntIndex because it is dead, therefore nil; check for nil instead
				if board == nil then
					table.remove(house2BoardIDs, i)
					if house2BoardIDs[1] == nil then
						APADV.SendMapLocation('House 2 Break Boards')
						hook.Remove('break_breakable', 'HW_House2BreakBoards')
					end
					break
				end
			end
		end)
		hook.Add('OnNPCKilled', 'HW_KillMapNPCs', function(npc, attac, inflic)
			local npcsExist
			for i, npcGroup in ipairs(npcGroups) do
				for j, npcInfo in ipairs(npcGroup) do
					npcsExist = true
					if
							(type(npcInfo) == 'string' and npc:GetName() == npcInfo) or
							(type(npcInfo) == 'number' and npc:MapCreationID() == npcInfo) then
						table.remove(npcGroup, j)
						if npcGroup[1] == nil then
							if i == 1 then
								APADV.SendMapLocation('House 2 Kill Indoor Zombie')
							elseif i == 2 then
								APADV.SendMapLocation('House 2 Kill Outdoor Zombie')
							elseif i == 3 then
								APADV.SendMapLocation('Church Kill Zombie')
							elseif i == 4 then
								APADV.SendMapLocation('Unreality Kill Envy Hoods')
							elseif i == 5 then
								APADV.SendMapLocation('House 6 Secret Kill Zombie')
							elseif i == 6 then
								APADV.SendMapLocation('House 6 Kill Upper Zombies')
							elseif i == 7 then
								APADV.SendMapLocation('House 6 Kill Lower Zombies')
							end
						end
						break
					end
				end
			end
			if not npcsExist then
				hook.Remove('OnNPCKilled', 'HW_KillMapNPCs')
			end
		end)
		hook.Add('AcceptInput', 'HW_House3PressBricks', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'stonedoor02_counter' then return end
			APADV.SendMapLocation('House 3 Press Well Bricks')
			return true
		end)
		hook.Add('AcceptInput', 'HW_BlockItemOutputs', function(ent, input, activ, callr, val)
			if not IsValid(callr) then return end
			local callrID = callr:MapCreationID()
			local callrName = callr:GetName()
			local entName = ent:GetName()
			if
					(callrID == 4173 and entName == 'firstattack_trig') or --House 2 Weak Knife
					(callrID == 2060 and entName == 'churchdoors_trig') or --Church Key
					--Sewer Key
					(callrID == 3010 and (
						entName == 'sewerdoors' or
						entName == 'sewerboss_trigger' or
						entName == 'venttp' or
						entName == 'ventblock' or
						entName == 'lockeddoor'
					)) or
					--Sewer Bomb/Detonator
					((callrID == 3581 or callrID == 3585) and (
						entName == 'bomb_counter' or
						entName == 'sewerddd'
					)) or
					(callrID == 1773 and entName == 'door03') or --House 5 Mansion Key
					(callrID == 2369 and entName == 'door05') or --House 5 Rusty Key
					--House 5 Turn Statue
					(callrID == 2537 and (
						entName == 'scare12_trigger' or
						entName == 'scare12_model01' or
						entName == 'door06'
					)) or
					--Unreality Old Key
					(callrID == 2448 and entName == 'mansion_ambush_trigger') or
					--Unreality Hidden Key
					(callrID == 2458 and entName == 'mansion_hside_door2') or
					--Unreality Light to Exit
					(callrID == 3831 and (
						entName == 'nightmare_btndoor1' or
						entName == 'nightmare_glow1'
					)) or
					--Unreality Gluttony Chair
					(callrID == UNREALITY_GLUTTONY_CHAIR_BUTTON_ID and (
						entName == 'bleh1' or
						entName == 'nightmare_glow3' or
						entName == 'nightmare_glow3333'
					)) or
					--Outputs that trigger Unreality Light to Key
					((callrName == 'nightmare_scare_counter' or callrName == 'nightmare_scare_trig2') and (
						entName == 'nightmare_btndoor2' or
						entName == 'nightmare_glow3'
					)) or
					--Unreality Nightmare Key
					(callrID == 4273 and entName == 'nightmare_door') or
					--House 5 Mansion Gate Key
					(callrID == 3405 and entName == 'mansiondoors_trig') or
					--House 6 Secret Button Under Box
					(callrID == 4085 and entName == 'midgetdoor') or
					--House 6 Cell Door and House 8 Front Door - These strangely treat the player as the caller
					(callr:IsPlayer() and input ~= 'Use' and (
						entName == 'dhouses_door01' or entName == 'traphouse_door01'
					)) then
				return true
			end
		end)
		--When Church Zombie sights the player, these Horrorween 2 hooks erroneously run, creating Lua errors; remove them after they're created
		hook.Remove('EntityEmitSound', 'hellguard_mute')
		hook.Remove('EntityEmitSound', 'hellspawn_mute')
		hook.Add('PlayerCanPickupWeapon', self, function(self, ply, wep)
			local wepClass = wep:GetClass()
			if not (wepClass == 'weapon_e_poorcross' or wepClass == 'weapon_e_banana') or wep:MapCreationID() == -1 then return end
			if wepClass == 'weapon_e_poorcross' then
				APADV.SendMapLocation('Church Holy Might')
				hook.Remove('AcceptInput', 'HW_ChurchHolyMightAlreadyEquipped')
			else --'weapon_e_banana'
				APADV.SendMapLocation('House 6 Secret Amazing Banana')
				hook.Remove('AcceptInput', 'HW_House6SecretAmazingBananaAlreadyEquipped')
			end
			wep:Fire('Kill')
			if not APADV.MapLocationStatus('Church Holy Might') or not APADV.MapLocationStatus('House 6 Secret Amazing Banana') then return end
			hook.Remove('PlayerCanPickupWeapon', self)
			hook.Remove('AcceptInput', 'HW_WeaponAlreadyEquipped')
		end)
		hook.Add('AcceptInput', 'HW_WeaponAlreadyEquipped', function(ent, input, activ, callr)
			local entClass = ent:GetClass()
			if input ~= 'Use' or not (entClass == 'weapon_e_poorcross' or entClass == 'weapon_e_banana') then return end
			if entClass == 'weapon_e_poorcross' then
				APADV.SendMapLocation('Church Holy Might')
			else --'weapon_e_banana'
				APADV.SendMapLocation('House 6 Secret Amazing Banana')
			end
			ent:Fire('Kill')
			if not APADV.MapLocationStatus('Church Holy Might') or not APADV.MapLocationStatus('House 6 Secret Amazing Banana') then return end
			hook.Remove('PlayerCanPickupWeapon', self)
			hook.Remove('AcceptInput', 'HW_WeaponAlreadyEquipped')
		end)
		hook.Add('AcceptInput', 'HW_SewerViewZombieOnCamera', function(ent, input, activ, callr)
			if
					IsValid(callr) and (
						callr:MapCreationID() == SEWER_CAMERA_ZOMBIE_TRIGGER_ID or
						callr:GetName() == 'gman_sewers_seq'
					) then
				APADV.SendMapLocation('Sewer View Zombie on Camera')
				hook.Remove('AcceptInput', 'HW_SewerViewZombieOnCamera')
			end
		end)
		hook.Add('AcceptInput', 'HW_PreventSewerDoorLocking', function(ent, input, activ, callr)
			if IsValid(callr) and callr:GetName() == 'lockeddoor' then return true end
		end)
		--Move 2nd Sewer Zombie spawners inside Pistol room so they aren't blocked by locked door
		local spawners = ents.FindByName('sewerboss_spawner2')
		for i, spawner in ipairs(spawners) do
			local x = -2376
			local y = 4384
			if i == 2 then
				x = -2408
				y = 4432
			end
			spawner:SetPos(Vector(x, y, -248))
		end
		hook.Add('AcceptInput', 'HW_SewerKillZombies', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'sewerboss_relay2' then return end
			APADV.SendMapLocation('Sewer Kill Zombies')
			hook.Remove('AcceptInput', 'HW_KillSewerZombies')
		end)
		hook.Add('AcceptInput', 'HW_SewerLockerJumpscare', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'lockerscare_door' then return end
			APADV.SendMapLocation('Sewer Locker Jumpscare')
			if not sewerLockerJumpscared then
				hook.Remove('AcceptInput', 'HW_SewerLockerJumpscare')
			elseif input ~= 'Lock' then
				return true
			end
		end)
		hook.Add('AcceptInput', 'HW_SewerCellJumpscare', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'jpgscare_firsttp' then return end
			APADV.SendMapLocation('Sewer Cell Jumpscare')
			hook.Remove('AcceptInput', 'HW_SewerCellJumpscare')
		end)
		hook.Add('AcceptInput', 'HW_SewerPrepareBlockageDetonation', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'bomb_counter' then return end
			local button = ents.GetMapCreatedEntity(SEWER_BLOCKAGE_BUTTON_1_ID)
			if button ~= nil then button:Fire('Kill') end
			hook.Remove('AcceptInput', 'HW_SewerPrepareBlockageDetonation')
		end)
		hook.Add('AcceptInput', 'HW_SewerDetonateBlockage', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'bombrelay' or ent:GetName() ~= 'bomb_expl' then return end
			APADV.SendMapLocation('Sewer Detonate Blockage')
			hook.Remove('AcceptInput', 'HW_SewerDetonateBlockage')
		end)
		hook.Add('AcceptInput', 'HW_House4Checkpoint', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:MapCreationID() ~= HOUSE_4_CHECKPOINT_BUTTON_ID then return end
			APADV.SendMapLocation('House 4 Checkpoint')
			hook.Remove('AcceptInput', 'HW_House4Checkpoint')
		end)
		hook.Add('AcceptInput', 'HW_House5TurnStatue', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:GetName() ~= 'mansion_statuebutton' then return end
			APADV.SendMapLocation('House 5 Turn Statue')
			hook.Remove('AcceptInput', 'HW_House5TurnStatue')
		end)
		hook.Add('AcceptInput', 'HW_House5ShadowManJumpscare', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'scare12_trigger' then return end
			timer.Simple(0.4, function()
				APADV.SendMapLocation('House 5 Shadow Man Jumpscare')
			end)
			hook.Remove('AcceptInput', 'HW_House5ShadowManJumpscare')
		end)
		ents.FindByName('hside_tpfix')[1]:SetPos(Vector(-2048, 6636, 300))
		ents.FindByName('destination_mansionHside')[1]:SetPos(Vector(-3984, 7196, 2085))
		ents.FindByName('destination_mansioHside_back')[1]:SetPos(Vector(-2048, 6624, 261))
		hook.Add('AcceptInput', 'HW_UnrealityKillZombies', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'mansion_ambush_counter' then return end
			APADV.SendMapLocation('Unreality Kill Wrath Zombies')
			unrealityWrathAmbush = nil
			hook.Remove('AcceptInput', 'HW_UnrealityKillZombies')
		end)
		for i = 1, 3 do
			ents.FindByName('devildoor_trig0' .. tostring(i))[1]:Fire('Kill')
		end
		hook.Add('AcceptInput', 'HW_TrackNPCSpawners', function(ent, input, activ, callr)
			local entClass = ent:GetClass()
			if (
						entClass == 'npc_maker' or entClass == 'env_entity_maker'
					) and (
						input == 'Enable' or input == 'Spawn' or input == 'ForceSpawn'
					) then
				npcSpawner = ent:GetName()
			end
		end)
		hook.Add('OnEntityCreated', 'HW_TrackSpawnedNPCs', function(ent)
			if not npcSpawner or ent:CreatedByMap() then return end
			local entClass = ent:GetClass()
			if entClass ~= 'npc_zombie' and entClass ~= 'npc_fastzombie' then return end
			if spawnedNPCs == nil then spawnedNPCs = {} end
			if spawnedNPCs[npcSpawner] == nil then spawnedNPCs[npcSpawner] = {} end
			table.insert(spawnedNPCs[npcSpawner], ent:GetCreationID())
		end)
		hook.Add('AcceptInput', 'HW_ChurchGhostExploded', function(ent, input, activ, callr)
			if input ~= 'Explode' then return end
			local entName = ent:GetName()
			for i, expName in ipairs(churchGhostExplosions) do
				if entName == expName then
					table.remove(churchGhostExplosions, i)
					if churchGhostExplosions[1] == nil then
						APADV.SendMapLocation('Church Kill Ghosts')
						hook.Remove('AcceptInput', 'HW_ChurchGhostExploded')
					end
					break
				end
			end
		end)
		hook.Add('OnNPCKilled', 'HW_KillSpawnedNPCs', function(npc, attac, inflic)
			if not spawnedNPCs then return end
			local npcClass = npc:GetClass()
			if npcClass ~= 'npc_zombie' and npcClass ~= 'npc_fastzombie' then return end
			for spawner, spawnedNPCGroup in pairs(spawnedNPCs) do
				--Church Zombies use `env_explosion`s to signify their death at half health, killing themselves before it actually happens; handled in 'HW_ChurchGhostExploded'
				if spawner ~= 'churchambush_spawner' then
					local foundInGroup
					for i, spawnedNPCID in ipairs(spawnedNPCGroup) do
						if npc:GetCreationID() == spawnedNPCID then
							foundInGroup = true
							table.remove(spawnedNPCGroup, i)
							break
						end
					end
					if foundInGroup then
						if spawnedNPCGroup[1] == nil then
							if spawner == 'jp_spawner' then
								APADV.SendMapLocation('Unreality Kill Sloth Zombie')
							elseif spawner == 'traphouse01_npcmaker02' then
								APADV.SendMapLocation('House 6 Kill Fast Zombie')
							end
							break
						end
					end
				end
			end
		end)
		hook.Add('AcceptInput', 'House5EnterUnreality', function(ent, input, activ, callr)
			if ent:GetName() ~= 'mansion_hside_door' or input ~= 'Kill' then return end
			APADV.SendMapLocation('House 5 Enter Unreality')
			hook.Remove('AcceptInput', 'House5EnterUnreality')
		end)
		hook.Add('SetupMove', 'HW_UnrealityFastTravel', function(ply, mv, cmd)
			if unrealityWrathAmbush then return end
			local pos = mv:GetOrigin()
			if pos.x < -4048 or pos.x > -3920 or pos.y < 7268 or pos.y > 7296 or pos.z < 2048 or pos.z > 2240 then return end
			mv:SetOrigin(Vector(-2048, 6624, 261))
			ply:SetEyeAngles(Angle(0, 270, 0))
		end)
		hook.Add('AcceptInput', 'HW_UnrealityBreakChains', function(ent, input, activ, callr)
			if input ~= 'Use' then return end
			local entID = ent:MapCreationID()
			if entID ~= UNREALITY_LUST_CHAIN_BUTTON_ID and entID ~= UNREALITY_SLOTH_CHAIN_BUTTON_ID then return end
			if entID == UNREALITY_LUST_CHAIN_BUTTON_ID then
				APADV.SendMapLocation('Unreality Break Lust Chain')
			else --UNREALITY_SLOTH_CHAIN_BUTTON_ID
				APADV.SendMapLocation('Unreality Break Sloth Chain')
			end
			if APADV.MapLocationStatus('Unreality Break Lust Chain') and APADV.MapLocationStatus('Unreality Break Sloth Chain') then
				hook.Remove('AcceptInput', 'HW_UnrealityBreakChains')
			end
		end)
		hook.Add('AcceptInput', 'HW_UnrealitySpellPride', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'pride_btn5' then return end
			APADV.SendMapLocation('Unreality Spell Pride')
			local entName = ent:GetName()
			if entName == 'pride_shk_open' or entName == 'pride_snd_open' or entName == 'pride_door' then
				return true
			elseif entName == 'pride_btn5' then
				timer.Simple(0.01, function()
					hook.Remove('AcceptInput', 'HW_UnrealitySpellPride')
				end)
			end
		end)
		hook.Add('AcceptInput', 'HW_UnrealityOpenWays', function(ent, input, activ, callr)
			if not IsValid(callr) then return end
			for i, lightEnts in ipairs(unrealityLights) do
				if (
							type(lightEnts.button) == 'number' and callr:MapCreationID() == lightEnts.button
						) or (
							type(lightEnts.button) == 'string' and callr:GetName() == lightEnts.button
						) then
					APADV.SendMapLocation(lightEnts.locName)
					table.remove(unrealityLights, i)
					if unrealityLights[1] == nil then
						hook.Remove('AcceptInput', 'HW_UnrealityOpenWays')
					end
					break
				end
			end
		end)
		hook.Add('AcceptInput', 'HW_UnrealityTouchEnvyBaby', function(ent, input, activ, callr)
			if ent:GetName() ~= 'nightmare_scare_blood' then return end
			APADV.SendMapLocation('Unreality Touch Envy Baby')
			hook.Remove('AcceptInput', 'HW_UnrealityTouchEnvyBaby')
		end)
		hook.Add('AcceptInput', 'HW_UnrealityGluttonyBlocks', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:MapCreationID() ~= UNREALITY_GLUTTONY_CHAIR_BUTTON_ID then return end
			timer.Simple(9.2, function()
				APADV.SendMapLocation('Unreality Gluttony Blocks')
			end)
			hook.Remove('AcceptInput', 'HW_UnrealityGluttonyBlocks')
		end)
		hook.Add('AcceptInput', 'HW_UnrealityGluttonyJumpscare', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'jpgsrc_trig' then return end
			APADV.SendMapLocation('Unreality Gluttony Jumpscare')
			hook.Remove('AcceptInput', 'HW_UnrealityGluttonyJumpscare')
		end)
		hook.Add('AcceptInput', 'HW_UnrealityRedHoodJumpscare', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'scaretriggerrerer' then return end
			APADV.SendMapLocation('Unreality Red Hood Jumpscare')
			hook.Remove('AcceptInput', 'HW_UnrealityRedHoodJumpscare')
		end)
		hook.Add('AcceptInput', 'HW_UnrealityExit', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'mansion_hside_endtrig' or ent:GetName() ~= 'mansion_hside_tp2' then return end
			APADV.SendMapLocation('Unreality Exit')
			hook.Remove('AcceptInput', 'HW_UnrealityExit')
			return true
		end)
		hook.Add('AcceptInput', 'HW_House5PullLever', function(ent, input, activ, callr)
			if input == 'Use' and ent:MapCreationID() == HOUSE_5_LEVER_BUTTON_ID then
				APADV.SendMapLocation('House 5 Pull Lever')
			elseif IsValid(callr) and callr:GetName() == 'stonedoor01_lever' then
				hook.Remove('AcceptInput', 'HW_House5PullLever')
				return true
			end
		end)
		if APADV_ENTRNAME == 'House 6 Secret' then
			local newPos = Vector(-672, 7554, 81)
			ents.FindByName('mansiondoors_trig')[1]:SetPos(newPos)
			ents.FindByName('mansiondoor_hint')[1]:SetPos(newPos)
		end
		ents.GetMapCreatedEntity(HOUSE_6_FRONT_DOOR_TRIGGER_ID):Fire('Disable')
		hook.Add('AcceptInput', 'HW_CourtyardGateJumpscare', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:MapCreationID() ~= COURTYARD_GATE_JUMPSCARE_TRIGGER_ID then return end
			APADV.SendMapLocation('Courtyard Gate Jumpscare')
			hook.Remove('AcceptInput', 'HW_CourtyardGateJumpscare')
		end)
		hook.Add('AcceptInput', 'HW_CourtyardShedJumpscare', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:MapCreationID() ~= COURTYARD_CITIZEN_JUMPSCARE_TRIGGER_ID then return end
			APADV.SendMapLocation('Courtyard Shed Jumpscare')
			hook.Remove('AcceptInput', 'HW_CourtyardShedJumpscare')
		end)
		hook.Add('AcceptInput', 'HW_House6SecretCheckpoint', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:MapCreationID() ~= HOUSE_6_SECRET_CHECKPOINT_BUTTON_ID then return end
			APADV.SendMapLocation('House 6 Secret Checkpoint')
			hook.Remove('AcceptInput', 'HW_House6SecretCheckpoint')
		end)
		hook.Add('AcceptInput', 'HW_House6SecretButtonUnderBox', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:MapCreationID() ~= HOUSE_6_SECRET_BOX_BUTTON_ID then return end
			APADV.SendMapLocation('House 6 Secret Button Under Box')
			if ent:GetName() ~= 'midgetdoor' then return end
			hook.Remove('AcceptInput', 'HW_House6SecretButtonUnderBox')
			return true
		end)
		ents.FindByName('scare02_block')[1]:Fire('Enable')
		hook.Add('AcceptInput', 'HW_House6FrontDoorJumpscare', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:MapCreationID() ~= HOUSE_6_FRONT_DOOR_TRIGGER_ID then return end
			APADV.SendMapLocation('House 6 Front Door Jumpscare')
			hook.Remove('AcceptInput', 'HW_House6FrontDoorJumpscare')
		end)
		hook.Add('PropBreak', 'HW_House6BreakLadderPadlock', function(attac, prop)
			if prop:MapCreationID() ~= HOUSE_6_LADDER_PADLOCK_ID then return end
			APADV.SendMapLocation('House 6 Break Ladder Padlock')
			hook.Remove('PropBreak', 'HW_House6BreakLadderPadlock')
		end)
		hook.Add('AcceptInput', 'HW_House6PullLever', function(ent, input, activ, callr)
			if input == 'Use' and ent:MapCreationID() == HOUSE_6_LEVER_BUTTON_ID then
				APADV.SendMapLocation('House 6 Pull Lever')
			elseif IsValid(callr) and callr:GetName() == 'door01_lever' then
				hook.Remove('AcceptInput', 'HW_House6PullLever')
				return true
			end
		end)
		hook.Add('SetupMove', 'HW_House6PrepareFastZombie', function(ply, mv, cmd)
			local pos = mv:GetOrigin()
			if pos.x < -3696 or pos.x > -3656 or pos.y < 9256 or pos.y > 9296 or pos.z < 224 or pos.z > 264 then return end
			ents.FindByName('traphouse01_npcmaker02_trigger')[1]:Fire('Enable')
			hook.Remove('SetupMove', 'HW_House6PrepareFastZombie')
		end)
		hook.Add('PropBreak', 'HW_House6BreakPot', function(attac, prop)
			if prop:MapCreationID() ~= HOUSE_6_POT_ID then return end
			APADV.SendMapLocation('House 6 Break Pot')
			hook.Remove('PropBreak', 'HW_House6BreakPot')
		end)
		hook.Add('AcceptInput', 'HW_BlockHouse6FrontDoorUse', function(ent, input, activ, callr)
			if input == 'Use' and ent:GetName() == 'scare02_door' then return true end
		end)
		ents.GetMapCreatedEntity(HOUSE_6_FRONT_DOOR_INSIDE_BUTTON_ID):Fire('Kill')
		hook.Add('SetupMove', 'HW_House6FrontDoorExit', function(ply, mv, cmd)
			if not house6FrontDoor then return end
			local pos = mv:GetOrigin()
			if pos.x < -3952 or pos.x > -3856 or pos.y < 9838 or pos.y > 9862 or pos.z < 16 or pos.z > 208 then return end
			pos:Add(Vector(0, 266, -15))
			mv:SetOrigin(pos)
		end)
		ents.FindByName('dhouses_door01')[1]:Fire('Lock')
		hook.Add('AcceptInput', 'HW_House8TryHouse18Door', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:GetName() ~= 'dhouses_door03' then return end
			if not APADV.MapLocationStatus('House 8 Defeat Zombie Painting') then
				APADV.SendMapLocation('House 8 Try House 18 Door')
				return
			end
			--Boss defeated, teleport player to Ending Credits Room
			if not APADV.MapLocationStatus('Ending Credits') then
				callr:SetPos(Vector(-384, -4432, 513))
				callr:SetEyeAngles(Angle(0, 90, 0))
			else --Face towards exit
				callr:SetPos(Vector(-384, -4129, 513))
				callr:SetEyeAngles(Angle(0, 270, 0))
			end
			return true
		end)
		--It is annoying trying to figure out how to get the House 8 Painting to disappear, so the logic is being simplified
		ents.FindByName('dhouses_fireplace_trigger1')[1]:Fire('Kill')
		ents.FindByName('dhouses_fireplace_trigger2')[1]:Fire('Kill')
		local trigger = ents.FindByName('dhouses_fireplace_trigger')[1]
		trigger:Fire('AddOutput', 'OnTrigger dhouses_door02:Close')
		trigger:Fire('AddOutput', 'OnTrigger dhouses_door02:Lock::0.01')
		trigger:Fire('AddOutput', 'OnTrigger dhouses_door01:Close')
		trigger:Fire('AddOutput', 'OnTrigger dhouses_door01:Lock::0.01')
		trigger:Fire('AddOutput', 'OnTrigger dhouses_door01:Unlock::27')
		hook.Add('AcceptInput', 'HW_House8PaintingDisappeared', function(ent, input, activ, callr)
			if ent:GetName() ~= 'dhouses_painting' then return end
			timer.Simple(1, function()
				APADV.SendMapLocation('House 8 Painting Disappeared')
			end)
			hook.Remove('AcceptInput', 'HW_House8PaintingDisappeared')
		end)
		hook.Add('AcceptInput', 'HW_House8ConfrontPainting', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'dhouses_bosstrig' then return end
			APADV.SendMapLocation('House 8 Confront Painting')
			hook.Remove('AcceptInput', 'HW_House8ConfrontPainting')
		end)
		hook.Add('AcceptInput', 'HW_House8DefeatZombiePainting', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'boss01_deathtrig' then return end
			APADV.SendMapLocation('House 8 Defeat Zombie Painting')
			hook.Remove('AcceptInput', 'HW_House8DefeatZombiePainting')
		end)
	end,

	CfgUnload = function(self)
		hook.Remove('PlayerSpawn', 'HW_SetProgressiveSpeed')
		hook.Remove('AcceptInput', 'HW_House1UseComputer')
		hook.Remove('AcceptInput', 'HW_House1OpenBedroomDoor')
		hook.Remove('AcceptInput', 'HW_House1TryBlockedDoor')
		hook.Remove('AcceptInput', 'HW_House1AnswerPhone')
		hook.Remove('AcceptInput', 'HW_House1OpenFrontDoor')
		hook.Remove('AcceptInput', 'HW_GrabItems')
		hook.Remove('AcceptInput', 'HW_RingDoorbells')
		hook.Remove('AcceptInput', 'HW_House2BreakLadder')
		hook.Remove('OnNPCKilled', 'HW_KillMapNPCs')
		hook.Remove('break_breakable', 'HW_House2BreakBoards')
		hook.Remove('AcceptInput', 'HW_ChurchGhostExploded')
		hook.Remove('AcceptInput', 'HW_House3PressBricks')
		hook.Remove('AcceptInput', 'HW_BlockItemOutputs')
		hook.Remove('PlayerCanPickupWeapon', self)
		hook.Remove('AcceptInput', 'HW_WeaponAlreadyEquipped')
		hook.Remove('AcceptInput', 'HW_SewerViewZombieOnCamera')
		hook.Remove('AcceptInput', 'HW_PreventSewerDoorLocking')
		hook.Remove('AcceptInput', 'HW_SewerKillZombies')
		hook.Remove('AcceptInput', 'HW_SewerLockerJumpscare')
		hook.Remove('AcceptInput', 'HW_SewerCellJumpscare')
		hook.Remove('AcceptInput', 'HW_SewerPrepareBlockageDetonation')
		hook.Remove('AcceptInput', 'HW_SewerDetonateBlockage')
		hook.Remove('AcceptInput', 'HW_House4Checkpoint')
		hook.Remove('AcceptInput', 'HW_House5TurnStatue')
		hook.Remove('AcceptInput', 'HW_House5ShadowManJumpscare')
		hook.Remove('AcceptInput', 'House5EnterUnreality')
		hook.Remove('SetupMove', 'HW_UnrealityFastTravel')
		hook.Remove('AcceptInput', 'HW_UnrealityBreakChains')
		hook.Remove('AcceptInput', 'HW_TrackNPCSpawners')
		hook.Remove('OnEntityCreated', 'HW_TrackSpawnedNPCs')
		hook.Remove('OnNPCKilled', 'HW_KillSpawnedNPCs')
		hook.Remove('AcceptInput', 'HW_UnrealitySpellPride')
		hook.Remove('AcceptInput', 'HW_UnrealityOpenWays')
		hook.Remove('AcceptInput', 'HW_UnrealityTouchEnvyBaby')
		hook.Remove('AcceptInput', 'HW_UnrealityGluttonyBlocks')
		hook.Remove('AcceptInput', 'HW_UnrealityGluttonyJumpscare')
		hook.Remove('AcceptInput', 'HW_UnrealityRedHoodJumpscare')
		hook.Remove('AcceptInput', 'HW_UnrealityExit')
		hook.Remove('AcceptInput', 'HW_House5PullLever')
		hook.Remove('AcceptInput', 'HW_CourtyardGateJumpscare')
		hook.Remove('AcceptInput', 'HW_CourtyardShedJumpscare')
		hook.Remove('AcceptInput', 'HW_House6SecretCheckpoint')
		hook.Remove('AcceptInput', 'HW_House6SecretButtonUnderBox')
		hook.Remove('AcceptInput', 'HW_House6FrontDoorJumpscare')
		hook.Remove('PropBreak', 'HW_House6BreakLadderPadlock')
		hook.Remove('AcceptInput', 'HW_House6PullLever')
		hook.Remove('SetupMove', 'HW_House6PrepareFastZombie')
		hook.Remove('PropBreak', 'HW_House6BreakPot')
		hook.Remove('AcceptInput', 'HW_BlockHouse6FrontDoorUse')
		hook.Remove('SetupMove', 'HW_House6FrontDoorExit')
		hook.Remove('AcceptInput', 'HW_House8TryHouse18Door')
		hook.Remove('AcceptInput', 'HW_House8PaintingDisappeared')
		hook.Remove('AcceptInput', 'HW_House8ConfrontPainting')
		hook.Remove('AcceptInput', 'HW_House8DefeatZombiePainting')
	end,

	OnFullConnect = function(self)
		timer.Simple(1, function()
			HWSetAllPlayersSpeed() --Run after gamemode setup
		end)
		if not (APADV.MapLocationStatus('House 1 Answer Phone') and APADV.MapLocationStatus('House 1 Answer Phone Again')) then
			playIntro = true
		else
			ents.GetMapCreatedEntity(HOUSE_1_PHONE_BUTTON_ID):Fire('Lock')
			ents.FindByName('intro_phone_glow')[1]:Fire('Kill')
			ents.FindByName('intro_phone_glow2')[1]:Fire('Kill')
			hook.Remove('AcceptInput', 'HW_House1AnswerPhone')
		end
		--Loading finished, undo lock
		ents.GetMapCreatedEntity(HOUSE_1_BEDROOM_DOOR_ID):Fire('Unlock')
		local coinsFound = 0
		for i = #items, 1, -1 do
			if APADV.MapLocationStatus(items[i].name) then
				if string.EndsWith(items[i].name, 'Coin') then
					coinsFound = coinsFound + 1
				end
				ents.GetMapCreatedEntity(items[i].id):Fire('Kill')
				ents.FindByName(items[i].glowName)[1]:Fire('Kill')
				if items[i].modelName ~= nil then
					ents.FindByName(items[i].modelName)[1]:Fire('Kill')
				end
				if items[i].name == 'Sewer Bomb' then
					ents.GetMapCreatedEntity(SEWER_BOMB_DOOR_ID):Fire('Open')
				end
				table.remove(items, i)
			end
		end
		--There are multiple Golden Coin counters that fire at different maxes; kill those that are equal or below and only allow the remaining counters to trigger
		for _, counter in ipairs(ents.FindByName('goldencoin_counter')) do
			if tonumber(counter:GetKeyValues()['max']) <= coinsFound then
				counter:Fire('Kill')
			else
				counter:Fire('SetValue', tostring(coinsFound))
			end
		end
		if items[1] == nil then
			hook.Remove('AcceptInput', 'HW_GrabItems')
		end
		if APADV.MapLocationStatus('House 1 Front Porch') then
			ents.GetMapCreatedEntity(HOUSE_1_OBJECTIVE_TRIGGER_ID):Fire('Kill')
		end
		if APADV.MapLocationStatus('House 2 Break Ladder') then
			ents.GetMapCreatedEntity(HOUSE_2_BREAK_LADDER_TRIGGER_ID):Fire('Kill')
			for _, rungID in ipairs({ 2842, 2841, 2840, 2839 }) do
				ents.GetMapCreatedEntity(rungID):Fire('Kill')
			end
			hook.Remove('AcceptInput', 'HW_House2BreakLadder')
		end
		local npcGroupsKilled = 0
		for i, npcGroup in ipairs(npcGroups) do
			if
					i == 1 and APADV.MapLocationStatus('House 2 Kill Indoor Zombie') or
					i == 2 and APADV.MapLocationStatus('House 2 Kill Outdoor Zombie') or
					i == 3 and APADV.MapLocationStatus('Church Kill Zombie') or
					i == 4 and APADV.MapLocationStatus('Unreality Kill Envy Hoods') or
					i == 5 and APADV.MapLocationStatus('House 6 Secret Kill Zombie') or
					i == 6 and APADV.MapLocationStatus('House 6 Kill Upper Zombies') or
					i == 7 and APADV.MapLocationStatus('House 6 Kill Lower Zombies') then
				for j = #npcGroup, 1, -1 do
					local npcInfo = npcGroup[j]
					if type(npcInfo) == 'string' then
						ents.FindByName(npcInfo)[1]:Fire('Kill')
					else --'number'
						ents.GetMapCreatedEntity(npcInfo):Fire('Kill')
					end
					table.remove(npcGroup, j)
				end
				npcGroupsKilled = npcGroupsKilled + 1
			end
		end
		if npcGroupsKilled == #npcGroups then
			hook.Remove('OnNPCKilled', 'HW_KillMapNPCs')
		end
		if APADV.MapLocationStatus('House 2 Kill Indoor Zombie') then
			ents.FindByName('firstattack_trig')[1]:Fire('Kill')
			--ents.FindByName('npc01')[1]:Fire('Kill') - Handled by `npcGroups`
			local door = ents.FindByName('firstattack_door')[1]
			door:Fire('Unlock')
			door:Fire('Open')
			hook.Remove('OnNPCKilled', 'HW_House2KillZombie')
		end
		if APADV.MapLocationStatus('House 2 Break Boards') then
			for _, boardID in ipairs(house2BoardIDs) do
				ents.GetMapCreatedEntity(boardID):Fire('Kill')
			end
			hook.Remove('break_breakable', 'HW_House2BreakBoards')
		end
		if APADV.MapLocationStatus('House 3 Press Well Bricks') then
			for _, brickID in ipairs({ 1697, 1703, 1706, 1705, 1700 }) do
				ents.GetMapCreatedEntity(brickID):Fire('Press')
			end
		end
		if
				APADV.MapLocationStatus('Church Gravestones') or
				APADV.MapLocationStatus('Church Shed') or
				APADV.MapLocationStatus('Church Kill Ghosts') or
				APADV.MapLocationStatus('Church Kill Zombie') or
				APADV.MapLocationStatus('Church Left Window') or
				APADV.MapLocationStatus('Church Right Window') or
				APADV.MapLocationStatus('Church Holy Might') or
				APADV.MapLocationStatus('Church Golden Coin') then
			ents.FindByName('churchdoors_trig')[1]:Fire('Kill')
			local doors = ents.FindByName('churchdoors')
			for _, door in ipairs(doors) do
				door:Fire('Open')
			end
		end
		if APADV.MapLocationStatus('Church Kill Ghosts') then
			ents.GetMapCreatedEntity(CHURCH_GHOSTS_TRIGGER_ID):Fire('Kill')
			hook.Remove('AcceptInput', 'HW_ChurchGhostExploded')
		end
		if APADV.MapLocationStatus('Church Holy Might') or APADV.MapLocationStatus('Church Golden Coin') then
			ents.GetMapCreatedEntity(CHURCH_JUMPSCARE_TRIGGER_ID):Fire('Kill')
		end
		if APADV.MapLocationStatus('Church Holy Might') then
			for _, wep in ipairs(ents.FindByClass('weapon_e_poorcross')) do
				if wep:MapCreationID() ~= -1 then
					wep:Fire('Kill')
					break
				end
			end
		end
		if APADV.MapLocationStatus('House 3 Shed') then
			ents.FindByName('pushersasdtrigger')[1]:Fire('Kill')
		end
		if APADV.MapLocationStatus('Sewer Vent') then
			ents.GetMapCreatedEntity(SEWER_VENT_COVER_1_ID):Fire('Kill')
			ents.GetMapCreatedEntity(SEWER_VENT_COVER_2_ID):Fire('Kill')
		end
		if APADV.MapLocationStatus('Sewer Kill Zombies') then
			ents.FindByName('sewerboss_trigger')[1]:Fire('Kill')
			ents.FindByName('wooddoor')[1]:Fire('Kill')
		end
		if APADV.MapLocationStatus('Sewer Locker Jumpscare') then
			sewerLockerJumpscared = true
			ents.FindByName('lockerscare_door')[1]:Fire('Open')
			hook.Remove('AcceptInput', 'HW_SewerLockerJumpscare')
		end
		if APADV.MapLocationStatus('Sewer Cell Jumpscare') then
			ents.FindByName('jpgscare_firsttp')[1]:Fire('Kill')
			hook.Remove('AcceptInput', 'HW_SewerCellJumpscare')
		end
		if APADV.MapLocationStatus('Sewer Detonate Blockage') then
			for _, entName in ipairs({
				'bomb_blockage', 'bomb_button2', 'bomb_hint01_glow', 'fakebomb_glow', 'fakebomb_model'
			}) do
				ents.FindByName(entName)[1]:Fire('Kill')
			end
			ents.GetMapCreatedEntity(SEWER_BLOCKAGE_BUTTON_1_ID):Fire('Kill')
			hook.Remove('AcceptInput', 'HW_SewerDetonateBlockage')
		end
		if APADV.MapLocationStatus('House 4 Checkpoint') then
			ents.FindByName('cp1_smoke')[1]:Fire('Kill')
			ents.FindByName('globalsnd_cp1')[1]:Fire('Kill')
			ents.GetMapCreatedEntity(HOUSE_4_CHECKPOINT_BUTTON_ID):Fire('Press')
			hook.Remove('AcceptInput', 'HW_House4Checkpoint')
		end
		if APADV.MapLocationStatus('House 5 Turn Statue') then
			ents.FindByName('mansion_statuebutton')[1]:Fire('Open')
			hook.Remove('AcceptInput', 'HW_House5TurnStatue')
		end
		if APADV.MapLocationStatus('House 5 Shadow Man Jumpscare') then
			ents.FindByName('scare12_model01')[1]:Fire('Kill')
			ents.FindByName('scare12_trigger')[1]:Fire('Kill')
		end
		if APADV.MapLocationStatus('House 5 Enter Unreality') then
			hook.Remove('AcceptInput', 'House5EnterUnreality')
			ents.FindByName('mansion_hside_door')[1]:Fire('Kill')
			ents.GetMapCreatedEntity(UNREALITY_ENTRANCE_TRIGGER_ID):Fire('Kill')
			ents.FindByName('mansion_hside_tp2')[1]:Fire('Enable')
		end
		if APADV.MapLocationStatus('Unreality Kill Wrath Zombies') then
			unrealityWrathAmbush = nil
			ents.FindByName('mansion_ambush_trigger')[1]:Fire('Kill')
			local door = ents.FindByName('mansion_ambush_door')[1]
			door:Fire('Open')
			door:Fire('Lock', nil, 0.05)
			ents.FindByName('mansion_ambush_doorbrush')[1]:Fire('Kill')
			local zombies = ents.FindByName('mansion_ambush_zombies')
			for _, zombie in ipairs(zombies) do
				zombie:Fire('Kill')
			end
			hook.Remove('AcceptInput', 'HW_UnrealityKillZombies')
		end
		if APADV.MapLocationStatus('Unreality Hidden Key') then
			ents.GetMapCreatedEntity(UNREALITY_HIDDEN_KEY_BREAKABLE_ID):Fire('Kill')
		end
		if APADV.MapLocationStatus('Unreality Break Lust Chain') then
			ents.GetMapCreatedEntity(UNREALITY_LUST_CHAIN_BREAKABLE_ID):Fire('Kill')
			ents.GetMapCreatedEntity(UNREALITY_LUST_CHAIN_BUTTON_ID):Fire('Kill')
			ents.FindByName('chain1')[1]:Fire('Kill')
		end
		if APADV.MapLocationStatus('Unreality Break Sloth Chain') then
			ents.GetMapCreatedEntity(UNREALITY_SLOTH_CHAIN_BUTTON_ID):Fire('Kill')
			ents.FindByName('chain2')[1]:Fire('Kill')
			if APADV.MapLocationStatus('Unreality Break Lust Chain') then
				hook.Remove('AcceptInput', 'HW_UnrealityBreakChains')
			end
		end
		if APADV.MapLocationStatus('Unreality Kill Sloth Zombie') then
			ents.GetMapCreatedEntity(UNREALITY_SLOTH_ZOMBIE_TRIGGER_ID):Fire('Kill')
			ents.FindByName('jp_door')[1]:Fire('Open')
		end
		if APADV.MapLocationStatus('Unreality Spell Pride') then
			for i = 1, 5 do
				ents.FindByName('pride_btn' .. tostring(i))[1]:Fire('Kill')
			end
			hook.Remove('AcceptInput', 'HW_UnrealitySpellPride')
		end
		ents.FindByName(unrealityLights[1].glowName)[1]:Fire('HideSprite')
		ents.GetMapCreatedEntity(unrealityLights[1].button):Fire('Lock')
		for i = #unrealityLights, 1, -1 do
			local light = unrealityLights[i]
			if APADV.MapLocationStatus(light.locName) then
				ents.FindByName(light.glowName)[1]:Fire('Kill')
				if type(light.button) == 'string' then
					ents.FindByName(light.button)[1]:Fire('Kill')
				else
					ents.GetMapCreatedEntity(light.button):Fire('Kill')
				end
				table.remove(unrealityLights, i)
			end
		end
		if unrealityLights[1] == nil then
			hook.Remove('AcceptInput', 'HW_UnrealityOpenWays')
		end
		if APADV.MapLocationStatus('Unreality Touch Envy Baby') then
			hook.Remove('AcceptInput', 'HW_UnrealityTouchEnvyBaby')
		end
		if APADV.MapLocationStatus('Unreality Kill Envy Hoods') then
			ents.GetMapCreatedEntity(UNREALITY_ENVY_TRIGGER_ID):Fire('Kill')
			ents.FindByName('nightmare_scare_brush2')[1]:Fire('Kill')
		end
		if APADV.MapLocationStatus('Unreality Gluttony Blocks') then
			ents.GetMapCreatedEntity(UNREALITY_GLUTTONY_CHAIR_BUTTON_ID):Fire('Kill')
			--[[
			The below doesn't work because trains can't be moved by Gmod Lua
			local trains = ents.FindByName('cubetrains')
			for _, train in ipairs(trains) do
				train:Fire('StartForward')
			end
			]]
			for _, enableName in ipairs({ 'cube_bloodbrush', 'cube_bloodbrush2', 'jpgsrc_trig' }) do
				ents.FindByName(enableName)[1]:Fire('Enable')
			end
			hook.Remove('AcceptInput', 'HW_UnrealityGluttonyBlocks')
		end
		if APADV.MapLocationStatus('Unreality Gluttony Jumpscare') then
			ents.FindByName('jpgsrc_trig')[1]:Fire('Kill')
			hook.Remove('AcceptInput', 'HW_UnrealityGluttonyJumpscare')
		end
		if APADV.MapLocationStatus('Unreality Red Hood Jumpscare') then
			ents.FindByName('scaretriggerrerer')[1]:Fire('Kill')
			hook.Remove('AcceptInput', 'HW_UnrealityRedHoodJumpscare')
		end
		if APADV.MapLocationStatus('Unreality Exit') then
			ents.FindByName('hside_tpbackfade_snd')[1]:Fire('Kill')
			ents.FindByName('hside_tpbackfade')[1]:Fire('Kill')
			ents.FindByName('nightmare_door')[1]:Fire('Open')
		end
		if APADV.MapLocationStatus('House 5 Mansion Gate Key') then
			ents.GetMapCreatedEntity(HOUSE_5_MANSION_GATE_KEY_BREAKABLE_ID):Fire('Kill')
		end
		if APADV.MapLocationStatus('House 5 Pull Lever') then
			ents.GetMapCreatedEntity(HOUSE_5_LEVER_BUTTON_ID):Fire('Press')
		end
		if APADV.MapLocationStatus('House 5 Golden Coin') then
			ents.FindByName('mansionsecret_shake')[1]:Fire('Kill')
			ents.FindByName('mansionsecret_snd')[1]:Fire('Kill')
		end
		if APADV.MapLocationStatus('Courtyard Gate Jumpscare') then
			ents.GetMapCreatedEntity(COURTYARD_GATE_JUMPSCARE_TRIGGER_ID):Fire('Kill')
			hook.Remove('AcceptInput', 'HW_CourtyardGateJumpscare')
		end
		if APADV.MapLocationStatus('Courtyard Yellow Shed') then
			ents.GetMapCreatedEntity(COURTYARD_YELLOW_SHED_BREAKABLE_ID):Fire('Kill')
		end
		if APADV.MapLocationStatus('Courtyard Shed Jumpscare') then
			ents.GetMapCreatedEntity(COURTYARD_CITIZEN_JUMPSCARE_TRIGGER_ID):Fire('Kill')
			hook.Remove('AcceptInput', 'HW_CourtyardShedJumpscare')
		end
		if APADV.MapLocationStatus('House 6 Secret Checkpoint') then
			ents.FindByName('cp1_smoke1')[1]:Fire('Kill')
			ents.FindByName('globalsnd_cp2')[1]:Fire('Kill')
			ents.GetMapCreatedEntity(HOUSE_6_SECRET_CHECKPOINT_BUTTON_ID):Fire('Press')
			hook.Remove('AcceptInput', 'HW_House6SecretCheckpoint')
		end
		if APADV.MapLocationStatus('House 6 Secret Button Under Box') then
			--[[
			The below doesn't work because trains can't be moved by Gmod Lua
			ents.FindByName('cratetrain')[1]:SetPos(Vector(-2668, 9548, 40))
			]]
			ents.GetMapCreatedEntity(HOUSE_6_SECRET_BOX_BUTTON_ID):Fire('Kill')
			hook.Remove('AcceptInput', 'HW_House6SecretButtonUnderBox')
		end
		if
				APADV.MapLocationStatus('House 6 Secret Golden Coin') or
				APADV.MapLocationStatus('House 6 Secret Kill Zombie') or
				APADV.MapLocationStatus('House 6 Secret Amazing Banana') then
			ents.FindByName('globalsnd_secret')[1]:Fire('Kill')
		end
		if APADV.MapLocationStatus('House 6 Secret Amazing Banana') then
			for _, wep in ipairs(ents.FindByClass('weapon_e_banana')) do
				if wep:MapCreationID() ~= -1 then
					wep:Fire('Kill')
					break
				end
			end
		end
		if APADV.MapLocationStatus('House 6 Front Door Jumpscare') then
			ents.GetMapCreatedEntity(HOUSE_6_FRONT_DOOR_TRIGGER_ID):Fire('Kill')
			ents.FindByName('scare02_tp222')[1]:Fire('Enable')
			local doors = ents.FindByName('traphouse_doors')
			for _, door in ipairs(doors) do
				door:Fire('Open')
			end
		end
		if APADV.MapLocationStatus('House 6 Break Ladder Padlock') then
			ents.GetMapCreatedEntity(HOUSE_6_LADDER_PADLOCK_ID):Fire('Kill')
			ents.FindByName('traphouse01_ladder')[1]:Fire('Open')
		end
		if APADV.MapLocationStatus('House 6 Pull Lever') then
			ents.GetMapCreatedEntity(HOUSE_6_LEVER_BUTTON_ID):Fire('Press')
		end
		if APADV.MapLocationStatus('House 6 Kill Fast Zombie') then
			ents.FindByName('traphouse01_npcmaker02_trigger')[1]:Fire('Kill')
			ents.GetMapCreatedEntity(HOUSE_6_VENT_COVER_ID):Fire('Kill')
			hook.Remove('SetupMove', 'HW_House6PrepareFastZombie')
		end
		if APADV.MapLocationStatus('House 6 Chair') then
			ents.FindByName('breakablefloor')[1]:Fire('Kill')
		end
		if APADV.MapLocationStatus('House 6 Break Pot') then
			ents.GetMapCreatedEntity(HOUSE_6_POT_ID):Fire('Kill')
			hook.Remove('PropBreak', 'HW_House6BreakPot')
		end
		if APADV.MapLocationStatus('House 8 Painting Disappeared') then
			ents.FindByName('dhouses_fireplace_trigger')[1]:Fire('Kill')
			ents.FindByName('dhouses_painting')[1]:Fire('Kill')
			ents.FindByName('dhouses_bossrel1')[1]:Fire('Enable')
			hook.Remove('AcceptInput', 'HW_House8PaintingDisappeared')
		end
		if APADV.MapLocationStatus('House 8 Confront Painting') then
			hook.Remove('AcceptInput', 'HW_House8ConfrontPainting')
		end
		if APADV.MapLocationStatus('House 8 Defeat Zombie Painting') then
			ents.FindByName('dhouses_bossrel1')[1]:Fire('Kill')
			hook.Remove('AcceptInput', 'HW_House8DefeatZombiePainting')
		end
	end,

	MapItemFuncs = {
		['Progressive Speed'] = function(iList)
			if iList[1] == nil then return end
			local speedAmt = #iList
			walkSpeed = 150 + (6.25 * speedAmt)
			runSpeed = 200 + (25 * speedAmt)
			HWSetAllPlayersSpeed()
			if iList[8] ~= nil then return true end
		end,
		['House 1 Front Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('intro_frontdoor')[1]:Fire('Unlock')
			return true
		end,
		['House 2 Front Door'] = function(iList)
			if iList[1] == nil then return end
			ents.GetMapCreatedEntity(HOUSE_2_FRONT_DOOR_ID):Fire('Unlock')
			return true
		end,
		['House 2 Indoor Zombie'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('firstattack_trig')[1]:Fire('Enable')
			return true
		end,
		['House 3 Well Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('stonedoor02')[1]:Fire('Open')
			return true
		end,
		['Church Gate'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('churchdoors_trig')[1]:Fire('Enable')
			return true
		end,
		['Sewer Door to Coin'] = function(iList)
			if iList[1] == nil then return end
			ents.GetMapCreatedEntity(SEWER_COIN_DOOR_ID):Fire('Unlock')
			return true
		end,
		['Sewer Door to Key'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('lockeddoor')[1]:Fire('Unlock')
			return true
		end,
		['Sewer Door to Blockage'] = function(iList)
			if iList[1] == nil then return end
			ents.GetMapCreatedEntity(SEWER_BLOCKAGE_DOOR_ID):Fire('Unlock')
			return true
		end,
		['Sewer Door to Cell'] = function(iList)
			if iList[1] == nil then return end
			local door = ents.FindByName('sewerddd')[1]
			door:Fire('Unlock')
			door:Fire('Open')
			return true
		end,
		['Sewer Zombies'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('sewerboss_trigger')[1]:Fire('Enable')
			return true
		end,
		['Bomb'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('bomb_counter')[1]:Fire('Add', '1')
			return true
		end,
		['Detonator'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('bomb_counter')[1]:Fire('Add', '1')
			return true
		end,
		['House 5 Front Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('door03')[1]:Fire('Unlock')
			return true
		end,
		['House 5 Bathroom Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('door06')[1]:Fire('Unlock')
			return true
		end,
		['House 5 Stone Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('stonedoor01')[1]:Fire('Open')
			return true
		end,
		['House 5 Shadow Man'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('scare12_model01')[1]:Fire('Enable')
			ents.FindByName('scare12_trigger')[1]:Fire('Enable')
			return true
		end,
		['House 5 Door to Unreality'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('door05')[1]:Fire('Unlock')
			return true
		end,
		['Unreality Wrath Door'] = function(iList)
			if iList[1] == nil then return end
			if not APADV.MapLocationStatus('Unreality Kill Wrath Zombies') then
				unrealityWrathAmbush = true
			end
			local trigger = ents.FindByName('mansion_ambush_trigger')[1]
			if trigger ~= nil then trigger:Fire('Enable') end
			return true
		end,
		['Unreality Hallways Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('mansion_hside_door2')[1]:Fire('Unlock')
			return true
		end,
		['Unreality Lust Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('devildoor01')[1]:Fire('Open')
			return true
		end,
		['Unreality Sloth Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('devildoor03')[1]:Fire('Open')
			return true
		end,
		['Unreality Pride Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('devildoor02')[1]:Fire('Open')
			return true
		end,
		['Unreality Blood Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('pride_door')[1]:Fire('Unlock')
			return true
		end,
		['Unreality Exit Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('nightmare_door')[1]:Fire('Unlock')
			return true
		end,
		['House 5 Door Past Unreality'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('mansion_door1')[1]:Fire('Unlock')
			return true
		end,
		['Courtyard Gate'] = function(iList)
			if iList[1] == nil then return end
			local hint = ents.FindByName('mansiondoor_hint')[1]
			if hint ~= nil then hint:Fire('Kill') end
			ents.FindByName('mansiondoors_trig')[1]:Fire('Enable')
			if APADV.MapLocationStatus('Courtyard Gate Jumpscare') then
				ents.FindByName('mansiondoors_trig')[1]:Fire('Kill')
				for _, door in ipairs(ents.FindByName('mansiondoors')) do
					door:Fire('Open')
				end
			end
			return true
		end,
		['House 6 Secret Small Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('midgetdoor')[1]:Fire('Unlock')
			return true
		end,
		['House 6 Front Door'] = function(iList)
			if iList[1] == nil then return end
			house6FrontDoor = true
			ents.GetMapCreatedEntity(HOUSE_6_FRONT_DOOR_TRIGGER_ID):Fire('Enable')
			return true
		end,
		['House 6 Upper Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('door01')[1]:Fire('Open')
			return true
		end,
		['House 6 Cell Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('traphouse_door01')[1]:Fire('Unlock')
			return true
		end,
		['House 8 Front Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('dhouses_door01')[1]:Fire('Unlock')
			return true
		end,
		['House 8 Cutscene'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('dhouses_fireplace_trigger')[1]:Fire('Enable')
			return true
		end,
		['Golden Coin'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('rewardblop')[1]:Fire('Enable')
			ents.FindByName('reward_dix_door')[1]:Fire('Unlock')
			ents.FindByName('reward_dix_brushes')[1]:Fire('Enable')
			if iList[3] == nil then return end
			ents.FindByName('rewardblop2')[1]:Fire('Enable')
			for _, partyDoor in ipairs(ents.FindByName('doorrrs')) do
				partyDoor:Fire('Unlock')
			end
			ents.FindByName('reward_boobs_brushes')[1]:Fire('Enable')
			if iList[6] == nil then return end
			ents.FindByName('rewardblop3')[1]:Fire('Enable')
			ents.FindByName('reward_boobs_door')[1]:Fire('Unlock')
			return true
		end,
		['Liars Door'] = function(iList)
			if iList[1] == nil then return end
			ents.GetMapCreatedEntity(LIARS_DOOR_ID):Fire('Unlock')
			return true
		end,
	}
}
for _, light in ipairs(unrealityLights) do
	apadvObj.MapItemFuncs[light.itemName] = function(iList)
		if iList[1] == nil or light.glowName == nil then return end
		local glow = ents.FindByName(light.glowName)[1]
		if glow ~= nil then glow:Fire('ShowSprite') end
		if type(light.button) == 'string' then
			ents.FindByName(light.button)[1]:Fire('Unlock')
		else
			ents.GetMapCreatedEntity(light.button):Fire('Unlock')
		end
		if light.itemName == 'Unreality Light to Key' then
			ents.FindByName('scaretriggerrerer')[1]:Fire('Enable')
		end
		return true
	end
end

return apadvObj
