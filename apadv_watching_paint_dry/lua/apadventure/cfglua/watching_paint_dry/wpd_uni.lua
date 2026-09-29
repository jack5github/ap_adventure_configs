include('shared.lua')

local FRONT_DOOR_WHITE_BRUSH_INDEX = 1321
local PICTURE_FRAME_INDEX = 1300

local touchedFrontDoor = false
local crates = {
  { ['index'] = 1312, ['broken'] = false },
  { ['index'] = 1314, ['broken'] = false },
  { ['index'] = 1313, ['broken'] = false },
  { ['index'] = 1315, ['broken'] = false },
  { ['index'] = 1311, ['broken'] = false },
  { ['index'] = 1316, ['broken'] = false },
  { ['index'] = 1310, ['broken'] = false },
  { ['index'] = 1317, ['broken'] = false }
}

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    WPDCloseAndLockDoor(ents.FindByName('firstdoor')[1])
    hook.Add('AcceptInput', 'WPD_ReadNewspaper', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:GetModel() ~= 'models/props_junk/garbage_newspaper001a.mdl' then return end
      APADV.SendMapLocation('Read Newspaper')
      hook.Remove('AcceptInput', 'WPD_ReadNewspaper')
    end)
    --Move the white brush at the front door slightly back and make it solid so the player can trigger the ending sequence while also not being able to leave the house and go out of bounds
    local frontDoorWhiteBrush = ents.GetMapCreatedEntity(FRONT_DOOR_WHITE_BRUSH_INDEX)
    frontDoorWhiteBrush:SetPos(Vector(-524.5, -343, 54))
    frontDoorWhiteBrush:SetNotSolid(false)
    hook.Add('AcceptInput', 'WPD_PreventEndCredits', function(ent, input, activ, callr)
      if
          IsValid(callr) and
          callr:GetClass() == 'trigger_multiple' and (
            ent:GetName() == 'outsidesoundscape' or
            ent:GetName() == 'Color_Correction' or
            ent:GetName() == 'camera_01' or
            ent:GetName() == 'fadeout' or
            ent:GetName() == 'credits' or
            ent:GetName() == 'closegame' or (
              touchedFrontDoor and (
                ent:GetName() == 'fadein' or
                ent:GetName() == 'flashsfx' or
                ent:GetName() == 'OutroMusic' or
                ent:GetName() == 'fadeout'
              )
            )
          ) then
        APADV.SendMapLocation('Front Door')
        return true
      end
    end)
    hook.Add('AcceptInput', 'WPD_DetachPicture', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= PICTURE_FRAME_INDEX then return end
      APADV.SendMapLocation('Detach Picture')
      hook.Remove('AcceptInput', 'WPD_DetachPicture')
    end)
    WPDCloseAndLockDoor(ents.FindByName('controlroomdoor')[1])
    hook.Add('PropBreak', 'WPD_BreakCrates', function(attac, prop)
      local cratesBroken = 0
      for num, crate in ipairs(crates) do
        if prop:MapCreationID() == crate.index then
          if not crate.broken then
            crate.broken = true
            APADV.SendMapLocation('Break Crate ' .. num)
          end
        end
        if crate.broken then
          cratesBroken = cratesBroken + 1
        end
      end
      if cratesBroken == #crates then
        hook.Remove('PropBreak', 'WPD_BreakCrates')
      end
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('AcceptInput', 'WPD_ReadNewspaper')
    hook.Remove('AcceptInput', 'WPD_PreventEndCredits')
    touchedFrontDoor = false
    hook.Remove('AcceptInput', 'WPD_DetachPicture')
    hook.Remove('PropBreak', 'WPD_BreakCrates')
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Front Door') == true then
      touchedFrontDoor = true
    end
    if APADV.MapLocationStatus('Detach Picture') == true then
      ents.GetMapCreatedEntity(PICTURE_FRAME_INDEX):Fire('Kill')
    end
    local cratesBroken = 0
    for index = 1, #crates do
      if APADV.MapLocationStatus('Break Crate ' .. index) == true then
        ents.GetMapCreatedEntity(crates[index].index):TakeDamage(100)
        crates[index].broken = true
        cratesBroken = cratesBroken + 1
      end
    end
    if cratesBroken == #crates then
      hook.Remove('PropBreak', 'WPD_BreakCrates')
    end
  end,

  MapItemFuncs = {
    ['First Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('firstdoor')[1])
    end,
    ['Crates Room Door'] = function(iList)
      if #iList == 0 then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
