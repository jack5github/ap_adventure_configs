return {
  PostCfgLoad = function(self)
    ents.FindByClass('trigger_once')[1]:Fire('Kill')
    hook.Add('PlayerInitialSpawn', 'WPD_FirstSpawn', function(ply)
      --`trigger_once` 'OnTrigger' outputs
      ents.FindByName('brushgrass')[1]:Fire('Open')
      ents.FindByName('welcome')[1]:Fire('PlaySound', nil, 3)
      timer.Simple(27, function()
        APADV.SendMapLocation('Watch Grass Grow')
      end)
      hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
  end
}
