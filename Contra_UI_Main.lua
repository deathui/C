-- Contra主界面通用函数库
-- 提供复用性强的UI组件创建函数

ContraUI = ContraUI or {}

-- 界面设置 - 通用风格
local ContraUI_Settings = {
    CheckBoxWidth = 20,
    CheckBoxHeight = 20,
    SliderWidth = 160,
    SliderHeight = 15,
    FontSize = 12,
    TitleFontSize = 13,
    Spacing = 5,
    ButtonWidth = 150,
    ButtonHeight = 30,
    IconButtonSize = 36,

}

-- 颜色定义 - 通用主题
-- 职业颜色配置表
local ContraUI_Colors = {
    -- 通用颜色
    Common = {
        Background = { 0.05, 0.05, 0.05, 0.9 },
        Border = { 0.3, 0.3, 0.3, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.5, 0.5, 0.5, 1 },
        Highlight = { 0.8, 0.8, 0.8, 1 }
    },
 
    -- 法师颜色 (蓝色主题)
    MAGE = {
        Background = { 0.05, 0.05, 0.1, 0.9 },
        Border = { 0.41, 0.8, 0.94, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.5, 0.5, 0.6, 1 },
        Highlight = { 0.8, 0.9, 1, 1 },
        Accent = { 0.4, 0.6, 0.9, 1 }
    },
 
    -- 战士颜色 (棕色主题)
    WARRIOR = {
        Background = { 0.1, 0.05, 0.05, 0.9 },
        Border = { 0.5, 0.3, 0.2, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.6, 0.5, 0.5, 1 },
        Highlight = { 1, 0.9, 0.8, 1 },
        Accent = { 0.8, 0.6, 0.4, 1 }
    },
 
    -- 盗贼颜色 (黄色主题)
    ROGUE = {
        Background = { 0.1, 0.1, 0.05, 0.9 },
        Border = { 1, 0.84, 0, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.6, 0.5, 0.4, 1 },
        Highlight = { 1, 1, 0.8, 1 },
        Accent = { 1, 0.9, 0.3, 1 }
    },
 
    -- 牧师颜色 (白色主题)
    PRIEST = {
        Background = { 0.1, 0.1, 0.1, 0.9 },
        Border = { 0.4, 0.4, 0.4, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.5, 0.5, 0.5, 1 },
        Highlight = { 0.9, 0.9, 0.9, 1 },
        Accent = { 1, 1, 1, 1 }
    },
 
    -- 死亡骑士颜色 (红色主题)
    DEATHKNIGHT = {
        Background = { 0.1, 0.05, 0.05, 0.9 },
        Border = { 0.5, 0.2, 0.2, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.6, 0.4, 0.4, 1 },
        Highlight = { 1, 0.8, 0.8, 1 },
        Accent = { 0.9, 0.3, 0.3, 1 }
    },
 
    -- 萨满颜色 (蓝色主题)
    SHAMAN = {
        Background = { 0.05, 0.05, 0.1, 0.9 },
        Border = { 0.2, 0.3, 0.5, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.4, 0.5, 0.6, 1 },
        Highlight = { 0.8, 0.9, 1, 1 },
        Accent = { 0.2, 0.5, 0.9, 1 }
    },
 
    -- 猎人颜色 (绿色主题)
    HUNTER = {
        Background = { 0.05, 0.1, 0.05, 0.9 },
        Border = { 0.2, 0.5, 0.2, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.4, 0.6, 0.4, 1 },
        Highlight = { 0.8, 1, 0.8, 1 },
        Accent = { 0.3, 0.9, 0.3, 1 }
    },
 
    -- 德鲁伊颜色 (橙色主题)
    DRUID = {
        Background = { 0.1, 0.08, 0.05, 0.9 },
        Border = { 0.5, 0.3, 0.2, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.6, 0.5, 0.4, 1 },
        Highlight = { 1, 0.9, 0.8, 1 },
        Accent = { 1, 0.5, 0.2, 1 }
    },
 
    -- 术士颜色 (紫色主题)
    WARLOCK = {
        Background = { 0.08, 0.05, 0.1, 0.9 },
        Border = { 0.4, 0.2, 0.5, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.5, 0.4, 0.6, 1 },
        Highlight = { 0.9, 0.8, 1, 1 },
        Accent = { 0.6, 0.3, 0.9, 1 }
    },
 
    -- 圣骑士颜色 (粉色主题)
    PALADIN = {
        Background = { 0.1, 0.05, 0.08, 0.9 },
        Border = { 0.5, 0.3, 0.4, 1 },
        Text = { 1, 1, 1, 1 },
        Disabled = { 0.6, 0.5, 0.5, 1 },
        Highlight = { 1, 0.9, 0.9, 1 },
        Accent = { 0.9, 0.4, 0.7, 1 }
    }
}

-- 获取当前玩家职业
function ContraUI.GetPlayerClass()
    local _, class = UnitClass("player")
    return class or "MAGE" -- 默认为法师
end

-- 获取当前职业的颜色配置
function ContraUI.GetClassColors()
    local playerClass = ContraUI.GetPlayerClass()
    return ContraUI_Colors[playerClass] or ContraUI_Colors.Common
end

-- 初始化当前职业颜色
local CurrentColors = ContraUI.GetClassColors()

-- 1. 创建复选框函数
-- parent: 父框架
-- name: 复选框名称
-- text: 显示文本
-- tooltip: 鼠标提示内容
-- x, y: 相对位置
-- variableTable: 变量表
-- variableKey: 变量键名
function ContraUI.CreateCheckBox(parent, name, text, tooltip, x, y, variableTable, variableKey)
    local checkbox = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    checkbox:SetWidth(ContraUI_Settings.CheckBoxWidth)
    checkbox:SetHeight(ContraUI_Settings.CheckBoxHeight)
 
    -- 显示文本
    checkbox.Label = checkbox:CreateFontString(nil, "OVERLAY")
    checkbox.Label:SetFont(GameFontNormal:GetFont(), ContraUI_Settings.FontSize)
    checkbox.Label:SetPoint("LEFT", checkbox, "RIGHT", ContraUI_Settings.Spacing, 0)
    checkbox.Label:SetText(text)
    checkbox.Label:SetTextColor(unpack(CurrentColors.Text))
 
    -- 设置初始值
    if variableTable and variableKey then
        checkbox:SetChecked(variableTable[variableKey] or false)
    end
 
    -- 点击事件处理
    checkbox:SetScript("OnClick", function()
        local checked = this:GetChecked()
        if variableTable and variableKey then
            variableTable[variableKey] = checked
        end
        
        -- 触发自定义事件
        if checkbox.OnValueChanged then
            checkbox.OnValueChanged(checked)
        end
    end)

    -- 鼠标提示
    if tooltip and tooltip ~= "" then
        checkbox:SetScript("OnEnter", function()
            GameTooltip:SetOwner(this, "ANCHOR_NONE")
            GameTooltip:SetPoint("BOTTOMRIGHT", this, "TOPLEFT")
            GameTooltip:AddLine(tooltip, 0.8, 0.8, 0.8, 1)
            GameTooltip:Show()
        end)
        checkbox:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end
 
    return checkbox
end

-- 2. 创建标题函数
-- parent: 父框架
-- text: 标题文本
-- color: 字体颜色 {r, g, b, a}
-- x, y: 相对位置
-- fontSize: 字体大小(可选)
function ContraUI.CreateTitle(parent, text, color, x, y, fontSize)
    local title = parent:CreateFontString(nil, "OVERLAY")
    title:SetFont(GameFontNormal:GetFont(), fontSize or ContraUI_Settings.TitleFontSize, "OUTLINE")
    title:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    title:SetText(text)
 
    if color then
        title:SetTextColor(unpack(CurrentColors.Border))
    else
        title:SetTextColor(unpack(CurrentColors.Accent))
    end
 
    return title
end

-- 3. 创建拖动条函数
-- parent: 父框架
-- name: 拖动条名称
-- text: 显示文本
-- minVal: 最小值
-- maxVal: 最大值
-- step: 步长
-- x, y: 相对位置
-- variableTable: 变量表
-- variableKey: 变量键名
function ContraUI.CreateSlider(parent, name, text, minVal, maxVal, step, x, y, variableTable, variableKey)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    slider:SetWidth(ContraUI_Settings.SliderWidth)
    slider:SetHeight(ContraUI_Settings.SliderHeight)
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(step)
    slider:SetOrientation("HORIZONTAL")
 
    -- 设置初始值
    local initialValue = variableTable and variableKey and variableTable[variableKey] or minVal
    slider:SetValue(initialValue)
 
    -- 标签文本
    slider.Text = _G[name .. "Text"]
    if slider.Text then
        slider.Text:SetText(text .. " " .. initialValue)
        slider.Text:SetTextColor(unpack(CurrentColors.Border))
        slider.Text:SetFont(GameFontNormal:GetFont(), ContraUI_Settings.FontSize - 2)
    end
 
    -- 值变化事件
    slider:SetScript("OnValueChanged", function()
        --value的值取小数点后1位
        local value = math.floor(this:GetValue() * 10 + 0.5) / 10
        
        if variableTable and variableKey then
            variableTable[variableKey] = value
        end
        
        -- 更新显示文本
        if slider.Text then
            slider.Text:SetText(text .. " " .. value)
        end
        
        -- 触发自定义事件
        if slider.OnValueChanged then
            slider.OnValueChanged(value)
        end
    end)
 
    -- 最小值和最大值标签
    slider.Low = _G[name .. "Low"]
    slider.High = _G[name .. "High"]
    if slider.Low and slider.High then
        slider.Low:SetText("")
        slider.High:SetText("")
        slider.Low:SetTextColor(unpack(CurrentColors.Text))
        slider.High:SetTextColor(unpack(CurrentColors.Text))
    end
 
    return slider
end

-- 使用示例和测试函数
-- 5. 示例函数：显示示例界面
-- 使用 /run ContraUI.ShowExample() 来测试
function ContraUI.ShowExample()
    -- 获取当前职业
    local className = ContraUI.GetPlayerClass()
    local classColors = ContraUI.GetClassColors()
    
    -- 创建示例框架
    local exampleFrame = CreateFrame("Frame", "ContraUIExample", UIParent)
    exampleFrame:SetWidth(320)
    exampleFrame:SetHeight(320)
    exampleFrame:SetPoint("CENTER", 0, 0)
    exampleFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    exampleFrame:SetBackdropColor(CurrentColors.Background[1], CurrentColors.Background[2], CurrentColors.Background[3], CurrentColors.Background[4])
    exampleFrame:EnableMouse(true)
    exampleFrame:SetMovable(true)
    exampleFrame:RegisterForDrag("LeftButton")
    exampleFrame:SetScript("OnDragStart", function() this:StartMoving() end)
    exampleFrame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)

    -- 示例变量表
    local exampleVars = {
        enableFeature = false,
        sliderValue = 50,
        qualityLevel = 75
    }

    -- 创建标题
    ContraUI.CreateTitle(exampleFrame, "ContraUI 交互效果演示", CurrentColors.Accent, 20, -20, 1)
    ContraUI.CreateTitle(exampleFrame, "当前职业: " .. (className or "未知"), CurrentColors.Text, 20, -40, 2)
    
    -- 创建分隔线
    local divider = exampleFrame:CreateTexture(nil, "ARTWORK")
    divider:SetTexture("Interface\\AddOns\\Contra\\divider")
    divider:SetHeight(1)
    divider:SetWidth(280)
    divider:SetPoint("TOPLEFT", exampleFrame, "TOPLEFT", 20, -55)
    divider:SetVertexColor(CurrentColors.Border[1], CurrentColors.Border[2], CurrentColors.Border[3], 0.5)

    -- 创建标准按钮
    ContraUI.CreateTitle(exampleFrame, "标准按钮", CurrentColors.Text, 20, -75, 3)
    
    local testButton1 = ContraUI.CreateButton(exampleFrame, "TestButton1", "点击测试", 100, 25, 20, -95, function()
        DEFAULT_CHAT_FRAME:AddMessage("标准按钮被点击了！", 1, 1, 0)
    end)

    local testButton2 = ContraUI.CreateButton(exampleFrame, "TestButton2", "悬停测试", 100, 25, 120, -95, function()
        DEFAULT_CHAT_FRAME:AddMessage("悬停按钮被点击了！", 1, 1, 0)
    end)

    -- 创建图标按钮
    ContraUI.CreateTitle(exampleFrame, "图标按钮", CurrentColors.Text, 20, -130, 3)
    
    local iconButton1 = ContraUI.CreateIconButton(exampleFrame, "IconButton1", "Interface\\Icons\\INV_Misc_QuestionMark", 32, 32, 20, -150, "这是一个图标按钮提示")
    iconButton1:SetScript("OnClick", function()
        DEFAULT_CHAT_FRAME:AddMessage("图标按钮1被点击了！", 1, 1, 0)
    end)

    local iconButton2 = ContraUI.CreateIconButton(exampleFrame, "IconButton2", "Interface\\Icons\\INV_Misc_Gem_01", 32, 32, 70, -150, "这是另一个图标按钮")
    iconButton2:SetScript("OnClick", function()
        DEFAULT_CHAT_FRAME:AddMessage("图标按钮2被点击了！", 1, 1, 0)
    end)

    -- 创建关闭按钮
    local closeButton = ContraUI.CreateButton(exampleFrame, "ExampleClose", "关闭", 60, 25, 240, -280, function()
        exampleFrame:Hide()
    end)

    exampleFrame:Show()
end

-- 注册斜杠命令测试
SLASH_CONTRAUI1 = "/contraui"
SlashCmdList["CONTRAUI"] = function()
    ContraUI.ShowExample()
end



-- 4. 创建按钮模板函数
-- 参照HDLRaidTools的按钮风格，使用当前框架的职业主题颜色
-- parent: 父框架
-- name: 按钮名称
-- text: 按钮文本
-- width, height: 按钮尺寸
-- x, y: 相对位置
-- onClick: 点击回调函数
function ContraUI.CreateButton(parent, name, text, width, height, x, y, onClick)
    local button = CreateFrame("Button", name, parent)
    button:SetWidth(width or ContraUI_Settings.ButtonWidth)
    button:SetHeight(height or ContraUI_Settings.ButtonHeight)
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

    -- 设置按钮样式
    local backdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    }

    button:SetBackdrop(backdrop)
    button:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    button:SetBackdropBorderColor(CurrentColors.Border[1], CurrentColors.Border[2], CurrentColors.Border[3], CurrentColors.Border[4] or 1)

    -- 创建文本
    button.Text = button:CreateFontString(nil, "OVERLAY")
    button.Text:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
    button.Text:SetPoint("CENTER", button, "CENTER", 0, 0)
    button.Text:SetText(text)
    button.Text:SetTextColor(CurrentColors.Text[1], CurrentColors.Text[2], CurrentColors.Text[3], CurrentColors.Text[4] or 1)

    -- 鼠标指向效果
    button:SetScript("OnEnter", function()
        this:SetBackdropBorderColor(CurrentColors.Accent[1], CurrentColors.Accent[2], CurrentColors.Accent[3], 1)
        this.Text:SetTextColor(CurrentColors.Highlight[1], CurrentColors.Highlight[2], CurrentColors.Highlight[3], 1)
    end)

    -- 鼠标离开效果
    button:SetScript("OnLeave", function()
        this:SetBackdropBorderColor(CurrentColors.Border[1], CurrentColors.Border[2], CurrentColors.Border[3], CurrentColors.Border[4] or 1)
        this.Text:SetTextColor(CurrentColors.Text[1], CurrentColors.Text[2], CurrentColors.Text[3], CurrentColors.Text[4] or 1)
    end)

    -- 鼠标按下效果
    button:SetScript("OnMouseDown", function()
        this:SetBackdropColor(0.2, 0.2, 0.2, 0.9)
        this:SetBackdropBorderColor(CurrentColors.Accent[1], CurrentColors.Accent[2], CurrentColors.Accent[3], 0.8)
        this.Text:SetPoint("CENTER", 1, -1) -- 文本轻微下移模拟按下效果
    end)

    -- 鼠标释放效果
    button:SetScript("OnMouseUp", function()
        this:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
        this:SetBackdropBorderColor(CurrentColors.Accent[1], CurrentColors.Accent[2], CurrentColors.Accent[3], 1)
        this.Text:SetPoint("CENTER", 0, 0) -- 文本恢复原位
    end)

    -- 点击事件
    if onClick then
        button:SetScript("OnClick", onClick)
    end

    return button
end

-- 5. 创建图标按钮模板函数
-- 创建带有图标的按钮，适用于技能图标等
-- parent: 父框架
-- name: 按钮名称
-- icon: 图标路径
-- width, height: 按钮尺寸
-- x, y: 相对位置
-- tooltip: 提示文本
-- onClick: 点击回调函数
function ContraUI.CreateIconButton(parent, name, icon, width, height, x, y, tooltip, onClick)
    local button = CreateFrame("Button", name, parent)
    button:SetWidth(width or ContraUI_Settings.IconButtonSize)
    button:SetHeight(height or ContraUI_Settings.IconButtonSize)
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

    -- 创建图标纹理
    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetAllPoints(button)
    button.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")

    -- 设置背景
    local backdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    }

    button:SetBackdrop(backdrop)
    button:SetBackdropColor(0.1, 0.1, 0.1, 0.7)
    button:SetBackdropBorderColor(CurrentColors.Border[1], CurrentColors.Border[2], CurrentColors.Border[3], 0.8)

    -- 高亮效果
    button:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(CurrentColors.Accent[1], CurrentColors.Accent[2], CurrentColors.Accent[3], 1)
        if tooltip then
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetPoint("BOTTOMRIGHT", self, "TOPLEFT")
            GameTooltip:AddLine(tooltip, 0.8, 0.8, 0.8, 1)
            GameTooltip:Show()
        end
    end)

    button:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(CurrentColors.Border[1], CurrentColors.Border[2], CurrentColors.Border[3], 0.8)
        if tooltip then
            GameTooltip:Hide()
        end
    end)

    -- 鼠标按下效果
    button:SetScript("OnMouseDown", function(self)
        self:SetBackdropColor(0.2, 0.2, 0.2, 0.9)
        self:SetBackdropBorderColor(CurrentColors.Accent[1], CurrentColors.Accent[2], CurrentColors.Accent[3], 0.8)
    end)

    -- 鼠标释放效果
    button:SetScript("OnMouseUp", function(self)
        self:SetBackdropColor(0.1, 0.1, 0.1, 0.7)
        self:SetBackdropBorderColor(CurrentColors.Accent[1], CurrentColors.Accent[2], CurrentColors.Accent[3], 1)
    end)

    -- 点击事件
    if onClick then
        button:SetScript("OnClick", onClick)
    end

    return button
end



-- 导出到全局
_G.ContraUI = ContraUI


-- 独立的Contra Tooltip系统
-- 解决与pfUI等插件的tooltip冲突问题
-- ===========================================

ContraTooltipSystem = ContraTooltipSystem or {}

-- 创建独立的tooltip框架
function ContraTooltipSystem:Initialize()
    if self.tooltip then return end -- 已初始化
    
    -- 创建独立的GameTooltip实例
    self.tooltip = CreateFrame("GameTooltip", "ContraTooltipFrame", UIParent, "GameTooltipTemplate")
    self.tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    self.tooltip:SetClampedToScreen(true)
    
    -- 设置默认样式
    self.tooltip:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    
    -- 存储当前的锚点和目标
    self.currentAnchor = nil
    self.currentTarget = nil
end

-- 智能锚点计算（避免屏幕边缘）
function ContraTooltipSystem:CalculateAnchor(frame, preferredAnchor)
    if not frame then return "ANCHOR_CURSOR" end
    
    local x, y = frame:GetCenter()
    if not x or not y then return "ANCHOR_CURSOR" end
    
    local screenWidth, screenHeight = UIParent:GetWidth(), UIParent:GetHeight()
    
    -- 根据屏幕位置选择最佳锚点
    if x < screenWidth / 3 then
        return "ANCHOR_RIGHT" -- 屏幕左侧，锚点在右侧
    elseif x > screenWidth * 2/3 then
        return "ANCHOR_LEFT" -- 屏幕右侧，锚点在左侧
    elseif y < screenHeight / 2 then
        return "ANCHOR_TOP" -- 屏幕下方，锚点在上方
    else
        return "ANCHOR_BOTTOM" -- 屏幕上方，锚点在下方
    end
end

-- 显示tooltip
function ContraTooltipSystem:Show(ownerFrame, text, title, anchor)
    self:Initialize()
    
    if not ownerFrame or not text then return end
    
    -- 清除之前的内容
    self.tooltip:ClearLines()
    
    -- 设置锚点
    local actualAnchor = anchor or self:CalculateAnchor(ownerFrame)
    self.tooltip:SetOwner(ownerFrame, actualAnchor)
    
    -- 设置标题（如果有）
    if title then
        self.tooltip:AddLine(title, 1, 0.82, 0) -- 金色标题
    end
    
    -- 设置内容
    self.tooltip:AddLine(text, 1, 1, 1, 1)
    
    -- 显示tooltip
    self.tooltip:Show()
    
    -- 记录当前状态
    self.currentAnchor = actualAnchor
    self.currentTarget = ownerFrame
end

-- 隐藏tooltip
function ContraTooltipSystem:Hide()
    if self.tooltip then
        self.tooltip:Hide()
        self.currentAnchor = nil
        self.currentTarget = nil
    end
end

-- 更新tooltip内容
function ContraTooltipSystem:Update(ownerFrame, text, title)
    if self.currentTarget == ownerFrame then
        self:Show(ownerFrame, text, title, self.currentAnchor)
    end
end

-- 检查tooltip是否显示
function ContraTooltipSystem:IsShown()
    return self.tooltip and self.tooltip:IsShown()
end

-- ===========================================
-- 向后兼容的API函数
-- 可以直接替换现有的GameTooltip调用
-- ===========================================

-- 兼容函数：显示tooltip
function ContraUI.ShowTooltip(ownerFrame, text, title, anchor)
    ContraTooltipSystem:Show(ownerFrame, text, title, anchor)
end

-- 兼容函数：隐藏tooltip
function ContraUI.HideTooltip()
    ContraTooltipSystem:Hide()
end

-- ===========================================
-- 修改现有的UI组件以使用新的tooltip系统
-- ===========================================

-- 重写CreateCheckBox函数中的tooltip逻辑
local originalCreateCheckBox = ContraUI.CreateCheckBox
function ContraUI.CreateCheckBox(parent, name, text, tooltip, x, y, variableTable, variableKey)
    local checkbox = originalCreateCheckBox(parent, name, text, tooltip, x, y, variableTable, variableKey)
    
    -- 移除原有的tooltip脚本
    checkbox:SetScript("OnEnter", nil)
    checkbox:SetScript("OnLeave", nil)
    
    -- 添加新的tooltip脚本
    if tooltip and tooltip ~= "" then
        checkbox:SetScript("OnEnter", function()
            ContraUI.ShowTooltip(this, tooltip, text)
        end)
        checkbox:SetScript("OnLeave", function()
            ContraUI.HideTooltip()
        end)
    end
    
    return checkbox
end

-- 重写CreateIconButton函数中的tooltip逻辑
local originalCreateIconButton = ContraUI.CreateIconButton
function ContraUI.CreateIconButton(parent, name, icon, width, height, x, y, tooltip, onClick)
    local button = originalCreateIconButton(parent, name, icon, width, height, x, y, tooltip, onClick)
    
    -- 修改OnEnter脚本
    button:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(CurrentColors.Accent[1], CurrentColors.Accent[2], CurrentColors.Accent[3], 1)
        if tooltip then
            ContraUI.ShowTooltip(self, tooltip)
        end
    end)
    
    -- 修改OnLeave脚本
    button:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(CurrentColors.Border[1], CurrentColors.Border[2], CurrentColors.Border[3], 0.8)
        ContraUI.HideTooltip()
    end)
    
    return button
end

-- ===========================================
-- 为Minimap按钮添加独立tooltip支持
-- ===========================================

-- 修改Minimap按钮的tooltip（如果存在）
if Contra and Contra.MiniMapButtonFrame and Contra.MiniMapButtonFrame.Button then
    local minimapButton = Contra.MiniMapButtonFrame.Button
    
    -- 移除原有的tooltip脚本
    minimapButton:SetScript("OnEnter", nil)
    minimapButton:SetScript("OnLeave", nil)
    
    -- 添加新的tooltip脚本
    minimapButton:SetScript("OnEnter", function(button)
        ContraUI.ShowTooltip(button, "团队BUFF助手", "Contra")
    end)
    minimapButton:SetScript("OnLeave", function()
        ContraUI.HideTooltip()
    end)
end

-- ===========================================
-- 初始化新的tooltip系统
-- ===========================================

-- 在插件加载时初始化
local contraTooltipInit = CreateFrame("Frame")
contraTooltipInit:RegisterEvent("ADDON_LOADED")
contraTooltipInit:SetScript("OnEvent", function()
    if arg1 == "Contra" then
        ContraTooltipSystem:Initialize()
    end
end)

-- 更新复选框状态的辅助函数
function ContraUI.UpdateCheckBox(name, value)
    local checkbox = _G[name]
    if checkbox and checkbox.SetChecked then
        checkbox:SetChecked(value)
    end
end

-- 更新滑块状态的辅助函数
function ContraUI.UpdateSlider(name, value, textPrefix)
    local slider = _G[name]
    if slider and slider.SetValue then
        slider:SetValue(value)
        
        -- 更新滑块文本
        local sliderText = _G[name.."Text"]
        if sliderText and sliderText.SetText then
            sliderText:SetText(textPrefix..value)
        end
    end
end

-- 导出到全局命名空间
_G.ContraTooltipSystem = ContraTooltipSystem
_G.ContraUI.ShowTooltip = ContraUI.ShowTooltip
_G.ContraUI.HideTooltip = ContraUI.HideTooltip