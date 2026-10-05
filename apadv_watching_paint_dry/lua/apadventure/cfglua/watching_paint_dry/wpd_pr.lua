include('shared.lua')

local FRIDGE_DOOR_LEFT_ID = 1295
local FRIDGE_DOOR_RIGHT_ID = 1296
local HIDEOUT_GRATE_ID = 1287
local PICTURE_FRAME_ID = 1327

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    WPDAddGravityGunHooks(self)
    hook.Add('EntityTakeDamage', 'WPD_BreakGrate', function(target, dmginfo)
      if target:MapCreationID() ~= HIDEOUT_GRATE_ID then return end
      APADV.SendMapLocation('Break Grate')
      hook.Remove('EntityTakeDamage', 'WPD_BreakGrate')
    end)
    ents.FindByName('closetdoortrigger')[1]:Fire('Kill')
    WPDCloseAndLockDoor(ents.FindByName('closetdoor')[1])
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_ID))
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_ID))
    hook.Add('AcceptInput', 'WPD_DetachPicture', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= PICTURE_FRAME_ID then return end
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
    if APADV.MapLocationStatus('Detach Picture') then
      ents.GetMapCreatedEntity(PICTURE_FRAME_ID):Fire('Kill')
    end
    if APADV.MapLocationStatus('Break Grate') then
      ents.GetMapCreatedEntity(HIDEOUT_GRATE_ID):TakeDamage(100)
    end
    if APADV.MapLocationStatus('Control Room Button') then
      ents.FindByName('bonzibutton')[1]:Fire('PressIn')
    end
  end,

  MapItemFuncs = {
    ['Fridge Doors'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_ID))
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_ID))
    end,
    ['Closet Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('closetdoor')[1])
    end,
    ['Control Room Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
