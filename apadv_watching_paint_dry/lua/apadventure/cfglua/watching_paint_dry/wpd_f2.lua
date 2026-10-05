include('shared.lua')

local FRIDGE_DOOR_LEFT_ID = 1460
local FRIDGE_DOOR_RIGHT_ID = 1461
local PICTURE_FRAME_ID = 1350

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    WPDCloseAndLockDoor(ents.FindByName('firstdoor')[1])
    WPDAddGravityGunHooks(self)
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
    hook.Remove('AcceptInput', 'WPD_DetachPicture')
    hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
  end,

  OnFullConnect = function(self)
    WPDKillFoundGravityGun()
    if APADV.MapLocationStatus('Detach Picture') then
      ents.GetMapCreatedEntity(PICTURE_FRAME_ID):Fire('Kill')
    end
    if APADV.MapLocationStatus('Control Room Button') then
      ents.FindByName('bonzibutton')[1]:Fire('PressIn')
    end
  end,

  MapItemFuncs = {
    ['First Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('firstdoor')[1])
    end,
    ['Fridge Doors'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_ID))
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_ID))
    end,
    ['Control Room Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
