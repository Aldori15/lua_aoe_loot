local controller = { }

controller.OnLootFrameOpen = function(event, packet, player)
    local aoe_loot_active = player:GetData("AOE_LOOT_STATUS") or false
    if aoe_loot_active then
      local selection = player:GetSelection()
      if not (selection) then
          return nil
      end
      if not (selection:GetTypeId() == 3) then
          return nil
      end

      local creature = selection:ToCreature()
      if not (creature) then
          return nil
      end
      if not (creature:IsDead()) then
          return nil
      end

      local lootable_creature = controller.GetLootableCreatures(player)
      return controller.SetCreatureLoot(player, creature, lootable_creature)
    end
end
RegisterPacketEvent(0x15D, 5, controller.OnLootFrameOpen)

controller.GetLootableCreatures = function(player)
    local creatures_in_range = player:GetCreaturesInRange(50, 0, 0, 2)
    local lootable_creatures
    
    do
        local _accum_0 = { }
        local _len_0 = 1

        for _index_0 = 1, #creatures_in_range do
            local creature = creatures_in_range[_index_0]

            if creature:IsDead() and creature:HasFlag(0x0006 + 0x0049, 0x0001) then
                _accum_0[_len_0] = creature
                _len_0 = _len_0 + 1
            end
        end

        lootable_creatures = _accum_0
    end
    
    return lootable_creatures
end

controller.SetCreatureLoot = function(player, anchor_creature, nearby_corpses)
    -- Loot on the corpse you actually opened
    local anchor_loot = anchor_creature:GetLoot()
    local loot_mode = anchor_creature:GetLootMode()

    for _, source_corpse in ipairs(nearby_corpses) do
        if source_corpse ~= anchor_creature and source_corpse:GetLootRecipient() == player then
            local source_loot = source_corpse:GetLoot()

            if not source_loot:IsLooted() then
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
        end
    end

    anchor_loot:UpdateItemIndex()
    return anchor_loot:SetUnlootedCount(anchor_loot:GetItemCount())
end
