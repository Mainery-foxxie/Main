-- FluxHub 
local lib = {};
local UIS = game:GetService("UserInputService");
local TS = game:GetService("TweenService");
local RS = game:GetService("RunService");
local LP = game:GetService("Players").LocalPlayer;
local Mouse = LP:GetMouse();
local TextService = game:GetService("TextService")

local GUI = Instance.new("ScreenGui");
GUI.Name = "FluxHub";
GUI.Parent = game.CoreGui;
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
GUI.IgnoreGuiInset = true

local C = {
    BG      = Color3.fromRGB(15, 16, 20),
    SURFACE = Color3.fromRGB(20, 22, 28),
    PANEL   = Color3.fromRGB(25, 27, 34),
    ITEM    = Color3.fromRGB(30, 32, 40),
    BORDER  = Color3.fromRGB(45, 48, 60),
    TEXT    = Color3.fromRGB(220, 222, 230),
    SUBTEXT = Color3.fromRGB(120, 123, 140),
    WHITE   = Color3.new(1, 1, 1),
}

function Create(instance, properties, children)
    local obj = Instance.new(instance)
    for i, v in pairs(properties or {}) do
        obj[i] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

function tween(instance, time, properties, callback)
    callback = callback or function() end
    local tw = TS:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    tw:Play()
    tw.Completed:Connect(callback)
end

function lib:CreateWindow(title)
    local window = {
        Font = Enum.Font.GothamMedium,
        AccentColor = Color3.fromRGB(255, 75, 75)
    }
    local hidden = false

    -- Tooltip
    local ToolTip = Create("Frame", {
        BackgroundColor3 = C.PANEL,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Parent = GUI,
        ZIndex = 99,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 9),
            PaddingRight = UDim.new(0, 9),
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4)
        }),
        Create("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = C.BORDER,
            Transparency = 1
        }),
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextColor3 = C.TEXT,
            TextTransparency = 1,
            Text = "",
            ZIndex = 99,
        })
    })

    coroutine.wrap(function()
        RS.RenderStepped:Connect(function()
            ToolTip.Position = UDim2.new(0, UIS:GetMouseLocation().X + 14, 0, UIS:GetMouseLocation().Y + 22)
        end)
    end)()

    function showTooltip(text)
        if type(text) ~= "string" or text == "" then return end
        ToolTip.Label.Text = text
        tween(ToolTip, 0.2, { BackgroundTransparency = 0.05 })
        tween(ToolTip.UIStroke, 0.2, { Transparency = 0.5 })
        tween(ToolTip.Label, 0.2, { TextTransparency = 0 })
    end

    function hideTooltip()
        tween(ToolTip, 0.2, { BackgroundTransparency = 1 })
        tween(ToolTip.UIStroke, 0.2, { Transparency = 1 })
        tween(ToolTip.Label, 0.2, { TextTransparency = 1 })
    end

    -- Main frame
    local MainFrame = Create("Frame", {
        BackgroundColor3 = C.BG,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 620, 0, 360),
        Position = UDim2.new(0.5, -310, 0.5, -180),
        Parent = GUI,
        ClipsDescendants = true,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Create("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = C.BORDER,
            Transparency = 0.5,
            Thickness = 1
        })
    })

    -- Titlebar
    local TitleBar = Create("Frame", {
        BackgroundColor3 = C.SURFACE,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        Parent = MainFrame,
        ZIndex = 2
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 8) })
    })

    -- Accent underline
    Create("Frame", {
        BackgroundColor3 = window.AccentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        Parent = TitleBar,
        ZIndex = 3
    })

    -- Logo dot
    Create("Frame", {
        BackgroundColor3 = window.AccentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0, 13, 0.5, -4),
        Parent = TitleBar,
        ZIndex = 3
    }, {
        Create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })

    -- Title text
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        Text = title,
        Font = Enum.Font.GothamBold,
        TextColor3 = C.TEXT,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar,
        ZIndex = 3
    })

    -- Minimize button
    local MinBtn = Create("TextButton", {
        BackgroundColor3 = C.ITEM,
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -30, 0.5, -11),
        Text = "",
        AutoButtonColor = false,
        Parent = TitleBar,
        ZIndex = 3
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
        Create("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = C.BORDER,
            Transparency = 0.4
        }),
        Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(0.5, -6, 0.5, -6),
            Image = "rbxassetid://6031094670",
            ImageColor3 = C.SUBTEXT,
            Rotation = 90,
            ZIndex = 4
        })
    })

    -- Drag
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- Minimize logic
    local toggleDebounce = false
    MinBtn.MouseButton1Click:Connect(function()
        if toggleDebounce then return end
        toggleDebounce = true
        hidden = not hidden
        tween(MinBtn.Icon, 0.35, { Rotation = hidden and 270 or 90 })
        if hidden then
            tween(MainFrame, 0.35, { Size = UDim2.new(0, 620, 0, 36) }, function() toggleDebounce = false end)
        else
            tween(MainFrame, 0.35, { Size = UDim2.new(0, 620, 0, 360) }, function() toggleDebounce = false end)
        end
    end)
    MinBtn.MouseEnter:Connect(function()
        tween(MinBtn, 0.15, { BackgroundColor3 = C.BORDER })
        tween(MinBtn.Icon, 0.15, { ImageColor3 = C.TEXT })
    end)
    MinBtn.MouseLeave:Connect(function()
        tween(MinBtn, 0.15, { BackgroundColor3 = C.ITEM })
        tween(MinBtn.Icon, 0.15, { ImageColor3 = C.SUBTEXT })
    end)

    -- Content area
    local Container = Create("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 38),
        Size = UDim2.new(1, 0, 1, -38),
        ClipsDescendants = true,
        Parent = MainFrame
    })

    -- Sidebar
    local Sidebar = Create("Frame", {
        BackgroundColor3 = C.SURFACE,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 140, 1, 0),
        Parent = Container
    })
    Create("Frame", {
        BackgroundColor3 = C.BORDER,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundTransparency = 0.5,
        Parent = Sidebar
    })

    local Menu = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
        ScrollBarImageColor3 = C.BORDER,
        BottomImage = "",
        TopImage = "",
        BorderSizePixel = 0,
        Parent = Sidebar
    }, {
        Create("UIListLayout", {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6)
        })
    })

    local Pages = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 141, 0, 0),
        Size = UDim2.new(1, -141, 1, 0),
        ZIndex = 5,
        Parent = Container
    })

    local selectedPage = nil
    local pagedebounce = false
    local MenuCount = 0

    local function selectTab(btn)
        if pagedebounce then return end
        pagedebounce = true
        for _, v in pairs(Menu:GetChildren()) do
            if v:IsA("TextButton") and v ~= btn then
                tween(v, 0.2, { BackgroundTransparency = 1 })
                tween(v.Label, 0.2, { TextColor3 = C.SUBTEXT })
                tween(v.Accent, 0.2, { BackgroundTransparency = 1 })
                tween(Pages[v.Name], 0.25, { Position = UDim2.new(0, 0, 1, 10) })
            end
        end
        if selectedPage ~= nil then task.wait(0.12) end
        tween(btn, 0.2, { BackgroundTransparency = 0.88 })
        tween(btn.Label, 0.2, { TextColor3 = C.WHITE })
        tween(btn.Accent, 0.2, { BackgroundTransparency = 0 })
        tween(Pages[btn.Name], 0.25, { Position = UDim2.new(0, 0, 0, 0) })
        selectedPage = btn.Name
        pagedebounce = false
    end

    function sizeTab(tab)
        local size = 0
        for _, v in pairs(tab:GetChildren()) do
            if v:IsA("Frame") then
                size = size + v.Size.Y.Offset + 6
            end
        end
        return size
    end

    function window:NewTab(tabTitle)
        local comp1 = {}

        local button = Create("TextButton", {
            BackgroundColor3 = window.AccentColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Text = "",
            Name = tabTitle,
            LayoutOrder = MenuCount,
            AutoButtonColor = false,
            Parent = Menu,
            ZIndex = 2
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
            Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = tabTitle,
                TextColor3 = C.SUBTEXT,
                TextSize = 13,
                ZIndex = 3
            }),
            Create("Frame", {
                Name = "Accent",
                BackgroundColor3 = window.AccentColor,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 3, 0.55, 0),
                Position = UDim2.new(0, 0, 0.225, 0),
                ZIndex = 3
            }, {
                Create("UICorner", { CornerRadius = UDim.new(1, 0) })
            })
        })

        button.MouseButton1Click:Connect(function()
            coroutine.wrap(selectTab)(button)
        end)
        button.MouseEnter:Connect(function()
            if selectedPage ~= tabTitle then
                tween(button.Label, 0.15, { TextColor3 = C.TEXT })
            end
        end)
        button.MouseLeave:Connect(function()
            if selectedPage ~= tabTitle then
                tween(button.Label, 0.15, { TextColor3 = C.SUBTEXT })
            end
        end)

        Menu.CanvasSize = UDim2.new(0, 0, 0, Menu.CanvasSize.Y.Offset + 32)

        local page = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarImageColor3 = C.BORDER,
            BottomImage = "",
            TopImage = "",
            ScrollBarThickness = 3,
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
            Name = tabTitle,
            Parent = Pages,
            Position = UDim2.new(0, 0, 1, 10)
        }, {
            Create("UIListLayout", { Padding = UDim.new(0, 6) }),
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8)
            })
        })

        MenuCount = MenuCount + 1
        if MenuCount == 1 then
            coroutine.wrap(selectTab)(button)
        end

        function comp1:AddSection(secTitle)
            local components = {}
            local secCollapsed = false
            local order = 0

            local bg = Create("Frame", {
                BackgroundColor3 = C.PANEL,
                Size = UDim2.new(1, 0, 0, 28),
                ClipsDescendants = true,
                Parent = page
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Create("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = C.BORDER,
                    Transparency = 0.5
                })
            })

            local secHeader = Create("Frame", {
                BackgroundColor3 = C.SURFACE,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 28),
                Parent = bg,
                ZIndex = 2
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 6) })
            })

            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = secTitle,
                TextColor3 = C.TEXT,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = secHeader,
                ZIndex = 3
            })

            local secTog = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 28, 0, 28),
                Position = UDim2.new(1, -28, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Parent = secHeader,
                ZIndex = 3
            }, {
                Create("ImageLabel", {
                    Name = "Icon",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 11, 0, 11),
                    Position = UDim2.new(0.5, -5, 0.5, -5),
                    Image = "rbxassetid://6031094670",
                    ImageColor3 = C.SUBTEXT,
                    Rotation = 90,
                    ZIndex = 4
                })
            })

            local container = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 6, 0, 32),
                Size = UDim2.new(1, -12, 0, 0),
                Parent = bg
            }, {
                Create("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            })

            local function sectionSize(section)
                local size = 0
                for _, v in pairs(section:FindFirstChildOfClass("Frame"):GetChildren()) do
                    if not v:IsA("UIListLayout") then
                        size = size + (v.Size.Y.Offset + 4)
                    end
                end
                return size
            end

            local function refreshSize()
                local s = sectionSize(bg)
                container.Size = UDim2.new(1, -12, 0, s)
                bg.Size = UDim2.new(1, 0, 0, s + 36)
            end

            secTog.MouseButton1Click:Connect(function()
                secCollapsed = not secCollapsed
                tween(secTog.Icon, 0.3, { Rotation = secCollapsed and 270 or 90 })
                if secCollapsed then
                    tween(bg, 0.3, { Size = UDim2.new(1, 0, 0, 28) })
                else
                    tween(bg, 0.3, { Size = UDim2.new(1, 0, 0, sectionSize(bg) + 36) })
                end
            end)

            function components:AddButton(buttonTitle, tooltip, callback)
                tooltip = tooltip or nil
                callback = callback or function() end
                local btndebounce = false
                local b1 = Create("TextButton", {
                    BackgroundColor3 = C.ITEM,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = container,
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = order
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                    Create("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.6
                    }),
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0.5, -7),
                        Size = UDim2.new(1, -40, 0, 14),
                        Font = Enum.Font.GothamMedium,
                        Text = buttonTitle,
                        TextColor3 = C.TEXT,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("ImageLabel", {
                        Name = "Arrow",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -24, 0.5, -7),
                        Size = UDim2.new(0, 14, 0, 14),
                        Image = "rbxassetid://6031094670",
                        ImageColor3 = C.SUBTEXT,
                        Rotation = 180
                    })
                })
                b1.MouseEnter:Connect(function()
                    tween(b1, 0.12, { BackgroundColor3 = C.BORDER })
                    showTooltip(tooltip)
                end)
                b1.MouseLeave:Connect(function()
                    tween(b1, 0.12, { BackgroundColor3 = C.ITEM })
                    hideTooltip()
                end)
                b1.MouseButton1Click:Connect(function()
                    callback()
                    if not btndebounce then
                        btndebounce = true
                        TS:Create(b1:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true), { Color = window.AccentColor }):Play()
                        task.wait(0.3)
                        btndebounce = false
                    end
                end)
                refreshSize()
                order = order + 1
            end

            function components:AddToggle(buttonTitle, tooltip, default, callback)
                local t1 = {}
                tooltip = tooltip or nil
                t1.State = default or false
                callback = callback or function() end

                local b1 = Create("TextButton", {
                    BackgroundColor3 = C.ITEM,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = container,
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = order
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                    Create("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.6
                    }),
                    Create("TextLabel", {
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0.5, -7),
                        Size = UDim2.new(1, -60, 0, 14),
                        Font = Enum.Font.GothamMedium,
                        Text = buttonTitle,
                        TextColor3 = C.TEXT,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                })

                -- Pill switch
                local pillBg = Create("Frame", {
                    BackgroundColor3 = t1.State and window.AccentColor or C.BORDER,
                    Size = UDim2.new(0, 36, 0, 18),
                    Position = UDim2.new(1, -46, 0.5, -9),
                    Parent = b1
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })

                local pillKnob = Create("Frame", {
                    BackgroundColor3 = C.WHITE,
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = t1.State and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                    Parent = pillBg
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })

                local function updateVisuals()
                    tween(pillBg, 0.18, { BackgroundColor3 = t1.State and window.AccentColor or C.BORDER })
                    tween(pillKnob, 0.18, { Position = t1.State and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6) })
                end

                b1.MouseEnter:Connect(function()
                    tween(b1, 0.12, { BackgroundColor3 = C.BORDER })
                    showTooltip(tooltip)
                end)
                b1.MouseLeave:Connect(function()
                    tween(b1, 0.12, { BackgroundColor3 = C.ITEM })
                    hideTooltip()
                end)
                b1.MouseButton1Click:Connect(function()
                    t1.State = not t1.State
                    callback(t1.State)
                    updateVisuals()
                end)

                function t1:SetState(state)
                    t1.State = state
                    callback(t1.State)
                    updateVisuals()
                end

                refreshSize()
                order = order + 1
                return t1
            end

            function components:AddTextBox(boxTitle, tooltip, placeholder, default, callback)
                tooltip = tooltip or nil
                placeholder = placeholder or ""
                default = default or ""
                callback = callback or function() end

                local b1 = Create("Frame", {
                    BackgroundColor3 = C.ITEM,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = container,
                    LayoutOrder = order
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                    Create("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.6
                    }),
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0.5, -7),
                        Size = UDim2.new(0.42, 0, 0, 14),
                        Font = Enum.Font.GothamMedium,
                        Text = boxTitle,
                        TextColor3 = C.TEXT,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                })

                local textbox = Create("TextBox", {
                    BackgroundColor3 = C.BG,
                    Size = UDim2.new(0, 145, 0, 22),
                    Position = UDim2.new(1, -150, 0.5, -11),
                    Parent = b1,
                    Font = Enum.Font.GothamMedium,
                    Text = default,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = C.SUBTEXT,
                    TextColor3 = C.TEXT,
                    TextSize = 12,
                    TextWrapped = true,
                    ClearTextOnFocus = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    Create("UIStroke", {
                        Name = "Stroke",
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.5
                    })
                })

                textbox.Focused:Connect(function()
                    tween(textbox.Stroke, 0.2, { Color = window.AccentColor, Transparency = 0 })
                end)
                textbox.FocusLost:Connect(function()
                    tween(textbox.Stroke, 0.2, { Color = C.BORDER, Transparency = 0.5 })
                    callback(textbox.Text)
                end)
                b1.MouseEnter:Connect(function() showTooltip(tooltip) end)
                b1.MouseLeave:Connect(function() hideTooltip() end)
                refreshSize()
                order = order + 1
            end

            function components:AddDropdown(dropdownText, tooltip, items, default, callback)
                local ee = {}
                tooltip = tooltip or nil
                items = items or {}
                default = default or ""
                callback = callback or function() end
                local dropdownOpen = false

                local b1 = Create("Frame", {
                    BackgroundColor3 = C.ITEM,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = container,
                    LayoutOrder = order,
                    ClipsDescendants = true
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                    Create("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.6
                    }),
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(0.42, 0, 0, 30),
                        Font = Enum.Font.GothamMedium,
                        Text = dropdownText,
                        TextColor3 = C.TEXT,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                })

                local selected = Create("TextBox", {
                    BackgroundColor3 = C.BG,
                    Size = UDim2.new(0, 118, 0, 22),
                    Position = UDim2.new(1, -152, 0.5, -11),
                    Parent = b1,
                    Font = Enum.Font.GothamMedium,
                    Text = default,
                    PlaceholderText = "select...",
                    PlaceholderColor3 = C.SUBTEXT,
                    TextColor3 = C.TEXT,
                    TextSize = 12,
                    TextEditable = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    Create("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.5
                    })
                })

                local dropBtn = Create("TextButton", {
                    BackgroundColor3 = C.BG,
                    Size = UDim2.new(0, 26, 0, 22),
                    Position = UDim2.new(1, -28, 0.5, -11),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = b1
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    Create("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.5
                    }),
                    Create("ImageLabel", {
                        Name = "Icon",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 11, 0, 11),
                        Position = UDim2.new(0.5, -5, 0.5, -5),
                        Image = "rbxassetid://6031094670",
                        ImageColor3 = C.SUBTEXT,
                        Rotation = 90
                    })
                })

                local dropdownContainer = Create("ScrollingFrame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, -8, 1, -34),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = C.BORDER,
                    BottomImage = "",
                    TopImage = "",
                    ScrollBarThickness = 3,
                    VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
                    Parent = b1,
                    Position = UDim2.new(0, 4, 0, 32)
                }, {
                    Create("UIListLayout", { Padding = UDim.new(0, 3) }),
                    Create("UIPadding", {
                        PaddingTop = UDim.new(0, 3),
                        PaddingBottom = UDim.new(0, 3)
                    })
                })

                dropBtn.MouseButton1Click:Connect(function()
                    dropdownOpen = not dropdownOpen
                    tween(dropBtn.Icon, 0.3, { Rotation = dropdownOpen and 270 or 90 })
                    tween(b1, 0.3, { Size = dropdownOpen and UDim2.new(1, 0, 0, 112) or UDim2.new(1, 0, 0, 30) })
                end)

                b1.Changed:Connect(function(it)
                    if it == "Size" then
                        local s = sectionSize(bg)
                        container.Size = UDim2.new(1, -12, 0, s)
                        bg.Size = UDim2.new(1, 0, 0, s + 36)
                    end
                end)

                local function buildItems(list)
                    for _, v in pairs(dropdownContainer:GetChildren()) do
                        if v:IsA("TextButton") then v:Destroy() end
                    end
                    dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
                    for i, v in pairs(list) do
                        local btndebounce = false
                        local entry = Create("TextButton", {
                            BackgroundColor3 = C.BG,
                            Size = UDim2.new(1, 0, 0, 26),
                            Parent = dropdownContainer,
                            Text = "",
                            AutoButtonColor = false,
                        }, {
                            Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                            Create("UIStroke", {
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Color = C.BORDER,
                                Transparency = 0.6
                            }),
                            Create("TextLabel", {
                                BackgroundTransparency = 1,
                                Position = UDim2.new(0, 8, 0.5, -7),
                                Size = UDim2.new(1, -8, 0, 14),
                                Font = Enum.Font.GothamMedium,
                                Text = v,
                                TextColor3 = C.TEXT,
                                TextSize = 12,
                                TextXAlignment = Enum.TextXAlignment.Left
                            })
                        })
                        dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, dropdownContainer.CanvasSize.Y.Offset + 29)
                        entry.MouseEnter:Connect(function()
                            tween(entry, 0.1, { BackgroundColor3 = C.ITEM })
                        end)
                        entry.MouseLeave:Connect(function()
                            tween(entry, 0.1, { BackgroundColor3 = C.BG })
                        end)
                        entry.MouseButton1Click:Connect(function()
                            selected.Text = v
                            callback(v)
                            if not btndebounce then
                                btndebounce = true
                                TS:Create(entry:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true), { Color = window.AccentColor }):Play()
                                task.wait(0.3)
                                btndebounce = false
                            end
                        end)
                    end
                end

                buildItems(items)

                function ee:Update(newlist)
                    items = newlist
                    selected.Text = ""
                    buildItems(items)
                end

                b1.MouseEnter:Connect(function() showTooltip(tooltip) end)
                b1.MouseLeave:Connect(function() hideTooltip() end)
                refreshSize()
                order = order + 1
                return ee
            end

            function components:AddSlider(boxTitle, tooltip, minValue, maxValue, default, precise, callback)
                local t1 = {}
                precise = precise or false
                tooltip = tooltip or nil
                minValue = minValue or 0
                maxValue = maxValue or 1
                default = default or minValue
                callback = callback or function() end
                local valuee = default

                local b1 = Create("Frame", {
                    BackgroundColor3 = C.ITEM,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = container,
                    LayoutOrder = order
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
                    Create("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.6
                    }),
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0.5, -7),
                        Size = UDim2.new(0.38, 0, 0, 14),
                        Font = Enum.Font.GothamMedium,
                        Text = boxTitle,
                        TextColor3 = C.TEXT,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("TextLabel", {
                        Name = "ValLabel",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.38, 0, 0.5, -7),
                        Size = UDim2.new(0, 40, 0, 14),
                        Font = Enum.Font.GothamMedium,
                        Text = tostring(default),
                        TextColor3 = window.AccentColor,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                })

                local sliderBg = Create("Frame", {
                    BackgroundColor3 = C.BG,
                    Size = UDim2.new(0, 128, 0, 6),
                    Position = UDim2.new(1, -136, 0.5, -3),
                    Parent = b1,
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Create("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = C.BORDER,
                        Transparency = 0.4
                    })
                })

                local initScale = (default - minValue) / (maxValue - minValue)

                local sliderFill = Create("Frame", {
                    BackgroundColor3 = window.AccentColor,
                    Size = UDim2.new(initScale, 0, 1, 0),
                    Parent = sliderBg
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })

                local knob = Create("Frame", {
                    BackgroundColor3 = C.WHITE,
                    Size = UDim2.new(0, 10, 0, 10),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(initScale, 0, 0.5, 0),
                    Parent = sliderBg,
                    ZIndex = 3
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })

                local draggingg = false
                local function move(input)
                    local scale = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local raw = scale * (maxValue - minValue) + minValue
                    local val = precise and math.floor(raw) or tonumber(string.format("%.2f", raw))
                    valuee = val
                    tween(sliderFill, 0.06, { Size = UDim2.new(scale, 0, 1, 0) })
                    tween(knob, 0.06, { Position = UDim2.new(scale, 0, 0.5, 0) })
                    b1.ValLabel.Text = tostring(val)
                    callback(valuee)
                end

                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        move(input)
                        draggingg = true
                    end
                end)
                sliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingg = false
                    end
                end)
                UIS.InputChanged:Connect(function(input)
                    if draggingg and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        move(input)
                    end
                end)

                function t1:SetValue(val)
                    val = math.clamp(val, minValue, maxValue)
                    local scale = (val - minValue) / (maxValue - minValue)
                    valuee = val
                    tween(sliderFill, 0.2, { Size = UDim2.new(scale, 0, 1, 0) })
                    tween(knob, 0.2, { Position = UDim2.new(scale, 0, 0.5, 0) })
                    b1.ValLabel.Text = tostring(val)
                    callback(valuee)
                end

                function t1:GetValue()
                    return valuee
                end

                b1.MouseEnter:Connect(function() showTooltip(tooltip) end)
                b1.MouseLeave:Connect(function() hideTooltip() end)
                refreshSize()
                order = order + 1
                return t1
            end

            bg.Changed:Connect(function(thing)
                if thing == "Size" then
                    page.CanvasSize = UDim2.new(0, 0, 0, sizeTab(page) + 10)
                end
            end)

            page.CanvasSize = UDim2.new(0, 0, 0, sizeTab(page) + 10)
            return components
        end
        return comp1
    end
    return window
end
return lib
