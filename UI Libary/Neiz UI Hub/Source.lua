-- ╔══════════════════════════════════════════╗
-- ║           Neiz UI Hub  v2.1              ║
-- ║                                          ║
-- ╚══════════════════════════════════════════╝

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local RunService   = game:GetService("RunService")

-- ── Clean up old instance ──
pcall(function()
    if CoreGui:FindFirstChild("NeizHub") then
        CoreGui.NeizHub:Destroy()
    end
end)

-- ══════════════════════════════════════════
--  ROOT GUI
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "NeizHub"
ScreenGui.Parent          = CoreGui
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder    = 999

-- ── Main window ──
local Main = Instance.new("Frame")
Main.Parent             = ScreenGui
Main.Name               = "Main"
Main.Size               = UDim2.new(0, 550, 0, 380)
Main.Position           = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3   = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel    = 0
Main.ClipsDescendants   = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent       = Main
MainStroke.Color        = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.82

-- ══════════════════════════════════════════
--  TITLE BAR
-- ══════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Parent           = Main
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 5

-- thin bottom line on title bar
local TitleLine = Instance.new("Frame")
TitleLine.Parent               = TitleBar
TitleLine.Size                 = UDim2.new(1, 0, 0, 1)
TitleLine.Position             = UDim2.new(0, 0, 1, -1)
TitleLine.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
TitleLine.BackgroundTransparency = 0.87
TitleLine.BorderSizePixel      = 0
TitleLine.ZIndex               = 6

local Title = Instance.new("TextLabel")
Title.Parent              = TitleBar
Title.BackgroundTransparency = 1
Title.Position            = UDim2.new(0, 15, 0, 0)
Title.Size                = UDim2.new(1, -50, 1, 0)
Title.Font                = Enum.Font.Code
Title.Text                = "Neiz UI Hub"
Title.TextColor3          = Color3.fromRGB(255, 255, 255)
Title.TextSize            = 15
Title.TextXAlignment      = Enum.TextXAlignment.Left
Title.ZIndex              = 6

-- Collapse / expand button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent              = TitleBar
ToggleButton.BackgroundTransparency = 1
ToggleButton.Position            = UDim2.new(1, -38, 0.5, -12)
ToggleButton.Size                = UDim2.new(0, 24, 0, 24)
ToggleButton.Text                = ""
ToggleButton.ZIndex              = 7
ToggleButton.AutoButtonColor     = false

local ToggleIcon = Instance.new("ImageLabel")
ToggleIcon.Parent               = ToggleButton
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Image                = "rbxassetid://6031094670"
ToggleIcon.Size                 = UDim2.new(1, 0, 1, 0)
ToggleIcon.ImageColor3          = Color3.fromRGB(200, 200, 200)
ToggleIcon.Rotation             = 90   -- arrow pointing down = "open"
ToggleIcon.ZIndex               = 8

-- ══════════════════════════════════════════
--  TWEEN HELPER
-- ══════════════════════════════════════════
local function Tween(obj, t, props, cb)
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    if cb then
        tw.Completed:Once(cb)
    end
    return tw
end

-- ══════════════════════════════════════════
--  MINIMIZE / EXPAND
-- ══════════════════════════════════════════
local hidden      = false
local toggleBusy  = false

ToggleButton.MouseButton1Click:Connect(function()
    if toggleBusy then return end
    toggleBusy = true
    hidden = not hidden

    Tween(ToggleIcon, 0.4, { Rotation = hidden and 270 or 90 })

    if hidden then
        Tween(Main, 0.45, { Size = UDim2.new(0, 550, 0, 45) }, function()
            toggleBusy = false
        end)
    else
        Tween(Main, 0.45, { Size = UDim2.new(0, 550, 0, 380) }, function()
            toggleBusy = false
        end)
    end
end)

-- ══════════════════════════════════════════
--  DRAGGABLE (title bar only)
-- ══════════════════════════════════════════
local dragging, dragStart, startPos = false, nil, nil

TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        -- don't drag when clicking the toggle button
        if ToggleButton:IsAncestorOf(inp) then return end
        dragging  = true
        dragStart = inp.Position
        startPos  = Main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(inp)
    if dragging and (
        inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = inp.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ══════════════════════════════════════════
--  TAB BAR  (left sidebar)
-- ══════════════════════════════════════════
local TabBar = Instance.new("Frame")
TabBar.Parent           = Main
TabBar.Name             = "TabBar"
TabBar.Position         = UDim2.new(0, 0, 0, 46)
TabBar.Size             = UDim2.new(0, 148, 1, -56)
TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
TabBar.BorderSizePixel  = 0

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Parent                = TabBar
TabScroll.BackgroundTransparency = 1
TabScroll.Size                  = UDim2.new(1, 0, 1, 0)
TabScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
TabScroll.ScrollBarThickness    = 3
TabScroll.ScrollBarImageColor3  = Color3.fromRGB(70, 70, 70)
TabScroll.BorderSizePixel       = 0
TabScroll.BottomImage           = ""
TabScroll.TopImage              = ""

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent  = TabScroll
TabLayout.Padding = UDim.new(0, 4)

local TabPad = Instance.new("UIPadding")
TabPad.Parent        = TabScroll
TabPad.PaddingLeft   = UDim.new(0, 8)
TabPad.PaddingRight  = UDim.new(0, 8)
TabPad.PaddingTop    = UDim.new(0, 8)
TabPad.PaddingBottom = UDim.new(0, 8)

-- divider line between tab bar and pages
local Divider = Instance.new("Frame")
Divider.Parent               = Main
Divider.Position             = UDim2.new(0, 148, 0, 46)
Divider.Size                 = UDim2.new(0, 1, 1, -56)
Divider.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
Divider.BackgroundTransparency = 0.87
Divider.BorderSizePixel      = 0

-- ══════════════════════════════════════════
--  PAGES CONTAINER
-- ══════════════════════════════════════════
local PagesFrame = Instance.new("Frame")
PagesFrame.Parent           = Main
PagesFrame.Name             = "Pages"
PagesFrame.Position         = UDim2.new(0, 149, 0, 46)
PagesFrame.Size             = UDim2.new(1, -149, 1, -56)
PagesFrame.BackgroundTransparency = 1
PagesFrame.BorderSizePixel  = 0
PagesFrame.ClipsDescendants = true

-- ── Bottom accent bar ──
local BottomBar = Instance.new("Frame")
BottomBar.Parent           = Main
BottomBar.Position         = UDim2.new(0, 0, 1, -10)
BottomBar.Size             = UDim2.new(1, 0, 0, 10)
BottomBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
BottomBar.BorderSizePixel  = 0

local BottomLine = Instance.new("Frame")
BottomLine.Parent               = BottomBar
BottomLine.Size                 = UDim2.new(1, 0, 0, 1)
BottomLine.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
BottomLine.BackgroundTransparency = 0.87
BottomLine.BorderSizePixel      = 0

-- ══════════════════════════════════════════
--  TAB / PAGE STATE
-- ══════════════════════════════════════════
local selectedTab = nil
local pageBusy    = false
local tabCount    = 0

local function UpdateTabCanvas()
    task.wait()
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 16)
end

local function SelectTab(btn)
    if pageBusy then return end
    if selectedTab == btn.Name then return end
    pageBusy = true

    -- deselect all others
    for _, v in pairs(TabScroll:GetChildren()) do
        if v:IsA("TextButton") and v ~= btn then
            Tween(v, 0.2, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) })
            Tween(v, 0.2, { TextColor3 = Color3.fromRGB(140, 140, 140) })
            local pg = PagesFrame:FindFirstChild(v.Name)
            if pg then Tween(pg, 0.3, { Position = UDim2.new(1, 0, 0, 0) }) end
        end
    end

    task.wait(0.08)

    -- select clicked tab
    Tween(btn, 0.2, { BackgroundColor3 = Color3.fromRGB(42, 90, 190) })
    Tween(btn, 0.2, { TextColor3 = Color3.fromRGB(255, 255, 255) })
    local pg = PagesFrame:FindFirstChild(btn.Name)
    if pg then Tween(pg, 0.3, { Position = UDim2.new(0, 0, 0, 0) }) end

    selectedTab = btn.Name
    pageBusy    = false
end

-- ══════════════════════════════════════════
--  _G.AddTab  — PUBLIC API
-- ══════════════════════════════════════════
function _G.AddTab(tabName)
    tabCount += 1
    local comp = {}

    -- ── Tab button ──
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent              = TabScroll
    TabBtn.Name                = tabName
    TabBtn.Size                = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3    = Color3.fromRGB(20, 20, 20)
    TabBtn.BorderSizePixel     = 0
    TabBtn.Font                = Enum.Font.Code
    TabBtn.Text                = tabName
    TabBtn.TextColor3          = Color3.fromRGB(140, 140, 140)
    TabBtn.TextSize            = 12
    TabBtn.AutoButtonColor     = false

    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 7)

    TabBtn.MouseEnter:Connect(function()
        if selectedTab ~= tabName then
            Tween(TabBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(27, 27, 27) })
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if selectedTab ~= tabName then
            Tween(TabBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) })
        end
    end)
    TabBtn.MouseButton1Click:Connect(function()
        coroutine.wrap(SelectTab)(TabBtn)
    end)

    UpdateTabCanvas()

    -- ── Page (scrolling frame) ──
    local Page = Instance.new("ScrollingFrame")
    Page.Parent                = PagesFrame
    Page.Name                  = tabName
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel       = 0
    Page.Size                  = UDim2.new(1, 0, 1, 0)
    Page.Position              = UDim2.new(1, 0, 0, 0)  -- offscreen right
    Page.CanvasSize            = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness    = 3
    Page.ScrollBarImageColor3  = Color3.fromRGB(70, 70, 70)
    Page.BottomImage           = ""
    Page.TopImage              = ""

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent  = Page
    PageLayout.Padding = UDim.new(0, 6)

    local PagePad = Instance.new("UIPadding")
    PagePad.Parent        = Page
    PagePad.PaddingLeft   = UDim.new(0, 12)
    PagePad.PaddingRight  = UDim.new(0, 12)
    PagePad.PaddingTop    = UDim.new(0, 10)
    PagePad.PaddingBottom = UDim.new(0, 10)

    local function UpdatePageCanvas()
        task.wait()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end

    -- auto-select first tab
    if tabCount == 1 then
        coroutine.wrap(SelectTab)(TabBtn)
    end

    -- ────────────────────────────────────────
    --  comp:AddSection
    -- ────────────────────────────────────────
    function comp:AddSection(args)
        local Lbl = Instance.new("TextLabel")
        Lbl.Parent               = Page
        Lbl.Size                 = UDim2.new(1, 0, 0, 22)
        Lbl.BackgroundTransparency = 1
        Lbl.Font                 = Enum.Font.Code
        Lbl.Text                 = (args.Text or "Section"):upper()
        Lbl.TextColor3           = Color3.fromRGB(70, 70, 70)
        Lbl.TextSize             = 10
        Lbl.TextXAlignment       = Enum.TextXAlignment.Left
        UpdatePageCanvas()
    end

    -- ────────────────────────────────────────
    --  comp:AddButton  (Fluxus style)
    -- ────────────────────────────────────────
    function comp:AddButton(args)
        local Holder = Instance.new("Frame")
        Holder.Parent           = Page
        Holder.Size             = UDim2.new(1, 0, 0, 32)
        Holder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Holder.BorderSizePixel  = 0
        Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 7)

        -- Fluxus-style left accent line
        local Accent = Instance.new("Frame")
        Accent.Parent           = Holder
        Accent.Size             = UDim2.new(0, 3, 0, 16)
        Accent.Position         = UDim2.new(0, 0, 0.5, -8)
        Accent.BackgroundColor3 = Color3.fromRGB(60, 110, 220)
        Accent.BorderSizePixel  = 0
        Instance.new("UICorner", Accent).CornerRadius = UDim.new(1, 0)

        local HStroke = Instance.new("UIStroke")
        HStroke.Parent       = Holder
        HStroke.Color        = Color3.fromRGB(38, 38, 38)
        HStroke.Transparency = 0

        local Btn = Instance.new("TextButton")
        Btn.Parent               = Holder
        Btn.Size                 = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundTransparency = 1
        Btn.Font                 = Enum.Font.Code
        Btn.Text                 = args.Text or "Button"
        Btn.TextColor3           = Color3.fromRGB(215, 215, 215)
        Btn.TextSize             = 13
        Btn.AutoButtonColor      = false

        Btn.MouseEnter:Connect(function()
            Tween(Holder,  0.15, { BackgroundColor3 = Color3.fromRGB(28, 28, 28) })
            Tween(HStroke, 0.15, { Color = Color3.fromRGB(60, 110, 220), Transparency = 0.5 })
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Holder,  0.15, { BackgroundColor3 = Color3.fromRGB(22, 22, 22) })
            Tween(HStroke, 0.15, { Color = Color3.fromRGB(38, 38, 38), Transparency = 0 })
        end)
        Btn.MouseButton1Down:Connect(function()
            Tween(Holder, 0.08, { BackgroundColor3 = Color3.fromRGB(35, 70, 160) })
        end)
        Btn.MouseButton1Up:Connect(function()
            Tween(Holder, 0.12, { BackgroundColor3 = Color3.fromRGB(22, 22, 22) })
        end)
        Btn.MouseButton1Click:Connect(function()
            pcall(function()
                if args.Callback then args.Callback() end
            end)
        end)

        UpdatePageCanvas()
    end

    -- ────────────────────────────────────────
    --  comp:AddToggle
    -- ────────────────────────────────────────
    function comp:AddToggle(args)
        local enabled  = args.Default or false
        local debounce = false

        local Holder = Instance.new("Frame")
        Holder.Parent           = Page
        Holder.Size             = UDim2.new(1, 0, 0, 36)
        Holder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Holder.BorderSizePixel  = 0
        Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 7)

        local HStroke = Instance.new("UIStroke")
        HStroke.Parent = Holder
        HStroke.Color  = Color3.fromRGB(38, 38, 38)

        local Lbl = Instance.new("TextLabel")
        Lbl.Parent               = Holder
        Lbl.BackgroundTransparency = 1
        Lbl.Position             = UDim2.new(0, 12, 0, 0)
        Lbl.Size                 = UDim2.new(1, -65, 1, 0)
        Lbl.Font                 = Enum.Font.Code
        Lbl.Text                 = args.Text or "Toggle"
        Lbl.TextColor3           = Color3.fromRGB(210, 210, 210)
        Lbl.TextSize             = 13
        Lbl.TextXAlignment       = Enum.TextXAlignment.Left

        local Track = Instance.new("Frame")
        Track.Parent           = Holder
        Track.Size             = UDim2.new(0, 40, 0, 20)
        Track.Position         = UDim2.new(1, -50, 0.5, -10)
        Track.BackgroundColor3 = enabled and Color3.fromRGB(55, 160, 85) or Color3.fromRGB(40, 40, 40)
        Track.BorderSizePixel  = 0
        Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Parent           = Track
        Circle.Size             = UDim2.new(0, 16, 0, 16)
        Circle.Position         = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BorderSizePixel  = 0
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local function Refresh()
            Tween(Track,  0.2,  { BackgroundColor3 = enabled and Color3.fromRGB(55, 160, 85) or Color3.fromRGB(40, 40, 40) })
            Tween(Circle, 0.25, { Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) })
        end

        Holder.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                if debounce then return end
                debounce = true
                enabled  = not enabled
                Refresh()
                pcall(function() if args.Callback then args.Callback(enabled) end end)
                task.wait(args.Delay or 0.2)
                debounce = false
            end
        end)

        Holder.MouseEnter:Connect(function()
            Tween(HStroke, 0.15, { Color = Color3.fromRGB(65, 65, 65) })
        end)
        Holder.MouseLeave:Connect(function()
            Tween(HStroke, 0.15, { Color = Color3.fromRGB(38, 38, 38) })
        end)

        UpdatePageCanvas()

        -- Return controller so caller can set value programmatically
        local ctrl = {}
        function ctrl:Set(val)
            enabled = val
            Refresh()
            pcall(function() if args.Callback then args.Callback(enabled) end end)
        end
        function ctrl:Get() return enabled end
        return ctrl
    end

    -- ────────────────────────────────────────
    --  comp:AddTextbox  (Fluxus style)
    -- ────────────────────────────────────────
    function comp:AddTextbox(args)
        local Outer = Instance.new("Frame")
        Outer.Parent               = Page
        Outer.Size                 = UDim2.new(1, 0, 0, 54)
        Outer.BackgroundTransparency = 1
        Outer.BorderSizePixel      = 0

        local Lbl = Instance.new("TextLabel")
        Lbl.Parent               = Outer
        Lbl.BackgroundTransparency = 1
        Lbl.Size                 = UDim2.new(1, 0, 0, 16)
        Lbl.Font                 = Enum.Font.Code
        Lbl.Text                 = args.Text or "Textbox"
        Lbl.TextColor3           = Color3.fromRGB(110, 110, 110)
        Lbl.TextSize             = 11
        Lbl.TextXAlignment       = Enum.TextXAlignment.Left

        local BoxHolder = Instance.new("Frame")
        BoxHolder.Parent           = Outer
        BoxHolder.Size             = UDim2.new(1, 0, 0, 30)
        BoxHolder.Position         = UDim2.new(0, 0, 0, 20)
        BoxHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        BoxHolder.BorderSizePixel  = 0
        Instance.new("UICorner", BoxHolder).CornerRadius = UDim.new(0, 7)

        local BoxStroke = Instance.new("UIStroke")
        BoxStroke.Parent = BoxHolder
        BoxStroke.Color  = Color3.fromRGB(40, 40, 40)

        local Box = Instance.new("TextBox")
        Box.Parent               = BoxHolder
        Box.BackgroundTransparency = 1
        Box.Size                 = UDim2.new(1, -16, 1, 0)
        Box.Position             = UDim2.new(0, 10, 0, 0)
        Box.PlaceholderText      = args.Placeholder or "Type here..."
        Box.PlaceholderColor3    = Color3.fromRGB(65, 65, 65)
        Box.Font                 = Enum.Font.Code
        Box.TextColor3           = Color3.fromRGB(220, 220, 220)
        Box.TextSize             = 12
        Box.ClearTextOnFocus     = args.ClearOnFocus or false
        Box.BorderSizePixel      = 0
        Box.TextXAlignment       = Enum.TextXAlignment.Left

        Box.Focused:Connect(function()
            Tween(BoxStroke, 0.2, { Color = Color3.fromRGB(60, 110, 220), Transparency = 0.2 })
            Tween(BoxHolder, 0.2, { BackgroundColor3 = Color3.fromRGB(24, 24, 24) })
        end)
        Box.FocusLost:Connect(function(enter)
            Tween(BoxStroke, 0.2, { Color = Color3.fromRGB(40, 40, 40), Transparency = 0 })
            Tween(BoxHolder, 0.2, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) })
            pcall(function()
                if args.Callback then args.Callback(Box.Text, enter) end
            end)
        end)

        UpdatePageCanvas()

        local ctrl = {}
        function ctrl:Get() return Box.Text end
        function ctrl:Set(val) Box.Text = tostring(val) end
        return ctrl
    end

    -- ────────────────────────────────────────
    --  comp:AddDropdown
    -- ────────────────────────────────────────
    function comp:AddDropdown(args)
        local ee       = {}
        local items    = args.List or {}
        local selected = args.Default or ""
        local isOpen   = false

        local ITEM_H   = 28
        local MAX_SHOW = 4

        local Holder = Instance.new("Frame")
        Holder.Parent           = Page
        Holder.Size             = UDim2.new(1, 0, 0, 32)
        Holder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Holder.BorderSizePixel  = 0
        Holder.ClipsDescendants = true
        Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 7)

        local HStroke = Instance.new("UIStroke")
        HStroke.Parent = Holder
        HStroke.Color  = Color3.fromRGB(38, 38, 38)

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Parent               = Holder
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Position             = UDim2.new(0, 12, 0, 0)
        TitleLbl.Size                 = UDim2.new(0.5, 0, 0, 32)
        TitleLbl.Font                 = Enum.Font.Code
        TitleLbl.Text                 = args.Text or "Dropdown"
        TitleLbl.TextColor3           = Color3.fromRGB(140, 140, 140)
        TitleLbl.TextSize             = 12
        TitleLbl.TextXAlignment       = Enum.TextXAlignment.Left

        local SelLbl = Instance.new("TextLabel")
        SelLbl.Parent               = Holder
        SelLbl.BackgroundTransparency = 1
        SelLbl.Position             = UDim2.new(0.5, 0, 0, 0)
        SelLbl.Size                 = UDim2.new(0.5, -38, 0, 32)
        SelLbl.Font                 = Enum.Font.Code
        SelLbl.Text                 = selected
        SelLbl.TextColor3           = Color3.fromRGB(220, 220, 220)
        SelLbl.TextSize             = 12
        SelLbl.TextXAlignment       = Enum.TextXAlignment.Right

        local ArrowBtn = Instance.new("TextButton")
        ArrowBtn.Parent               = Holder
        ArrowBtn.BackgroundTransparency = 1
        ArrowBtn.Position             = UDim2.new(1, -28, 0.5, -10)
        ArrowBtn.Size                 = UDim2.new(0, 20, 0, 20)
        ArrowBtn.Font                 = Enum.Font.Code
        ArrowBtn.Text                 = "▾"
        ArrowBtn.TextColor3           = Color3.fromRGB(110, 110, 110)
        ArrowBtn.TextSize             = 14
        ArrowBtn.AutoButtonColor      = false

        -- item list container
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Parent                = Holder
        Scroll.Position              = UDim2.new(0, 6, 0, 36)
        Scroll.Size                  = UDim2.new(1, -12, 1, -40)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel       = 0
        Scroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
        Scroll.ScrollBarThickness    = 3
        Scroll.ScrollBarImageColor3  = Color3.fromRGB(70, 70, 70)
        Scroll.BottomImage           = ""
        Scroll.TopImage              = ""

        local SLayout = Instance.new("UIListLayout")
        SLayout.Parent  = Scroll
        SLayout.Padding = UDim.new(0, 3)

        local function BuildItems(list)
            for _, c in pairs(Scroll:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

            for _, v in pairs(list) do
                local Opt = Instance.new("TextButton")
                Opt.Parent           = Scroll
                Opt.Size             = UDim2.new(1, 0, 0, ITEM_H)
                Opt.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                Opt.BorderSizePixel  = 0
                Opt.Font             = Enum.Font.Code
                Opt.Text             = tostring(v)
                Opt.TextColor3       = tostring(v) == selected
                    and Color3.fromRGB(255, 255, 255)
                    or  Color3.fromRGB(160, 160, 160)
                Opt.TextSize         = 12
                Opt.AutoButtonColor  = false
                Instance.new("UICorner", Opt).CornerRadius = UDim.new(0, 5)

                Opt.MouseEnter:Connect(function()
                    Tween(Opt, 0.12, { BackgroundColor3 = Color3.fromRGB(38, 38, 38) })
                end)
                Opt.MouseLeave:Connect(function()
                    Tween(Opt, 0.12, { BackgroundColor3 = Color3.fromRGB(28, 28, 28) })
                end)
                Opt.MouseButton1Click:Connect(function()
                    selected     = tostring(v)
                    SelLbl.Text  = selected
                    -- update text colors
                    for _, c2 in pairs(Scroll:GetChildren()) do
                        if c2:IsA("TextButton") then
                            c2.TextColor3 = c2.Text == selected
                                and Color3.fromRGB(255, 255, 255)
                                or  Color3.fromRGB(160, 160, 160)
                        end
                    end
                    pcall(function() if args.Callback then args.Callback(selected) end end)
                end)

                Scroll.CanvasSize = UDim2.new(0, 0, 0, SLayout.AbsoluteContentSize.Y + 6)
            end
        end

        BuildItems(items)

        local function ToggleOpen()
            isOpen = not isOpen
            local openH = 32 + math.min(#items, MAX_SHOW) * (ITEM_H + 3) + 10
            Tween(Holder,   0.3, { Size = isOpen and UDim2.new(1, 0, 0, openH) or UDim2.new(1, 0, 0, 32) })
            Tween(ArrowBtn, 0.3, { Rotation = isOpen and 180 or 0 })
            Holder.Changed:Connect(function(p)
                if p == "Size" then UpdatePageCanvas() end
            end)
        end

        ArrowBtn.MouseButton1Click:Connect(ToggleOpen)
        TitleLbl.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then ToggleOpen() end
        end)
        SelLbl.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then ToggleOpen() end
        end)

        function ee:Update(newList)
            items = newList
            BuildItems(newList)
            if isOpen then
                local openH = 32 + math.min(#items, MAX_SHOW) * (ITEM_H + 3) + 10
                Holder.Size = UDim2.new(1, 0, 0, openH)
                UpdatePageCanvas()
            end
        end
        function ee:Get() return selected end

        UpdatePageCanvas()
        return ee
    end

    -- ────────────────────────────────────────
    --  comp:AddSlider
    -- ────────────────────────────────────────
    function comp:AddSlider(args)
        local Min     = args.Min     or 0
        local Max     = args.Max     or 100
        local Default = args.Default or Min

        local Outer = Instance.new("Frame")
        Outer.Parent               = Page
        Outer.Size                 = UDim2.new(1, 0, 0, 50)
        Outer.BackgroundTransparency = 1

        local Top = Instance.new("Frame")
        Top.Parent               = Outer
        Top.Size                 = UDim2.new(1, 0, 0, 18)
        Top.BackgroundTransparency = 1

        local Lbl = Instance.new("TextLabel")
        Lbl.Parent               = Top
        Lbl.BackgroundTransparency = 1
        Lbl.Size                 = UDim2.new(1, -50, 1, 0)
        Lbl.Font                 = Enum.Font.Code
        Lbl.Text                 = args.Text or "Slider"
        Lbl.TextColor3           = Color3.fromRGB(150, 150, 150)
        Lbl.TextSize             = 12
        Lbl.TextXAlignment       = Enum.TextXAlignment.Left

        local ValLbl = Instance.new("TextLabel")
        ValLbl.Parent               = Top
        ValLbl.BackgroundTransparency = 1
        ValLbl.Position             = UDim2.new(1, -46, 0, 0)
        ValLbl.Size                 = UDim2.new(0, 46, 1, 0)
        ValLbl.Font                 = Enum.Font.Code
        ValLbl.Text                 = tostring(Default)
        ValLbl.TextColor3           = Color3.fromRGB(60, 110, 220)
        ValLbl.TextSize             = 12
        ValLbl.TextXAlignment       = Enum.TextXAlignment.Right

        local Bar = Instance.new("Frame")
        Bar.Parent           = Outer
        Bar.Position         = UDim2.new(0, 0, 0, 30)
        Bar.Size             = UDim2.new(1, 0, 0, 8)
        Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Bar.BorderSizePixel  = 0
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame")
        Fill.Parent           = Bar
        Fill.Size             = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(60, 110, 220)
        Fill.BorderSizePixel  = 0
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local Knob = Instance.new("Frame")
        Knob.Parent           = Bar
        Knob.Size             = UDim2.new(0, 14, 0, 14)
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Knob.BorderSizePixel  = 0
        Knob.ZIndex           = 5
        Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

        local currentVal = Default

        local function SetValue(pct)
            pct        = math.clamp(pct, 0, 1)
            currentVal = math.floor((Max - Min) * pct + Min)
            Fill.Size      = UDim2.new(pct, 0, 1, 0)
            Knob.Position  = UDim2.new(pct, -7, 0.5, -7)
            ValLbl.Text    = tostring(currentVal)
            pcall(function() if args.Callback then args.Callback(currentVal) end end)
        end

        SetValue((Default - Min) / (Max - Min))

        local sliding = false

        Bar.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                Tween(Knob, 0.1, { Size = UDim2.new(0, 16, 0, 16) })
                -- update immediately on click
                local pct = (inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X
                SetValue(pct)
            end
        end)

        UIS.InputEnded:Connect(function(inp)
            if sliding and (
                inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch
            ) then
                sliding = false
                Tween(Knob, 0.1, { Size = UDim2.new(0, 14, 0, 14) })
            end
        end)

        UIS.InputChanged:Connect(function(inp)
            if sliding and (
                inp.UserInputType == Enum.UserInputType.MouseMovement
                or inp.UserInputType == Enum.UserInputType.Touch
            ) then
                local pct = (inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X
                SetValue(pct)
            end
        end)

        UpdatePageCanvas()

        local ctrl = {}
        function ctrl:Set(val)
            SetValue((val - Min) / (Max - Min))
        end
        function ctrl:Get() return currentVal end
        return ctrl
    end

    -- ────────────────────────────────────────
    --  comp:AddLabel
    -- ────────────────────────────────────────
    function comp:AddLabel(args)
        local Lbl = Instance.new("TextLabel")
        Lbl.Parent               = Page
        Lbl.Size                 = UDim2.new(1, 0, 0, 24)
        Lbl.BackgroundColor3     = Color3.fromRGB(18, 18, 18)
        Lbl.BorderSizePixel      = 0
        Lbl.Font                 = Enum.Font.Code
        Lbl.Text                 = args.Text or "Label"
        Lbl.TextColor3           = Color3.fromRGB(160, 160, 160)
        Lbl.TextSize             = 12
        Lbl.TextXAlignment       = Enum.TextXAlignment.Left
        Instance.new("UICorner", Lbl).CornerRadius = UDim.new(0, 6)

        local LP = Instance.new("UIPadding")
        LP.Parent      = Lbl
        LP.PaddingLeft = UDim.new(0, 10)

        UpdatePageCanvas()

        local ctrl = {}
        function ctrl:Set(val) Lbl.Text = tostring(val) end
        function ctrl:Get() return Lbl.Text end
        return ctrl
    end

    return comp
end

-- ══════════════════════════════════════════
--  GLOBAL HELPERS
-- ══════════════════════════════════════════
function _G.SetTitle(text)
    Title.Text = tostring(text)
end

-- RightControl toggles visibility
UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

return ScreenGui
