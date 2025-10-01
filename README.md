# 🗡️ AOE Loot Script for Eluna

## Overview
Implement the AOE Loot/Mass Loot feature from Mist of Pandaria, allowing players to loot multiple nearby corpses in a single action. Compatible with any emulator using Eluna, including TrinityCore and AzerothCore.

## Features

- ✅ AOE Loot in Solo Play.
- ✅ AOE Loot in Group Play.
- ✅ Duplication Protection.
- ✅ Enable/Disable via Interface (CSMH and AIO support).
- ✅ ["Skinning"](https://wowpedia.fandom.com/wiki/Skinning) and ["Mob Engineering"](https://wowwiki-archive.fandom.com/wiki/Mob_engineering) support.
- ✅ AutoLoot support.
- ✅ Quest item handling.

## Prerequisites

I would recommend using [my fork](https://github.com/Aldori15/mod-eluna) of mod-eluna as that has the necessary Eluna changes and is pretty much plug and play.  If you would like to use a different mod-eluna repo, I have submitted a pull request [here](https://github.com/azerothcore/mod-eluna/pull/323). So you will need to be updated to at least [commit 972879c](https://github.com/azerothcore/mod-eluna/commit/972879c69656f0f73d09d974c6fe55382a677f4d) or newer and the pending pull request.  But if you are cherry picking, then at the very least you need the aforementioned commit and also [commit de84ed1](https://github.com/azerothcore/mod-eluna/commit/de84ed13695f04e90feae49ba2a74106f3da8add) in addition to the pending pull request.  If the pull request gets approved, I will update this README with the proper commit #.

For TrinityCore, use the provided `.diff` file to add the needed methods, ensuring full functionality.

## 🚀 Installation

1. Download the `aoe_loot.lua` script.
2. Download the `aoe_loot_aio.lua` script if you use [AIO](https://github.com/Rochet2/AIO), or download the `aoe_loot_csmh.lua` script if you use [CSMH](https://github.com/Foereaper/CSMH).
3. Place both scripts in your `lua_scripts` directory.  You can use a subfolder within that directory if you want.

## 🎮 Usage

Enable via the Interface options in-game, which allows for looting multiple nearby corpses simultaneously.

<img width="1149" height="672" alt="image" src="https://github.com/user-attachments/assets/aa12be68-33a3-496a-8df3-217fd8f3824b" />

## 🔄 Compatibility

Works with any emulator using Eluna, including TrinityCore and AzerothCore.

## 📚 References

- [AOE Looting in Mist of Pandaria](https://wowwiki-archive.fandom.com/wiki/Area_of_Effect_looting)

## 📜 License

Licensed under GNU GPL v3. See the LICENSE file.
