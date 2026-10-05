--Although it is possible to kill 25 zombies with 100 health and suit charge using only a Crowbar, the logic is intentionally structured with the expectation that you don't have any suit charge, so that those that don't know the strategy aren't inconvenienced

local WEAPONS = {
  {
    ['name'] = 'Suit Charger',
    ['id'] = 1367,
    ['pos'] = Vector(-191.62, -184, 47.93)
  },
  {
    ['name'] = 'Health Charger',
    ['id'] = 1368,
    ['pos'] = Vector(-191.62, -216, 47.93)
  },
  {
    ['name'] = 'Pulse Rifle',
    ['id'] = 1357,
    ['pos'] = Vector(-428, -216, 70)
  },
  {
    ['name'] = 'SMG',
    ['id'] = 1360,
    ['pos'] = Vector(-428, -178.01, 70)
  },
  {
    ['name'] = 'Shotgun',
    ['id'] = 1361,
    ['pos'] = Vector(-430.27, -138, 70)
  },
  {
    ['name'] = '.357 Revolver',
    ['id'] = 1356,
    ['pos'] = Vector(-430, -222, 51.73)
  },
  {
    ['name'] = 'Pistol',
    ['id'] = 1358,
    ['pos'] = Vector(-430, -189.61, 52.72)
  },
  {
    ['name'] = 'RPG',
    ['id'] = 1359,
    ['pos'] = Vector(-428, -126, 47.75)
  },
  {
    ['name'] = 'Crowbar',
    ['id'] = 1375,
    ['pos'] = Vector(-423.02, -221.01, 33.11)
  }
}
local zombiesInvading = -1

local WPDStartSpawningZombies = function()
  local zombieSounds = ents.FindByName('zombie_call')
  if zombieSounds[1] ~= nil then
    zombieSounds[1]:Fire('PlaySound')
  end
  local zombieSpawners = ents.FindByName('zombiespawner')
  if zombieSpawners[1] ~= nil then
    zombieSpawners[1]:Fire('Enable')
  end
end

local ammoCrates = { 1363, 1399, 1435, 1434, 1436, 1437, 1366, 1362, 1364, 1365, 1400 }
local zombiesKilled = 0

local apadvTable = {
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
    hook.Add('AcceptInput', 'WPD_OpenAllAmmoCrates', function(ent, input, activ, callr)
      if input ~= 'Use' then return end
      for i, ammoCrate in ipairs(ammoCrates) do
        if ent:MapCreationID() == ammoCrate then
          table.remove(ammoCrates, i)
          break
        end
      end
      if ammoCrates[1] ~= nil then return end
      APADV.SendMapLocation('Open All Ammo Crates')
      hook.Remove('AcceptInput', 'WPD_OpenAllAmmoCrates')
    end)
    for _, weapon in ipairs(WEAPONS) do
      ents.GetMapCreatedEntity(weapon.id):SetPos(
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
            if zombieSpawners[1] ~= nil then
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
    hook.Remove('AcceptInput', 'WPD_OpenAllAmmoCrates')
  end,

  OnFullConnect = function(self)
    if APADV.MapLocationStatus('Kill 25 Zombies') then
      ents.FindByName('zombie_call')[1]:Fire('Kill')
      ents.FindByName('zombiespawner')[1]:Fire('Kill')
      for _, zombie in ipairs(ents.FindByClass('npc_fastzombie')) do
        zombie:TakeDamage(100)
      end
    end
  end,

  MapItemFuncs = {
    ['Zombie Invasion'] = function(iList)
      if iList[1] == nil then return end
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
  apadvTable.MapItemFuncs[weapon.name] = function(iList)
    if iList[1] == nil then return end
    ents.GetMapCreatedEntity(weapon.id):SetPos(weapon.pos)
  end
end
return apadvTable
