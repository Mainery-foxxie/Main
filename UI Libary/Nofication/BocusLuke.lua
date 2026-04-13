local Notification = {}

-- Anti‑detection: use cloneref if available, otherwise direct reference
local cloneref = cloneref or function(obj) return obj end
local CoreGui = cloneref(game:GetService("CoreGui"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = game:GetService("TweenService")

-- Create/find GUI (no cloneref on parent assignment)
local GUI = CoreGui:FindFirstChild("STX_Nofitication")
if not GUI then
    GUI = Instance.new("ScreenGui")
    GUI.Name = "STX_Nofitication"
    GUI.Parent = CoreGui  -- direct parenting works fine
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.ResetOnSpawn = false
    if syn and syn.protect_gui then
        syn.protect_gui(GUI)
    end

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = GUI
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.Padding = UDim.new(0, 5)
end

local function makeDraggable(frame, dragHandle)
    local dragging, dragStartPos, frameStartPos = false, nil, nil
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStartPos, frameStartPos = true, input.Position, frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStartPos
            frame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function Notification:Notify(nofdebug, middledebug, all)
    local selectedType = string.lower(tostring(middledebug.Type))

    -- Create elements (start invisible)
    local ambientShadow = Instance.new("ImageLabel")
    ambientShadow.Name = "Notification"
    ambientShadow.Parent = GUI  -- direct parent, no cloneref
    ambientShadow.BackgroundTransparency = 1
    ambientShadow.BorderSizePixel = 0
    ambientShadow.Size = UDim2.new(0, 0, 0, 0)
    ambientShadow.Image = "rbxassetid://1316045217"
    ambientShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ambientShadow.ImageTransparency = 1
    ambientShadow.ScaleType = Enum.ScaleType.Slice
    ambientShadow.SliceCenter = Rect.new(10, 10, 118, 118)

    local Window = Instance.new("Frame")
    Window.Parent = ambientShadow
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0, 5, 0, 5)
    Window.Size = UDim2.new(0, 230, 0, 80)
    Window.ZIndex = 2
    Window.BackgroundTransparency = 1

    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 6)
    windowCorner.Parent = Window

    local Outline_A = Instance.new("Frame")
    Outline_A.Parent = Window
    Outline_A.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Outline_A.BorderSizePixel = 0
    Outline_A.Position = UDim2.new(0, 0, 0, 25)
    Outline_A.Size = UDim2.new(0, 230, 0, 2)
    Outline_A.ZIndex = 5
    Outline_A.BackgroundTransparency = 1

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 100))
    })
    gradient.Parent = Outline_A

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent = Outline_A

    local WindowTitle = Instance.new("TextLabel")
    WindowTitle.Parent = Window
    WindowTitle.BackgroundTransparency = 1
    WindowTitle.BorderSizePixel = 0
    WindowTitle.Position = UDim2.new(0, 8, 0, 2)
    WindowTitle.Size = UDim2.new(0, 222, 0, 22)
    WindowTitle.ZIndex = 4
    WindowTitle.Font = Enum.Font.GothamSemibold
    WindowTitle.Text = nofdebug.Title
    WindowTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    WindowTitle.TextSize = 12
    WindowTitle.TextXAlignment = Enum.TextXAlignment.Left
    WindowTitle.TextYAlignment = Enum.TextYAlignment.Center
    WindowTitle.TextTransparency = 1

    local WindowDescription = Instance.new("TextLabel")
    WindowDescription.Parent = Window
    WindowDescription.BackgroundTransparency = 1
    WindowDescription.BorderSizePixel = 0
    WindowDescription.Position = UDim2.new(0, 8, 0, 34)
    WindowDescription.Size = UDim2.new(0, 216, 0, 40)
    WindowDescription.ZIndex = 4
    WindowDescription.Font = Enum.Font.GothamSemibold
    WindowDescription.Text = nofdebug.Description
    WindowDescription.TextColor3 = Color3.fromRGB(180, 180, 180)
    WindowDescription.TextSize = 12
    WindowDescription.TextWrapped = true
    WindowDescription.TextXAlignment = Enum.TextXAlignment.Left
    WindowDescription.TextYAlignment = Enum.TextYAlignment.Top
    WindowDescription.TextTransparency = 1

    makeDraggable(ambientShadow, WindowTitle)

    -- Type‑specific elements (also start invisible)
    local extraElements = {}
    if selectedType == "image" then
        WindowTitle.Position = UDim2.new(0, 24, 0, 2)
        local ImageButton = Instance.new("ImageButton")
        ImageButton.Parent = Window
        ImageButton.BackgroundTransparency = 1
        ImageButton.BorderSizePixel = 0
        ImageButton.Position = UDim2.new(0, 4, 0, 4)
        ImageButton.Size = UDim2.new(0, 18, 0, 18)
        ImageButton.ZIndex = 5
        ImageButton.AutoButtonColor = false
        ImageButton.Image = all.Image
        ImageButton.ImageColor3 = all.ImageColor
        ImageButton.ImageTransparency = 1
        table.insert(extraElements, ImageButton)
    elseif selectedType == "option" then
        ambientShadow.Size = UDim2.new(0, 0, 0, 0)  -- will tween to 240x110
        Window.Size = UDim2.new(0, 230, 0, 100)
        local Uncheck = Instance.new("ImageButton")
        Uncheck.Parent = Window
        Uncheck.BackgroundTransparency = 1
        Uncheck.BorderSizePixel = 0
        Uncheck.Position = UDim2.new(0, 7, 0, 76)
        Uncheck.Size = UDim2.new(0, 18, 0, 18)
        Uncheck.ZIndex = 5
        Uncheck.AutoButtonColor = false
        Uncheck.Image = "http://www.roblox.com/asset/?id=6031094678"
        Uncheck.ImageColor3 = Color3.fromRGB(255, 84, 84)
        Uncheck.ImageTransparency = 1
        local Check = Instance.new("ImageButton")
        Check.Parent = Window
        Check.BackgroundTransparency = 1
        Check.BorderSizePixel = 0
        Check.Position = UDim2.new(0, 28, 0, 76)
        Check.Size = UDim2.new(0, 18, 0, 18)
        Check.ZIndex = 5
        Check.AutoButtonColor = false
        Check.Image = "http://www.roblox.com/asset/?id=6031094667"
        Check.ImageColor3 = Color3.fromRGB(83, 230, 50)
        Check.ImageTransparency = 1
        table.insert(extraElements, Uncheck)
        table.insert(extraElements, Check)
    end

    -- Entrance animation
    local function playEntrance(targetSize)
        local sizeTween = TweenService:Create(ambientShadow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = targetSize })
        local shadowFade = TweenService:Create(ambientShadow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0.4 })
        local windowFade = TweenService:Create(Window, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 })
        local titleFade = TweenService:Create(WindowTitle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
        local descFade = TweenService:Create(WindowDescription, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
        local barFade = TweenService:Create(Outline_A, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 })

        sizeTween:Play()
        shadowFade:Play()
        windowFade:Play()
        titleFade:Play()
        descFade:Play()
        barFade:Play()

        for _, el in ipairs(extraElements) do
            if el:IsA("ImageButton") then
                local fade = TweenService:Create(el, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 })
                fade:Play()
            end
        end

        sizeTween.Completed:Wait()
    end

    -- Exit animation
    local function playExit()
        local sizeTween = TweenService:Create(ambientShadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 0, 0) })
        local fadeTween = TweenService:Create(ambientShadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 1 })
        sizeTween:Play()
        fadeTween:Play()
        sizeTween.Completed:Wait()
        ambientShadow:Destroy()
    end

    -- Main coroutine
    coroutine.wrap(function()
        local targetSize = UDim2.new(0, 240, 0, 90)
        if selectedType == "option" then
            targetSize = UDim2.new(0, 240, 0, 110)
        end

        playEntrance(targetSize)

        Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", middledebug.Time)
        wait(middledebug.Time)

        if selectedType ~= "option" or (selectedType == "option" and not extraElements[1].Parent) then
            playExit()
        end
    end)()

    -- Option button handling
    if selectedType == "option" then
        local Uncheck = extraElements[1]
        local Check = extraElements[2]
        local active = true
        local function closeWith(value)
            if not active then return end
            active = false
            pcall(function() all.Callback(value) end)
            playExit()
        end
        Uncheck.MouseButton1Click:Connect(function() closeWith(false) end)
        Check.MouseButton1Click:Connect(function() closeWith(true) end)
    end
end

return Notification
