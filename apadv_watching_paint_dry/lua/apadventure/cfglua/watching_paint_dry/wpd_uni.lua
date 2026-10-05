include('shared.lua')

local FRONT_DOOR_WHITE_BRUSH_ID = 1321
local PICTURE_FRAME_ID = 1300
local touchedFrontDoor
local crates = { 1312, 1314, 1313, 1315, 1311, 1316, 1310, 1317 }

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
    local frontDoorWhiteBrush = ents.GetMapCreatedEntity(FRONT_DOOR_WHITE_BRUSH_ID)
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
          )
      then
        APADV.SendMapLocation('Front Door')
        return true
      end
    end)
    hook.Add('AcceptInput', 'WPD_DetachPicture', function(ent, input, activ, callr)
      if input ~= 'Use' or ent:MapCreationID() ~= PICTURE_FRAME_ID then return end
      APADV.SendMapLocation('Detach Picture')
      hook.Remove('AcceptInput', 'WPD_DetachPicture')
    end)
    WPDCloseAndLockDoor(ents.FindByName('controlroomdoor')[1])
    hook.Add('PropBreak', 'WPD_BreakCrates', function(attac, prop)
      local allBroken = true
      for i, crate in ipairs(crates) do
        if prop:MapCreationID() == crate then
          crates[i] = -2 -- -1 is reserved for no map creation ID
          APADV.SendMapLocation('Break Crate ' .. i)
        elseif crate ~= -2 then
          allBroken = false
        end
      end
      if not allBroken then return end
      hook.Remove('PropBreak', 'WPD_BreakCrates')
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('AcceptInput', 'WPD_ReadNewspaper')
    hook.Remove('AcceptInput', 'WPD_PreventEndCredits')
    hook.Remove('AcceptInput', 'WPD_DetachPicture')
    hook.Remove('PropBreak', 'WPD_BreakCrates')
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Front Door') then
      touchedFrontDoor = true
    end
    if APADV.MapLocationStatus('Detach Picture') then
      ents.GetMapCreatedEntity(PICTURE_FRAME_ID):Fire('Kill')
    end
    local allBroken = true
    for i, crate in ipairs(crates) do
      if APADV.MapLocationStatus('Break Crate ' .. i) then
        ents.GetMapCreatedEntity(crate):TakeDamage(100)
        crates[i] = -2
      else
        allBroken = false
      end
    end
    if not allBroken then return end
    hook.Remove('PropBreak', 'WPD_BreakCrates')
  end,

  MapItemFuncs = {
    ['First Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('firstdoor')[1])
    end,
    ['Crates Room Door'] = function(iList)
      if iList[1] == nil then return end
      WPDOpenLockedDoor(ents.FindByName('controlroomdoor')[1])
    end
  }
}
