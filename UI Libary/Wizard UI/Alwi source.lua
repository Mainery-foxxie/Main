-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local hue = 0
local colorPickerZIndex = 1
local windowOffset = 0

if game:GetService("CoreGui"):FindFirstChild("WizardLibrary") then
    game:GetService("CoreGui"):FindFirstChild("WizardLibrary"):Destroy()
end

-- Theme
local T = {
    BG         = Color3.fromRGB(13,  15,  20),
    SURFACE    = Color3.fromRGB(20,  23,  32),
    SECTION    = Color3.fromRGB(26,  30,  44),
    ELEMENT    = Color3.fromRGB(35,  40,  58),
    ELEMENT2   = Color3.fromRGB(44,  50,  70),
    ACCENT     = Color3.fromRGB(58, 123, 255),
    ACCENT_DIM = Color3.fromRGB(30,  60, 140),
    TEXT       = Color3.fromRGB(230, 235, 255),
    SUBTEXT    = Color3.fromRGB(130, 145, 180),
    TOGGLE_OFF = Color3.fromRGB(55,  60,  80),
    WHITE      = Color3.fromRGB(255, 255, 255),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WizardLibrary"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = ScreenGui
Container.BackgroundTransparency = 1
Container.Size = UDim2.new(1, 0, 1, 0)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or T.ELEMENT2
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function stripSpaces(str)
    return str:gsub(" ", "")
end

local function tween(instance, info, goal)
    TweenService:Create(instance, info, goal):Play()
end

local TI_FAST   = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TI_MED    = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TI_SLOW   = TweenInfo.new(0.40, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TI_SPRING = TweenInfo.new(0.35, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)

coroutine.wrap(function()
    while task.wait() do
        hue = (hue + 0.004) % 1
    end
end)()

local function Dragging(frame)
    local dragStart, startPos, dragging, lastInput
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        then
            lastInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == lastInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

return {
    NewWindow = function(_, windowTitle)
        local WIN_W = 240
        local TOPBAR_H = 36
        local windowId = stripSpaces(windowTitle)
        local bodyHeight = 0
        local windowOpen = true

        -- stagger multiple windows
        windowOffset = windowOffset + 260

        local WindowRoot = Instance.new("Frame")
        local Topbar     = Instance.new("Frame")
        local TitleLabel = Instance.new("TextLabel")
        local MinBtn     = Instance.new("TextButton")
        local Body       = Instance.new("Frame")
        local BodyLayout = Instance.new("UIListLayout")

        WindowRoot.Name = windowId .. "Window"
        WindowRoot.Parent = Container
        WindowRoot.BackgroundColor3 = T.BG
        WindowRoot.BorderSizePixel = 0
        WindowRoot.Position = UDim2.new(0, 20 + (windowOffset - 260), 0, 20)
        WindowRoot.Size = UDim2.new(0, WIN_W, 0, TOPBAR_H)
        WindowRoot.ZIndex = 2
        WindowRoot.ClipsDescendants = false
        corner(WindowRoot, 10)
        stroke(WindowRoot, T.ELEMENT2, 1, 0.5)

        Topbar.Name = "Topbar"
        Topbar.Parent = WindowRoot
        Topbar.BackgroundColor3 = T.SURFACE
        Topbar.BorderSizePixel = 0
        Topbar.Size = UDim2.new(1, 0, 0, TOPBAR_H)
        Topbar.ZIndex = 3
        corner(Topbar, 10)

        -- Accent line
        local AccentLine = Instance.new("Frame")
        AccentLine.Parent = Topbar
        AccentLine.BackgroundColor3 = T.ACCENT
        AccentLine.BorderSizePixel = 0
        AccentLine.Size = UDim2.new(1, 0, 0, 2)
        AccentLine.ZIndex = 4
        local acCorner = Instance.new("UICorner")
        acCorner.CornerRadius = UDim.new(0, 10)
        acCorner.Parent = AccentLine

        -- Traffic dots
        local dotColors = {
            Color3.fromRGB(255, 95, 87),
            Color3.fromRGB(255, 189, 46),
            Color3.fromRGB(40, 201, 64),
        }
        for i, col in ipairs(dotColors) do
            local d = Instance.new("Frame")
            d.Parent = Topbar
            d.BackgroundColor3 = col
            d.BorderSizePixel = 0
            d.Size = UDim2.new(0, 8, 0, 8)
            d.Position = UDim2.new(0, 6 + (i - 1) * 14, 0.5, -4)
            d.ZIndex = 4
            corner(d, 4)
        end

        TitleLabel.Name = "WindowTitle"
        TitleLabel.Parent = Topbar
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 54, 0, 0)
        TitleLabel.Size = UDim2.new(1, -80, 1, 0)
        TitleLabel.ZIndex = 4
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = windowTitle
        TitleLabel.TextColor3 = T.TEXT
        TitleLabel.TextSize = 12
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

        MinBtn.Name = "MinBtn"
        MinBtn.Parent = Topbar
        MinBtn.BackgroundColor3 = T.ELEMENT
        MinBtn.BorderSizePixel = 0
        MinBtn.AnchorPoint = Vector2.new(1, 0.5)
        MinBtn.Position = UDim2.new(1, -8, 0.5, 0)
        MinBtn.Size = UDim2.new(0, 22, 0, 16)
        MinBtn.ZIndex = 4
        MinBtn.AutoButtonColor = false
        MinBtn.Font = Enum.Font.GothamBold
        MinBtn.Text = "—"
        MinBtn.TextColor3 = T.SUBTEXT
        MinBtn.TextSize = 9
        corner(MinBtn, 4)

        MinBtn.MouseEnter:Connect(function()
            tween(MinBtn, TI_FAST, { TextColor3 = T.TEXT })
        end)
        MinBtn.MouseLeave:Connect(function()
            tween(MinBtn, TI_FAST, { TextColor3 = T.SUBTEXT })
        end)

        Body.Name = "Body"
        Body.Parent = WindowRoot
        Body.BackgroundColor3 = T.BG
        Body.BorderSizePixel = 0
        Body.ClipsDescendants = true
        Body.Position = UDim2.new(0, 0, 0, TOPBAR_H)
        Body.Size = UDim2.new(1, 0, 0, 0)
        Body.ZIndex = 2

        local BodyPad = Instance.new("UIPadding")
        BodyPad.Parent = Body
        BodyPad.PaddingTop    = UDim.new(0, 6)
        BodyPad.PaddingBottom = UDim.new(0, 6)
        BodyPad.PaddingLeft   = UDim.new(0, 8)
        BodyPad.PaddingRight  = UDim.new(0, 8)

        BodyLayout.Parent = Body
        BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
        BodyLayout.Padding = UDim.new(0, 4)

        local function setBodyHeight(h)
            bodyHeight = h
            tween(Body, TI_MED, { Size = UDim2.new(1, 0, 0, bodyHeight) })
            tween(WindowRoot, TI_MED, { Size = UDim2.new(0, WIN_W, 0, TOPBAR_H + bodyHeight) })
        end

        local function growBody(amount)
            setBodyHeight(bodyHeight + amount)
        end
        local function shrinkBody(amount)
            setBodyHeight(math.max(0, bodyHeight - amount))
        end

        MinBtn.MouseButton1Click:Connect(function()
            if windowOpen then
                windowOpen = false
                MinBtn.Text = "+"
                tween(Body, TI_MED, { Size = UDim2.new(1, 0, 0, 0) })
                tween(WindowRoot, TI_MED, { Size = UDim2.new(0, WIN_W, 0, TOPBAR_H) })
            else
                windowOpen = true
                MinBtn.Text = "—"
                tween(Body, TI_MED, { Size = UDim2.new(1, 0, 0, bodyHeight) })
                tween(WindowRoot, TI_MED, { Size = UDim2.new(0, WIN_W, 0, TOPBAR_H + bodyHeight) })
            end
        end)

        Dragging(Topbar)

        return {
            NewSection = function(_, sectionTitle)
                local sectionId = stripSpaces(sectionTitle)
                local sectionOpen = false
                local HEADER_H = 34
                local ITEM_H   = 32
                local PAD_V    = 8
                local sectionContentHeight = 0

                local SectionFrame  = Instance.new("Frame")
                local SectionHeader = Instance.new("Frame")
                local AccentBar     = Instance.new("Frame")
                local SecTitle      = Instance.new("TextLabel")
                local ChevronLbl    = Instance.new("TextLabel")
                local ClickRgn      = Instance.new("TextButton")
                local ItemContainer = Instance.new("Frame")
                local ItemLayout    = Instance.new("UIListLayout")

                SectionFrame.Name = sectionId .. "Section"
                SectionFrame.Parent = Body
                SectionFrame.BackgroundColor3 = T.SURFACE
                SectionFrame.BorderSizePixel = 0
                SectionFrame.ClipsDescendants = true
                SectionFrame.Size = UDim2.new(1, 0, 0, HEADER_H)
                SectionFrame.ZIndex = 3
                corner(SectionFrame, 8)
                stroke(SectionFrame, T.ELEMENT, 1, 0.5)

                -- header
                SectionHeader.Name = "Header"
                SectionHeader.Parent = SectionFrame
                SectionHeader.BackgroundTransparency = 1
                SectionHeader.Size = UDim2.new(1, 0, 0, HEADER_H)
                SectionHeader.ZIndex = 4

                AccentBar.Name = "AccentBar"
                AccentBar.Parent = SectionHeader
                AccentBar.BackgroundColor3 = T.ACCENT
                AccentBar.BorderSizePixel = 0
                AccentBar.Size = UDim2.new(0, 3, 0, 16)
                AccentBar.Position = UDim2.new(0, 10, 0.5, -8)
                AccentBar.ZIndex = 5
                corner(AccentBar, 2)

                SecTitle.Name = "Title"
                SecTitle.Parent = SectionHeader
                SecTitle.BackgroundTransparency = 1
                SecTitle.Position = UDim2.new(0, 22, 0, 0)
                SecTitle.Size = UDim2.new(1, -44, 1, 0)
                SecTitle.ZIndex = 5
                SecTitle.Font = Enum.Font.GothamBold
                SecTitle.Text = sectionTitle
                SecTitle.TextColor3 = T.TEXT
                SecTitle.TextSize = 11
                SecTitle.TextXAlignment = Enum.TextXAlignment.Left

                ChevronLbl.Name = "Chevron"
                ChevronLbl.Parent = SectionHeader
                ChevronLbl.BackgroundTransparency = 1
                ChevronLbl.AnchorPoint = Vector2.new(1, 0.5)
                ChevronLbl.Position = UDim2.new(1, -10, 0.5, 0)
                ChevronLbl.Size = UDim2.new(0, 16, 0, 16)
                ChevronLbl.ZIndex = 5
                ChevronLbl.Font = Enum.Font.GothamBold
                ChevronLbl.Text = "›"
                ChevronLbl.TextColor3 = T.SUBTEXT
                ChevronLbl.TextSize = 18
                ChevronLbl.Rotation = 90

                ClickRgn.Name = "ClickRegion"
                ClickRgn.Parent = SectionHeader
                ClickRgn.BackgroundTransparency = 1
                ClickRgn.Size = UDim2.new(1, 0, 1, 0)
                ClickRgn.ZIndex = 6
                ClickRgn.Text = ""
                ClickRgn.AutoButtonColor = false

                -- item container
                ItemContainer.Name = "Items"
                ItemContainer.Parent = SectionFrame
                ItemContainer.BackgroundTransparency = 1
                ItemContainer.Position = UDim2.new(0, 0, 0, HEADER_H)
                ItemContainer.Size = UDim2.new(1, 0, 1, -HEADER_H)
                ItemContainer.ClipsDescendants = false
                ItemContainer.ZIndex = 4

                local ItemPad = Instance.new("UIPadding")
                ItemPad.Parent = ItemContainer
                ItemPad.PaddingLeft   = UDim.new(0, 8)
                ItemPad.PaddingRight  = UDim.new(0, 8)
                ItemPad.PaddingTop    = UDim.new(0, 4)
                ItemPad.PaddingBottom = UDim.new(0, 4)

                ItemLayout.Parent = ItemContainer
                ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ItemLayout.Padding = UDim.new(0, 3)

                -- section grows body by HEADER_H + 10 (section frame + gap)
                local SECTION_OVERHEAD = HEADER_H + 4
                growBody(SECTION_OVERHEAD)

                local itemCount = 0

                local function addItem(extraH)
                    local h = extraH or ITEM_H
                    itemCount = itemCount + 1
                    sectionContentHeight = sectionContentHeight + h + 3
                end

                local function openSection()
                    sectionOpen = true
                    local totalH = HEADER_H + PAD_V + sectionContentHeight
                    tween(SectionFrame, TI_MED, { Size = UDim2.new(1, 0, 0, totalH) })
                    tween(ChevronLbl, TI_MED, { Rotation = 270, TextColor3 = T.ACCENT })
                    growBody(sectionContentHeight + PAD_V)
                end

                local function closeSection()
                    sectionOpen = false
                    tween(SectionFrame, TI_MED, { Size = UDim2.new(1, 0, 0, HEADER_H) })
                    tween(ChevronLbl, TI_MED, { Rotation = 90, TextColor3 = T.SUBTEXT })
                    shrinkBody(sectionContentHeight + PAD_V)
                end

                ClickRgn.MouseButton1Click:Connect(function()
                    if sectionOpen then
                        closeSection()
                    else
                        openSection()
                    end
                end)

                ClickRgn.MouseEnter:Connect(function()
                    tween(SectionFrame, TI_FAST, { BackgroundColor3 = T.SECTION })
                end)
                ClickRgn.MouseLeave:Connect(function()
                    tween(SectionFrame, TI_FAST, { BackgroundColor3 = T.SURFACE })
                end)

                return {
                    CreateToggle = function(_, label, callback)
                        addItem()
                        local state = false

                        local Row     = Instance.new("Frame")
                        local Lbl     = Instance.new("TextLabel")
                        local Track   = Instance.new("Frame")
                        local Knob    = Instance.new("Frame")
                        local HitArea = Instance.new("TextButton")

                        Row.Name = stripSpaces(label) .. "Row"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)
                        Row.ZIndex = 5

                        Lbl.Parent = Row
                        Lbl.BackgroundTransparency = 1
                        Lbl.Size = UDim2.new(1, -52, 1, 0)
                        Lbl.Font = Enum.Font.Gotham
                        Lbl.Text = label
                        Lbl.TextColor3 = T.TEXT
                        Lbl.TextSize = 11
                        Lbl.TextXAlignment = Enum.TextXAlignment.Left
                        Lbl.ZIndex = 5

                        Track.Parent = Row
                        Track.BackgroundColor3 = T.TOGGLE_OFF
                        Track.BorderSizePixel = 0
                        Track.AnchorPoint = Vector2.new(1, 0.5)
                        Track.Position = UDim2.new(1, 0, 0.5, 0)
                        Track.Size = UDim2.new(0, 40, 0, 20)
                        Track.ZIndex = 5
                        corner(Track, 10)

                        Knob.Parent = Track
                        Knob.BackgroundColor3 = T.WHITE
                        Knob.BorderSizePixel = 0
                        Knob.AnchorPoint = Vector2.new(0, 0.5)
                        Knob.Position = UDim2.new(0, 2, 0.5, 0)
                        Knob.Size = UDim2.new(0, 16, 0, 16)
                        Knob.ZIndex = 6
                        corner(Knob, 8)

                        HitArea.Parent = Row
                        HitArea.BackgroundTransparency = 1
                        HitArea.Size = UDim2.new(1, 0, 1, 0)
                        HitArea.Text = ""
                        HitArea.AutoButtonColor = false
                        HitArea.ZIndex = 7

                        HitArea.MouseButton1Click:Connect(function()
                            state = not state
                            if state then
                                tween(Track, TI_MED, { BackgroundColor3 = T.ACCENT })
                                tween(Knob, TI_SPRING, { Position = UDim2.new(0, 22, 0.5, 0) })
                            else
                                tween(Track, TI_MED, { BackgroundColor3 = T.TOGGLE_OFF })
                                tween(Knob, TI_SPRING, { Position = UDim2.new(0, 2, 0.5, 0) })
                            end
                            callback(state)
                        end)
                    end,

                    CreateSlider = function(_, label, min, max, default, isFloat, callback)
                        local SLIDER_H = ITEM_H + 14
                        addItem(SLIDER_H)

                        local dragging = false
                        local cur = default or min

                        local Row    = Instance.new("Frame")
                        local Lbl    = Instance.new("TextLabel")
                        local ValBg  = Instance.new("Frame")
                        local ValLbl = Instance.new("TextLabel")
                        local Track  = Instance.new("Frame")
                        local Fill   = Instance.new("Frame")
                        local Thumb  = Instance.new("Frame")
                        local HitArea = Instance.new("TextButton")

                        Row.Name = stripSpaces(label) .. "SliderRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, SLIDER_H)
                        Row.ZIndex = 5

                        Lbl.Parent = Row
                        Lbl.BackgroundTransparency = 1
                        Lbl.Position = UDim2.new(0, 0, 0, 0)
                        Lbl.Size = UDim2.new(0.6, 0, 0, 18)
                        Lbl.Font = Enum.Font.Gotham
                        Lbl.Text = label
                        Lbl.TextColor3 = T.TEXT
                        Lbl.TextSize = 11
                        Lbl.TextXAlignment = Enum.TextXAlignment.Left
                        Lbl.ZIndex = 5

                        ValBg.Parent = Row
                        ValBg.BackgroundColor3 = T.ELEMENT
                        ValBg.BorderSizePixel = 0
                        ValBg.AnchorPoint = Vector2.new(1, 0)
                        ValBg.Position = UDim2.new(1, 0, 0, 0)
                        ValBg.Size = UDim2.new(0, 44, 0, 18)
                        ValBg.ZIndex = 5
                        corner(ValBg, 5)

                        ValLbl.Parent = ValBg
                        ValLbl.BackgroundTransparency = 1
                        ValLbl.Size = UDim2.new(1, 0, 1, 0)
                        ValLbl.Font = Enum.Font.GothamBold
                        ValLbl.TextColor3 = T.ACCENT
                        ValLbl.TextSize = 10
                        ValLbl.Text = tostring(isFloat and tonumber(string.format("%.2f", cur)) or math.floor(cur))
                        ValLbl.ZIndex = 6

                        Track.Parent = Row
                        Track.BackgroundColor3 = T.ELEMENT
                        Track.BorderSizePixel = 0
                        Track.Position = UDim2.new(0, 0, 0, 26)
                        Track.Size = UDim2.new(1, 0, 0, 4)
                        Track.ZIndex = 5
                        corner(Track, 2)

                        local initScale = (cur - min) / math.max(max - min, 0.0001)

                        Fill.Parent = Track
                        Fill.BackgroundColor3 = T.ACCENT
                        Fill.BorderSizePixel = 0
                        Fill.Size = UDim2.new(initScale, 0, 1, 0)
                        Fill.ZIndex = 6
                        corner(Fill, 2)

                        Thumb.Parent = Track
                        Thumb.BackgroundColor3 = T.WHITE
                        Thumb.BorderSizePixel = 0
                        Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
                        Thumb.Position = UDim2.new(initScale, 0, 0.5, 0)
                        Thumb.Size = UDim2.new(0, 12, 0, 12)
                        Thumb.ZIndex = 7
                        corner(Thumb, 6)
                        stroke(Thumb, T.ACCENT, 2, 0)

                        HitArea.Parent = Row
                        HitArea.BackgroundTransparency = 1
                        HitArea.Position = UDim2.new(0, 0, 0, 18)
                        HitArea.Size = UDim2.new(1, 0, 0, 24)
                        HitArea.Text = ""
                        HitArea.AutoButtonColor = false
                        HitArea.ZIndex = 8

                        local function updateSlider(input)
                            local scale = math.clamp(
                                (input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X,
                                0, 1
                            )
                            tween(Fill, TI_FAST, { Size = UDim2.new(scale, 0, 1, 0) })
                            tween(Thumb, TI_FAST, { Position = UDim2.new(scale, 0, 0.5, 0) })
                            local raw = scale * (max - min) + min
                            local val = isFloat and tonumber(string.format("%.2f", raw)) or math.floor(raw)
                            ValLbl.Text = tostring(val)
                            callback(val)
                        end

                        HitArea.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragging = true
                                tween(Thumb, TI_FAST, { Size = UDim2.new(0, 14, 0, 14) })
                                updateSlider(i)
                            end
                        end)
                        HitArea.InputEnded:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                dragging = false
                                tween(Thumb, TI_FAST, { Size = UDim2.new(0, 12, 0, 12) })
                            end
                        end)
                        UserInputService.InputChanged:Connect(function(i)
                            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                                updateSlider(i)
                            end
                        end)
                    end,

                    CreateButton = function(_, label, callback)
                        addItem()

                        local Row = Instance.new("Frame")
                        local Btn = Instance.new("TextButton")

                        Row.Name = stripSpaces(label) .. "BtnRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)
                        Row.ZIndex = 5

                        Btn.Parent = Row
                        Btn.BackgroundColor3 = T.ACCENT_DIM
                        Btn.BorderSizePixel = 0
                        Btn.AnchorPoint = Vector2.new(0.5, 0.5)
                        Btn.Position = UDim2.new(0.5, 0, 0.5, 0)
                        Btn.Size = UDim2.new(1, 0, 0, 26)
                        Btn.AutoButtonColor = false
                        Btn.Font = Enum.Font.GothamBold
                        Btn.Text = label
                        Btn.TextColor3 = T.TEXT
                        Btn.TextSize = 11
                        Btn.ZIndex = 6
                        corner(Btn, 6)
                        stroke(Btn, T.ACCENT, 1, 0.5)

                        Btn.MouseEnter:Connect(function()
                            tween(Btn, TI_FAST, { BackgroundColor3 = T.ACCENT })
                        end)
                        Btn.MouseLeave:Connect(function()
                            tween(Btn, TI_FAST, { BackgroundColor3 = T.ACCENT_DIM })
                        end)
                        Btn.MouseButton1Down:Connect(function()
                            tween(Btn, TI_FAST, { Size = UDim2.new(1, 0, 0, 23) })
                        end)
                        Btn.MouseButton1Up:Connect(function()
                            tween(Btn, TI_SPRING, { Size = UDim2.new(1, 0, 0, 26) })
                        end)
                        Btn.MouseButton1Click:Connect(function()
                            callback(Btn)
                        end)
                    end,

                    CreateTextbox = function(_, placeholder, callback)
                        addItem()

                        local Row = Instance.new("Frame")
                        local TB  = Instance.new("TextBox")

                        Row.Name = stripSpaces(placeholder) .. "TBRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)
                        Row.ZIndex = 5

                        TB.Parent = Row
                        TB.BackgroundColor3 = T.ELEMENT
                        TB.BorderSizePixel = 0
                        TB.AnchorPoint = Vector2.new(0.5, 0.5)
                        TB.Position = UDim2.new(0.5, 0, 0.5, 0)
                        TB.Size = UDim2.new(1, 0, 0, 26)
                        TB.ClearTextOnFocus = false
                        TB.Font = Enum.Font.Gotham
                        TB.PlaceholderText = placeholder
                        TB.PlaceholderColor3 = T.SUBTEXT
                        TB.Text = ""
                        TB.TextColor3 = T.TEXT
                        TB.TextSize = 11
                        TB.ZIndex = 6
                        corner(TB, 6)
                        local tbStroke = stroke(TB, T.ELEMENT2, 1, 0)

                        TB.Focused:Connect(function()
                            tween(TB, TI_FAST, { BackgroundColor3 = T.SECTION })
                            tween(tbStroke, TI_FAST, { Color = T.ACCENT })
                        end)
                        TB.FocusLost:Connect(function(enter)
                            tween(TB, TI_FAST, { BackgroundColor3 = T.ELEMENT })
                            tween(tbStroke, TI_FAST, { Color = T.ELEMENT2 })
                            if enter then callback(TB.Text) end
                        end)
                    end,

                    CreateDropdown = function(_, label, options, defaultIndex, callback)
                        addItem()
                        local selected = options[defaultIndex] or options[1]
                        local isOpen = false
                        local OPT_H = 26
                        local maxVisible = math.min(#options, 4)
                        local popupH = maxVisible * OPT_H

                        local Row      = Instance.new("Frame")
                        local Display  = Instance.new("Frame")
                        local SelLabel = Instance.new("TextLabel")
                        local Arrow    = Instance.new("TextLabel")
                        local HitArea  = Instance.new("TextButton")
                        local Popup    = Instance.new("Frame")
                        local Scroll   = Instance.new("ScrollingFrame")
                        local SLayout  = Instance.new("UIListLayout")

                        Row.Name = stripSpaces(label) .. "DDRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.ClipsDescendants = false
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)
                        Row.ZIndex = 5

                        Display.Parent = Row
                        Display.BackgroundColor3 = T.ELEMENT
                        Display.BorderSizePixel = 0
                        Display.AnchorPoint = Vector2.new(0.5, 0.5)
                        Display.Position = UDim2.new(0.5, 0, 0.5, 0)
                        Display.Size = UDim2.new(1, 0, 0, 26)
                        Display.ZIndex = 6
                        corner(Display, 6)
                        stroke(Display, T.ELEMENT2, 1, 0.4)

                        SelLabel.Parent = Display
                        SelLabel.BackgroundTransparency = 1
                        SelLabel.Position = UDim2.new(0, 10, 0, 0)
                        SelLabel.Size = UDim2.new(1, -28, 1, 0)
                        SelLabel.Font = Enum.Font.Gotham
                        SelLabel.Text = selected
                        SelLabel.TextColor3 = T.TEXT
                        SelLabel.TextSize = 11
                        SelLabel.TextXAlignment = Enum.TextXAlignment.Left
                        SelLabel.ZIndex = 7

                        Arrow.Parent = Display
                        Arrow.BackgroundTransparency = 1
                        Arrow.AnchorPoint = Vector2.new(1, 0.5)
                        Arrow.Position = UDim2.new(1, -6, 0.5, 0)
                        Arrow.Size = UDim2.new(0, 16, 0, 16)
                        Arrow.Font = Enum.Font.GothamBold
                        Arrow.Text = "›"
                        Arrow.TextColor3 = T.SUBTEXT
                        Arrow.TextSize = 16
                        Arrow.Rotation = 90
                        Arrow.ZIndex = 7

                        HitArea.Parent = Display
                        HitArea.BackgroundTransparency = 1
                        HitArea.Size = UDim2.new(1, 0, 1, 0)
                        HitArea.Text = ""
                        HitArea.AutoButtonColor = false
                        HitArea.ZIndex = 8

                        Popup.Parent = Row
                        Popup.BackgroundColor3 = T.SECTION
                        Popup.BorderSizePixel = 0
                        Popup.ClipsDescendants = true
                        Popup.Position = UDim2.new(0, 0, 1, 4)
                        Popup.Size = UDim2.new(1, 0, 0, 0)
                        Popup.ZIndex = 20
                        corner(Popup, 6)
                        stroke(Popup, T.ELEMENT2, 1, 0.3)

                        Scroll.Parent = Popup
                        Scroll.BackgroundTransparency = 1
                        Scroll.BorderSizePixel = 0
                        Scroll.Size = UDim2.new(1, 0, 1, 0)
                        Scroll.CanvasSize = UDim2.new(0, 0, 0, #options * OPT_H)
                        Scroll.ScrollBarThickness = 2
                        Scroll.ScrollBarImageColor3 = T.ACCENT
                        Scroll.ZIndex = 21

                        SLayout.Parent = Scroll
                        SLayout.SortOrder = Enum.SortOrder.LayoutOrder

                        for _, opt in ipairs(options) do
                            local OBtn = Instance.new("TextButton")
                            OBtn.Parent = Scroll
                            OBtn.BackgroundTransparency = 1
                            OBtn.BorderSizePixel = 0
                            OBtn.Size = UDim2.new(1, 0, 0, OPT_H)
                            OBtn.AutoButtonColor = false
                            OBtn.Font = Enum.Font.Gotham
                            OBtn.Text = opt
                            OBtn.TextColor3 = T.TEXT
                            OBtn.TextSize = 11
                            OBtn.ZIndex = 22

                            OBtn.MouseEnter:Connect(function()
                                tween(OBtn, TI_FAST, { BackgroundTransparency = 0.6, BackgroundColor3 = T.ACCENT })
                            end)
                            OBtn.MouseLeave:Connect(function()
                                tween(OBtn, TI_FAST, { BackgroundTransparency = 1 })
                            end)
                            OBtn.MouseButton1Click:Connect(function()
                                selected = opt
                                SelLabel.Text = opt
                                callback(opt)
                                isOpen = false
                                tween(Arrow, TI_MED, { Rotation = 90, TextColor3 = T.SUBTEXT })
                                tween(Popup, TI_MED, { Size = UDim2.new(1, 0, 0, 0) })
                                SectionFrame.ClipsDescendants = true
                                Body.ClipsDescendants = true
                            end)
                        end

                        HitArea.MouseButton1Click:Connect(function()
                            if isOpen then
                                isOpen = false
                                tween(Arrow, TI_MED, { Rotation = 90, TextColor3 = T.SUBTEXT })
                                tween(Popup, TI_MED, { Size = UDim2.new(1, 0, 0, 0) })
                                SectionFrame.ClipsDescendants = true
                                Body.ClipsDescendants = true
                            else
                                isOpen = true
                                SectionFrame.ClipsDescendants = false
                                Body.ClipsDescendants = false
                                ItemContainer.ClipsDescendants = false
                                tween(Arrow, TI_MED, { Rotation = 270, TextColor3 = T.ACCENT })
                                tween(Popup, TI_MED, { Size = UDim2.new(1, 0, 0, popupH) })
                            end
                        end)

                        Display.MouseEnter:Connect(function()
                            tween(Display, TI_FAST, { BackgroundColor3 = T.ELEMENT2 })
                        end)
                        Display.MouseLeave:Connect(function()
                            tween(Display, TI_FAST, { BackgroundColor3 = T.ELEMENT })
                        end)
                    end,

                    CreateColorPicker = function(_, label, defaultColor, callback)
                        addItem()
                        colorPickerZIndex = colorPickerZIndex + 1
                        local zi = colorPickerZIndex
                        local pickerOpen = false
                        local rainbowOn  = false
                        local satConn, hueConn
                        local HSV = { H = 1, S = 1, V = 1 }

                        local Row       = Instance.new("Frame")
                        local Lbl       = Instance.new("TextLabel")
                        local Swatch    = Instance.new("TextButton")
                        local Popup     = Instance.new("Frame")
                        local SatHolder = Instance.new("Frame")
                        local SatSurf   = Instance.new("ImageLabel")
                        local SatMark   = Instance.new("ImageLabel")
                        local HueHolder = Instance.new("Frame")
                        local HueBar    = Instance.new("ImageLabel")
                        local HueMark   = Instance.new("Frame")
                        local LabelR    = Instance.new("TextLabel")
                        local LabelG    = Instance.new("TextLabel")
                        local LabelB    = Instance.new("TextLabel")
                        local RainRow   = Instance.new("Frame")
                        local RainLbl   = Instance.new("TextLabel")
                        local RainTrack = Instance.new("Frame")
                        local RainKnob  = Instance.new("Frame")
                        local RainHit   = Instance.new("TextButton")

                        Row.Name = stripSpaces(label) .. "CPRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.ClipsDescendants = false
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)
                        Row.ZIndex = 5

                        Lbl.Parent = Row
                        Lbl.BackgroundTransparency = 1
                        Lbl.Size = UDim2.new(1, -38, 1, 0)
                        Lbl.Font = Enum.Font.Gotham
                        Lbl.Text = label
                        Lbl.TextColor3 = T.TEXT
                        Lbl.TextSize = 11
                        Lbl.TextXAlignment = Enum.TextXAlignment.Left
                        Lbl.ZIndex = 6

                        Swatch.Parent = Row
                        Swatch.BackgroundColor3 = defaultColor
                        Swatch.BorderSizePixel = 0
                        Swatch.AnchorPoint = Vector2.new(1, 0.5)
                        Swatch.Position = UDim2.new(1, 0, 0.5, 0)
                        Swatch.Size = UDim2.new(0, 30, 0, 20)
                        Swatch.AutoButtonColor = false
                        Swatch.Text = ""
                        Swatch.ZIndex = 6
                        corner(Swatch, 5)
                        stroke(Swatch, T.ELEMENT2, 1, 0.3)

                        Popup.Parent = Row
                        Popup.BackgroundColor3 = T.SECTION
                        Popup.BorderSizePixel = 0
                        Popup.ClipsDescendants = true
                        Popup.Position = UDim2.new(1, 8, -1.5, 0)
                        Popup.Size = UDim2.new(0, 0, 0, 175)
                        Popup.ZIndex = 10 + zi
                        corner(Popup, 8)
                        stroke(Popup, T.ELEMENT2, 1, 0.3)

                        SatHolder.Parent = Popup
                        SatHolder.BackgroundColor3 = T.ELEMENT
                        SatHolder.BorderSizePixel = 0
                        SatHolder.ClipsDescendants = true
                        SatHolder.Position = UDim2.new(0, 6, 0, 6)
                        SatHolder.Size = UDim2.new(0, 120, 0, 114)
                        SatHolder.ZIndex = 11 + zi
                        corner(SatHolder, 6)

                        SatSurf.Parent = SatHolder
                        SatSurf.BackgroundColor3 = defaultColor
                        SatSurf.BorderSizePixel = 0
                        SatSurf.Size = UDim2.new(1, 0, 1, 0)
                        SatSurf.Image = "rbxassetid://4805274903"
                        SatSurf.ZIndex = 12 + zi

                        SatMark.Parent = SatHolder
                        SatMark.BackgroundTransparency = 1
                        SatMark.Size = UDim2.new(0, 0, 0, 0)
                        SatMark.Image = "http://www.roblox.com/asset/?id=4805639000"
                        SatMark.ZIndex = 13 + zi

                        HueHolder.Parent = Popup
                        HueHolder.BackgroundColor3 = T.ELEMENT
                        HueHolder.BorderSizePixel = 0
                        HueHolder.ClipsDescendants = true
                        HueHolder.Position = UDim2.new(0, 133, 0, 6)
                        HueHolder.Size = UDim2.new(0, 20, 0, 114)
                        HueHolder.ZIndex = 11 + zi
                        corner(HueHolder, 5)

                        HueBar.Parent = HueHolder
                        HueBar.BackgroundTransparency = 1
                        HueBar.Size = UDim2.new(1, 0, 1, 0)
                        HueBar.Image = "http://www.roblox.com/asset/?id=4801885250"
                        HueBar.ScaleType = Enum.ScaleType.Crop
                        HueBar.ZIndex = 12 + zi

                        HueMark.Parent = HueHolder
                        HueMark.BackgroundColor3 = T.WHITE
                        HueMark.BorderSizePixel = 0
                        HueMark.Position = UDim2.new(0, -2, 0, 0)
                        HueMark.Size = UDim2.new(1, 4, 0, 3)
                        HueMark.ZIndex = 13 + zi
                        corner(HueMark, 2)

                        local function makeRgbLbl(xPos, text)
                            local l = Instance.new("TextLabel")
                            l.Parent = Popup
                            l.BackgroundColor3 = T.ELEMENT
                            l.BorderSizePixel = 0
                            l.Position = UDim2.new(0, xPos, 0, 127)
                            l.Size = UDim2.new(0, 46, 0, 16)
                            l.ZIndex = 11 + zi
                            l.Font = Enum.Font.GothamBold
                            l.TextColor3 = T.TEXT
                            l.TextSize = 9
                            l.Text = text
                            corner(l, 4)
                            return l
                        end

                        LabelR = makeRgbLbl(6, "R: 000")
                        LabelG = makeRgbLbl(55, "G: 000")
                        LabelB = makeRgbLbl(104, "B: 000")

                        RainRow.Parent = Popup
                        RainRow.BackgroundTransparency = 1
                        RainRow.Position = UDim2.new(0, 6, 0, 149)
                        RainRow.Size = UDim2.new(1, -12, 0, 22)
                        RainRow.ZIndex = 11 + zi

                        RainLbl.Parent = RainRow
                        RainLbl.BackgroundTransparency = 1
                        RainLbl.Size = UDim2.new(1, -50, 1, 0)
                        RainLbl.Font = Enum.Font.Gotham
                        RainLbl.Text = "Rainbow"
                        RainLbl.TextColor3 = T.TEXT
                        RainLbl.TextSize = 10
                        RainLbl.TextXAlignment = Enum.TextXAlignment.Left
                        RainLbl.ZIndex = 12 + zi

                        RainTrack.Parent = RainRow
                        RainTrack.BackgroundColor3 = T.TOGGLE_OFF
                        RainTrack.BorderSizePixel = 0
                        RainTrack.AnchorPoint = Vector2.new(1, 0.5)
                        RainTrack.Position = UDim2.new(1, 0, 0.5, 0)
                        RainTrack.Size = UDim2.new(0, 36, 0, 18)
                        RainTrack.ZIndex = 12 + zi
                        corner(RainTrack, 9)

                        RainKnob.Parent = RainTrack
                        RainKnob.BackgroundColor3 = T.WHITE
                        RainKnob.BorderSizePixel = 0
                        RainKnob.AnchorPoint = Vector2.new(0, 0.5)
                        RainKnob.Position = UDim2.new(0, 2, 0.5, 0)
                        RainKnob.Size = UDim2.new(0, 14, 0, 14)
                        RainKnob.ZIndex = 13 + zi
                        corner(RainKnob, 7)

                        RainHit.Parent = RainRow
                        RainHit.BackgroundTransparency = 1
                        RainHit.Size = UDim2.new(1, 0, 1, 0)
                        RainHit.Text = ""
                        RainHit.AutoButtonColor = false
                        RainHit.ZIndex = 14 + zi

                        local function updateRgb()
                            local c = Swatch.BackgroundColor3
                            LabelR.Text = "R: " .. math.floor(c.R * 255)
                            LabelG.Text = "G: " .. math.floor(c.G * 255)
                            LabelB.Text = "B: " .. math.floor(c.B * 255)
                        end

                        local function applyHSV()
                            local c = Color3.fromHSV(HSV.H, HSV.S, HSV.V)
                            Swatch.BackgroundColor3 = c
                            SatSurf.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1)
                            callback(c)
                            updateRgb()
                        end

                        updateRgb()

                        local function closePopup()
                            pickerOpen = false
                            tween(Popup, TI_SLOW, { Size = UDim2.new(0, 0, 0, 175) })
                            SectionFrame.ClipsDescendants = true
                            Body.ClipsDescendants = true
                        end

                        Swatch.MouseButton1Click:Connect(function()
                            if pickerOpen then
                                closePopup()
                            else
                                pickerOpen = true
                                SectionFrame.ClipsDescendants = false
                                Body.ClipsDescendants = false
                                ItemContainer.ClipsDescendants = false
                                tween(Popup, TI_SLOW, { Size = UDim2.new(0, 159, 0, 175) })
                            end
                        end)

                        SatSurf.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 and not rainbowOn then
                                if satConn then satConn:Disconnect() end
                                satConn = RunService.RenderStepped:Connect(function()
                                    local x = math.clamp((Mouse.X - SatHolder.AbsolutePosition.X) / SatHolder.AbsoluteSize.X, 0, 1)
                                    local y = math.clamp((Mouse.Y - SatHolder.AbsolutePosition.Y) / SatHolder.AbsoluteSize.Y, 0, 1)
                                    SatMark.Position = UDim2.new(x, 0, y, 0)
                                    HSV.S = x
                                    HSV.V = 1 - y
                                    applyHSV()
                                end)
                            end
                        end)
                        SatSurf.InputEnded:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 and satConn then
                                satConn:Disconnect() satConn = nil
                            end
                        end)

                        HueBar.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 and not rainbowOn then
                                if hueConn then hueConn:Disconnect() end
                                hueConn = RunService.RenderStepped:Connect(function()
                                    local y = math.clamp((Mouse.Y - HueHolder.AbsolutePosition.Y) / HueHolder.AbsoluteSize.Y, 0, 1)
                                    HSV.H = 1 - y
                                    tween(HueMark, TI_FAST, { Position = UDim2.new(0, -2, y, 0) })
                                    applyHSV()
                                end)
                            end
                        end)
                        HueBar.InputEnded:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 and hueConn then
                                hueConn:Disconnect() hueConn = nil
                            end
                        end)

                        RainHit.MouseButton1Click:Connect(function()
                            rainbowOn = not rainbowOn
                            if rainbowOn then
                                tween(RainTrack, TI_MED, { BackgroundColor3 = T.ACCENT })
                                tween(RainKnob, TI_SPRING, { Position = UDim2.new(0, 20, 0.5, 0) })
                                while rainbowOn do
                                    local c = Color3.fromHSV(hue, 1, 1)
                                    Swatch.BackgroundColor3 = c
                                    SatSurf.BackgroundColor3 = c
                                    callback(c)
                                    updateRgb()
                                    task.wait()
                                end
                            else
                                tween(RainTrack, TI_MED, { BackgroundColor3 = T.TOGGLE_OFF })
                                tween(RainKnob, TI_SPRING, { Position = UDim2.new(0, 2, 0.5, 0) })
                            end
                        end)
                    end,
                }
            end,
        }
    end,
}
