include('shared.lua')

local FRIDGE_DOOR_LEFT_INDEX = 1440
local FRIDGE_DOOR_RIGHT_INDEX = 1441
local PICTURE_FRAME_INDEX = 1349

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    WPDCloseAndLockDoor(ents.FindByName('firstdoor')[1])
    WPDAddGravityGunHooks(self)
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
    hook.Add('AcceptInput', 'WPD_ZombieButton', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:GetName() ~= 'zombiebutton' then return end
      APADV.SendMapLocation('Zombie Button')
      hook.Remove('AcceptInput', 'WPD_ZombieButton')
    end)
  end,

  CfgUnload = function(self)
    WPDRemoveGravityGunHooks(self)
    hook.Remove('AcceptInput', 'WPD_DetachPicture')
    hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
    hook.Remove('AcceptInput', 'WPD_ZombieButton')
  end,

  OnFullConnect = function(self)
    WPDKillFoundGravityGun()
    if APADV.MapLocationStatus('Detach Picture') == true then
      ents.GetMapCreatedEntity(PICTURE_FRAME_INDEX):Fire('Kill')
    end
    if APADV.MapLocationStatus('Control Room Button') == true then
      ents.FindByName('bonzibutton')[1]:Fire('PressIn')
    end
    if APADV.MapLocationStatus('Zombie Button') == true then
      ents.FindByName('zombiebuttonsound')[1]:Fire('Kill')
      ents.FindByName('zombiescream')[1]:Fire('Kill')
      ents.FindByName('zombiebutton')[1]:Fire('PressIn')
    end
  end,

  MapItemFuncs = {
    ['First Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('firstdoor')[1])
    end,
    ['Fridge Doors'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_INDEX))
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_INDEX))
    end,
    ['Control Room Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
