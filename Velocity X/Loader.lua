-- prevent spamming
if getgenv().Velocity_X_Loader then
    --error("Alwi made this idk 😳") 
end
getgenv().Velocity_X_Loader = true

local function randomString(len)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local str = ""
    for i = 1, len do
        local r = math.random(1,#chars)
        str = str .. chars:sub(r,r)
    end
    return str
end

local cloneref = cloneref or function(obj) return obj end
local CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--[[
-- This useless i think
for _,v in pairs(CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name:match("Velocity_") then
        v:Destroy()
    end
end
--]]
-- Main name
local RealZzHub = Instance.new("ScreenGui")
RealZzHub.Name = "Velocity_"..randomString(10)
RealZzHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(RealZzHub)
    RealZzHub.Parent = CoreGui
elseif gethui then
    RealZzHub.Parent = gethui()
else
    RealZzHub.Parent = CoreGui
end

local MainBackground = Instance.new("ImageLabel", RealZzHub)
MainBackground.AnchorPoint = Vector2.new(0.5,0.5)
MainBackground.Position = UDim2.new(0.5,0,0.5,0)
MainBackground.Size = UDim2.new(0,1,0,1)
MainBackground.Image = "rbxassetid://7877641241"
MainBackground.BackgroundColor3 = Color3.new(1,1,1)
MainBackground.BorderSizePixel = 0
MainBackground.Visible = false
MainBackground.ImageTransparency = 1

local Gradient = Instance.new("UIGradient", MainBackground)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}
Gradient.Rotation = 45

local ShadowStroke = Instance.new("UIStroke", MainBackground)
ShadowStroke.Color = Color3.fromRGB(0, 100, 150)
ShadowStroke.Thickness = 4.5
ShadowStroke.Transparency = 0.6

local EdgeStroke = Instance.new("UIStroke", MainBackground)
EdgeStroke.Thickness = 3.5
EdgeStroke.Transparency = 0.3

local colorGreen = Color3.fromRGB(0, 255, 120)
local colorBlue = Color3.fromRGB(0, 170, 255)

local startTime = tick()
local cycleDuration = 4

spawn(function()
    while MainBackground and MainBackground.Parent do
        local t = (tick() - startTime) / cycleDuration
        local factor = (math.sin(t * math.pi * 2) + 1) / 2
        local r = colorGreen.R + (colorBlue.R - colorGreen.R) * factor
        local g = colorGreen.G + (colorBlue.G - colorGreen.G) * factor
        local b = colorGreen.B + (colorBlue.B - colorGreen.B) * factor
        EdgeStroke.Color = Color3.new(r, g, b)
        RunService.Heartbeat:Wait()
    end
end)

local Corner = Instance.new("UICorner", MainBackground)
Corner.CornerRadius = UDim.new(0, 8)

local Logo = Instance.new("ImageButton", MainBackground)
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0,6,0,6)
Logo.Size = UDim2.new(0,25,0,25)
Logo.Image = "rbxassetid://103887859853708"
Logo.Visible = false

local Name = Instance.new("TextLabel", MainBackground)
Name.BackgroundTransparency = 1
Name.Position = UDim2.new(0.11,0,0.04,0)
Name.Size = UDim2.new(0,78,0,25)
Name.Font = Enum.Font.Arcade
Name.Text = "Velocity X Loader"
Name.TextSize = 15
Name.TextXAlignment = Enum.TextXAlignment.Left
Name.TextColor3 = Color3.fromRGB(0,255,150)
Name.TextStrokeTransparency = 0
Name.TextStrokeColor3 = Color3.fromRGB(0,0,0)
Name.Visible = false

local InjectButton = Instance.new("TextButton", MainBackground)
InjectButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
InjectButton.BackgroundTransparency = 1
InjectButton.Position = UDim2.new(0.11,0,0.33,0)
InjectButton.Size = UDim2.new(0,252,0,47)
InjectButton.Font = Enum.Font.Arcade
InjectButton.Text = "Initializing..."
InjectButton.TextScaled = true
InjectButton.TextColor3 = Color3.new(0,0,0)
InjectButton.Visible = false

Instance.new("UICorner", InjectButton).CornerRadius = UDim.new(0,4)

local BtnGradient = Instance.new("UIGradient", InjectButton)
BtnGradient.Color = Gradient.Color
BtnGradient.Rotation = 90

local BtnStroke = Instance.new("UIStroke", InjectButton)
BtnStroke.Color = Color3.fromRGB(0,255,150)
BtnStroke.Thickness = 1.5

local Version = Instance.new("TextLabel", MainBackground)
Version.BackgroundTransparency = 1
Version.Position = UDim2.new(0.26,0,0.86,0)
Version.Size = UDim2.new(0,227,0,21)
Version.Font = Enum.Font.Arcade
Version.Text = "Loading..."
Version.TextSize = 13
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.TextColor3 = Color3.fromRGB(0,200,255)
Version.TextStrokeTransparency = 0
Version.TextStrokeColor3 = Color3.fromRGB(0,0,0)
Version.Visible = false

local CloseButton = Instance.new("TextButton", MainBackground)
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(0.928,0,0,-2)
CloseButton.Rotation = 45
CloseButton.Size = UDim2.new(0,25,0,25)
CloseButton.Font = Enum.Font.Arcade
CloseButton.Text = "+"
CloseButton.TextSize = 29
CloseButton.Visible = false

local SettingsIcon = Instance.new("ImageButton", MainBackground)
SettingsIcon.BackgroundTransparency = 1
SettingsIcon.Position = UDim2.new(0.85,0,0.01,0)
SettingsIcon.Size = UDim2.new(0,22,0,22)
SettingsIcon.Image = "rbxassetid://101339235267993"
SettingsIcon.Visible = false
SettingsIcon.ImageTransparency = 0.2

local SettingsPanel = Instance.new("ImageLabel", MainBackground)
SettingsPanel.AnchorPoint = Vector2.new(1, 0)
SettingsPanel.Position = UDim2.new(0.85, 0, 0.09, 0)
SettingsPanel.Size = UDim2.new(0, 180, 0, 130)  -- height for three toggles
SettingsPanel.Image = "rbxassetid://7877641241"
SettingsPanel.BackgroundColor3 = Color3.new(1,1,1)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 2

local PanelGradient = Instance.new("UIGradient", SettingsPanel)
PanelGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}
PanelGradient.Rotation = 45

local PanelStroke = Instance.new("UIStroke", SettingsPanel)
PanelStroke.Color = Color3.fromRGB(0,200,255)
PanelStroke.Thickness = 2
PanelStroke.Transparency = 0.3

local PanelCorner = Instance.new("UICorner", SettingsPanel)
PanelCorner.CornerRadius = UDim.new(0, 8)

local PanelTitle = Instance.new("TextLabel", SettingsPanel)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Position = UDim2.new(0, 8, 0, 5)
PanelTitle.Size = UDim2.new(1, -16, 0, 20)
PanelTitle.Font = Enum.Font.Arcade
PanelTitle.Text = "Settings"
PanelTitle.TextColor3 = Color3.fromRGB(0,255,150)
PanelTitle.TextSize = 12
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle 1: Auto Save Config
local AutoSaveToggle = Instance.new("Frame", SettingsPanel)
AutoSaveToggle.Name = "AutoSaveToggle"
AutoSaveToggle.Position = UDim2.new(0, 10, 0, 30)
AutoSaveToggle.Size = UDim2.new(0, 160, 0, 25)
AutoSaveToggle.BackgroundTransparency = 1

local AutoSaveLabel = Instance.new("TextLabel", AutoSaveToggle)
AutoSaveLabel.BackgroundTransparency = 1
AutoSaveLabel.Position = UDim2.new(0, 0, 0, 0)
AutoSaveLabel.Size = UDim2.new(0, 100, 1, 0)
AutoSaveLabel.Font = Enum.Font.Arcade
AutoSaveLabel.Text = "Auto Save Config"
AutoSaveLabel.TextColor3 = Color3.fromRGB(255,255,255)
AutoSaveLabel.TextSize = 10
AutoSaveLabel.TextXAlignment = Enum.TextXAlignment.Left

local AutoSaveCheck = Instance.new("Frame", AutoSaveToggle)
AutoSaveCheck.Name = "Check"
AutoSaveCheck.AnchorPoint = Vector2.new(1, 0.5)
AutoSaveCheck.Position = UDim2.new(1, -5, 0.5, 0)
AutoSaveCheck.Size = UDim2.new(0, 20, 0, 20)
AutoSaveCheck.BackgroundColor3 = Color3.fromRGB(42,42,42)
AutoSaveCheck.BorderSizePixel = 0

local AutoSaveCheckInner = Instance.new("Frame", AutoSaveCheck)
AutoSaveCheckInner.AnchorPoint = Vector2.new(0.5, 0.5)
AutoSaveCheckInner.Position = UDim2.new(0.5, 0, 0.5, 0)
AutoSaveCheckInner.Size = UDim2.new(1, 0, 1, 0)
AutoSaveCheckInner.BackgroundColor3 = Color3.fromRGB(255,255,255)
AutoSaveCheckInner.BackgroundTransparency = 1

local AutoSaveCheckInnerCorner = Instance.new("UICorner", AutoSaveCheckInner)
AutoSaveCheckInnerCorner.CornerRadius = UDim.new(1,0)

local AutoSaveGrad = Instance.new("UIGradient", AutoSaveCheckInner)
AutoSaveGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}
AutoSaveGrad.Rotation = 48

local AutoSaveCorner = Instance.new("UICorner", AutoSaveCheck)
AutoSaveCorner.CornerRadius = UDim.new(1,0)

-- Toggle 2: Auto Inject
local AutoInjectToggle = Instance.new("Frame", SettingsPanel)
AutoInjectToggle.Name = "AutoInjectToggle"
AutoInjectToggle.Position = UDim2.new(0, 10, 0, 60)
AutoInjectToggle.Size = UDim2.new(0, 160, 0, 25)
AutoInjectToggle.BackgroundTransparency = 1

local AutoInjectLabel = Instance.new("TextLabel", AutoInjectToggle)
AutoInjectLabel.BackgroundTransparency = 1
AutoInjectLabel.Position = UDim2.new(0, 0, 0, 0)
AutoInjectLabel.Size = UDim2.new(0, 100, 1, 0)
AutoInjectLabel.Font = Enum.Font.Arcade
AutoInjectLabel.Text = "Auto Inject"
AutoInjectLabel.TextColor3 = Color3.fromRGB(255,255,255)
AutoInjectLabel.TextSize = 10
AutoInjectLabel.TextXAlignment = Enum.TextXAlignment.Left

local AutoInjectCheck = Instance.new("Frame", AutoInjectToggle)
AutoInjectCheck.Name = "Check"
AutoInjectCheck.AnchorPoint = Vector2.new(1, 0.5)
AutoInjectCheck.Position = UDim2.new(1, -5, 0.5, 0)
AutoInjectCheck.Size = UDim2.new(0, 20, 0, 20)
AutoInjectCheck.BackgroundColor3 = Color3.fromRGB(42,42,42)
AutoInjectCheck.BorderSizePixel = 0

local AutoInjectCheckInner = Instance.new("Frame", AutoInjectCheck)
AutoInjectCheckInner.AnchorPoint = Vector2.new(0.5, 0.5)
AutoInjectCheckInner.Position = UDim2.new(0.5, 0, 0.5, 0)
AutoInjectCheckInner.Size = UDim2.new(1, 0, 1, 0)
AutoInjectCheckInner.BackgroundColor3 = Color3.fromRGB(255,255,255)
AutoInjectCheckInner.BackgroundTransparency = 1

local AutoInjectCheckInnerCorner = Instance.new("UICorner", AutoInjectCheckInner)
AutoInjectCheckInnerCorner.CornerRadius = UDim.new(1,0)

local AutoInjectGrad = Instance.new("UIGradient", AutoInjectCheckInner)
AutoInjectGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}
AutoInjectGrad.Rotation = 48

local AutoInjectCorner = Instance.new("UICorner", AutoInjectCheck)
AutoInjectCorner.CornerRadius = UDim.new(1,0)

-- Toggle 3: Auto Executor Loader (queue_on_teleport)
local ExecutorLoaderToggle = Instance.new("Frame", SettingsPanel)
ExecutorLoaderToggle.Name = "ExecutorLoaderToggle"
ExecutorLoaderToggle.Position = UDim2.new(0, 10, 0, 90)
ExecutorLoaderToggle.Size = UDim2.new(0, 160, 0, 25)
ExecutorLoaderToggle.BackgroundTransparency = 1

local ExecutorLoaderLabel = Instance.new("TextLabel", ExecutorLoaderToggle)
ExecutorLoaderLabel.BackgroundTransparency = 1
ExecutorLoaderLabel.Position = UDim2.new(0, 0, 0, 0)
ExecutorLoaderLabel.Size = UDim2.new(0, 100, 1, 0)
ExecutorLoaderLabel.Font = Enum.Font.Arcade
ExecutorLoaderLabel.Text = "Auto Executor Loader"
ExecutorLoaderLabel.TextColor3 = Color3.fromRGB(255,255,255)
ExecutorLoaderLabel.TextSize = 10
ExecutorLoaderLabel.TextXAlignment = Enum.TextXAlignment.Left

local ExecutorLoaderCheck = Instance.new("Frame", ExecutorLoaderToggle)
ExecutorLoaderCheck.Name = "Check"
ExecutorLoaderCheck.AnchorPoint = Vector2.new(1, 0.5)
ExecutorLoaderCheck.Position = UDim2.new(1, -5, 0.5, 0)
ExecutorLoaderCheck.Size = UDim2.new(0, 20, 0, 20)
ExecutorLoaderCheck.BackgroundColor3 = Color3.fromRGB(42,42,42)
ExecutorLoaderCheck.BorderSizePixel = 0

local ExecutorLoaderCheckInner = Instance.new("Frame", ExecutorLoaderCheck)
ExecutorLoaderCheckInner.AnchorPoint = Vector2.new(0.5, 0.5)
ExecutorLoaderCheckInner.Position = UDim2.new(0.5, 0, 0.5, 0)
ExecutorLoaderCheckInner.Size = UDim2.new(1, 0, 1, 0)
ExecutorLoaderCheckInner.BackgroundColor3 = Color3.fromRGB(255,255,255)
ExecutorLoaderCheckInner.BackgroundTransparency = 1

local ExecutorLoaderCheckInnerCorner = Instance.new("UICorner", ExecutorLoaderCheckInner)
ExecutorLoaderCheckInnerCorner.CornerRadius = UDim.new(1,0)

local ExecutorLoaderGrad = Instance.new("UIGradient", ExecutorLoaderCheckInner)
ExecutorLoaderGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}
ExecutorLoaderGrad.Rotation = 48

local ExecutorLoaderCorner = Instance.new("UICorner", ExecutorLoaderCheck)
ExecutorLoaderCorner.CornerRadius = UDim.new(1,0)

-- ========== CONFIGURATION SYSTEM ==========
local CONFIG_FILE = "VelocityX_Settings.json"
local config = {
    autoSave = false,
    autoInject = false,
    autoExecutorLoader = false
}

local function updateToggleUI(checkFrame, innerFrame, value)
    if value then
        TweenService:Create(innerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.8, 0, 0.8, 0),
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(checkFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(60,60,60)
        }):Play()
    else
        TweenService:Create(innerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(checkFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(42,42,42)
        }):Play()
    end
end

local function loadConfig()
    if readfile and isfile and isfile(CONFIG_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success and data then
            config.autoSave = data.autoSave or false
            config.autoInject = data.autoInject or false
            config.autoExecutorLoader = data.autoExecutorLoader or false
        end
    end
end

local function saveConfig()
    if writefile and config.autoSave then
        local data = HttpService:JSONEncode({
            autoSave = config.autoSave,
            autoInject = config.autoInject,
            autoExecutorLoader = config.autoExecutorLoader
        })
        writefile(CONFIG_FILE, data)
    end
end

local function applyConfigToUI()
    updateToggleUI(AutoSaveCheck, AutoSaveCheckInner, config.autoSave)
    updateToggleUI(AutoInjectCheck, AutoInjectCheckInner, config.autoInject)
    updateToggleUI(ExecutorLoaderCheck, ExecutorLoaderCheckInner, config.autoExecutorLoader)
end

local function setupAutoExecutorLoader()
    local queueteleport = queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if queueteleport then
        spawn(function()
            pcall(function()
                queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Loader.lua'))()")
            end)
        end)
    else
        warn("Your executor does not support queue_on_teleport. Auto Executor Loader will not work.")
        print("Your executor does not support queue_on_teleport. Auto Executor Loader will not work.")
        pcall(function()
            game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
        end)
    end
end

-- ========== BUTTON ENABLE/DISABLE HELPERS ==========
local function setButtonActive(button, active)
    if not button or not button.Parent then return end
    button.Active = active
    if button:IsA("TextButton") then
        button.TextTransparency = active and 0 or 0.5
    elseif button:IsA("ImageButton") then
        button.ImageTransparency = active and 0.2 or 0.6
    end
end

-- ========== SCRIPT LOGIC ==========
local path1 = nil
local isUniversal = true
local injected = false

local UNIVERSAL_URL = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/Universal/Main.lua"
local BASE_GAME_URL = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/"

-- add faster tick niggers
local fetchSuccess, response = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/SupportedGames.json?nocache=" .. tick())
end)

if fetchSuccess and response then
    local decodeSuccess, gamesData = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    if decodeSuccess and gamesData then
        local gameIdStr = tostring(game.GameId)
        if gamesData[gameIdStr] then
            local gameInfo = gamesData[gameIdStr]
            InjectButton.Text = gameInfo.Name .. "."
            path1 = gameInfo.Path
            isUniversal = false
        else
            InjectButton.Text = "Universal"
            isUniversal = true
        end
    else
        warn("JSON decode failed. Using Universal.")
        InjectButton.Text = "Universal"
        isUniversal = true
    end
else
    warn("Failed to fetch SupportedGames.json. Using Universal.")
    InjectButton.Text = "Universal"
    isUniversal = true
end

if not path1 then
    isUniversal = true
    InjectButton.Text = "Universal"
end

pcall(function()
    local versionStr = game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/version.json")
    Version.Text = "Version: " .. versionStr
end)

local function clearText()
    for _,v in ipairs(MainBackground:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            v.Text = ""
        end
    end
end

local function injectScript()
    if injected then return end
    injected = true
    if isUniversal then
        loadstring(game:HttpGet(UNIVERSAL_URL))()
    else
        local fullUrl = BASE_GAME_URL .. path1
        loadstring(game:HttpGet(fullUrl))()
    end
end

local function performAutoInject()
    if injected then return end
    injectScript()
    InjectButton.Text = "Injecting..."
    TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0),
        ImageTransparency = 1
    }):Play()
    clearText()
    task.wait(0.35)
    if RealZzHub then RealZzHub:Destroy() end
end

-- OPEN ANIMATION
MainBackground.Visible = true
MainBackground.Size = UDim2.new(0,0,0,0)
TweenService:Create(MainBackground, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0,318,0,150),
    ImageTransparency = 0.2
}):Play()
task.wait(0.4)

CloseButton.Visible = true
InjectButton.Visible = true
Name.Visible = true
Logo.Visible = true
Version.Visible = true
SettingsIcon.Visible = true

loadConfig()
applyConfigToUI()

if config.autoExecutorLoader then
    setupAutoExecutorLoader()
end

local function createToggleHandler(checkFrame, innerFrame, configKey, callback)
    local click = Instance.new("TextButton")
    click.Name = "Click"
    click.Parent = checkFrame.Parent
    click.BackgroundTransparency = 1
    click.Size = UDim2.new(1, 0, 1, 0)
    click.Text = ""
    click.ZIndex = 3
    click.MouseButton1Click:Connect(function()
        local newValue = not config[configKey]
        config[configKey] = newValue
        updateToggleUI(checkFrame, innerFrame, newValue)
        if config.autoSave then saveConfig() end
        if callback then callback(newValue) end
        
        if configKey == "autoInject" and newValue and not injected then
            performAutoInject()
        elseif configKey == "autoExecutorLoader" and newValue then
            setupAutoExecutorLoader()
        end
    end)
end

createToggleHandler(AutoSaveCheck, AutoSaveCheckInner, "autoSave", function(val)
    print("Auto Save Config:", val)
end)
createToggleHandler(AutoInjectCheck, AutoInjectCheckInner, "autoInject", function(val)
    print("Auto Inject:", val)
end)
createToggleHandler(ExecutorLoaderCheck, ExecutorLoaderCheckInner, "autoExecutorLoader", function(val)
    print("Auto Executor Loader:", val)
end)

if config.autoInject then
    performAutoInject()
end

InjectButton.MouseButton1Click:Connect(function()
    if not InjectButton.Active then return end
    injectScript()
    InjectButton.Text = "Injecting..."
    TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0),
        ImageTransparency = 1
    }):Play()
    clearText()
    task.wait(0.35)
    if RealZzHub then RealZzHub:Destroy() end
end)

SettingsIcon.MouseButton1Click:Connect(function()
    if not SettingsPanel then return end
    if SettingsPanel.Visible then
        TweenService:Create(SettingsPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            ImageTransparency = 1
        }):Play()
        task.wait(0.15)
        if SettingsPanel then
            SettingsPanel.Visible = false
            SettingsPanel.Size = UDim2.new(0, 180, 0, 130)
            SettingsPanel.ImageTransparency = 0
        end
        if ConfirmFrame and not ConfirmFrame.Visible then
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton, true)
        end
    else
        SettingsPanel.Visible = true
        SettingsPanel.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(SettingsPanel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 180, 0, 130),
            ImageTransparency = 0
        }):Play()
        setButtonActive(InjectButton, false)
        setButtonActive(CloseButton, false)
    end
end)

-- Confirmation dialog
local ConfirmFrame = Instance.new("ImageLabel", MainBackground)
ConfirmFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ConfirmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ConfirmFrame.Size = UDim2.new(0, 200, 0, 100)
ConfirmFrame.Image = "rbxassetid://7877641241"
ConfirmFrame.BackgroundColor3 = Color3.new(1,1,1)
ConfirmFrame.BorderSizePixel = 0
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 3

local ConfirmGradient = Instance.new("UIGradient", ConfirmFrame)
ConfirmGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}
ConfirmGradient.Rotation = 45
local ConfirmStroke = Instance.new("UIStroke", ConfirmFrame)
ConfirmStroke.Color = Color3.fromRGB(0,200,255)
ConfirmStroke.Thickness = 2
ConfirmStroke.Transparency = 0.3
local ConfirmCorner = Instance.new("UICorner", ConfirmFrame)
ConfirmCorner.CornerRadius = UDim.new(0, 8)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
ConfirmText.Size = UDim2.new(1, 0, 0.3, 0)
ConfirmText.Font = Enum.Font.Arcade
ConfirmText.Text = "Are you sure you want\nto close Velocity X?"
ConfirmText.TextSize = 12
ConfirmText.TextColor3 = Color3.fromRGB(0,255,150)
ConfirmText.TextStrokeTransparency = 0
ConfirmText.TextStrokeColor3 = Color3.fromRGB(0,0,0)

local YesButton = Instance.new("TextButton", ConfirmFrame)
YesButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
YesButton.BackgroundTransparency = 1
YesButton.Position = UDim2.new(0.15, 0, 0.65, 0)
YesButton.Size = UDim2.new(0, 70, 0, 30)
YesButton.Font = Enum.Font.Arcade
YesButton.Text = "Yes"
YesButton.TextScaled = true
YesButton.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", YesButton).CornerRadius = UDim.new(0, 4)
local YesGradient = Instance.new("UIGradient", YesButton)
YesGradient.Color = ConfirmGradient.Color
YesGradient.Rotation = 90
local YesStroke = Instance.new("UIStroke", YesButton)
YesStroke.Color = Color3.fromRGB(0,255,150)
YesStroke.Thickness = 1.5

local NoButton = Instance.new("TextButton", ConfirmFrame)
NoButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
NoButton.BackgroundTransparency = 1
NoButton.Position = UDim2.new(0.55, 0, 0.65, 0)
NoButton.Size = UDim2.new(0, 70, 0, 30)
NoButton.Font = Enum.Font.Arcade
NoButton.Text = "No"
NoButton.TextScaled = true
NoButton.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", NoButton).CornerRadius = UDim.new(0, 4)
local NoGradient = Instance.new("UIGradient", NoButton)
NoGradient.Color = ConfirmGradient.Color
NoGradient.Rotation = 90
local NoStroke = Instance.new("UIStroke", NoButton)
NoStroke.Color = Color3.fromRGB(0,255,150)
NoStroke.Thickness = 1.5

local confirmClosing = false
local function closeConfirmDialog(callback)
    if not ConfirmFrame or not ConfirmFrame.Parent then
        if callback then callback() end
        return
    end
    if not ConfirmFrame.Visible or confirmClosing then
        if callback then callback() end
        return
    end
    confirmClosing = true
    local tween = TweenService:Create(ConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0),
        ImageTransparency = 1
    })
    tween.Completed:Connect(function()
        if ConfirmFrame and ConfirmFrame.Parent then
            ConfirmFrame.Visible = false
            ConfirmFrame.Size = UDim2.new(0,200,0,100)
            ConfirmFrame.ImageTransparency = 0
        end
        confirmClosing = false
        if SettingsPanel and SettingsPanel.Visible then
            setButtonActive(InjectButton, false)
            setButtonActive(CloseButton, false)
            setButtonActive(SettingsIcon, true)
        else
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton, true)
            setButtonActive(SettingsIcon, true)
        end
        if callback then callback() end
    end)
    tween:Play()
end

CloseButton.MouseButton1Click:Connect(function()
    if not ConfirmFrame or ConfirmFrame.Visible then return end
    setButtonActive(InjectButton, false)
    setButtonActive(CloseButton, false)
    setButtonActive(SettingsIcon, false)
    if SettingsPanel and SettingsPanel.Visible then
        SettingsPanel.Visible = false
        SettingsPanel.Size = UDim2.new(0, 180, 0, 130)
        SettingsPanel.ImageTransparency = 0
    end
    ConfirmFrame.Visible = true
    ConfirmFrame.Size = UDim2.new(0,0,0,0)
    ConfirmFrame.ImageTransparency = 1
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0,200,0,100),
        ImageTransparency = 0
    }):Play()
end)

YesButton.MouseButton1Click:Connect(function()
    closeConfirmDialog(function()
        clearText()
        TweenService:Create(MainBackground, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0,0,0,0),
            ImageTransparency = 1
        }):Play()
        task.wait(0.3)
        if RealZzHub then RealZzHub:Destroy() end
    end)
end)

NoButton.MouseButton1Click:Connect(function()
    closeConfirmDialog()
end)

-- DRAG SYSTEM
local UIS = game:GetService("UserInputService")
local dragging = false
local dragInput, mousePos, framePos

local function update(input)
    local delta = input.Position - mousePos
    MainBackground.Position = UDim2.new(
        framePos.X.Scale,
        framePos.X.Offset + delta.X,
        framePos.Y.Scale,
        framePos.Y.Offset + delta.Y
    )
end

MainBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MainBackground.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainBackground.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
