include('shared.lua')

local FRIDGE_DOOR_LEFT_INDEX = 1451
local FRIDGE_DOOR_RIGHT_INDEX = 1452
local FRIDGE_POWER_SWITCH_INDEX = 1502
local WINDOW_DOOR_INDEX = 1329
local HIDEOUT_POWER_SWITCH_INDEX = 1505
local HIDEOUT_GRATE_INDEX = 1340
local PICTURE_FRAME_INDEX = 1378
local CONTROL_ROOL_POWER_SWITCH_INDEX = 1508
local FRIDGE_BONZI_INDEX = 1411

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    hook.Add('PlayerInitialSpawn', 'WPD_FirstSpawn', function(ply)
      --`spawn_trigger` 'OnTrigger' outputs
      if APADV_ENTRNAME == nil then --New game
        ents.FindByName('fadein')[1]:Fire('Fade')
      end
      ents.FindByName('narrator_welcome')[1]:Fire('PlaySound', nil, 4)
      --ents.FindByName('Press E to interact with Objects')[1]:Fire('Display', nil, 5)
      ents.FindByName('wallpaintgrasstrigger')[1]:Fire('Kill', nil, 20)
      ents.FindByName('wallpaintgrassbrush')[1]:Fire('Kill', nil, 20)
      ents.FindByName('wallpaintfailtrigger')[1]:Fire('Kill', nil, 14400)
      ents.FindByName('wallpaintbrush')[1]:Fire('Kill', nil, 14400)
      hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    end)
    --Splashing paint from paint cans not added as a location; seems like a lot of effort for little reward
    hook.Add('AcceptInput', 'WPD_NoPatience', function(ent, input, activ, callr)
      if ent:GetName() ~= 'narrator_grass' then return end
      APADV.SendMapLocation('No Patience')
      hook.Remove('AcceptInput', 'WPD_NoPatience')
    end)
    hook.Add('AcceptInput', 'WPD_Fail', function(ent, input, activ, callr)
      if ent:GetName() ~= 'narrator_notdry' then return end
      APADV.SendMapLocation('Fail')
      hook.Remove('AcceptInput', 'WPD_Fail')
    end)
    hook.Add('AcceptInput', 'WPD_Win', function(ent, input, activ, callr)
      if ent:GetName() ~= 'narrator_dry' then return end
      APADV.SendMapLocation('Win')
      hook.Remove('AcceptInput', 'WPD_Win')
    end)
    ents.GetMapCreatedEntity(1463):Fire('Kill') --`trigger_multiple` in Painting
    hook.Add('AcceptInput', 'WPD_Key', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:GetName() ~= 'key01' then return end
      APADV.SendMapLocation('Key')
      WPDDisablePhysicsProp(ent)
      hook.Remove('AcceptInput', 'WPD_Key')
    end)
    ents.GetMapCreatedEntity(1355):Fire('Kill') --`trigger_once` at First Door
    WPDCloseAndLockDoor(ents.FindByName('firstdoor')[1])
    WPDAddGravityGunHooks(self)
    hook.Add('AcceptInput', 'WPD_ReadNewspaper', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:GetModel() ~= 'models/props_junk/garbage_newspaper001a.mdl' then return end
      APADV.SendMapLocation('Read Newspaper')
      hook.Remove('AcceptInput', 'WPD_ReadNewspaper')
    end)
    WPDDisablePhysicsProp(ents.FindByName('Clock')[1])
    WPDDisablePhysicsProp(ents.FindByName('ClockBack')[1])
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_INDEX))
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_INDEX))
    hook.Add('AcceptInput', 'WPD_FridgePowerSwitch', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= FRIDGE_POWER_SWITCH_INDEX then return end
      APADV.SendMapLocation('Fridge Power Switch')
      hook.Remove('AcceptInput', 'WPD_FridgePowerSwitch')
    end)
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(WINDOW_DOOR_INDEX))
    hook.Add('EntityTakeDamage', 'WPD_BreakGrate', function(target, dmginfo)
      if target:MapCreationID() ~= HIDEOUT_GRATE_INDEX then return end
      APADV.SendMapLocation('Break Grate')
      hook.Remove('EntityTakeDamage', 'WPD_BreakGrate')
    end)
    WPDDisablePhysicsProp(ents.FindByName('Computer')[1])
    WPDDisablePhysicsProp(ents.FindByName('key02')[1])
    hook.Add('AcceptInput', 'WPD_LowerHideoutPowerSwitch', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= HIDEOUT_POWER_SWITCH_INDEX then return end
      APADV.SendMapLocation('Hideout Power Switch')
      hook.Remove('AcceptInput', 'WPD_LowerHideoutPowerSwitch')
    end)
    ents.FindByName('closetdoortrigger')[1]:Fire('Kill')
    WPDDisablePhysicsProp(ents.FindByName('Dish')[1])
    WPDCloseAndLockDoor(ents.FindByName('closetdoor')[1])
    WPDCloseAndLockDoor(ents.FindByName('TimeTravelDoor')[1])
    hook.Add('AcceptInput', 'WPD_AttachClock', function(ent, input, activ, callr)
      if ent:GetName() ~= 'ClockLogicRelay' then return end
      APADV.SendMapLocation('Attach Clock')
      hook.Remove('AcceptInput', 'WPD_AttachClock')
    end)
    hook.Add('AcceptInput', 'WPD_AttachDish', function(ent, input, activ, callr)
      if ent:GetName() ~= 'DishLogicRelay' then return end
      APADV.SendMapLocation('Attach Dish')
      hook.Remove('AcceptInput', 'WPD_AttachDish')
    end)
    hook.Add('AcceptInput', 'WPD_AttachMonitor', function(ent, input, activ, callr)
      if ent:GetName() ~= 'ComputerLogicRelay' then return end
      APADV.SendMapLocation('Attach Monitor')
      hook.Remove('AcceptInput', 'WPD_AttachMonitor')
    end)
    ents.FindByName('TimeMachineButton')[1]:Fire('Lock')
    hook.Add('AcceptInput', 'WPD_NotEnoughProgressivePower', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:GetName() ~= 'TimeMachineButton' then return end
      callr:PrintMessage(4, "The time machine isn't powered on! Come back when you have more Progressive Power.")
    end)
    hook.Add('AcceptInput', 'WPD_TimeTravel', function(ent, input, activ, callr)
      if not IsValid(callr) or callr:GetName() ~= 'TeleportTrigger' then return end
      APADV.SendMapLocation('Time Travel')
      hook.Remove('AcceptInput', 'WPD_TimeTravel')
    end)
    hook.Add('AcceptInput', 'WPD_PreventMovingDoors', function(ent, input, activ, callr)
      if
          IsValid(callr) and (
            callr:GetName() == 'PostPortalRelay' or
            callr:GetName() == 'bonzibutton'
          ) and
          string.find(ent:GetName(), 'door') then
        return true
      end
    end)
    WPDCloseAndLockDoor(ents.FindByName('bathroomdoor')[1])
    ents.FindByName('fadeout')[1]:Fire('Kill') --`env_fade` after flushing toilet
    hook.Add('AcceptInput', 'WPD_FlushToilet', function(ent, input, activ, callr)
      if not IsValid(callr) or callr:GetClass() ~= 'func_button' or ent:GetName() ~= 'toilet_sound' then return end
      APADV.SendMapLocation('Flush Toilet')
      hook.Remove('AcceptInput', 'WPD_FlushToilet')
    end)
    hook.Add('AcceptInput', 'WPD_DetachPicture', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= PICTURE_FRAME_INDEX then return end
      APADV.SendMapLocation('Detach Picture')
      hook.Remove('AcceptInput', 'WPD_DetachPicture')
    end)
    hook.Add('AcceptInput', 'WPD_ScanKeycard', function(ent, input, activ, callr)
      if not IsValid(callr) or callr:MapCreationID() ~= 1393 or ent:GetName() ~= 'keysound' then return end
      APADV.SendMapLocation('Scan Keycard')
      hook.Remove('AcceptInput', 'WPD_ScanKeycard')
    end)
    WPDCloseAndLockDoor(ents.FindByName('controlroomdoor')[1])
    hook.Add('AcceptInput', 'WPD_ControlRoomPowerSwitch', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= CONTROL_ROOL_POWER_SWITCH_INDEX then return end
      APADV.SendMapLocation('Control Room Power Switch')
      hook.Remove('AcceptInput', 'WPD_ControlRoomPowerSwitch')
    end)
    hook.Add('AcceptInput', 'WPD_ControlRoomButton', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:GetName() ~= 'bonzibutton' then return end
      APADV.SendMapLocation('Awake Bonzi')
      hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
    end)
    hook.Add('AcceptInput', 'WPD_BonziAppears', function(ent, input, activ, callr)
      if not IsValid(callr) or callr:GetName() ~= 'bonzibutton' or ent:GetName() ~= 'Flash' then return end
      local exits = ents.FindByClass('apadventure_exit')
      for _, exit in ipairs(exits) do
        if exit:GetTable()['ExitName'] == 'Control Room' then
          WPDDisablePhysicsProp(exit)
          break
        end
      end
      hook.Remove('AcceptInput', 'WPD_BonziAppears')
    end)
    ents.GetMapCreatedEntity(FRIDGE_BONZI_INDEX):Fire('Kill')
    hook.Add('AcceptInput', 'WPD_WorldEradicated', function(ent, input, activ, callr)
      if not IsValid(callr) or callr:GetName() ~= 'bonzibutton' or ent:GetName() ~= 'closegame' then return end
      APADV.SendMapLocation('World Eradicated')
      WPDKillAllPlayers()
      ents.FindByName('bonzifinalshake')[1]:Fire('StopShake')
      ents.FindByName('rumble')[1]:Fire('StopSound') --Alarm sound
      ents.FindByName('fog_controller')[1]:Fire('Kill')
      ents.FindByName('bonzicc')[1]:Fire('Kill')     --Bonzi colour correction
      ents.FindByName('b o n z i')[1]:Fire('Kill')   --Bonzi himself
      local exits = ents.FindByClass('apadventure_exit')
      for _, exit in ipairs(exits) do
        if exit:GetTable()['ExitName'] == 'Control Room' then
          WPDEnablePhysicsProp(exit, false)
          break
        end
      end
      hook.Remove('AcceptInput', 'WPD_WorldEradicated')
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    hook.Remove('AcceptInput', 'WPD_NoPatience')
    hook.Remove('AcceptInput', 'WPD_Fail')
    hook.Remove('AcceptInput', 'WPD_Win')
    hook.Remove('AcceptInput', 'WPD_Key')
    WPDRemoveGravityGunHooks(self)
    hook.Remove('AcceptInput', 'WPD_ReadNewspaper')
    hook.Remove('AcceptInput', 'WPD_FridgePowerSwitch')
    hook.Remove('AcceptInput', 'WPD_LowerHideoutPowerSwitch')
    hook.Remove('EntityTakeDamage', 'WPD_BreakGrate')
    hook.Remove('AcceptInput', 'WPD_AttachDish')
    hook.Remove('AcceptInput', 'WPD_AttachClock')
    hook.Remove('AcceptInput', 'WPD_AttachMonitor')
    hook.Remove('AcceptInput', 'WPD_NotEnoughProgressivePower')
    hook.Remove('AcceptInput', 'WPD_TimeTravel')
    hook.Remove('AcceptInput', 'WPD_PreventMovingDoors')
    hook.Remove('AcceptInput', 'WPD_FlushToilet')
    hook.Remove('AcceptInput', 'WPD_DetachPicture')
    hook.Remove('AcceptInput', 'WPD_ScanKeycard')
    hook.Remove('AcceptInput', 'WPD_ControlRoomPowerSwitch')
    hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
    hook.Remove('AcceptInput', 'WPD_BonziAppears')
    hook.Remove('AcceptInput', 'WPD_WorldEradicated')
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Key') == true then
      ents.GetMapCreatedEntity(1377):GetPhysicsObject():EnableMotion(true) --First room grate
      ents.FindByName('key01')[1]:Fire('Kill')
    end
    WPDKillFoundGravityGun()
    if APADV.MapLocationStatus('Fridge Power Switch') == true then
      ents.GetMapCreatedEntity(FRIDGE_POWER_SWITCH_INDEX):Fire('Open')
    end
    if APADV.MapLocationStatus('Hideout Power Switch') == true then
      ents.GetMapCreatedEntity(HIDEOUT_POWER_SWITCH_INDEX):Fire('Open')
    end
    if APADV.MapLocationStatus('Break Grate') == true then
      ents.GetMapCreatedEntity(HIDEOUT_GRATE_INDEX):TakeDamage(100)
    end
    if APADV.MapLocationStatus('Attach Clock') == true then
      ents.FindByName('ClockLogicRelay')[1]:Fire('Trigger')
    end
    if APADV.MapLocationStatus('Attach Monitor') == true then
      ents.FindByName('ComputerLogicRelay')[1]:Fire('Trigger')
    end
    if APADV.MapLocationStatus('Attach Dish') == true then
      ents.FindByName('DishLogicRelay')[1]:Fire('Trigger')
    end
    if APADV.MapLocationStatus('Detach Picture') == true then
      ents.GetMapCreatedEntity(PICTURE_FRAME_INDEX):Fire('Kill')
    end
    if APADV.MapLocationStatus('Control Room Power Switch') == true then
      ents.GetMapCreatedEntity(CONTROL_ROOL_POWER_SWITCH_INDEX):Fire('Open')
    end
    --Do not 'PressIn' `bonzibutton`, starts Bonzi sequence
  end,

  MapItemFuncs = {
    ['First Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('firstdoor')[1])
    end,
    ['Clock'] = function(iList)
      if #iList == 0 then return end
      WPDEnablePhysicsProp(ents.FindByName('Clock')[1], false)
      WPDEnablePhysicsProp(ents.FindByName('ClockBack')[1], false)
    end,
    ['Fridge Doors'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_INDEX))
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_INDEX))
    end,
    ['Window Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(WINDOW_DOOR_INDEX))
    end,
    ['Monitor'] = function(iList)
      if #iList == 0 then return end
      WPDEnablePhysicsProp(ents.FindByName('Computer')[1], nil)
    end,
    ['Keycard'] = function(iList)
      if #iList == 0 then return end
      WPDEnablePhysicsProp(ents.FindByName('key02')[1], nil)
    end,
    ['Dish'] = function(iList)
      if #iList == 0 then return end
      WPDEnablePhysicsProp(ents.FindByName('Dish')[1], nil)
    end,
    ['Closet Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('closetdoor')[1])
    end,
    ['Time Travel Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('TimeTravelDoor')[1])
    end,
    ['Progressive Power'] = function(iList)
      if #iList < 3 then return end
      ents.FindByName('TimeMachineButton')[1]:Fire('Unlock')
      hook.Remove('AcceptInput', 'WPD_NotEnoughProgressivePower')
    end,
    ['Bathroom Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('bathroomdoor')[1])
    end,
    ['Control Room Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
