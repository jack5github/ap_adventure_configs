include('shared.lua')

local doorsToNowhere = { 1236, 1237, 1238 }
local CRATE_ID = 1259
local HEADCRAB_TRIGGER_ID = 1261
local BATTERY_TRIGGER_ID = 1268
local CONSTRUCTION_DOOR_ID = 1244
local GNOME_CHOMPSKI_ID = 1310
local COMBINE_ROOM_DOOR_ID = 1243
local HELICOPTER_BREAKABLE_ID = 1294

return {
	PostCfgLoad = function(self)
		hook.Add('AcceptInput', 'CV2_DoorsToNowhere', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:GetClass() ~= 'prop_door_rotating' then return end
			for i, doorID in ipairs(doorsToNowhere) do
				if ent:MapCreationID() == doorID then
					table.remove(doorsToNowhere, i)
				end
			end
			if doorsToNowhere[1] ~= nil then return end
			APADV.SendMapLocation('Open Doors to Nowhere')
			hook.Remove('AcceptInput', 'CV2_DoorsToNowhere')
		end)
		hook.Add('PropBreak', 'CV2_BreakCrate', function(attac, prop)
			if prop:MapCreationID() ~= CRATE_ID then return end
			APADV.SendMapLocation('Break Crate')
			hook.Remove('PropBreak', 'CV2_BreakCrate')
		end)
		--Block passage through vent from both ends by headcrab
		ents.GetMapCreatedEntity(HEADCRAB_TRIGGER_ID):SetPos(Vector(709, 160, 224))
		hook.Add('AcceptInput', 'CV2_KeepHeadcrabDown', function(ent, input, activ, callr)
			if ent:GetName() == 'crabcutout' and input == 'Open' then
				hook.Remove('AcceptInput', 'CV2_KeepHeadcrabDown')
				return true
			end
		end)
		CV2DisablePhysicsProp(ents.FindByName('batterypuz')[1])
		hook.Add('AcceptInput', 'CV2_BlockFuseBoxOutputs', function(ent, input, activ, callr)
			if IsValid(callr) and callr:MapCreationID() == BATTERY_TRIGGER_ID then
				APADV.SendMapLocation('Place Battery on Fuse Box')
				return true
			end
		end)
		ents.FindByName('puzdoor')[1]:Fire('Lock')
		ents.GetMapCreatedEntity(CONSTRUCTION_DOOR_ID):Fire('Lock')
		ents.GetMapCreatedEntity(GNOME_CHOMPSKI_ID):GetPhysicsObject():EnableMotion(true)
		hook.Add('AcceptInput', 'CV2_GrabGnomeChompski', function(ent, input, activ, callr)
			if input ~= 'Use' or ent:MapCreationID() ~= GNOME_CHOMPSKI_ID then return end
			APADV.SendMapLocation('Grab Gnome Chompski')
			hook.Remove('AcceptInput', 'CV2_GrabGnomeChompski')
		end)
		ents.GetMapCreatedEntity(COMBINE_ROOM_DOOR_ID):SetKeyValue('opendir', '2')
		hook.Add('AcceptInput', 'CV2_DestroyHelicopter', function(ent, input, activ, callr)
			if not IsValid(callr) or callr:MapCreationID() ~= HELICOPTER_BREAKABLE_ID then return end
			APADV.SendMapLocation('Destroy Helicopter')
			hook.Remove('AcceptInput', 'CV2_DestroyHelicopter')
			return true
		end)
	end,

	CfgUnload = function(self)
		hook.Remove('AcceptInput', 'CV2_DoorsToNowhere')
		hook.Remove('PropBreak', 'CV2_BreakCrate')
		hook.Remove('AcceptInput', 'CV2_KeepHeadcrabDown')
		hook.Remove('AcceptInput', 'CV2_BlockFuseBoxOutputs')
		hook.Remove('AcceptInput', 'CV2_GrabGnomeChompski')
		hook.Remove('AcceptInput', 'CV2_DestroyHelicopter')
	end,

	OnFullConnect = function(self)
		if APADV.MapLocationStatus('Break Crate') then
			ents.GetMapCreatedEntity(CRATE_ID):Fire('Kill')
		end
		if APADV.MapLocationStatus('Destroy Helicopter') then
			ents.GetMapCreatedEntity(HELICOPTER_BREAKABLE_ID):Fire('Kill')
		end
	end,

	MapItemFuncs = {
		['Battery'] = function(iList)
			if iList[1] == nil then return end
			CV2EnablePhysicsProp(ents.FindByName('batterypuz')[1])
		end,
		['Remove Headcrab'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('crabcutout')[1]:Fire('Kill')
		end,
		['Roller Door'] = function(iList)
			if iList[1] == nil then return end
			ents.FindByName('puzdoor')[1]:Fire('Unlock')
			ents.FindByName('puzdoor')[1]:Fire('Open')
			ents.FindByName('puzdoor')[1]:Fire('Lock')
		end,
		['Construction Room Door'] = function(iList)
			if iList[1] == nil then return end
			ents.GetMapCreatedEntity(CONSTRUCTION_DOOR_ID):Fire('Unlock')
		end
	}
}
