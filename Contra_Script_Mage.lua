-- ContraDBDefault = {
--     --版本号
--     Version = 20250909,
--     Mage = {
--         Buttons = {
--             -- 天赋配置
--             Arcane = {
--                 -- 基础开关
--                 AutoSelectTargetToggle = true,                  -- 自动选择目标选择框
--                 AutoSelectTargetHealthChangeToggle = true,      -- 自动选择目标血量小于多少时自动选择目标选择框
--                 AutoSelectTargetHealthChangeNum = 5000,         -- 自动选择目标血量小于多少时自动选择目标拖动条，范围1000-10000
--                 AutoBuffToggle = true,                          -- 自动补BUFF选择框
--                 AutoCreateManaGemsToggle = true,                -- 自动制造法力宝石选择框
--                 AutoEatOrange = true,                           -- 自动吃橘子选择框
                
--                 -- 技能开关
--                 ArcanePowerNotBossToggle = true,                -- 非boss时使用奥术强化选择框
--                 ArcanePowerBossToggle = true,                   -- boss时使用奥术强化选择框
--                 ArcanePowerNotBossHealthNum = 100000,           -- 非boss时使用奥术强化选择框血量小于多少开启拖动条，范围10000-200000
--                 ArcanePowerManaPercNum = 90,                    -- boss时使用奥术强化选择框魔法值百分比小于多少开启拖动条，范围0-100
                
--                 UseAoEToggle = true,                            -- 魔爆术选择框
--                 UseAoEEnemyNum = 4,                             -- 魔爆术小怪数量拖动条值，范围3-5

--                 FireballToggle = true,                          -- 火焰冲击选择框
--                 FireballHealthNum = 5000,                       -- 怪物血量小于多少时使用火焰冲击拖动条，范围1000-50000

--                 ArcaneSurgeIsMovingToogle = true,               -- 移动时使用奥术涌动选择框
--                 ArcaneSurgeIsCDToogle = true,                   -- 溃裂CD时使用奥术涌动选择框
--                 ArcaneSurgeHealthToggle = true,                 -- 怪物血量小于多少时使用奥术涌动选择框
--                 ArcaneSurgeHealthNum = 5000,                    -- 怪物血量小于多少时使用奥术涌动拖动条，范围1000-10000

--                 PresenceOfMindToggle = true,                    -- 气定神闲选择框
-- 				   RaceTalentsToggle = true,						-- 种族天赋选择框

--                 -- 消耗品开关
--                 UseManaPotionsBossToggle = true,                -- 使用法力药水选择框
--                 UseManaPotionsBossNum = 2250,                   -- 法力缺失大于等于多少时使用法力药水拖动条，范围1000-10000
--                 UseHerbsBossToggle = true,                      -- 使用草药茶选择框
--                 UseHerbsBossNum = 1350,                         -- 法力缺失大于等于多少时使用草药茶拖动条，范围1000-10000
--                 UseManaGemBossToggle = true,                    -- 使用法力宝石选择框
--                 UseManaGemBossNum = 1350,                       -- 法力缺失大于等于多少时使用法力宝石拖动条，范围1000-10000
--                 UseInvulnerabilityBossToggle = true,            -- 使用有限无敌选择框

--                 UseManaPotionsNotBossToggle = true,             -- 使用法力药水选择框
--                 UseManaPotionsNotBossNum = 2250,                -- 法力缺失大于等于多少时使用法力药水拖动条，范围1000-10000
--                 UseHerbsNotBossToggle = true,                   -- 使用草药茶选择框
--                 UseHerbsNotBossNum = 1350,                      -- 法力缺失大于等于多少时使用草药茶拖动条，范围1000-10000
--                 UseManaGemNotBossToggle = true,                 -- 使用法力宝石选择框
--                 UseManaGemNotBossNum = 1350,                    -- 法力缺失大于等于多少时使用法力宝石拖动条，范围1000-10000
--                 UseInvulnerabilityNotBossToggle = true,         -- 使用有限无敌选择框

--                 -- 饰品
--                 Use13SoltBossToggle = true,                     -- Boss使用上饰品开关
--                 Use14SlotBossToggle = true,                     -- Boss使用下饰品开关
--                 Use13SoltNotBossToggle = true,                  -- 非Boss使用上饰品开关
--                 Use14SlotNotBossToggle = true,                  -- 非Boss使用下饰品开关

--                 Change13SlotToggle = true,                      -- 切换上饰品选择框
--                 Change14SlotToggle = true,                      -- 切换下饰品选择框

--             },
--             Fire = {},  -- 火焰天赋
--             Frost = {}, -- 冰霜天赋
--         },

--     }
-- }

--- @useage 非raid模式
function Contra.Mage_NotInRaid()
    -- 如果奥术溃裂不在CD中，并且身上没有奥术溃裂BUFF，则释放奥术溃裂
    if Contra.CD("奥术溃裂") == 0 and not Contra.Casting.HasBuff("奥术溃裂") then
        Contra.MageCast("奥术溃裂")
    end
    if not Contra.Casting.IsChannel then
        Contra.MageCast("奥术飞弹")
    end
end


--- @useage 1-自动使用有限无敌
function Contra.Mage_Use_Infinite_Immunity()

    if Contra.ItemCD("有限无敌药水") == 0 then
        -- 如果在战斗中，目标是BOSS，目标的目标是自己，则使用有限无敌，并大喊
        if ContraDB.Mage.Buttons.Arcane.UseInvulnerabilityBossToggle and UnitAffectingCombat("player") and Contra.IsTargetBoss() and UnitName("targettarget") == UnitName("player") and UnitName("targettarget") ~= "拉格纳罗斯"  then
            Contra.UseItemByName("有限无敌药水")
            SendChatMessage(UnitName("target").."的目标是我，我已使用有限无敌", "SAY")
            Contra.Debug("符合BOSS使用有限无敌模式，已使用有限无敌药水","输出")
        end

        -- 如果周围目标大于等于4个，并且自身血量小于50%，并且在战斗中的敌对单位的目标是自己的数量大于等于1，则使用有限无敌药水
        if ContraDB.Mage.Buttons.Arcane.UseInvulnerabilityNotBossToggle and ContraDB.Mage.Buttons.Arcane.UseAoEToggle and Contra.Filter.CountAttackableUnitsInRangeTen() >= ContraDB.Mage.Buttons.Arcane.UseAoEEnemyNum and UnitHealth("player")/UnitHealthMax("player") < 0.5  then
            Contra.UseItemByName("有限无敌药水")
            Contra.Debug("符合非BOSS使用有限无敌模式，已使用有限无敌药水","输出")
        end
    end

end

--- @useage 2-自动选目标
function Contra.Mage_Select_Target()

    if ContraDB.Mage.Buttons.Arcane.AutoSelectTargetToggle and Contra.Filter.infight("player") then
        -- 正常切换目标
        if not UnitExists("target") or UnitIsDeadOrGhost("target") or UnitIsFriend("player", "target") or Contra.Casting.HasBuff("放逐术","target") then
		    local unit = Contra.Filter.FindClosestInfightUnit()
            if unit then
                TargetUnit(unit)
            end
        end
        -- 斩杀阶段火铳CD切目标
        if Contra.CD("火焰冲击") > 0 and Contra.CD("奥术涌动") > 0 and UnitHealth("target") < 5000 then
            local unit = Contra.Filter.FindClosestInfightUnit()
            if unit then
                TargetUnit(unit)
            end
        end
	end

end

--- @useage 3-自动吃橘子
function Contra.Mage_Eat_Orange()
    if ContraDB.Mage.Buttons.Arcane.AutoEatOrange then
        --如果玩家在移动，则不吃橘子
        if not Contra.IsMoving and (not Contra.Casting.HasBuff("进食") and not Contra.Casting.HasBuff("喝水")) and UnitMana("player")/UnitManaMax("player") < 0.8 and not UnitAffectingCombat("player") and not UnitAffectingCombat("target") and not Contra.Casting.IsChannel then
            if Contra.HasItem("魔法橘子") then 
                Contra.UseItemByName("魔法橘子")
            elseif Contra.HasItem("魔法晶水") then
                Contra.UseItemByName("魔法晶水")
            end
            Contra.Debug("魔法补充条件，已经补充魔法。","输出")
            return
        end
    end
end

--- @useage 4-自我补充BUFF
function Contra.Mage_Slef_Buff()
    
    if ContraDB.Mage.Buttons.Arcane.AutoBuffToggle and not UnitAffectingCombat("player") and not UnitAffectingCombat("target") then 
        if  not Contra.Casting.HasBuff("魔甲术","player") then
            Contra.MageCast("魔甲术")
            Contra.Debug("符合自动补buff条件，已使用魔甲术","输出")
        end

        --如果自己没有奥术智慧BUFF或者奥术光辉BUFF并且不在战斗中，则释放奥术智慧
        if not Contra.Casting.HasBuff("奥术智慧","player") and not Contra.Casting.HasBuff("奥术光辉","player") then
            Contra.MageCast("奥术智慧")
            Contra.Debug("符合自动补buff条件，已使用魔甲术","输出")
        end
    end

    if ContraDB.Mage.Buttons.Arcane.AutoCreateManaGemsToggle and not UnitAffectingCombat("player") and not UnitAffectingCombat("target") then

        --如果不在战斗中，并且身上没有法力红宝石，则释放制造法力红宝石
        if  not Contra.HasItem("法力红宝石") and not Contra.PlayerIsCasting() then
            CastSpellByName("制造魔法红宝石")
            Contra.Debug("符合自动补buff条件，已使用魔甲术释放制造法力红宝石","输出")
        end

        --如果不在战斗中，并且身上没有法力黄水晶，则释放制造法力黄水晶
        if  not Contra.HasItem("法力黄水晶") and not Contra.PlayerIsCasting() then
            CastSpellByName("制造魔法黄水晶")
            Contra.Debug("符合自动补buff条件，已使用魔甲术释放制造法力黄水晶","输出")
        end
    end

end


--- @useage 5-使用法力恢复道具
function Contra.Mage_Use_Mana_restoration_items()

    --如果玩家在战斗中，并且没有正在施法，并且目标不是团队副本训练假人，并且目标是BOSS，则使用法力恢复道具
    if UnitAffectingCombat("player") and UnitAffectingCombat("target") and not Contra.PlayerIsCasting() and Contra.IsTargetBoss() then

        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具诺达纳尔草药茶
        if Contra.ItemCD("诺达纳尔草药茶") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Arcane.UseHerbsBossNum and ContraDB.Mage.Buttons.Arcane.UseHerbsBossToggle then
            Contra.UseItemByName("诺达纳尔草药茶")
            Contra.Debug("符合BOSS使用道具条件，已使用道具诺达纳尔草药茶","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具法力红宝石
        if Contra.ItemCD("法力红宝石") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Arcane.UseManaGemBossNum and ContraDB.Mage.Buttons.Arcane.UseManaGemBossToggle then
            Contra.UseItemByName("法力红宝石")
            Contra.Debug("符合BOSS使用道具条件，已使用道具法力红宝石","输出")
            return
        end		
        
        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具法力黄水晶
        if Contra.ItemCD("法力黄水晶") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Arcane.UseManaGemBossNum and ContraDB.Mage.Buttons.Arcane.UseManaGemBossToggle then
            Contra.UseItemByName("法力黄水晶")
            Contra.Debug("符合BOSS使用道具条件，已使用道具法力黄水晶","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于2250，则使用道具特效法力药水，并且按住了alt键
        if Contra.ItemCD("特效法力药水") == 0 and UnitManaMax("player") - UnitMana("player") >= 2250 and IsAltKeyDown() then
            Contra.UseItemByName("特效法力药水")
            Contra.Debug("符合BOSS使用道具条件，已使用道具特效法力药水","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于2250，则使用道具特效法力药水，
        if Contra.ItemCD("特效法力药水") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Arcane.UseManaPotionsBossNum and ContraDB.Mage.Buttons.Arcane.UseManaPotionsBossToggle then
            Contra.UseItemByName("特效法力药水")
            Contra.Debug("符合BOSS使用道具条件，已使用道具特效法力药水","输出")
            return
        end

    end

    --如果玩家在战斗中，并且没有正在施法，并且目标不是团队副本训练假人，并且目标是BOSS，则使用法力恢复道具
    if UnitAffectingCombat("player") and UnitAffectingCombat("target") and not Contra.IsTargetBoss() and not Contra.Casting.HasBuff("奥术溃裂","player") and Contra.Filter.rangeThirty("target") then

        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具诺达纳尔草药茶
        if Contra.ItemCD("诺达纳尔草药茶") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Arcane.UseHerbsNotBossNum and ContraDB.Mage.Buttons.Arcane.UseHerbsNotBossToggle then
            Contra.UseItemByName("诺达纳尔草药茶")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具诺达纳尔草药茶","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具法力红宝石
        if Contra.ItemCD("法力红宝石") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Arcane.UseManaGemNotBossNum and ContraDB.Mage.Buttons.Arcane.UseManaGemNotBossToggle then
            Contra.UseItemByName("法力红宝石")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具法力红宝石","输出")
            return
        end
        
        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具法力黄水晶
        if Contra.ItemCD("法力黄水晶") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Arcane.UseManaGemNotBossNum and ContraDB.Mage.Buttons.Arcane.UseManaGemNotBossToggle then
            Contra.UseItemByName("法力黄水晶")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具法力黄水晶","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于2250，则使用道具特效法力药水，并且按住了alt键
        if Contra.ItemCD("特效法力药水") == 0 and UnitManaMax("player") - UnitMana("player") >= 2250 and IsAltKeyDown() then
            Contra.UseItemByName("特效法力药水")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具特效法力药水","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于2250，则使用道具特效法力药水，
        if Contra.ItemCD("特效法力药水") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Arcane.UseManaPotionsNotBossNum and ContraDB.Mage.Buttons.Arcane.UseManaPotionsNotBossToggle then
            Contra.UseItemByName("特效法力药水")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具特效法力药水","输出")
            return
        end

    end

end

--- @useage 6-使用饰品
function Contra.Mage_Use_Trinket()

    if UnitAffectingCombat("player") and UnitAffectingCombat("target") and Contra.Filter.rangeThirty("target") then


        if ContraDB.Mage.Buttons.Arcane.Use13SoltBossToggle and Contra.IsTargetBoss() and Contra.Casting.HasBuff("奥术溃裂","player") and Contra.Filter.rangeThirty("target") then
            Contra.UseItem(13)
            Contra.Debug("符合BOSS使用13号饰品条件，已使用道具13号饰品","输出")
        end
        if ContraDB.Mage.Buttons.Arcane.Use14SoltBossToggle and Contra.IsTargetBoss() and Contra.Casting.HasBuff("奥术溃裂","player") and Contra.Filter.rangeThirty("target") then
            Contra.UseItem(14)
            Contra.Debug("符合BOSS使用14号饰品条件，已使用道具14号饰品","输出")
        end
        if ContraDB.Mage.Buttons.Arcane.Use13SoltNotBossToggle and not Contra.IsTargetBoss() and Contra.Filter.rangeThirty("target") then
            Contra.UseItem(13)
            Contra.Debug("符合非BOSS使用13号饰品条件，已使用道具13号饰品","输出")
        end
        if ContraDB.Mage.Buttons.Arcane.Use14SlotNotBossToggle and not Contra.IsTargetBoss() and Contra.Filter.rangeThirty("target") then
            Contra.UseItem(14)
            Contra.Debug("符合非BOSS使用14号饰品条件，已使用道具14号饰品","输出")
        end

    end

end

--- @useage 7-使用种族天赋
function Contra.Mage_Use_Race_Talent()

    if ContraDB.Mage.Buttons.Arcane.RaceTalentsToggle and UnitAffectingCombat("player") and UnitAffectingCombat("target") and Contra.Filter.rangeThirty("target") then

        if Contra.MyRace == "兽人" then Contra.MageCast("血性狂怒")     end
        if Contra.MyRace == "人类" then Contra.MageCast("感知")         end
        if Contra.MyRace == "巨魔" then Contra.MageCast("狂暴")         end

        Contra.Debug("符合使用种族天赋条件，已使用种族天赋","输出")
    end

end

--- @useage 7-周围怪物数量大于等于指定值时，使用魔爆术
function Contra.Mage_UseArcaneBlast()
        --自动使用魔爆术
    if ContraDB.Mage.Buttons.Arcane.UseAoEToggle and Contra.Filter.CountAttackableUnitsInRangeTen() >= ContraDB.Mage.Buttons.Arcane.UseAoEEnemyNum then
		if nampower then
			NP_QueueChannelingSpells = GetCVar("NP_QueueChannelingSpells")
			if NP_QueueChannelingSpells ~= 0 then
				SetCVar("NP_QueueChannelingSpells", 0)
			end
		end

		CastSpellByName("魔爆术")
        Contra.Debug("符合使用魔爆术条件，已使用魔爆术","输出")

		if nampower then
			SetCVar("NP_QueueChannelingSpells", NP_QueueChannelingSpells)
		end
		return true
	end

    return false
    
end

--- @useage 8-使用火焰冲击
function Contra.Fire_Blast()

    if ContraDB.Mage.Buttons.Arcane.FireballToggle and UnitAffectingCombat("target") and Contra.CD("火焰冲击") == 0 then

        if Contra.Casting.IsChannel and UnitHealth("target") <= ContraDB.Mage.Buttons.Arcane.FireballHealthNum then 
            local count, mod, nextCastTime = Contra.GetArcaneMissilesTime()
            if count >= 2 and nextCastTime > 0.5 and mod > 0.1  then
                Contra.MageCast("火焰冲击", "stopCasting")
            end
        end

        if Contra.Casting.guids[Contra.Guids.MyGuid] and Contra.Casting.guids[Contra.Guids.MyGuid].spellID == 51954 and GetTime() - Contra.Casting.guids[Contra.Guids.MyGuid].startTime < 1.5 and UnitHealth("target") <= ContraDB.Mage.Buttons.Arcane.FireballHealthNum then
            Contra.MageCast("火焰冲击", "stopCasting")
        end
		
        if not Contra.PlayerIsCasting() then
            if Contra.IsMoving or UnitHealth("target") <= ContraDB.Mage.Buttons.Arcane.FireballHealthNum then
                Contra.MageCast("火焰冲击")
            end
        end
	end

end

--- @useage 9-使用奥术涌动
function Contra.Arcane_Barrage()
    --  ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIsMovingToogle = true,               -- 移动时使用奥术涌动选择框
    --  ContraDB.Mage.Buttons.Arcane.ArcaneSurgeHealthNum = 5000,                    -- 怪物血量小于多少时使用奥术涌动拖动条，范围1000-10000				
    --  ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIsCDToggle = false,                  -- 溃裂CD时使用奥术涌动选择框
    --  ContraDB.Mage.Buttons.Arcane.ArcaneSurgeNotBuffToggle = true,      -- 溃裂CD无溃裂BUFF时使用奥术涌动选择框
    --  ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIntruptToggle = true,                -- 打断奥术飞弹释放涌动

    --移动中施放
    if ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIsMovingToogle and Contra.IsMoving then
        Contra.MageCast("奥术涌动")
    end

    --少于指定血量，非施法状态施放
    if ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIsMovingToogle and ContraDB.Mage.Buttons.Arcane.ArcaneSurgeHealthNum >= UnitHealth("target") and not Contra.PlayerIsCasting then
        Contra.MageCast("奥术涌动")
    end

    --少于指定血量，施法状态施放
    if ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIsMovingToogle and ContraDB.Mage.Buttons.Arcane.ArcaneSurgeHealthNum >= UnitHealth("target") and not Contra.PlayerIsCasting then
        local _, swmjTime = Contra.Casting.HasBuff("思维敏捷","player")
        if swmjTime > 0 and swmjTime < 2 then
            Contra.MageCast("奥术涌动", "stopCasting")
        end
    end

    --
    if ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIsCDToggle and Contra.CD("奥术亏列") ~= 0 then return end

    if ContraDB.Mage.Buttons.Arcane.ArcaneSurgeNotBuffToggle and Contra.Casting.HasBuff("奥术强化","player") then return end

    if not ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIntruptToggle and Contra.Casting.IsChannel then return end

    if not Contra.PlayerIsCasting then  Contra.MageCast("奥术涌动") end

    if Contra.PlayerIsCasting then
        local _, swmjTime = Contra.Casting.HasBuff("思维敏捷","player")
        if swmjTime > 0 and swmjTime < 2 then
            Contra.MageCast("奥术涌动", "stopCasting")
        end
    end
end

--- @useage 10-使用气定神闲
function Contra.Mage_Presence_of_Mind()

    if ContraDB.Mage.Buttons.Arcane.PresenceOfMindToggle then
        if Contra.CD("气定神闲") == 0 and UnitAffectingCombat("target") and UnitAffectingCombat("player") and Contra.Filter.rangeThirty("target") then
            Contra.MageCast("气定神闲")
        end
    end

end

--- @useage 11-使用奥术强化
function Contra.Arcane_Power()
    if not Contra.CD("奥术强化") == 0 or not UnitAffectingCombat("player")  or not UnitAffectingCombat("target") then
        return
    end
    --如果装备了思维加速宝石，并且对应栏位的自动使用饰品处于激活状态
    if Contra.HasEquipItem("思维加速宝石") and ((Contra.GetItemType(13, 1) == "思维加速宝石" and ContraDB.Mage.Buttons.Arcane.Use13SoltBossToggle) or (Contra.GetItemType(14, 1) == "思维加速宝石" and ContraDB.Mage.Buttons.Arcane.Use14SoltBossToggle)) then
        --如果思维加速宝石CD中
        if not (ContraDB.Mage.Buttons.Arcane.ArcanePowerBossToggle and Contra.IsTargetBoss() or (ContraDB.Mage.Buttons.Arcane.ArcanePowerNotBossToggle and not Contra.IsTargetBoss())) then return end

        if  (Contra.GetItemType(13, 1) == "思维加速宝石" and Contra.EquipCD(13) > 0) or (Contra.GetItemType(14, 1) == "思维加速宝石" and Contra.EquipCD(14) > 0) then
            local _, swmjTime = Contra.Casting.HasBuff("思维敏捷","player")
            if swmjTime > 0 and swmjTime < 2 then
                Contra.MageCast("奥术强化", "stopCasting")
            end
            if swmjTime == 0 and (Contra.GetItemType(13, 1) == "思维加速宝石" and Contra.EquipCD(13) > 20) or  (Contra.GetItemType(14, 1) == "思维加速宝石" and Contra.EquipCD(14) > 20) then
                Contra.MageCast("奥术强化")
            end
        end
    --如果没有装备思维加速宝石，或者对应栏位的自动使用饰品处于未激活状态    
    else
        if ContraDB.Mage.Buttons.Arcane.ArcanePowerBossToggle and Contra.IsTargetBoss() and UnitMana("player")/UnitManaMax("player") > ContraDB.Mage.Buttons.Arcane.ArcanePowerManaPercNum/100 and Contra.Casting.HasBuff("奥术溃裂") then
            Contra.MageCast("奥术强化")
        end

        if ContraDB.Mage.Buttons.Arcane.ArcanePowerNotBossToggle and not Contra.IsTargetBoss() and UnitMana("player")/UnitManaMax("player") > ContraDB.Mage.Buttons.Arcane.ArcanePowerManaPercNum/100 and Contra.Filter.GetTotalHealthOfAttackableUnits() >= ContraDB.Mage.Buttons.Arcane.ArcanePowerNotBossHealthNum and Contra.Casting.HasBuff("奥术溃裂")then
            Contra.MageCast("奥术强化")
        end
    end
end

--- @useage 12-使用奥术溃裂
function Contra.Mage_ArcaneExplosion()
    --非敌对目标时，返回
    if not Contra.Filter.Attackable("target") then return end

    --目标不是boss时
    if Contra.CD("奥术溃裂") == 0 and not Contra.Casting.HasBuff("奥术溃裂","player") then
        if Contra.Casting.IsChannel then 
            local count, mod, nextCastTime = Contra.GetArcaneMissilesTime()
            if count >= 2 and nextCastTime > 0.5 and mod > 0.1 then
                Contra.MageCast("奥术溃裂", "stopCasting")
            end
        else
            Contra.MageCast("奥术溃裂")
        end
    end
end




--- @useage 13-使用奥术飞弹
function Contra.Arcane_Missiles()
    --如果目标在战斗中，并且玩家不在施法中，则释放奥术飞弹
    if  UnitAffectingCombat("target") and not Contra.PlayerIsCasting() then
        Contra.MageCast("奥术飞弹")
    end
end

function Contra.SwapTrinkets()
    -- 如果solt对应的饰品栏无饰品或者饰品正在CD中
    if event == "PLAYER_ENTERING_WORLD" then
        if Contra.MyClass ~= "法师" then 
            Contra.MageTrinketManager:UnregisterEvent("PLAYER_ENTERING_WORLD")
            Contra.MageTrinketManager:UnregisterEvent("PLAYER_REGEN_ENABLED")
            Contra.MageTrinketManager:SetScript("OnEvent", nil)
            Contra.MageTrinketManager = nil
        end
    end
    if event ~= "PLAYER_REGEN_ENABLED" then return end
    if ContraDB.Mage.Buttons.Arcane.Change13SlotToggle then 
        local _, _, trinketCanBeUsed = GetInventoryItemCooldown("player",13)
        if not GetInventoryItemLink("player",13) or Contra.EquipCD(13) > 30 or trinketCanBeUsed == 0 then
            -- 如果没有配置该职业的饰品列表，或者该职业的饰品列表为空
            if not Contra.OnUseTrinketList[Contra.MyClass] then return end
            --遍历Contra.OnUseTrinketList[Contra.MyClass],找到第一个CD为0的饰品
            for _, trinket in ipairs(Contra.OnUseTrinketList[Contra.MyClass]) do
                local trinketCD = Contra.ItemCD(trinket)
                if trinketCD <= 30 then
                    --使用该饰品
                    Contra.UseItemByName(trinket)
                    return
                end
            end
            --遍历Contra.PassiveTrinketList[Contra.MyClass],找到第一个CD为0的饰品
            for _, trinket in ipairs(Contra.PassiveTrinketList[Contra.MyClass]) do
                if trinket then
                    --使用该饰品
                    Contra.UseItemByName(trinket)
                    return
                end
            end
        end
    end
    if ContraDB.Mage.Buttons.Arcane.Change14SlotToggle then 
        local _, _, trinketCanBeUsed = GetInventoryItemCooldown("player",14)
        if not GetInventoryItemLink("player",14) or Contra.EquipCD(14) > 30 or trinketCanBeUsed == 0 then
            -- 如果没有配置该职业的饰品列表，或者该职业的饰品列表为空
            if not Contra.OnUseTrinketList[Contra.MyClass] then return end
            --遍历Contra.OnUseTrinketList[Contra.MyClass],找到第一个CD为0的饰品
            for _, trinket in ipairs(Contra.OnUseTrinketList[Contra.MyClass]) do
                local trinketCD = Contra.ItemCD(trinket)
                if trinketCD <= 30 then
                    --使用该饰品
                    PickupContainerItem(Contra.HasItem(trinket))
                    PickupInventoryItem(14)
                    return
                end
            end
            --遍历Contra.PassiveTrinketList[Contra.MyClass],找到第一个CD为0的饰品
            for _, trinket in ipairs(Contra.PassiveTrinketList[Contra.MyClass]) do
                if trinket then
                    --使用该饰品
                    PickupContainerItem(Contra.HasItem(trinket))
                    PickupInventoryItem(14)
                    return
                end
            end
        end
    end
end

Contra.MageTrinketManager = CreateFrame("Frame", "ContraTrinketManager", UIParent)
Contra.MageTrinketManager:RegisterEvent("PLAYER_REGEN_ENABLED")
Contra.MageTrinketManager:RegisterEvent("PLAYER_ENTERING_WORLD")
Contra.MageTrinketManager:SetScript("OnEvent", Contra.SwapTrinkets)





--- @useage 奥法一键输出
function Contra.Mage_Arcane()

    -- 不在团队中
    if not Contra.InRaid()  then
        if UnitName("target") ~= "团队副本训练假人" and UnitName("target") ~= "训练假人" and UnitName("target") ~= "学徒训练假人" then
            Contra.Mage_NotInRaid()
            return
        end
    end

    --使用有限无敌
    Contra.Mage_Use_Infinite_Immunity()

    --选择目标
    Contra.Mage_Select_Target()

    --自动 buff
    Contra.Mage_Slef_Buff()

    --自动吃橘子
    Contra.Mage_Eat_Orange()

    --自动使用法力恢复物品
    Contra.Mage_Use_Mana_restoration_items()

    --使用饰品
    Contra.Mage_Use_Trinket()

    --使用种族天赋
    Contra.Mage_Use_Race_Talent()

    --周围怪物数量大于等于4时，使用魔爆术
    if Contra.Mage_UseArcaneBlast() then return end

    --使用奥术涌动
    Contra.Arcane_Barrage()

    --使用火焰冲击
    Contra.Fire_Blast()

    --使用气定神闲
    Contra.Mage_Presence_of_Mind()

    -- 奥术强化
    Contra.Arcane_Power()
    
    --使用奥术溃裂
    Contra.Mage_ArcaneExplosion()

    --使用奥术飞弹
    Contra.Arcane_Missiles()

end



function Contra.Mage_Fire()

    --使用有限无敌
    Contra.Mage_Use_Infinite_Immunity()

    --选择目标
    Contra.Mage_Select_Target()

    --自动 buff
    Contra.Mage_Slef_Buff()

    --自动吃橘子
    Contra.Mage_Eat_Orange()

    --自动使用法力恢复物品
    Contra.Mage_Use_Mana_restoration_items()

    --使用饰品
    Contra.Mage_Use_Trinket(13)

    --周围怪物数量大于等于4时，使用魔爆术
    Contra.Mage_UseArcaneBlast()

    -- 周围所有怪物血量之和大于50000则释放燃烧
    if Contra.Filter.GetTotalHealthOfAttackableUnits() > 50000 and Contra.Casting.HasBuff("点燃","target") then
        Contra.MageCast("燃烧")
    end

    -- 目标血量少于5000且技能冷却时间小于0则释放火焰冲击
    if UnitHealth("target") < 5000 and Contra.CD("火焰冲击") == 0 then
        Contra.MageCast("火焰冲击")
    end

    -- 灼烧
    --如果目标是BOSS，并且火焰易伤BUFF小于5层，则释放灼烧
    if Contra.IsTargetBoss() and Contra.GetBuffCount("火焰易伤","target") < 5 then
        Contra.MageCast("灼烧")
    end
    -- 当目标的血量大于10000且技能小于20000且（火球术或者炎爆术的施法剩余时间大于2秒）则打断施法
    if UnitHealth("target") < 30000 and  UnitHealth("target") > 10000 and ( Contra.SpellCsatLeftTime(25306) > 2 or Contra.SpellCsatLeftTime(5940) > 2) then
        SpellStopCasting()
    end
    --如果目标血量少于20000并且不在施法则释放灼烧
    if UnitHealth("target") < 30000 and not Contra.PlayerIsCasting() then
        Contra.MageCast("灼烧")
    end
    --如果目标身上有点燃buff并且点燃层数大于3则释放灼烧
    if Contra.Casting.HasBuff("点燃","target") and Contra.GetBuffCount("点燃","target") >= 3 then
        Contra.MageCast("灼烧")
    end

    -- 炎爆术
    --如果有法术连击BUFF，并且法术连击BUFF的层数等于3，并且目标身上没有点燃BUFF，则释放炎爆术
    if Contra.Casting.HasBuff("法术连击","player") and Contra.GetBuffCount("法术连击","player") >= 3 then
        Contra.MageCast("炎爆术")
    end

    --如果有法术连击BUFF，并且法术连击BUFF的层数大于3，并且目标身上有点燃BUFF，并且目标的点燃BUFF的层数大于3，则释放炎爆术
    if Contra.Casting.HasBuff("法术连击","player") and Contra.GetBuffCount("法术连击","player") > 3 and Contra.Casting.HasBuff("点燃","target") and Contra.GetBuffCount("点燃","target") > 3 then
        Contra.MageCast("炎爆术")
    end
    --如果有法术连击BUFF，并且法术连击BUFF的层数等于5，则释放炎爆术
    if Contra.Casting.HasBuff("法术连击","player") and Contra.GetBuffCount("法术连击","player") == 5 then
        Contra.MageCast("炎爆术")
    end

    Contra.MageCast("火球术")


end

---@useage 免疫冰冻名称收集
Contra.Mage_ImmuneToFrostCollectFrame =  CreateFrame("Frame")
Contra.Mage_ImmuneToFrostCollectFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
Contra.Mage_ImmuneToFrostCollectFrame:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE")
Contra.Mage_ImmuneToFrostCollectFrame:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
Contra.Mage_ImmuneToFrostCollectFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")

Contra.Mage_ImmuneToFrostCollectFrame:SetScript("OnEvent", function()
    --你的冰霜新星施放失败。XX对此免疫。
    local msg = arg1
    local name = ""
    if string.find(msg, "冰霜新星施放失败。(.+)对此免疫。") 
    or string.find(msg, "霜寒刺骨施放失败。(.+)对此免疫。") then
        name = string.match(msg, "冰霜新星施放失败。(.+)对此免疫。") or string.match(msg, "霜寒刺骨施放失败。(.+)对此免疫。")
        if name and name ~= "" then
            if not ContraDB.Mage.ImmuneToFrost then
                ContraDB.Mage.ImmuneToFrost = {}
            end
            if not ContraDB.Mage.ImmuneToFrost[name] then
                ContraDB.Mage.ImmuneToFrost[name] = 2
            end
        end
    end
    if string.find(msg, "受到了霜寒刺骨效果的影响") 
    or string.find(msg, "受到了冰霜新星效果的影响") then
        name = string.match(msg, "(.+)受到了霜寒刺骨效果的影响") or string.match(msg, "(.+)受到了冰霜新星效果的影响")
        if name and name ~= "" then
            if not ContraDB.Mage.ImmuneToFrost then
                ContraDB.Mage.ImmuneToFrost = {}
            end
            if not ContraDB.Mage.ImmuneToFrost[name] then
                ContraDB.Mage.ImmuneToFrost[name] = 1
            end
        end
    end

end)


-- ContraDB.Mage.Buttons.Frost.UseManaPotionsBossToggle = true,                -- 使用法力药水选择框
-- ContraDB.Mage.Buttons.Frost.UseManaPotionsBossNum = 2250,                   -- 法力缺失大于等于多少时使用法力药水拖动条，范围1000-10000
-- ContraDB.Mage.Buttons.Frost.UseHerbsBossToggle = true,                      -- 使用草药茶选择框
-- ContraDB.Mage.Buttons.Frost.UseHerbsBossNum = 1350,                         -- 法力缺失大于等于多少时使用草药茶拖动条，范围1000-10000
-- ContraDB.Mage.Buttons.Frost.UseManaGemBossToggle = true,                    -- 使用法力宝石选择框
-- ContraDB.Mage.Buttons.Frost.UseManaGemBossNum = 1350,                       -- 法力缺失大于等于多少时使用法力宝石拖动条，范围1000-10000
-- ContraDB.Mage.Buttons.Frost.UseInvulnerabilityBossToggle = true,            -- 使用有限无敌选择框

-- ContraDB.Mage.Buttons.Frost.UseManaPotionsNotBossToggle = false,            -- 使用法力药水选择框
-- ContraDB.Mage.Buttons.Frost.UseManaPotionsNotBossNum = 2250,                -- 法力缺失大于等于多少时使用法力药水拖动条，范围1000-10000
-- ContraDB.Mage.Buttons.Frost.UseHerbsNotBossToggle = false,                  -- 使用草药茶选择框
-- ContraDB.Mage.Buttons.Frost.UseHerbsNotBossNum = 1350,                      -- 法力缺失大于等于多少时使用草药茶拖动条，范围1000-10000
-- ContraDB.Mage.Buttons.Frost.UseManaGemNotBossToggle = false,                -- 使用法力宝石选择框
-- ContraDB.Mage.Buttons.Frost.UseManaGemNotBossNum = 1350,                    -- 法力缺失大于等于多少时使用法力宝石拖动条，范围1000-10000
-- ContraDB.Mage.Buttons.Frost.UseInvulnerabilityBossToggle = true,            -- 使用有限无敌选择框
-- ContraDB.Mage.Buttons.Frost.UseInvulnerabilityNotBossToggle = false,        -- 使用有限无敌选择框
-- ContraDB.Mage.Buttons.Frost.UseInvulnerabilityNotBossPercNum = 50,			-- AOE场景使用有限无敌的血量百分比

-- -- 基础开关
-- ContraDB.Mage.Buttons.Frost.AutoSelectTargetToggle = true,                  -- 自动选择目标选择框
-- ContraDB.Mage.Buttons.Frost.AutoSelectTargetHealthChangeToggle = true,      -- 自动选择目标血量小于多少时自动选择目标选择框
-- ContraDB.Mage.Buttons.Frost.AutoSelectTargetHealthChangeNum = 5000,         -- 自动选择目标血量小于多少时自动选择目标拖动条，范围1000-10000
-- ContraDB.Mage.Buttons.Frost.AutoBuffToggle = true,                          -- 自动补BUFF选择框
-- ContraDB.Mage.Buttons.Frost.AutoCreateManaGemsToggle = true,                -- 自动制造法力宝石选择框
-- ContraDB.Mage.Buttons.Frost.AutoEatOrange = true,                           -- 自动吃橘子选择框

-- -- 技能开关
-- ContraDB.Mage.Buttons.Frost.IceShieldToggle = true,							-- 冰盾启用开关
-- ContraDB.Mage.Buttons.Frost.IceShieldPercent = 50,							-- 切换为1级冰盾的当前魔法值百分比
-- ContraDB.Mage.Buttons.Frost.ConeofColdToggle = true,						    -- 冰锥启用开关
-- ContraDB.Mage.Buttons.Frost.ConeofColdPercent = 50,							-- 切换为1级冰锥的当前魔法值百分比

-- ContraDB.Mage.Buttons.Frost.UseAoEToggle = true,                            -- 魔爆术选择框
-- ContraDB.Mage.Buttons.Frost.UseAoEEnemyNum = 4,                             -- 魔爆术小怪数量拖动条值，范围3-5

-- ContraDB.Mage.Buttons.Frost.FireballToggle = true,                          -- 火焰冲击选择框
-- ContraDB.Mage.Buttons.Frost.FireballHealthNum = 5000,                       -- 怪物血量小于多少时使用火焰冲击拖动条，范围1000-50000

-- ContraDB.Mage.Buttons.Frost.ArcaneSurgeIsMovingToogle = true,               -- 移动时使用奥术涌动选择框
-- ContraDB.Mage.Buttons.Frost.ArcaneSurgeHealthNum = 5000,                    -- 怪物血量小于多少时使用奥术涌动拖动条，范围1000-10000				

-- ContraDB.Mage.Buttons.Frost.StopCastingToggle = true,						-- 打断寒冰箭，施放冰柱
-- ContraDB.Mage.Buttons.Frost.StopCastingTimeNum = 0.5,						-- 寒冰箭读条剩余时间大于此值时打断

-- ContraDB.Mage.Buttons.Frost.RaceTalentsToggle = true,						-- 种族天赋选择框
-- ContraDB.Mage.Buttons.Frost.ColdSnapBossToggle = true,						-- BOSS战使用极速冷却

-- -- 饰品
-- ContraDB.Mage.Buttons.Frost.Use13SoltBossToggle = true,                     -- Boss使用上饰品开关
-- ContraDB.Mage.Buttons.Frost.Use14SlotBossToggle = true,                     -- Boss使用下饰品开关
-- ContraDB.Mage.Buttons.Frost.Use13SoltNotBossToggle = true,                  -- 非Boss使用上饰品开关
-- ContraDB.Mage.Buttons.Frost.Use14SlotNotBossToggle = false,                 -- 非Boss使用下饰品开关

-- ContraDB.Mage.Buttons.Frost.Change13SlotToggle = true,                      -- 切换上饰品选择框
-- ContraDB.Mage.Buttons.Frost.Change14SlotToggle = false,                     -- 切换下饰品选择框



--- @useage 1-自动使用有限无敌
function Contra.Mage_Frost_Use_Infinite_Immunity()

    if Contra.ItemCD("有限无敌药水") == 0 then
        -- 如果在战斗中，目标是BOSS，目标的目标是自己，则使用有限无敌，并大喊
        if ContraDB.Mage.Buttons.Frost.UseInvulnerabilityBossToggle and UnitAffectingCombat("player") and Contra.IsTargetBoss() and UnitName("targettarget") == UnitName("player") and UnitName("targettarget") ~= "拉格纳罗斯"  then
            Contra.UseItemByName("有限无敌药水")
            SendChatMessage(UnitName("target").."的目标是我，我已使用有限无敌", "SAY")
            Contra.Debug("符合BOSS使用有限无敌模式，已使用有限无敌药水","输出")
        end

        -- 如果周围目标大于等于4个，并且自身血量小于50%，并且在战斗中的敌对单位的目标是自己的数量大于等于1，则使用有限无敌药水
        if ContraDB.Mage.Buttons.Frost.UseInvulnerabilityNotBossToggle and ContraDB.Mage.Buttons.Frost.UseAoEToggle and Contra.Filter.CountAttackableUnitsInRangeTen() >= ContraDB.Mage.Buttons.Frost.UseAoEEnemyNum and UnitHealth("player")/UnitHealthMax("player") < 0.5  then
            Contra.UseItemByName("有限无敌药水")
            Contra.Debug("符合非BOSS使用有限无敌模式，已使用有限无敌药水","输出")
        end
    end

end

--- @useage 2-自动选目标
function Contra.Mage_Frost_Select_Target()

    if ContraDB.Mage.Buttons.Frost.AutoSelectTargetToggle and Contra.Filter.infight("player") then
        -- 正常切换目标
        if not UnitExists("target") or UnitIsDeadOrGhost("target") or UnitIsFriend("player", "target") or Contra.Casting.HasBuff("放逐术","target") then
		    local unit = Contra.Filter.FindClosestInfightUnit()
            if unit then
                TargetUnit(unit)
            end
        end
        -- 斩杀阶段火铳CD切目标
        if Contra.CD("火焰冲击") > 0 and UnitHealth("target") < 5000 then
            local unit = Contra.Filter.FindClosestInfightUnit()
            if unit then
                TargetUnit(unit)
            end
        end
	end

end

--- @useage 3-自动吃橘子
function Contra.Mage_Frost_Eat_Orange()
    if ContraDB.Mage.Buttons.Frost.AutoEatOrange then
        --如果玩家在移动，则不吃橘子
        if not Contra.IsMoving and (not Contra.Casting.HasBuff("进食") and not Contra.Casting.HasBuff("喝水")) and UnitMana("player")/UnitManaMax("player") < 0.8 and not UnitAffectingCombat("player") and not UnitAffectingCombat("target") and not Contra.Casting.IsChannel then
            if Contra.HasItem("魔法橘子") then 
                Contra.UseItemByName("魔法橘子")
            elseif Contra.HasItem("魔法晶水") then
                Contra.UseItemByName("魔法晶水")
            end
            Contra.Debug("魔法补充条件，已经补充魔法。","输出")
            return
        end
    end
end

--- @useage 4-自我补充BUFF
function Contra.Mage_Frost_Self_Buff()
    
    if ContraDB.Mage.Buttons.Frost.AutoBuffToggle and not UnitAffectingCombat("player") and not UnitAffectingCombat("target") then 
        if  not Contra.Casting.HasBuff("魔甲术","player") then
            Contra.MageCast("魔甲术")
            Contra.Debug("符合自动补buff条件，已使用魔甲术","输出")
        end

        --如果自己没有奥术智慧BUFF或者奥术光辉BUFF并且不在战斗中，则释放奥术智慧
        if not Contra.Casting.HasBuff("奥术智慧","player") and not Contra.Casting.HasBuff("奥术光辉","player") then
            Contra.MageCast("奥术智慧")
            Contra.Debug("符合自动补buff条件，已使用魔甲术","输出")
        end
    end

    if ContraDB.Mage.Buttons.Frost.AutoCreateManaGemsToggle and not UnitAffectingCombat("player") and not UnitAffectingCombat("target") then

        --如果不在战斗中，并且身上没有法力红宝石，则释放制造法力红宝石
        if  not Contra.HasItem("法力红宝石") and not Contra.PlayerIsCasting() then
            CastSpellByName("制造魔法红宝石")
            Contra.Debug("符合自动补buff条件，已使用魔甲术释放制造法力红宝石","输出")
        end

        --如果不在战斗中，并且身上没有法力黄水晶，则释放制造法力黄水晶
        if  not Contra.HasItem("法力黄水晶") and not Contra.PlayerIsCasting() then
            CastSpellByName("制造魔法黄水晶")
            Contra.Debug("符合自动补buff条件，已使用魔甲术释放制造法力黄水晶","输出")
        end
    end

end

--- @useage 5-使用法力恢复道具
function Contra.Mage_Frost_Use_Mana_restoration_items()

    --如果玩家在战斗中，并且没有正在施法，并且目标不是团队副本训练假人，并且目标是BOSS，则使用法力恢复道具
    if UnitAffectingCombat("player") and UnitAffectingCombat("target") and not Contra.PlayerIsCasting() and Contra.IsTargetBoss() then

        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具诺达纳尔草药茶
        if Contra.ItemCD("诺达纳尔草药茶") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Frost.UseHerbsBossNum and ContraDB.Mage.Buttons.Frost.UseHerbsBossToggle then
            Contra.UseItemByName("诺达纳尔草药茶")
            Contra.Debug("符合BOSS使用道具条件，已使用道具诺达纳尔草药茶","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具法力红宝石
        if Contra.ItemCD("法力红宝石") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Frost.UseManaGemBossNum and ContraDB.Mage.Buttons.Frost.UseManaGemBossToggle then
            Contra.UseItemByName("法力红宝石")
            Contra.Debug("符合BOSS使用道具条件，已使用道具法力红宝石","输出")
            return
        end		
        
        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具法力黄水晶
        if Contra.ItemCD("法力黄水晶") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Frost.UseManaGemBossNum and ContraDB.Mage.Buttons.Frost.UseManaGemBossToggle then
            Contra.UseItemByName("法力黄水晶")
            Contra.Debug("符合BOSS使用道具条件，已使用道具法力黄水晶","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于2250，则使用道具特效法力药水，并且按住了alt键
        if Contra.ItemCD("特效法力药水") == 0 and UnitManaMax("player") - UnitMana("player") >= 2250 and IsAltKeyDown() then
            Contra.UseItemByName("特效法力药水")
            Contra.Debug("符合BOSS使用道具条件，已使用道具特效法力药水","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于2250，则使用道具特效法力药水，
        if Contra.ItemCD("特效法力药水") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Frost.UseManaPotionsBossNum and ContraDB.Mage.Buttons.Frost.UseManaPotionsBossToggle then
            Contra.UseItemByName("特效法力药水")
            Contra.Debug("符合BOSS使用道具条件，已使用道具特效法力药水","输出")
            return
        end

    end

    --如果玩家在战斗中，并且没有正在施法，并且目标不是团队副本训练假人，并且目标是BOSS，则使用法力恢复道具
    if UnitAffectingCombat("player") and UnitAffectingCombat("target") and not Contra.IsTargetBoss() and not Contra.Casting.HasBuff("奥术溃裂","player") and Contra.Filter.rangeThirty("target") then

        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具诺达纳尔草药茶
        if Contra.ItemCD("诺达纳尔草药茶") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Frost.UseHerbsNotBossNum and ContraDB.Mage.Buttons.Frost.UseHerbsNotBossToggle then
            Contra.UseItemByName("诺达纳尔草药茶")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具诺达纳尔草药茶","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具法力红宝石
        if Contra.ItemCD("法力红宝石") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Frost.UseManaGemNotBossNum and ContraDB.Mage.Buttons.Frost.UseManaGemNotBossToggle then
            Contra.UseItemByName("法力红宝石")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具法力红宝石","输出")
            return
        end
        
        --如果最大魔法值减去当前魔法值大于等于1350，则使用道具法力黄水晶
        if Contra.ItemCD("法力黄水晶") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Frost.UseManaGemNotBossNum and ContraDB.Mage.Buttons.Frost.UseManaGemNotBossToggle then
            Contra.UseItemByName("法力黄水晶")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具法力黄水晶","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于2250，则使用道具特效法力药水，并且按住了alt键
        if Contra.ItemCD("特效法力药水") == 0 and UnitManaMax("player") - UnitMana("player") >= 2250 and IsAltKeyDown() then
            Contra.UseItemByName("特效法力药水")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具特效法力药水","输出")
            return
        end

        --如果最大魔法值减去当前魔法值大于等于2250，则使用道具特效法力药水，
        if Contra.ItemCD("特效法力药水") == 0 and UnitManaMax("player") - UnitMana("player") >= ContraDB.Mage.Buttons.Frost.UseManaPotionsNotBossNum and ContraDB.Mage.Buttons.Frost.UseManaPotionsNotBossToggle then
            Contra.UseItemByName("特效法力药水")
            Contra.Debug("符合非BOSS使用道具条件，已使用道具特效法力药水","输出")
            return
        end

    end

end

--- @useage 6-使用饰品
function Contra.Mage_Frost_Use_Trinket()

    if UnitAffectingCombat("player") and UnitAffectingCombat("target") and Contra.Filter.rangeThirty("target") then


        if ContraDB.Mage.Buttons.Frost.Use13SoltBossToggle and Contra.IsTargetBoss() and Contra.Casting.HasBuff("奥术溃裂","player") and Contra.Filter.rangeThirty("target") then
            Contra.UseItem(13)
            Contra.Debug("符合BOSS使用13号饰品条件，已使用道具13号饰品","输出")
        end
        if ContraDB.Mage.Buttons.Frost.Use14SoltBossToggle and Contra.IsTargetBoss() and Contra.Casting.HasBuff("奥术溃裂","player") and Contra.Filter.rangeThirty("target") then
            Contra.UseItem(14)
            Contra.Debug("符合BOSS使用14号饰品条件，已使用道具14号饰品","输出")
        end
        if ContraDB.Mage.Buttons.Frost.Use13SoltNotBossToggle and not Contra.IsTargetBoss() and Contra.Filter.rangeThirty("target") then
            Contra.UseItem(13)
            Contra.Debug("符合非BOSS使用13号饰品条件，已使用道具13号饰品","输出")
        end
        if ContraDB.Mage.Buttons.Frost.Use14SoltNotBossToggle and not Contra.IsTargetBoss() and Contra.Filter.rangeThirty("target") then
            Contra.UseItem(14)
            Contra.Debug("符合非BOSS使用14号饰品条件，已使用道具14号饰品","输出")
        end

    end

end

--- @useage 7-使用种族天赋
function Contra.Mage_Frost_Use_Race_Talent()

    if ContraDB.Mage.Buttons.Frost.RaceTalentsToggle and UnitAffectingCombat("player") and UnitAffectingCombat("target") and Contra.Filter.rangeThirty("target") then

        if Contra.MyRace == "兽人" then Contra.MageCast("血性狂怒")     end
        if Contra.MyRace == "人类" then Contra.MageCast("感知")         end
        if Contra.MyRace == "巨魔" then Contra.MageCast("狂暴")         end

        Contra.Debug("符合使用种族天赋条件，已使用种族天赋","输出")
    end

end

--- @useage 8-使用冰柱
function Contra.Mage_Frost_FrostBolt02() 
    --如果有冰霜速冻buff
    if Contra.Casting.HasBuff("冰霜速冻","player") then
        --如果不在施法，则释放冰柱
        if not Contra.PlayerIsCasting() then
            Contra.MageCast("冰柱")
        end
        if Contra.PlayerIsCasting() then
            if ContraDB.Mage.Buttons.Frost.StopCastingToggle then 
                if Contra.Casting.guids[Contra.Guids.MyGuid] and Contra.Casting.guids[Contra.Guids.MyGuid].spellID == 25304 and (2.5-(GetTime() - Contra.Casting.guids[Contra.Guids.MyGuid].startTime)) < 1.5 then
                    Contra.MageCast("冰柱")
                end
            end
        end
    end
end

--- @useage 9-周围怪物数量大于等于指定值时，使用魔爆术
function Contra.Mage_Frost_UseArcaneBlast()
        --自动使用魔爆术
    if ContraDB.Mage.Buttons.Frost.UseAoEToggle and Contra.Filter.CountAttackableUnitsInRangeTen() >= ContraDB.Mage.Buttons.Frost.UseAoEEnemyNum then
		if nampower then
			NP_QueueChannelingSpells = GetCVar("NP_QueueChannelingSpells")
			if NP_QueueChannelingSpells ~= 0 then
				SetCVar("NP_QueueChannelingSpells", 0)
			end
		end

		CastSpellByName("魔爆术")
        Contra.Debug("符合使用魔爆术条件，已使用魔爆术","输出")

		if nampower then
			SetCVar("NP_QueueChannelingSpells", NP_QueueChannelingSpells)
		end
		return true
	end

    return false
    
end

--- @useage 10-使用火焰冲击
function Contra.Mage_Frost_Use_Fire_Blast()

    if ContraDB.Mage.Buttons.Frost.FireballToggle and UnitAffectingCombat("target") and Contra.CD("火焰冲击") == 0 then

        if Contra.Casting.guids[Contra.Guids.MyGuid] and Contra.Casting.guids[Contra.Guids.MyGuid].spellID == 25304 and GetTime() - Contra.Casting.guids[Contra.Guids.MyGuid].startTime < 1.5 and UnitHealth("target") <= ContraDB.Mage.Buttons.Frost.FireballHealthNum then
            Contra.MageCast("火焰冲击", "stopCasting")
        end
		
        if not Contra.PlayerIsCasting() then
            if Contra.IsMoving or UnitHealth("target") <= ContraDB.Mage.Buttons.Frost.FireballHealthNum then
                Contra.MageCast("火焰冲击")
            end
        end
	end

end

--- @useage 11-使用奥术涌动
function Contra.Mage_Frost_Arcane_Barrage()

    -- 如果在移动中，则释放奥术涌动
    if Contra.IsMoving then
        Contra.MageCast("奥术涌动")
    end

    --如果不在施法，则释放奥术涌动
    if not Contra.PlayerIsCasting() then
        Contra.MageCast("奥术涌动")
    end

    --如果正在释放寒冰箭，则视情况释放奥术涌动
    if Contra.Casting.guids[Contra.Guids.MyGuid] and Contra.Casting.guids[Contra.Guids.MyGuid].spellID == 25304 and GetTime() - Contra.Casting.guids[Contra.Guids.MyGuid].startTime < 1.5 and UnitHealth("target") <= ContraDB.Mage.Buttons.Frost.FireballHealthNum then
        Contra.MageCast("奥术涌动", "stopCasting")
    end

end

--- @useage 13-使用冰锥术
function Contra.Mage_Frost_ConeofCold()
    if UnitExists("target") and ContraDB.Mage.Buttons.Frost.ConeofColdToggle and not Contra.PlayerIsCasting() and UnitXP("distanceBetween", "player", "target", "chains") <= 12 then
        if UnitMana("player")/UnitManaMax("player") >= ContraDB.Mage.Buttons.Frost.ConeofColdPercent then
            Contra.MageCast("冰锥术")
        else
            Contra.MageCast("冰锥术(等级 1)")
        end
    end
end

--- @useage 14-使用冰霜新星
function Contra.Mage_Frost_FrostNova()
    -- 基本检查：技能冷却、战斗状态
    local cd = Contra.CD("冰霜新星")
    if cd > 0 then
        -- print("冰霜新星冷却中：", cd)
        return
    end
    
    -- 获取12码内可攻击的单位
    local nearbyUnits = Contra.Filter.GetNamesOfAttackableUnitsInRangeTwelve()
    if not nearbyUnits or table.getn(nearbyUnits) == 0 then
        -- print("12码内没有可攻击的单位")
        return
    end
    
    -- print("检测到", table.getn(nearbyUnits), "个可攻击单位")
    

    for _, name in ipairs(nearbyUnits) do
        
        if not ContraDB.Mage.ImmuneToFrost or not ContraDB.Mage.ImmuneToFrost[name] or ContraDB.Mage.ImmuneToFrost[name] == 2 then
            -- print("准备释放冰霜新星给：", name)
            Contra.MageCast("冰霜新星", "stopCasting")
            hasValidTarget = true
            break
        end
    end
end

---@useage 15-释放冰盾
function Contra.MageIceShield()
    if ContraDB.Mage.Buttons.Frost.IceShieldToggle and not Contra.PlayerIsCasting() and not Contra.Casting.HasBuff("寒冰护体") then
        if UnitMana("player")/UnitManaMax("player") >= ContraDB.Mage.Buttons.Frost.IceShieldPercent/100 then
            Contra.MageCast("寒冰护体(等级 4)", "stopCasting")
        else
            Contra.MageCast("寒冰护体(等级 1)", "stopCasting")
        end
    end
end

---@useage 16-暴风雪
function Contra.Mage_Frost_Blizzard()
        --如果有冰霜速冻buff则返回
    if Contra.Casting.HasBuff("冰霜速冻") then return end
    if Contra.PlayerIsCasting() then return end
    if Contra.Filter.CountBlizzardFive() < 3 then return end
    Contra.MageCast("暴风雪(等级 1)")
end

---@useage 17-施放寒冰箭
function Contra.Mage_Frost_FrostBolt()
    --如果有冰霜速冻buff则返回
    if Contra.Casting.HasBuff("冰霜速冻") then return end
    if Contra.PlayerIsCasting() then return end
    Contra.MageCast("寒冰箭")
end

---@useage 16-暴风雪


--- @useage 冰法法一键输出
function Contra.Mage_Frost()

    --使用有限无敌
    Contra.Mage_Frost_Use_Infinite_Immunity()

    --选择目标
    Contra.Mage_Frost_Select_Target()

    --自动 buff
    Contra.Mage_Frost_Self_Buff()

    --自动吃橘子
    Contra.Mage_Frost_Eat_Orange()

    --自动使用法力恢复物品
    Contra.Mage_Frost_Use_Mana_restoration_items()

    --使用饰品
    Contra.Mage_Frost_Use_Trinket()

    --使用种族天赋
    Contra.Mage_Frost_Use_Race_Talent()

    --施放冰柱
    Contra.Mage_Frost_FrostBolt02()

    --如果有冰霜速冻buff则返回
    if Contra.Casting.HasBuff("冰霜速冻") then return end

    --施放冰霜新星
    Contra.Mage_Frost_FrostNova()

    --施放奥术涌动
    Contra.Mage_Frost_Arcane_Barrage()

    --施放火冲
    Contra.Mage_Frost_Use_Fire_Blast()

    --周围怪物数量大于等于4时，使用魔爆术
    Contra.Mage_Frost_UseArcaneBlast()

    --施放冰锥术
    Contra.Mage_Frost_ConeofCold()

    --释放冰盾
    Contra.MageIceShield()

    --施放暴风雪

    --施放寒冰箭
    Contra.Mage_Frost_FrostBolt()
    

end

function Contra.Mage_Rogue()
    -- 基本检查：技能冷却、战斗状态
    Contra.MainhandBuff("速效毒药",2,5)

    Contra.OffhandBuff("速效毒药",2,5)

    CastSpellByName("还击")

    local _, guid = UnitExists("target")
    if Contra.Casting.guids[guid] and Contra.CD("脚踢")then 
        CastSpellByName("脚踢") 
        return
    end

    Contra.Attack()
    if not Contra.Casting.HasBuff("切割") and GetComboPoints() >= 1 then
        CastSpellByName("切割")
    end
    CastSpellByName("邪恶攻击")
end