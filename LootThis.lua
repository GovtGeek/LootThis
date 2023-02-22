local f = CreateFrame("Frame", "LootThisFrame")
f:RegisterEvent("LOOT_BIND_CONFIRM")
f:SetScript("OnEvent", function(this, event, ...)
    if event == "LOOT_BIND_CONFIRM" then
	--DEFAULT_CHAT_FRAME:AddMessage("Automatically confirming loot bind")
	slotID = ...
	if IsInInstance() then
    	--DEFAULT_CHAT_FRAME:AddMessage("Detected instance")
	    local autoconfirm = false
	    local onlineInZone = false
	    local i = 1
	    if GetNumGroupMembers() == 0 then autoconfirm = true end -- Autoconfirm when in an instance solo
	    if autoconfirm ~= true then
	    -- Autoconfirm if no one is in the instance or if everyone is offline
		local members = GetNumGroupMembers()
		if members > 1 then
		    local myZone = GetRealZoneText()
		    local myName = GetUnitName("player")
		    for i = 1, members do
                name, _, _, _, _, _, zone, online = GetRaidRosterInfo(i)
    			if online == 1 and zone == myZone and name ~= myName then onlineInZone = true end
		    end
		    if onlineInZone ~= true then autoconfirm = true end
		end
	    end
	    if autoconfirm == true then
		for i = 1, STATICPOPUP_NUMDIALOGS do
		    local frame = _G["StaticPopup"..i]
		    if frame.which == "LOOT_BIND" and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
		end
		this:UnregisterEvent("LOOT_BIND_CONFIRM")
		LootSlot(slotID)
		for i = 1, STATICPOPUP_NUMDIALOGS do
		    local frame = _G["StaticPopup"..i]
		    if frame.which == "LOOT_BIND" and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
		end
		ConfirmLootSlot(slotID)
		this:RegisterEvent("LOOT_BIND_CONFIRM")
	    end
	end
    end
end)
