local controller = { }

local MAX_CORPSES_PER_OPEN = 10

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

controller.GetLootableCreatures = function(player)
    local radius = 50
    local creatures_in_range = player:GetCreaturesInRange(radius, 0, 0, 2)
    local lootable_corpses = {}

    for _, creature in ipairs(creatures_in_range) do
        if creature:IsDead() and creature:HasFlag(0x0006 + 0x0049, 0x0001) then
            lootable_corpses[#lootable_corpses + 1] = creature
        end
    end

    return lootable_corpses
end

controller.SetCreatureLoot = function(player, anchor_creature, nearby_corpses)
    -- Loot on the corpse you actually opened
    if anchor_creature:GetLootRecipient() ~= player then return end
    local anchor_loot = anchor_creature:GetLoot()
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

            -- Only bother if there’s something to merge and it’s not already looted
            if not source_loot:IsLooted() and (source_loot:GetItemCount() > 0 or source_loot:GetMoney() > 0) then
                -- Merge regular non-quest items
                for _, item in ipairs(source_loot:GetItems() or {}) do
                    if not item.is_looted and GetGUIDLow(item.roll_winner_guid) == 0 then
                        source_loot:RemoveItem(item.id, true, item.count)
                        anchor_loot:AddItem(item.id, item.count, item.count, 100.0, loot_mode, item.needs_quest, true)
                    end
                end

                -- Merge quest items
                if source_loot:HasQuestItems() then
                    for _, qitem in ipairs(source_loot:GetQuestItems() or {}) do
                        if not qitem.is_looted and GetGUIDLow(qitem.roll_winner_guid) == 0 then
                            source_loot:RemoveItem(qitem.id, true, qitem.count)
                            anchor_loot:AddItem(qitem.id, qitem.count, qitem.count, 100.0, loot_mode, true, true)
                        end
                    end
                end

                -- Move money
                anchor_loot:SetMoney(anchor_loot:GetMoney() + source_loot:GetMoney())
                source_loot:SetMoney(0)

                -- Clean up the source corpse
                if source_loot:IsEmpty() then
                    source_loot:Clear()
                    source_loot:SetUnlootedCount(0)
                    source_corpse:RemoveFlag(0x0006 + 0x0049, 0x0001)
                else
                    source_loot:SetUnlootedCount(source_loot:GetItemCount())
                end

                merged = merged + 1
                if merged >= MAX_CORPSES_PER_OPEN then break end
            end
        end
    end

    anchor_loot:UpdateItemIndex()
    return anchor_loot:SetUnlootedCount(anchor_loot:GetItemCount())
end
