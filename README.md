# 🗡️ AOE Loot Script for ALE

## Overview
Implement the AOE Loot/Mass Loot feature from Mist of Pandaria, allowing players to loot multiple nearby corpses in a single action. Compatible with AzerothCore using a modified version of ALE.

## Features

- ✅ AOE Loot in Solo Play.
- ✅ AOE Loot in Group Play.
- ✅ Duplication Protection.
- ✅ Enable/Disable via Interface (CSMH and AIO support).
- ✅ ["Skinning"](https://wowpedia.fandom.com/wiki/Skinning) and ["Mob Engineering"](https://wowwiki-archive.fandom.com/wiki/Mob_engineering) support.
- ✅ AutoLoot support.
- ✅ Quest item handling.

## Prerequisites

- AzerothCore with [my mod-ale fork](https://github.com/Aldori15/mod-ale)
  at [commit 3d448616](https://github.com/Aldori15/mod-ale/commit/3d448616fdefe8574f7c81bc7f5cccf6e1c57777)
  or newer. Alternatively, port the changes from that commit into your own mod-ale repo.

This provides the native `Creature:MergeLootFrom()` method required by the Lua script. No additional AzerothCore core source modifications are required.

## 🚀 Installation

1. Download the `aoe_loot.lua` script.
2. Download the `aoe_loot_aio.lua` script if you use [AIO](https://github.com/Rochet2/AIO), or download the `aoe_loot_csmh.lua` script if you use [CSMH](https://github.com/Foereaper/CSMH).
3. Place both scripts in your `lua_scripts` directory.  You can use a subfolder within that directory if you want.

## 🎮 Usage

Enable via the Interface options in-game, which allows for looting multiple nearby corpses simultaneously.

<img width="1149" height="672" alt="image" src="https://github.com/user-attachments/assets/aa12be68-33a3-496a-8df3-217fd8f3824b" />

<img width="1756" height="1261" alt="image" src="https://github.com/user-attachments/assets/03e1ef90-3dd0-4cdf-875b-97cc55aada89" />

## 🔄 Compatibility

Tested with AzerothCore and ALE using the required mod-ale version above.

Other emulators require an equivalent native `Creature:MergeLootFrom()` implementation and are not
currently supported out of the box.

## 📚 References

- [AOE Looting in Mist of Pandaria](https://wowwiki-archive.fandom.com/wiki/Area_of_Effect_looting)

## 📜 License

Licensed under GNU GPL v3. See the LICENSE file.
