# Horrorween apAdventure

> Happy halloween 2026!

Version 1.0.0

## Requirements

- Installation as explained in [the main repository](https://github.com/jack5github/ap_adventure_configs)
- [Horrorween](https://steamcommunity.com/sharedfiles/filedetails/?id=938657810)

## Description

**Horrorween** can be described as the quintessential Garry's Mod horror map. The story isn't important, *but if you must know*, you're on your way to friend Lucifer's house; number 666. The map features a semi-linear layout with unique themed locations, multiple collectibles, boss battles and jumpscares galore. It has featured on YouTube channels such as [VanossGaming](https://www.youtube.com/watch?v=HgeG6g_HFfQ) and [LordMinion777](https://www.youtube.com/watch?v=SQ6ueBi5LC8) ([even I made a video on it!](https://www.youtube.com/watch?v=KCKGXlhlcJo)).

This config randomises all the locked doors in the map and also the front doors of all primary non-checkpoint buildings, resulting in non-linear yet similarly-paced gameplay compared to the original. Certain jumpscares require an item to be experienced, and once experienced, they award a check and can never occur again. **[Horrorween 2](https://steamcommunity.com/sharedfiles/filedetails/?id=3023042949)** may be added to this config in the future (but don't hold your breath for it).

## Map

> [!WARNING]
> **SPOILER ALERT!** Don't read any further down if you want to go in blind!

- `hr_horrorween_1` **Horrorween** - Entrances and exits are located in *House 1 Bedroom*, *House 4* and *House 6 Secret*. An extra exit is located in *Ending*.
  - Item: *Progressive Speed* - There are 8 of these. The more you have, the closer you get to default GMod player speed.
  - *House 1 Answer Phone Again* - Wait a few seconds after the first phone call finishes, then use the phone again.
  - *Church Holy Might* - Pick up the cross next to *Church Golden Coin*.
  - *House 3 Press Well Bricks* - Inside the well, interact with the 5 bricks that stick out from the walls. One is right next to the ladder in.
  - *Sewer View Zombie on Camera* - Press button 4 on the security system deep within the sewer.
  - *Sewer Detonate Blockage* - You need the *Bomb* and *Detonator* items, then you can interact with the blockage to detonate it.
  - *Unreality Gluttony Blocks* - Interact with the chair with a book on it and wait for the blocks to arrange themselves.
  - *Unreality Spell Pride* - Press the letter buttons in the exact order: `PRIDE`.
  - *Courtyard Gate Jumpscare* - Approach the *Courtyard Gate* from the courtyard side, or walk through it as it opens.
  - *House 6 Kill Fast Zombie* - This zombie only appears once you crouch into a nearby vent filled with ammo.
  - *House 8 Defeat Zombie Painting* - You need the *House 8 Cutscene* item to achieve this and a few other locations.
  - Item: *Golden Coin* - There are 6 of these. 1 unlocks the *Ending Dicks Room*, 3 the *Ending Party Room* and 6 the *Ending Boobs Room* (it pains me to implement these).
  - *Ending Liars Room* - Past a normally locked door in the *Ending Party Room*.

## Known Issues

- After getting *House 8 Defeat Zombie Painting*, you are kept locked in and are later forcibly teleported to the *Ending*. It would be better if you could go back and optionally interact with the House 18 door to teleport (which becomes the default behaviour from then on).
- *House 6 Cell Door* (an item) can be unblocked once the floor underneath *House 6 Chair* breaks, even if the player doesn't own the item.
- It is possible for sounds to not play after entering from certain entrances under unknown conditions due to the error `total_channels == MAX_CHANNELS`.
- Locations that use `func_tracktrain` entities will appear as if they haven't been completed on reload due to movement limitations.

## AI Disclosure

No AI was used at any point during the making of this config. I wrote all this by hand.

> An apAdventure config made by **Jack5**
