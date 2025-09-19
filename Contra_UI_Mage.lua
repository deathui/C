----------------------------------------------------------------------------
----------------------------------------------------------------------------
---
---
---                             奥法界面设置
--- 
--- 
----------------------------------------------------------------------------
----------------------------------------------------------------------------


Contra.MageUI = Contra.MageUI or {}

-- 使用Contra_UI_DB.lua中定义的ContraDB结构
-- ContraDB.Mage.Buttons.Arcane 等已经由Contra_UI_DB.lua初始化

-- 界面设置 - Contra法师专用
Contra.MageUI_Settings = {
    Width = 760,
    Height = 650,
    HeaderHeight = 64,
    SectionSpacing = 10,
    ButtonWidth = 220,
    ButtonHeight = 25,
    SliderWidth = 160,
    SliderHeight = 3
}

-- 背景模板 - Contra法师专用
Contra.MageUI_BackdropTemplate = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
}

-- 颜色定义 - Contra法师专用
Contra.MageUI_Colors = {
    Background = { 0.05, 0.08, 0.12, 0.95 },
    Border = { 0.41, 0.8, 0.94, 1 }, -- 对应 #69CCF0 的 RGB 值 (105/255, 204/255, 240/255)
    Header = { 0.41, 0.8, 0.94, 1 }, -- 对应 #69CCF0
    Text = { 1, 1, 1, 1 },
    Disabled = { 0.4, 0.5, 0.6, 1 },
    Highlight = { 0.41, 0.8, 0.94, 0.7 } -- 使用相同的颜色但降低透明度
}

function Contra.HasNotBeDone()
    print("此功能暂未完成")
end

-- 创建主窗口
function Contra.MageUI.CreateMainFrame()
    -- 主框架
    Contra.MageUI.Frame = CreateFrame("Frame", "ContraMageMainFrame", UIParent)
    Contra.MageUI.Frame:SetFrameStrata("MEDIUM")
    Contra.MageUI.Frame:SetWidth(Contra.MageUI_Settings.Width)
    Contra.MageUI.Frame:SetHeight(Contra.MageUI_Settings.Height)
    Contra.MageUI.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    Contra.MageUI.Frame:SetBackdrop(Contra.MageUI_BackdropTemplate)
    Contra.MageUI.Frame:SetBackdropColor(unpack(Contra.MageUI_Colors.Background))
    Contra.MageUI.Frame:SetBackdropBorderColor(unpack(Contra.MageUI_Colors.Border))
    Contra.MageUI.Frame:EnableMouse(true)
    Contra.MageUI.Frame:SetMovable(true)
    Contra.MageUI.Frame:RegisterForDrag("LeftButton")
    Contra.MageUI.Frame:SetScript("OnDragStart", function() Contra.MageUI.Frame:StartMoving() end)
    Contra.MageUI.Frame:SetScript("OnDragStop", function() Contra.MageUI.Frame:StopMovingOrSizing() end)
    Contra.MageUI.Frame:Hide()

    -- 标题背景
    Contra.MageUI.Frame.Title = Contra.MageUI.Frame:CreateTexture("ContraMageMainFrameHeader", "ARTWORK")
    Contra.MageUI.Frame.Title:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    Contra.MageUI.Frame.Title:SetWidth(400)
    Contra.MageUI.Frame.Title:SetHeight(64)
    Contra.MageUI.Frame.Title:SetPoint("TOP", Contra.MageUI.Frame, "TOP", 0, 12)
    
    -- 标题文字
    Contra.MageUI.Frame.Title.Text = Contra.MageUI.Frame:CreateFontString(nil, "OVERLAY")
    Contra.MageUI.Frame.Title.Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
    Contra.MageUI.Frame.Title.Text:SetPoint("CENTER", Contra.MageUI.Frame.Title, "CENTER", 0, 11)
    Contra.MageUI.Frame.Title.Text:SetText("Contra 奥法助手")
    Contra.MageUI.Frame.Title.Text:SetTextColor(unpack(Contra.MageUI_Colors.Header))

    -- 作者信息
    Contra.MageUI.Frame.Author = Contra.MageUI.Frame:CreateFontString(nil, "OVERLAY")
    Contra.MageUI.Frame.Author:SetFont(STANDARD_TEXT_FONT, 9)
    Contra.MageUI.Frame.Author:SetTextColor(0.6, 0.6, 0.6)
    Contra.MageUI.Frame.Author:SetPoint("BOTTOMRIGHT", Contra.MageUI.Frame, "BOTTOMRIGHT", -24, 11)
    Contra.MageUI.Frame.Author:SetText("by:魂斗罗工会")


    --创建一个无边框底纹的按钮，位于框体的右上方，文本用一个颜色风格与标题一致的字母X显示
    Contra.MageUI.Frame.CloseButton = CreateFrame("Button", nil, Contra.MageUI.Frame)
    Contra.MageUI.Frame.CloseButton:SetPoint("TOPRIGHT", Contra.MageUI.Frame, "TOPRIGHT", -10, -10)
    Contra.MageUI.Frame.CloseButton:SetWidth(20)
    Contra.MageUI.Frame.CloseButton:SetHeight(20)
    --设置显示文本为X
    Contra.MageUI.Frame.CloseButton:SetText("X")
    Contra.MageUI.Frame.CloseButton:SetFont(STANDARD_TEXT_FONT, 14)
    Contra.MageUI.Frame.CloseButton:SetTextColor(0.41, 0.8, 0.94, 1)
    Contra.MageUI.Frame.CloseButton:SetScript("OnClick", function()
        Contra.MageUI.Frame:Hide()
    end)
    --设置鼠标指向时文本高亮
    Contra.MageUI.Frame.CloseButton:SetScript("OnEnter", function()
        Contra.MageUI.Frame.CloseButton:SetTextColor(0.94, 0.25, 0.41, 1)
    end)
    --设置鼠标离开时文本取消高亮
    Contra.MageUI.Frame.CloseButton:SetScript("OnLeave", function()
        Contra.MageUI.Frame.CloseButton:SetTextColor(0.41, 0.8, 0.94, 1)
    end)
 
end

-- /run C_Timer.After(0.1, function() print("1") end);print(2)

function Contra.CreatMageUI()

    if Contra.MyClass ~= "法师" then return end

    if Contra.MageUI.Frame then return end

    local x,y = 40,-70

    -- 先创建主框架
    Contra.MageUI.CreateMainFrame()

    --1-1 标题：药水设置
    Contra.MageUI.TitleMana = ContraUI.CreateTitle(Contra.MageUI.Frame, "消耗品设置", Contra.MageUI_Colors.Header, x, y)
    
    --2-1 复选框：Boss使用法力药水
    y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUseManaPotionsBossToggle", "Boss使用法力药水", "Boss使用法力药水", x, y, ContraDB.Mage.Buttons.Arcane, "UseManaPotionsBossToggle")
   
    --2-2 拖动条：法力药水使用间隔
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneUseManaPotionsBossNum", "法力缺失阈值 ≥ ", 2250, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Arcane, "UseManaPotionsBossNum")

    --2-3 复选框：非Boss使用法力药水
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUseManaPotionsNotBossToggle", "非Boss使用法力药水", "非Boss使用法力药水", x, y, ContraDB.Mage.Buttons.Arcane, "UseManaPotionsNotBossToggle")

    --2-4 拖动条：非Boss使用法力药水
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneUseManaPotionsNotBossNum", "法力缺失阈值 ≥ ", 2250, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Arcane, "UseManaPotionsNotBossNum")

    --3-1 复选框：Boss使用草药茶
    x = 40 ; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneContraUseHerbsBossToggle", "Boss使用草药茶", "Boss使用草药茶", x, y, ContraDB.Mage.Buttons.Arcane, "UseHerbsBossToggle")

    --3-2 拖动条：Boss使用草药茶的阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneUseHerbsBossNum", "法力缺失阈值 ≥ ", 1350, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Arcane, "UseHerbsBossNum")

    --3-3 复选框：非Boss使用草药茶
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUseHerbsNotBossToggle", "非Boss使用草药茶", "非Boss使用草药茶", x, y, ContraDB.Mage.Buttons.Arcane, "UseHerbsNotBossToggle")

    --3-4 拖动条：非boss使用草药茶阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneUseHerbsNotBossNum", "法力缺失阈值 ≥ ", 1350, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Arcane, "UseHerbsNotBossNum")

    --4-1 复选框：Boss使用法力宝石
    x = 40 ; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUseManaGemBossToggle", "Boss使用法力宝石", "Boss使用法力宝石", x, y, ContraDB.Mage.Buttons.Arcane, "UseManaGemBossToggle")

    --4-2 拖动条：Boss使用法力宝石的阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneUseManaGemBossNum", "法力缺失阈值 ≥ ", 1350, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Arcane, "UseManaGemBossNum")

    -- 4-3 复选框：非Boss使用法力宝石
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUseManaGemNotBossToggle", "非Boss使用法力宝石", "非Boss使用法力宝石", x, y, ContraDB.Mage.Buttons.Arcane, "UseManaGemNotBossToggle")

    --4-4 拖动条：非Boss使用法力宝石的阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneUseManaGemNotBossNum", "法力缺失阈值 ≥ ", 1350, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Arcane, "UseManaGemNotBossNum")

    --5-1 复选框：Boss使用有限无敌
    x = 40 ; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUseInvulnerabilityBossToggle", "Boss使用有限无敌", "Boss使用有限无敌", x, y, ContraDB.Mage.Buttons.Arcane, "UseInvulnerabilityBossToggle")

    --5-3 复选框：非Boss使用有限无敌
    x = x + 370
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUseInvulnerabilityNotBossToggle", "AOE场景使用有限无敌", "AOE场景下，当血量百分比少于设定值使用有限无敌,需要开启自动魔爆术", x, y, ContraDB.Mage.Buttons.Arcane, "UseInvulnerabilityNotBossToggle")

    --5-4 拖动条：非Boss使用有限无敌的阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneUseInvulnerabilityNotBossPercNum", "血量百分比阈值 ≤ ", 0, 100, 5, x, y-4, ContraDB.Mage.Buttons.Arcane, "UseInvulnerabilityNotBossPercNum")


    --6-1 标题：基础开关
    x = 40 ; y = y - 50
    Contra.MageUI.TitleBase = ContraUI.CreateTitle(Contra.MageUI.Frame, "基础设置", Contra.MageUI_Colors.Header, x, y)

    --7-1 复选框：自动选择目标
    y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneAutoSelectTargetToggle", "自动选择目标", "自动选择目前正在战斗中的目标，不会误开怪", x, y, ContraDB.Mage.Buttons.Arcane, "AutoSelectTargetToggle")

    --7-2 复选框：自动补buff
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneAutoBuffToggle", "自动补buff", "自动补buff", x, y, ContraDB.Mage.Buttons.Arcane, "AutoBuffToggle")

    --7-3 复选框：自动制作法力宝石
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneAutoManaGemToggle", "自动制作法力宝石", "自动制作法力宝石", x, y, ContraDB.Mage.Buttons.Arcane, "AutoCreateManaGemsToggle")

    --7-4 复选框：自动吃橘子
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneAutoEatToggle", "自动吃橘子", "自动吃橘子", x, y, ContraDB.Mage.Buttons.Arcane, "AutoEatOrange")


    --8-1 标题：技能设置
    x = 40 ; y = y - 50
    Contra.MageUI.TitleSkill = ContraUI.CreateTitle(Contra.MageUI.Frame, "技能设置", Contra.MageUI_Colors.Header, x, y)

    --9-1 复选框：目标是boss时使用奥术强化
    y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneArcanePowerBossToggle", "Boss使用奥术强化", "目标为Boss且魔法值百分比大于指定值时使用奥术强化", x, y, ContraDB.Mage.Buttons.Arcane, "ArcanePowerBossToggle")

    --9-2 拖动条：boss时使用奥术强化选择框魔法值百分比小于多少开启拖动条，范围0-100
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneArcanePowerManaPercNum", "魔法值百分比阈值 ≥ ", 0, 100, 5, x, y-4, ContraDB.Mage.Buttons.Arcane, "ArcanePowerManaPercNum")

    --9-3 复选框：目标不是boss时使用奥术强化
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneArcanePowerNotBossToggle", "非Boss使用奥术强化", "目标不是Boss且周围小怪总血量之和大于指定值时使用奥术强化", x, y, ContraDB.Mage.Buttons.Arcane, "ArcanePowerNotBossToggle")

    --9-4 拖动条：非boss时使用奥术强化选择框血量小于多少开启拖动条，范围10000-200000
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneArcanePowerNotBossHealthNum", "血量阈值 ≥ ", 10000, 200000, 10000, x, y-4, ContraDB.Mage.Buttons.Arcane, "ArcanePowerNotBossHealthNum")

    --10-1 复选框：火焰冲击选择框
    x = 40 ; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneFireballToggle", "火焰冲击 [|cFF808080斩杀移动|r]", "玩家在移动或目标血量小于指定值时使用火焰冲击", x, y, ContraDB.Mage.Buttons.Arcane, "FireballToggle")

    --10-2 拖动条：火焰冲击选择框血量小于多少开启拖动条，范围1000-50000
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneFireballHealthNum", "血量阈值 ≤ ", 1000, 20000, 1000, x, y-4, ContraDB.Mage.Buttons.Arcane, "FireballHealthNum")

    --10-3 复选框：奥术涌动选择框
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneArcaneSurgeHealthToggle", "奥术涌动 [|cFF808080斩杀移动|r]", "玩家在移动或目标血量小于指定值时使用奥术涌动", x, y, ContraDB.Mage.Buttons.Arcane, "ArcaneSurgeIsMovingToogle")

    --10-4 拖动条：奥术涌动选择框血量小于多少开启拖动条，范围1000-10000
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneArcaneSurgeHealthNum", "血量阈值 ≤ ", 1000, 20000, 1000, x, y-4, ContraDB.Mage.Buttons.Arcane, "ArcaneSurgeHealthNum")

    --11-1 复选框：魔爆术选择框
    x = 40 ; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUseAoEToggle", "魔爆术", "附近10码内的怪物数量大于等于设定值时，自动使用魔爆术", x, y, ContraDB.Mage.Buttons.Arcane, "UseAoEToggle")

    --11-2 拖动条：魔爆术选择框小怪数量小于多少开启拖动条，范围3-10
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI.Frame, "ContraMageArcaneUseAoEEnemyNum", "小怪数量阈值 ≥ ", 3, 10, 1, x, y-4, ContraDB.Mage.Buttons.Arcane, "UseAoEEnemyNum")

    --11-3 复选框：奥术涌动特殊处理1
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneArcaneSurgeIsCDToggle", "奥术涌动特殊条件-1", "无奥术溃裂BUFF时使用奥术涌动", x, y, ContraDB.Mage.Buttons.Arcane, "ArcaneSurgeIsCDToggle")

    --11-4 复选框：奥术涌动特殊处理2
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneArcaneSurgeNotBuffToggle", "奥术涌动特殊条件-2", "奥术溃裂在CD时使用奥术涌动", x, y, ContraDB.Mage.Buttons.Arcane, "ArcaneSurgeNotBuffToggle")

    --12-1 复选框：气定神闲选择框
    x = 40 ; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcanePresenceOfMindToggle", "气定神闲", "自动使用启动神闲", x, y, ContraDB.Mage.Buttons.Arcane, "PresenceOfMindToggle")

    --12-2 复选框：种族天赋RaceTalentsToggle
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneRaceTalentsToggle", "种族天赋", "自动使用种族天赋", x, y, ContraDB.Mage.Buttons.Arcane, "RaceTalentsToggle")

    --12-3 复选框：打断奥术飞弹释放奥术涌动
    x = x + 220
    ArcaneSurgeIntruptToggle = ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneArcaneSurgeIntruptToggle", "奥术涌动特殊条件-3", "打断奥术飞弹释放奥术涌动", x, y, ContraDB.Mage.Buttons.Arcane, "ArcaneSurgeIntruptToggle")


    --13-1 标题：饰品设置
    x = 40 ; y = y - 50
    Contra.MageUI.TitleAccessory = ContraUI.CreateTitle(Contra.MageUI.Frame, "饰品设置", Contra.MageUI_Colors.Header, x, y)

    --14-1 复选框：Boss使用上饰品位
    y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUse13SoltBossToggle", "Boss使用上饰品", "目标为Boss时自动使用上饰品", x, y, ContraDB.Mage.Buttons.Arcane, "Use13SoltBossToggle")

    --14-2 复选框：Boss使用下饰品
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUse14SlotBossToggle", "Boss使用下饰品", "目标为Boss时自动使用下饰品", x, y, ContraDB.Mage.Buttons.Arcane, "Use14SlotBossToggle")

    --15-1 复选框：非Boss使用上饰品
    x = 40 ; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUse13SoltNotBossToggle", "非Boss使用上饰品", "目标非Boss时自动使用上饰品", x, y, ContraDB.Mage.Buttons.Arcane, "Use13SoltNotBossToggle")

    --15-2 复选框：非Boss使用下饰品
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneUse14SlotNotBossToggle", "非Boss使用下饰品", "目标非Boss时自动使用下饰品", x, y, ContraDB.Mage.Buttons.Arcane, "Use14SlotNotBossToggle")

    --16-1 复选框：切换上饰品选择框
    x = 40 ; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneChange13SlotToggle", "切换上饰品", "脱战后如果上饰品位CD大于30秒，则自动切换饰品", x, y, ContraDB.Mage.Buttons.Arcane, "Change13SlotToggle")

    --17-2 复选框：切换下饰品选择框
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI.Frame, "ContraMageArcaneChange14SlotToggle", "切换下饰品", "脱战后如果下饰品位CD大于30秒，则自动切换饰品", x, y, ContraDB.Mage.Buttons.Arcane, "Change14SlotToggle")

    --20-1 按钮： 恢复默认值
    ContraUI.CreateButton(Contra.MageUI.Frame, "ContraMageArcaneResetDefault", "恢复默认值", nil, nil, 410, -515, Contra.MageUI.ResetDefault)

    --20-2 按钮： 自动换装
    ContraUI.CreateButton(Contra.MageUI.Frame, "ContraMageArcaneAutoChange", "自动换装", nil, nil, 560, -515, Contra.HasNotBeDone)

    --20-3 按钮： 饰品管理器
    ContraUI.CreateButton(Contra.MageUI.Frame, "ContraMageArcaneTinketManager", "饰品管理器", nil, nil, 410, -565, Contra.HasNotBeDone)

    --20-4 按钮： 关闭界面
    ContraUI.CreateButton(Contra.MageUI.Frame, "ContraMageArcaneCloseUI", "关闭界面", nil, nil, 560, -565, function() Contra.MageUI.Frame:Hide() end)

    -- ContraMageMainFrame:Show()
end


-- 使用不同名称的事件处理框架，避免覆盖Contra.MageUI.Frame
Contra.MageUI.eventFrame = CreateFrame("Frame")
Contra.MageUI.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
Contra.MageUI.eventFrame:SetScript("OnEvent", Contra.CreatMageUI)



--添加一个恢复默认值的功能
function Contra.MageUI.ResetDefault()
    
    -- 应用默认值
    for key, value in pairs(ContraDBDefault.Mage.Buttons.Arcane) do
        ContraDB.Mage.Buttons.Arcane[key] = value
    end
    
    -- 更新所有UI控件的显示
    if Contra.MageUI.Frame then
        Contra.MageUI.UpdateAllUI()
    end

end


-- 更新所有UI控件的函数
function Contra.MageUI.UpdateAllUI()
    if not Contra.MageUI.Frame then return end
    
    -- 更新所有复选框
    ContraUI.UpdateCheckBox("ContraMageArcaneUseManaPotionsBossToggle", ContraDB.Mage.Buttons.Arcane.UseManaPotionsBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUseManaPotionsNotBossToggle", ContraDB.Mage.Buttons.Arcane.UseManaPotionsNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneContraUseHerbsBossToggle", ContraDB.Mage.Buttons.Arcane.UseHerbsBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUseHerbsNotBossToggle", ContraDB.Mage.Buttons.Arcane.UseHerbsNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUseManaGemBossToggle", ContraDB.Mage.Buttons.Arcane.UseManaGemBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUseManaGemNotBossToggle", ContraDB.Mage.Buttons.Arcane.UseManaGemNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUseInvulnerabilityBossToggle", ContraDB.Mage.Buttons.Arcane.UseInvulnerabilityBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUseInvulnerabilityNotBossToggle", ContraDB.Mage.Buttons.Arcane.UseInvulnerabilityNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneAutoSelectTargetToggle", ContraDB.Mage.Buttons.Arcane.AutoSelectTargetToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneAutoBuffToggle", ContraDB.Mage.Buttons.Arcane.AutoBuffToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneAutoManaGemToggle", ContraDB.Mage.Buttons.Arcane.AutoCreateManaGemsToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneAutoEatToggle", ContraDB.Mage.Buttons.Arcane.AutoEatOrange)
    ContraUI.UpdateCheckBox("ContraMageArcaneArcanePowerBossToggle", ContraDB.Mage.Buttons.Arcane.ArcanePowerBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneArcanePowerNotBossToggle", ContraDB.Mage.Buttons.Arcane.ArcanePowerNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneFireballToggle", ContraDB.Mage.Buttons.Arcane.FireballToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneArcaneSurgeHealthToggle", ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIsMovingToogle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUseAoEToggle", ContraDB.Mage.Buttons.Arcane.UseAoEToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneArcaneSurgeIsCDToggle", ContraDB.Mage.Buttons.Arcane.ArcaneSurgeIsCDToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneArcaneSurgeNotBuffToggle", ContraDB.Mage.Buttons.Arcane.ArcaneSurgeNotBuffToggle)
    ContraUI.UpdateCheckBox("ContraMageArcanePresenceOfMindToggle", ContraDB.Mage.Buttons.Arcane.PresenceOfMindToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneRaceTalentsToggle", ContraDB.Mage.Buttons.Arcane.RaceTalentsToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUse13SoltBossToggle", ContraDB.Mage.Buttons.Arcane.Use13SoltBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUse14SlotBossToggle", ContraDB.Mage.Buttons.Arcane.Use14SlotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUse13SoltNotBossToggle", ContraDB.Mage.Buttons.Arcane.Use13SoltNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneUse14SlotNotBossToggle", ContraDB.Mage.Buttons.Arcane.Use14SlotNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneChange13SlotToggle", ContraDB.Mage.Buttons.Arcane.Change13SlotToggle)
    ContraUI.UpdateCheckBox("ContraMageArcaneChange14SlotToggle", ContraDB.Mage.Buttons.Arcane.Change14SlotToggle)
    
    -- 更新所有滑块
    ContraUI.UpdateSlider("ContraMageArcaneUseManaPotionsBossNum", ContraDB.Mage.Buttons.Arcane.UseManaPotionsBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageArcaneUseManaPotionsNotBossNum", ContraDB.Mage.Buttons.Arcane.UseManaPotionsNotBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageArcaneUseHerbsBossNum", ContraDB.Mage.Buttons.Arcane.UseHerbsBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageArcaneUseHerbsNotBossNum", ContraDB.Mage.Buttons.Arcane.UseHerbsNotBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageArcaneUseManaGemBossNum", ContraDB.Mage.Buttons.Arcane.UseManaGemBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageArcaneUseManaGemNotBossNum", ContraDB.Mage.Buttons.Arcane.UseManaGemNotBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageArcaneUseInvulnerabilityNotBossPercNum", ContraDB.Mage.Buttons.Arcane.UseInvulnerabilityNotBossPercNum, "血量百分比阈值 ≤ ")
    ContraUI.UpdateSlider("ContraMageArcaneArcanePowerManaPercNum", ContraDB.Mage.Buttons.Arcane.ArcanePowerManaPercNum, "魔法值百分比阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageArcaneArcanePowerNotBossHealthNum", ContraDB.Mage.Buttons.Arcane.ArcanePowerNotBossHealthNum, "血量阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageArcaneFireballHealthNum", ContraDB.Mage.Buttons.Arcane.FireballHealthNum, "血量阈值 ≤ ")
    ContraUI.UpdateSlider("ContraMageArcaneArcaneSurgeHealthNum", ContraDB.Mage.Buttons.Arcane.ArcaneSurgeHealthNum, "血量阈值 ≤ ")
    ContraUI.UpdateSlider("ContraMageArcaneUseAoEEnemyNum", ContraDB.Mage.Buttons.Arcane.UseAoEEnemyNum, "小怪数量阈值 ≥ ")
end



----------------------------------------------------------------------------
----------------------------------------------------------------------------
---
---
---                             冰法界面设置
--- 
--- 
----------------------------------------------------------------------------
----------------------------------------------------------------------------


Contra.MageUI_Frost = Contra.MageUI_Frost or {}

-- 冰法界面设置
Contra.MageUI_Frost_Settings = {
    Width = 760,
    Height = 650,
    HeaderHeight = 64,
    SectionSpacing = 10,
    ButtonWidth = 220,
    ButtonHeight = 25,
    SliderWidth = 160,
    SliderHeight = 3
}

-- 使用相同的背景模板和颜色定义
Contra.MageUI_Frost_BackdropTemplate = Contra.MageUI_BackdropTemplate
Contra.MageUI_Frost_Colors = Contra.MageUI_Colors

-- 创建冰法主窗口
function Contra.MageUI_Frost.CreateMainFrame()
    -- 主框架
    Contra.MageUI_Frost.Frame = CreateFrame("Frame", "ContraMageFrostMainFrame", UIParent)
    Contra.MageUI_Frost.Frame:SetFrameStrata("MEDIUM")
    Contra.MageUI_Frost.Frame:SetWidth(Contra.MageUI_Frost_Settings.Width)
    Contra.MageUI_Frost.Frame:SetHeight(Contra.MageUI_Frost_Settings.Height)
    Contra.MageUI_Frost.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    Contra.MageUI_Frost.Frame:SetBackdrop(Contra.MageUI_Frost_BackdropTemplate)
    Contra.MageUI_Frost.Frame:SetBackdropColor(unpack(Contra.MageUI_Frost_Colors.Background))
    Contra.MageUI_Frost.Frame:SetBackdropBorderColor(unpack(Contra.MageUI_Frost_Colors.Border))
    Contra.MageUI_Frost.Frame:EnableMouse(true)
    Contra.MageUI_Frost.Frame:SetMovable(true)
    Contra.MageUI_Frost.Frame:RegisterForDrag("LeftButton")
    Contra.MageUI_Frost.Frame:SetScript("OnDragStart", function() Contra.MageUI_Frost.Frame:StartMoving() end)
    Contra.MageUI_Frost.Frame:SetScript("OnDragStop", function() Contra.MageUI_Frost.Frame:StopMovingOrSizing() end)
    Contra.MageUI_Frost.Frame:Hide()

    -- 标题背景
    Contra.MageUI_Frost.Frame.Title = Contra.MageUI_Frost.Frame:CreateTexture("ContraMageFrostMainFrameHeader", "ARTWORK")
    Contra.MageUI_Frost.Frame.Title:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    Contra.MageUI_Frost.Frame.Title:SetWidth(400)
    Contra.MageUI_Frost.Frame.Title:SetHeight(64)
    Contra.MageUI_Frost.Frame.Title:SetPoint("TOP", Contra.MageUI_Frost.Frame, "TOP", 0, 12)
    
    -- 标题文字
    Contra.MageUI_Frost.Frame.Title.Text = Contra.MageUI_Frost.Frame:CreateFontString(nil, "OVERLAY")
    Contra.MageUI_Frost.Frame.Title.Text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
    Contra.MageUI_Frost.Frame.Title.Text:SetPoint("CENTER", Contra.MageUI_Frost.Frame.Title, "CENTER", 0, 11)
    Contra.MageUI_Frost.Frame.Title.Text:SetText("Contra 冰法助手")
    Contra.MageUI_Frost.Frame.Title.Text:SetTextColor(unpack(Contra.MageUI_Frost_Colors.Header))

    -- 作者信息
    Contra.MageUI_Frost.Frame.Author = Contra.MageUI_Frost.Frame:CreateFontString(nil, "OVERLAY")
    Contra.MageUI_Frost.Frame.Author:SetFont(STANDARD_TEXT_FONT, 9)
    Contra.MageUI_Frost.Frame.Author:SetTextColor(0.6, 0.6, 0.6)
    Contra.MageUI_Frost.Frame.Author:SetPoint("BOTTOMRIGHT", Contra.MageUI_Frost.Frame, "BOTTOMRIGHT", -24, 11)
    Contra.MageUI_Frost.Frame.Author:SetText("by:魂斗罗工会")

    -- 关闭按钮
    Contra.MageUI_Frost.Frame.CloseButton = CreateFrame("Button", nil, Contra.MageUI_Frost.Frame)
    Contra.MageUI_Frost.Frame.CloseButton:SetPoint("TOPRIGHT", Contra.MageUI_Frost.Frame, "TOPRIGHT", -10, -10)
    Contra.MageUI_Frost.Frame.CloseButton:SetWidth(20)
    Contra.MageUI_Frost.Frame.CloseButton:SetHeight(20)
    Contra.MageUI_Frost.Frame.CloseButton:SetText("X")
    Contra.MageUI_Frost.Frame.CloseButton:SetFont(STANDARD_TEXT_FONT, 14)
    Contra.MageUI_Frost.Frame.CloseButton:SetTextColor(0.41, 0.8, 0.94, 1)
    Contra.MageUI_Frost.Frame.CloseButton:SetScript("OnClick", function()
        Contra.MageUI_Frost.Frame:Hide()
    end)
    Contra.MageUI_Frost.Frame.CloseButton:SetScript("OnEnter", function()
        Contra.MageUI_Frost.Frame.CloseButton:SetTextColor(0.94, 0.25, 0.41, 1)
    end)
    Contra.MageUI_Frost.Frame.CloseButton:SetScript("OnLeave", function()
        Contra.MageUI_Frost.Frame.CloseButton:SetTextColor(0.41, 0.8, 0.94, 1)
    end)
end

function Contra.CreatMageUI_Frost()

    if Contra.MyClass ~= "法师" then return end

    if Contra.MageUI_Frost.Frame then return end

    local x, y = 40, -70

    -- 先创建主框架
    Contra.MageUI_Frost.CreateMainFrame()

    -- 1-1 标题：药水设置
    Contra.MageUI_Frost.TitleMana = ContraUI.CreateTitle(Contra.MageUI_Frost.Frame, "消耗品设置", Contra.MageUI_Frost_Colors.Header, x, y)
    
    -- 2-1 复选框：Boss使用法力药水
    y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseManaPotionsBossToggle", "Boss使用法力药水", "Boss使用法力药水", x, y, ContraDB.Mage.Buttons.Frost, "UseManaPotionsBossToggle")
   
    -- 2-2 拖动条：法力药水使用间隔
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostUseManaPotionsBossNum", "法力缺失阈值 ≥ ", 2250, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Frost, "UseManaPotionsBossNum")

    -- 2-3 复选框：非Boss使用法力药水
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseManaPotionsNotBossToggle", "非Boss使用法力药水", "非Boss使用法力药水", x, y, ContraDB.Mage.Buttons.Frost, "UseManaPotionsNotBossToggle")

    -- 2-4 拖动条：非Boss使用法力药水
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostUseManaPotionsNotBossNum", "法力缺失阈值 ≥ ", 2250, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Frost, "UseManaPotionsNotBossNum")

    -- 3-1 复选框：Boss使用草药茶
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseHerbsBossToggle", "Boss使用草药茶", "Boss使用草药茶", x, y, ContraDB.Mage.Buttons.Frost, "UseHerbsBossToggle")

    -- 3-2 拖动条：Boss使用草药茶的阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostUseHerbsBossNum", "法力缺失阈值 ≥ ", 1350, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Frost, "UseHerbsBossNum")

    -- 3-3 复选框：非Boss使用草药茶
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseHerbsNotBossToggle", "非Boss使用草药茶", "非Boss使用草药茶", x, y, ContraDB.Mage.Buttons.Frost, "UseHerbsNotBossToggle")

    -- 3-4 拖动条：非boss使用草药茶阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostUseHerbsNotBossNum", "法力缺失阈值 ≥ ", 1350, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Frost, "UseHerbsNotBossNum")

    -- 4-1 复选框：Boss使用法力宝石
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseManaGemBossToggle", "Boss使用法力宝石", "Boss使用法力宝石", x, y, ContraDB.Mage.Buttons.Frost, "UseManaGemBossToggle")

    -- 4-2 拖动条：Boss使用法力宝石的阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostUseManaGemBossNum", "法力缺失阈值 ≥ ", 1350, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Frost, "UseManaGemBossNum")

    -- 4-3 复选框：非Boss使用法力宝石
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseManaGemNotBossToggle", "非Boss使用法力宝石", "非Boss使用法力宝石", x, y, ContraDB.Mage.Buttons.Frost, "UseManaGemNotBossToggle")

    -- 4-4 拖动条：非Boss使用法力宝石的阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostUseManaGemNotBossNum", "法力缺失阈值 ≥ ", 1350, 10000, 50, x, y-4, ContraDB.Mage.Buttons.Frost, "UseManaGemNotBossNum")

    -- 5-1 复选框：Boss使用有限无敌
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseInvulnerabilityBossToggle", "Boss使用有限无敌", "Boss使用有限无敌", x, y, ContraDB.Mage.Buttons.Frost, "UseInvulnerabilityBossToggle")

    -- 5-3 复选框：非Boss使用有限无敌
    x = x + 370
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseInvulnerabilityNotBossToggle", "AOE场景使用有限无敌", "AOE场景下，当血量百分比少于设定值使用有限无敌,需要开启自动魔爆术", x, y, ContraDB.Mage.Buttons.Frost, "UseInvulnerabilityNotBossToggle")

    -- 5-4 拖动条：非Boss使用有限无敌的阈值
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostUseInvulnerabilityNotBossPercNum", "血量百分比阈值 ≤ ", 0, 100, 5, x, y-4, ContraDB.Mage.Buttons.Frost, "UseInvulnerabilityNotBossPercNum")

    -- 6-1 标题：基础开关
    x = 40; y = y - 50
    Contra.MageUI_Frost.TitleBase = ContraUI.CreateTitle(Contra.MageUI_Frost.Frame, "基础设置", Contra.MageUI_Frost_Colors.Header, x, y)

    -- 7-1 复选框：自动选择目标
    y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostAutoSelectTargetToggle", "自动选择目标", "自动选择目前正在战斗中的目标，不会误开怪", x, y, ContraDB.Mage.Buttons.Frost, "AutoSelectTargetToggle")

    -- 7-2 复选框：自动补buff
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostAutoBuffToggle", "自动补buff", "自动补buff", x, y, ContraDB.Mage.Buttons.Frost, "AutoBuffToggle")

    -- 7-3 复选框：自动制作法力宝石
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostAutoManaGemToggle", "自动制作法力宝石", "自动制作法力宝石", x, y, ContraDB.Mage.Buttons.Frost, "AutoCreateManaGemsToggle")

    -- 7-4 复选框：自动吃橘子
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostAutoEatToggle", "自动吃橘子", "自动吃橘子", x, y, ContraDB.Mage.Buttons.Frost, "AutoEatOrange")

    -- 8-1 标题：技能设置
    x = 40; y = y - 50
    Contra.MageUI_Frost.TitleSkill = ContraUI.CreateTitle(Contra.MageUI_Frost.Frame, "技能设置", Contra.MageUI_Frost_Colors.Header, x, y)

    -- 9-1 复选框：冰盾启用开关
    y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostIceShieldToggle", "冰盾术", "自动使用冰盾，并根据魔法值百分比切换1级和满级", x, y, ContraDB.Mage.Buttons.Frost, "IceShieldToggle")

    -- 9-2 拖动条：切换为1级冰盾的当前魔法值百分比
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostIceShieldPercent", "魔法值百分比阈值 ≤ ", 0, 100, 5, x, y-4, ContraDB.Mage.Buttons.Frost, "IceShieldPercent")

    -- 9-3 复选框：冰锥启用开关
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostConeofColdToggle", "冰锥术", "自动使用冰锥术，根据魔法值百分比切换1级和满级", x, y, ContraDB.Mage.Buttons.Frost, "ConeofColdToggle")

    -- 9-4 拖动条：切换为1级冰锥的当前魔法值百分比
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostConeofColdPercent", "魔法值百分比阈值 ≤ ", 0, 100, 5, x, y-4, ContraDB.Mage.Buttons.Frost, "ConeofColdPercent")

    -- 10-1 复选框：魔爆术选择框
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUseAoEToggle", "魔爆术", "附近10码内的怪物数量大于等于设定值时，自动使用魔爆术", x, y, ContraDB.Mage.Buttons.Frost, "UseAoEToggle")

    -- 10-2 拖动条：魔爆术选择框小怪数量小于多少开启拖动条，范围3-10
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostUseAoEEnemyNum", "小怪数量阈值 ≥ ", 3, 10, 1, x, y-4, ContraDB.Mage.Buttons.Frost, "UseAoEEnemyNum")

    -- 10-3 复选框：火焰冲击选择框
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostFireballToggle", "火焰冲击 [|cFF808080斩杀移动|r]", "玩家在移动或目标血量小于指定值时使用火焰冲击", x, y, ContraDB.Mage.Buttons.Frost, "FireballToggle")

    -- 10-4 拖动条：火焰冲击选择框血量小于多少开启拖动条，范围1000-50000
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostFireballHealthNum", "血量阈值 ≤ ", 1000, 20000, 1000, x, y-4, ContraDB.Mage.Buttons.Frost, "FireballHealthNum")

    -- 11-1 复选框：打断寒冰箭，施放冰柱
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostStopCastingToggle", "断寒冰箭施放冰柱", "当冰柱触发，寒冰箭剩余读条时间大于指定值的时候打断寒冰箭释放冰柱", x, y, ContraDB.Mage.Buttons.Frost, "StopCastingToggle")

    -- 11-2 拖动条：寒冰箭读条剩余时间大于此值时打断
    x = x + 150
    ContraUI.CreateSlider(Contra.MageUI_Frost.Frame, "ContraMageFrostStopCastingTimeNum", "读条剩余时间 ≥ ", 0.1, 2.0, 0.1, x, y-4, ContraDB.Mage.Buttons.Frost, "StopCastingTimeNum")

    -- 11-3 复选框：BOSS战使用极速冷却
    x = x + 220
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostColdSnapBossToggle", "BOSS战使用极速冷却", "目标为Boss时自动使用极速冷却", x, y, ContraDB.Mage.Buttons.Frost, "ColdSnapBossToggle")

    -- 11-4 复选框：种族天赋
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostRaceTalentsToggle", "种族天赋", "自动使用种族天赋", x, y, ContraDB.Mage.Buttons.Frost, "RaceTalentsToggle")

    -- 12-1 标题：饰品设置
    x = 40; y = y - 50
    Contra.MageUI_Frost.TitleAccessory = ContraUI.CreateTitle(Contra.MageUI_Frost.Frame, "饰品设置", Contra.MageUI_Frost_Colors.Header, x, y)

    -- 13-1 复选框：Boss使用上饰品位
    y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUse13SoltBossToggle", "Boss使用上饰品", "目标为Boss时自动使用上饰品", x, y, ContraDB.Mage.Buttons.Frost, "Use13SoltBossToggle")

    -- 13-2 复选框：Boss使用下饰品
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUse14SlotBossToggle", "Boss使用下饰品", "目标为Boss时自动使用下饰品", x, y, ContraDB.Mage.Buttons.Frost, "Use14SlotBossToggle")

    -- 14-1 复选框：非Boss使用上饰品
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUse13SoltNotBossToggle", "非Boss使用上饰品", "目标非Boss时自动使用上饰品", x, y, ContraDB.Mage.Buttons.Frost, "Use13SoltNotBossToggle")

    -- 14-2 复选框：非Boss使用下饰品
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostUse14SlotNotBossToggle", "非Boss使用下饰品", "目标非Boss时自动使用下饰品", x, y, ContraDB.Mage.Buttons.Frost, "Use14SlotNotBossToggle")

    -- 15-1 复选框：切换上饰品选择框
    x = 40; y = y - 30
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostChange13SlotToggle", "切换上饰品", "脱战后如果上饰品位CD大于30秒，则自动切换饰品", x, y, ContraDB.Mage.Buttons.Frost, "Change13SlotToggle")

    -- 15-2 复选框：切换下饰品选择框
    x = x + 150
    ContraUI.CreateCheckBox(Contra.MageUI_Frost.Frame, "ContraMageFrostChange14SlotToggle", "切换下饰品", "脱战后如果下饰品位CD大于30秒，则自动切换饰品", x, y, ContraDB.Mage.Buttons.Frost, "Change14SlotToggle")

    -- 16-1 按钮：恢复默认值
    ContraUI.CreateButton(Contra.MageUI_Frost.Frame, "ContraMageFrostResetDefault", "恢复默认值", nil, nil, 410, -515, Contra.MageUI_Frost.ResetDefault)

    -- 16-2 按钮：自动换装
    ContraUI.CreateButton(Contra.MageUI_Frost.Frame, "ContraMageFrostAutoChange", "自动换装", nil, nil, 560, -515, Contra.HasNotBeDone)

    -- 16-3 按钮：饰品管理器
    ContraUI.CreateButton(Contra.MageUI_Frost.Frame, "ContraMageFrostTinketManager", "饰品管理器", nil, nil, 410, -565, Contra.HasNotBeDone)

    -- 16-4 按钮：关闭界面
    ContraUI.CreateButton(Contra.MageUI_Frost.Frame, "ContraMageFrostCloseUI", "关闭界面", nil, nil, 560, -565, function() Contra.MageUI_Frost.Frame:Hide() end)

end

-- 恢复冰法默认值功能
function Contra.MageUI_Frost.ResetDefault()
    -- 应用默认值
    for key, value in pairs(ContraDBDefault.Mage.Buttons.Frost) do
        ContraDB.Mage.Buttons.Frost[key] = value
    end
    
    -- 更新所有UI控件的显示
    if Contra.MageUI_Frost.Frame then
        Contra.MageUI_Frost.UpdateAllUI()
    end
end

-- 更新冰法所有UI控件的函数
function Contra.MageUI_Frost.UpdateAllUI()
    if not Contra.MageUI_Frost.Frame then return end
    
    -- 更新所有复选框
    ContraUI.UpdateCheckBox("ContraMageFrostUseManaPotionsBossToggle", ContraDB.Mage.Buttons.Frost.UseManaPotionsBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUseManaPotionsNotBossToggle", ContraDB.Mage.Buttons.Frost.UseManaPotionsNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUseHerbsBossToggle", ContraDB.Mage.Buttons.Frost.UseHerbsBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUseHerbsNotBossToggle", ContraDB.Mage.Buttons.Frost.UseHerbsNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUseManaGemBossToggle", ContraDB.Mage.Buttons.Frost.UseManaGemBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUseManaGemNotBossToggle", ContraDB.Mage.Buttons.Frost.UseManaGemNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUseInvulnerabilityBossToggle", ContraDB.Mage.Buttons.Frost.UseInvulnerabilityBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUseInvulnerabilityNotBossToggle", ContraDB.Mage.Buttons.Frost.UseInvulnerabilityNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostAutoSelectTargetToggle", ContraDB.Mage.Buttons.Frost.AutoSelectTargetToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostAutoBuffToggle", ContraDB.Mage.Buttons.Frost.AutoBuffToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostAutoManaGemToggle", ContraDB.Mage.Buttons.Frost.AutoCreateManaGemsToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostAutoEatToggle", ContraDB.Mage.Buttons.Frost.AutoEatOrange)
    ContraUI.UpdateCheckBox("ContraMageFrostIceShieldToggle", ContraDB.Mage.Buttons.Frost.IceShieldToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostConeofColdToggle", ContraDB.Mage.Buttons.Frost.ConeofColdToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUseAoEToggle", ContraDB.Mage.Buttons.Frost.UseAoEToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostFireballToggle", ContraDB.Mage.Buttons.Frost.FireballToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostStopCastingToggle", ContraDB.Mage.Buttons.Frost.StopCastingToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostColdSnapBossToggle", ContraDB.Mage.Buttons.Frost.ColdSnapBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostRaceTalentsToggle", ContraDB.Mage.Buttons.Frost.RaceTalentsToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUse13SoltBossToggle", ContraDB.Mage.Buttons.Frost.Use13SoltBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUse14SlotBossToggle", ContraDB.Mage.Buttons.Frost.Use14SlotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUse13SoltNotBossToggle", ContraDB.Mage.Buttons.Frost.Use13SoltNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostUse14SlotNotBossToggle", ContraDB.Mage.Buttons.Frost.Use14SlotNotBossToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostChange13SlotToggle", ContraDB.Mage.Buttons.Frost.Change13SlotToggle)
    ContraUI.UpdateCheckBox("ContraMageFrostChange14SlotToggle", ContraDB.Mage.Buttons.Frost.Change14SlotToggle)
    
    -- 更新所有滑块
    ContraUI.UpdateSlider("ContraMageFrostUseManaPotionsBossNum", ContraDB.Mage.Buttons.Frost.UseManaPotionsBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageFrostUseManaPotionsNotBossNum", ContraDB.Mage.Buttons.Frost.UseManaPotionsNotBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageFrostUseHerbsBossNum", ContraDB.Mage.Buttons.Frost.UseHerbsBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageFrostUseHerbsNotBossNum", ContraDB.Mage.Buttons.Frost.UseHerbsNotBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageFrostUseManaGemBossNum", ContraDB.Mage.Buttons.Frost.UseManaGemBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageFrostUseManaGemNotBossNum", ContraDB.Mage.Buttons.Frost.UseManaGemNotBossNum, "法力缺失阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageFrostUseInvulnerabilityNotBossPercNum", ContraDB.Mage.Buttons.Frost.UseInvulnerabilityNotBossPercNum, "血量百分比阈值 ≤ ")
    ContraUI.UpdateSlider("ContraMageFrostIceShieldPercent", ContraDB.Mage.Buttons.Frost.IceShieldPercent, "魔法值百分比阈值 ≤ ")
    ContraUI.UpdateSlider("ContraMageFrostConeofColdPercent", ContraDB.Mage.Buttons.Frost.ConeofColdPercent, "魔法值百分比阈值 ≤ ")
    ContraUI.UpdateSlider("ContraMageFrostUseAoEEnemyNum", ContraDB.Mage.Buttons.Frost.UseAoEEnemyNum, "小怪数量阈值 ≥ ")
    ContraUI.UpdateSlider("ContraMageFrostFireballHealthNum", ContraDB.Mage.Buttons.Frost.FireballHealthNum, "血量阈值 ≤ ")
    ContraUI.UpdateSlider("ContraMageFrostStopCastingTimeNum", ContraDB.Mage.Buttons.Frost.StopCastingTimeNum, "读条剩余时间 ≥ ")
end

-- 使用不同的事件处理框架，避免冲突
Contra.MageUI_Frost.eventFrame = CreateFrame("Frame")
Contra.MageUI_Frost.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
Contra.MageUI_Frost.eventFrame:SetScript("OnEvent", Contra.CreatMageUI_Frost)




----------------------------------------------------------------------------
----------------------------------------------------------------------------
---
---
---                             火法界面设置
--- 
--- 
----------------------------------------------------------------------------
----------------------------------------------------------------------------