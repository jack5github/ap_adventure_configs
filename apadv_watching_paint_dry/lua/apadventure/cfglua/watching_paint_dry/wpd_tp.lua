local TRIGGER_INDEX = 1238

return {
  PostCfgLoad = function(self)
    --There are multiple `trigger_multiple`s, kill unnamed spawn trigger by origin
    local triggers = ents.FindByClass('trigger_multiple')
    for _, trigger in ipairs(triggers) do
      local pos = trigger:GetPos()
      if pos.x == -290 and pos.y == -162 and pos.z == 8.5 then
        trigger:Fire('Kill')
        break
      end
    end
    hook.Add('PlayerInitialSpawn', 'WPD_FirstSpawn', function(ply)
      --`spawn_trigger` 'OnTrigger' outputs
      --ents.FindByName('fadein')[1]:Fire('Fade')
      ents.FindByName('bathroomlockeddoor')[1]:Fire('Open', nil, 3)
      hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    end)
    --No location or item exists for the first room; this is intentional as otherwise this very linear map would require unnecessary backtracking
    hook.Add('AcceptInput', 'WPD_WrongGame', function(ent, input, activ, callr)
      if not IsValid(callr) or callr:MapCreationID() ~= TRIGGER_INDEX or ent:GetName() ~= 'narrator' then return end
      APADV.SendMapLocation('Wrong Game')
      hook.Remove('AcceptInput', 'WPD_WrongGame')
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    hook.Remove('AcceptInput', 'WPD_WrongGame')
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Wrong Game') == true then
      ents.GetMapCreatedEntity(TRIGGER_INDEX):Fire('Kill')
      local door = ents.FindByName('hallwaylockeddoor')[1]
      door:Fire('Close')
      door:Fire('Lock')
    end
  end
}
