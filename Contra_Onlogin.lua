Contra.MyClass = ""
Contra.MyTalent = ""
Contra.ArcaneMissilesNum = 5

Contra.OnLogin = {}
Contra.OnLogin.Frame = CreateFrame("Frame")
Contra.OnLogin.Frame:RegisterEvent("PLAYER_LOGIN")
Contra.OnLogin.Frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
Contra.OnLogin.Frame:RegisterEvent("CHAT_MSG_SYSTEM")


--获取玩家职业
Contra.OnLogin.GetPlayerClass = function()
    if event == "PLAYER_LOGIN" then
        Contra.MyClass,_ = UnitClass("player")
        Contra.MyRace,_ = UnitRace("player")
    end
end

--法师特殊化处理
Contra.OnLogin.Mage_Specialization = function()
    --如果是法师
    if Contra.MyClass == "法师" then
        if event == "PLAYER_LOGIN" or event == "UNIT_INVENTORY_CHANGED" or (event == "CHAT_MSG_SYSTEM" and string.find(arg1, "你学会新的")) then
            -- 判定天赋
            if Contra.TalentRank(1,19) > 0 then Contra.MyTalent ="Arcane" end
            if Contra.TalentRank(2,17) > 0 then Contra.MyTalent ="Fire" end
            if Contra.TalentRank(3,19) > 0 then Contra.MyTalent ="Frost" end

            --装备判定
            if Contra.HasEquipItem("霜火束带") then Contra.ArcaneMissilesNum = 6 else Contra.ArcaneMissilesNum = 5 end
        end
        if event == "PLAYER_LOGIN" and nampower then
            SetCVar("NP_QueueCastTimeSpells",1)
            SetCVar("NP_QueueInstantSpells",1)
            SetCVar("NP_QueueOnSwingSpells",1)
            SetCVar("NP_QueueChannelingSpells",1)
            SetCVar("NP_QueueTargetingSpells",1)
            SetCVar("NP_QueueSpellsOnCooldown",1)
        end
    end
end

-- ContraDBDefault = {
--     --版本号
--     Version = 20250910,

--判断版本号，如果不一致，则将数据库初始化
function Contra.OnLogin.CheckVersion()
    if event == "PLAYER_LOGIN" then
        if ContraDB == nil then
            ContraDB = ContraDBDefault
        elseif ContraDB.Version ~= ContraDBDefault.Version then
            for k, v in pairs(ContraDBDefault) do
                if ContraDB[k] == nil then
                    ContraDB[k] = v
                end
            end
        end
    end
end

--初始化数据库
Contra.OnLogin.InitDB = function()
    --如果数据库不存在
    if not ContraDB or ContraDB.Version ~= ContraDBDefault.Version then
        --创建数据库
        ContraDB = ContraDBDefault
    end
end


--初始化
Contra.OnLogin.Init = function()
    Contra.OnLogin.GetPlayerClass()
    Contra.OnLogin.Mage_Specialization()
    Contra.OnLogin.InitDB()
    Contra.OnLogin.CheckVersion()
end

--事件处理
Contra.OnLogin.Frame:SetScript("OnEvent", Contra.OnLogin.Init)