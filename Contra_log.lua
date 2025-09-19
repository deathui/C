-- -- 创建战斗日志框架
-- Contra.BattleLog = {}
-- Contra.BattleLog.Frame = CreateFrame("Frame", "ContraBattleLogFrame", UIParent)
-- Contra.BattleLog.Frame:SetWidth(650)
-- Contra.BattleLog.Frame:SetHeight(300)
-- Contra.BattleLog.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
-- Contra.BattleLog.Frame:SetBackdrop({
--     bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
--     edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
--     tile = true, tileSize = 16, edgeSize = 16,
--     insets = { left = 4, right = 4, top = 4, bottom = 4 }
-- })
-- Contra.BattleLog.Frame:SetBackdropColor(0, 0, 0, 0.8)
-- Contra.BattleLog.Frame:SetMovable(true)
-- Contra.BattleLog.Frame:EnableMouse(true)
-- Contra.BattleLog.Frame:RegisterForDrag("LeftButton")
-- Contra.BattleLog.Frame:SetScript("OnDragStart", function()
--     Contra.BattleLog.Frame:StartMoving()
-- end)
-- Contra.BattleLog.Frame:SetScript("OnDragStop", function()
--     Contra.BattleLog.Frame:StopMovingOrSizing()
-- end)
-- Contra.BattleLog.Frame:Hide()

-- -- 创建标题
-- Contra.BattleLog.Title = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
-- Contra.BattleLog.Title:SetPoint("TOP", Contra.BattleLog.Frame, "TOP", 0, -5)
-- Contra.BattleLog.Title:SetText("战斗日志")
-- Contra.BattleLog.Title:SetTextColor(1, 1, 0)

-- -- 定义列宽和位置
-- local colWidths = {
--     time = 60,
--     spell = 100,
--     rage = 40,
--     st = 40,
--     ss = 40,
--     targetPct = 60,
--     targetHP = 80,
--     cd1 = 60,
--     cd2 = 60,
--     cd3 = 60
-- }

-- -- 创建表头
-- local headerX = 10
-- Contra.BattleLog.Headers = {}

-- -- 时间
-- Contra.BattleLog.Headers.time = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.time:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.time:SetWidth(colWidths.time)
-- Contra.BattleLog.Headers.time:SetText("时间")
-- Contra.BattleLog.Headers.time:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.time

-- -- 技能名称
-- Contra.BattleLog.Headers.spell = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.spell:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.spell:SetWidth(colWidths.spell)
-- Contra.BattleLog.Headers.spell:SetText("技能名称")
-- Contra.BattleLog.Headers.spell:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.spell

-- -- 怒气
-- Contra.BattleLog.Headers.rage = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.rage:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.rage:SetWidth(colWidths.rage)
-- Contra.BattleLog.Headers.rage:SetText("怒气")
-- Contra.BattleLog.Headers.rage:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.rage

-- -- ST
-- Contra.BattleLog.Headers.st = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.st:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.st:SetWidth(colWidths.st)
-- Contra.BattleLog.Headers.st:SetText("ST")
-- Contra.BattleLog.Headers.st:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.st

-- -- SS
-- Contra.BattleLog.Headers.ss = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.ss:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.ss:SetWidth(colWidths.ss)
-- Contra.BattleLog.Headers.ss:SetText("SS")
-- Contra.BattleLog.Headers.ss:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.ss

-- -- 目标%
-- Contra.BattleLog.Headers.targetPct = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.targetPct:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.targetPct:SetWidth(colWidths.targetPct)
-- Contra.BattleLog.Headers.targetPct:SetText("目标%")
-- Contra.BattleLog.Headers.targetPct:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.targetPct

-- -- 目标血量
-- Contra.BattleLog.Headers.targetHP = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.targetHP:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.targetHP:SetWidth(colWidths.targetHP)
-- Contra.BattleLog.Headers.targetHP:SetText("目标血量")
-- Contra.BattleLog.Headers.targetHP:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.targetHP

-- -- 嗜血CD
-- Contra.BattleLog.Headers.cd1 = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.cd1:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.cd1:SetWidth(colWidths.cd1)
-- Contra.BattleLog.Headers.cd1:SetText("嗜血CD")
-- Contra.BattleLog.Headers.cd1:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.cd1

-- -- 致死CD
-- Contra.BattleLog.Headers.cd2 = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.cd2:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.cd2:SetWidth(colWidths.cd2)
-- Contra.BattleLog.Headers.cd2:SetText("致死CD")
-- Contra.BattleLog.Headers.cd2:SetTextColor(1, 1, 1)
-- headerX = headerX + colWidths.cd2

-- -- 旋风CD
-- Contra.BattleLog.Headers.cd3 = Contra.BattleLog.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- Contra.BattleLog.Headers.cd3:SetPoint("TOPLEFT", Contra.BattleLog.Frame, "TOPLEFT", headerX, -25)
-- Contra.BattleLog.Headers.cd3:SetWidth(colWidths.cd3)
-- Contra.BattleLog.Headers.cd3:SetText("旋风CD")
-- Contra.BattleLog.Headers.cd3:SetTextColor(1, 1, 1)

-- -- 创建滚动框架
-- Contra.BattleLog.ScrollFrame = CreateFrame("ScrollFrame", "ContraBattleLogScrollFrame", Contra.BattleLog.Frame, "UIPanelScrollFrameTemplate")
-- Contra.BattleLog.ScrollFrame:SetPoint("TOPLEFT", Contra.BattleLog.Headers.time, "BOTTOMLEFT", 0, -5)
-- Contra.BattleLog.ScrollFrame:SetPoint("BOTTOMRIGHT", Contra.BattleLog.Frame, "BOTTOMRIGHT", -25, 10)

-- -- 创建滚动内容框架
-- Contra.BattleLog.ScrollChild = CreateFrame("Frame", "ContraBattleLogScrollChild")
-- Contra.BattleLog.ScrollChild:SetWidth(620)
-- Contra.BattleLog.ScrollChild:SetHeight(240)

-- -- 设置滚动框架的子框架
-- Contra.BattleLog.ScrollFrame:SetScrollChild(Contra.BattleLog.ScrollChild)

-- -- 创建日志内容容器
-- Contra.BattleLog.ContentFrame = CreateFrame("Frame", nil, Contra.BattleLog.ScrollChild)
-- Contra.BattleLog.ContentFrame:SetPoint("TOPLEFT", Contra.BattleLog.ScrollChild, "TOPLEFT", 0, 0)
-- Contra.BattleLog.ContentFrame:SetWidth(620)

-- -- 存储日志内容
-- Contra.BattleLog.LogEntries = {}
-- Contra.BattleLog.Lines = {}

-- -- 格式化数字的辅助函数
-- function Contra.BattleLog.FormatNumber(num, decimals)
--     if not num then return "0" end
--     if decimals == 0 then
--         return tostring(floor(num))
--     elseif decimals == 1 then
--         return tostring(floor(num*10)/10)
--     else
--         return tostring(floor(num*100)/100)
--     end
-- end

-- -- 添加日志条目的函数
-- function Contra.BattleLog.AddEntry(entry)
--     table.insert(Contra.BattleLog.LogEntries, entry)
    
--     -- 将#替换为table.getn()
--     if table.getn(Contra.BattleLog.LogEntries) > 500 then
--         table.remove(Contra.BattleLog.LogEntries, 1)
--     end
    
--     -- 更新显示
--     Contra.BattleLog.UpdateDisplay()
-- end

-- -- 更新显示函数
-- function Contra.BattleLog.UpdateDisplay()
--     -- 先移除所有现有的行
--     for i, line in ipairs(Contra.BattleLog.Lines) do
--         line:Hide()
--     end
--     Contra.BattleLog.Lines = {}
    
--     -- 计算内容框架的总高度
--     local totalHeight = 20 * table.getn(Contra.BattleLog.LogEntries)
--     Contra.BattleLog.ContentFrame:SetHeight(math.max(totalHeight, 240))
    
--     -- 创建新行
--     for i, entry in ipairs(Contra.BattleLog.LogEntries) do
--         local line = Contra.BattleLog.CreateLogLine(i, entry)
--         table.insert(Contra.BattleLog.Lines, line)
--     end
    
--     -- 更新滚动范围
--     local scrollHeight = Contra.BattleLog.ScrollFrame:GetHeight()
--     local scrollBar = _G[Contra.BattleLog.ScrollFrame:GetName() .. "ScrollBar"]
    
--     -- 自定义滚动更新逻辑
--     local maxLines = math.floor(scrollHeight / 20)
--     local visibleLines = math.min(table.getn(Contra.BattleLog.LogEntries), maxLines)
    
--     if totalHeight > scrollHeight then
--         scrollBar:SetMinMaxValues(0, totalHeight - scrollHeight)
--         scrollBar:Show()
--     else
--         scrollBar:SetValue(0)
--         scrollBar:Hide()
--     end
    
--     -- 设置滚动步长
--     scrollBar:SetValueStep(20)
    
--     -- 在1.12版本中，我们需要手动设置页面大小
--     scrollBar:SetScript("OnValueChanged", function(self, value)
--         Contra.BattleLog.ContentFrame:SetPoint("TOP", 0, -value)
--     end)

--     -- 设置页面大小为 (maxLines - 1) * 20 像素
--     scrollBar.pageSize = (maxLines - 1) * 20
--     scrollBar:SetScript("OnMouseWheel", function(self, delta)
--         local currentValue = scrollBar:GetValue()
--         local minVal, maxVal = scrollBar:GetMinMaxValues()
--         local newValue = currentValue - (delta * scrollBar:GetValueStep() * 3) -- 3行每次滚动
        
--         if newValue < minVal then
--             newValue = minVal
--         elseif newValue > maxVal then
--             newValue = maxVal
--         end
        
--         scrollBar:SetValue(newValue)
--     end)
-- end

-- -- 创建单行日志条目
-- function Contra.BattleLog.CreateLogLine(index, entryData)
--     local line = CreateFrame("Frame", nil, Contra.BattleLog.ContentFrame)
--     line:SetWidth(620)
--     line:SetHeight(20)
--     line:SetPoint("TOPLEFT", Contra.BattleLog.ContentFrame, "TOPLEFT", 0, -((index-1)*20))
    
--     local xOffset = 0
    
--     -- 时间
--     line.time = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.time:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.time:SetWidth(colWidths.time)
--     line.time:SetText(entryData.time or "")
--     line.time:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.time
    
--     -- 技能名称
--     line.spell = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.spell:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.spell:SetWidth(colWidths.spell)
--     line.spell:SetText(entryData.spellName or "")
--     line.spell:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.spell
    
--     -- 怒气
--     line.rage = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.rage:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.rage:SetWidth(colWidths.rage)
--     line.rage:SetText(entryData.rage or "")
--     line.rage:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.rage
    
--     -- ST
--     line.st = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.st:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.st:SetWidth(colWidths.st)
--     line.st:SetText(entryData.st or "")
--     line.st:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.st
    
--     -- SS
--     line.ss = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.ss:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.ss:SetWidth(colWidths.ss)
--     line.ss:SetText(entryData.ss or "")
--     line.ss:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.ss
    
--     -- 目标%
--     line.targetPct = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.targetPct:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.targetPct:SetWidth(colWidths.targetPct)
--     line.targetPct:SetText(entryData.targetHPPercent or "")
--     line.targetPct:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.targetPct
    
--     -- 目标血量
--     line.targetHP = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.targetHP:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.targetHP:SetWidth(colWidths.targetHP)
--     line.targetHP:SetText(entryData.targetMaxHP or "")
--     line.targetHP:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.targetHP
    
--     -- 嗜血CD
--     line.cd1 = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.cd1:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.cd1:SetWidth(colWidths.cd1)
--     line.cd1:SetText(entryData.cd1 or "")
--     line.cd1:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.cd1
    
--     -- 致死CD
--     line.cd2 = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.cd2:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.cd2:SetWidth(colWidths.cd2)
--     line.cd2:SetText(entryData.cd2 or "")
--     line.cd2:SetTextColor(1, 1, 1)
--     xOffset = xOffset + colWidths.cd2
    
--     -- 旋风CD
--     line.cd3 = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--     line.cd3:SetPoint("LEFT", line, "LEFT", xOffset, 0)
--     line.cd3:SetWidth(colWidths.cd3)
--     line.cd3:SetText(entryData.cd3 or "")
--     line.cd3:SetTextColor(1, 1, 1)
    
--     return line
-- end

-- -- 显示/隐藏战斗日志界面的函数
-- function Contra.BattleLog.Toggle()
--     if Contra.BattleLog.Frame:IsShown() then
--         Contra.BattleLog.Frame:Hide()
--     else
--         Contra.BattleLog.Frame:Show()
--         Contra.BattleLog.UpdateDisplay()
--     end
-- end

-- -- 清空日志的函数
-- function Contra.BattleLog.Clear()
--     Contra.BattleLog.LogEntries = {}
--     Contra.BattleLog.UpdateDisplay()
-- end

-- -- 创建关闭按钮
-- local closeButton = CreateFrame("Button", nil, Contra.BattleLog.Frame, "UIPanelCloseButton")
-- closeButton:SetPoint("TOPRIGHT", Contra.BattleLog.Frame, "TOPRIGHT", 0, 0)
-- closeButton:SetScript("OnClick", function()
--     Contra.BattleLog.Frame:Hide()
-- end)

-- -- 创建清空按钮
-- local clearButton = CreateFrame("Button", "ContraBattleLogClearButton", Contra.BattleLog.Frame, "UIPanelButtonTemplate")
-- clearButton:SetPoint("BOTTOM", Contra.BattleLog.Frame, "BOTTOM", 0, 5)
-- clearButton:SetWidth(60)
-- clearButton:SetHeight(20)
-- clearButton:SetText("清空")
-- clearButton:SetScript("OnClick", function()
--     Contra.BattleLog.Clear()
-- end)

-- -- 格式化日志条目并添加到显示中
-- function Contra.BattleLog.AddFormattedEntry(time, spellName, rage, st, ss, targetHPPercent, targetMaxHP, cd1, cd2, cd3)
--     local timeStr = Contra.BattleLog.FormatNumber(time, 1)
--     local stStr =   Contra.BattleLog.FormatNumber(st, 2)
--     local ssStr =   Contra.BattleLog.FormatNumber(ss, 2)
--     local cd1Str = Contra.BattleLog.FormatNumber(cd1, 2)
--     local cd2Str = Contra.BattleLog.FormatNumber(cd2, 2)
--     local cd3Str = Contra.BattleLog.FormatNumber(cd3, 2)
    
--     -- 创建表格条目而不是字符串
--     local entry = {
--         time = timeStr,
--         spellName = spellName or "未知",
--         rage = rage or 0,
--         st = stStr,
--         ss = ssStr,
--         targetHPPercent = (targetHPPercent or 0).."%", 
--         targetMaxHP = targetMaxHP or 0,
--         cd1 = cd1Str,
--         cd2 = cd2Str,
--         cd3 = cd3Str
--     }
    
--     Contra.BattleLog.AddEntry(entry)
-- end

-- -- 初始化
-- Contra.BattleLog.UpdateDisplay()

-- function Contra.BattleLog.GetLog()
--    if event == "UNIT_CASTEVENT" and (arg3 == "CAST" or arg3 == "MAINHAND") and arg1 == Contra.Guids.MyGuid then
--         local time = 0
--         if Contra.Casting.BattleEnd then time = GetTime() - Contra.Casting.BattleStart end
--         local spellName = Contra.DB.IDToName[arg4] and Contra.DB.IDToName[arg4].spelllname or "未知技能"
--         local rage = UnitMana("player")
--         local ST = Contra.Casting.RemainingTime or 0
--         local SS =  Contra.Casting.PastTime or 0
--         local hpp = (UnitHealth("target") or 0) / (UnitHealthMax("target") or 1) * 100
--         local maxhp = UnitHealthMax("target") or 0
--         local sxcd = Contra.CD("嗜血") or 0
--         local zscd = Contra.CD("致死打击") or 0
--         local xfcd = Contra.CD("旋风斩") or 0
--         Contra.BattleLog.AddFormattedEntry(time, spellName, rage, ST, SS, hpp, maxhp, sxcd, zscd, xfcd)
--     end
-- end

-- Contra.BattleLog.LFrame = CreateFrame("Frame", "ContraBattleLogLFrame", UIParent)
-- Contra.BattleLog.LFrame:RegisterEvent("UNIT_CASTEVENT")
-- Contra.BattleLog.LFrame:SetScript("OnEvent",  Contra.BattleLog.GetLog)