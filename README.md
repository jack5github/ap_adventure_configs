# Jack5's apAdventure configs

This repository contains all of Jack5's custom configuration files for the [Garry's Mod](https://store.steampowered.com/app/4000/Garrys_Mod/) [Archipelago randomiser](https://archipelago.gg/) '[GMod - apAdventure](https://archipelago.miraheze.org/wiki/GMod_-_apAdventure)' (gee, that's a mouthful).

*Now instead of playing those few Half-Life 2 maps over and over again, you can play **THESE** maps over and over again! **Oh what fun!!***

## Configs

- **[Watching Paint Dry: The apAdventure](apadv_watching_paint_dry/README.md)**
- **[CromulentVille 2 apAdventure](apadv_cromulentville_2/README.md)** (incomplete)

## Installation

1. Install [apAdventure](https://github.com/ChrisCj8/ap_adventure) and all its dependencies (read its README, just like this one).
2. Download this entire repository (**Code > Download ZIP**).
3. Move the configs (`apadv_*` folders) you wish to play with into `steamapps/common/GarrysMod/garrysmod/addons/`, deleting older versions.
4. Each config has its own requirements. Refer to their READMEs for more information.

> [!NOTE]
> At time of writing, apAdventure may throw an `Options.OptionError: Slot <player_name> tried add config group <config_name> to their pool, which could not be found.`
>
> To fix this, copy the folder in each `apadv_*/data_static/apadventure/logic/cfg/` to your Archipelago folder's `gmod_apadv/logic/cfg/`. You will need to do this each time you update a config. Alternatively, use a symbolic link (if you're on Linux and know how to make those).
