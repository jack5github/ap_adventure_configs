include('shared.lua')

local FRIDGE_DOOR_LEFT_ID = 1335
local FRIDGE_DOOR_RIGHT_ID = 1336
local PICTURE_FRAME_ID = 1388
local RED_BUTTON_ID = 1375
local earthDestroyed

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    if APADV_ENTRNAME ~= 'First Room' then
      ents.FindByName('music_trigger')[1]:Fire('Kill')
      ents.FindByName('music')[1]:Fire('PlaySound', nil, 1.5)
    end
    WPDCloseAndLockDoor(ents.FindByName('firstdoor')[1])
    WPDAddGravityGunHooks(self)
    hook.Add('AcceptInput', 'WPD_ReadNewspaper', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:GetModel() ~= 'models/props_junk/garbage_newspaper001a.mdl' then return end
      APADV.SendMapLocation('Read Newspaper')
      hook.Remove('AcceptInput', 'WPD_ReadNewspaper')
    end)
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_ID))
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_ID))
    WPDCloseAndLockDoor(ents.FindByName('LaunchDoor')[1])
    hook.Add('AcceptInput', 'WPD_RedButton', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= RED_BUTTON_ID then return end
      --[[
      Garry's Mod seems unable to stop music from playing; this isn't too much of an issue
      ents.FindByName('music')[1]:Fire('StopSound')
      ]]
      APADV.SendMapLocation('Red Button')
      hook.Remove('AcceptInput', 'WPD_RedButton')
    end)
    hook.Add('AcceptInput', 'WPD_DestroyEarth', function(ent, input, activ, callr)
      if ent:GetName() ~= 'ExplosionNoise' then return end
      APADV.SendMapLocation('Destroy Earth')
      hook.Remove('AcceptInput', 'WPD_DestroyEarth')
    end)
    hook.Add('AcceptInput', 'WPD_BlockRedButtonOutputs', function(ent, input, activ, callr)
      if
          IsValid(callr) and
          callr:MapCreationID() == RED_BUTTON_ID and
          (ent:GetName() == 'LaunchDoor' or earthDestroyed)
      then
        return true
      end
    end)
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
    hook.Remove('AcceptInput', 'WPD_ReadNewspaper')
    hook.Remove('AcceptInput', 'WPD_RedButton')
    hook.Remove('AcceptInput', 'WPD_DestroyEarth')
    hook.Remove('AcceptInput', 'WPD_BlockRedButtonOutputs')
    hook.Remove('AcceptInput', 'WPD_DetachPicture')
    hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
  end,

  OnFullConnect = function(self)
    WPDKillFoundGravityGun()
    if APADV.MapLocationStatus('Destroy Earth') then
      earthDestroyed = true
      ents.FindByName('EarthSafe')[1]:Fire('Open') --Destroyed Earth
      ents.GetMapCreatedEntity(RED_BUTTON_ID):Fire('PressIn')
    end
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
    ['Launch Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('LaunchDoor')[1])
    end,
    ['Control Room Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
