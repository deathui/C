-- Contra 宏命令处理模块
-- 本模块用于处理用户输入的宏命令参数，并调用对应的输出循环函数

-- 参数说明：
-- zsa 运行单体输出循环函数 Contra_KBZ_DanTi()
-- zsb 运行群体输出循环函数 Contra_KBZ_QunTi()

-- 主函数：处理传入的参数并执行相应的输出循环
function Contra_MacroHandler(cmd)
    -- 检查参数是否为空
    if not cmd then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Contra 输出助手|r: 请指定参数: zsa(单体) 或 zsb(群体)")
        return
    end
    
    -- 将参数转换为小写，确保大小写不敏感
    local param = string.lower(cmd)
    
    -- 根据参数调用对应的输出循环函数
    if param == "zsa" then
        -- 运行单体输出循环
        if type(Contra_KBZ_DanTi) == "function" then
            Contra_KBZ_DanTi()
        end
    elseif param == "zsb" then
        -- 运行群体输出循环
        if type(Contra_KBZ_QunTi) == "function" then
            Contra_KBZ_QunTi()
        end
    elseif param == "mage" then
        -- 运行群体输出循环
        if Contra.MyTalent == "Arcane" then
            Contra.Mage_Arcane()
        end
        if Contra.MyTalent == "Fire" then
            Contra.Mage_Fire()
        end
        if Contra.MyTalent == "Frost" then
            Contra.Mage_Frost()
        end
    else
        -- 无效参数提示
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000错误|r: 无效参数 '" .. param .. "'")
        if Contra.MyClass == "法师" then
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Contra 输出助手|r: 可用参数: mage")
        elseif Contra.MyClass == "战士" then
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Contra 输出助手|r: 可用参数: zsa(单体) 或 zsb(群体)")
        end
        
    end
end

-- 注册聊天命令
SLASH_CONTRAMACRO1 = "/cm" -- 主命令
SLASH_CONTRAMACRO2 = "/contramacro" -- 完整命令
SLASH_CONTRAMACRO3 = "/Contra" -- 额外命令
SLASH_CONTRAMACRO4 = "/contra" -- 额外命令(小写)

-- 聊天命令处理函数
SlashCmdList["CONTRAMACRO"] = Contra_MacroHandler

-- 提供一个简单的调用接口，便于在宏中使用
function Contra_Macro(param)
    Contra_MacroHandler(param)
end


