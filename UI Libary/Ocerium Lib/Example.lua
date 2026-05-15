-- ============================================================
--  Ocerium Lib — Example GUI Script
--  Load the library clean from the source
-- ============================================================

-- Optional: set a custom theme BEFORE loading the library
getgenv().LibTheme = {
    MainColor          = Color3.fromRGB(35, 35, 40),      -- dark bg
    BrighterMainColor  = Color3.fromRGB(40, 40, 45),      -- slightly lighter bg
    IconsColor         = Color3.fromRGB(100, 100, 120),
    Accent             = Color3.fromRGB(0, 120, 255),     -- blue accent
    DarkText           = Color3.fromRGB(170, 170, 170),
    BrightText         = Color3.fromRGB(145, 145, 145),
    Font               = "Gotham",
    SoundVolume        = 0.5,
    HideKey            = "LeftAlt",  -- press Left Alt to hide/show the GUI
}

-- Load the library
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Ocerium%20Lib/Source.lua"
))()

-- ============================================================
--  Create the main window
-- ============================================================
local Window = Library.Main("My Script")

-- Show a loading animation for 3 seconds on open
Window.Loader(3)

-- ============================================================
--  PAGE 1 — Combat
-- ============================================================
local CombatPage = Window.Page("Combat", "11342940462")

-- Section: Aimbot
local AimbotSection = CombatPage.Section("Aimbot")

AimbotSection.Component("Card",
    "Aimbot",
    "Automatically locks your aim to the nearest player."
)

AimbotSection.Component("Toggle",
    "Enable Aimbot",           -- label
    function(state)            -- callback  (state = true/false)
        print("Aimbot:", state)
        -- put your aimbot enable/disable logic here
    end,
    false                      -- default value
)

AimbotSection.Component("Slider",
    "Aimbot FOV",              -- label
    10,                        -- min
    500,                       -- max
    false,                     -- float? (false = integers only)
    function(value)            -- callback
        print("FOV set to:", value)
    end,
    120                        -- default value
)

AimbotSection.Component("Dropdown",
    "Aim Part",                -- label
    {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},  -- options
    false,                     -- multi-select?
    function(choice, selected) -- callback
        print("Aim part selected:", choice)
    end
)

-- Section: Silent Aim
local SilentSection = CombatPage.Section("Silent Aim")

SilentSection.Component("Toggle",
    "Enable Silent Aim",
    function(state)
        print("Silent Aim:", state)
    end,
    false
)

SilentSection.Component("Slider",
    "Silent Aim Chance (%)",
    0, 100, false,
    function(value)
        print("Silent Aim chance:", value .. "%")
    end,
    75
)

-- ============================================================
--  PAGE 2 — Movement
-- ============================================================
local MovePage = Window.Page("Movement", "11342940832")

local SpeedSection = MovePage.Section("Speed")

SpeedSection.Component("Card",
    "Speed",
    "Modify your character walk and fly speed."
)

SpeedSection.Component("Toggle",
    "Speed Hack",
    function(state)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = state and 50 or 16
            end
        end
    end,
    false
)

SpeedSection.Component("Slider",
    "Walk Speed",
    16, 200, false,
    function(value)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = value end
        end
    end,
    16
)

SpeedSection.Component("Slider",
    "Jump Power",
    50, 500, false,
    function(value)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = value end
        end
    end,
    50
)

local FlySection = MovePage.Section("Fly")

FlySection.Component("Toggle",
    "Enable Fly",
    function(state)
        print("Fly:", state)
        -- put your fly logic here
    end,
    false
)

FlySection.Component("Slider",
    "Fly Speed",
    10, 300, false,
    function(value)
        print("Fly speed:", value)
    end,
    60
)

-- ============================================================
--  PAGE 3 — Visual
-- ============================================================
local VisualPage = Window.Page("Visual", "11342940570")

local EspSection = VisualPage.Section("ESP")

EspSection.Component("Card",
    "ESP",
    "Renders boxes, names, and health bars over players."
)

EspSection.Component("Toggle",
    "Player ESP",
    function(state)
        print("Player ESP:", state)
    end,
    false
)

EspSection.Component("Toggle",
    "Show Names",
    function(state)
        print("Show Names:", state)
    end,
    true
)

EspSection.Component("Toggle",
    "Show Health",
    function(state)
        print("Show Health:", state)
    end,
    true
)

EspSection.Component("Dropdown",
    "ESP Style",
    {"Box", "Outline", "Chams", "Skeleton"},
    false,
    function(choice)
        print("ESP style:", choice)
    end
)

-- ============================================================
--  PAGE 4 — Misc
-- ============================================================
local MiscPage = Window.Page("Misc", "11342940120")

local UtilSection = MiscPage.Section("Utilities")

UtilSection.Component("Card",
    "Utilities",
    "General-purpose tools and toggles."
)

UtilSection.Component("Toggle",
    "Infinite Jump",
    function(state)
        local UIS = game:GetService("UserInputService")
        if state then
            _G.InfJump = game:GetService("UserInputService").JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState("Jumping") end
                end
            end)
        else
            if _G.InfJump then
                _G.InfJump:Disconnect()
                _G.InfJump = nil
            end
        end
    end,
    false
)

UtilSection.Component("Toggle",
    "No Clip",
    function(state)
        _G.NoClip = state
        if state then
            _G.NoClipConn = game:GetService("RunService").Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if _G.NoClipConn then
                _G.NoClipConn:Disconnect()
                _G.NoClipConn = nil
            end
        end
    end,
    false
)

UtilSection.Component("Button",
    "Rejoin Server",
    function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId)
    end
)

UtilSection.Component("Button",
    "Copy Game ID",
    function()
        setclipboard(tostring(game.PlaceId))
        print("Copied Game ID:", game.PlaceId)
    end
)

local MultiSection = MiscPage.Section("Multi-Select Example")

MultiSection.Component("Dropdown",
    "Select Features",
    {"Speed", "Jump", "Fly", "NoClip", "ESP"},
    true,                                  -- multi-select = true
    function(choice, selected)
        print(choice, "->", selected)
    end
)
