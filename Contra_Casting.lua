---------------------------------------------------------------------------
--- 施法计时及攻击计时
---------------------------------------------------------------------------

Contra.Casting = {}
Contra.Casting.BattleStart = 0
Contra.Casting.BattleEnd = true
Contra.Casting.AoShuFeiDanTime = 0
Contra.Casting.AoShuFeiDanCount = 0
Contra.Casting.SelfBuffs = {}
Contra.Casting.guids = {}
Contra.Casting.AutoInterruptId = nil

Contra.Casting.Frame = CreateFrame("Frame", "ContraCastingFrame", UIParent)

Contra.Casting.Frame:RegisterEvent("UNIT_CASTEVENT")
Contra.Casting.Frame:RegisterEvent("RAW_COMBATLOG")
Contra.Casting.Frame:RegisterEvent("SPELLCAST_CHANNEL_START")
Contra.Casting.Frame:RegisterEvent("SPELLCAST_CHANNEL_UPDATE")
Contra.Casting.Frame:RegisterEvent("SPELLCAST_CHANNEL_STOP")
Contra.Casting.Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
Contra.Casting.Frame:RegisterEvent("PLAYER_REGEN_ENABLED")


Contra.Casting.TestMode = 0
Contra.Casting.TestModeToggle = function()
	if Contra.Casting.TestMode == 0 then
		Contra.Casting.TestMode = 1
		print("|cffffff00Contra: UNIT_CASTEVENT测试模式已开启。|r")
		return
	end
	if Contra.Casting.TestMode == 1 then
		Contra.Casting.TestMode = 2
		print("|cffffff00Contra: RAW_COMBATLOG测试模式已开启。|r")
		return
	end
	if Contra.Casting.TestMode == 2 then
		Contra.Casting.TestMode = 0
		print("|cffffff00Contra: 测试模式已关闭。|r")
		return
	end
end

--事件测试函数
function Contra.Casting.TestEvent()
	if event == "UNIT_CASTEVENT" and Contra.Casting.TestMode == 1 then
		if UnitName("player") == UnitName(arg1) then
			--- print("施法人：" .. UnitName(arg1) .. " 施法目标：" .. UnitName(arg2) .. "施法类型：" .. arg3 .. " 施法ID：" .. arg4 .. " 施法剩余时间：" .. arg5)
			print("---------------------")

			if arg1 then
				print("施法单位：" .. UnitName(arg1) .. " (" .. arg1 .. ")")
			else
				print("施法单位：未知")
			end

			if arg2 and UnitName(arg2) then
				print("施法目标：" .. UnitName(arg2) .. " (" .. arg2 .. ")")
			else
				print("施法目标：未知")
			end

			print("施法类型：" .. arg3)

			print("施法ID：" .. arg4 .. "施法名称：" .. (Contra.DB.IDToName[arg4] and Contra.DB.IDToName[arg4]["spelllname"]) or "未知")

			if arg5 then
				print("施法时间：" .. arg5)
			else
				print("施法时间：未知")
			end

			if arg4 == 25345 then
				Contra.Casting.AoShuFeiDanTime = GetTime()
				Contra.Casting.AoShuFeiDanCount = 0
				print("|cffff0000奥术飞弹开始施法:0秒|r")
			end
			if arg4 == 25346 then
				local time = GetTime() - Contra.Casting.AoShuFeiDanTime
				print("|cffff0000奥术飞弹施法:" .. time .. "秒|r")
				Contra.Casting.AoShuFeiDanCount = Contra.Casting.AoShuFeiDanCount + 1
				print("|cffff0000奥术飞弹施法次数:" .. Contra.Casting.AoShuFeiDanCount .. "|r")
			end
		end

	elseif event == "RAW_COMBATLOG" and Contra.Casting.TestMode == 2 then
		--- print("arg1: " .. arg1 .. " arg2: " .. arg2)
		if arg1 then
			print("---------------------")
			print("事件类型：" .. arg1)
		end
		if arg2 then
			print("事件内容：" .. arg2)
		end
	end
end



--获取施法guid的函数
function Contra.Casting.GetCastingGuid()
	if event == "UNIT_CASTEVENT" then
		if arg3 == "START" or arg3 == "CHANNEL" then
			--根据guid进行记录，记录内容为施法者名称，开始时间，施法ID，施法时间
			Contra.Casting.guids[arg1] = {
				casterName = UnitName(arg1),
				startTime = GetTime(),
				spellID = arg4,
				spellName = (Contra.DB.IDToName[arg4] and Contra.DB.IDToName[arg4]["spelllname"]) or "未知",
				castingTime = arg5,
			}
			--如果目标在近战范围内，并且不在玩家背后，则将guid记录
			if Contra.Filter.rangeFive(arg1) and Contra.Filter.behindPlayer(arg1) and Contra.DB.Interrupt[UnitName(arg1)] and Contra.DB.Interrupt[UnitName(arg1)][Contra.DB.IDToName[arg4]["spelllname"]] then
				Contra.Casting.AutoInterruptId = arg1
				print("自动打断触发！")
			end
		end
	end
end

--移除施法guid的函数
function Contra.Casting.RemoveCastingGuid()
	local objectGUID = nil
	if event == "UNIT_CASTEVENT" then
		if arg3 == "FAIL" or arg3 == "CAST" then
			Contra.Casting.guids[arg1] = nil
			if Contra.Casting.AutoInterruptId == arg1 then
				Contra.Casting.AutoInterruptId = nil
			end
		end
	end
	if event == "RAW_COMBATLOG"  then
		if arg1 == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
			objectGUID = string.match(arg2,"0x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x")
			Contra.Guids.guids[objectGUID] = nil
		end
		if Contra.Casting.AutoInterruptId == objectGUID then
			Contra.Casting.AutoInterruptId = nil
		end
	end
end

Contra.Casting.IsChannel = false
Contra.Casting.StartTime = 0
Contra.Casting.ArcaneMissilesChannelTime = 0
--检测引导法术函数
function Contra.Casting.CheckChannelMode()
	if event == "SPELLCAST_CHANNEL_START" then
		Contra.Casting.IsChannel = true
		Contra.Casting.StartTime = GetTime()
		Contra.Casting.ArcaneMissilesChannelTime = Contra.GetSpellCastTime("奥术飞弹", "等级 8")
	end
	if event == "SPELLCAST_CHANNEL_UPDATE" then
		Contra.Casting.IsChannel = true
	end
	if event == "SPELLCAST_CHANNEL_STOP" then
		Contra.Casting.IsChannel = false
		Contra.Casting.ArcaneMissilesChannelTime = 0
	end
end

--获得BUFF函数
--Contra.Casting.SelfBuffs = {}
function Contra.Casting.GetBuffs()
	if arg1 == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or arg1 == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
		local spellName = string.match(arg2, "你获得了(.+)的效果")
		if spellName then
			Contra.Casting.SelfBuffs[spellName] = GetTime()
		end
	end
	if event == "UNIT_CASTEVENT" and arg3 == "CAST" and UnitName("player") == UnitName(arg1) then
		if Contra.DB.IDToName[arg4] then
			local spellName = Contra.DB.IDToName[arg4]["spelllname"]
			if spellName then
				Contra.Casting.SelfBuffs[spellName] = GetTime()
			end
		end
	end
end	

--移除BUFF函数
function Contra.Casting.RemoveBuffs()
	if arg1 == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
		local spellName = string.match(arg2, "(.+)效果从你身上消失了")
		if spellName and Contra.Casting.SelfBuffs[spellName] then
			Contra.Casting.SelfBuffs[spellName] = nil
		end
	end
	if arg1 == "CHAT_MSG_COMBAT_FRIENDLY_DEATH" then
		if string.match(arg2, "你死了") then
			--全部BUFF清除
			for spellName in pairs(Contra.Casting.SelfBuffs) do
				if Contra.DB.BUFF[spellName] and Contra.DB.BUFF[spellName]["DeathToKeep"] then
					return
				else
					Contra.Casting.SelfBuffs[spellName] = nil
				end
			end
		end
	end
end

--定时清除BUFF
Contra.Casting.ClearBuffsTime = 0
function Contra.Casting.OnUpdateClearBuffs()
	if GetTime() - Contra.Casting.ClearBuffsTime < 10 then
		return
	end
	Contra.Casting.ClearBuffsTime = GetTime()
	
	--检查BUFF是否过期
	for spellName, time in pairs(Contra.Casting.SelfBuffs) do
		if spellName and time and Contra.DB.BUFF[spellName] then
			if GetTime() - time > Contra.DB.BUFF[spellName]["time"] then
				Contra.Casting.SelfBuffs[spellName] = nil
			end
		end
	end
end

--战斗开始函数
function Contra.Casting.StartBattle()
	if event == "PLAYER_REGEN_DISABLED" then
		Contra.Casting.BattleStart = GetTime()
		Contra.Casting.BattleEnd = false
	end
end

--战斗结束函数
function Contra.Casting.EndBattle()
	if event == "PLAYER_REGEN_ENABLED" then
		Contra.Casting.BattleEnd = true
        Contra.Casting.LastCastName = ""
	end
end


--主手攻击计时的函数
Contra.Casting.AttackTime = 0
Contra.Casting.RemainingTime = 0
Contra.Casting.PastTime = 0
Contra.Casting.AttackSpeed = 1
Contra.Casting.PrevAttackSpeed = nil

-- 获取武器速度
function Contra.Casting.GetWeaponSpeed()
	local speedMH, speedOH = UnitAttackSpeed("player")
	local stlocaleClass, stclass = UnitClass("player")
	if stclass ~= "HUNTER" then
		return speedMH, speedOH
	else
		return UnitRangedDamage("player") or speedMH, speedOH
	end
end

-- 检查并应用速度变化
function Contra.Casting.CheckAndApplySpeedChange()
	local currentSpeed = Contra.Casting.GetWeaponSpeed()
	if Contra.Casting.PrevAttackSpeed and Contra.Casting.PrevAttackSpeed ~= currentSpeed and Contra.Casting.AttackSpeed > 0 then
		-- 计算当前剩余时间占原速度的百分比
		local remainingPercent = Contra.Casting.RemainingTime / Contra.Casting.AttackSpeed
		-- 应用新速度并按比例调整剩余时间
		Contra.Casting.AttackSpeed = currentSpeed
		Contra.Casting.RemainingTime = Contra.Casting.AttackSpeed * remainingPercent
		-- 确保剩余时间不为负数
		if Contra.Casting.RemainingTime < 0 then
			Contra.Casting.RemainingTime = 0
		end
	end
	Contra.Casting.PrevAttackSpeed = currentSpeed
end

-- 检查是否应该重置计时器
function Contra.Casting.ShouldResetTimer()
	local percentTime = Contra.Casting.RemainingTime / Contra.Casting.AttackSpeed
	return (percentTime < 0.05)
end

-- 重置主手攻击计时器
function Contra.Casting.ResetAttackTimer()
	Contra.Casting.AttackTime = GetTime()
	Contra.Casting.AttackSpeed = Contra.Casting.GetWeaponSpeed()
	Contra.Casting.RemainingTime = Contra.Casting.AttackSpeed
end

function Contra.Casting.GetAttackTime()
	-- 主手攻击事件
	if event == "UNIT_CASTEVENT" and arg3 == "MAINHAND" and arg1 == Contra.Guids.MyGuid then
		Contra.Casting.AttackTime = GetTime()
		Contra.Casting.AttackSpeed = Contra.Casting.GetWeaponSpeed()
	end
	
	-- 处理RAW_COMBATLOG事件
	if event == "RAW_COMBATLOG" then
		-- 主手攻击命中/未命中事件
		if arg1 == "CHAT_MSG_COMBAT_SELF_HITS" or arg1 == "CHAT_MSG_COMBAT_SELF_MISSES" then
			if Contra.Casting.ShouldResetTimer() then
				Contra.Casting.ResetAttackTimer()
			end
		end
		
		-- 武器速度变化处理 - 当获得或失去BUFF时
		if arg1 == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or arg1 == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
			Contra.Casting.CheckAndApplySpeedChange()
		end
		
		-- 招架减少攻击间隔
		if arg1 == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
			if string.find(arg2, ".* attacks. You parry.") or string.find(arg2, ".*发起了攻击。你招架住了。") then
				local minimum = Contra.Casting.AttackSpeed * 0.20
				if Contra.Casting.RemainingTime > minimum then
					local reduct = Contra.Casting.AttackSpeed * 0.40
					local newTimer = Contra.Casting.RemainingTime - reduct
					if newTimer < minimum then
						Contra.Casting.RemainingTime = minimum
					else
						Contra.Casting.RemainingTime = newTimer
					end
				end
			end
		end
	end
end

function Contra.Casting.OnUpdateAttackTime()
	if Contra.Casting.AttackSpeed and Contra.Casting.AttackTime > 0 then
		Contra.Casting.RemainingTime = Contra.Casting.AttackSpeed - (GetTime() - Contra.Casting.AttackTime)
		Contra.Casting.PastTime = GetTime() - Contra.Casting.AttackTime
		if Contra.Casting.RemainingTime < 0 then
			Contra.Casting.RemainingTime = 0
		end
	end
end

--英勇打击/顺劈斩的重置主手攻击计时
function Contra.Casting.ResetAttackTime()
	if event == "UNIT_CASTEVENT" and arg3 == "CAST" and (arg4 == 25286 or arg4 == 20569) and arg1 == Contra.Guids.MyGuid then
		Contra.Casting.AttackTime = GetTime()
		Contra.Casting.AttackSpeed = Contra.Casting.GetWeaponSpeed()
	end
end

--副手攻击计时的函数
-- Contra.Casting.OffHandAttackTime = 0
-- Contra.Casting.OffHandRemainingTime = 0
-- Contra.Casting.OffHandPastTime = 0
-- Contra.Casting.OffHandAttackSpeed = 1
-- function Contra.Casting.GetOffHandAttackTime()
-- 	if event == "UNIT_CASTEVENT" and arg3 == "OFFHAND" and arg1 == Contra.Guids.MyGuid then
-- 		Contra.Casting.OffHandAttackTime = GetTime()
-- 		_, Contra.Casting.OffHandAttackSpeed = UnitAttackSpeed("player")
-- 	end
	-- if event == "RAW_COMBATLOG" then
	-- 	if arg1 == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or arg1 == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
	-- 		if Contra.Casting.OffHandAttackSpeed then
	-- 			local perc = Contra.Casting.OffHandRemainingTime/Contra.Casting.OffHandAttackSpeed
	-- 		end
	-- 		_,Contra.Casting.OffHandAttackSpeed = UnitAttackSpeed("player")
	-- 		if Contra.Casting.OffHandAttackSpeed then
	-- 			Contra.Casting.OffHandRemainingTime = Contra.Casting.OffHandAttackSpeed * perc
	-- 		end
			
	-- 	end
	-- end
-- end

local isMovingCheckTime = 0.05
local isMovingOldX,isMovingOldY = 0,0
local isMovingLastCheckTime = 0
Contra.IsMoving = false
--判断是否在移动
function Contra.Casting.IsMoving()
	if GetTime() - isMovingLastCheckTime < isMovingCheckTime then return end 
    local x,y = GetPlayerMapPosition("player")
    if x ~= isMovingOldX or y ~= isMovingOldY then
        Contra.IsMoving = true
    else
        Contra.IsMoving = false
    end
	isMovingOldX,isMovingOldY = x,y
	isMovingLastCheckTime = GetTime()
end

--记录旋风斩和嗜血上次的释放试讲
Contra.Casting.LastCuttingTime = 0
Contra.Casting.LastBloodlustTime = 0
Contra.Casting.LastCastName = ""

function Contra.Casting.CheckCuttingAndBloodlust()
    if event == "UNIT_CASTEVENT" and arg1 == Contra.Guids.MyGuid and arg3 == "CAST" and arg4 == 1680 then 
        Contra.Casting.LastCuttingTime = GetTime()
        Contra.Casting.LastCastName = "旋风斩"
    end
    if event == "UNIT_CASTEVENT" and arg1 == Contra.Guids.MyGuid and arg3 == "CAST" and arg4 == 23894 then 
        Contra.Casting.LastBloodlustTime = GetTime()
        Contra.Casting.LastCastName = "嗜血"
    end
    if event == "UNIT_CASTEVENT" and arg1 == Contra.Guids.MyGuid and arg3 == "CAST" and arg4 == 45961 then 
        Contra.Casting.LastBloodlustTime = GetTime()
        Contra.Casting.LastCastName = "猛击"
    end
end


--事件处理总函数
function Contra.Casting.CastingEvent()
	--获取施法状态
	Contra.Casting.GetCastingGuid()
	--移除施法状态
	Contra.Casting.RemoveCastingGuid()
	--打印日志函数
	Contra.Casting.TestEvent()
	--获取BUFF
	Contra.Casting.GetBuffs()
	--移除BUFF
	Contra.Casting.RemoveBuffs()
	--战斗开始函数
	Contra.Casting.StartBattle()
	--战斗结束函数
	Contra.Casting.EndBattle()
	--主手攻击计时的函数
	Contra.Casting.GetAttackTime()
	--重置主手攻击计时
	Contra.Casting.ResetAttackTime()
	--是否正在引导
	Contra.Casting.CheckChannelMode()
    --获取旋风斩和嗜血的释放时间
    Contra.Casting.CheckCuttingAndBloodlust()
end

--定时处理函数
function Contra.Casting.OnUpdate()
	--主手攻击计时
	Contra.Casting.OnUpdateAttackTime()
	--定时清除BUFF
	Contra.Casting.OnUpdateClearBuffs()
	-- 每次更新都检查速度变化，确保乱舞等BUFF能立即生效
	Contra.Casting.CheckAndApplySpeedChange()
	-- 判断是否在移动
	Contra.Casting.IsMoving()
end


--事件处理
Contra.Casting.Frame:SetScript("OnEvent", Contra.Casting.CastingEvent)
--定时清除BUFF
Contra.Casting.Frame:SetScript("OnUpdate", Contra.Casting.OnUpdate)




