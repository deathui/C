local Cast = CastSpellByName
local IsCasting = Contra.IsTargetCasting
local ItemCD = Contra.ItemCD
local CD = Contra.CD
local Unbuff = Contra.Casting.CancelBuffByName
local Buff = Contra.Casting.HasBuff
local CastTime = Contra.GetSpellCastTime

local function ContraGetCombatInfoRogue()
    -- 获取当前玩家的生命值、法力值、目标的生命值等信息
    local hp = UnitHealth("target") / UnitHealthMax("target") * 100
    local myhp = UnitHealth("player") / UnitHealthMax("player") * 100
    local mp = UnitMana("player")

    -- 目标的生命值和最大生命值
    local maxhp = UnitHealthMax("target")
    local inghp = UnitHealth("target")

    -- 是否在近战范围内
    local IsMeleeRange = Contra.IsMeleeRange()

    -- 是否是目标的目标
    local IsTargetOfTargetMe = Contra.IsTargetOfTargetMe()

    -- 是否是Boss
    local IsBoss = Contra.IsTargetBoss()
    
    --是否在战斗中
    local IsCombat = UnitAffectingCombat("player")

    -- 获取施法剩余时间、过去时间和攻击速度 
    local ST = Contra.Casting.RemainingTime
    local SS = Contra.Casting.PastTime
    local SD = UnitAttackSpeed("player")

    -- 获取AOE范围
    local Range = Contra.GetAOERange()

    -- 获取指定BUFF的层数
    local Layer = Contra.GetBuffCount("破甲攻击", "target")

    --当前角色种族
    local raceName, _ = UnitRace("player")

    --当前角色职业
    local playerClass, _ = UnitClass("player")

    --是否在目标背后
    local behind = UnitXP("behind", "player", "target")

    --获取周围生命
    local healthall = Contra.Filter.GetTotalHealthOfAttackableUnits()

    
    local _, qgtime = Contra.Casting.HasBuff("切割","player")
    local _, xxqxtime = Contra.Casting.HasBuff("血腥气息","player")
    local _, dstime = Contra.Casting.HasBuff("毒伤","player")
    local _, cdtime = Contra.Casting.HasBuff("冲动","player")

    return hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass, behind, healthall, qgtime, xxqxtime, dstime, cdtime, IsCombat

end

-- local _, dstime = Contra.Casting.HasBuff("毒伤","player")
-- mp > 19 and GetComboPoints() < 5 and dstime < 2
-- /run local _, dstime = Contra.Casting.HasBuff("毒伤","player"); print(UnitMana("player")>19 and GetComboPoints() < 5 and dstime < 2)


-- 模拟界面
-- 开启： true     关闭： false

-- 生存开关
-- ContraDB.Rogui.Buttons.Shun.Shanbi = true        -- 标题：使用 闪避              说明：骷髅级的目标OT了，使用闪避
-- ContraDB.Rogui.Buttons.Shun.Xiaoshi = true       -- 标题：使用 消失              说明：骷髅级的目标OT了，使用消失    
-- ContraDB.Rogui.Buttons.Shun.Wudi = true          -- 标题：使用 无敌药水          说明：骷髅级的目标OT了，使用有限无敌药水（闪避CD中才会用 和 麦迪文不用）
-- ContraDB.Rogui.Buttons.Shun.Tang = true          -- 标题：使用 治疗石            说明：我的生命值低于设定百分比，使用特效治疗石
-- ContraDB.Rogui.Buttons.Shun.Dahong = true        -- 标题：使用 大红              说明：我的生命值低于设定百分比，使用特效治疗药水（麦迪文除外）
-- ContraDB.Rogui.Buttons.Shun.Cyc = true           -- 标题：使用 草药茶            说明：我的生命值低于设定百分比，使用特效草药茶

-- -- 技能开关
-- ContraDB.Rogui.Buttons.Shun.HuanJi = true        -- 还击开关
-- ContraDB.Rogui.Buttons.Shun.Jhc = true           -- 标题：使用 菊花茶            说明：能量低于10，使用菊花茶
-- ContraDB.Rogui.Buttons.Shun.Zhongzu = true       -- 标题：使用 种族天赋          说明：开启种族天赋
-- ContraDB.Rogui.Buttons.Shun.Guimei = true        -- 标题：使用 鬼魅攻击          说明：施放鬼魅攻击
-- ContraDB.Rogui.Buttons.Shun.Huanji = true        -- 标题：使用 还击              说明：施放还击
-- ContraDB.Rogui.Buttons.Shun.xiee = true          -- 标题：使用 邪恶攻击          说明：当击打目标正面时，强制使用邪恶攻击（背刺贼专用）
-- ContraDB.Rogui.Buttons.Shun.Daduan = true        -- 标题：使用 自动打断          说明：当目标施法时自动打断
-- ContraDB.Rogui.Buttons.Shun.SWBJ = true          -- 标题：使用 死亡标记          说明：骷髅级目标血量低于设定值，则施放死亡标记
-- ContraDB.Rogui.Buttons.Shun.Siwangbiaoji = 100   -- 标题：使用死亡标记           说明：设置目标施放死亡标记的百分比

-- --终结技开关
-- ContraDB.Rogui.Buttons.Shun.Sy = true            -- 标题：使用 死亡之影          说明：骷髅级目标血量低于设定值，则施放死亡之影
-- ContraDB.Rogui.Buttons.Shun.Siying = 5           -- 标题：使用 死亡之影连击点数   说明：施放死亡之影(建议5)

-- ContraDB.Rogui.Buttons.Shun.Ds = true            -- 标题：使用 毒伤              说明：设置施放毒伤的连击点数值（建议4）
-- ContraDB.Rogui.Buttons.Shun.Dushang = 5          -- 标题：使用 毒伤连击点数       说明：设置施放毒伤的连击点数值

-- ContraDB.Rogui.Buttons.Shun.Qg = true            -- 标题：使用 切割              说明：设置施放切割的连击点数值（建议4）
-- ContraDB.Rogui.Buttons.Shun.Qiege = 5            -- 标题：使用 切割连击点数       说明：设置施放切割的连击点数值

-- ContraDB.Rogui.Buttons.Shun.Gl = true            -- 标题：使用 割裂              说明：设置施放割裂的连击点数值（建议5）
-- ContraDB.Rogui.Buttons.Shun.Gelie = 5            -- 标题：使用 割裂连击点数       说明：设置施放割裂的连击点数值

-- ContraDB.Rogui.Buttons.Shun.Tg = true            -- 标题：使用 剔骨              说明：设置施放剔骨的连击点数值（建议4或5）
-- ContraDB.Rogui.Buttons.Shun.Tigu = 5             -- 标题：使用 剔骨连击点数       说明：设置施放剔骨的连击点数值

-- ContraDB.Rogui.Buttons.Shun.Pj = true            -- 标题：使用 破甲              说明：骷髅级目标血量低于设定值，则施放破甲
-- ContraDB.Rogui.Buttons.Shun.Pojia = 5            -- 标题：使用 破甲连击点数       说明：施放破甲(建议5)










local BuYongWuDi ={
    ["麦迪文的回响"]  = true,
    ["克苏恩之眼"]   = true,
    ["拉格纳罗斯"]   = true,
    ["阿努布雷坎"]    = true,
    ["帕奇维克"]    = true,
    ["女公爵布劳繆克丝"]    = true,
}

--毒伤贼
function Dushangzei_A()

    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass, behind, healthall, qgtime, xxqxtime, dstime, cdtime, IsCombat = ContraGetCombatInfoRogue()



    -- print("切割时间:"..qgtime.." 血腥气息时间:"..xxqxtime.." 毒伤时间:"..dstime.." 冲动时间:"..cdtime)

    Contra.Attack()

    if ContraDB.Rogui.Buttons.Shun.Huanji and IsTargetOfTargetMe then
		CastSpellByName("还击")
	end
    
    if ContraDB.Rogui.Buttons.Shun.Shanbi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("闪避")
	end

	if ContraDB.Rogui.Buttons.Shun.Xiaoshi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("消失")
	end

	if ContraDB.Rogui.Buttons.Shun.Wudi and IsBoss and IsTargetOfTargetMe and Buff("闪避") and not BuYongWuDi[UnitName("target")] then
		Contra.UseItemByName("有限无敌药水")
	end

    if ContraDB.Rogui.Buttons.Shun.Tang and IsCombat and myhp < 40 and IsCombat then
		Contra.UseItemByName("特效治疗石")
	end

    if ContraDB.Rogui.Buttons.Shun.Dahong and IsCombat and IsBoss and myhp < 30 and UnitName("target") ~= "麦迪文的回响" then
		Contra.UseItemByName("特效治疗药水")
	end

	if ContraDB.Rogui.Buttons.Shun.Cyc and myhp < 20 and IsCombat then
		Contra.UseItemByName("诺达纳尔草药茶")
	end

	if ContraDB.Rogui.Buttons.Shun.Jhc and mp < 10 and IsBoss and Range() < 6 and IsCombat then
		Contra.UseItemByName("菊花茶")
	end

    if (ContraDB.Rogui.Buttons.Shun.Gl and healthall > 150000 and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Gelie and xxqxtime < 2 and ST > 0.5) or (ContraDB.Rogui.Buttons.Shun.Gl and healthall > 150000 and mp > 79 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Gelie and xxqxtime < 5 and ST > 0.5) then
        Cast("割裂")
    end

    if (ContraDB.Rogui.Buttons.Shun.Ds and mp > 19 and GetComboPoints() < ContraDB.Rogui.Buttons.Shun.Dushang and dstime < 2) or (ContraDB.Rogui.Buttons.Shun.Ds and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Dushang and dstime < 3 and xxqxtime > 6) then
        Cast("毒伤")
    end

    if (ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() < ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 2) or (ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 3 and xxqxtime > 6) then
        Cast("切割")
    end

    if (ContraDB.Rogui.Buttons.Shun.Tg and inghp > 40000 and mp > 69 and ST > 0.5 and dstime > 3 and qgtime > 3 and xxqxtime > 6 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Tigu) or (ContraDB.Rogui.Buttons.Shun.Tg and inghp < 40001 and GetComboPoints() <= ContraDB.Rogui.Buttons.Shun.Tigu) then
        Cast("剔骨")
    end

    if GetComboPoints() < 5 and mp > 9 and ST > 0.5 then
        Cast("双刃毒袭")
    end

    if ContraDB.Rogui.Buttons.Shun.Guimei and IsTargetOfTargetMe and mp > 39 and ST > 0.5 then
		CastSpellByName("鬼魅攻击")
	end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not IsBoss and mp < 20 and raceName == "人类") or (IsBoss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "人类") then
        Cast("感知")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not IsBoss and mp < 20 and IsMeleeRange and raceName == "巨魔") or (IsBoss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "巨魔") then
        Cast("狂暴")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not IsBoss and mp < 20 and IsMeleeRange and raceName == "兽人") or (IsBoss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "兽人") then
        Cast("血性狂怒")
    end




    
end

--战斗毒伤贼（战毒贼）
function Zhanduzei_A()

    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass, behind, healthall, qgtime, xxqxtime, dstime, cdtime, IsCombat = ContraGetCombatInfoRogue()

    Contra.Attack()

    if ContraDB.Rogui.Buttons.Shun.Huanji and IsTargetOfTargetMe then
		CastSpellByName("还击")
	end
    
    if ContraDB.Rogui.Buttons.Shun.Shanbi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("闪避")
	end

	if ContraDB.Rogui.Buttons.Shun.Xiaoshi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("消失")
	end

	if ContraDB.Rogui.Buttons.Shun.Wudi and IsBoss and IsTargetOfTargetMe and Buff("闪避") and not BuYongWuDi[UnitName("target")] then
		Contra.UseItemByName("有限无敌药水")
	end

    if ContraDB.Rogui.Buttons.Shun.Tang and IsCombat and myhp < 40 and IsCombat then
		Contra.UseItemByName("特效治疗石")
	end

    if ContraDB.Rogui.Buttons.Shun.Dahong and IsCombat and IsBoss and myhp < 30 and UnitName("target") ~= "麦迪文的回响" then
		Contra.UseItemByName("特效治疗药水")
	end

	if ContraDB.Rogui.Buttons.Shun.Cyc and myhp < 20 and IsCombat then
		Contra.UseItemByName("诺达纳尔草药茶")
	end

	if ContraDB.Rogui.Buttons.Shun.Jhc and mp < 10 and IsBoss and Range() < 6 and IsCombat then
		Contra.UseItemByName("菊花茶")
	end

    if (ContraDB.Rogui.Buttons.Shun.Gl and healthall > 150000 and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Gelie and xxqxtime < 2 and ST > 0.5) or (ContraDB.Rogui.Buttons.Shun.Gl and healthall > 150000 and mp > 79 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Gelie and xxqxtime < 6 and ST > 0.5) then
        Cast("割裂")
    end

    if (ContraDB.Rogui.Buttons.Shun.Ds and mp > 19 and GetComboPoints() < ContraDB.Rogui.Buttons.Shun.Dushang and dstime < 2) or (ContraDB.Rogui.Buttons.Shun.Ds and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Dushang and dstime < 3 and xxqxtime > 6) then
        Cast("毒伤")
    end

    if (ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() < ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 2) or (ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 3 and xxqxtime > 6) then
        Cast("切割")
    end

    if (ContraDB.Rogui.Buttons.Shun.TG and inghp > 30000 and mp > 69 and ST > 0.5 and dstime > 3 and qgtime > 3 and xxqxtime > 6 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Tigu) or (ContraDB.Rogui.Buttons.Shun.TG and inghp < 30001 and GetComboPoints() <= ContraDB.Rogui.Buttons.Shun.Tigu) then
        Cast("剔骨")
    end

    if GetComboPoints() < 5 and mp > 9 and ST > 0.5 then
        CastSpellByName("突袭")
    end

    if ContraDB.Rogui.Buttons.Shun.Guimei and GetComboPoints() < 5 and mp > 39 and ST > 0.5 then
        CastSpellByName("鬼魅攻击")
    end

    if GetComboPoints() < 5 and mp > 39 and ST > 0.5 then
        CastSpellByName("邪恶攻击")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and raceName == "人类") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "人类") then
        Cast("感知")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "巨魔") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "巨魔") then
        Cast("狂暴")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "兽人") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "兽人") then
        Cast("血性狂怒")
    end
    
    -- print("\n\n切割时间:"..qgtime.." \n血腥气息时间:"..xxqxtime.." \n毒伤时间:"..dstime.." \n冲动时间:"..cdtime.."\n\n")

end



--战斗匕首毒伤贼（战毒贼）
function Zhanbiduzei_A()

    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass, behind, healthall, qgtime, xxqxtime, dstime, cdtime, IsCombat = ContraGetCombatInfoRogue()

    Contra.Attack()

    if ContraDB.Rogui.Buttons.Shun.Huanji and IsTargetOfTargetMe then
		CastSpellByName("还击")
	end
    
    if ContraDB.Rogui.Buttons.Shun.Shanbi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("闪避")
	end

	if ContraDB.Rogui.Buttons.Shun.Xiaoshi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("消失")
	end

	if ContraDB.Rogui.Buttons.Shun.Wudi and IsBoss and IsTargetOfTargetMe and Buff("闪避") and not BuYongWuDi[UnitName("target")] then
		Contra.UseItemByName("有限无敌药水")
	end

    if ContraDB.Rogui.Buttons.Shun.Tang and IsCombat and myhp < 40 and IsCombat then
		Contra.UseItemByName("特效治疗石")
	end

    if ContraDB.Rogui.Buttons.Shun.Dahong and IsCombat and IsBoss and myhp < 30 and UnitName("target") ~= "麦迪文的回响" then
		Contra.UseItemByName("特效治疗药水")
	end

	if ContraDB.Rogui.Buttons.Shun.Cyc and myhp < 20 and IsCombat then
		Contra.UseItemByName("诺达纳尔草药茶")
	end

	if ContraDB.Rogui.Buttons.Shun.Jhc and mp < 10 and IsBoss and Range() < 6 and IsCombat then
		Contra.UseItemByName("菊花茶")
	end

    if (ContraDB.Rogui.Buttons.Shun.Gl and healthall > 150000 and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Gelie and xxqxtime < 2 and ST > 0.5) or (ContraDB.Rogui.Buttons.Shun.Gl and healthall > 150000 and mp > 79 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Gelie and xxqxtime < 6 and ST > 0.5) then
        Cast("割裂")
    end

    if (ContraDB.Rogui.Buttons.Shun.Ds and mp > 19 and GetComboPoints() < ContraDB.Rogui.Buttons.Shun.Dushang and dstime < 2) or (ContraDB.Rogui.Buttons.Shun.Ds and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Dushang and dstime < 3 and xxqxtime > 6) then
        Cast("毒伤")
    end

    if (ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() < ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 2) or (ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 3 and xxqxtime > 6) then
        Cast("切割")
    end

    if (ContraDB.Rogui.Buttons.Shun.Tg and inghp > 30000 and mp > 69 and ST > 0.5 and dstime > 3 and qgtime > 3 and xxqxtime > 6 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qiege) or (ContraDB.Rogui.Buttons.Shun.Tg and inghp < 30001 and GetComboPoints() <= ContraDB.Rogui.Buttons.Shun.Qiege) then
        Cast("剔骨")
    end

    if GetComboPoints() < 5 and mp > 9 and ST > 0.5 then
        CastSpellByName("突袭")
    end

    if not Contra.GetItemType(16, 2) == "匕首" and behind and mp > 59 and GetComboPoints() < 5 and ST > 0.5 then
        Cast("背刺")
    end
    
    if ContraDB.Rogui.Buttons.Shun.xiee and not behind and mp > 69 and GetComboPoints() < 5 and ST > 0.5 then
        Cast("邪恶攻击")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and raceName == "人类") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "人类") then
        Cast("感知")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "巨魔") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "巨魔") then
        Cast("狂暴")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "兽人") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "兽人") then
        Cast("血性狂怒")
    end
    
    -- print("\n\n切割时间:"..qgtime.." \n血腥气息时间:"..xxqxtime.." \n毒伤时间:"..dstime.." \n冲动时间:"..cdtime.."\n\n")

end

--战斗贼
function Zhandouzei_A()

    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass, behind, healthall, qgtime, xxqxtime, dstime, cdtime, IsCombat = ContraGetCombatInfoRogue()



    -- print("切割时间:"..qgtime.." 血腥气息时间:"..xxqxtime.." 毒伤时间:"..dstime.." 冲动时间:"..cdtime)

    Contra.Attack()
    
    if ContraDB.Rogui.Buttons.Shun.Shanbi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("闪避")
	end

	if ContraDB.Rogui.Buttons.Shun.Xiaoshi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("消失")
	end

	if ContraDB.Rogui.Buttons.Shun.Wudi and IsBoss and IsTargetOfTargetMe and Buff("闪避") and not BuYongWuDi[UnitName("target")] then
		Contra.UseItemByName("有限无敌药水")
	end

    if ContraDB.Rogui.Buttons.Shun.Tang and IsCombat and myhp < 40 and IsCombat then
		Contra.UseItemByName("特效治疗石")
	end

    if ContraDB.Rogui.Buttons.Shun.Dahong and IsCombat and IsBoss and myhp < 30 and UnitName("target") ~= "麦迪文的回响" then
		Contra.UseItemByName("特效治疗药水")
	end

	if ContraDB.Rogui.Buttons.Shun.Cyc and myhp < 20 and IsCombat then
		Contra.UseItemByName("诺达纳尔草药茶")
	end

	if ContraDB.Rogui.Buttons.Shun.Jhc and mp < 10 and IsBoss and Range() < 6 and IsCombat then
		Contra.UseItemByName("菊花茶")
	end

    if ContraDB.Rogui.Buttons.Shun.Gl and inghp > 30000 and mp > 79 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qiege and xxqxtime < 6 and ST > 0.5 then
        Cast("割裂")
    end

    if ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() < ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 2 then
        Cast("切割")
    end

    if ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 2 and xxqxtime > 6 then
        Cast("切割")
    end

    if ContraDB.Rogui.Buttons.Shun.Tg and inghp > 30000 and mp > 69 and ST > 0.5 and qgtime > 4 and xxqxtime > 6 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Tigu then
        Cast("剔骨")
    end

    if ContraDB.Rogui.Buttons.Shun.Tg and inghp < 30001 and GetComboPoints() <= ContraDB.Rogui.Buttons.Shun.Tigu then
        Cast("剔骨")
    end

    if ContraDB.Rogui.Buttons.Shun.HuanJi and mp > 9 and ST > 0.5 then
        CastSpellByName("还击")
    end

    if GetComboPoints() < 5 and mp > 9 and ST > 0.5 then
        CastSpellByName("突袭")
    end

    if ContraDB.Rogui.Buttons.Shun.Guimei and GetComboPoints() < 5 and mp > 39 and ST > 0.5 then
        CastSpellByName("鬼魅攻击")
    end

    if GetComboPoints() < 5 and mp > 39 and ST > 0.5 then
        CastSpellByName("邪恶攻击")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and raceName == "人类") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "人类") then
        Cast("感知")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "巨魔") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "巨魔") then
        Cast("狂暴")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "兽人") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "兽人") then
        Cast("血性狂怒")
    end
    
end

--战斗匕首贼
function Zhanbizei_A()

    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass, behind, healthall, qgtime, xxqxtime, dstime, cdtime, IsCombat = ContraGetCombatInfoRogue()



    -- print("切割时间:"..qgtime.." 血腥气息时间:"..xxqxtime.." 毒伤时间:"..dstime.." 冲动时间:"..cdtime)

    Contra.Attack()

    if ContraDB.Rogui.Buttons.Shun.Huanji and IsTargetOfTargetMe then
		CastSpellByName("还击")
	end
    
    if ContraDB.Rogui.Buttons.Shun.Shanbi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("闪避")
	end

	if ContraDB.Rogui.Buttons.Shun.Xiaoshi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("消失")
	end

	if ContraDB.Rogui.Buttons.Shun.Wudi and IsBoss and IsTargetOfTargetMe and Buff("闪避") and not BuYongWuDi[UnitName("target")] then
		Contra.UseItemByName("有限无敌药水")
	end

    if ContraDB.Rogui.Buttons.Shun.Tang and IsCombat and myhp < 40 and IsCombat then
		Contra.UseItemByName("特效治疗石")
	end

    if ContraDB.Rogui.Buttons.Shun.Dahong and IsCombat and IsBoss and myhp < 30 and UnitName("target") ~= "麦迪文的回响" then
		Contra.UseItemByName("特效治疗药水")
	end

	if ContraDB.Rogui.Buttons.Shun.Cyc and myhp < 20 and IsCombat then
		Contra.UseItemByName("诺达纳尔草药茶")
	end

	if ContraDB.Rogui.Buttons.Shun.Jhc and mp < 10 and IsBoss and Range() < 6 and IsCombat then
		Contra.UseItemByName("菊花茶")
	end

    if ContraDB.Rogui.Buttons.Shun.Gl and inghp > 30000 and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qg and xxqxtime < 2 and ST > 0.5 then
        Cast("割裂")
    end

    if ContraDB.Rogui.Buttons.Shun.Gl and inghp > 30000 and mp > 79 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qg and xxqxtime < 6 and ST > 0.5 then
        Cast("割裂")
    end

    if ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() < ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 2 then
        Cast("切割")
    end

    if ContraDB.Rogui.Buttons.Shun.Qg and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Qiege and qgtime < 2 and xxqxtime > 6 then
        Cast("切割")
    end

    if ContraDB.Rogui.Buttons.Shun.Tg and inghp > 30000 and mp > 69 and ST > 0.5 and qgtime > 4 and xxqxtime > 6 and GetComboPoints() > 4 then
        Cast("剔骨")
    end

    if ContraDB.Rogui.Buttons.Shun.Tg and inghp < 30001 and GetComboPoints() > 2 then
        Cast("剔骨")
    end

    if GetComboPoints() < 5 and mp > 9 and ST > 0.5 then
        CastSpellByName("突袭")
    end
    
    if Contra.GetItemType(16, 2) == "匕首" and behind and mp > 59 and GetComboPoints() < 5 and ST > 0.5 then
        Cast("背刺")
    end
    
    if ContraDB.Rogui.Buttons.Shun.xiee and not behind and mp > 69 and GetComboPoints() < 5 and ST > 0.5 then
        Cast("邪恶攻击")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and raceName == "人类") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "人类") then
        Cast("感知")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "巨魔") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "巨魔") then
        Cast("狂暴")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "兽人") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "兽人") then
        Cast("血性狂怒")
    end
end

--破甲贼
function Pojiazei_A()

    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass, behind, healthall, qgtime, xxqxtime, dstime, cdtime, IsCombat = ContraGetCombatInfoRogue()



    -- print("切割时间:"..qgtime.." 血腥气息时间:"..xxqxtime.." 毒伤时间:"..dstime.." 冲动时间:"..cdtime)

    Contra.Attack()

    if ContraDB.Rogui.Buttons.Shun.Huanji and IsTargetOfTargetMe then
		CastSpellByName("还击")
	end
    
    if ContraDB.Rogui.Buttons.Shun.Shanbi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("闪避")
	end

	if ContraDB.Rogui.Buttons.Shun.Xiaoshi and IsBoss and IsTargetOfTargetMe and not BuYongWuDi[UnitName("target")] then
		CastSpellByName("消失")
	end

	if ContraDB.Rogui.Buttons.Shun.Wudi and IsBoss and IsTargetOfTargetMe and Buff("闪避") and not BuYongWuDi[UnitName("target")] then
		Contra.UseItemByName("有限无敌药水")
	end

    if ContraDB.Rogui.Buttons.Shun.Tang and IsCombat and myhp < 40 and IsCombat then
		Contra.UseItemByName("特效治疗石")
	end

    if ContraDB.Rogui.Buttons.Shun.Dahong and IsCombat and IsBoss and myhp < 30 and UnitName("target") ~= "麦迪文的回响" then
		Contra.UseItemByName("特效治疗药水")
	end

	if ContraDB.Rogui.Buttons.Shun.Cyc and myhp < 20 and IsCombat then
		Contra.UseItemByName("诺达纳尔草药茶")
	end

	if ContraDB.Rogui.Buttons.Shun.Jhc and mp < 10 and IsBoss and Range() < 6 and IsCombat then
		Contra.UseItemByName("菊花茶")
	end

    if ContraDB.Rogui.Buttons.Shun.Pojia and mp > 19 and GetComboPoints() > 4 then
        Cast("破甲")
    end

    if hp < ContraDB.Rogui.Buttons.Shun.SWBJ and IsBoss and mp > 39 then
        Cast("死亡标记")
    end

    if ContraDB.Rogui.Buttons.Shun.Gl and inghp > 30000 and mp > 19 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Gelie and xxqxtime < 2 and ST > 0.5 then
        Cast("割裂")
    end

    if ContraDB.Rogui.Buttons.Shun.Gl and inghp > 30000 and mp > 79 and GetComboPoints() == ContraDB.Rogui.Buttons.Shun.Gelie and xxqxtime < 6 and ST > 0.5 then
        Cast("割裂")
    end

    if ContraDB.Rogui.Buttons.Shun.Qiege and mp > 19 and GetComboPoints() < 5 and qgtime < 3 then
        Cast("切割")
    end

    if ContraDB.Rogui.Buttons.Shun.Qiege and mp > 19 and GetComboPoints() > 4 and qgtime < 3 and xxqxtime > 6 then
        Cast("切割")
    end

    if inghp > 30000 and mp > 69 and ST > 0.5 and qgtime > 4 and xxqxtime > 6 and GetComboPoints() > 4 then
        Cast("剔骨")
    end

    if inghp < 30001 and GetComboPoints() > 2 then
        Cast("剔骨")
    end

    if GetComboPoints() < 5 and mp > 9 and ST > 0.5 then
        CastSpellByName("突袭")
    end

    if GetComboPoints() < 5 and mp > 39 and ST > 0.5 then
        CastSpellByName("鬼魅攻击")
    end

    if GetComboPoints() < 5 and mp > 39 and ST > 0.5 then
        CastSpellByName("邪恶攻击")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and raceName == "人类") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "人类") then
        Cast("感知")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "巨魔") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "巨魔") then
        Cast("狂暴")
    end

    if (ContraDB.Rogui.Buttons.Shun.Zhongzu and hp > 70 and not Isboss and mp < 20 and IsMeleeRange and raceName == "兽人") or (Isboss and mp < 20 and hp > 9 and IsMeleeRange and raceName == "兽人") then
        Cast("血性狂怒")
    end
    
end
