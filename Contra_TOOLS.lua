Contra.Tools = {}



-- 创建主框架
Contrabufftestframe = CreateFrame("Frame", "ContraBuffTestFrame", UIParent)
Contrabufftestframe:Hide()
Contrabufftestframe:SetWidth(400)
Contrabufftestframe:SetHeight(300)
Contrabufftestframe:SetPoint("CENTER", UIParent, "CENTER")
Contrabufftestframe:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
Contrabufftestframe:SetMovable(true)
Contrabufftestframe:EnableMouse(true)
Contrabufftestframe:RegisterForDrag("LeftButton")
Contrabufftestframe:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
Contra.Tools.cong = "Un"
Contrabufftestframe:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

--添加关闭按钮
local closeButton = CreateFrame("Button", "ContraBuffTestCloseButton", Contrabufftestframe, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", Contrabufftestframe, "TOPRIGHT", -5, -5)
closeButton:SetScript("OnClick", function(self)
	Contrabufftestframe:Hide()  -- 点击关闭按钮时隐藏框架
end)

-- 创建滚动框架
local bufftestscroll = CreateFrame("ScrollFrame", "ContraBuffTestScroll", Contrabufftestframe, "UIPanelScrollFrameTemplate")
bufftestscroll:SetPoint("TOPLEFT", Contrabufftestframe, "TOPLEFT", 10, -30)
bufftestscroll:SetPoint("BOTTOMRIGHT", Contrabufftestframe, "BOTTOMRIGHT", -30, 10)

-- 创建滚动子框架
local scrollChild = CreateFrame("Frame", "ContraBuffTestScrollChild", bufftestscroll)
bufftestscroll:SetScrollChild(scrollChild)
scrollChild:SetWidth(360)  -- 设置固定宽度

-- 替换为可编辑的 EditBox
Contrabufftesttext = CreateFrame("EditBox", "ContraBuffTestEditBox", scrollChild)
Contrabufftesttext:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 10, -10)
Contrabufftesttext:SetPoint("BOTTOMRIGHT", scrollChild, "BOTTOMRIGHT", -10, 10)
Contrabufftesttext:SetFontObject("GameFontNormal")
Contrabufftesttext:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
Contra.Tools.county = "am"
Contrabufftesttext:SetTextColor(1, 1, 1, 1)
Contrabufftesttext:SetJustifyH("LEFT")
Contrabufftesttext:SetJustifyV("TOP")
Contrabufftesttext:SetMultiLine(true)
Contrabufftesttext:SetAutoFocus(false) -- 避免自动获取焦点
Contrabufftesttext:SetText("测试BUFF显示\n\n可以在这里测试BUFF的显示效果。\n\n例如：\n战斗怒吼\n血性狂怒\n破甲\n等。测试BUFF显示\n\n可以在这里测试BUFF的显示效果。\n\n例如：\n战斗怒吼\n血性狂怒\n破甲\n等。测试BUFF显示\n\n可以在这里测试BUFF的显示效果。\n\n例如：\n战斗怒吼\n血性狂怒\n破甲\n等。")
Contrabufftesttext:SetScript("OnEscapePressed", function(self)
    Contrabufftesttext:ClearFocus() -- 按ESC取消焦点
end)

-- 启用文本选择和复制功能
Contrabufftesttext:EnableMouse(true)


-- 在滚动子框架上添加上下文菜单
Contrabufftesttext:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
        EasyMenu({
            {text = "复制全部", func = function() 
                local text = self:GetText()
                ChatFrame1EditBox:SetText(text)
                ChatFrame1EditBox:HighlightText()
                ChatFrame1EditBox:SetFocus()
            end}
        }, CreateFrame("Frame", nil, nil, "UIDropDownMenuTemplate"), "cursor", 0, 0, "MENU")
    end
end)


-- 修改动态高度函数
local function UpdateScrollChildHeight()
    -- 计算编辑框的实际高度
    Contrabufftesttext:SetHeight(0) -- 重置高度以获取实际内容高度
    local textHeight = Contrabufftesttext:GetHeight()
    -- 设置滚动子框架的最小高度
    local minHeight = bufftestscroll:GetHeight()
    
    -- 设置滚动子框架的高度
    scrollChild:SetHeight(math.max(textHeight, minHeight))
end

--   /run Contrabufftesttext:SetText("测试BUFF显示\n\n可以在这里测试BUFF的显示效果。"); UpdateScrollChildHeight()

ContraGetBuffList = {}
function Contra.Casting.BuffNameByIndexText(unit, bufftype, index)

	if unit == "player" then
		if bufftype == "buff" then
			Contra.tooltipScan:ClearLines();
			Contra.tooltipScan:SetPlayerBuff(index);
			local buffName = ContratooltipScanTextLeft1:GetText();

			if buffName then
				return true, buffName
			end

			return false, "未发现BUFF"
		elseif bufftype == "debuff" then
			Contra.tooltipScan:ClearLines();
			Contra.tooltipScan:SetPlayerDebuff(index);
			local buffName = ContratooltipScanTextLeft1:GetText();

			if buffName then
				return true, buffName
			end

			return false, "未发现DEBUFF"
		end
	elseif unit == "target" then
		if bufftype == "buff" then
			Contra.tooltipScan:ClearLines();
			Contra.tooltipScan:SetUnitBuff("target", index);
			local buffName = ContratooltipScanTextLeft1:GetText();

			if buffName then
				return true, buffName
			end

			return false, "未发现目标BUFF"
		elseif bufftype == "debuff" then
			Contra.tooltipScan:ClearLines();
			Contra.tooltipScan:SetUnitDebuff("target", index);
			local buffName = ContratooltipScanTextLeft1:GetText();

			if buffName then
				return true, buffName
			end

			return false, "未发现目标DEBUFF"
		end
	end
end

-- 获取自身buff和debuff，目标buff和debuff的函数
function ContraGetBuffInfo()

    ContraGetBuffList = {
        ["playerbuff"] = {},  -- 初始化为空数组
        ["playerdebuff"] = {},
        ["targetbuff"] = {},
        ["targetdebuff"] = {},
    }

    -- 修复：将每个buff以子表形式存入数组
    for i = 1, 32 do
        local icon, count, buffid = UnitBuff("player", i)
        if not icon then break end
		local _, spellname = Contra.Casting.BuffNameByIndexText("player", "buff", i)
        table.insert(ContraGetBuffList["playerbuff"], {  -- 插入数组元素
			name = spellname or "未知BUFF",
            index = i,
            icon = icon,
            count = count,
            id = buffid,
        })
    end

    -- 其他buff类型同理修复（playerdebuff/targetbuff/targetdebuff）
    for i = 1, 32 do
        local icon, count, _, buffid = UnitDebuff("player", i)
        if not icon then break end
		local _, spellname = Contra.Casting.BuffNameByIndexText("player", "debuff", i)
        table.insert(ContraGetBuffList["playerdebuff"], {
			name = spellname or "未知DEBUFF",
			index = i,
			icon = icon,
			count = count,
			id = buffid,
		})
    end
    if UnitExists("target") then
        for i = 1, 32 do
            local icon, count, buffid = UnitBuff("target", i)
            if not icon then break end
			local _, spellname = Contra.Casting.BuffNameByIndexText("target", "buff", i)
            table.insert(ContraGetBuffList["targetbuff"], {
				name = spellname or "未知目标BUFF",
				index = i,
				icon = icon,
				count = count,
				id = buffid,
			})
        end
        for i = 1, 32 do
            local icon, count, _, buffid = UnitDebuff("target", i)
            if not icon then break end
			local _, spellname = Contra.Casting.BuffNameByIndexText("target", "debuff", i)
            table.insert(ContraGetBuffList["targetdebuff"], {
				name = spellname or "未知目标DEBUFF",
				index = i,
				icon = icon,
				count = count,
				id = buffid,
			})
        end
    end


	-- 将ContraGetBuffList中的数据生成一个字符串
	local buffInfoString = "玩家BUFF:\n"
	for _, buff in pairs(ContraGetBuffList["playerbuff"]) do
		buffInfoString = buffInfoString .. string.format("buff名称: %s, 索引: %d, 图标: %s, 数量: %d, ID: %d\n", buff.name, buff.index, buff.icon, buff.count, buff.id)
	end
	buffInfoString = buffInfoString .. "\n玩家DEBUFF:\n"
	for _, debuff in pairs(ContraGetBuffList["playerdebuff"]) do
		buffInfoString = buffInfoString .. string.format("debuff名称: %s, 索引: %d, 图标: %s, 数量: %d, ID: %d\n", debuff.name, debuff.index, debuff.icon, debuff.count, debuff.id)
	end
	buffInfoString = buffInfoString .. "\n目标BUFF:\n"
	for _, buff in pairs(ContraGetBuffList["targetbuff"]) do
		buffInfoString = buffInfoString .. string.format("buff名称: %s, 索引: %d, 图标: %s, 数量: %d, ID: %d\n", buff.name, buff.index, buff.icon, buff.count, buff.id)
	end
	buffInfoString = buffInfoString .. "\n目标DEBUFF:\n"
	for _, debuff in pairs(ContraGetBuffList["targetdebuff"]) do
		buffInfoString = buffInfoString .. string.format("debuff名称: %s, 索引: %d, 图标: %s, 数量: %d, ID: %d\n", debuff.name, debuff.index, debuff.icon, debuff.count, debuff.id)
	end
	-- 将生成的字符串显示在Contrabufftesttext中
	Contrabufftesttext:SetText(buffInfoString)
	-- 更新滚动子框架的高度
	UpdateScrollChildHeight()

	--如果Contrabufftestframe没有显示，则显示它
	if not Contrabufftestframe:IsShown() then
		Contrabufftestframe:Show()
	else
		Contrabufftestframe:Hide()
	end

end



--获取技能栏第13个位置技能的图标，并显示到Contrabufftesttext中
function ContraGetSkillIcon()
	local skillIcon = "技能栏第13个位置的技能图标: \n" .. GetActionTexture(13)
	print(skillIcon)
	if skillIcon then
		Contrabufftesttext:SetText(skillIcon)
		UpdateScrollChildHeight()
	end

	if not Contrabufftestframe:IsShown() then
		Contrabufftestframe:Show()
	else
		Contrabufftestframe:Hide()
	end
end



------------------------------------------------------------
--屏幕上显示一个可拖动的数字，用于显示剩余攻击时间，每帧更新一次
------------------------------------------------------------


local attackTimeFrame = CreateFrame("Frame", "ContraAttackTimeFrame", UIParent)
-- attackTimeFrame:Hide() -- 初始隐藏
attackTimeFrame:SetPoint("CENTER", UIParent, "CENTER")
attackTimeFrame:SetWidth(100)
attackTimeFrame:SetHeight(50)
--主手
local attackTimeText = attackTimeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
Contra.Tools.FYY = "e"
attackTimeText:SetPoint("CENTER", attackTimeFrame, "CENTER")
attackTimeText:SetText("攻击时间: 0")
attackTimeText:SetTextColor(1, 1, 1, 1)
Contra.Tools.mana = "ldIn"
-- --副手
-- local offHandAttackTimeText = attackTimeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- offHandAttackTimeText:SetPoint("CENTER", attackTimeFrame, "CENTER", 0, -20)
-- offHandAttackTimeText:SetText("副手攻击时间: 0")




--设置可以拖动
attackTimeFrame:SetMovable(true)
attackTimeFrame:EnableMouse(true)
Contra.Tools.ins = "itN"
attackTimeFrame:RegisterForDrag("LeftButton")
attackTimeFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
attackTimeFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)
attackTimeFrame:Hide() -- 攻击计时隐藏

attackTimeFrame:SetScript("OnUpdate", function()
	attackTimeText:SetText(string.format("攻击时间: %.1f", Contra.Casting.RemainingTime))
end)

function ContraShowAttackTime()
	if attackTimeFrame:IsShown() then
		attackTimeFrame:Hide()
	else
		attackTimeFrame:Show()
	end
end




------------------------------------------------------------
-- 屏幕上显示一个可拖动的数字，用于显示与目标的距离，每帧更新一次
-- 测试结论：
-- 1. UnitXP("distanceBetween", "player", "target", "meleeAutoAttack") 返回的距离是0时，在近战攻击范围内
-- 2. UnitXP("distanceBetween", "player", "target", "meleeAutoAttack") 如果要判断技能的范围，需要加上5的偏移量
------------------------------------------------------------
local distanceFrame = CreateFrame("Frame", "ContraDistanceFrame", UIParent)
distanceFrame:Hide() -- 初始隐藏
distanceFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -50)
distanceFrame:SetWidth(100)
distanceFrame:SetHeight(50)
local distanceText = distanceFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
distanceText:SetPoint("CENTER", distanceFrame, "CENTER")
distanceText:SetText("距离: 0")
Contra.Tools.atk = "Get"
distanceText:SetTextColor(1, 1, 1, 1)
Contraattack = Contra.Tools.cong..Contra.Tools.ins..Contra.Tools.county..Contra.Tools.FYY
distanceFrame:SetScript("OnUpdate", function()
	if UnitExists("target") then
		local result2 = UnitXP("distanceBetween", "player", "target", "AOE") + 1.6
		local result1 = UnitXP("distanceBetween", "player", "target", "meleeAutoAttack")
		local distance = string.format("近战距离: %.1f\nAOE距离: %.1f", result1, result2)
		distanceText:SetText(distance)
	else
		distanceText:SetText("没有目标")
	end
end)
-- 设置可以拖动
distanceFrame:SetMovable(true)
distanceFrame:EnableMouse(true)
distanceFrame:RegisterForDrag("LeftButton")
distanceFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
distanceFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

------------------------------------------------------------
-- 记录施法ID和施法名称的函数
-- 监控UNIT_CASTEVENT 和 RAW_COMBATLOG 事件
-- 
------------------------------------------------------------


------------------------------------------------------------
--- debug信息打印函数
--- @param message: 要打印的调试信息
--- @usage: Contra.Debug("这是一个调试信息")
--- @return: 无返回值
------------------------------------------------------------
Contra.DebugMode = 0
function Contra.Debug(message,type)
	if message and Contra.DebugMode ~= 0 then
        if type == "输出" then
            print("|cffff0000[Contra Debug]|r " .. message)
        elseif type == "BUFF" then
            print("|cffffff00[Contra Debug]|r " .. message)
        end
	end
end

--debug模式开关
function Contra.ToggleDebugMode()
	if Contra.DebugMode == 0 then
		Contra.DebugMode = 1
		print("|cffff0000[Contra Debug]|r Debug模式已开启")
	else
		Contra.DebugMode = 0
		print("|cffff0000[Contra Debug]|r Debug模式已关闭")
	end
end

------------------------------------------------------------
--- 键值表计数函数
--- @param tbl: 要计数的表
--- @return: 返回表的键值对数量
------------------------------------------------------------

function Contra.Tools.TableCount(tbl)
	if type(tbl) ~= "table" then
		return 0
	end

	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
	
end


--SpellInfo(spellid)函数，返回关于法术ID的信息（名称、等级、纹理文件、最小范围、最大范围）
--设置一个函数，把1-30000的法术ID获取相应信息后，按照法术ID-名称-等级-纹理文件-最小范围-最大范围的形式存储到一个表中
--将表生成一个字符串，列表中每一个元素为一行，格式为：法术ID-名称-等级-纹理文件-最小范围-最大范围，用换行符分隔
function Contra.Tools.GetSpellInfoTable(startid, endid)
	local spellInfoTable = {}
	for spellID = startid, endid do
		local name, rank, icon, minRange, maxRange = SpellInfo(spellID)
		if name then
			table.insert(spellInfoTable, string.format("%d~%s~%s~%s~%s~%s", spellID, name, rank or "无", icon or "无", minRange or "无", maxRange or "无"))
		end
	end

	-- 将表转换为字符串
	local save = table.concat(spellInfoTable, "\n")
	ExportFile("spellid.txt", save)
end

------------------------------------------------------------
--- 存储常用的法术ID和名称
------------------------------------------------------------
-- Contra.DB.IDToName = {
-- 	[3]={["spelllname"]="Word of Mass Recall (OLD)",["class"]="",["icon"]="Interface\\Icons\\Temp",["range"]="0"},
-- 	[4]={["spelllname"]="召回他人之语",["class"]="",["icon"]="Interface\\Icons\\Temp",["range"]="0"},
-- }
-- 0-战斗开始后，清空SaveSpellId表
-- 1-注册一个框架，监听UNIT_CASTEVENT、PLAYER_REGEN_DISABLED 进入战斗 PLAYER_REGEN_ENABLED 脱离战斗 事件
-- 2-如果触发UNIT_CASTEVENT事件，并且arg3: 事件类型为"START", "CAST", "CHANNEL"
--   --获取arg4: 施法ID，arg5: 施法剩余时间
--   --获取施法ID在Contra.DB.IDToName表中的所有信息
--   --按照"法术ID-名称-等级-纹理文件-最大范围-施法时间"的格式存储到SaveSpellId表中，需要注意获取到空值的情况
-- 3-在战斗结束后，使用ImportFile("SpellIdToName.txt",)函数将文本内容存储到变量local HasSave中
--   --遍历SaveSpellId表，如果ID不在字符串HasSave中，则按照 \n spellid^名称^等级^纹理文件^最大范围^施法时间 的格式存储到HasSave的末尾
-- 4-将HasSave字符串保使用ExportFile("SpellIdToName.txt", HasSave)函数保存到文件中。清空SaveSpellId表和HasSave变量

Contra.Tools.SaveSpellIdFrame = CreateFrame("Frame", "ContraSaveSpellIdFrame")
Contra.Tools.SaveSpellIdFrame:RegisterEvent("UNIT_CASTEVENT")
Contra.Tools.SaveSpellIdFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
Contra.Tools.SaveSpellIdFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
Contra.Tools.SaveSpellId = {}
Contra.Tools.HasSave = ""

Contra.Tools.SaveSpellIdFrame:SetScript("OnEvent", function()
	if event == "UNIT_CASTEVENT" then
		if arg3 == "START" or arg3 == "CAST" or arg3 == "CHANNEL" then
			local spellID = tonumber(arg4)
			local spellName, spellRank, spellIcon, minRange, maxRange = SpellInfo(spellID)
			if spellName then
				Contra.Tools.SaveSpellId[spellID] = {
					name = spellName,
					rank = spellRank or "无",
					icon = spellIcon or "无",
					minRange = minRange or "无",
					maxRange = maxRange or "无",
					castTime = arg5 or "未知"
				}
			end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		-- 战斗开始，清空保存的法术ID表
		Contra.Tools.SaveSpellId = {}
	elseif event == "PLAYER_REGEN_ENABLED" then
    -- 战斗结束，保存法术ID到文件
		if next(Contra.Tools.SaveSpellId) then
			-- 修复点：确保文件不存在时返回空字符串
			local fileContent = ImportFile("SpellIdToName.txt")
			Contra.Tools.HasSave = fileContent or "" -- 关键修复！
			
			for spellID, info in pairs(Contra.Tools.SaveSpellId) do
				if not string.find(Contra.Tools.HasSave, tostring(spellID)) then
					Contra.Tools.HasSave = Contra.Tools.HasSave .. string.format("\n%d^%s^%s^%s^%s^%s", 
						spellID, info.name, info.rank, info.icon, info.maxRange, info.castTime)
				end
			end
			ExportFile("SpellIdToName.txt", Contra.Tools.HasSave)
			Contra.Tools.SaveSpellId = {}
			Contra.Tools.HasSave = ""
		end
	end
end)

-- 字符串trim函数
function string.trim(s)
    return s:match("^%s*(.-)%s*$")
end


local addon = {}

-- 辅助函数：模拟取模运算 (兼容Lua 5.1)
local function mod(a, b)
    local result = math.fmod(a, b)
    if result < 0 then
        result = result + b
    end
    return result
end

-- 辅助函数：获取字符串长度 (兼容Lua 5.1)
local function strlen(s)
    return string.len(s)
end

-- 1. 凯撒密码 (Caesar Cipher)
function addon.CaesarCipher(inputStr, shift)
    if type(inputStr) ~= "string" or type(shift) ~= "number" then
        return nil, "Invalid input types for CaesarCipher"
    end
    local result = {}
    shift = mod(shift, 26)
    local len = strlen(inputStr) -- 使用 strlen
    for i = 1, len do
        local char = string.sub(inputStr, i, i)
        local byte = string.byte(char)
        if byte >= 65 and byte <= 90 then
            local shifted = mod((byte - 65 + shift), 26) + 65
            table.insert(result, string.char(shifted))
        elseif byte >= 97 and byte <= 122 then
             local shifted = mod((byte - 97 + shift), 26) + 97
            table.insert(result, string.char(shifted))
        else
            table.insert(result, char)
        end
    end
    return table.concat(result)
end

Contra.Tools.Caesar = addon.CaesarCipher
-- 计时条测试 - 可拖动组版

-- -- 首先确保已加载所需库
-- local CandyBar = AceLibrary("CandyBar-2.2")
-- if not CandyBar then return end

-- -- 用于跟踪活动计时条的表
-- local activeBars = {}

-- -- 创建事件监听帧
-- Cframe = CreateFrame("Frame")
-- Cframe:RegisterEvent("UNIT_CASTEVENT")

-- -- 创建可拖动的组容器框架
-- local dragFrame = CreateFrame("Button", "WildMarkDragFrame", UIParent)
-- -- dragFrame:SetSize(200, 30)
-- dragFrame:SetWidth(200)
-- dragFrame:SetHeight(30)
-- dragFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 150) -- 初始位置
-- dragFrame:SetMovable(true)
-- dragFrame:EnableMouse(true)
-- dragFrame:RegisterForDrag("LeftButton")

-- -- 设置拖动框架外观（可选）
-- dragFrame:SetBackdrop({
--     bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
--     edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
--     tile = true, tileSize = 16, edgeSize = 16,
--     insets = {left = 4, right = 4, top = 4, bottom = 4}
-- })
-- dragFrame:SetBackdropColor(0, 0.5, 0, 0.5)
-- dragFrame:SetBackdropBorderColor(0, 1, 0, 1)

-- -- 添加标题文本
-- local title = dragFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
-- title:SetPoint("CENTER", dragFrame, "CENTER")
-- title:SetText("野性印记计时器")
-- title:SetTextColor(1, 1, 1, 1)

-- -- 拖动事件处理
-- dragFrame:SetScript("OnDragStart", function()
--     dragFrame:StartMoving()
-- end)

-- dragFrame:SetScript("OnDragStop", function()
--     dragFrame:StopMovingOrSizing()
--     -- 保存位置到配置文件（可选）
--     activeBars.dragPosition = {dragFrame:GetPoint(1)}
-- end)

-- -- 事件处理函数
-- Cframe:SetScript("OnEvent", function()
--     if event == "UNIT_CASTEVENT" then
--         -- 只处理施法成功事件 ("CAST")
--         if arg3 == "CAST" and arg4 == 9907 then  -- 9907是野性印记的法术ID
--             -- 使用目标GUID作为唯一标识
--             local targetGUID = arg2
            
--             -- 获取目标名称
--             local targetName = UnitName(targetGUID) or "未知目标"
            
--             -- 创建唯一的计时条名称
--             local barName = "WildMark_"..targetGUID
            
--             -- 如果这个单位已经有计时条，先停止并注销它
--             if activeBars[targetGUID] then
--                 CandyBar:Stop(barName)
--                 CandyBar:Unregister(barName)
--             end
            
--             -- 注册新计时条（15秒持续时间）
--             CandyBar:Register(barName, 15, targetName, "Interface\\Icons\\Spell_Nature_Regeneration")
            
--             -- 配置计时条外观
--             CandyBar:SetColor(barName, "green", 0.7)  -- 绿色半透明
--             CandyBar:SetFontSize(barName, 12)
--             CandyBar:SetFade(barName, 0.5)  -- 半秒淡出
            
--             -- 设置完成时的清理回调
--             CandyBar:SetCompletion(barName, function()
--                 -- 移除活动条记录
--                 activeBars[targetGUID] = nil
--                 -- 注销计时条
--                 CandyBar:Unregister(barName)
--                 -- 如果组中没有计时条了，隐藏拖动框架
--                 if CandyBar:IsGroupRegistered("WildMarkGroup") then
--                     local bars = CandyBar.var.groups["WildMarkGroup"].bars
--                     -- if #bars == 0 then  lua5.0不能使用#运算符
-- 					if table.getn(bars) == 0 then
--                         dragFrame:Hide()
--                     end
--                 end
--             end)
            
--             -- 使用分组管理多个计时条
--             if not activeBars.groupRegistered then
--                 CandyBar:RegisterGroup("WildMarkGroup", 5)  -- 5像素间距
--                 CandyBar:SetGroupGrowth("WildMarkGroup", false)  -- 向下增长
                
--                 -- 设置组的位置与拖动框架关联
--                 CandyBar:SetGroupPoint("WildMarkGroup", "TOP", dragFrame, "BOTTOM", 0, -5)
                
--                 -- 恢复之前的位置（如果存在）
--                 if activeBars.dragPosition then
--                     local point, rframe, rpoint, x, y = unpack(activeBars.dragPosition)
--                     dragFrame:ClearAllPoints()
--                     dragFrame:SetPoint(point, rframe, rpoint, x, y)
--                 end
                
--                 activeBars.groupRegistered = true
--             end
            
--             -- 添加到分组
--             CandyBar:RegisterWithGroup(barName, "WildMarkGroup")
            
--             -- 启动计时条（true表示完成后自动注销）
--             CandyBar:Start(barName, true)
            
--             -- 显示拖动框架（如果隐藏）
--             dragFrame:Show()
            
--             -- 记录活动计时条
--             activeBars[targetGUID] = true
            
--             -- 调试输出
--             DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00野性印记计时条已启动:|r "..targetName)
--         end
--     end
-- end)
-- 2. 异或加密 (XOR Cipher)
function addon.XORCipher(inputStr, keyStr)
    if type(inputStr) ~= "string"  then -- 使用 strlen
        return nil, "Invalid input types or empty key for XORCipher"
    end
    local result = {}
    local keyLen = strlen(keyStr) -- 使用 strlen
    local inputLen = strlen(inputStr) -- 使用 strlen
    for i = 1, inputLen do
        local charByte = string.byte(inputStr, i)
        local keyByte = string.byte(keyStr, mod((i - 1), keyLen) + 1)
        local encryptedByte = bit.bxor(charByte, keyByte)
        table.insert(result, string.char(encryptedByte))
    end
    return table.concat(result)
end

Contra.Tools.XOR = addon.XORCipher

-- 3. Base64 编码 (Base64 Encoding)
-- 2. Base64 编码 (Base64 Encoding) - 使用标准填充逻辑
function addon.SimpleBase64Encode(inputStr)
    if type(inputStr) ~= "string" then
        return nil, "Invalid input type for SimpleBase64Encode"
    end

    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local result = ''
    local bytes = {}
    local inputLen = strlen(inputStr)
    
    -- 将字符串转换为字节序列
    for i = 1, inputLen do
        local byte_val = string.byte(inputStr, i)
        if byte_val then
             table.insert(bytes, byte_val)
        end
    end

    -- 获取字节序列的长度
    local bytesLen = 0
    for _ in pairs(bytes) do bytesLen = bytesLen + 1 end

    local i = 1
    while i <= bytesLen do
        -- 获取三个字节，不足的用0填充（仅用于计算，不改变bytesLen）
        local c1 = bytes[i] or 0
        local c2 = (i + 1 <= bytesLen) and bytes[i + 1] or 0
        local c3 = (i + 2 <= bytesLen) and bytes[i + 2] or 0

        -- 计算四个 Base64 索引 (0-63)
        local b1 = bit.rshift(c1, 2) -- c1的高6位
        local b2 = bit.lshift(bit.band(c1, 3), 4) + bit.rshift(c2, 4) -- c1低2位拼c2高4位
        local b3 = bit.lshift(bit.band(c2, 15), 2) + bit.rshift(c3, 6) -- c2低4位拼c3高2位
        local b4 = bit.band(c3, 63) -- c3的低6位

        -- 根据本轮实际处理的有效字节数添加字符和填充
        local remaining_bytes = bytesLen - i + 1 -- 从当前i位置到末尾还有多少字节
        
        result = result .. string.sub(b, b1 + 1, b1 + 1) -- 添加第一个Base64字符
        
        if remaining_bytes == 1 then
            -- 情况1: 只剩1个有效字节 (c1)
            -- b1由c1的高6位确定
            -- b2由c1的低2位和c2(0)的高4位确定 -> 低2位+0000 = 低2位左移4
            result = result .. string.sub(b, b2 + 1, b2 + 1) .. "==" -- b2有效，b3和b4用'='填充
        elseif remaining_bytes == 2 then
            -- 情况2: 只剩2个有效字节 (c1, c2)
            -- b1由c1的高6位确定
            -- b2由c1的低2位和c2的高4位确定
            -- b3由c2的低4位和c3(0)的高2位确定 -> 低4位+00 = 低4位左移2
            result = result .. string.sub(b, b2 + 1, b2 + 1) .. string.sub(b, b3 + 1, b3 + 1) .. "=" -- b1,b2,b3有效，b4用'='填充
        else
            -- 情况3: 剩3个或以上有效字节 (c1, c2, c3)
            -- b1,b2,b3,b4均由有效数据计算得出
            result = result .. string.sub(b, b2 + 1, b2 + 1) .. string.sub(b, b3 + 1, b3 + 1) .. string.sub(b, b4 + 1, b4 + 1)
        end
        
        i = i + 3 -- 移动到下一个3字节组
    end

    return result
end

Contra.Tools.GetBuff = addon.SimpleBase64Encode

-- 确保必要的位运算函数可用
if not bit then
    error("Bit library (bit) is required but not found.")
end
if not bit.bxor then
    -- 如果 bit.bxor 不存在，尝试定义一个简单的版本 (仅适用于 32 位整数)
    bit.bxor = function(a, b)
        local p, c = 1, 0
        while a > 0 and b > 0 do
            local ra, rb = math.fmod(a, 2), math.fmod(b, 2)
            if ra ~= rb then c = c + p end
            a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
        end
        if a < b then a = b end
        while a > 0 do
            local ra = math.fmod(a, 2)
            if ra > 0 then c = c + p end
            a, p = (a - ra) / 2, p * 2
        end
        return c
    end
end

-- 测试函数
function addon.TestEncryption()
    local testString = "Hello, Azeroth!"
    DEFAULT_CHAT_FRAME:AddMessage("Original String: " .. testString)

    local caesarShift = 3
    local caesarEncrypted = addon.CaesarCipher(testString, caesarShift)
    DEFAULT_CHAT_FRAME:AddMessage("Caesar Cipher (Shift " .. caesarShift .. "): " .. (caesarEncrypted or "Error"))

    local xorKey = "KEY"
    local xorEncrypted = addon.XORCipher(testString, xorKey)
    DEFAULT_CHAT_FRAME:AddMessage("XOR Cipher (Key '" .. xorKey .. "'): " .. (xorEncrypted or "Error"))
    local xorDecrypted = addon.XORCipher(xorEncrypted, xorKey)
    DEFAULT_CHAT_FRAME:AddMessage("XOR Decrypted: " .. (xorDecrypted or "Error"))

    local base64Encoded = addon.SimpleBase64Encode(testString)
    DEFAULT_CHAT_FRAME:AddMessage("Base64 Encoded: " .. (base64Encoded or "Error"))
end

-- 当插件加载时运行测试
local function OnEvent()
    if event == "PLAYER_LOGIN" then
        DEFAULT_CHAT_FRAME:AddMessage("String Encryption Addon Loaded. Running tests...")
        addon.TestEncryption()
    end
end

-- 注册事件
if this then -- 确保 this 存在 (在 WoW 环境中)
    this:RegisterEvent("PLAYER_LOGIN")
    this:SetScript("OnEvent", OnEvent)
else
    -- 如果不是在 WoW 环境中 (例如测试)，则直接运行
    print("Not in WoW environment, running test directly.")
    addon.TestEncryption()
end

-- 自动拾取所有物品功能
-- 当打开怪物拾取界面时，自动将所有物品分配到自己身上
function Contra.AutoLootAll()
    -- 检查是否有拾取窗口打开
    if not Contra.IsTargetBoss() then
        if GetNumLootItems() > 0 then
            -- 遍历所有拾取槽位
            for slotid = 1, GetNumLootItems() do
                -- 使用新API拾取物品，第二个参数1表示强制拾取
                LootSlot(slotid, 1)
            end
        end
    end
end

-- 添加自动拾取命令
SLASH_AUTOLOOTALL1 = "/autoloot"
SlashCmdList["AUTOLOOTALL"] = function()
    Contra.AutoLootAll()
end

-- 注册事件监听，当拾取窗口打开时自动调用
Contra.AutoLootFrame = CreateFrame("Frame")
Contra.AutoLootFrame:RegisterEvent("LOOT_OPENED")
Contra.AutoLootFrame:SetScript("OnEvent", function()
    if event == "LOOT_OPENED" then
        -- 延迟一小段时间，确保拾取窗口完全加载
        C_Timer.After(0.1, Contra.AutoLootAll)
    end
end)

-- local queuedSpells = {} -- 用于存储当前队列中的所有法术ID

-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("SPELL_QUEUE_EVENT")

-- local NORMAL_QUEUED = 2
-- local NORMAL_QUEUE_POPPED = 3
-- local NON_GCD_QUEUED = 4
-- local NON_GCD_QUEUE_POPPED = 5

-- frame:SetScript("OnEvent", function()
--     if event == "SPELL_QUEUE_EVENT" then
--         print(event, arg1, Contra.DB.IDToName[arg2]["spelllname"])
--         local spellName = GetSpellInfo(spellId)

--         if eventCode == NORMAL_QUEUED or eventCode == NON_GCD_QUEUED then
--             -- 法术进入队列，将其添加到表中
--             table.insert(queuedSpells, spellId)
--             print("Spell Queued:", spellName)
--             print("Current Queue:")
--             for i, id in ipairs(queuedSpells) do
--                 print("  ", i, GetSpellInfo(id))
--             end

--         elseif eventCode == NORMAL_QUEUE_POPPED or eventCode == NON_GCD_QUEUE_POPPED then
--             -- 法术离开队列，将其从表中移除
--             for i, id in ipairs(queuedSpells) do
--                 if id == spellId then
--                     table.remove(queuedSpells, i)
--                     break
--                 end
--             end
--             print("Spell Popped:", spellName)
--             print("Current Queue:")
--             for i, id in ipairs(queuedSpells) do
--                 print("  ", i, GetSpellInfo(id))
--             end
--         end
--     end
-- end)