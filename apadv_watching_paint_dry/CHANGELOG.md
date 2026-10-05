# Changelog

## Version 1.0.1

- Dense table storage converted to array tables where possible
- Functions no longer use the length (`#`) operator
- Lua variables renamed from `*_INDEX`/`index` to `*_ID`/`id`
- Unnecessary `boolean == true` assertions shortened to `boolean`
- Unneeded variable setting in `CfgUnload` functions removed
- `wpd_pr`: Added missing grate removal when *Break Grate* has been checked
- `wpd_sp`: *Kitchen Couch* renamed to *Break Room*
- `wpd_zm`:
  - Now reports it has `Ammo_RPG_Round` (HL2) instead of `Ammo_RPG_Rocket` (HL:S)
  - *Open All Supply Crates* renamed to *Open All Ammo Crates*

## Version 1.0.0

- Initial release
