--------------------------------------------
---minimapbutton
--------------------------------------------

Contra.MiniMapButtonFrame = CreateFrame("Frame", "ContraMiniMapButtonFrame", Minimap)
Contra.MiniMapButtonFrame:SetWidth(32)
Contra.MiniMapButtonFrame:SetHeight(32)
Contra.MiniMapButtonFrame:SetPoint("TOPLEFT", Minimap, "LEFT", 2, 0)
Contra.MiniMapButtonFrame:SetFrameStrata("LOW")

-- 创建按钮并正确设置父框架
Contra.MiniMapButtonFrame.Button = CreateFrame("Button", "ContraMiniMapButton", Contra.MiniMapButtonFrame)
Contra.MiniMapButtonFrame.Button:SetWidth(32)
Contra.MiniMapButtonFrame.Button:SetHeight(32)
Contra.MiniMapButtonFrame.Button:SetPoint("TOPLEFT", Contra.MiniMapButtonFrame)

-- 普通状态纹理
Contra.MiniMapButtonFrame.Button.normalTexture = Contra.MiniMapButtonFrame.Button:CreateTexture(nil, "ARTWORK")
Contra.MiniMapButtonFrame.Button.normalTexture:SetTexture("Interface\\AddOns\\Contra\\Contra")
Contra.MiniMapButtonFrame.Button.normalTexture:SetAllPoints(Contra.MiniMapButtonFrame.Button) -- 修正锚点
Contra.MiniMapButtonFrame.Button:SetNormalTexture(Contra.MiniMapButtonFrame.Button.normalTexture)

-- 按下状态纹理
Contra.MiniMapButtonFrame.Button.pushedTexture = Contra.MiniMapButtonFrame.Button:CreateTexture(nil, "ARTWORK")
Contra.MiniMapButtonFrame.Button.pushedTexture:SetTexture("Interface\\AddOns\\Contra\\Contra")
Contra.MiniMapButtonFrame.Button.pushedTexture:SetAllPoints(Contra.MiniMapButtonFrame.Button) -- 修正锚点
Contra.MiniMapButtonFrame.Button:SetPushedTexture(Contra.MiniMapButtonFrame.Button.pushedTexture)

-- 高亮状态纹理
Contra.MiniMapButtonFrame.Button.highlightTexture = Contra.MiniMapButtonFrame.Button:CreateTexture(nil, "HIGHLIGHT")
Contra.MiniMapButtonFrame.Button.highlightTexture:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
Contra.MiniMapButtonFrame.Button.highlightTexture:SetBlendMode("ADD")
Contra.MiniMapButtonFrame.Button.highlightTexture:SetAllPoints(Contra.MiniMapButtonFrame.Button) -- 修正锚点
Contra.MiniMapButtonFrame.Button:SetHighlightTexture(Contra.MiniMapButtonFrame.Button.highlightTexture)

-- 确保按钮可见
Contra.MiniMapButtonFrame.Button:Show()

function Contra.MiniMapButtonFrame.ShowFrame()
    if Contra.MyClass == "法师" then
        if Contra.MyTalent == "Arcane" then
            Contra.MageUI.Frame:Show()
        elseif Contra.MyTalent == "Frost" then
            Contra.MageUI_Frost.Frame:Show()
        end
    end
    if Contra.MyClass == "盗贼" then
        Contra.RogueUI.Frame:Show()
    end
end

-- 点击事件处理
Contra.MiniMapButtonFrame.Button:SetScript("OnClick", Contra.MiniMapButtonFrame.ShowFrame)

-- OnEnter 事件
Contra.MiniMapButtonFrame.Button:SetScript("OnEnter", function(button)
    if not button or not GameTooltip then return end
    
    -- 设置工具提示位置
    GameTooltip:SetOwner(button, "ANCHOR_LEFT")
    GameTooltip:SetText("团队BUFF助手")
    GameTooltip:Show()
    
    -- 阻止其他插件覆盖工具提示（如 MinimapButtonBag）
    if button.IsMouseOver then
        button.IsMouseOver = function() return true end
    end
end)

Contra.MiniMapButtonFrame.Button:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)