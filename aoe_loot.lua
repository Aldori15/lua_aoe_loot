local controller = { }

local MAX_CORPSES_PER_OPEN = 10

local UNIT_DYNAMIC_FLAGS = 0x0006 + 0x0049
local LOOTABLE_FLAG = 0x0001

controller.OnLootFrameOpen = function(event, packet, player)
    local aoe_loot_active = player:GetData("AOE_LOOT_STATUS") or false
    if not aoe_loot_active then return end

    local loot_guid = packet:ReadGUID()
    if not loot_guid then return end

    local map = player:GetMap()
    if not map then return end

    local creature = map:GetWorldObject(loot_guid)
    if not creature or not creature:IsDead() then return end

    local lootable = controller.GetLootableCreatures(player)
    controller.SetCreatureLoot(player, creature, lootable)
end
RegisterPacketEvent(0x15D, 5, controller.OnLootFrameOpen)

controller.GetLootableCreatures = function(player)
    local radius = 50
    local creatures_in_range = player:GetCreaturesInRange(radius, 0, 0, 2)
    local lootable_corpses = {}

    for _, creature in ipairs(creatures_in_range) do
        if creature:IsDead() and creature:HasFlag(UNIT_DYNAMIC_FLAGS, LOOTABLE_FLAG) then
            lootable_corpses[#lootable_corpses + 1] = creature
        end
    end

    return lootable_corpses
end

controller.SetCreatureLoot = function(player, anchor_creature, nearby_corpses)
    if not anchor_creature.MergeLootFrom then return end

    table.sort(nearby_corpses, function(a, b)
        local da = anchor_creature:GetDistance(a) or 0
        local db = anchor_creature:GetDistance(b) or 0
        return da < db
    end)

    local merged = 0
    for _, source_corpse in ipairs(nearby_corpses) do
        if source_corpse ~= anchor_creature and anchor_creature:MergeLootFrom(source_corpse, player) then
            merged = merged + 1
            if merged >= MAX_CORPSES_PER_OPEN - 1 then break end
        end
    end
end
