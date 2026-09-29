include('shared.lua')

local FRIDGE_DOOR_LEFT_INDEX = 1295
local FRIDGE_DOOR_RIGHT_INDEX = 1296
local HIDEOUT_GRATE_INDEX = 1287
local PICTURE_FRAME_INDEX = 1327

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    WPDAddGravityGunHooks(self)
    hook.Add('EntityTakeDamage', 'WPD_BreakGrate', function(target, dmginfo)
      if target:MapCreationID() ~= HIDEOUT_GRATE_INDEX then return end
      APADV.SendMapLocation('Break Grate')
      hook.Remove('EntityTakeDamage', 'WPD_BreakGrate')
    end)
    ents.FindByName('closetdoortrigger')[1]:Fire('Kill')
    WPDCloseAndLockDoor(ents.FindByName('closetdoor')[1])
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_INDEX))
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_INDEX))
    hook.Add('AcceptInput', 'WPD_DetachPicture', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= PICTURE_FRAME_INDEX then return end
      APADV.SendMapLocation('Detach Picture')
      hook.Remove('AcceptInput', 'WPD_DetachPicture')
    end)
    WPDCloseAndLockDoor(ents.FindByName('controlroomdoor')[1])
    hook.Add('AcceptInput', 'WPD_ControlRoomButton', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:GetName() ~= 'bonzibutton' then return end
      APADV.SendMapLocation('Control Room Button')
      hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
    end)
  end,

  CfgUnload = function(self)
    WPDRemoveGravityGunHooks(self)
    hook.Remove('EntityTakeDamage', 'WPD_BreakGrate')
    hook.Remove('AcceptInput', 'WPD_DetachPicture')
    hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
  end,

  OnFullConnect = function(self)
    WPDKillFoundGravityGun()
    if APADV.MapLocationStatus('Detach Picture') == true then
      ents.GetMapCreatedEntity(PICTURE_FRAME_INDEX):Fire('Kill')
    end
    if APADV.MapLocationStatus('Control Room Button') == true then
      ents.FindByName('bonzibutton')[1]:Fire('PressIn')
    end
  end,

  MapItemFuncs = {
    ['Fridge Doors'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_INDEX))
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_INDEX))
    end,
    ['Closet Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('closetdoor')[1])
    end,
    ['Control Room Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
