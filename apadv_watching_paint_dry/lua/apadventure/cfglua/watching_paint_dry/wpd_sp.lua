include('shared.lua')

local FRIDGE_DOOR_LEFT_INDEX = 1255
local FRIDGE_DOOR_RIGHT_INDEX = 1256
local CONTROL_ROOM_BUTTON_INDEX = 1277

local hurtables = {
  { ['index'] = 1240, ['hurt'] = false }, --Paint can 1
  { ['index'] = 1239, ['hurt'] = false }, --Paint can 2
  { ['index'] = 1242, ['hurt'] = false }, --Paint can 3
  { ['index'] = 1326, ['hurt'] = false }, --Breen bust
  { ['index'] = 1325, ['hurt'] = false }, --Coffee maker
  { ['index'] = 1329, ['hurt'] = false }, --Kitchen table
}

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    hook.Add('PlayerInitialSpawn', 'WPD_FirstSpawn', function(ply)
      --`spawn_trigger` 'OnTrigger' outputs
      --ents.FindByName('fadein')[1]:Fire('Fade')
      ents.FindByName('stanpmusic')[1]:Fire('PlaySound', nil, 1)
      --Narration is too complicated, with overlapping and narrative contradictions galore, so kill it all
      for _, dialogue in ipairs({
        'stanpintro',
        'stanpkitchen',
        'stanpfridge1',
        'stanphallway',
        'stanpbutton'
      }) do
        ents.FindByName(dialogue)[1]:Fire('Kill')
      end
      --ents.FindByName('firstdoor')[1]:Fire('Open', nil, 50)
      hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    end)
    hook.Add('EntityTakeDamage', 'WPD_DestructionOfCompanyProperty', function(target, dmginfo)
      local hurt = false
      for _, hurtable in ipairs(hurtables) do
        if target:MapCreationID() == hurtable.index then
          hurtable.hurt = true
          hurt = true
          break
        end
      end
      if not hurt then return end
      for _, hurtable in ipairs(hurtables) do
        if not hurtable.hurt then return end
      end
      APADV.SendMapLocation('Destruction of Company Property')
      hook.Remove('EntityTakeDamage', 'WPD_DestructionOfCompanyProperty')
    end)
    WPDCloseAndLockDoor(ents.FindByName('firstdoor')[1])
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_INDEX))
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_INDEX))
    WPDCloseAndLockDoor(ents.FindByName('controlroomdoor')[1])
    hook.Add('AcceptInput', 'WPD_ControlRoomButton', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= CONTROL_ROOM_BUTTON_INDEX then return end
      APADV.SendMapLocation('Control Room Button')
      hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    hook.Remove('EntityTakeDamage', 'WPD_DestructionOfCompanyProperty')
    hook.Remove('AcceptInput', 'WPD_ControlRoomButton')
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Control Room Button') == true then
      ents.GetMapCreatedEntity(CONTROL_ROOM_BUTTON_INDEX):Fire('PressIn')
    end
  end,

  MapItemFuncs = {
    ['Destruction of Company Property'] = function(iList)
      if #iList == 0 then return end
      for _, hurtable in ipairs(hurtables) do
        ents.GetMapCreatedEntity(hurtable.index):TakeDamage(100)
      end
    end,
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
