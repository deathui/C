function ContraTest()
	print("ContraTest")
end

Contra = {}
Contra.Guids = {}
Contra.Guids.guids = {}
Contra.Guids.guidsFrame = CreateFrame("Frame", "guidsFrame", UIParent)
Contra.Guids.MyGuid = nil

Contra.tooltipScan = CreateFrame("GameTooltip", "ContratooltipScan", UIParent, "GameTooltipTemplate")
Contra.tooltipScan:SetOwner(UIParent, "ANCHOR_NONE")
Contra.tooltipScan:Hide()

Contra.Guids.guidsFrame:RegisterEvent("RAW_COMBATLOG")
Contra.Guids.guidsFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
Contra.Guids.guidsFrame:RegisterEvent("UNIT_COMBAT") -- this can get called with player/target/raid1 etc
Contra.Guids.guidsFrame:RegisterEvent("UNIT_MODEL_CHANGED")
Contra.Guids.guidsFrame:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
Contra.Guids.guidsFrame:RegisterEvent("UNIT_HEALTH")
Contra.Guids.guidsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")


--事件增加目标函数
Contra.Guids.AddGuids = function()

	local objectGUID = nil
	if event == "RAW_COMBATLOG" and arg1 ~= "CHAT_MSG_COMBAT_HOSTILE_DEATH" then 
		objectGUID = string.match(arg2,"0x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x")
	end
	if event ~= "RAW_COMBATLOG" and event ~= "PLAYER_TARGET_CHANGED" and arg1 then
		objectGUID = string.match(arg1,"0x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x")
	end
	if event == "PLAYER_TARGET_CHANGED" then
		_,objectGUID = UnitExists("target")
	end

	if objectGUID and UnitReaction("player", objectGUID) and UnitReaction("player", objectGUID) < 4 and Contra.Guids.guids[objectGUID] == nil and not UnitIsDeadOrGhost(objectGUID) then
		Contra.Guids.guids[objectGUID] = GetTime()
	end

	if event == "PLAYER_TARGET_CHANGED" and objectGUID and UnitReaction("player", objectGUID) and UnitReaction("player", objectGUID) <= 4 and Contra.Guids.guids[objectGUID] == nil and not UnitIsDeadOrGhost(objectGUID) then
		Contra.Guids.guids[objectGUID] = GetTime()
		Contra.Guids.guids[objectGUID] = GetTime()
	end
end


--事件减少目标函数
Contra.Guids.RemoveGuids = function()
	local objectGUID = nil
	if event == "RAW_COMBATLOG"  then
		if arg1 == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
			objectGUID = string.match(arg2,"0x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x")
			Contra.Guids.guids[objectGUID] = nil
		end
	end
end


--周期性移除目标
Contra.Guids.RemoveTime = 0
Contra.Guids.RemoveOldGuids = function()
	if GetTime() - Contra.Guids.RemoveTime < 2 then
		return
	end
	for guid, time in pairs(Contra.Guids.guids) do
		if UnitName(guid) == "未知目标" or UnitIsDeadOrGhost(guid)then
			Contra.Guids.guids[guid] = nil
			Contra.Guids.RemoveTime = GetTime()
		end
	end
end


--获取自身guid
function Contra.Guids.GetMyGuid()
	if event == "PLAYER_ENTERING_WORLD" then
		_,Contra.Guids.MyGuid = UnitExists("player")
	end
end

--每个frame只能处理一个函数
Contra.Guids.ChangeGuidList = function()
	Contra.Guids.AddGuids()
	Contra.Guids.RemoveGuids()
	Contra.Guids.GetMyGuid()
end


--事件变更guid
Contra.Guids.guidsFrame:SetScript("OnEvent", Contra.Guids.ChangeGuidList)
--周期性移除guid
Contra.Guids.guidsFrame:SetScript("OnUpdate", Contra.Guids.RemoveOldGuids)


--打印所有guids
-- @usage:打印所有guids
-- @test: /run Contra.Guids.printGuids()
function Contra.Guids.printGuids()
	for guid, time in pairs(Contra.Guids.guids) do
		print("name" .. UnitName(guid) .. "GUID: " .. guid .. ", Time: " .. time)
	end
end

