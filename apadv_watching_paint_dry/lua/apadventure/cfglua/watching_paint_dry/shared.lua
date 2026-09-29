WPDCloseAndLockDoor = function(ent)
	ent:Fire('Close')
	ent:Fire('Lock')
end

local EF_NODRAW = 32
local FVPHYSICS_NO_PLAYER_PICKUP = 128

---Disables a prop by hiding it visually, disabling its motion and preventing it from being picked up.
---@param ent Entity The prop to disable.
WPDDisablePhysicsProp = function(ent)
	ent:AddEffects(EF_NODRAW)
	ent:SetNotSolid(true)
	local phys = ent:GetPhysicsObject()
	phys:EnableMotion(false)
	phys:AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
end

WPDAddGravityGunHooks = function(self)
	hook.Add('PlayerCanPickupWeapon', self, function(self, ply, wep)
		if wep:GetClass() ~= 'weapon_physcannon' or wep:MapCreationID() == -1 then return end
		APADV.SendMapLocation('Gravity Gun')
		wep:Fire('Kill')
		hook.Remove('PlayerCanPickupWeapon', self)
		hook.Remove('AcceptInput', 'WPD_GravityGunAlreadyEquipped')
	end)
	hook.Add('AcceptInput', 'WPD_GravityGunAlreadyEquipped', function(ent, input, activ, callr)
		if input ~= 'Use' or ent:GetClass() ~= 'weapon_physcannon' then return end
		APADV.SendMapLocation('Gravity Gun')
		ent:Fire('Kill')
		hook.Remove('PlayerCanPickupWeapon', self)
		hook.Remove('AcceptInput', 'WPD_GravityGunAlreadyEquipped')
	end)
end

WPDKillAllPlayers = function()
	local filter = RecipientFilter()
	filter:AddAllPlayers()
	local players = filter:GetPlayers()
	for _, player in ipairs(players) do
		if player:Alive() then
			player:Kill()
		end
	end
end

WPDRemoveGravityGunHooks = function(self)
	hook.Remove('PlayerCanPickupWeapon', self)
	hook.Remove('AcceptInput', 'WPD_GravityGunAlreadyEquipped')
end

WPDKillFoundGravityGun = function()
	if APADV.MapLocationStatus('Gravity Gun') ~= true then return end
	for _, gravityGun in ipairs(ents.FindByClass('weapon_physcannon')) do
		if gravityGun:MapCreationID() ~= -1 then
			gravityGun:Fire('Kill')
			break
		end
	end
end

WPDOpenLockedDoor = function(ent)
	ent:Fire('Unlock')
	ent:Fire('Open')
	ent:Fire('Lock')
end

---Enables a prop by showing it visually, enabling its motion and allowing it to be picked up.
---@param ent Entity The prop to disable.
---@param enableMotion boolean | nil Whether the prop's motion should be enabled. Defaults to true. Set to false for the Clock props, as they are wall-mounted.
WPDEnablePhysicsProp = function(ent, enableMotion)
	ent:RemoveEffects(EF_NODRAW)
	ent:SetNotSolid(false)
	local phys = ent:GetPhysicsObject()
	if enableMotion ~= false then
		phys:EnableMotion(true)
	end
	phys:ClearGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
end
