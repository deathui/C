Contra.Filter = {}


--[[------------------------------------------------------------------------
  Contra插件 - 单位过滤系统
  版本: 1.0
  作者: Contra团队
  描述: 提供各种单位过滤函数，用于筛选满足特定条件的游戏单位
  注意: 本模块依赖SuperWoW API支持
------------------------------------------------------------------------]]

------------------------------------------------
---- 单体过滤器 - 基础条件判断
------------------------------------------------


--- @usage 判断单位是否可以被玩家攻击
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位可以被攻击则返回true，否则返回false
Contra.Filter.Attackable = function(unit)
	return UnitCanAttack("player", unit) and true or false
end

--- @usage 判断单位是否正在战斗中
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位正在战斗中则返回true，否则返回false
Contra.Filter.infight = function(unit)
	return UnitAffectingCombat(unit) and true or false
end

--- @usage 判断单位是否存活
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位存活则返回true，否则返回false
Contra.Filter.alive = function(unit)
	return not UnitIsDead(unit) and true or false
end

--- @usage 判断单位是否在玩家的近战攻击范围内
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位在近战范围内则返回true，否则返回false
--- @note 依赖SuperWoW的UnitXP扩展函数
Contra.Filter.rangeFive = function(unit)
	return UnitXP("distanceBetween", "player", unit, "meleeAutoAttack") == 0 and true or false
end

--- @usage 判断目标指向的单位和指定单位的距离是否在5码内
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位在近战范围内则返回true，否则返回false
--- @note 依赖SuperWoW的UnitXP扩展函数
Contra.Filter.BlizzardFive = function(unit)
	if not UnitExists("mouseover") then return false end
	local _,mouseoverUnit = UnitExists("mouseover")
	return UnitXP("distanceBetween", mouseoverUnit, unit, "AOE") < 5.2  and true or false
end

--- @usage 判断单位是否在8码范围内（用于旋风斩等AOE技能）
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位在8码范围内则返回true，否则返回false
--- @note 依赖SuperWoW的UnitXP扩展函数，+1.6是为了增加判断余量
Contra.Filter.rangeEight = function(unit)
	return UnitXP("distanceBetween", "player", unit, "AOE") + 1.6 <= 8 and true or false
end

--- @usage 判断单位是否在10码范围内（用于奥术爆炸等AOE技能）
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位在10码范围内则返回true，否则返回false
--- @note 依赖SuperWoW的UnitXP扩展函数，+1.6是为了增加判断余量
Contra.Filter.rangeTen = function(unit)
	return UnitXP("distanceBetween", "player", unit, "AOE") + 1.6 <= 10 and true or false
end

--- @usage 判断单位是否在12码范围内（用于奥术爆炸等AOE技能）
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位在12码范围内则返回true，否则返回false
--- @note 依赖SuperWoW的UnitXP扩展函数，+1.6是为了增加判断余量
Contra.Filter.rangeTwelve = function(unit)
	return UnitXP("distanceBetween", "player", unit, "AOE") + 1.6 <= 12 and true or false
end

--- @usage 判断单位是否在30码范围内
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位在30码范围内则返回true，否则返回false
--- @note 依赖SuperWoW的UnitXP扩展函数，+1.6是为了增加判断余量
Contra.Filter.rangeThirty = function(unit)
	if not UnitExists(unit) then                                                                                                   
		return false
	end
	return UnitXP("distanceBetween", "player", unit, "chains") + 1.6 <= 30 and true or false
end

--- @usage 判断单位是否不在玩家的背后
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位不在玩家背后则返回true，否则返回false
--- @note 依赖SuperWoW的UnitXP扩展函数
Contra.Filter.behindPlayer = function(unit)
	return not UnitXP("behind", unit, "player")
end

--- @usage 判断目标的血量百分比是否小于20%（可斩杀状态）
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位血量低于20%则返回true，否则返回false
Contra.Filter.Execute = function(unit)
	return UnitExists(unit) and UnitHealth(unit) > 0 and (UnitHealth(unit) / UnitHealthMax(unit)) < 0.2 and true or false
end

--- @usage 判断单位是否处于适宜被攻击的状态（没有受到控制效果）
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位适宜被攻击则返回true，否则返回false
--- @note 检查单位是否受到变形术、放逐术、休眠、束缚亡灵、冰冻陷阱、闷棍或致盲等控制效果
Contra.Filter.CanAttack = function(unit)
	if Contra.Casting.HasBuff("变形术", unit) or Contra.Casting.HasBuff("放逐术", unit) or Contra.Casting.HasBuff("休眠", unit) or Contra.Casting.HasBuff("束缚亡灵", unit) or Contra.Casting.HasBuff("冰冻陷阱", unit) or Contra.Casting.HasBuff("闷棍", unit) or Contra.Casting.HasBuff("致盲", unit) then
		return false
	end
	return true
end

--- @usage 判断单位是否没有被放逐术影响
--- @param unit string: 要检查的单位（GUID或单位标识符如 "target"）
--- @return boolean: 如果单位没有被放逐术影响则返回true，否则返回false
Contra.Filter.NoFangzhu = function (unit)
	if Contra.Casting.HasBuff("放逐术", unit) then
		return false
	end
	return true
end



------------------------------------------------
---- 单体过滤器使用函数
------------------------------------------------

--- @usage 对目标属性进行过滤的核心函数，支持多过滤器组合
--- @param ... function: 传入的过滤器函数，可以传入一个或多个
--- @return table: 返回一个新的表，包含所有通过所有过滤器的GUID及其时间戳
--- @note 该函数使用Lua 5.0兼容的参数处理方式，确保在不同版本的WoW中都能正常工作
Contra.Filter.guidsByFilters = function(...)
    --- 使用Lua 5.0兼容的参数获取方式
    local arg = arg or {}  --- 安全初始化
    local filters = {}
    local n = arg.n or 0   --- 参数个数

	--Contra.Debug("过滤器参数个数: " .. n)
    
    --- 手动复制所有参数
    for i = 1, n do
        filters[i] = arg[i]
    end
    
    local filteredGuids = {}
    
    --- 遍历所有 GUID
    for guid, timestamp in pairs(Contra.Guids.guids) do
        local valid = true
        
        --- 检查该GUID是否通过所有过滤器
        for i, filterFunc in ipairs(filters) do
            --- 只对有效的过滤器进行检查
            if type(filterFunc) == "function" then
                if not filterFunc(guid) then
                    valid = false
                    break
                end
            end
        end
        
        --- 如果通过所有过滤器，添加到新表
        if valid then
            filteredGuids[guid] = timestamp
        end
    end
    
    return filteredGuids
end




------------------------------------------------
---- 表体过滤器，将时间戳或者布尔值替换为操作数值
------------------------------------------------

--- @usage: 根据表中的GUID和其对应的时间戳，生成一个新的表，包含每个单位的GUID和其距离
--- @param unitList: 包含单位GUID和时间戳的列表
--- @return distanceList: 返回一个新的表，包含每个单位的GUID和其距离
Contra.Tools.icc = "Gui"
Contra.Filter.Distance = function(unitList)
	local distanceList = {}
	for guid, timestamp in pairs(unitList) do
		if UnitExists(guid) then
			local distance = UnitXP("distanceBetween", "player", guid)
			if distance then
				distanceList[guid] = distance
			end
		end
	end
	return distanceList
end

--- @usage 根据表中的GUID和其对应的布尔值，生成一个新的表，包含每个单位的GUID和其当前生命值
--- @param unitList table: 包含单位GUID和布尔值（通常表示存活状态）的列表
--- @return table: 返回一个新的表，包含每个单位的GUID和其当前生命值数值
--- @note 只处理存在且存活的单位，确保返回有效的生命值数据
Contra.Filter.Health = function(unitList)
	local healthList = {}
	for guid, isAlive in pairs(unitList) do
		if UnitExists(guid) and isAlive then
			local health = UnitHealth(guid)
			if health then
				healthList[guid] = health
			end
		end
	end
	return healthList
end

--- @usage: 根据表中的GUID和其对应的布尔值，生成一个新的表，包含每个单位的GUID和护甲值
--- @param unitList: 包含单位GUID和布尔值的列表
--- @return armorList: 返回一个新的表，包含每个单位的GUID和其护甲值
Contra.Filter.Armor = function(unitList)
	local armorList = {}
	for guid, isAlive in pairs(unitList) do
		if UnitExists(guid) and isAlive then
			local armor = UnitArmor(guid)
			if armor then
				armorList[guid] = armor
			end
		end
	end
	return armorList
end

------------------------------------------------
---- 表过滤器使用函数，取出其中符合要求的GUID
------------------------------------------------

--- @usage 从单位列表中找出数值最小的单位GUID
--- @param unitList table: 包含单位GUID作为键和数值作为值的列表（通常是距离、生命值、护甲等）
--- @return string|nil: 返回数值最小的GUID，如果列表为空则返回nil
--- @note 常用于查找最近的单位、生命值最低的单位或护甲值最低的单位
Contra.Filter.MinValueGuid = function(unitList)
	local minGuid = nil
	local minValue = math.huge --- 初始化为一个很大的数
	for guid, value in pairs(unitList) do
		if value < minValue then
			minValue = value
			minGuid = guid
		end
	end
	return minGuid
end

--- @usage 从单位列表中找出数值最大的单位GUID
--- @param unitList table: 包含单位GUID作为键和数值作为值的列表（通常是生命值、伤害等）
--- @return string|nil: 返回数值最大的GUID，如果列表为空则返回nil
--- @note 常用于查找生命值最高的单位或优先级最高的目标
Contra.Filter.MaxValueGuid = function(unitList)
	local maxGuid = nil
	local maxValue = -math.huge --- 初始化为一个很小的数
	for guid, value in pairs(unitList) do
		if value > maxValue then
			maxValue = value
			maxGuid = guid
		end
	end
	return maxGuid
end




------------------------------------------------
---- 输出循环中使用的函数
------------------------------------------------

--- @usage 找到可被攻击、存活、位于玩家面前、没有被放逐术影响且距离最小的单位
--- @return string: 返回找到的单位GUID，如果没有找到则返回"player"
--- @note 函数会依次应用多个过滤器条件，确保返回的单位满足所有要求
--- @test 在游戏中可以通过命令行测试：/run print(Contra.Filter.FindClosestAttackableUnit())
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息
Contra.Filter.FindClosestAttackableUnit = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local closestUnit = nil
	local closestDistance = math.huge --- 初始化为一个很大的数

	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.NoFangzhu,
		Contra.Filter.behindPlayer
	)
	--- Contra.Debug("过滤后的单位数量: " .. Contra.Tools.TableCount(templist))

	local distanceList = Contra.Filter.Distance(templist)
	local minGuid = Contra.Filter.MinValueGuid(distanceList)

	--- Contra.Debug("距离最小的单位: " .. (UnitName(minGuid) or "无"))

	if minGuid then
		return minGuid
	else
		return "player"
	end
	
end

--- @usage 找到可被攻击、存活、位于玩家面前、处于战斗中、适宜被攻击、距离在30码内且生命值最多的单位
--- @return string: 返回找到的单位GUID，如果没有找到则返回"player"
--- @note 通常用于选择最具威胁的优先攻击目标
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息和Contra.Tools.TableCount函数
Contra.Filter.FindClosestInfightUnit = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local closestUnit = nil
	local closestDistance = math.huge --- 初始化为一个很大的数

	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.infight,
		Contra.Filter.behindPlayer,
		Contra.Filter.CanAttack,
		Contra.Filter.rangeThirty
	)
	
	if Contra.Tools.TableCount(templist) == 0 then
		return "player"
	end
	
	local healthList = Contra.Filter.Health(templist)
	local maxGuid = Contra.Filter.MaxValueGuid(healthList)

	if maxGuid then
		return maxGuid
	else
		return "player"
	end
	
end

--- @usage 找到可被攻击、存活、位于玩家面前、距离5码内、生命值小于20%且生命值最低的单位
--- @return string|nil: 返回找到的单位GUID，如果没有找到则返回nil
--- @note 主要用于战士等职业的斩杀技能目标选择
--- @test 在游戏中可以通过命令行测试：/run print(Contra.Filter.FindExecuteUnit())
--- @teststatus 测试结果待验证
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息和Contra.Tools.TableCount函数
Contra.Filter.FindExecuteUnit = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.behindPlayer,
		Contra.Filter.rangeFive,
		Contra.Filter.Execute
	)
	
	if Contra.Tools.TableCount(templist) == 0 then
		return nil
	end
	
	local healthList = Contra.Filter.Health(templist)
	local minGuid = Contra.Filter.MinValueGuid(healthList)

	if minGuid then
		return minGuid
	else
		return nil
	end
	
end

--- @usage 计算可被攻击、存活、位于玩家面前且距离8码内的单位数量
--- @return number: 返回符合条件的单位数量（整数），如果没有找到符合条件的单位则返回0
--- @note 常用于判断是否适合使用旋风斩等AOE技能
--- @test 在游戏中可以通过命令行测试：/run print(Contra.Filter.CountAttackableUnitsInRangeEight())
--- @teststatus 测试结果待验证
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息和Contra.Tools.TableCount函数
Contra.Filter.CountAttackableUnitsInRangeEight = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local count = 0

	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.behindPlayer,
		Contra.Filter.rangeEight
	)
	
	count = Contra.Tools.TableCount(templist)
	
	--- Contra.Debug("符合条件的单位数量: " .. count)
	return count
end

--- @usage 计算可被攻击、存活、位于玩家面前且距离5码内的单位数量
--- @return number: 返回符合条件的单位数量（整数），如果没有找到符合条件的单位则返回0
--- @note 常用于判断是否适合使用近战AOE技能或是否需要调整攻击策略
--- @test 在游戏中可以通过命令行测试：/run print(Contra.Filter.CountAttackableUnitsInRangeFive())
--- @teststatus 测试结果待验证
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息和Contra.Tools.TableCount函数
Contra.Filter.CountAttackableUnitsInRangeFive = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local count = 0

	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.behindPlayer,
		Contra.Filter.rangeFive
	)
	
	count = Contra.Tools.TableCount(templist)
	
	--- Contra.Debug("符合条件的单位数量: " .. count)
	return count
end

--- @usage 计算可被攻击、存活且距离10码内的单位数量
--- @return number: 返回符合条件的单位数量（整数），如果没有找到符合条件的单位则返回0
--- @note 主要用于法师等职业判断是否适合施放奥术爆炸等AOE技能
--- @test 在游戏中可以通过命令行测试：/run print(Contra.Filter.CountAttackableUnitsInRangeTen())
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息和Contra.Tools.TableCount函数
Contra.Filter.CountAttackableUnitsInRangeTen = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))

	local count = 0

	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.rangeTen
	)

	count = Contra.Tools.TableCount(templist)

	--- Contra.Debug("符合条件的单位数量: " .. count)
	return count
end

--- @usage 找到可被攻击、存活、位于玩家面前且距离5码内护甲值最低的单位
--- @return string|nil: 返回找到的单位GUID，如果没有找到则返回nil
--- @note 主要用于优先攻击护甲低的单位以造成更高伤害（如法师对布甲目标优先攻击）
--- @test 在游戏中可以通过命令行测试：/run print(Contra.Filter.FindLowestArmorUnit())
--- @teststatus 测试结果待验证
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息、Contra.Tools.TableCount函数和Contra.Filter.Armor函数
Contra.Filter.FindLowestArmorUnit = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.behindPlayer,
		Contra.Filter.rangeFive
	)
	
	if Contra.Tools.TableCount(templist) == 0 then
		return nil
	end
	
	local armorList = Contra.Filter.Armor(templist)
	local minGuid = Contra.Filter.MinValueGuid(armorList)

	if minGuid then
		return minGuid
	else
		return nil
	end
	
end

--- @usage 获取当前在战斗中，可被攻击的单位的血量之和
--- @return number: 返回当前在战斗中，可被攻击的单位的血量之和
--- @note 主要用于判断当前团队的血量是否足够施放AOE技能
--- @test 在游戏中可以通过命令行测试：/run print(Contra.Filter.GetTotalHealthOfAttackableUnits())
--- @teststatus 测试结果待验证
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息和Contra.Tools.TableCount函数
Contra.Filter.GetTotalHealthOfAttackableUnits = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local totalHealth = 0

	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
        Contra.Filter.infight
	)
	
	for guid in pairs(templist) do
		if UnitExists(guid) then
			totalHealth = totalHealth + UnitHealth(guid)
		end
	end

	return totalHealth
end


--- @usage 获取12码内存活、可被攻击的单位的名称列表
--- @return table: 返回一个包含所有符合条件的单位名称的表
--- @note 主要用于判断是否适合使用AOE技能，如奥术爆炸等
--- @test 在游戏中可以通过命令行测试：/run print(Contra.Filter.GetNamesOfAttackableUnitsInRangeTwelve())
--- @teststatus 测试结果待验证
--- @dependencies 依赖Contra.Guids.guids列表存储的敌对单位信息和Contra.Tools.TableCount函数
Contra.Filter.GetNamesOfAttackableUnitsInRangeTwelve = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.rangeTwelve
	)
	
	local nameList = {}
	for guid, _ in pairs(templist) do
		local name, _ = UnitName(guid)
		table.insert(nameList, name)
	end
	if table.getn(nameList) > 0 then
		return nameList
	else
		return niul
	end
	
end

--- @usage 周围存活，可被攻击，且位于目标指向目标5码内的单位的数量
--- @return number: 符合条件的单位数量（整数），如果没有找到符合条件的单位则返回0
--- @note 主要用于判断是否适合使用暴风雪技能
Contra.Filter.CountBlizzardFive = function()
	local unitList = Contra.Guids.guids
	--- Contra.Debug("原始列表中的单位数量: " .. Contra.Tools.TableCount(unitList))
	
	local templist = Contra.Filter.guidsByFilters(
		Contra.Filter.Attackable,
		Contra.Filter.alive,
		Contra.Filter.BlizzardFive
	)
	
	local count = Contra.Tools.TableCount(templist)
	--- Contra.Debug("符合条件的单位数量: " .. count)
	return count
end
