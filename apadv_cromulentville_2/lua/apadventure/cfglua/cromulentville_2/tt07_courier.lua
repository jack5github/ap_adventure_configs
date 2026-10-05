local GOODS_TEXT_TRIGGER_ID = 1996
local GOODS_GRAB_TRIGGER_ID = 1700
local crateGroups = {
	{ 1720 },      --First crate
	{ 1726, 1724 }, --Flank crates
	{ 1746 },      --Overlook crate
	{ 1768, 1770 }, --Fence crates
	{ 1869, 1871 }, --Rooftop crates
	{ 1894, 1892 }, --Top floor crates
	{ 1922 }       --Hotel crate
}
local CROSSBOW_TRIGGER_ID = 1837
local CROSSBOW_ID = 1831
local DOORBELL_BUTTON_ID = 1963
local gotTheGoods

return {
	PostCfgLoad = function(self)
		ents.FindByClass('trigger_gravity')[1]:Fire('Kill')
		ents.FindByName('speedmod')[1]:Fire('Kill')
		ents.FindByName('intro-fade')[1]:Fire('Kill')
		ents.FindByName('intro-text')[1]:Fire('Kill')
		ents.FindByName('phone1ringtimer')[1]:Fire('Kill')
		hook.Add('AcceptInput', 'CV2_GrabTheGoods', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:MapCreationID() ~= GOODS_GRAB_TRIGGER_ID then return end
			APADV.SendMapLocation('Grab the Goods')
			hook.Remove('AcceptInput', 'CV2_GrabTheGoods')
		end)
		hook.Add('OnNPCKilled', 'CV2_CrateDied', function(npc, attac, inflic)
			if npc:GetClass() ~= 'npc_combine_s' or npc:MapCreationID() == nil then return end
			for i, group in ipairs(crateGroups) do
				for j, crateID in ipairs(group) do
					if npc:MapCreationID() == crateID then
						table.remove(group, j)
						if group[1] == nil then
							if i == 1 then
								APADV.SendMapLocation('Kill First Crate')
							elseif i == 2 then
								APADV.SendMapLocation('Kill Flank Crates')
							elseif i == 3 then
								APADV.SendMapLocation('Kill Overlook Crate')
							elseif i == 4 then
								APADV.SendMapLocation('Kill Fence Crates')
							elseif i == 5 then
								APADV.SendMapLocation('Kill Rooftop Crates')
							elseif i == 6 then
								APADV.SendMapLocation('Kill Top Floor Crates')
							else --7
								APADV.SendMapLocation('Kill Elevator Crate')
							end
						end
						return
					end
				end
			end
		end)
		--One of the fence crates only shoots the bullseyes, so modify the `ai_relationship` to cause both of them to hate the bullseyes
		ents.FindByName('fencecop2-hate-bullseye')[1]:SetKeyValue('subject', 'fencecop*')
		hook.Add('AcceptInput', 'CV2_GetCrossbow', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:MapCreationID() ~= CROSSBOW_TRIGGER_ID then return end
			APADV.SendMapLocation('Crossbow')
			hook.Remove('AcceptInput', 'CV2_GetCrossbow')
		end)
		if APADV_ENTRNAME ~= 'Apartments' then
			local doors = ents.FindByName('elevatordoor1')
			for _, door in ipairs(doors) do
				door:Fire('Close')
				door:Fire('Lock')
			end
		end
		hook.Add('AcceptInput', 'CV2_RingDoorbell', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:MapCreationID() ~= DOORBELL_BUTTON_ID then return end
			APADV.SendMapLocation('Ring Doorbell')
			hook.Remove('AcceptInput', 'CV2_RingDoorbell')
		end)
		ents.FindByName('xbowprop')[1]:Fire('Kill')
		ents.FindByClass('npc_citizen')[1]:SetHealth(2147483647) --Max 32-bit integer
		hook.Add('EntityTakeDamage', 'CV2_KeepCitizenAlive', function(target, dmgInfo)
			if target:GetClass() == 'npc_citizen' then target:SetHealth(2147483647) end
		end)
		hook.Add('AcceptInput', 'CV2_BlockGivingPizza', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:GetName() ~= 'givepizza' then return end
			if not gotTheGoods then return true end
			APADV.SendMapLocation('Give Pizza')
			hook.Remove('AcceptInput', 'CV2_BlockGivingPizza')
		end)
		ents.FindByName('outrofade')[1]:Fire('Kill')
	end,

	CfgUnload = function(self)
		hook.Remove('OnNPCKilled', 'CV2_CrateDied')
		hook.Remove('AcceptInput', 'CV2_GetCrossbow')
		hook.Remove('SetupMove', 'CV2_ConstructionMusic')
		hook.Remove('AcceptInput', 'CV2_RingDoorbell')
		hook.Remove('AcceptInput', 'CV2_BlockGivingPizza')
	end,

	OnFullConnect = function(self)
		if APADV.MapLocationStatus('Grab the Goods') then
			ents.GetMapCreatedEntity(GOODS_TEXT_TRIGGER_ID):Fire('Kill')
			ents.FindByName('goods')[1]:Fire('Kill')
			ents.GetMapCreatedEntity(GOODS_GRAB_TRIGGER_ID):Fire('Kill')
		end
		for i, group in ipairs(crateGroups) do
			if
					(i == 1 and APADV.MapLocationStatus('Kill First Crate')) or
					(i == 2 and APADV.MapLocationStatus('Kill Flank Crates')) or
					(i == 3 and APADV.MapLocationStatus('Kill Overlook Crate')) or
					(i == 4 and APADV.MapLocationStatus('Kill Fence Crates')) or
					(i == 5 and APADV.MapLocationStatus('Kill Rooftop Crates')) or
					(i == 6 and APADV.MapLocationStatus('Kill Top Floor Crates')) or
					(i == 7 and APADV.MapLocationStatus('Kill Elevator Crate'))
			then
				for _, crateID in ipairs(group) do
					ents.GetMapCreatedEntity(crateID):Fire('Kill')
				end
				crateGroups[i] = {}
			end
		end
		if APADV.MapLocationStatus('Crossbow') then
			ents.GetMapCreatedEntity(CROSSBOW_TRIGGER_ID):Fire('Kill')
			ents.GetMapCreatedEntity(CROSSBOW_ID):Fire('Kill')
		end
	end,

	MapItemFuncs = {
		['The Goods'] = function(iList)
			if iList[1] == nil then return end
			gotTheGoods = true
		end,
		['Elevator'] = function(iList)
			if iList[1] == nil then return end
			local doors = ents.FindByName('elevatordoor1')
			for _, door in ipairs(doors) do
				door:Fire('Unlock')
				door:Fire('Open')
			end
		end
	}
}
