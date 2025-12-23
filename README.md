# 🗡️ AOE Loot Script for Eluna/ALE

## Overview
Implement the AOE Loot/Mass Loot feature from Mist of Pandaria, allowing players to loot multiple nearby corpses in a single action. Compatible with any emulator using Eluna/ALE, including TrinityCore and AzerothCore.

## Features

- ✅ AOE Loot in Solo Play.
- ✅ AOE Loot in Group Play.
- ✅ Duplication Protection.
- ✅ Enable/Disable via Interface (CSMH and AIO support).
- ✅ ["Skinning"](https://wowpedia.fandom.com/wiki/Skinning) and ["Mob Engineering"](https://wowwiki-archive.fandom.com/wiki/Mob_engineering) support.
- ✅ AutoLoot support.
- ✅ Quest item handling.

## Prerequisites

You will need to use [my fork](https://github.com/Aldori15/mod-ale) of mod-ale as that has the necessary ALE changes and is pretty much plug and play for Azerothcore.

For TrinityCore, use the provided `.diff` file to add the needed methods, ensuring full functionality.

## 🚀 Installation

1. Download the `aoe_loot.lua` script.
2. Download the `aoe_loot_aio.lua` script if you use [AIO](https://github.com/Rochet2/AIO), or download the `aoe_loot_csmh.lua` script if you use [CSMH](https://github.com/Foereaper/CSMH).
3. Place both scripts in your `lua_scripts` directory.  You can use a subfolder within that directory if you want.

## 🎮 Usage

Enable via the Interface options in-game, which allows for looting multiple nearby corpses simultaneously.

<img width="1149" height="672" alt="image" src="https://github.com/user-attachments/assets/aa12be68-33a3-496a-8df3-217fd8f3824b" />

<img width="1756" height="1261" alt="image" src="https://github.com/user-attachments/assets/03e1ef90-3dd0-4cdf-875b-97cc55aada89" />

## 🔄 Compatibility

Works with any emulator using Eluna, including TrinityCore and ALE for AzerothCore.

## 📚 References

- [AOE Looting in Mist of Pandaria](https://wowwiki-archive.fandom.com/wiki/Area_of_Effect_looting)

## 📜 License

Licensed under GNU GPL v3. See the LICENSE file.
