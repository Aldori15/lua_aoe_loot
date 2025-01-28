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

## 🚀 Installation

1. Download the `aoe_loot.lua` script.
2. Download the `aoe_loot_aio.lua` script if you use [AIO](https://github.com/Rochet2/AIO), or download the `aoe_loot_csmh.lua` script if you use [CSMH](https://github.com/Foereaper/CSMH).
3. Place in your `lua_scripts` directory.  You can use a subfolder within that directory if you want.
4. Download the `.diff` file that corresponds to your emulator (TrinityCore or AzerothCore) and place it at the root of your source (see screenshot).


![image](https://github.com/user-attachments/assets/052fe90c-94cd-4c41-8871-c9685e2ac7db)

5. Right click in the folder directory, select Open in Terminal, then apply the corresponding `git apply` to add necessary methods to Eluna for your emulator:
```sh
git apply --directory=modules/mod-eluna azerothcore_eluna.diff

git apply --directory=src/server/game/LuaEngine trinitycore_eluna.diff
```
6. Recompile your source code.

## 🎮 Usage

Enable via the Interface options in-game, which allows for looting multiple nearby corpses simultaneously.

## 🔄 Compatibility

Works with any emulator using Eluna, including TrinityCore and AzerothCore, using the provided `.diff` file ensuring full functionality.

## 📚 References

- [AOE Looting in Mist of Pandaria](https://wowwiki-archive.fandom.com/wiki/Area_of_Effect_looting)


## 📜 License

Licensed under GNU GPL v3. See the LICENSE file.
