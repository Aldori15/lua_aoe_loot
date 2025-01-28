local AIO = AIO or require("AIO");
local AddonHandler = AIO.AddHandlers("AOELoot", {});

if AIO.AddAddon() then
    function AddonHandler.OnStatusChange(player, status)
        player:SetData("AOE_LOOT_STATUS", status and true or false)
    end
else
    AOE_LOOT_STATUS = AOE_LOOT_STATUS or false;
    AIO.AddSavedVarChar("AOE_LOOT_STATUS");

    local function SetAndSendStatus(self)
        self:SetChecked(AOE_LOOT_STATUS);
        AIO.Handle("AOELoot", "OnStatusChange", AOE_LOOT_STATUS);
    end

    -- Create the checkbox
    local InterfaceOptionsControlsPanelAoeLoot = CreateFrame("CheckButton", "InterfaceOptionsControlsPanelAoeLoot_GlobalName", InterfaceOptionsControlsPanel, "ChatConfigCheckButtonTemplate");
    InterfaceOptionsControlsPanelAoeLoot:SetPoint("TOPLEFT", InterfaceOptionsControlsPanelAutoLootCorpse, "BOTTOMLEFT", 0, -8);
    InterfaceOptionsControlsPanelAoeLoot:SetSize(26, 26);
    SetAndSendStatus(InterfaceOptionsControlsPanelAoeLoot);

    -- Checkbox label and tooltip text
    InterfaceOptionsControlsPanelAoeLoot_GlobalNameText:SetText(" AoE Loot");
    InterfaceOptionsControlsPanelAoeLoot.tooltipText = "Loot all corpses at once within a 50-meter radius.";
    
    InterfaceOptionsControlsPanelAoeLoot:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true);
        GameTooltip:Show();
    end);
    InterfaceOptionsControlsPanelAoeLoot:SetScript("OnLeave", function(self)
        GameTooltip:Hide();
    end);

    -- Check if ElvUI is loaded, then apply ElvUI styling
    local E, L, V, P, G = unpack(_G.ElvUI or {})
    local S = E and E:GetModule("Skins")
    if S then
        S:HandleCheckBox(InterfaceOptionsControlsPanelAoeLoot)
    end

    InterfaceOptionsControlsPanelAoeLoot:SetScript("OnClick", function(self)
        AOE_LOOT_STATUS = not AOE_LOOT_STATUS;
        SetAndSendStatus(self);
    end);

    InterfaceOptionsControlsPanelAutoLootKeyDropDown:SetPoint("TOPLEFT", InterfaceOptionsControlsPanelAoeLoot, "BOTTOMLEFT", -13, -24);

    InterfaceOptionsControlsPanelAutoLootCorpse:SetScript("OnShow", function(self)
        InterfaceOptionsControlsPanelAoeLoot:Show();
    end);
    InterfaceOptionsControlsPanelAutoLootCorpse:SetScript("OnHide", function(self)
        InterfaceOptionsControlsPanelAoeLoot:Hide();
    end);
end