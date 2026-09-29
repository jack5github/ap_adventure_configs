include('shared.lua')

local refusedMario = false

return {
  PostCfgLoad = function(self)
    ents.FindByClass('trigger_multiple')[1]:Fire('Kill')
    hook.Add('PlayerInitialSpawn', 'WPD_FirstSpawn', function(ply)
      --`trigger_multiple` 'OnTrigger' outputs
      --ents.FindByName('EnterFade')[1]:Fire('Fade')
      timer.Simple(8, function()
        if refusedMario then return end
        ents.FindByName('mariodoor')[1]:Fire('Open')
        ents.FindByName('DoorKickSound')[1]:Fire('PlaySound')
        --[[
        Garry's Mod seems unable to stop music from playing; this isn't too much of an issue
        ents.FindByName('Music')[1]:Fire('StopSound')
        ]]
        ents.FindByName('MarioKick')[1]:Fire('Open', nil, 1)
        ents.FindByName('MarioStand')[1]:Fire('Open', nil, 1)
        ents.FindByName('MarioVoice')[1]:Fire('PlaySound', nil, 1)
        ents.FindByName('DeleteThis')[1]:Fire('Open', nil, 6)
        ents.FindByName('GunLoad')[1]:Fire('PlaySound', nil, 6)
        timer.Simple(12, function()
          ents.FindByName('GunShot')[1]:Fire('PlaySound')
          --ents.FindByName('MarioDead')[1]:Fire('Command', 'kill')
          ents.FindByName('RedScreen')[1]:Fire('Fade')
          WPDKillAllPlayers()
          APADV.SendMapLocation('Refuse Mario')
          --ents.FindByName('MarioDead')[1]:Fire('Command', 'map wpd_st', 1)
        end)
      end)
      hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    refusedMario = false
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Refuse Mario') == true then
      refusedMario = true
    end
  end
}
