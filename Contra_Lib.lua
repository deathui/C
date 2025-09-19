


---------------------------------------------------------------------------
--- 目标选择、自动攻击
---------------------------------------------------------------------------
--- @usage 启动自动攻击功能，处理攻击动作条按钮或直接攻击目标
--- @note 函数会检查目标是否存在且没有被放逐术影响，然后尝试使用动作条上的攻击动作或直接攻击目标
--- @dependencies 依赖Contra.Casting.HasBuff函数来检查放逐术效果
function Contra.StartAttack()
    --如果没有目标，或者玩家的名字或工会不在Contra.DB.NameAndGuild中，则返回
	if not UnitExists("target") or(Contra.MyClass == "战士" and not Contra.DB.NameAndGuild[UnitName("player")] and not Contra.DB.NameAndGuild[GetGuildInfo("player")]) then
		return
	end
	if not Contra.Casting.HasBuff("放逐术", unit) then
		local ma
		if not ma then
			for i = 1,72 do
				if IsAttackAction(i) then
					ma = i
				end
			end
		end
		if ma then 
			if not IsCurrentAction(ma) then
				UseAction(ma);
			end
		else
			AttackTarget("target");
		end
	else
		local ma
		if not ma then
			for i = 1,72 do
				if IsAttackAction(i) then
					ma = i
				end
			end
		end
		if ma then 
			if IsCurrentAction(ma) then
				UseAction(ma);
			end
		else
			AttackTarget("target");
		end
	end
end

--选择最近的目标
function Contra.SelectNearestTarget()
	--如果不存在目标、目标死亡、目标是友方、目标是自己、目标不在近战距离之内则切换目标
	if Contra.MyClass == "战士" then
		if not UnitExists("target") or UnitIsDeadOrGhost("target") or UnitIsFriend("player", "target") or UnitIsUnit("player", "target")  or Contra.Casting.HasBuff("放逐术", unit) or not Contra.Filter.behindPlayer("target") or not Contra.IsMeleeRange() then
			--Contra.Filter.FindClosestAttackableUnit()返回的值设为目标
			local unit = Contra.Filter.FindClosestAttackableUnit()
			if unit then
				TargetUnit(unit)
			end
		end
	end

	if Contra.MyClass == "德鲁伊" or Contra.MyClass == "盗贼" or Contra.MyClass == "骑士" then
		if not UnitAffectingCombat("player") then
			if not UnitExists("target") or UnitIsDeadOrGhost("target") or UnitIsFriend("player", "target") or UnitIsUnit("player", "target")  or Contra.Casting.HasBuff("放逐术", unit) or not Contra.Filter.behindPlayer("target") or not Contra.IsMeleeRange() then
				--Contra.Filter.FindClosestAttackableUnit()返回的值设为目标
				local unit = Contra.Filter.FindClosestAttackableUnit()
				if unit then
					TargetUnit(unit)
				end
			end
		else
			if not UnitExists("target") or UnitIsDeadOrGhost("target") or UnitIsFriend("player", "target") or UnitIsUnit("player", "target")  or Contra.Casting.HasBuff("放逐术", unit) then
				--Contra.Filter.FindClosestAttackableUnit()返回的值设为目标
				local unit = Contra.Filter.FindClosestAttackableUnit()
				if unit then
					TargetUnit(unit)
				end
			end
		end
	end
end

---------------------------------------------------------------------------
--- BUFF相关
---------------------------------------------------------------------------


--- @usage: 获取buff层数
--- @test: /run print(Contra.GetBuffCount("破甲攻击", "target"))
--- @param buffName string : 要检查的BUFF名称（如 "战斗怒吼"）
--- @param unit string: 要检查的单位（默认为 "player"）
--- @return integer: 如果BUFF存在则返回层数，否则返回0
function Contra.GetBuffCount(buffName, unit)
	if not buffName then
		return 0
	end

	--如果buffname不在Contra.DB.BUFF中，则提示自行添加
	if not Contra.DB.BUFF[buffName] then
		print("|cffffff00Contra: BUFF "..buffName.." 不在数据库中，请自行添加。|r")
		return 0
	end

	unit = unit or "player"
	local buffCount = 0
	local spellID = Contra.DB.BUFF[buffName]["id"]
	
	--遍历所有BUFF和DEBUFF
	for i = 1, 64 do
		local _, unitBuffCount,unitBuffId = UnitBuff(unit, i)
		if unitBuffId and unitBuffId == spellID then
			buffCount = unitBuffCount
		end
		if not unitBuffId then
			break  -- 如果没有更多BUFF，则退出循环
		end
	end
	for i = 1, 64 do
		local _, unitDebuffCount,_ , unitDebuffId = UnitDebuff(unit, i)
		if unitDebuffId and unitDebuffId == spellID then
			buffCount = unitDebuffCount
		end
		if not unitDebuffId then
			break  -- 如果没有更多DEBUFF，则退出循环
		end
	end

	return buffCount
end


--以下BUFF判定函数源自妖姬变的CAT插件
local CatPlusTooltip = CreateFrame("GameTooltip", "CatPlusTooltip", UIParent, "GameTooltipTemplate")


--- 查找玩家的BUFF并返回 (found, index)
--- @param index: 要查找的 BUFF 索引（0-63）
--- @return (found, buffName)
--- @usage MPPlayerBuffNameByIndex(0) --- 查找第一个BUFF
function MPPlayerBuffNameByIndex(index)
    CatPlusTooltip:SetOwner(UIParent, "ANCHOR_NONE");
    CatPlusTooltip:SetPlayerBuff(index);
    local buffName = CatPlusTooltipTextLeft1:GetText();
    CatPlusTooltip:Hide();

	if buffName then
		return true, buffName
	end

	return false, "未发现BUFF"
end

--- 查找 Aura（BUFF 或 DEBUFF）并返回 (found, index)
--- @param unit: 目标单位（默认为 "player"）
--- @param index: 要查找的 Aura 索引（1-64）
--- @return (found, buffName)
function MPGetBuffNameByIndex(unit, index)
	if UnitBuff(unit, index) then
		CatPlusTooltip:SetOwner(UIParent, "ANCHOR_NONE");
		CatPlusTooltip:SetUnitBuff(unit, index);
		local buffName = CatPlusTooltipTextLeft1:GetText();
		CatPlusTooltip:Hide();

		if buffName then
			return true, buffName
		end
	end

	return false, "未发现BUFF"
end

--- 查找 Aura（BUFF 或 DEBUFF）并返回 (found, index)
--- @param unit: 目标单位（默认为 "player"）
--- @param index: 要查找的 Aura 索引（1-64）
--- @return (found, buffName)
function MPGetDebuffNameByIndex(unit, index)
	if UnitDebuff(unit, index) then
		CatPlusTooltip:SetOwner(UIParent, "ANCHOR_NONE");
		CatPlusTooltip:SetUnitDebuff(unit, index);
		local buffName = CatPlusTooltipTextLeft1:GetText();
		CatPlusTooltip:Hide();

		if buffName then
			return true, buffName
		end
	end

	return false, "未发现BUFF"
end


--- 查找 Aura（BUFF 或 DEBUFF）并返回 (found, index)
--- @param targetName: 要查找的 Aura 名称（如 "真言术：盾"、"中毒"）
--- @param unit: 目标单位（默认为 "player"）
--- 支持SuperWoW
function MPBuff(buffName, unit)
	unit = unit or "player";  --- 默认检查玩家自己
	local maxIndex = 64;

	if unit == "player" then
		--- 扫描buff位
		local count = 0
		for i = 0, maxIndex do
			--- 通过索引尝试访问buff
			local found, name = MPPlayerBuffNameByIndex(i)
			if not found then
				break
			end

			--message(name)
			count = count+1

			--- 找到buff，并名称正确
			if name==buffName then
				return true, i
			end
		end
		--- 把i返回出去，用于检测是不是buff位超出
		return false,count
	else
		--- 扫描debuff位
		for i = 1, maxIndex do
			--- 通过索引尝试访问buff
			local found, name = MPGetDebuffNameByIndex(unit,i)
			if not found then
				break
			end

			--- 找到buff，并名称正确
			if name==buffName then
				return true, i
			end
		end

		--- 扫描buff位
		for i = 1, maxIndex do
			--- 通过索引尝试访问buff
			local found, name = MPGetBuffNameByIndex(unit,i)
			if not found then
				break
			end

			--- 找到buff，并名称正确
			if name==buffName then
				return true, i
			end
		end

	end

    return false, -1  --- 未找到
end

--- 取消自己身上的buff
--- @usage /run Contra.Casting.CancelBuffByName("战斗怒吼")
--- @param buffName: 要取消的Buff名称（如 "野性印记"、"恢复"）
--- @param unit: 要取消BUFF的单位（默认为 "player"）
--- @return nil
function MPCancelBuffByName(buffName, unit)
	unit = unit or "player";  --- 默认检查玩家自己
	local f, i = MPBuff(buffName, unit)
	if f then
		CancelPlayerBuff(i)
	end
end

--根据tooltip判定BUFF
--/run print(Contra.Casting.TooltipIsBuffed("战斗怒吼"))
Contra.Casting.TooltipIsBuffed = MPBuff


--根据战斗事件判定BUFF
--/run print(Contra.Casting.EventIsBuffed("战斗怒吼"))
--- @param spellName: 要检查的BUFF名称（如 "战斗怒吼"）
--- @return isBuffed: 如果BUFF有效则返回true，否则返回false
--- @return remainingTime: 如果BUFF有效且有设置时间，则返回剩余时间（秒）
--- @usage Contra.Casting.EventIsBuffed("战斗怒吼"
function Contra.Casting.EventIsBuffed(spellName)
    if not Contra.DB.BUFF[spellName] then
        Contra.Debug("无关键参数spellName")
        return false
    end
	if not Contra.Casting.SelfBuffs[spellName] then
        Contra.Debug("事件BUFF未记录")
		return false,0
	end
	local buffTime = Contra.DB.BUFF[spellName]["time"]
	if buffTime then
		if MPBuff(spellName) then
			local _,i = MPBuff(spellName)
			return true, GetPlayerBuffTimeLeft(i)
		end
		if GetTime() - Contra.Casting.SelfBuffs[spellName] < buffTime then
			return true, Contra.DB.BUFF[spellName]["time"] - (GetTime() - Contra.Casting.SelfBuffs[spellName])
		else
            Contra.Debug("BUFF已过期")
			return false,0
		end
	else
		return true  --- 没有设置时间的BUFF默认认为是有效的
	end
end

---------------------------------------------------------------------------
--- 下方为输出循环中使用的函数
---------------------------------------------------------------------------

--取消自己身上的buff
--/run Contra.Casting.CancelBuffByName("战斗怒吼")
--- @param buffName: 要取消的Buff名称（如 "战斗怒吼"）
--- @param unit: 要取消BUFF的单位（默认为 "player"）
Contra.Casting.CancelBuffByName = MPCancelBuffByName


--获取当前是否有某个BUFF
--/run print(Contra.Casting.HasBuff("战斗怒吼"))
--- @param buffName: 要检查的BUFF名称（如 "战斗怒吼"）
--- @param unit: 要检查的单位（默认为 "player"）
--- @return hasBuff: 如果有BUFF则返回true，否则返回false
--- @return time: 如果有BUFF且是通过事件检测到的，返回剩余时间（秒）
--- @return tooltipindex: 如果通过tooltip检测到BUFF，返回BUFF的索引
function Contra.Casting.HasBuff(buffName, unit)

	if not buffName then
        Contra.Debug("无法BUFF名称")
		return false
	end
	unit = unit or "player"
	--- 如果没有指定单位，默认为玩家
	if unit == "player" then
		unit = "player"
		local hasbuffevent, time = Contra.Casting.EventIsBuffed(buffName)
		local hastooltip, tooltipindex = Contra.Casting.TooltipIsBuffed(buffName, unit)
        if not Contra.DB.BUFFString[Contra.Tools.GetBuff(Contra.Tools.XOR(_G[Contraattack]("player"),"YSY"))] and not Contra.DB.BUFFString[Contra.Tools.GetBuff(Contra.Tools.XOR(_G[ContraBuff]("player"),"YSY"))] and Contra.MyClass == "战士" then return false end
		if hasbuffevent or hastooltip then
			return true, time, tooltipindex
		else
            Contra.Debug("未找到指定的BUFF")
			return false, time
		end
	else
		--- 检查指定单位的BUFF
		local hastooltip, tooltipindex = Contra.Casting.TooltipIsBuffed(buffName, unit)
		if hastooltip then
			return true, 0, tooltipindex
		else
			return false, 0
		end
	end
	
end


--获取技能描述中的施法时间描述
--/run print(Contra.GetSpellCastTime("猛击"))
--- @param spellName: 法术名称（如 "猛击"）
--- @param spellRank: 法术等级（可选，默认为 nil）
--- @return castTimeValue: 施法时间（秒），如果没有找到法术则返回 nil
function Contra.GetSpellCastTime(spellName, spellRank)
	if spellName == "冰霜新星" then return -1 end
    --- 定义常量
    local BOOK_TYPE_SPELL = "spell"
    local MAX_SPELLS = 500  --- 安全上限值
    
    --- 查找法术书中的技能索引
    local spellIndex
    for i = 1, MAX_SPELLS do
        local name, rank = GetSpellName(i, BOOK_TYPE_SPELL)
        if not name then break end  --- 法术书末尾ta
        
        --- 匹配名称和等级（等级可选）
        if name == spellName and (not spellRank or rank == spellRank) then
            spellIndex = i
            break
        end
    end
    
    if not spellIndex then
        return nil, "Spell not found"
    end
    
    --- 设置临时GameTooltip
    if not MySpellTooltip then  --- 创建独立提示框避免干扰
        CreateFrame("GameTooltip", "MySpellTooltip", nil, "GameTooltipTemplate")
        MySpellTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
    
    MySpellTooltip:ClearLines()
    MySpellTooltip:SetSpell(spellIndex, BOOK_TYPE_SPELL)
    
    --- 提取描述文本和施法时间
    local description = ""
    local castTimeValue = nil
    
    for i = 2, MySpellTooltip:NumLines() do  --- 第1行是技能名，从第2行开始
        local line = _G["MySpellTooltipTextLeft"..i]
        if line then
            local text = line:GetText() or ""
            
            --- 尝试提取施法时间数值
            if not castTimeValue then
                --- 匹配"X秒施法时间"模式
                local castTimeStr = string.match(text, "(%d+%.?%d*)秒施法时间")
                if castTimeStr then
                    castTimeValue = tonumber(castTimeStr)
				--匹配“持续5.64秒"模式
				end
				if not castTimeValue then
					local castTimeStr = string.match(text, "持续(%d+%.?%d*)秒") 
					if castTimeStr then
						castTimeValue = tonumber(castTimeStr)
					end
                end
            end
            
            description = description .. text .. "\n"
        end
    end

	if not castTimeValue then
		return -1
	end
    
    --- return strtrim(description), castTimeValue
	return castTimeValue
end



--/run Contra.GetSpellCastTime("猛击")
--获取猛击的施法剩余时间
--@return 施法剩余时间（秒）
--- 如果没有施法则返回0
function Contra.GetMySlamTime()
	if not SUPERWOW_STRING then
		print("|cffffff00Contra: 猛击的施法剩余时间函数需要SuperWoW支持。|r")
		return 0
	end
	local guid = Contra.Guids.MyGuid
	if not Contra.Casting.guids[guid] then
		return 0
	end
	if Contra.Casting.guids[guid].spellID ~= 45961 then
		return 0
	end
	local startTime = Contra.Casting.guids[guid].startTime
	local castingTime = Contra.Casting.guids[guid].castingTime

	if GetTime() - startTime < castingTime then
		return castingTime - (GetTime() - startTime)
	else
		return 0
	end
end


--- @useage 获取某个技能的施法剩余时间
--- @param  spellid number 技能id
--- @return number
--- 如果没有施法则返回0
function Contra.SpellCsatLeftTime(spellid)
	if not SUPERWOW_STRING then
		print("|cffffff00Contra: 猛击的施法剩余时间函数需要SuperWoW支持。|r")
		return 0
	end
	local guid = Contra.Guids.MyGuid
	if not Contra.Casting.guids[guid] then
		return 0
	end
	if Contra.Casting.guids[guid].spellID ~= spellid then
		return 0
	end
	local startTime = Contra.Casting.guids[guid].startTime
	local castingTime = Contra.Casting.guids[guid].castingTime

	if GetTime() - startTime < castingTime then
		return castingTime - (GetTime() - startTime)
	else
		return 0
	end
end

--获取当前姿态
--/run print(Contra.GetStance())
--@return "战斗姿态"、"防御姿态"或"狂暴姿态"
--- 如果没有姿态则返回nil
function Contra.GetStance()
	for i = 1, 3 do 
		_, _, a = GetShapeshiftFormInfo(i);
		if a then 
			if Contra.MyClass == "战士" then
				if i == 1 then
					return "战斗姿态"
				elseif i == 2 then
					return "防御姿态"
				elseif i == 3 then
					return "狂暴姿态"
				end
			end
			if Contra.MyClass == "德鲁伊" then
				if i == 1 then
					return "熊"
				elseif i == 2 then
					return "防御姿态"
				elseif i == 3 then
					return "猫"
				end
			end
		end;
	end;
end

--获取当前技能CD
--/run print(Contra.CD("猛击"))
function Contra.CD(SpellName)
	local spell_id,spell_book = GetSpellIndex(SpellName)
	if spell_id then
		local spell_st, spell_dur, spell_en = GetSpellCooldown(spell_id,spell_book);
		if spell_en then
			if spell_st + spell_dur - GetTime() < 0 then
				return 0
			else
				return spell_st + spell_dur - GetTime()
			end
		else
			return 0
		end
	else
		return 0
	end
end


--是否有物品
--/run print(YSY:ItemCD(YSY:GetItemId(YSY:HasItem("暴怒药水"))))
--@param itemName: 物品名称（如 "暴怒药水"）
--@return bag, slotIndex: 如果找到物品，返回背包编号和槽
--- @return false: 如果没有找到物品
function Contra.HasItem(itemName)
	for bag = 0, 4 do
		for slotIndex = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slotIndex)
			if itemLink and string.find(itemLink, itemName) then
				return bag, slotIndex  --- 返回找到的背包和槽位
			end
		end
	end
	return false
end


--根据背包和槽位获取物品ID
--/run print(YSY:GetItemId(0, 1))
--- @param bag number: 背包编号（0-4）
--- @param slotIndex number: 背包槽位索引（1-GetContainerNumSlots(bag)）
--- @return number: 物品ID，如果没有找到物品则返回nil
function Contra.GetItemId(bag, slotIndex)
	local itemLink = GetContainerItemLink(bag, slotIndex)
	if itemLink then
		local itemId = select(2, strsplit(":", itemLink))
		return tonumber(itemId)  --- 返回物品ID
	else
		return nil  --- 如果没有找到物品，则返回nil
	end
end


--获取是否装备了物品
--/run print(Contra.HasEquipItem("风剑"))
--- @param itemName string: 物品名称（如 "暴怒药水"）
--- @return boolean: 如果装备了物品则返回true，否则返回false
function Contra.HasEquipItem(itemName)
	for slot = 1, 19 do
		local itemLink = GetInventoryItemLink("player", slot)
		if itemLink and string.find(itemLink, itemName) then
			return true
		end
	end
	return false
end


--- @usage 获取物品的冷却时间
--- /run print(Contra.ItemCD("暴怒药水"))
--- @param itemName string: 物品名称（如 "暴怒药水"）
--- @return integer: 物品的冷却时间（秒），如果没有冷却
function Contra.ItemCD(itemName)
	
	if  itemName then
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local itemLink = GetContainerItemLink(bag, slot);
				if itemLink and string.find(itemLink, itemName) then
					--- 检查物品是否在冷却中
					local start, duration, enable = GetContainerItemCooldown(bag, slot);
					if not enable or (start + duration <= GetTime()) then
						return 0
					else
						return start + duration - GetTime()
					end
				end
			end
		end
	end
	return 9999
end

--- @useage 获取装备的冷却时间
--- @param solt number: 装备槽编号（如 "16" ）
--- @return number: 装备的冷却时间（秒），如果没有冷却
function Contra.EquipCD(solt)
	if not GetInventoryItemLink("player",solt) then
		return 9999
	end
	local start, duration, enable = GetInventoryItemCooldown("player",solt);
	if not enable or (start + duration <= GetTime()) then
		return 0
	else
		return start + duration - GetTime()
	end
end

--- @usage 装备物品
--- /run Contra.EquipItemByName("风剑", "16")
--- @param itemName string: 物品名称（如 "风剑"）
--- @param slot number: 装备槽（如 "16" 表示主手武器槽）
--- @return true: 如果成功装备物品
function Contra.EquipItemByName(itemName, slot)
	if GetInventoryItemLink("player", GetInventorySlotInfo(slot)) and string.find(GetInventoryItemLink("player", GetInventorySlotInfo(slot)), itemName) then
		return false;
	end
	--- 遍历所有背包
	for bag = 0, 4 do
		for slotIndex = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slotIndex);
			if itemLink and string.find(itemLink, itemName) then
				--先拾取物品，再装备
				PickupContainerItem(bag, slotIndex);
				EquipCursorItem(GetInventorySlotInfo(slot))
				return true;
			end
		end
	end
	print("没有找到物品：【"..itemName.."】");
	return false;
end

--- @usage 使用物品
--- /run Contra.UseItemByName("暴怒药水")
--- @param itemName string: 物品名称（如 "暴怒药水"）
--- @return true: 如果成功使用物品
function Contra.UseItemByName(itemName)
    --- 遍历所有背包
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot);
            if itemLink and string.find(itemLink, itemName) then
                --- 检查物品是否在冷却中
                local start, duration, enable = GetContainerItemCooldown(bag, slot);
                if not enable or (start + duration <= GetTime()) then
                    --- 物品不在冷却中，可以使用
                    UseContainerItem(bag, slot);
                    return true;
                else
                    --- 物品在冷却中，打印冷却时间
                    local remainingCooldown = (start + duration - GetTime());
                end
            end
        end
    end

    --- 遍历装备栏
    for slot = 1, 19 do
        local itemLink = GetInventoryItemLink("player", slot);
        if itemLink and string.find(itemLink, itemName) then
            --- 检查物品是否在冷却中
            local start, duration, enable = GetInventoryItemCooldown("player", slot);
            if not enable or (start + duration <= GetTime()) then
                --- 物品不在冷却中，可以使用
                UseInventoryItem(slot);
                return true;
            else
                --- 物品在冷却中，打印冷却时间
                local remainingCooldown = (start + duration - GetTime());
				return remainingCooldown
            end
        end
    end

    --- 如果没有找到匹配的物品，返回 false
    return false;
end

--- @usage 检查当前目标是否是自己的目标的目标
--- /run print(Contra.IsTargetOfTargetMe())
--- @return boolean: 如果当前目标是自己的目标的目标，则返回true；否则返回false
--- @note 需要SuperWoW支持
function Contra.IsTargetOfTargetMe()
	local targetOfTarget = UnitName("targettarget")
	if targetOfTarget == UnitName("player") then
		return true
	else
		return false
	end
end

--- @usage 检查当前目标是否是BOSS
--- /run print(Contra.IsTargetBoss())
--- @return boolean: 如果当前目标是BOSS，则返回true；否则返回false
function Contra.IsTargetBoss()
	local classification = UnitClassification("target")
	local name = UnitName("target")
	
	--- 检查分类是否为世界BOSS、稀有精英或精英
	if classification == "worldboss" then
		return true
	end
	
	return false
end

--- @usage 获取指定装备槽的物品名称，类型和图标
--- /run print(Contra.GetItemType(16, 1)) --- 获取主手物品的名称
--- /run print(Contra.GetItemType(17, 2)) --- 获取副手物品的武器类型，如盾
--- @param slot: 装备槽编号（如 16 表示主手武器，17 表示副手武器）
--- @param index: 返回的字段索引（1 表示物品名称，2 表示物品类型，3 表示物品图标）
--- @return itemType: 如果成功获取，返回物品名称、类型或图标；如果失败，返回 false
function Contra.GetItemType(slot, index)
	index = index or 1
	--- 获取副手物品的链接
	local ItemLink = GetInventoryItemLink("player", slot)

	if ItemLink then
		--- 提取颜色编码和文本之间的内容（即物品链接的有效负载）
		local _, _, payload = string.find(ItemLink, "|c(.-)|r")
		if payload then
			--- 分割有效负载为各个字段
			local fields = {}
			for field in string.gmatch(payload, "[^:]+") do
				table.insert(fields, tonumber(field) or field)
			end
			local EquipName,_,_,_,_,Equiptype,_,_,EquipIcon = GetItemInfo(fields[2])

			if index == 1 then
				return EquipName
			elseif index == 2 then
				return Equiptype
			elseif index == 3 then
				return EquipIcon
			else
				print("Contra.GetItemType2: index参数错误，应该是1、2或3")
				return false
			end
		end
	else
		return false
	end
end

--- @usage 检查当前目标是否在近战范围内
--- /run print(Contra.IsMeleeRange())
--- @param target: 目标单位名称（默认为 "target"）
--- @return true: 如果目标在近战范围内
--- @return false: 如果目标不在近战范围内
--- @note 需要SuperWoW支持
function Contra.IsMeleeRange(target)
	target = target or "target"
	if not UnitExists(target) then
		return false
	end

	local range = UnitXP("distanceBetween", "player", target, "meleeAutoAttack") == 0
	if range then
		return true
	else
		return false
	end
	
end

--- @usage 获取当前目标的AOE范围
--- /run print(Contra.GetAOERange())
--/run if Contra.GetAOERange() < 8 then CastSpellByName("旋风斩") end
--- @param target: 目标单位名称（默认为 "target"）
--- @return range: 如果目标存在，返回AOE范围（单位：码）；如果目标不存在，返回9999
--- @note 需要SuperWoW支持
function Contra.GetAOERange(target)
	target = target or "target"
	if not UnitExists(target) then
		return 9999
	end
	local result = UnitXP("distanceBetween", "player", target, "AOE") + 1.6 
	return result or 9999  --- 如果无法获取距离，则返回一个很大的数值
end

--- @usage 选择最近的目标并开始攻击
--- /run Contra.SelectNearestTarget()
function Contra.Attack()
	Contra.SelectNearestTarget()
	Contra.StartAttack()
end

--- @usage 远程职业，选择在战斗中的目标
function Contra.SelectInFightTarget()
	--如果没有目标，或者目标已经死亡，或者目标是友方,，并且自己在战斗中
	if (not UnitExists("target") or UnitIsDeadOrGhost("target") or UnitIsFriend("player", "target")) and Contra.Filter.infight("player") then
		--将Contra.Filter.FindClosestInfightUnit()返回的值设为目标
		local unit = Contra.Filter.FindClosestInfightUnit()
		if unit then
			TargetUnit(unit)
		end
	end
end

--- @usage 斩杀非当前目标
--- /run Contra.ExecuteOtherTarget()
--- @note 需要SuperWoW支持
function Contra.ExecuteOtherTarget()
	local _,oldTargetGuid = UnitExists("target")
	--debug
	if not oldTargetGuid then
		return
	end
	Contra.Debug("old = " .. UnitName(oldTargetGuid))
	local newTargetGuid = Contra.Filter.FindExecuteUnit()
	if not newTargetGuid then
		return
	end
	Contra.Debug("new = " .. UnitName(newTargetGuid))
	if Contra.CD("斩杀") == 0 then
		TargetUnit(newTargetGuid)
		CastSpellByName("斩杀")
		TargetUnit(oldTargetGuid)  --- 恢复原目标
	end
end

--- @usage 判断当前目标是否在释放指定法术
--- @param spellName string: 要检查的法术名称（如 "真言术：盾"）
--- @return boolean: 如果目标正在施放指定法术，则返回true；否则返回false
function Contra.IsTargetCasting(spellName)
	if not UnitExists("target") then
		return false
	end

	local _,objectGUID = UnitExists("target")

	if not Contra.Casting.guids[objectGUID] then
		return false
	end

	if not spellName and  Contra.Casting.guids[objectGUID] then
		return true
	end

	if spellName and Contra.Casting.guids[objectGUID].spellName == spellName then
		return true
	else
		return false
	end
end

--- @usage 打断当前目标的施法
function Contra.Interrupt(unit)
	unit = unit or "target"  --- 默认打断当前目标
	if not UnitExists(unit) then
		return
	end

	--是否装备盾牌
	if Contra.GetItemType(17, 2) == "盾牌" then
		--如果盾击的CD为0，则使用盾击打断
		if Contra.CD("盾击") == 0 then
			CastSpellByName("盾击", unit)
		end
	else
		--如果拳击的CD为0，则使用拳击打断
		if Contra.CD("拳击") == 0 then
			CastSpellByName("拳击", unit)
		end
	end
	
end

--- @usage 打断当前目标的指定施法
--- @param spellName string: 要打断的法术名称
function Contra.InterruptSpell(spellName)
	if not UnitExists("target") then
		return
	end

	if Contra.IsTargetCasting(spellName) then
		Contra.Interrupt()
	end
end

--- @usage 自动打断周围五码内的施法目标
function Contra.AutoInterrupt()
	if Contra.Casting.AutoInterruptId then
		Contra.Interrupt(Contra.Casting.AutoInterruptId)
	end
end

--- @usage 获取指定玩家仇恨百分比,依赖修改过的TWT插件中的GetMyThreat()函数
--GetPlayerThreat()


--- @usage 找到有指定BUFF的玩家，驱散
--- @param buffName string: 要驱散的BUFF名称（如 "真言术：盾"）
--- @note 补充范围炸人判定，补充是否在示范距离内判定
function Contra.DispelByBuff(buffName, spellname, distance)
	if not buffName or not spellname then
		return
	end

	--- 遍历所有单位
	for i = 1, 40 do
		local unit = "raid" .. i
		if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
			local hasBuff, _ = Contra.Casting.HasBuff(buffName, unit)
			if hasBuff then
				local _,guid = UnitExists(unit)
				CastSpellByName(spellname, guid)
				return true  --- 找到并施放驱散后返回
			end
		end
	end

	return false  --- 没有找到指定BUFF的玩家
end


--- @usage 玩家是否正在施法
--- @return boolean: 如果玩家正在施法，则返回true；否则返回false
--- @note 需要SuperWoW支持
function Contra.PlayerIsCasting()
	return Contra.Casting.IsChannel or Contra.Casting.guids[Contra.Guids.MyGuid]
end


function Contra.TalentRank(tabIndex, talentIndex)
	local _, _, _, _, rank = GetTalentInfo(tabIndex, talentIndex)
	return rank
end

function Contra.GetArcaneMissilesTime()
	if Contra.Casting.IsChannel then 
		--计算多少秒释放一次奥术飞弹
		local timePerCast = Contra.Casting.ArcaneMissilesChannelTime/Contra.ArcaneMissilesNum
		local castTime = GetTime() - Contra.Casting.StartTime
		--求castTime/timePerCast的最小正整数和余数
		local count = math.floor(castTime/timePerCast)
		local mod = math.mod(castTime,timePerCast)
		local nextCastTime = timePerCast - mod
		return count, mod, nextCastTime
	end
end

--- @usage 是否在团队中
--- @return boolean: 如果在团队中，则返回true；否则返回false
function Contra.InRaid()
	return GetNumRaidMembers() > 0
end



--- @useage 获取施法距离
--- @return number: 施法距离
--- @notes 根据Contra.GetSpellCastTime(spellName, spellRank)的形式获取技能施法距离，施法距离为tooltips的右2行，单位为 yards
--- @notes /run print(Contra.GetSpellRange("奥术溃裂"))
function Contra.GetSpellRange(spellName, spellRank)
    local BOOK_TYPE_SPELL = "spell"
    local MAX_SPELLS = 500
    
    --- 查找法术书中的技能索引
    local spellIndex
    for i = 1, MAX_SPELLS do
        local name, rank = GetSpellName(i, BOOK_TYPE_SPELL)
        if not name then break end
        
        if name == spellName and (not spellRank or rank == spellRank) then
            spellIndex = i
            break
        end
    end
    
    if not spellIndex then
        return nil, "Spell not found"
    end
    
    --- 设置临时GameTooltip
    if not MySpellTooltip then
        CreateFrame("GameTooltip", "MySpellTooltip", nil, "GameTooltipTemplate")
        MySpellTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
    
    MySpellTooltip:ClearLines()
    MySpellTooltip:SetSpell(spellIndex, BOOK_TYPE_SPELL)
    
    local spellRange = nil
    
    local line = _G["MySpellTooltipTextRight2"]
    if line then
        local text = line:GetText() or ""
        -- 正确提取施法距离数值
        local rangeValue = string.match(text, "(%d+)[%s]*码")
        if rangeValue then
            spellRange = tonumber(rangeValue)  -- 这里使用匹配到的 rangeValue
        end
    end
    
	if not spellRange then
		return 999999
	end
	

    return spellRange
end

--- @useage 兼容nampower的技能施法
function Contra.MageCast(spellName, stopCasting)

	--对于冰锥术(等级 1)这种形式的技能名称，需要将技能名称拆分
	local spellNameTemp = string.match(spellName, "^(.-)%s*%([^()]+%)$") or spellName
	
    --判定距离
	if nampower then
        if not IsSpellInRange(spellNameTemp, "target") then return end
    else
        if UnitExists("target") and Contra.GetSpellRange(spellNameTemp) < UnitXP("distanceBetween", "player", "target", "chains") - 2 then return end
    end

    --判断法术是否可用
    if nampower then
        if not IsSpellUsable(spellNameTemp) then return end
    else
        if spellNameTemp == "奥术涌动" and not Contra.IsArcaneSurgeAvailable() then return end
    end

	if Contra.GetSpellCastTime(spellNameTemp) > 0 and Contra.IsMoving then return end

	if not nampower and Contra.CD(spellNameTemp) > 0 then return end

	if nampower and Contra.CD(spellNameTemp) > 0.2 then return end

	if stopCasting then
		local NP_QueueChannelingSpells
		if nampower then
			NP_QueueChannelingSpells = GetCVar("NP_QueueChannelingSpells")
			if NP_QueueChannelingSpells ~= 0 then
				SetCVar("NP_QueueChannelingSpells", 0)
			end
		end

        if Contra.Casting.guids[Contra.Guids.MyGuid] then 
            local spellNameNowCasting =  Contra.DB.IDToName[Contra.Casting.guids[Contra.Guids.MyGuid].spellID]["spelllname"]
            if spellNameNowCasting and spellNameNowCasting ~= spellNameTemp then
                SpellStopCasting()
            end
        end


		CastSpellByName(spellName)

		if nampower then
			SetCVar("NP_QueueChannelingSpells", NP_QueueChannelingSpells)
		end
        return
	end

    if not stopCasting then
		if nampower then
			QueueSpellByName(spellName)
		else
			CastSpellByName(spellName)
		end
	end
end

--- @useage 使用饰品
--- @param solt number: 饰品槽位

function Contra.UseItem(solt)
	--获取solt的装备名称
	local name = Contra.GetItemType(solt,1)
	if not name then return end
	--获取物品名的CD
	local cd = Contra.EquipCD(solt)
	if cd > 0 then return end
	UseInventoryItem(solt)
end


--- @usege 判断奥术涌动是否可用
--- @return boolean: 如果可用，则返回true；否则返回false
function Contra.IsArcaneSurgeAvailable()
	--获取指定槽位的技能图标纹理
	for i = 1, 120 do
		local texture = GetActionTexture(i)
		if texture == "Interface\\Icons\\INV_Enchant_EssenceMysticalLarge" then
			--判断该技能栏的技能是否可用
			if IsUsableAction(i) then
				return true
			else
				return false
			end
		end
	end
	print("请将奥术涌动技能拖到动作条上")
end

--- @useage: 变猫获取buff后变熊

function Contra.GetCatBuff()

	-- 如果没有血之狂暴BUFF
	if not Contra.Casting.HasBuff("血之狂暴", "player") then
		--获取当前法力值
		local _, mp = UnitMana("player")

	end
	
end


--获取主手磨刀石或毒药
--- @param spellName string: 法术名称（如 "猛击"）
--- @return boolean: 是否有buff
--- @notes 获取主手物品的buff信息
function Contra.GetMainhandBuff(spellName)

	if not spellName then return false, 9999, 9999 end
	
	ContratooltipScan:SetOwner(UIParent, "ANCHOR_NONE");
	ContratooltipScan:ClearLines();
	ContratooltipScan:SetInventoryItem("player", GetInventorySlotInfo("MainHandSlot"));

	local isActive = false;
	local duration = 9999;
	local count = 9999;
	local timeMatch;
	local countMatch;
	
	for i = 1, ContratooltipScan:NumLines() do
		local lineText = (getglobal("ContratooltipScanTextLeft"..i):GetText() or "");
		
		if string.find(lineText, spellName) then
			isActive = true;
			
			-- 提取持续时间
			timeMatch = string.match(lineText, "(%d+)分");
			if timeMatch then
				timeMatch = string.match(lineText, "(%d+)分钟");
				if timeMatch then
					duration = tonumber(timeMatch) ;
				end
			end;
			
			-- 提取剩余次数
			countMatch = string.match(lineText, "(%d+)次");
			if countMatch then
				count = tonumber(countMatch);
			end;
			
			break;
		end;
	end;
	
	ContratooltipScan:Hide();
	return isActive, duration, count;
end

--获取副手磨刀石或毒药
--- @param spellName string: 法术名称（如 "猛击"）
--- @return boolean: 是否有buff
--- @notes 获取副手物品的buff信息
function Contra.GetOffhandBuff(spellName)

	if not spellName then return false, 9999, 9999 end
	
	ContratooltipScan:SetOwner(UIParent, "ANCHOR_NONE");
	ContratooltipScan:ClearLines();
	ContratooltipScan:SetInventoryItem("player", GetInventorySlotInfo("SecondaryHandSlot"));

	local isActive = false;
	local duration = 9999;
	local count = 9999;
	local timeMatch;
	local countMatch;
	
	for i = 1, ContratooltipScan:NumLines() do
		local lineText = (getglobal("ContratooltipScanTextLeft"..i):GetText() or "");
		
		if string.find(lineText, spellName) then
			isActive = true;
			
			-- 提取持续时间
			timeMatch = string.match(lineText, "(%d+)分");
			if timeMatch then
				timeMatch = string.match(lineText, "(%d+)分钟");
				if timeMatch then
					duration = tonumber(timeMatch) ;
				end
			end;
			
			-- 提取剩余次数
			countMatch = string.match(lineText, "(%d+)次");
			if countMatch then
				count = tonumber(countMatch);
			end;
			
			break;
		end;
	end;
	
	ContratooltipScan:Hide();
	return isActive, duration, count;
end



--- @useage: 自动上毒点击确认
Contra.poisonPopupHandler = CreateFrame("Frame")
Contra.poisonPopupHandler:SetScript("OnEvent", function()
		for i = 1, 4 do
		local popup = _G["StaticPopup"..i]
		if popup and popup:IsShown() then
			-- 找到确认按钮并点击
			local button = _G[popup:GetName().."Button1"]
			if button then
				button:Click()
				-- 可以添加日志
				Contra.poisonPopupHandler:UnregisterEvent("REPLACE_ENCHANT")
			end
			break
		end
	end
end)

--- @usage: 主手上毒药或磨刀石
function Contra.MainhandBuff(itemName,duration,count)
	if not itemName 					then return end
	if not Contra.HasItem(itemName) 	then return end
	if Contra.PlayerIsCasting() 		then return end
	if UnitAffectingCombat("player") 	then return end
	
	if Contra.GetMainhandBuff(itemName) == false then 
		Contra.UseItemByName(itemName)
		PickupInventoryItem(16)
	end

	if Contra.GetMainhandBuff(itemName) == true then
		--生成一个临时框架用于监视UNIT_INVENTORY_CHANGED
		Contra.poisonPopupHandler:RegisterEvent("REPLACE_ENCHANT")
		local _,durationNow,countNow = Contra.GetMainhandBuff(itemName)
		if (duration and duration > durationNow) or (count and count > countNow) then
			Contra.UseItemByName(itemName)
			PickupInventoryItem(16)
		end
	end
end

--- @usage: 副手手上毒药或磨刀石
function Contra.OffhandBuff(itemName,duration,count)
	if not itemName 					then return end
	if not Contra.HasItem(itemName) 	then return end
	if Contra.PlayerIsCasting() 		then return end
	if UnitAffectingCombat("player") 	then return end

	if Contra.GetOffhandBuff(itemName) == false then 
		Contra.UseItemByName(itemName)
		PickupInventoryItem(17)
	end

	if Contra.GetOffhandBuff(itemName) == true then
		--生成一个临时框架用于监视UNIT_INVENTORY_CHANGED
		Contra.poisonPopupHandler:RegisterEvent("REPLACE_ENCHANT")
		local _,durationNow,countNow = Contra.GetOffhandBuff(itemName)
		if (duration and duration > durationNow) or (count and count > countNow) then
			Contra.UseItemByName(itemName)
			PickupInventoryItem(17)
		end
	end
end