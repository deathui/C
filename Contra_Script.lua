local Use = Contra.UseItemByName
local Cast = CastSpellByName
local IsCasting = Contra.IsTargetCasting
local CastTime = Contra.GetSpellCastTime
local ItemCD = Contra.ItemCD
local CD = Contra.CD
local Unbuff = Contra.Casting.CancelBuffByName
local Buff = Contra.Casting.HasBuff
function Contra:GetCombatInfo()
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


    return hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName,
    playerClass
end

-- if Contra.DB.Buttons.QiShouBaoFa then

Contra.DB.Buttons = {
    ["QiShouBaoFa"] = true
}




function Contra_KBZ_DanTi()
    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass = Contra:GetCombatInfo()

    Contra.Attack()

    if not Buff("战斗怒吼") and hp > 50
    then Cast("战斗怒吼") end

    if Buff("强效怒气") then
        Cast("血性狂怒")
        UseInventoryItem(13)
        UseInventoryItem(14)
        Use("魂能之速")
    end

    if mp > 4 and mp < 29 and IsMeleeRange and hp > 21
    then Cast("压制") end

    Cast("狂暴姿态")



    if UnitName("target") == "帕奇维克" then

        if hp > 95 then Use("强效怒气")  end
        if hp > 95 then Cast("感知") end
        if hp < 27 then Cast("死亡之愿") end
        if hp < 20.5 then Cast("鲁莽") end
        if hp < 20 and mp < 50 then Use("强效怒气") end     

        if (Contra.Casting.LastCastName ~= "嗜血" or Contra.Casting.LastCastName ~= "旋风斩" or Contra.Casting.LastCastName ~= "猛击") and hp > 80 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) then Cast("旋风斩") end

        if hp > 21 then
            if mp > 84
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
            then Cast("英勇打击") end 
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
        end

        if hp > 20 then
            if Contra.Casting.LastCastName == "嗜血" 
            or Contra.Casting.LastCastName == "旋风斩"
            or (CD("嗜血") ~= 0 and CD("旋风斩") ~= 0 and ST > SS)
            then Cast("猛击") end    
            if Contra.Casting.LastCastName == "猛击" and CD("嗜血") == 0 then Cast("嗜血") end
            if Contra.Casting.LastCastName == "猛击" and CD("旋风斩") == 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34 then Cast("旋风斩") end       
        end

        if hp <= 20 and hp > 2 then
            if ST > CastTime("猛击","等级 5") + 0.2 then Cast("猛击") end
            if (SS > 1.2 and CD("嗜血") == 0 and mp > 45) or (ST > 1.2 and CD("嗜血") ~= 0) or mp > 94 then Cast("斩杀") end
            if SS > 1 and CD("嗜血") == 0 and mp <= 45 then Cast("嗜血") end   
        end
        if hp <= 2 and Contra.GetMySlamTime() > 0.2 then SpellStopCasting() end
        if hp <= 2 then Cast("斩杀") end
    
    end

    if IsBoss or UnitName("target") == "学徒训练假人" then  

        if not Buff("乱舞") and hp >= 80 then        
            if (raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5) then Cast("旋风斩") end
            if not Buff("乱舞") and CD("嗜血") == 0 then Cast("嗜血") end
            
        end
        if (Contra.Casting.LastCastName ~= "嗜血" or Contra.Casting.LastCastName ~= "旋风斩" or Contra.Casting.LastCastName ~= "猛击") and hp > 80 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) then Cast("旋风斩") end
        if hp > 21 then
            if mp > 84
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
            then Cast("英勇打击") end 
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
        end
    
        if hp > 20 then
            if Contra.Casting.LastCastName == "嗜血" 
            or Contra.Casting.LastCastName == "旋风斩"
            or (CD("嗜血") ~= 0 and CD("旋风斩") ~= 0 and ST > SS)
            then Cast("猛击") end    
            if Contra.Casting.LastCastName == "猛击" and CD("嗜血") == 0 then Cast("嗜血") end
            if Contra.Casting.LastCastName == "猛击" and CD("旋风斩") == 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34 then Cast("旋风斩") end      
        end
  
        if hp <= 20 and hp > 2 then
            if ST > CastTime("猛击","等级 5") + 0.3 then Cast("猛击") end
            if (ST < CastTime("猛击","等级 5") + 0.3 and CD("嗜血") == 0 and mp > 45) or (ST < CastTime("猛击","等级 5") + 0.3 and CD("嗜血") ~= 0) or mp > 94 then Cast("斩杀") end
            if ST < CastTime("猛击","等级 5") + 0.3 and CD("嗜血") == 0 and mp <= 45 then Cast("嗜血") end   
        end
        if hp <= 2 and Contra.GetMySlamTime() > 0.2 then SpellStopCasting() end    
        if hp <= 2 then Cast("斩杀") end
    end
    
    if maxhp >= 50000 and not IsBoss and UnitName("target") ~= "学徒训练假人" then
       
        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end  

        if hp > 21 then
          if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
          then Cast("英勇打击") end 
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
        end      

      
        if (hp > 20 and CD("旋风斩") < 6.5)
        or (hp < 19 and hp > 1 and ST > 1.5 and CD("嗜血") == 0 and IsBoss and mp > 47)
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") < 4 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34
        then Cast("旋风斩") end
        if hp > 20 and SS < CastTime("猛击","等级 5")
        then Cast("猛击") end  

    end
    if CD("血性狂暴") == 0 and not Buff("狂怒") and IsMeleeRange
    then Cast("血性狂暴") end


    if maxhp >= 12000 and maxhp < 50000 then

        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end 

        if hp > 21 then
          if ((SS < 0.3 and mp > 82) or (ST < 0.3 and mp > 57)) and CD("嗜血") < ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 96) or (ST < 0.3 and mp > 66)) and CD("嗜血") < ST and CD("旋风斩") > ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 86) or (ST < 0.3 and mp > 71)) and CD("嗜血") > ST and CD("旋风斩") > ST
          then Cast("英勇打击") end 
          if ((SS < 0.3 and mp > 95) or (ST < 0.3 and mp > 70)) and CD("嗜血") > ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
        end
        if (hp > 21 and ST > 0.5 and CD("嗜血")==0)
        or (hp < 19 and ST > 1.5 and CD("嗜血") == 0 and IsBoss and (mp > 44 or mp < 35))
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") > 1 and CD("旋风斩")== 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 39 and (ST < 1.8 or SS < 0.2)
        then Cast("旋风斩") end  
        if hp > 21 and ST > CastTime("猛击","等级 5") and CD("嗜血") > 0.1
        then Cast("猛击") end
    end

    if maxhp < 12000 then

        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end 

        if (hp > 21 and CD("嗜血") > SD and mp > 36) or (hp > 20 and CD("嗜血") < SD and mp > 41)
        then Cast("英勇打击") end
        if hp > 21 and CD("嗜血")==0
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") > 1 and CD("旋风斩")== 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 39 and (ST < 1.8 or SS < 0.2)
        then Cast("旋风斩") end  
        if hp > 21 and ST > CastTime("猛击","等级 5") and CD("嗜血") > 1.5 and CD("旋风斩") > 1.5
        then Cast("猛击") end
    end
end

function Contra_KBZ_QunTi()
    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass = Contra:GetCombatInfo()

    Contra.Attack()

    if not Buff("战斗怒吼") then
        Cast("战斗怒吼")
    end

    if Buff("强效怒气") then
        Cast("血性狂怒")
        UseInventoryItem(13)
        UseInventoryItem(14)
        Use("魂能之速")
    end    

    if mp > 4 and mp < 29 and IsMeleeRange and hp > 21
    then Cast("压制") end
 
    Cast("狂暴姿态")
 
    if CD("血性狂暴") == 0 and not Buff("狂怒") and IsMeleeRange
    then Cast("血性狂暴") end
 
    if hp < 20 and Contra.GetMySlamTime() > 0.2 then
        SpellStopCasting()
    end  
 
 
 
    if (hp < 20 and mp >= 62)
     or (hp < 20 and CD("旋风斩") > 0.5 and mp > 19)
     or (hp < 20 and CD("旋风斩") > 0.5 and mp < 20)
    then Cast("斩杀") end
 
    if maxhp > 38000 and IsMeleeRange then
        if (CD("旋风斩") > SD*2 and mp > 34)
         or (CD("旋风斩") > SD and mp > 59)
         or (CD("旋风斩") < SD and mp > 59)
        then Cast("顺劈斩") end
        if CD("旋风斩") == 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5))
        then Cast("旋风斩") end
        if (hp > 20 and CD("嗜血") == 0 and CD("旋风斩") > 9 and mp > 89)
         or (hp > 20 and CD("嗜血") == 0 and CD("旋风斩") > SD*2 and mp > 94)
         or (hp > 20 and CD("嗜血") == 0 and CD("旋风斩") > SD and CD("旋风斩") < SD*2 and mp > 99)
         or (hp > 20 and CD("嗜血") == 0 and CD("旋风斩") < SD and CD("旋风斩") > 1.4 and CD("旋风斩") <= 9 and mp > 94)
        then Cast("嗜血") end

        if hp > 20 and SS < CastTime("猛击","等级 5") and CD("旋风斩") > 0.5
        then Cast("猛击") end
    end
 
    if maxhp > 14000 and maxhp < 38000 and IsMeleeRange then
        if mp > 44 or (CD("旋风斩") > SD and mp > 19)
        then Cast("顺劈斩") end
        if (hp > 20 and CD("嗜血") == 0 and CD("旋风斩") > ST and ((mp > 84 and CD("旋风斩") < SD*2) or (mp > 59 and CD("旋风斩") > SD*2)))
        then Cast("嗜血") end
        if CD("旋风斩") == 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5))
        then Cast("旋风斩") end    
        if hp > 30 and ST > CastTime("猛击","等级 5") and CD("旋风斩") > 1.4
        then Cast("猛击") end
    end
 
    if maxhp < 14000 and IsMeleeRange then
        if mp > 44 or (CD("旋风斩") > SD and mp > 19)
        then Cast("顺劈斩") end
        if hp > 20 and CD("旋风斩") > 1.4 and mp > 29
        then Cast("嗜血") end
        if CD("旋风斩") == 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5))
        then Cast("旋风斩") end
        if hp > 25 and ST > CastTime("猛击","等级 5") and CD("旋风斩") > 2 and CD("嗜血") > 2
        then Cast("猛击") end
    end
end
 
 
function Contra_KBZ_CS()
    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass = Contra:GetCombatInfo()

    Contra.Attack()

    if not Buff("战斗怒吼") and hp > 50
    then Cast("战斗怒吼") end

    if Buff("强效怒气") then
        Cast("血性狂怒")
        UseInventoryItem(13)
        UseInventoryItem(14)
        Use("魂能之速")
    end

    if mp > 4 and mp < 29 and IsMeleeRange and hp > 21
    then Cast("压制") end

    Cast("狂暴姿态")

    if hp > 98 then        
        if CD("嗜血") == 0 then Cast("嗜血") end
        if (raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5) then Cast("旋风斩") end
    end

    if UnitName("target") == "帕奇维克" then

        if hp > 95 then Use("强效怒气")  end
        if hp > 95 then Cast("感知") end
        if hp < 27 then Cast("死亡之愿") end
        if hp < 20.5 then Cast("鲁莽") end
        if hp < 20 and mp < 50 then Use("强效怒气") end     

        if hp > 21 then
            if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
            then Cast("英勇打击") end 
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
        end
        if Contra.Casting.LastCastName == "嗜血"
        or Contra.Casting.LastCastName == "旋风斩"
        then Cast("猛击") end

        if Contra.Casting.LastCastName == "猛击" then Cast("嗜血") end
        if Contra.Casting.LastCastName == "猛击" then Cast("旋风斩") end

        -- if hp <= 20 and hp > 2 and ST > CastTime("猛击","等级 5") + 0.2 then Cast("猛击") end

        -- if hp < 20 and (SS > 1.3 or mp > 94) then Cast("斩杀") end
        -- if (hp > 20 and CD("旋风斩") < 6.5)
        -- or (hp < 20 and hp > 2 and SS >= 1 and CD("嗜血") == 0 and mp > 47)
        -- then Cast("嗜血") end   

        -- if hp > 21 and CD("嗜血") < 4 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34
        -- then Cast("旋风斩") end
        -- if hp > 20 and SS < CastTime("猛击","等级 5")
        -- then Cast("猛击") end
    end

    if not IsBoss then  

        if hp > 21 then
            if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
            then Cast("英勇打击") end 
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
        end

        if Contra.Casting.LastCastName == "嗜血" 
        or Contra.Casting.LastCastName == "旋风斩"
        or (CD("嗜血") ~= 0 and CD("旋风斩") ~= 0 and ST > SS)
        then Cast("猛击") end

        if Contra.Casting.LastCastName == "猛击" and CD("嗜血") == 0 then Cast("嗜血") end
        if Contra.Casting.LastCastName == "猛击" and CD("旋风斩") == 0 then Cast("旋风斩") end

        -- if hp <= 20 and hp > 2 and ST > CastTime("猛击","等级 5") + 0.2 then Cast("猛击") end

        -- if hp < 20 and (SS > 1.3 or mp > 94) then Cast("斩杀") end
        -- if (hp > 20 and CD("旋风斩") < 6.5)
        -- or (hp < 20 and hp > 2 and SS >= 1 and CD("嗜血") == 0 and mp > 47)
        -- then Cast("嗜血") end   

        -- if hp > 21 and CD("嗜血") < 4 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34
        -- then Cast("旋风斩") end
        -- if hp > 20 and ST > 1
        -- then Cast("猛击") end
    end
    
    if maxhp >= 50000 and IsBoss then
       
        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end  

        if hp > 21 then
          if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
          then Cast("英勇打击") end 
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
        end      

      
        if (hp > 20 and CD("旋风斩") < 6.5)
        or (hp < 19 and hp > 1 and ST > 1.5 and CD("嗜血") == 0 and IsBoss and mp > 47)
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") < 4 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34
        then Cast("旋风斩") end
        if hp > 20 and SS < CastTime("猛击","等级 5")
        then Cast("猛击") end  

    end
    if CD("血性狂暴") == 0 and not Buff("狂怒") and IsMeleeRange
    then Cast("血性狂暴") end


    if maxhp >= 12000 and maxhp < 50000 then

        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end 

        if hp > 21 then
          if ((SS < 0.3 and mp > 82) or (ST < 0.3 and mp > 57)) and CD("嗜血") < ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 96) or (ST < 0.3 and mp > 66)) and CD("嗜血") < ST and CD("旋风斩") > ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 86) or (ST < 0.3 and mp > 71)) and CD("嗜血") > ST and CD("旋风斩") > ST
          then Cast("英勇打击") end 
          if ((SS < 0.3 and mp > 95) or (ST < 0.3 and mp > 70)) and CD("嗜血") > ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
        end
        if (hp > 21 and ST > 0.5 and CD("嗜血")==0)
        or (hp < 19 and ST > 1.5 and CD("嗜血") == 0 and IsBoss and (mp > 44 or mp < 35))
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") > 1 and CD("旋风斩")== 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 39 and (ST < 1.8 or SS < 0.2)
        then Cast("旋风斩") end  
        if hp > 21 and ST > CastTime("猛击","等级 5") and CD("嗜血") > 0.5
        then Cast("猛击") end
    end

    if maxhp < 12000 then

        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end 

        if (hp > 21 and CD("嗜血") > SD and mp > 36) or (hp > 20 and CD("嗜血") < SD and mp > 41)
        then Cast("英勇打击") end
        if hp > 21 and CD("嗜血")==0
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") > 1 and CD("旋风斩")== 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 39 and (ST < 1.8 or SS < 0.2)
        then Cast("旋风斩") end  
        if hp > 21 and ST > CastTime("猛击","等级 5") and CD("嗜血") > 1.5 and CD("旋风斩") > 1.5
        then Cast("猛击") end
    end
end


function Contra_beiyong()
    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass = Contra:GetCombatInfo()

    Contra.Attack()

    if not Buff("战斗怒吼") and hp > 50
    then Cast("战斗怒吼") end

    if Buff("强效怒气") then
        Cast("血性狂怒")
        UseInventoryItem(13)
        UseInventoryItem(14)
        Use("魂能之速")
    end

    if mp > 4 and mp < 29 and IsMeleeRange and hp > 21
    then Cast("压制") end

    Cast("狂暴姿态")

    if not Buff("乱舞") then        
        if CD("嗜血") == 0 then Cast("嗜血") end
        if (raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5) then Cast("旋风斩") end
    end

    if UnitName("target") == "帕奇维克" then

        if hp > 95 then Use("强效怒气")  end
        if hp > 95 then Cast("感知") end
        if hp < 27 then Cast("死亡之愿") end
        if hp < 20.5 then Cast("鲁莽") end
        if hp < 20 and mp < 50 then Use("强效怒气") end     

        if hp > 21 then
            if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
            then Cast("英勇打击") end 
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
        end
    
        if hp <= 20 and hp > 2 and ST > CastTime("猛击","等级 5") + 0.2 then Cast("猛击") end

        if hp < 20 and (SS > 1.3 or mp > 94) then Cast("斩杀") end
        if (hp > 20 and CD("旋风斩") < 6.5)
        or (hp < 20 and hp > 2 and SS >= 1 and CD("嗜血") == 0 and mp > 47)
        then Cast("嗜血") end   

        if hp > 21 and CD("嗜血") < 4 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34
        then Cast("旋风斩") end
        if hp > 20 and SS < CastTime("猛击","等级 5")
        then Cast("猛击") end
    end

    if not IsBoss then  

        if hp > 21 then
            if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
            then Cast("英勇打击") end
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
            then Cast("英勇打击") end 
            if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
            then Cast("英勇打击") end
        end
    
        if hp <= 20 and hp > 2 and ST > CastTime("猛击","等级 5") + 0.2 then Cast("猛击") end

        if hp < 20 and (SS > 1.3 or mp > 94) then Cast("斩杀") end
        if (hp > 20 and CD("旋风斩") < 6.5)
        or (hp < 20 and hp > 2 and SS >= 1 and CD("嗜血") == 0 and mp > 47)
        then Cast("嗜血") end   

        if hp > 21 and CD("嗜血") < 4 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34
        then Cast("旋风斩") end
        if hp > 20 and ST > 1
        then Cast("猛击") end
    end
    
    if maxhp >= 50000 and IsBoss then
       
        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end  

        if hp > 21 then
          if ((SS < 0.3 and mp > 81) or (ST < 0.3 and mp > 59)) and CD("嗜血") < ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 61)) and CD("嗜血") < ST and CD("旋风斩") > ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 66)) and CD("嗜血") > ST and CD("旋风斩") > ST
          then Cast("英勇打击") end 
          if ((SS < 0.3 and mp > 91) or (ST < 0.3 and mp > 65)) and CD("嗜血") > ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
        end      

      
        if (hp > 20 and CD("旋风斩") < 6.5)
        or (hp < 19 and hp > 1 and ST > 1.5 and CD("嗜血") == 0 and IsBoss and mp > 47)
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") < 4 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 34
        then Cast("旋风斩") end
        if hp > 20 and SS < CastTime("猛击","等级 5")
        then Cast("猛击") end  

    end
    if CD("血性狂暴") == 0 and not Buff("狂怒") and IsMeleeRange
    then Cast("血性狂暴") end


    if maxhp >= 12000 and maxhp < 50000 then

        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end 

        if hp > 21 then
          if ((SS < 0.3 and mp > 82) or (ST < 0.3 and mp > 57)) and CD("嗜血") < ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 96) or (ST < 0.3 and mp > 66)) and CD("嗜血") < ST and CD("旋风斩") > ST
          then Cast("英勇打击") end
          if ((SS < 0.3 and mp > 86) or (ST < 0.3 and mp > 71)) and CD("嗜血") > ST and CD("旋风斩") > ST
          then Cast("英勇打击") end 
          if ((SS < 0.3 and mp > 95) or (ST < 0.3 and mp > 70)) and CD("嗜血") > ST and CD("旋风斩") < ST
          then Cast("英勇打击") end
        end
        if (hp > 21 and ST > 0.5 and CD("嗜血")==0)
        or (hp < 19 and ST > 1.5 and CD("嗜血") == 0 and IsBoss and (mp > 44 or mp < 35))
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") > 1 and CD("旋风斩")== 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 39 and (ST < 1.8 or SS < 0.2)
        then Cast("旋风斩") end  
        if hp > 21 and ST > CastTime("猛击","等级 5") and CD("嗜血") > 0.5
        then Cast("猛击") end
    end

    if maxhp < 12000 then

        if hp < 20 and Contra.GetMySlamTime() > 0.2
        then SpellStopCasting() end 

        if (hp > 21 and CD("嗜血") > SD and mp > 36) or (hp > 20 and CD("嗜血") < SD and mp > 41)
        then Cast("英勇打击") end
        if hp > 21 and CD("嗜血")==0
        then Cast("嗜血") end   
        if hp < 20
        then Cast("斩杀") end
        if hp > 21 and CD("嗜血") > 1 and CD("旋风斩")== 0 and ((raceName ~= "牛头人" and Range < 8) or (raceName == "牛头人" and Range < 5.5)) and mp > 39 and (ST < 1.8 or SS < 0.2)
        then Cast("旋风斩") end  
        if hp > 21 and ST > CastTime("猛击","等级 5") and CD("嗜血") > 1.5 and CD("旋风斩") > 1.5
        then Cast("猛击") end
    end
end

