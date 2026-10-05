# Watching Paint Dry: The apAdventure

Version 1.0.1

> *Welcome to **Watching Paint Dry: The apAdventure**. In this apAdventure, you sit, and watch paint dry, in 4-dimensional-time. Feel free to hunt down the checks throughout the maps, but do not touch the walls until you have goaled. Have fun!*

## Requirements

- Installation as explained in [the main repository](https://github.com/jack5github/ap_adventure_configs)
- [Watching Paint Dry: The Game](https://steamcommunity.com/workshop/filedetails/?id=2393633994) (GMod Workshop version)

## Description

**Watching Paint Dry: The Game** was originally a Source Engine mod, but it has been [ported to be playable entirely within Garry's Mod](https://steamcommunity.com/sharedfiles/filedetails/?id=3390693513). The mod's maps are mostly copy-pastes of each-other, but with different environments and interactible elements. There's also a text-to-speech narrator that speaks to you in an unnervingly passive manner.

With this config, almost the entirety of **Watching Paint Dry: The Game** is now randomised by apAdventure. Watch grass grow, blow up the Earth, travel 4 hours into the future, kill infinitely-spawning zombies, teleport to the wrong game... all in an unpredictable order. (There are even some extra locations that I added because they seemed like funny ideas.)

> [!NOTE]
> **Watching Paint Dry: The Game** is very **The Stanley Parable**-esque, so I made the conscious decision that doors in this config are almost always locked from the start, cannot be interacted with, and are either closed or opened depending on whether or not you have their associated items. This is by no means how every other community config should be made, it was a choice made for this project only.

## Maps

> [!WARNING]
> **SPOILER ALERT!** Don't read any further down if you want to go in blind!

Most of the maps use the same layout with three common exits: the *First Room*, the inside of the *Fridge*, and the *Control Room*. You need the *First Door*, *Fridge Doors* and *Control Room Door* items respectively (for each map) to get out of those rooms into their main hallways.

- `wgg` **Watching Grass Grow** - One-exit map with one check.
  - *Watch Grass Grow* - Wait for the narrator to finish speaking.
- `wpd_br` **Backrooms** (before it was oversaturated)
- `wpd_d1` **Walled-In**
- `wpd_d3` **Buried**
- `wpd_de` **Nuclear Fallout** - One-exit map with two checks.
  - *Enjoy Nuclear Fallout* - Wait for the narrator to finish speaking.
- `wpd_f2` **Hellfire**
- `wpd_m` **Mario Wants Your Computer** - One-exit map with one check.
  - *Refuse Mario* - Get shot by Mario.
- `wpd_mn` **The Moon**
- `wpd_nh` **Narrator's House**
  - *Player Brutality* - Hit the narrator for 100 damage (10 crowbar hits will do).
  - *Create Paradox* - Wait for the narrator to finish speaking after hitting him with a paint can.
- `wpd_pr` **Nova Prospekt**
- `wpd_sp` **The Stanley Parable**
- `wpd_st` **First Map** (a.k.a. "Start here!") - Has a lot of exits and a random chance to be your `start_map`!
  - *No Patience* - Touch the wall immediately.
  - *Fail* - Touch the wall once the narrator has finished speaking.
  - *Key* - Press `+use` on the roof vent in the *First Room* and pick up the key.
  - *Awake Bonzi* - This is just *Control Room Button* with a different name for obvious reasons.
  - *World Eradicated* - Wait for Bonzi to eradicate the world (don't worry, you'll survive, somewhat).
  - Item: *Progressive Power* - You can't time travel until you have 3 of these.
  - *Time Travel* - Attach the clock, dish and monitor props (you need to have all their items) to the time machine, press the button on it and then walk into the part that glows.
  - *Win* - Touch the wall after time travelling.
- `wpd_tp` **Title_Pending** - One-exit map with two checks.
  - *Wrong Game* - Walk to the end of the hallway and wait for the narrator to start speaking.
- `wpd_tx` **Hazardous Environment**
  - *Behind Barrels* - Jump onto the barrels and crouch on their edges to tip them over and clear the way.
- `wpd_uni` **Painted House**
  - *Front Door* - The true ending.
- `wpd_zm` **Zombie House**
  - Item: *Zombie Invasion* - Zombies won't spawn until you get this.
  - *Kill 5/10/15/20/25 Zombies* - Self-explanatory. Once 25 zombies are killed, they'll all die and won't spawn again.

For other locations and items, refer to a generated Archipelago multiworld's spoiler.

`watchingpaintdrybg01` and `wpd_asc` are not included due to the player being unable to move after spawning in.

## Known Issues

- You can't get the *Detach Picture* location by hitting the picture with a weapon; I need to design a hook that checks the position of the picture every half a second and awards the check if it isn't where it should be.
- `wpd_m`: There is a chance for the castle music to play twice and for no other sounds to play after that (other than you dying of course).
- `wpd_mn`: After you've destroyed the Earth and when you return to the map, the Earth will disappear instead of appearing destroyed. Just think of it as the Earth's fragments having spread apart and now being completely out of view.
- `wpd_nh`: Outside of singleplayer, when spawning in the *Narrator's Room*, it's possible for the narrator to speak so early that you don't hear him.
- `wpd_sp`/`wpd_uni`/`wpd_zm`: If you use a weapon that disintegrates NPCs and props rather than breaking them (e.g., the Gluon Gun), you won't be able to get *Destruction of Company Property*, *Break Crate #* or *Kill # Zombies* checks respectively.
- `wpd_st`: It may be that the *Key* item disappears after players time travel; just re-enter the map and grab it that way.

## AI Disclosure

No AI was used at any point during the making of this config. I wrote all this by hand.

> An apAdventure config made by **Jack5**
