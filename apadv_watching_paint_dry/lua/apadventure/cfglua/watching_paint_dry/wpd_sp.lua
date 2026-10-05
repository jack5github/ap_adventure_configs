include('shared.lua')

local FRIDGE_DOOR_LEFT_ID = 1255
local FRIDGE_DOOR_RIGHT_ID = 1256
local CONTROL_ROOM_BUTTON_ID = 1277
--Paint can 1, 2, 3, Breen bust, coffee maker, kitchen table
local hurtables = { 1240, 1239, 1242, 1326, 1325, 1329 }

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
      for i, hurtable in ipairs(hurtables) do
        if target:MapCreationID() == hurtable then
          table.remove(hurtables, i)
          break
        end
      end
      if hurtables[1] ~= nil then return end
      APADV.SendMapLocation('Destruction of Company Property')
      hook.Remove('EntityTakeDamage', 'WPD_DestructionOfCompanyProperty')
    end)
    WPDCloseAndLockDoor(ents.FindByName('firstdoor')[1])
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_LEFT_ID))
    WPDCloseAndLockDoor(ents.GetMapCreatedEntity(FRIDGE_DOOR_RIGHT_ID))
    WPDCloseAndLockDoor(ents.FindByName('controlroomdoor')[1])
    hook.Add('AcceptInput', 'WPD_ControlRoomButton', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= CONTROL_ROOM_BUTTON_ID then return end
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
    if APADV.MapLocationStatus('Control Room Button') then
      ents.GetMapCreatedEntity(CONTROL_ROOM_BUTTON_ID):Fire('PressIn')
    end
  end,

  MapItemFuncs = {
    ['Destruction of Company Property'] = function(iList)
      if iList[1] == nil then return end
      for _, hurtable in ipairs(hurtables) do
        ents.GetMapCreatedEntity(hurtable.id):TakeDamage(100)
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
    ['Control Room Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
