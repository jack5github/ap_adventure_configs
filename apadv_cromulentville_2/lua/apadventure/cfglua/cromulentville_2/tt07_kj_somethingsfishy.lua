local explosions = -1
local supplyCrates = { 1893, 1892, 1903, 1902 }

return {
	PostCfgLoad = function(self)
		hook.Add('PlayerCanPickupWeapon', self, function(self, ply, wep)
			if wep:GetName() ~= 'w_physgun' then return end
			APADV.SendMapLocation('Super Gravity Gun')
			wep:Fire('Kill')
			ents.FindByName('relay_physgunpickup')[1]:Fire('Trigger')
			hook.Remove('PlayerCanPickupWeapon', self)
			hook.Remove('AcceptInput', 'CV2_GravityGunAlreadyEquipped')
		end)
		hook.Add('AcceptInput', 'CV2_GravityGunAlreadyEquipped', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:GetName() ~= 'w_physgun' then return end
			APADV.SendMapLocation('Super Gravity Gun')
			ent:Fire('Kill')
			ents.FindByName('relay_physgunpickup')[1]:Fire('Trigger')
			hook.Remove('PlayerCanPickupWeapon', self)
			hook.Remove('AcceptInput', 'CV2_GravityGunAlreadyEquipped')
		end)
		--Max 32-bit integer
		ents.FindByClass('npc_alyx')[1]:SetHealth(2147483647)
		ents.FindByClass('npc_breen')[1]:SetHealth(2147483647)
		hook.Add('EntityTakeDamage', 'CV2_KeepNPCsAlive', function(target, dmgInfo)
			if
					target:Health() ~= 0 and (
						target:GetClass() == 'npc_alyx' or target:GetClass() == 'npc_breen'
					)
			then
				target:SetHealth(2147483647)
			end
		end)
		hook.Add('AcceptInput', 'CV2_AlyxDies', function(ent, input, activ, callr)
			if explosions == -1 then
				if not IsValid(callr) or callr:GetName() ~= 'fishbot_rise_from_hell' then return end
				explosions = 0
			elseif ent:GetClass() ~= 'env_explosion' or input ~= 'Explode' then
				return
			end
			explosions = explosions + 1
			--Although only 4 explosions are fired, Alyx seems to die 1 explosion early, so break the window at 5
			if explosions < 5 then return end
			local window = ents.FindByName('window_break')[1]
			if window == nil then return end
			window:Fire('Break')
			APADV.SendMapLocation('Alyx Dies')
			hook.Remove('AcceptInput', 'CV2_AlyxDies')
		end)
		hook.Add('PropBreak', 'CV2_BreakAllCrates', function(attac, prop)
			if prop:GetClass() ~= 'item_item_crate' then return end
			for i, supplyCrate in ipairs(supplyCrates) do
				if prop:MapCreationID() == supplyCrate then
					table.remove(supplyCrates, i)
					break
				end
			end
			if supplyCrates[1] ~= nil then return end
			APADV.SendMapLocation('Break All Crates')
			hook.Remove('PropBreak', 'CV2_BreakAllCrates')
		end)
		ents.FindByName('turret3-tank')[1]:Fire('SetFireRate', '0')
		ents.FindByName('turret1-tank')[1]:Fire('SetFireRate', '0')
		--Explosions in this map deal little to no damage and have little to no radius in Garry's Mod; this is a brute force patch that applies damage and radius floor to all explosions
		hook.Add('AcceptInput', 'CV2_FixCannons', function(ent, input, activ, callr)
			if ent:GetClass() ~= 'env_explosion' or input ~= 'Explode' then return end
			local explosionKVs = ent:GetKeyValues()
			if tonumber(explosionKVs['iMagnitude']) >= 150 or tonumber(explosionKVs['iRadiusOverride']) >= 300 then return end
			ent:SetKeyValue('iMagnitude', '150')
			ent:SetKeyValue('iRadiusOverride', '300')
		end)
		hook.Add('AcceptInput', 'CV2_DefeatFishermanRobot', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:GetName() ~= 'relay_fishbot_explode_finale' then return end
			APADV.SendMapLocation('Defeat Fisherman Robot')
			if ent:GetName() ~= 'relay_end' then return end
			--Prevent ending cutscene
			hook.Remove('AcceptInput', 'CV2_FixCannons')
			hook.Remove('AcceptInput', 'CV2_DefeatFishermanRobot')
			return true
		end)
	end,

	CfgUnload = function(self)
		hook.Remove('PlayerCanPickupWeapon', self)
		hook.Remove('AcceptInput', 'CV2_GravityGunAlreadyEquipped')
		hook.Remove('EntityTakeDamage', 'CV2_KeepNPCsAlive')
		hook.Remove('AcceptInput', 'CV2_AlyxDies')
		hook.Remove('PropBreak', 'CV2_BreakAllCrates')
		hook.Remove('AcceptInput', 'CV2_FixCannons')
		hook.Remove('AcceptInput', 'CV2_DefeatFishermanRobot')
	end,

	MapItemFuncs = {
		['Cannons'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('turret3-tank')[1]:Fire('SetFireRate', '1')
			ents.FindByName('turret1-tank')[1]:Fire('SetFireRate', '1')
		end
	}
}
