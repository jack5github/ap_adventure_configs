local nuclearFalloutEnjoyed

return {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    hook.Add('PlayerInitialSpawn', 'WPD_FirstSpawn', function(ply)
      --`spawn_trigger` 'OnTrigger' outputs
      --ents.FindByName('fadein')[1]:Fire('Fade')
      timer.Simple(15, function()
        if nuclearFalloutEnjoyed then return end
        ents.FindByName('Narrator')[1]:Fire('PlaySound')
        timer.Simple(17.5, function()
          APADV.SendMapLocation('Enjoy Nuclear Fallout')
        end)
      end)
      hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Enjoy Nuclear Fallout') then
      nuclearFalloutEnjoyed = true
    end
  end
}
