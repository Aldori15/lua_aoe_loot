local controller = { }

local MAX_CORPSES_PER_OPEN = 10

local UNIT_DYNAMIC_FLAGS = 0x0006 + 0x0049
local LOOTABLE_FLAG = 0x0001

local LOOT_CONSUMED_KEY = "AOE_LOOT_CONSUMED_BY_CORPSE"

local function getConsumedByCorpse(player)
    local data = player:GetData(LOOT_CONSUMED_KEY)
    if not data then
        data = {}
        player:SetData(LOOT_CONSUMED_KEY, data)
    end
    return data
end

local function addConsumedCount(player, corpse_guid_low, item_id, amount)
    if not corpse_guid_low or corpse_guid_low == 0 then return end
    if not item_id or item_id == 0 then return end
    if not amount or amount <= 0 then return end

    local by_corpse = getConsumedByCorpse(player)
    local corpse_counts = by_corpse[corpse_guid_low]
    if not corpse_counts then
        corpse_counts = {}
        by_corpse[corpse_guid_low] = corpse_counts
    end

    corpse_counts[item_id] = (corpse_counts[item_id] or 0) + amount
end

local function getConsumedCount(player, corpse_guid_low, item_id)
    local by_corpse = player:GetData(LOOT_CONSUMED_KEY)
    if not by_corpse then return 0 end

    local corpse_counts = by_corpse[corpse_guid_low]
    if not corpse_counts then return 0 end

    return corpse_counts[item_id] or 0
end

controller.OnLootFrameOpen = function(event, packet, player)
    local aoe_loot_active = player:GetData("AOE_LOOT_STATUS") or false
    if not aoe_loot_active then return end

    local selection = player:GetSelection()
    if not selection or selection:GetTypeId() ~= 3 then return end

    local creature = selection:ToCreature()
    if not creature or not creature:IsDead() then return end

    local lootable = controller.GetLootableCreatures(player)
    return controller.SetCreatureLoot(player, creature, lootable)
end
RegisterPacketEvent(0x15D, 5, controller.OnLootFrameOpen)

controller.OnPlayerLootItem = function(event, player, item, count, lootguid)
    local aoe_loot_active = player:GetData("AOE_LOOT_STATUS") or false
    if not aoe_loot_active then return end
    if not item or not lootguid then return end

    local corpse_guid_low = GetGUIDLow(lootguid)
    if corpse_guid_low == 0 then return end

    local item_id = item:GetEntry()
    if not item_id or item_id == 0 then return end

    addConsumedCount(player, corpse_guid_low, item_id, count or 1)
end
RegisterPlayerEvent(32, controller.OnPlayerLootItem)

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
    -- Loot on the corpse you actually opened
    if anchor_creature:GetLootRecipient() ~= player then return end
    local anchor_loot = anchor_creature:GetLoot()
    if not anchor_loot then return end
    local loot_mode = anchor_creature:GetLootMode()

    local merged = 0

    -- prioritize nearest corpses first if they exceed the cap
    if #nearby_corpses > MAX_CORPSES_PER_OPEN then
        table.sort(nearby_corpses, function(a, b)
            local da = anchor_creature:GetDistance(a) or 0
            local db = anchor_creature:GetDistance(b) or 0
            return da < db
        end)
    end

    for _, source_corpse in ipairs(nearby_corpses) do
        if source_corpse ~= anchor_creature and source_corpse:GetLootRecipient() == player then
            local source_loot = source_corpse:GetLoot()
            local source_guid_low = source_corpse:GetGUIDLow()
            local moved_from_source = false

            -- Only merge if there’s something to merge and it’s not already looted
            if source_loot and not source_loot:IsLooted() and (source_loot:GetItemCount() > 0 or source_loot:GetMoney() > 0 or source_loot:HasQuestItems()) then
                -- Merge regular non-quest items
                for _, item in ipairs(source_loot:GetItems() or {}) do
                    local winnerLow = item.roll_winner_guid and GetGUIDLow(item.roll_winner_guid) or 0
                    if not item.is_looted and winnerLow == 0 then
                        source_loot:RemoveItem(item.id, true, item.count)
                        anchor_loot:AddItem(item.id, item.count, item.count, 100.0, loot_mode, item.needs_quest, true)
                        moved_from_source = true
                    end
                end

                -- Merge quest items
                if source_loot:HasQuestItems() then
                    for _, qitem in ipairs(source_loot:GetQuestItems() or {}) do
                        local winnerLow = qitem.roll_winner_guid and GetGUIDLow(qitem.roll_winner_guid) or 0
                        if not qitem.is_looted and winnerLow == 0 then
                            local needsQuestItem = (not player.HasQuestForItem) or player:HasQuestForItem(qitem.id)
                            if needsQuestItem then
                                local consumed = getConsumedCount(player, source_guid_low, qitem.id)
                                local remaining = (qitem.count or 0) - consumed

                                if remaining > 0 then
                                    source_loot:RemoveItem(qitem.id, true, remaining)
                                    anchor_loot:AddItem(qitem.id, remaining, remaining, 100.0, loot_mode, true, true)
                                    addConsumedCount(player, source_guid_low, qitem.id, remaining)
                                    moved_from_source = true
                                end
                            end
                        end
                    end
                end

                -- Move money
                local source_money = source_loot:GetMoney() or 0
                if source_money > 0 then
                    anchor_loot:SetMoney(anchor_loot:GetMoney() + source_money)
                    source_loot:SetMoney(0)
                    moved_from_source = true
                end

                -- Clean up the source corpse
                if source_loot:IsEmpty() then
                    source_corpse:AllLootRemovedFromCorpse()
                    source_loot:Clear()
                    source_corpse:RemoveFlag(UNIT_DYNAMIC_FLAGS, LOOTABLE_FLAG)
                else
                    source_loot:SetUnlootedCount(source_loot:GetMaxSlotForPlayer(player))
                end

                if moved_from_source then
                    merged = merged + 1
                    if merged >= MAX_CORPSES_PER_OPEN then break end
                end
            end
        end
    end

    anchor_loot:UpdateItemIndex()
    if merged > 0 then
        anchor_loot:RefreshForPlayer(player)
    end

    return anchor_loot:SetUnlootedCount(anchor_loot:GetMaxSlotForPlayer(player))
end
