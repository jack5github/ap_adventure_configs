include('shared.lua')

local PAINT_CANS = {
  --First Room
  { ['id'] = 1270, ['region'] = 0 },
  { ['id'] = 1248, ['region'] = 0 },
  { ['id'] = 1278, ['region'] = 0 },
  --Lower Hideout
  { ['id'] = 1457, ['region'] = 1 },
  { ['id'] = 1455, ['region'] = 1 },
  { ['id'] = 1456, ['region'] = 1 },
  { ['id'] = 1462, ['region'] = 1 },
  { ['id'] = 1463, ['region'] = 1 },
  { ['id'] = 1461, ['region'] = 1 },
  { ['id'] = 1460, ['region'] = 1 },
  { ['id'] = 1459, ['region'] = 1 },
  { ['id'] = 1458, ['region'] = 1 },
  { ['id'] = 1464, ['region'] = 1 },
  { ['id'] = 1465, ['region'] = 1 },
  { ['id'] = 1466, ['region'] = 1 },
  --Narrator's Room
  { ['id'] = 1472, ['region'] = 2 },
  { ['id'] = 1471, ['region'] = 2 },
  { ['id'] = 1470, ['region'] = 2 },
  { ['id'] = 1473, ['region'] = 2 },
  { ['id'] = 1474, ['region'] = 2 },
}
local FRIDGE_DOOR_LEFT_ID = 1371
local FRIDGE_DOOR_RIGHT_ID = 1370
local WINDOW_DOOR_ID = 1302
local HIDEOUT_GRATE_ID = 1310
local BUTTON_UNDER_DESK_ID = 1416
local CONTROL_ROOM_BUTTON_ID = 1398
local NARRATOR_PROP_ID = 1375

local narratorDmgTaken = 0

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    if APADV_ENTRNAME == "Narrator's Room" then
      ents.FindByName('radiomusic')[1]:Fire('PlaySound')
    end
    for _, paintCan in ipairs(PAINT_CANS) do
      WPDDisablePhysicsProp(ents.GetMapCreatedEntity(paintCan.id))
    end
    WPDCloseAndLockDoor(ents.FindByName('firstdoor')[1])
    WPDAddGravityGunHooks(self)
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_ID))
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_ID))
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(WINDOW_DOOR_ID))
    hook.Add('EntityTakeDamage', 'WPD_BreakGrate', function(target, dmginfo)
      if target:MapCreationID() ~= HIDEOUT_GRATE_ID then return end
      APADV.SendMapLocation('Break Grate')
      hook.Remove('EntityTakeDamage', 'WPD_BreakGrate')
    end)
    ents.FindByName('closetdoortrigger')[1]:Fire('Kill')
    WPDCloseAndLockDoor(ents.FindByName('closetdoor')[1])
    WPDCloseAndLockDoor(ents.FindByName('controlroomdoor')[1])
    if APADV_ENTRNAME == "Narrator's Room" then
      hook.Add('AcceptInput', 'WPD_BlockRadioMusic', function(ent, input, activ, callr)
        if not IsValid(callr) or callr:GetClass() ~= 'trigger_multiple' or ent:GetName() ~= 'radiomusic' then return end
        hook.Remove('AcceptInput', 'WPD_BlockRadioMusic')
        return true
      end)
    end
    hook.Add('AcceptInput', 'WPD_MeetTheNarrator', function(ent, input, activ, callr)
      if ent:GetName() ~= 'narrator_welcome_sound' then return end
      APADV.SendMapLocation('Meet the Narrator')
      hook.Remove('AcceptInput', 'WPD_MeetTheNarrator')
    end)
    hook.Add('AcceptInput', 'WPD_ButtonUnderDesk', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= BUTTON_UNDER_DESK_ID then return end
      APADV.SendMapLocation('Button Under Desk')
      hook.Remove('AcceptInput', 'WPD_ButtonUnderDesk')
    end)
    hook.Add('AcceptInput', 'WPD_ControlRoomButton', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= CONTROL_ROOM_BUTTON_ID then return end
      APADV.SendMapLocation('Control Room Button')
      hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
    end)
    hook.Add('EntityTakeDamage', 'WPD_PlayerBrutality', function(target, dmginfo)
      if target:MapCreationID() ~= NARRATOR_PROP_ID or not dmginfo:GetAttacker():IsPlayer() then return end
      narratorDmgTaken = narratorDmgTaken + dmginfo:GetDamage()
      if narratorDmgTaken >= 100 then
        APADV.SendMapLocation('Player Brutality')
        hook.Remove('EntityTakeDamage', 'WPD_PlayerBrutality')
      end
    end)
    hook.Add('AcceptInput', 'WPD_PaintCanParadox', function(ent, input, activ, callr)
      if ent:GetName() ~= 'sneeze' then return end
      APADV.SendMapLocation('Hit Narrator with Paint Can')
      timer.Simple(140, function()
        APADV.SendMapLocation('Create Paradox')
      end)
      hook.Remove('AcceptInput', 'WPD_PaintCanParadox')
    end)
    --Normally stays fully white for 30 seconds, impossible to play in this state
    ents.FindByName('sneezeexplosionfade')[1]:SetKeyValue('holdtime', 5)
    WPDCloseAndLockDoor(ents.FindByName('shelfdoor')[1])
    WPDCloseAndLockDoor(ents.FindByName('narratordoor')[1])
  end,

  CfgUnload = function(self)
    WPDRemoveGravityGunHooks(self)
    hook.Remove('EntityTakeDamage', 'WPD_BreakGrate')
    hook.Remove('AcceptInput', 'WPD_BlockRadioMusic')
    hook.Remove('AcceptInput', 'WPD_MeetTheNarrator')
    hook.Remove('AcceptInput', 'WPD_ButtonUnderDesk')
    hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
    hook.Remove('EntityTakeDamage', 'WPD_PlayerBrutality')
    hook.Remove('AcceptInput', 'WPD_PaintCanParadox')
  end,

  OnFullConnect = function(self)
    WPDKillFoundGravityGun()
    if APADV.MapLocationStatus('Break Grate') then
      ents.GetMapCreatedEntity(HIDEOUT_GRATE_ID):TakeDamage(100)
    end
    if APADV.MapLocationStatus('Meet the Narrator') then
      ents.FindByName('narrator_welcome_sound')[1]:Fire('Kill')
    elseif APADV_ENTRNAME == "Narrator's Room" then
      ents.FindByName('narrator_welcome_sound')[1]:Fire('PlaySound')
    end
    if APADV.MapLocationStatus('Control Room Button') then
      ents.GetMapCreatedEntity(CONTROL_ROOM_BUTTON_ID):Fire('PressIn')
    end
    if APADV.MapLocationStatus('Create Paradox') then
      ents.FindByName('sneeze')[1]:Fire('Kill')
      ents.FindByName('shake')[1]:Fire('Kill')
      ents.FindByName('sneezeexplosionfade')[1]:Fire('Kill')
      ents.FindByName('changelevel')[1]:Fire('Kill')
    end
  end,

  MapItemFuncs = {
    ['First Room Paint Cans'] = function(iList)
      if iList[1] == nil then return end
      for _, paintCan in ipairs(PAINT_CANS) do
        if paintCan.region == 0 then
          WPDEnablePhysicsProp(ents.GetMapCreatedEntity(paintCan.id))
        end
      end
    end,
    ['First Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('firstdoor')[1])
    end,
    ['Fridge Doors'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_ID))
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_ID))
    end,
    ['Window Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.GetMapCreatedEntity(WINDOW_DOOR_ID))
    end,
    ['Hideout Paint Cans'] = function(iList)
      if iList[1] == nil then return end
      for _, paintCan in ipairs(PAINT_CANS) do
        if paintCan.region == 1 then
          WPDEnablePhysicsProp(ents.GetMapCreatedEntity(paintCan.id))
        end
      end
    end,
    ['Closet Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('closetdoor')[1])
    end,
    ["Narrator's Door"] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end,
    ["Narrator's Paint Cans"] = function(iList)
      if iList[1] == nil then return end
      for _, paintCan in ipairs(PAINT_CANS) do
        if paintCan.region == 2 then
          WPDEnablePhysicsProp(ents.GetMapCreatedEntity(paintCan.id))
        end
      end
    end,
    ['Shelf Secret'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('shelfdoor')[1])
    end,
    ['Chalkboard Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('narratordoor')[1])
    end
  }
}
