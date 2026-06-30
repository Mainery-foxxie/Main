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

-- Helpers
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
        windowOffset = windowOffset + 2

        local WIN_W = 240
        local windowId = stripSpaces(windowTitle)
        local bodyHeight = 0
        local windowOpen = true

        local WindowRoot = Instance.new("Frame")
        local Topbar     = Instance.new("Frame")
        local TitleLabel = Instance.new("TextLabel")
        local MinBtn     = Instance.new("TextButton")
        local Body       = Instance.new("Frame")
        local BodyLayout = Instance.new("UIListLayout")

        -- Window shadow
        local Shadow = Instance.new("ImageLabel")
        Shadow.Name = "Shadow"
        Shadow.Parent = Container
        Shadow.BackgroundTransparency = 1
        Shadow.Size = UDim2.new(0, WIN_W + 30, 0, 60)
        Shadow.Position = UDim2.new(windowOffset, -115, 3, -278)
        Shadow.Image = "rbxassetid://6014261993"
        Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        Shadow.ImageTransparency = 0.5
        Shadow.ScaleType = Enum.ScaleType.Slice
        Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

        WindowRoot.Name = windowId .. "Window"
        WindowRoot.Parent = Container
        WindowRoot.BackgroundColor3 = T.BG
        WindowRoot.BorderSizePixel = 0
        WindowRoot.Position = UDim2.new(windowOffset, -100, 3, -265)
        WindowRoot.Size = UDim2.new(0, WIN_W, 0, 36)
        WindowRoot.ZIndex = 2
        corner(WindowRoot, 10)
        stroke(WindowRoot, T.ELEMENT2, 1, 0.5)

        Topbar.Name = "Topbar"
        Topbar.Parent = WindowRoot
        Topbar.BackgroundColor3 = T.SURFACE
        Topbar.BorderSizePixel = 0
        Topbar.Size = UDim2.new(1, 0, 0, 36)
        Topbar.ZIndex = 2
        corner(Topbar, 10)

        -- Accent line at top of topbar
        local AccentLine = Instance.new("Frame")
        AccentLine.Name = "AccentLine"
        AccentLine.Parent = Topbar
        AccentLine.BackgroundColor3 = T.ACCENT
        AccentLine.BorderSizePixel = 0
        AccentLine.Size = UDim2.new(1, 0, 0, 2)
        AccentLine.Position = UDim2.new(0, 0, 0, 0)
        AccentLine.ZIndex = 3
        local acCorner = Instance.new("UICorner")
        acCorner.CornerRadius = UDim.new(0, 10)
        acCorner.Parent = AccentLine

        -- Dot indicators
        local function makeDot(color, xOff)
            local d = Instance.new("Frame")
            d.Parent = Topbar
            d.BackgroundColor3 = color
            d.BorderSizePixel = 0
            d.Size = UDim2.new(0, 8, 0, 8)
            d.Position = UDim2.new(0, xOff, 0.5, -4)
            d.ZIndex = 3
            corner(d, 4)
            return d
        end
        makeDot(Color3.fromRGB(255, 95, 87), 12)
        makeDot(Color3.fromRGB(255, 189, 46), 26)
        makeDot(Color3.fromRGB(40, 201, 64), 40)

        TitleLabel.Name = "WindowTitle"
        TitleLabel.Parent = Topbar
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 58, 0, 0)
        TitleLabel.Size = UDim2.new(0, WIN_W - 90, 0, 36)
        TitleLabel.ZIndex = 3
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
        MinBtn.Position = UDim2.new(1, -10, 0.5, 0)
        MinBtn.Size = UDim2.new(0, 22, 0, 16)
        MinBtn.ZIndex = 3
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
        Body.Position = UDim2.new(0, 0, 0, 36)
        Body.Size = UDim2.new(1, 0, 0, 0)
        Body.ZIndex = 2

        local BodyPad = Instance.new("UIPadding")
        BodyPad.Parent = Body
        BodyPad.PaddingTop = UDim.new(0, 6)
        BodyPad.PaddingBottom = UDim.new(0, 6)

        BodyLayout.Parent = Body
        BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
        BodyLayout.Padding = UDim.new(0, 4)

        local function growBody(amount)
            bodyHeight = bodyHeight + amount
            tween(Body, TI_MED, { Size = UDim2.new(1, 0, 0, bodyHeight) })
            tween(WindowRoot, TI_MED, { Size = UDim2.new(0, WIN_W, 0, 36 + bodyHeight) })
            tween(Shadow, TI_MED, { Size = UDim2.new(0, WIN_W + 30, 0, 36 + bodyHeight + 24) })
        end
        local function shrinkBody(amount)
            bodyHeight = bodyHeight - amount
            tween(Body, TI_MED, { Size = UDim2.new(1, 0, 0, bodyHeight) })
            tween(WindowRoot, TI_MED, { Size = UDim2.new(0, WIN_W, 0, 36 + bodyHeight) })
            tween(Shadow, TI_MED, { Size = UDim2.new(0, WIN_W + 30, 0, 36 + bodyHeight + 24) })
        end

        MinBtn.MouseButton1Click:Connect(function()
            if windowOpen then
                windowOpen = false
                tween(MinBtn, TI_FAST, { Size = UDim2.new(0, 22, 0, 16) })
                MinBtn.Text = "+"
                tween(Body, TI_MED, { Size = UDim2.new(1, 0, 0, 0) })
                tween(WindowRoot, TI_MED, { Size = UDim2.new(0, WIN_W, 0, 36) })
                tween(Shadow, TI_MED, { Size = UDim2.new(0, WIN_W + 30, 0, 60) })
            else
                windowOpen = true
                MinBtn.Text = "—"
                tween(Body, TI_MED, { Size = UDim2.new(1, 0, 0, bodyHeight) })
                tween(WindowRoot, TI_MED, { Size = UDim2.new(0, WIN_W, 0, 36 + bodyHeight) })
                tween(Shadow, TI_MED, { Size = UDim2.new(0, WIN_W + 30, 0, 36 + bodyHeight + 24) })
            end
        end)

        Dragging(Topbar)

        return {
            NewSection = function(_, sectionTitle)
                local sectionId = stripSpaces(sectionTitle)
                local sectionOpen = false
                local sectionHeight = 36
                local ITEM_H = 34

                local SectionFrame  = Instance.new("Frame")
                local SectionHeader = Instance.new("Frame")
                local AccentBar     = Instance.new("Frame")
                local SecTitle      = Instance.new("TextLabel")
                local ChevronLbl    = Instance.new("TextLabel")
                local ItemContainer = Instance.new("Frame")
                local ItemLayout    = Instance.new("UIListLayout")

                SectionFrame.Name = sectionId .. "Section"
                SectionFrame.Parent = Body
                SectionFrame.BackgroundColor3 = T.SURFACE
                SectionFrame.BorderSizePixel = 0
                SectionFrame.ClipsDescendants = true
                SectionFrame.Size = UDim2.new(1, -16, 0, sectionHeight)
                SectionFrame.Position = UDim2.new(0, 8, 0, 0)
                corner(SectionFrame, 8)
                stroke(SectionFrame, T.ELEMENT, 1, 0.6)

                growBody(ITEM_H + 10)

                SectionHeader.Name = "SectionHeader"
                SectionHeader.Parent = SectionFrame
                SectionHeader.BackgroundTransparency = 1
                SectionHeader.Size = UDim2.new(1, 0, 0, 36)
                SectionHeader.ZIndex = 3

                AccentBar.Name = "AccentBar"
                AccentBar.Parent = SectionHeader
                AccentBar.BackgroundColor3 = T.ACCENT
                AccentBar.BorderSizePixel = 0
                AccentBar.Size = UDim2.new(0, 3, 0, 16)
                AccentBar.Position = UDim2.new(0, 10, 0.5, -8)
                AccentBar.ZIndex = 4
                corner(AccentBar, 2)

                SecTitle.Name = "SectionTitle"
                SecTitle.Parent = SectionHeader
                SecTitle.BackgroundTransparency = 1
                SecTitle.Position = UDim2.new(0, 22, 0, 0)
                SecTitle.Size = UDim2.new(1, -50, 1, 0)
                SecTitle.ZIndex = 4
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
                ChevronLbl.ZIndex = 4
                ChevronLbl.Font = Enum.Font.GothamBold
                ChevronLbl.Text = "›"
                ChevronLbl.TextColor3 = T.SUBTEXT
                ChevronLbl.TextSize = 16
                ChevronLbl.Rotation = 90

                ItemContainer.Name = "Items"
                ItemContainer.Parent = SectionFrame
                ItemContainer.BackgroundTransparency = 1
                ItemContainer.BorderSizePixel = 0
                ItemContainer.Position = UDim2.new(0, 0, 0, 36)
                ItemContainer.Size = UDim2.new(1, 0, 1, -36)
                ItemContainer.ClipsDescendants = true

                local ItemPad = Instance.new("UIPadding")
                ItemPad.Parent = ItemContainer
                ItemPad.PaddingLeft = UDim.new(0, 10)
                ItemPad.PaddingRight = UDim.new(0, 10)
                ItemPad.PaddingBottom = UDim.new(0, 4)

                ItemLayout.Parent = ItemContainer
                ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ItemLayout.Padding = UDim.new(0, 2)

                local itemCount = 0

                local function growSection()
                    sectionHeight = sectionHeight + ITEM_H
                    tween(SectionFrame, TI_MED, { Size = UDim2.new(1, -16, 0, sectionHeight) })
                    growBody(ITEM_H)
                end
                local function shrinkSection()
                    sectionHeight = sectionHeight - ITEM_H
                    tween(SectionFrame, TI_MED, { Size = UDim2.new(1, -16, 0, sectionHeight) })
                    shrinkBody(ITEM_H)
                end

                local clickBtn = Instance.new("TextButton")
                clickBtn.Name = "SectionClickRegion"
                clickBtn.Parent = SectionHeader
                clickBtn.BackgroundTransparency = 1
                clickBtn.Size = UDim2.new(1, 0, 1, 0)
                clickBtn.ZIndex = 5
                clickBtn.Text = ""
                clickBtn.AutoButtonColor = false

                clickBtn.MouseButton1Click:Connect(function()
                    if sectionOpen then
                        sectionOpen = false
                        tween(ChevronLbl, TI_MED, { Rotation = 90, TextColor3 = T.SUBTEXT })
                        for _ = 1, itemCount do
                            shrinkSection()
                        end
                    else
                        sectionOpen = true
                        tween(ChevronLbl, TI_MED, { Rotation = 270, TextColor3 = T.ACCENT })
                        for _ = 1, itemCount do
                            growSection()
                        end
                    end
                end)

                SectionHeader.MouseEnter:Connect(function()
                    tween(SectionFrame, TI_FAST, { BackgroundColor3 = T.SECTION })
                end)
                SectionHeader.MouseLeave:Connect(function()
                    tween(SectionFrame, TI_FAST, { BackgroundColor3 = T.SURFACE })
                end)

                -- Section API
                return {
                    CreateToggle = function(_, label, callback)
                        itemCount = itemCount + 1
                        local state = false

                        local Row      = Instance.new("Frame")
                        local Lbl      = Instance.new("TextLabel")
                        local Track    = Instance.new("Frame")
                        local Knob     = Instance.new("Frame")
                        local HitArea  = Instance.new("TextButton")

                        Row.Name = stripSpaces(label) .. "Row"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)

                        Lbl.Name = "Label"
                        Lbl.Parent = Row
                        Lbl.BackgroundTransparency = 1
                        Lbl.Position = UDim2.new(0, 0, 0, 0)
                        Lbl.Size = UDim2.new(1, -52, 1, 0)
                        Lbl.Font = Enum.Font.Gotham
                        Lbl.Text = label
                        Lbl.TextColor3 = T.TEXT
                        Lbl.TextSize = 11
                        Lbl.TextXAlignment = Enum.TextXAlignment.Left

                        Track.Name = "Track"
                        Track.Parent = Row
                        Track.BackgroundColor3 = T.TOGGLE_OFF
                        Track.BorderSizePixel = 0
                        Track.AnchorPoint = Vector2.new(1, 0.5)
                        Track.Position = UDim2.new(1, 0, 0.5, 0)
                        Track.Size = UDim2.new(0, 40, 0, 20)
                        corner(Track, 10)

                        Knob.Name = "Knob"
                        Knob.Parent = Track
                        Knob.BackgroundColor3 = T.WHITE
                        Knob.BorderSizePixel = 0
                        Knob.AnchorPoint = Vector2.new(0, 0.5)
                        Knob.Position = UDim2.new(0, 2, 0.5, 0)
                        Knob.Size = UDim2.new(0, 16, 0, 16)
                        corner(Knob, 8)

                        HitArea.Name = "Hit"
                        HitArea.Parent = Row
                        HitArea.BackgroundTransparency = 1
                        HitArea.Size = UDim2.new(1, 0, 1, 0)
                        HitArea.Text = ""
                        HitArea.AutoButtonColor = false
                        HitArea.ZIndex = 2

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
                        itemCount = itemCount + 1
                        local dragging = false
                        local SLIDER_H = ITEM_H + 10

                        local Row      = Instance.new("Frame")
                        local Lbl      = Instance.new("TextLabel")
                        local ValLbl   = Instance.new("TextLabel")
                        local Track    = Instance.new("Frame")
                        local Fill     = Instance.new("Frame")
                        local Thumb    = Instance.new("Frame")
                        local HitArea  = Instance.new("TextButton")

                        Row.Name = stripSpaces(label) .. "SliderRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, SLIDER_H)

                        Lbl.Name = "Label"
                        Lbl.Parent = Row
                        Lbl.BackgroundTransparency = 1
                        Lbl.Position = UDim2.new(0, 0, 0, 0)
                        Lbl.Size = UDim2.new(0.6, 0, 0, 18)
                        Lbl.Font = Enum.Font.Gotham
                        Lbl.Text = label
                        Lbl.TextColor3 = T.TEXT
                        Lbl.TextSize = 11
                        Lbl.TextXAlignment = Enum.TextXAlignment.Left

                        local ValBg = Instance.new("Frame")
                        ValBg.Parent = Row
                        ValBg.BackgroundColor3 = T.ELEMENT
                        ValBg.BorderSizePixel = 0
                        ValBg.AnchorPoint = Vector2.new(1, 0)
                        ValBg.Position = UDim2.new(1, 0, 0, 0)
                        ValBg.Size = UDim2.new(0, 42, 0, 18)
                        corner(ValBg, 5)

                        ValLbl.Name = "Value"
                        ValLbl.Parent = ValBg
                        ValLbl.BackgroundTransparency = 1
                        ValLbl.Size = UDim2.new(1, 0, 1, 0)
                        ValLbl.Font = Enum.Font.GothamBold
                        ValLbl.TextColor3 = T.ACCENT
                        ValLbl.TextSize = 10
                        ValLbl.Text = tostring(isFloat and tonumber(string.format("%.2f", default or min)) or (default or min))

                        Track.Name = "Track"
                        Track.Parent = Row
                        Track.BackgroundColor3 = T.ELEMENT
                        Track.BorderSizePixel = 0
                        Track.Position = UDim2.new(0, 0, 0, 26)
                        Track.Size = UDim2.new(1, 0, 0, 4)
                        corner(Track, 2)

                        Fill.Name = "Fill"
                        Fill.Parent = Track
                        Fill.BackgroundColor3 = T.ACCENT
                        Fill.BorderSizePixel = 0
                        Fill.Size = UDim2.new(((default or min) - min) / math.max(max - min, 0.0001), 0, 1, 0)
                        corner(Fill, 2)

                        Thumb.Name = "Thumb"
                        Thumb.Parent = Track
                        Thumb.BackgroundColor3 = T.WHITE
                        Thumb.BorderSizePixel = 0
                        Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
                        Thumb.Position = UDim2.new(((default or min) - min) / math.max(max - min, 0.0001), 0, 0.5, 0)
                        Thumb.Size = UDim2.new(0, 12, 0, 12)
                        corner(Thumb, 6)
                        stroke(Thumb, T.ACCENT, 2, 0)

                        HitArea.Name = "Hit"
                        HitArea.Parent = Track
                        HitArea.BackgroundTransparency = 1
                        HitArea.Position = UDim2.new(0, 0, -3, 0)
                        HitArea.Size = UDim2.new(1, 0, 0, 22)
                        HitArea.Text = ""
                        HitArea.AutoButtonColor = false
                        HitArea.ZIndex = 2

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
                        itemCount = itemCount + 1

                        local Row = Instance.new("Frame")
                        local Btn = Instance.new("TextButton")

                        Row.Name = stripSpaces(label) .. "BtnRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)

                        Btn.Name = "Button"
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
                        corner(Btn, 6)
                        stroke(Btn, T.ACCENT, 1, 0.6)

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
                        itemCount = itemCount + 1

                        local Row = Instance.new("Frame")
                        local TB  = Instance.new("TextBox")

                        Row.Name = stripSpaces(placeholder) .. "TBRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)

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
                        corner(TB, 6)
                        local tbStroke = stroke(TB, T.ELEMENT2, 1, 0)

                        TB.Focused:Connect(function()
                            tween(TB, TI_FAST, { BackgroundColor3 = T.SECTION })
                            tween(tbStroke, TI_FAST, { Color = T.ACCENT, Transparency = 0 })
                        end)
                        TB.FocusLost:Connect(function(enter)
                            tween(TB, TI_FAST, { BackgroundColor3 = T.ELEMENT })
                            tween(tbStroke, TI_FAST, { Color = T.ELEMENT2 })
                            if enter then callback(TB.Text) end
                        end)
                    end,

                    CreateDropdown = function(_, label, options, defaultIndex, callback)
                        itemCount = itemCount + 1
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
                        local ScrollLayout = Instance.new("UIListLayout")

                        Row.Name = stripSpaces(label) .. "DDRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.ClipsDescendants = false
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)

                        Display.Name = "Display"
                        Display.Parent = Row
                        Display.BackgroundColor3 = T.ELEMENT
                        Display.BorderSizePixel = 0
                        Display.AnchorPoint = Vector2.new(0.5, 0.5)
                        Display.Position = UDim2.new(0.5, 0, 0.5, 0)
                        Display.Size = UDim2.new(1, 0, 0, 26)
                        corner(Display, 6)
                        stroke(Display, T.ELEMENT2, 1, 0.4)

                        SelLabel.Name = "Selected"
                        SelLabel.Parent = Display
                        SelLabel.BackgroundTransparency = 1
                        SelLabel.Position = UDim2.new(0, 10, 0, 0)
                        SelLabel.Size = UDim2.new(1, -30, 1, 0)
                        SelLabel.Font = Enum.Font.Gotham
                        SelLabel.Text = selected
                        SelLabel.TextColor3 = T.TEXT
                        SelLabel.TextSize = 11
                        SelLabel.TextXAlignment = Enum.TextXAlignment.Left

                        Arrow.Name = "Arrow"
                        Arrow.Parent = Display
                        Arrow.BackgroundTransparency = 1
                        Arrow.AnchorPoint = Vector2.new(1, 0.5)
                        Arrow.Position = UDim2.new(1, -8, 0.5, 0)
                        Arrow.Size = UDim2.new(0, 16, 0, 16)
                        Arrow.Font = Enum.Font.GothamBold
                        Arrow.Text = "›"
                        Arrow.TextColor3 = T.SUBTEXT
                        Arrow.TextSize = 14
                        Arrow.Rotation = 90

                        HitArea.Name = "Hit"
                        HitArea.Parent = Display
                        HitArea.BackgroundTransparency = 1
                        HitArea.Size = UDim2.new(1, 0, 1, 0)
                        HitArea.Text = ""
                        HitArea.AutoButtonColor = false
                        HitArea.ZIndex = 2

                        Popup.Name = "Popup"
                        Popup.Parent = Row
                        Popup.BackgroundColor3 = T.SECTION
                        Popup.BorderSizePixel = 0
                        Popup.ClipsDescendants = true
                        Popup.Position = UDim2.new(0, 0, 1, 4)
                        Popup.Size = UDim2.new(1, 0, 0, 0)
                        Popup.ZIndex = 10
                        corner(Popup, 6)
                        stroke(Popup, T.ELEMENT2, 1, 0.3)

                        Scroll.Parent = Popup
                        Scroll.BackgroundTransparency = 1
                        Scroll.BorderSizePixel = 0
                        Scroll.Size = UDim2.new(1, 0, 1, 0)
                        Scroll.CanvasSize = UDim2.new(0, 0, 0, #options * OPT_H)
                        Scroll.ScrollBarThickness = 2
                        Scroll.ScrollBarImageColor3 = T.ACCENT
                        Scroll.ZIndex = 11

                        ScrollLayout.Parent = Scroll
                        ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder

                        for _, opt in ipairs(options) do
                            local OBtn = Instance.new("TextButton")
                            OBtn.Name = stripSpaces(opt)
                            OBtn.Parent = Scroll
                            OBtn.BackgroundTransparency = 1
                            OBtn.BorderSizePixel = 0
                            OBtn.Size = UDim2.new(1, 0, 0, OPT_H)
                            OBtn.AutoButtonColor = false
                            OBtn.Font = Enum.Font.Gotham
                            OBtn.Text = opt
                            OBtn.TextColor3 = T.TEXT
                            OBtn.TextSize = 11
                            OBtn.ZIndex = 12

                            OBtn.MouseEnter:Connect(function()
                                tween(OBtn, TI_FAST, { BackgroundTransparency = 0.7, BackgroundColor3 = T.ACCENT })
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
                                Body.ClipsDescendants = true
                                ItemContainer.ClipsDescendants = true
                                SectionFrame.ClipsDescendants = true
                            end)
                        end

                        HitArea.MouseButton1Click:Connect(function()
                            if isOpen then
                                isOpen = false
                                tween(Arrow, TI_MED, { Rotation = 90, TextColor3 = T.SUBTEXT })
                                tween(Popup, TI_MED, { Size = UDim2.new(1, 0, 0, 0) })
                                Body.ClipsDescendants = true
                                ItemContainer.ClipsDescendants = true
                                SectionFrame.ClipsDescendants = true
                            else
                                isOpen = true
                                Body.ClipsDescendants = false
                                ItemContainer.ClipsDescendants = false
                                SectionFrame.ClipsDescendants = false
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
                        itemCount = itemCount + 1
                        colorPickerZIndex = colorPickerZIndex + 1
                        local zi = colorPickerZIndex
                        local pickerOpen = false
                        local rainbowOn = false
                        local satConn, hueConn
                        local HSV = { H = 1, S = 1, V = 1 }

                        local Row        = Instance.new("Frame")
                        local Lbl        = Instance.new("TextLabel")
                        local Swatch     = Instance.new("ImageButton")
                        local Popup      = Instance.new("Frame")
                        local HueHolder  = Instance.new("Frame")
                        local HueBar     = Instance.new("ImageLabel")
                        local HueMarker  = Instance.new("Frame")
                        local SatHolder  = Instance.new("Frame")
                        local SatSurface = Instance.new("ImageLabel")
                        local SatMarker  = Instance.new("ImageLabel")
                        local LabelR     = Instance.new("TextLabel")
                        local LabelG     = Instance.new("TextLabel")
                        local LabelB     = Instance.new("TextLabel")
                        local RainRow    = Instance.new("Frame")
                        local RainLbl    = Instance.new("TextLabel")
                        local RainTrack  = Instance.new("Frame")
                        local RainKnob   = Instance.new("Frame")
                        local RainHit    = Instance.new("TextButton")

                        Row.Name = stripSpaces(label) .. "CPRow"
                        Row.Parent = ItemContainer
                        Row.BackgroundTransparency = 1
                        Row.Size = UDim2.new(1, 0, 0, ITEM_H)

                        Lbl.Name = "Label"
                        Lbl.Parent = Row
                        Lbl.BackgroundTransparency = 1
                        Lbl.Position = UDim2.new(0, 0, 0, 0)
                        Lbl.Size = UDim2.new(1, -36, 1, 0)
                        Lbl.Font = Enum.Font.Gotham
                        Lbl.Text = label
                        Lbl.TextColor3 = T.TEXT
                        Lbl.TextSize = 11
                        Lbl.TextXAlignment = Enum.TextXAlignment.Left

                        Swatch.Name = "Swatch"
                        Swatch.Parent = Row
                        Swatch.BackgroundColor3 = defaultColor
                        Swatch.BorderSizePixel = 0
                        Swatch.AnchorPoint = Vector2.new(1, 0.5)
                        Swatch.Position = UDim2.new(1, 0, 0.5, 0)
                        Swatch.Size = UDim2.new(0, 28, 0, 20)
                        Swatch.Image = ""
                        corner(Swatch, 5)
                        stroke(Swatch, T.ELEMENT2, 1, 0.3)

                        Popup.Name = "ColorPopup"
                        Popup.Parent = Row
                        Popup.BackgroundColor3 = T.SECTION
                        Popup.BorderSizePixel = 0
                        Popup.ClipsDescendants = true
                        Popup.Position = UDim2.new(1, 8, -1.6, 0)
                        Popup.Size = UDim2.new(0, 0, 0, 175)
                        Popup.ZIndex = 1 + zi
                        corner(Popup, 8)
                        stroke(Popup, T.ELEMENT2, 1, 0.3)

                        SatHolder.Name = "SatHolder"
                        SatHolder.Parent = Popup
                        SatHolder.BackgroundColor3 = T.ELEMENT
                        SatHolder.BorderSizePixel = 0
                        SatHolder.ClipsDescendants = true
                        SatHolder.Position = UDim2.new(0, 6, 0, 6)
                        SatHolder.Size = UDim2.new(0, 120, 0, 114)
                        SatHolder.ZIndex = 2 + zi
                        corner(SatHolder, 6)

                        SatSurface.Name = "SatSurface"
                        SatSurface.Parent = SatHolder
                        SatSurface.BackgroundColor3 = defaultColor
                        SatSurface.BorderSizePixel = 0
                        SatSurface.Size = UDim2.new(1, 0, 1, 0)
                        SatSurface.Image = "rbxassetid://4805274903"
                        SatSurface.ZIndex = 1 + zi

                        SatMarker.Name = "SatMarker"
                        SatMarker.Parent = SatHolder
                        SatMarker.BackgroundColor3 = T.WHITE
                        SatMarker.BackgroundTransparency = 1
                        SatMarker.Size = UDim2.new(0, 0, 0, 0)
                        SatMarker.Image = "http://www.roblox.com/asset/?id=4805639000"
                        SatMarker.ZIndex = 1 + zi

                        HueHolder.Name = "HueHolder"
                        HueHolder.Parent = Popup
                        HueHolder.BackgroundColor3 = T.ELEMENT
                        HueHolder.BorderSizePixel = 0
                        HueHolder.ClipsDescendants = true
                        HueHolder.Position = UDim2.new(0, 133, 0, 6)
                        HueHolder.Size = UDim2.new(0, 20, 0, 114)
                        HueHolder.ZIndex = 2 + zi
                        corner(HueHolder, 5)

                        HueBar.Name = "HueBar"
                        HueBar.Parent = HueHolder
                        HueBar.BackgroundTransparency = 1
                        HueBar.Size = UDim2.new(1, 0, 1, 0)
                        HueBar.Image = "http://www.roblox.com/asset/?id=4801885250"
                        HueBar.ScaleType = Enum.ScaleType.Crop
                        HueBar.ZIndex = 1 + zi

                        HueMarker.Name = "HueMarker"
                        HueMarker.Parent = HueHolder
                        HueMarker.BackgroundColor3 = T.WHITE
                        HueMarker.BorderSizePixel = 0
                        HueMarker.Position = UDim2.new(0, -2, 0, 0)
                        HueMarker.Size = UDim2.new(1, 4, 0, 3)
                        HueMarker.ZIndex = 2 + zi
                        corner(HueMarker, 2)

                        local function makeRgbLbl(xPos, text)
                            local lbl = Instance.new("TextLabel")
                            lbl.Parent = Popup
                            lbl.BackgroundColor3 = T.ELEMENT
                            lbl.BorderSizePixel = 0
                            lbl.Position = UDim2.new(0, xPos, 0, 127)
                            lbl.Size = UDim2.new(0, 46, 0, 16)
                            lbl.ZIndex = 2 + zi
                            lbl.Font = Enum.Font.GothamBold
                            lbl.TextColor3 = T.TEXT
                            lbl.TextSize = 9
                            lbl.Text = text
                            corner(lbl, 4)
                            return lbl
                        end

                        LabelR = makeRgbLbl(6, "R: 000")
                        LabelG = makeRgbLbl(55, "G: 000")
                        LabelB = makeRgbLbl(104, "B: 000")

                        RainRow.Name = "RainRow"
                        RainRow.Parent = Popup
                        RainRow.BackgroundTransparency = 1
                        RainRow.Position = UDim2.new(0, 6, 0, 149)
                        RainRow.Size = UDim2.new(1, -12, 0, 22)
                        RainRow.ZIndex = 1 + zi

                        RainLbl.Name = "RainLbl"
                        RainLbl.Parent = RainRow
                        RainLbl.BackgroundTransparency = 1
                        RainLbl.Size = UDim2.new(1, -50, 1, 0)
                        RainLbl.Font = Enum.Font.Gotham
                        RainLbl.Text = "Rainbow"
                        RainLbl.TextColor3 = T.TEXT
                        RainLbl.TextSize = 10
                        RainLbl.TextXAlignment = Enum.TextXAlignment.Left
                        RainLbl.ZIndex = 2 + zi

                        RainTrack.Name = "RainTrack"
                        RainTrack.Parent = RainRow
                        RainTrack.BackgroundColor3 = T.TOGGLE_OFF
                        RainTrack.BorderSizePixel = 0
                        RainTrack.AnchorPoint = Vector2.new(1, 0.5)
                        RainTrack.Position = UDim2.new(1, 0, 0.5, 0)
                        RainTrack.Size = UDim2.new(0, 36, 0, 18)
                        RainTrack.ZIndex = 2 + zi
                        corner(RainTrack, 9)

                        RainKnob.Name = "RainKnob"
                        RainKnob.Parent = RainTrack
                        RainKnob.BackgroundColor3 = T.WHITE
                        RainKnob.BorderSizePixel = 0
                        RainKnob.AnchorPoint = Vector2.new(0, 0.5)
                        RainKnob.Position = UDim2.new(0, 2, 0.5, 0)
                        RainKnob.Size = UDim2.new(0, 14, 0, 14)
                        RainKnob.ZIndex = 3 + zi
                        corner(RainKnob, 7)

                        RainHit.Name = "RainHit"
                        RainHit.Parent = RainRow
                        RainHit.BackgroundTransparency = 1
                        RainHit.Size = UDim2.new(1, 0, 1, 0)
                        RainHit.Text = ""
                        RainHit.AutoButtonColor = false
                        RainHit.ZIndex = 4 + zi

                        local function updateRgb()
                            local c = Swatch.BackgroundColor3
                            LabelR.Text = "R: " .. math.floor(c.R * 255)
                            LabelG.Text = "G: " .. math.floor(c.G * 255)
                            LabelB.Text = "B: " .. math.floor(c.B * 255)
                        end

                        local function applyHSV()
                            local c = Color3.fromHSV(HSV.H, HSV.S, HSV.V)
                            Swatch.BackgroundColor3 = c
                            SatSurface.BackgroundColor3 = Color3.fromHSV(HSV.H, 1, 1)
                            callback(c)
                            updateRgb()
                        end

                        updateRgb()

                        local function closePopup()
                            pickerOpen = false
                            tween(Popup, TI_SLOW, { Size = UDim2.new(0, 0, 0, 175) })
                            Body.ClipsDescendants = true
                            SectionFrame.ClipsDescendants = true
                            ItemContainer.ClipsDescendants = true
                        end

                        Swatch.MouseButton1Click:Connect(function()
                            if pickerOpen then
                                closePopup()
                            else
                                pickerOpen = true
                                Body.ClipsDescendants = false
                                SectionFrame.ClipsDescendants = false
                                ItemContainer.ClipsDescendants = false
                                tween(Popup, TI_SLOW, { Size = UDim2.new(0, 159, 0, 175) })
                            end
                        end)

                        SatSurface.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 and not rainbowOn then
                                if satConn then satConn:Disconnect() end
                                satConn = RunService.RenderStepped:Connect(function()
                                    local x = math.clamp((Mouse.X - SatHolder.AbsolutePosition.X) / SatHolder.AbsoluteSize.X, 0, 1)
                                    local y = math.clamp((Mouse.Y - SatHolder.AbsolutePosition.Y) / SatHolder.AbsoluteSize.Y, 0, 1)
                                    SatMarker.Position = UDim2.new(x, 0, y, 0)
                                    HSV.S = x
                                    HSV.V = 1 - y
                                    applyHSV()
                                end)
                            end
                        end)
                        SatSurface.InputEnded:Connect(function(i)
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
                                    tween(HueMarker, TI_FAST, { Position = UDim2.new(0, -2, y, 0) })
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
                                    SatSurface.BackgroundColor3 = c
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
