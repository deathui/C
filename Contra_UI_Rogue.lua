-- 生存设置

----------------------------------------------------------------------------
---
---
---                             盗贼界面设置
--- 
--- 
----------------------------------------------------------------------------
----------------------------------------------------------------------------


Contra.RogueUI = Contra.RogueUI or {}

-- 使用Contra_UI_DB.lua中定义的ContraDB结构
-- ContraDB.Rogue.Buttons.Shun 等已经由Contra_UI_DB.lua初始化

-- 界面设置 - Contra盗贼专用
Contra.RogueUI_Settings = {
    Width = 750,
    Height = 500,
    HeaderHeight = 64,
    SectionSpacing = 10,
    ButtonWidth = 220,
    ButtonHeight = 25,
    SliderWidth = 160,
    SliderHeight = 3
}

-- 背景模板 - Contra盗贼专用
Contra.RogueUI_BackdropTemplate = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
}

-- 颜色定义 - Contra盗贼专用
Contra.RogueUI_Colors = {
    Background = { 0.12, 0.05, 0.05, 0.95 },
    Border = { 1, 0.84, 0, 1 }, -- 对应 #F06969 的 RGB 值
    Header = { 1, 0.84, 0, 1 }, -- 对应 #F06969
    Text = { 1, 1, 1, 1 },
    Disabled = { 0.4, 0.5, 0.6, 1 },
    Highlight = { 1, 0.84, 0, 0.7 } -- 使用相同的颜色但降低透明度
}


-- 创建主窗口
function Contra.RogueUI.CreateMainFrame()
    -- 主框架
    Contra.RogueUI.Frame = CreateFrame("Frame", "ContraRogueUIFrame", UIParent)
    Contra.RogueUI.Frame:SetFrameStrata("MEDIUM")
    Contra.RogueUI.Frame:SetWidth(Contra.RogueUI_Settings.Width)
    Contra.RogueUI.Frame:SetHeight(Contra.RogueUI_Settings.Height)
    Contra.RogueUI.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    Contra.RogueUI.Frame:SetBackdrop(Contra.RogueUI_BackdropTemplate)
    Contra.RogueUI.Frame:SetBackdropColor(unpack(Contra.RogueUI_Colors.Background))
    Contra.RogueUI.Frame:SetBackdropBorderColor(unpack(Contra.RogueUI_Colors.Border))
    Contra.RogueUI.Frame:EnableMouse(true)
    Contra.RogueUI.Frame:SetMovable(true)
    Contra.RogueUI.Frame:RegisterForDrag("LeftButton")
    Contra.RogueUI.Frame:SetScript("OnDragStart", function() Contra.RogueUI.Frame:StartMoving() end)
    Contra.RogueUI.Frame:SetScript("OnDragStop", function() Contra.RogueUI.Frame:StopMovingOrSizing() end)
    Contra.RogueUI.Frame:Hide()

    -- 标题背景
    Contra.RogueUI.Frame.Title = Contra.RogueUI.Frame:CreateTexture("ContraDB.Rogue.Buttons.Shun.MainFrameHeader", "ARTWORK")
    Contra.RogueUI.Frame.Title:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    Contra.RogueUI.Frame.Title:SetWidth(400)
    Contra.RogueUI.Frame.Title:SetHeight(64)
    Contra.RogueUI.Frame.Title:SetPoint("TOP", Contra.RogueUI.Frame, "TOP", 0, 12)
    
    -- 标题文字
    Contra.RogueUI.Frame.Title.Text = Contra.RogueUI.Frame:CreateFontString(nil, "OVERLAY")
    Contra.RogueUI.Frame.Title.Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
    Contra.RogueUI.Frame.Title.Text:SetPoint("CENTER", Contra.RogueUI.Frame.Title, "CENTER", 0, 11)
    Contra.RogueUI.Frame.Title.Text:SetText("Contra 盗贼助手")
    Contra.RogueUI.Frame.Title.Text:SetTextColor(unpack(Contra.RogueUI_Colors.Header))

    -- 作者信息
    Contra.RogueUI.Frame.Author = Contra.RogueUI.Frame:CreateFontString(nil, "OVERLAY")
    Contra.RogueUI.Frame.Author:SetFont(STANDARD_TEXT_FONT, 9)
    Contra.RogueUI.Frame.Author:SetTextColor(0.6, 0.6, 0.6)
    Contra.RogueUI.Frame.Author:SetPoint("BOTTOMRIGHT", Contra.RogueUI.Frame, "BOTTOMRIGHT", -24, 11)
    Contra.RogueUI.Frame.Author:SetText("by:魂斗罗工会")


    --创建一个无边框底纹的按钮，位于框体的右上方，文本用一个颜色风格与标题一致的字母X显示
    Contra.RogueUI.Frame.CloseButton = CreateFrame("Button", nil, Contra.RogueUI.Frame)
    Contra.RogueUI.Frame.CloseButton:SetPoint("TOPRIGHT", Contra.RogueUI.Frame, "TOPRIGHT", -10, -10)
    Contra.RogueUI.Frame.CloseButton:SetWidth(20)
    Contra.RogueUI.Frame.CloseButton:SetHeight(20)
    --设置显示文本为X
    Contra.RogueUI.Frame.CloseButton:SetText("X")
    Contra.RogueUI.Frame.CloseButton:SetFont(STANDARD_TEXT_FONT, 14)
    Contra.RogueUI.Frame.CloseButton:SetTextColor(0.94, 0.41, 0.41, 1)
    Contra.RogueUI.Frame.CloseButton:SetScript("OnClick", function()
        Contra.RogueUI.Frame:Hide()
    end)
    --设置鼠标指向时文本高亮
    Contra.RogueUI.Frame.CloseButton:SetScript("OnEnter", function()
        Contra.RogueUI.Frame.CloseButton:SetTextColor(1, 0.8, 0.25, 1)
    end)
    --设置鼠标离开时文本取消高亮
    Contra.RogueUI.Frame.CloseButton:SetScript("OnLeave", function()
        Contra.RogueUI.Frame.CloseButton:SetTextColor(0.94, 0.41, 0.41, 1)
    end)
 
end


-- -- 生存设置
-- ContraDB.Rogue.Buttons.Shun.Shanbi = true,        -- 标题：使用 闪避              说明：骷髅级的目标OT时使用闪避
-- ContraDB.Rogue.Buttons.Shun.Xiaoshi = true,       -- 标题：使用 消失              说明：骷髅级的目标OT时使用消失    
-- ContraDB.Rogue.Buttons.Shun.Wudi = true,          -- 标题：使用 无敌药水          说明：骷髅级的目标OT时使用有限无敌药水（闪避CD中才会用 和 麦迪文不用）
-- ContraDB.Rogue.Buttons.Shun.Tang = true,          -- 标题：使用 治疗石            说明：生命值低于40%时使用治疗石
-- ContraDB.Rogue.Buttons.Shun.Cyc = true,           -- 标题：使用 草药茶            说明：生命值低于30%时使用草药茶
-- ContraDB.Rogue.Buttons.Shun.Dahong = true,        -- 标题：使用 大红              说明：生命值低于20%时使用大红

-- -- 技能开关
-- ContraDB.Rogue.Buttons.Shun.HuanJi = true,        -- 标题：使用 还击
-- ContraDB.Rogue.Buttons.Shun.Jhc = true,           -- 标题：使用 菊花茶            说明：能量低于10，使用菊花茶
-- ContraDB.Rogue.Buttons.Shun.Zhongzu = true,       -- 标题：使用 种族天赋          说明：开启种族天赋
-- ContraDB.Rogue.Buttons.Shun.Guimei = true,        -- 标题：使用 鬼魅攻击          说明：施放鬼魅攻击
-- ContraDB.Rogue.Buttons.Shun.xiee = true,          -- 标题：使用 邪恶攻击          说明：当击打目标正面时，强制使用邪恶攻击（背刺贼专用）
-- ContraDB.Rogue.Buttons.Shun.Daduan = true,        -- 标题：使用 自动打断          说明：当目标施法时自动打断
-- ContraDB.Rogue.Buttons.Shun.SWBJ = true,          -- 标题：使用 死亡标记          说明：骷髅级目标血量低于设定值，则施放死亡标记
-- ContraDB.Rogue.Buttons.Shun.Siwangbiaoji = 100,   -- 标题：使用死亡标记           说明：设置目标施放死亡标记的百分比

-- --终结技开关
-- ContraDB.Rogue.Buttons.Shun.Sy = true,            -- 标题：使用 死亡之影          说明：骷髅级目标血量低于设定值，则施放死亡之影
-- ContraDB.Rogue.Buttons.Shun.Siying = 5,           -- 标题：使用 死亡之影连击点数   说明：施放死亡之影(建议5)

-- ContraDB.Rogue.Buttons.Shun.Ds = true,            -- 标题：使用 毒伤              说明：设置施放毒伤的连击点数值（建议4）
-- ContraDB.Rogue.Buttons.Shun.Dushang = 5,          -- 标题：使用 毒伤连击点数       说明：设置施放毒伤的连击点数值

-- ContraDB.Rogue.Buttons.Shun.Qg = true,            -- 标题：使用 切割              说明：设置施放切割的连击点数值（建议4）
-- ContraDB.Rogue.Buttons.Shun.Qiege = 5,            -- 标题：使用 切割连击点数       说明：设置施放切割的连击点数值

-- ContraDB.Rogue.Buttons.Shun.Gl = true,            -- 标题：使用 割裂              说明：设置施放割裂的连击点数值（建议5）
-- ContraDB.Rogue.Buttons.Shun.Gelie = 5,            -- 标题：使用 割裂连击点数       说明：设置施放割裂的连击点数值

-- ContraDB.Rogue.Buttons.Shun.Tg = true,            -- 标题：使用 剔骨              说明：设置施放剔骨的连击点数值（建议4或5）
-- ContraDB.Rogue.Buttons.Shun.Tigu = 5,             -- 标题：使用 剔骨连击点数       说明：设置施放剔骨的连击点数值

-- ContraDB.Rogue.Buttons.Shun.Pj = true,            -- 标题：使用 破甲              说明：骷髅级目标血量低于设定值，则施放破甲
-- ContraDB.Rogue.Buttons.Shun.Pojia = 5,            -- 标题：使用 破甲连击点数       说明：施放破甲(建议5)

function Contra.CreatRogueUI()

    if Contra.MyClass ~= "盗贼" then return end

    if Contra.RogueUI.Frame then return end

    local x,y = 40,-70

    -- 先创建主框架
    Contra.RogueUI.CreateMainFrame()

    -- 1-1标题：生存
    ContraUI.CreateTitle(Contra.RogueUI.Frame, "生存设置", Contra.RogueUI_Colors.Header, x, y)

    --2-1 复选框：使用消失
    y = y - 30
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueXiaoshi", "使用 消失", "骷髅级的目标OT时使用消失", x, y, ContraDB.Rogue.Buttons.Shun, "Xiaoshi")   

    --2-2 复选框：使用闪避
    x = x + 150
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueShanbi", "使用 闪避", "骷髅级的目标OT并且消失处于CD中时使用闪避", x, y, ContraDB.Rogue.Buttons.Shun, "Shanbi")
  
    --2-3 复选框：使用无敌药水
    x = x + 220
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueWudi", "使用 无敌药水", "骷髅级的目标OT，并且小时和闪避处于CD中时使用有限无敌药水", x, y, ContraDB.Rogue.Buttons.Shun, "Wudi")
   
    --2-4 复选框：使用 治疗石
    x = x + 150
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueTang", "使用 治疗石", "生命值低于40%时使用治疗石", x, y, ContraDB.Rogue.Buttons.Shun, "Tang")

    --3-1 复选框：使用 草药茶
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueCyc", "使用 草药茶", "生命值低于30%时使用草药茶", x, y, ContraDB.Rogue.Buttons.Shun, "Cyc")

    --3-2 复选框：使用 大红
    x = x + 150
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueDahong", "使用 大红", "生命值低于20%时使用大红", x, y, ContraDB.Rogue.Buttons.Shun, "Dahong")

    -- 4-1 标题：技能
    x = 40; y = y - 40
    ContraUI.CreateTitle(Contra.RogueUI.Frame,  "技能设置", x, y)

    --5-1 复选框：还击
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueHuanji", "使用 还击", "施放还击", x, y, ContraDB.Rogue.Buttons.Shun, "Huanji")

    --5-2 复选框：菊花茶
    x = x + 150
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueJhc", "使用 菊花茶", "能量低于10，使用菊花茶", x, y, ContraDB.Rogue.Buttons.Shun, "Jhc")

    --5-3 复选框：使用 种族天赋 
    x = x + 220
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueZhongzu", "使用 种族天赋", "使用种族天赋", x, y, ContraDB.Rogue.Buttons.Shun, "Zhongzu")

    --5-4 复选框：使用 鬼魅攻击
    x = x + 150
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueGuimei", "使用 鬼魅攻击", "施放鬼魅攻击", x, y, ContraDB.Rogue.Buttons.Shun, "Guimei")

    --6-1 复选框：使用 邪恶攻击
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRoguexiee", "使用 邪恶攻击", "当击打目标正面时，强制使用邪恶攻击（背刺贼专用）", x, y, ContraDB.Rogue.Buttons.Shun, "xiee")

    --6-2 复选框：使用 自动打断
    x = x + 150
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueDaduan", "使用 自动打断", "当目标施法时自动打断", x, y, ContraDB.Rogue.Buttons.Shun, "Daduan")

    --6-3 复选框：使用 死亡标记
    x = x + 220
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueSWBJ", "使用 死亡标记", "当目标血量小于指定百分比时使用死亡标记", x, y, ContraDB.Rogue.Buttons.Shun, "SWBJ")

    --6-4 滑块：使用死亡标记
    x = x + 150
    ContraUI.CreateSlider(Contra.RogueUI.Frame, "ContraRogueSiwangbiaoji", "使用死亡标记%", 0, 100, 5, x, y, ContraDB.Rogue.Buttons.Shun, "Siwangbiaoji")

    -- 7-1 标题：终结技
    x = 40; y = y - 40
    ContraUI.CreateTitle(Contra.RogueUI.Frame, "终结技设置", x, y)

    --8-1 复选框：使用 死亡之影
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueSy", "使用 死亡之影", "施放死亡之影", x, y, ContraDB.Rogue.Buttons.Shun, "Sy")

    --8-2 滑块：使用 死亡之影连击点数
    x = x + 150
    ContraUI.CreateSlider(Contra.RogueUI.Frame, "ContraRogueSiying", "使用 死亡之影连击点数", 1, 5, 1, x, y, ContraDB.Rogue.Buttons.Shun, "Siying")

    --8-3 复选框：使用 毒伤
    x = x + 220
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueDs", "使用 毒伤", "施放毒伤", x, y, ContraDB.Rogue.Buttons.Shun, "Ds")

    --8-4 滑块：使用 毒伤连击点数
    x = x + 150
    ContraUI.CreateSlider(Contra.RogueUI.Frame, "ContraRogueDushang", "使用 毒伤连击点数", 1, 5, 1, x, y, ContraDB.Rogue.Buttons.Shun, "Dushang")

    --9-1 复选框：使用 切割
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueQg", "使用 切割", "施放切割", x, y, ContraDB.Rogue.Buttons.Shun, "Qg")

    --9-2 滑块：使用 切割连击点数
    x = x + 150
    ContraUI.CreateSlider(Contra.RogueUI.Frame, "ContraRogueQiege", "使用 切割连击点数", 1, 5, 1, x, y, ContraDB.Rogue.Buttons.Shun, "Qiege")

    --9-3 复选框：使用 割裂
    x = x + 220
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueGl", "使用 割裂", "施放割裂", x, y, ContraDB.Rogue.Buttons.Shun, "Gl")

    --9-4 滑块：使用 割裂连击点数
    x = x + 150
    ContraUI.CreateSlider(Contra.RogueUI.Frame, "ContraRogueGelie", "使用 割裂连击点数", 1, 5, 1, x, y, ContraDB.Rogue.Buttons.Shun, "Gelie")

    --10-1 复选框：使用 剔骨
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRogueTg", "使用 剔骨", "施放剔骨", x, y, ContraDB.Rogue.Buttons.Shun, "Tg")

    --10-2 滑块：使用 剔骨连击点数
    x = x + 150
    ContraUI.CreateSlider(Contra.RogueUI.Frame, "ContraRogueTigu", "使用 剔骨连击点数", 1, 5, 1, x, y, ContraDB.Rogue.Buttons.Shun, "Tigu")

    --10-3 复选框：使用 破甲
    x = x + 220
    ContraUI.CreateCheckBox(Contra.RogueUI.Frame, "ContraRoguePj", "使用 破甲", "施放破甲", x, y, ContraDB.Rogue.Buttons.Shun, "Pj")

    --10-4 滑块：使用 破甲连击点数
    x = x + 150
    ContraUI.CreateSlider(Contra.RogueUI.Frame, "ContraRoguePojia", "使用 破甲连击点数", 1, 5, 1, x, y, ContraDB.Rogue.Buttons.Shun, "Pojia")

    --20-2 按钮： 打断设置
    y = y - 60
    ContraUI.CreateButton(Contra.RogueUI.Frame, "ContraRogueAutoIntrrupt", "自动换装", nil, nil, 80, y, Contra.HasNotBeDone)

    --20-3 按钮： 恢复默认值
    ContraUI.CreateButton(Contra.RogueUI.Frame, "ContraRogueResetDefault", "恢复默认值", nil, nil, 300, y, function() Contra.RogueUI.ResetDefault() end)

    --20-4 按钮： 关闭界面
    ContraUI.CreateButton(Contra.RogueUI.Frame, "ContraRogueCloseUI", "关闭界面", nil, nil, 520, y, function() Contra.RogueUI.Frame:Hide() end)

end


-- 使用不同名称的事件处理框架，避免覆盖Contra.RogueUI.Frame
Contra.RogueUI.eventFrame = CreateFrame("Frame")
Contra.RogueUI.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
Contra.RogueUI.eventFrame:SetScript("OnEvent", Contra.CreatRogueUI)

-- =====================================================
-- 恢复默认值功能 - 参照Contra_UI_Mage.lua实现
-- =====================================================

-- 恢复默认值函数
function Contra.RogueUI.ResetDefault()
    -- 应用默认值到当前配置
    for key, value in pairs(ContraDBDefault.Rogue.Buttons.Shun) do
        ContraDB.Rogue.Buttons.Shun[key] = value
    end
    
    -- 更新所有UI控件的显示
    if Contra.RogueUI.Frame then
        Contra.RogueUI.UpdateAllUI()
    end
    
    -- 打印提示信息
    print("|cFFFFD700[Contra]|r 盗贼设置已恢复默认值")
end

-- 更新所有UI控件的函数
function Contra.RogueUI.UpdateAllUI()
    if not Contra.RogueUI.Frame then return end
    
    -- 更新所有复选框状态
    ContraUI.UpdateCheckBox("ContraRogueXiaoshi", ContraDB.Rogue.Buttons.Shun.Xiaoshi)
    ContraUI.UpdateCheckBox("ContraRogueShanbi", ContraDB.Rogue.Buttons.Shun.Shanbi)
    ContraUI.UpdateCheckBox("ContraRogueWudi", ContraDB.Rogue.Buttons.Shun.Wudi)
    ContraUI.UpdateCheckBox("ContraRogueTang", ContraDB.Rogue.Buttons.Shun.Tang)
    ContraUI.UpdateCheckBox("ContraRogueCyc", ContraDB.Rogue.Buttons.Shun.Cyc)
    ContraUI.UpdateCheckBox("ContraRogueDahong", ContraDB.Rogue.Buttons.Shun.Dahong)
    ContraUI.UpdateCheckBox("ContraRogueHuanji", ContraDB.Rogue.Buttons.Shun.Huanji)
    ContraUI.UpdateCheckBox("ContraRogueJhc", ContraDB.Rogue.Buttons.Shun.Jhc)
    ContraUI.UpdateCheckBox("ContraRogueZhongzu", ContraDB.Rogue.Buttons.Shun.Zhongzu)
    ContraUI.UpdateCheckBox("ContraRogueGuimei", ContraDB.Rogue.Buttons.Shun.Guimei)
    ContraUI.UpdateCheckBox("ContraRoguexiee", ContraDB.Rogue.Buttons.Shun.xiee)
    ContraUI.UpdateCheckBox("ContraRogueDaduan", ContraDB.Rogue.Buttons.Shun.Daduan)
    ContraUI.UpdateCheckBox("ContraRogueSWBJ", ContraDB.Rogue.Buttons.Shun.SWBJ)
    ContraUI.UpdateCheckBox("ContraRogueSy", ContraDB.Rogue.Buttons.Shun.Sy)
    ContraUI.UpdateCheckBox("ContraRogueDs", ContraDB.Rogue.Buttons.Shun.Ds)
    ContraUI.UpdateCheckBox("ContraRogueQg", ContraDB.Rogue.Buttons.Shun.Qg)
    ContraUI.UpdateCheckBox("ContraRogueGl", ContraDB.Rogue.Buttons.Shun.Gl)
    ContraUI.UpdateCheckBox("ContraRogueTg", ContraDB.Rogue.Buttons.Shun.Tg)
    ContraUI.UpdateCheckBox("ContraRoguePj", ContraDB.Rogue.Buttons.Shun.Pj)
    
    -- 更新所有滑块值
    ContraUI.UpdateSlider("ContraRogueSiwangbiaoji", ContraDB.Rogue.Buttons.Shun.Siwangbiaoji, "使用死亡标记: ")
    ContraUI.UpdateSlider("ContraRogueSiying", ContraDB.Rogue.Buttons.Shun.Siying, "使用 死亡之影连击点数: ")
    ContraUI.UpdateSlider("ContraRogueDushang", ContraDB.Rogue.Buttons.Shun.Dushang, "使用 毒伤连击点数: ")
    ContraUI.UpdateSlider("ContraRogueQiege", ContraDB.Rogue.Buttons.Shun.Qiege, "使用 切割连击点数: ")
    ContraUI.UpdateSlider("ContraRogueGelie", ContraDB.Rogue.Buttons.Shun.Gelie, "使用 割裂连击点数: ")
    ContraUI.UpdateSlider("ContraRogueTigu", ContraDB.Rogue.Buttons.Shun.Tigu, "使用 剔骨连击点数: ")
    ContraUI.UpdateSlider("ContraRoguePojia", ContraDB.Rogue.Buttons.Shun.Pojia, "使用 破甲连击点数: ")
end



