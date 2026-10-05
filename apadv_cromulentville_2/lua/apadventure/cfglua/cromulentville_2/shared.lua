local EF_NODRAW = 32
local FVPHYSICS_NO_PLAYER_PICKUP = 128

---Disables a prop by hiding it visually, disabling its motion and preventing it from being picked up.
---@param ent Entity The prop to disable.
CV2DisablePhysicsProp = function(ent)
	ent:AddEffects(EF_NODRAW)
	ent:SetNotSolid(true)
	local phys = ent:GetPhysicsObject()
	phys:EnableMotion(false)
	phys:AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
end

---Enables a prop by showing it visually, enabling its motion and allowing it to be picked up.
---@param ent Entity The prop to enable.
---@param enableMotion boolean | nil Whether the prop's motion should be enabled. Defaults to true. Set to false for the Clock props, as they are wall-mounted.
CV2EnablePhysicsProp = function(ent, enableMotion)
	ent:RemoveEffects(EF_NODRAW)
	ent:SetNotSolid(false)
	local phys = ent:GetPhysicsObject()
	if enableMotion ~= false then
		phys:EnableMotion(true)
	end
	phys:ClearGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
end
