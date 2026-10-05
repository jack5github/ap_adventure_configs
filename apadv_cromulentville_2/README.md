# CromulentVille 2 apAdventure

Version 0.1.0

## Requirements

- Installation as explained in [the main repository](https://github.com/jack5github/ap_adventure_configs)
- [CromulentVille 2](https://www.moddb.com/mods/map-labs/downloads/test-tube-7-cromulentville-2); place the `cromulentville2/` folder into `GarrysMod/garrysmod/addons/` (this will hopefully be changed to a GMod Workshop download in the future)

## Description

**Test Tube #7 - CromulentVille 2** is a collection of maps that were packaged as a SourceMod as part of the Half-Life 2 / Source Engine anthology **[Map Labs](https://www.moddb.com/mods/map-labs)**. It is arguably the best Map Labs collection, featuring several maps with incredibly unique concepts including **Courier**, **Fulfillment**, **Milgram** and **Something's Fishy**, each of which were popularised by their appearance as standalone videos on the YouTube channel [A Jolly Wangcore](https://www.youtube.com/@JollyWangcore).

This config intends to randomise almost every map in the collection, as they are each enjoyable for their own reasons. The gameplay of these maps is comparable to the default Half-Life 2 configs for apAdventure, with some outliers here and there to keep things interesting. What oddities will you encounter on your run?

## Maps

> [!WARNING]
> **SPOILER ALERT!** Don't read any further down if you want to go in blind!

- `tt07_behind` **what we left behind**
  - *Top of Crooked Stairs* - Place the big cube (new to this config) on a nearby platform in order to jump over the invisible extension to the next platform's collision.
- `tt07_courier` **Courier**
  - Item: *The Goods* - Needed to *Give Pizza* to the apartment-dweller.
- `tt07_kj_somethingsfishy` **Something's Fishy** - Boss map.
  - Item: *Cannons* - Logically required to *Defeat Fisherman Robot*.
- `tt07_mysterymansion` **Mansion of Mapping Mystery**
- *More maps will be added once their randomisation is stable enough...*

`tt07_xblah_cromulentville2` **Scrambled** will not be implemented because it is a Mirror Cube puzzle that takes control of players' movements (go play a Rubik's Cube apworld instead). It's a similar story for `background_tt07` and `tt07_warehouse_background`.

## Known Issues

- If you use a weapon that disintegrates NPCs and props rather than breaking them (e.g., the Gluon Gun), you won't be able to get killing or breaking checks respectively.
- Props that are hidden due to their map items not yet being received can still be broken with explosive damage, awarding checks out of logic.
- `tt07_bemusement`: The gas station doors do not open at the same time as each-other; I've tried both changing their names and using their `slavename` properties with no luck.
- `tt07_courier`: The map's music (`fightmusic`) does not play when emerging from the *Construction* entrance; it needs to play when players leap off the platforms.

## AI Disclosure

No AI was used at any point during the making of this config. I wrote all this by hand.

> An apAdventure config made by **Jack5**
