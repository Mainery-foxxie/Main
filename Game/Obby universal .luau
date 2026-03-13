local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("Majestic_VIP_TP") then
    PlayerGui.Majestic_VIP_TP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Majestic_VIP_TP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local C_BG = Color3.fromRGB(5, 5, 5)        
local C_CARD = Color3.fromRGB(12, 12, 15)   
local C_PURP = Color3.fromRGB(120, 40, 255) 
local C_GLOW = Color3.fromRGB(160, 80, 255) 
local C_TEXT = Color3.fromRGB(240, 240, 240)
local C_SUB = Color3.fromRGB(150, 150, 150)

local Toggling = false

local function MakeDraggable(object)
    local dragging, dragInput, dragStart, startPos
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = C_BG
ToggleButton.Text = "M"
ToggleButton.TextColor3 = C_PURP
ToggleButton.Font = Enum.Font.FredokaOne
ToggleButton.TextSize = 20
ToggleButton.Parent = ScreenGui
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = C_PURP
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 360) 
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
MainFrame.BackgroundColor3 = C_BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C_PURP
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "MAJESTIC VIP"
Title.TextColor3 = C_TEXT
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local function CreateStyledInput(placeholder, pos)
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.85, 0, 0, 38)
    Box.Position = pos
    Box.AnchorPoint = Vector2.new(0.5, 0)
    Box.BackgroundColor3 = C_CARD
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.TextColor3 = C_TEXT
    Box.PlaceholderColor3 = C_SUB
    Box.Font = Enum.Font.GothamSemibold
    Box.TextSize = 13
    Box.Parent = MainFrame
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Box
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 35, 40)
    Stroke.Thickness = 1
    Stroke.Parent = Box
    return Box
end

local StartStageInput = CreateStyledInput("Start Stage", UDim2.new(0.5, 0, 0.20, 0))
local EndStageInput = CreateStyledInput("End Stage", UDim2.new(0.5, 0, 0.35, 0))
local SpeedInput = CreateStyledInput("Delay Speed (0.5)", UDim2.new(0.5, 0, 0.50, 0))

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0.65, 0, 0, 42)
StartBtn.Position = UDim2.new(0.5, 0, 0.80, 0)
StartBtn.AnchorPoint = Vector2.new(0.5, 0.5)
StartBtn.BackgroundColor3 = C_PURP
StartBtn.Text = "AUTO TP: OFF"
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 14
StartBtn.AutoButtonColor = false
StartBtn.Parent = MainFrame
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = StartBtn

local function ExecuteTP()
    if Toggling then
        Toggling = false
        StartBtn.Text = "AUTO TP: OFF"
        return
    end

    local stagesFolder = workspace:FindFirstChild("Stages") or workspace:FindFirstChild("Checkpoints")
    if not stagesFolder then 
        StartBtn.Text = "STAGES NOT FOUND"
        task.wait(1)
        StartBtn.Text = "AUTO TP: OFF"
        return 
    end

    Toggling = true
    StartBtn.Text = "AUTO TP: ON"

    local startNum = tonumber(StartStageInput.Text) or 0
    local endNum = tonumber(EndStageInput.Text) or 9999
    local speed = tonumber(SpeedInput.Text) or 0.5
    
    local list = {}
    for _, s in ipairs(stagesFolder:GetChildren()) do
        local n = tonumber(s.Name:match("%d+"))
        if n then table.insert(list, {obj = s, n = n}) end
    end
    table.sort(list, function(a, b) return a.n < b.n end)

    task.spawn(function()
        for _, stageData in ipairs(list) do
            if not Toggling then break end
            
            if stageData.n >= startNum and stageData.n <= endNum then
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local root = char:WaitForChild("HumanoidRootPart", 5)
                
                if root then
                    local target = stageData.obj
                    local part = target:IsA("BasePart") and target or (target:FindFirstChild("TouchPart") or target:FindFirstChildWhichIsA("BasePart", true))
                    
                    if part then
                        root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                        task.wait(speed)
                    end
                end
            end
        end
        Toggling = false
        StartBtn.Text = "AUTO TP: OFF"
    end)
end

StartBtn.MouseButton1Click:Connect(ExecuteTP)
MakeDraggable(MainFrame)
MakeDraggable(ToggleButton)

local visible = true
ToggleButton.MouseButton1Click:Connect(function()
    visible = not visible
    if visible then
        MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 280, 0, 360), "Out", "Quart", 0.4, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 280, 0, 0), "In", "Quart", 0.4, true, function() if not visible then MainFrame.Visible = false end end)
    end
end)

RunService.RenderStepped:Connect(function()
    local t = tick()
    local pulse = math.abs(math.sin(t * 1.5))
    ToggleStroke.Transparency = 0.2 + (pulse * 0.4)
    MainStroke.Transparency = 0.3 + (pulse * 0.3)
end)
