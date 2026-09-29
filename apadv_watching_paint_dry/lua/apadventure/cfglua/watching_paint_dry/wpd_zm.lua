local WEAPONS = {
  {
    ['name'] = 'Suit Charger',
    ['index'] = 1367,
    ['pos'] = Vector(-191.62, -184, 47.93)
  },
  {
    ['name'] = 'Health Charger',
    ['index'] = 1368,
    ['pos'] = Vector(-191.62, -216, 47.93)
  },
  {
    ['name'] = 'Pulse Rifle',
    ['index'] = 1357,
    ['pos'] = Vector(-428, -216, 70)
  },
  {
    ['name'] = 'SMG',
    ['index'] = 1360,
    ['pos'] = Vector(-428, -178.01, 70)
  },
  {
    ['name'] = 'Shotgun',
    ['index'] = 1361,
    ['pos'] = Vector(-430.27, -138, 70)
  },
  {
    ['name'] = '.357 Revolver',
    ['index'] = 1356,
    ['pos'] = Vector(-430, -222, 51.73)
  },
  {
    ['name'] = 'Pistol',
    ['index'] = 1358,
    ['pos'] = Vector(-430, -189.61, 52.72)
  },
  {
    ['name'] = 'RPG',
    ['index'] = 1359,
    ['pos'] = Vector(-428, -126, 47.75)
  },
  {
    ['name'] = 'Crowbar',
    ['index'] = 1375,
    ['pos'] = Vector(-423.02, -221.01, 33.11)
  }
}

local zombiesInvading = -1

local WPDStartSpawningZombies = function()
  local zombieSounds = ents.FindByName('zombie_call')
  if #zombieSounds > 0 then
    zombieSounds[1]:Fire('PlaySound')
  end
  local zombieSpawners = ents.FindByName('zombiespawner')
  if #zombieSpawners > 0 then
    zombieSpawners[1]:Fire('Enable')
  end
end

local supplyCrates = {
  { ['index'] = 1363, ['opened'] = false },
  { ['index'] = 1399, ['opened'] = false },
  { ['index'] = 1435, ['opened'] = false },
  { ['index'] = 1434, ['opened'] = false },
  { ['index'] = 1436, ['opened'] = false },
  { ['index'] = 1437, ['opened'] = false },
  { ['index'] = 1366, ['opened'] = false },
  { ['index'] = 1362, ['opened'] = false },
  { ['index'] = 1364, ['opened'] = false },
  { ['index'] = 1365, ['opened'] = false },
  { ['index'] = 1400, ['opened'] = false },
}
local zombiesKilled = 0

local apAdvTable = {
  PostCfgLoad = function(self)
    ents.FindByName('spawn_trigger')[1]:Fire('Kill')
    hook.Add('PlayerInitialSpawn', 'WPD_FirstSpawn', function(ply)
      --`spawn_trigger` 'OnTrigger' outputs
      --ents.FindByName('fadein')[1]:Fire('Fade')
      --ents.FindByName('changelevel')[1]:Fire('Command', 'crosshair 1')
      timer.Simple(25, function()
        zombiesInvading = zombiesInvading + 1
        if zombiesInvading == 1 then
          WPDStartSpawningZombies()
        end
      end)
      hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    end)
    hook.Add('AcceptInput', 'WPD_OpenAllSupplyCrates', function(ent, input, activ, callr)
      if input ~= 'Use' then return end
      local supplyCratesOpened = 0
      for _, supplyCrate in ipairs(supplyCrates) do
        if ent:MapCreationID() == supplyCrate.index then
          if not supplyCrate.opened then
            supplyCrate.opened = true
          end
        end
        if supplyCrate.opened then
          supplyCratesOpened = supplyCratesOpened + 1
        end
      end
      if supplyCratesOpened == #supplyCrates then
        APADV.SendMapLocation('Open All Supply Crates')
        hook.Remove('AcceptInput', 'WPD_OpenAllSupplyCrates')
      end
    end)
    for _, weapon in ipairs(WEAPONS) do
      ents.GetMapCreatedEntity(weapon.index):SetPos(
        Vector(-500, weapon.pos.y, weapon.pos.z) --Move out of bounds
      )
    end
    hook.Add('OnNPCKilled', 'ExplosionEffectOnNPCDeath', function(npc, attac, inflic)
      if npc:GetClass() ~= 'npc_fastzombie' then return end
      zombiesKilled = zombiesKilled + 1
      for amt = 1, 5 do
        local amt5 = amt * 5
        if zombiesKilled == amt5 then
          APADV.SendMapLocation('Kill ' .. amt5 .. ' Zombies')
          if amt == 5 then
            local zombieSpawners = ents.FindByName('zombiespawner')
            if #zombieSpawners > 0 then
              zombieSpawners[1]:Fire('Disable')
              zombieSpawners[1]:Fire('Kill', nil, 0.01)
            end
            for _, zombie in ipairs(ents.FindByClass('npc_fastzombie')) do
              zombie:TakeDamage(100)
            end
          end
        end
      end
    end)
  end,

  CfgUnload = function(self)
    hook.Remove('PlayerInitialSpawn', 'WPD_FirstSpawn')
    zombiesInvading = -1
    hook.Remove('AcceptInput', 'WPD_OpenAllSupplyCrates')
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Kill 25 Zombies') == true then
      ents.FindByName('zombie_call')[1]:Fire('Kill')
      ents.FindByName('zombiespawner')[1]:Fire('Kill')
      for _, zombie in ipairs(ents.FindByClass('npc_fastzombie')) do
        zombie:TakeDamage(100)
      end
    end
  end,

  MapItemFuncs = {
    ['Zombie Invasion'] = function(iList)
      if #iList == 0 then return end
      print("'Zombie Invasion' item collected")
      zombiesInvading = zombiesInvading + 1
      if zombiesInvading == 1 then
        WPDStartSpawningZombies()
      end
    end
    --Filler items populated below
  }
}
for _, weapon in ipairs(WEAPONS) do
  apAdvTable.MapItemFuncs[weapon.name] = function(iList)
    if #iList == 0 then return end
    ents.GetMapCreatedEntity(weapon.index):SetPos(weapon.pos)
  end
end
return apAdvTable
