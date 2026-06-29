-- open source enjoy skidding
local coreGui = game:GetService("CoreGui")
if coreGui:FindFirstChild("ToraScript") then
    coreGui.ToraScript:Destroy()
end

local ToraLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zaikonurami/ToraScript/refs/heads/main/test", true))()
local Window = ToraLib:CreateWindow("WimbleWorld Tennis")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

_G.Ball = false
_G.Straw = false

local function findNearestBall()
    local nearestBall = nil
    local minDist = math.huge

    for _, court in pairs(Workspace.Courts:GetChildren()) do
        for _, descendant in pairs(court:GetDescendants()) do
            if descendant.Name:match("^ClientBall_") and descendant.Ball then
                local ball = descendant.Ball
                if ball.Position.Y < 3 then
                    local dist = (HumanoidRootPart.Position - ball.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearestBall = ball
                    end
                end
            end
        end
    end

    return nearestBall
end

local function autoBallTask()
    while _G.Ball do
        local targetBall = findNearestBall()
        if targetBall then
            HumanoidRootPart.CFrame = CFrame.new(targetBall.Position)
        end
        task.wait(0.1)
    end
end

local function strawberryTask()
    while _G.Straw do
        task.wait()
        pcall(function()
            for _, obstacle in pairs(Workspace.Src.RunwayRamble.World.RunwayRambleArena.Code.Obstacles:GetDescendants()) do
                if obstacle.Name == "Ball" then
                    obstacle.CFrame = Workspace.Src.RunwayRamble.World.RunwayRambleArena.Code.DebrisKillZone.CFrame
                end
            end

            for _, pickup in pairs(Workspace.Src.RunwayRamble.World.RunwayRambleArena.Code.Pickups:GetDescendants()) do
                if pickup.Name == "TouchCollider" and pickup.CFrame.Position.X > 1430 then
                    HumanoidRootPart.CFrame = CFrame.new(pickup.Position)
                    task.wait()
                end
            end
        end)
    end
end

Window:AddToggle({
    text = "Auto Ball",
    flag = "toggle",
    state = false,
    callback = function(value)
        _G.Ball = value
        print("Auto Ball:", value)
        if value then
            task.spawn(autoBallTask)
        end
    end,
})

Window:AddButton({
    text = "NOTE !!",
    flag = "button",
    callback = function()
        StarterGui:SetCore("SendNotification", {
            Title = "NOTE",
            Text = "Take control of your own direction",
            Duration = 10,
        })
    end,
})

Window:AddButton({
    text = "Collect ScavengerHunt",
    flag = "button",
    callback = function()
        for _, obj in pairs(Workspace.ScavengerHunt.Day1.Objects:GetDescendants()) do
            if obj:IsA("TouchTransmitter") then
                HumanoidRootPart.CFrame = CFrame.new(obj.Parent.Position)
                task.wait(1)
            end
        end
    end,
})

Window:AddButton({
    text = "Auto Lawn",
    flag = "button",
    callback = function()
        HumanoidRootPart.CFrame = Workspace.NEWLayout.LOC.LawnMowerChallenge.NormalGame.MowerGiver.MowerGiver.CFrame
        task.wait(0.2)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.2)

        for _, tile in pairs(Workspace.NEWLayout.LOC.LawnMowerChallenge.MowingCourt1.Grass:GetDescendants()) do
            if tile.Name == "GrassTile" then
                local targetCFrame = CFrame.new(tile.Position) * CFrame.new(0, 4, 5)
                local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.1), { CFrame = targetCFrame })
                tween:Play()
                tween.Completed:Wait()
            end
        end
    end,
})

Window:AddToggle({
    text = "Collect Strawberries",
    flag = "toggle",
    state = false,
    callback = function(value)
        _G.Straw = value
        print("Strawberries:", value)
        if value then
            task.spawn(strawberryTask)
        end
    end,
})

Window:AddLabel({
    text = "UwU",
})

ToraLib:Init()
