-- Load UI Library (Kawai Lib)
local Env = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Kawai%20Lib/Source.luau", true))()

local Banner = {
    Combat = 112935442242481
}

local Window = Env:Window({
    Title = "Velocity X",
    Desc = "Shark Bite 2"
})

local CombatTab = Env.Tabs:Add({
    Title = "Combat",
    Desc = "Shark Bite 2 Combat",
    Banner = Banner.Combat
})

local Section1 = CombatTab:Section({
    Title = "Combat",
    Side = "l"
})

local Section = CombatTab:Section({
    Title = "Free UGC",
    Side = "r"
})

-- Services & Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local hrp

local remote = nil
local sharkName = nil

local remotesFolder = ReplicatedStorage:WaitForChild("Projectiles"):WaitForChild("Events"):WaitForChild("Weapons"):WaitForChild("remotes")

local function hookRemote(remoteObject)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if self == remoteObject and (method == "FireServer" or method == "InvokeServer") then
            remote = self.Name
        end
        return oldNamecall(self, ...)
    end)
end

for _, child in ipairs(remotesFolder:GetChildren()) do
    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
        pcall(hookRemote, child)
    end
end

local afk = player.PlayerScripts:FindFirstChild("AFK")
if afk then afk:Destroy() end

local hud = player.PlayerScripts:FindFirstChild("HUD")
if hud then
    local oxygen = hud:FindFirstChild("Oxygen")
    if oxygen then oxygen:Destroy() end
end

local function updateHRP()
    character = player.Character or player.CharacterAdded:Wait()
    backpack = player:WaitForChild("Backpack")
    hrp = character:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(updateHRP)
if player.Character then updateHRP() end

local function getShark()
    local sharksFolder = workspace:FindFirstChild("Sharks")
    if sharksFolder then
        for _, shark in ipairs(sharksFolder:GetChildren()) do
            if shark:IsA("Model") then
                sharkName = shark.Name
                return
            end
        end
    end
    sharkName = nil
end

local function KillShark()
    for _ = 1, 20 do
        if sharkName and remote then
            local shark = workspace:WaitForChild("Sharks"):FindFirstChild(sharkName)
            if shark then
                remotesFolder:WaitForChild(remote):FireServer(shark, true)
            end
        end
    end
end

local runningConnection = nil

local function startAutoKill()
    if runningConnection then return end
    local angle = 0
    local speed = math.pi * 2
    local center = Vector3.new(0, -100, 0)
    local radius = 1000

    runningConnection = RunService.Heartbeat:Connect(function(dt)
        if not (player.Team and player.Team.Name == "Survivor" and hrp) then return end

        getShark()

        if not sharkName then
            Camera.CameraType = Enum.CameraType.Custom
            local chinook = workspace:FindFirstChild("Chinook")
            local interior = chinook and chinook:FindFirstChild("interior")
            if interior then
                hrp.CFrame = interior.CFrame
            end
        else
            local sharksFolder = workspace:FindFirstChild("Sharks")
            local shark = sharksFolder and sharksFolder:FindFirstChild(sharkName)
            if shark then
                local sharkPart = shark.PrimaryPart or shark:FindFirstChildWhichIsA("BasePart", true)
                if sharkPart then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = character
                        end
                    end

                    if not remote then
                        local behind = sharkPart.CFrame * CFrame.new(0, 0, 50)
                        hrp.CFrame = CFrame.new(behind.Position, sharkPart.Position)

                        Camera.CameraType = Enum.CameraType.Scriptable
                        Camera.CFrame = CFrame.new(behind.Position, sharkPart.Position)

                        local equippedTool = character:FindFirstChildOfClass("Tool")
                        if equippedTool then
                            local vp = Camera.ViewportSize
                            local cx, cy = vp.X / 2, vp.Y / 2
                            VirtualInputManager:SendMouseMoveEvent(cx, cy, game)
                            VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
                            VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
                            task.wait(1)
                        end
                    else
                        Camera.CameraType = Enum.CameraType.Custom

                        angle = angle + speed * dt
                        local t = (angle % (math.pi * 2)) / (math.pi * 2)
                        local offset
                        if t < 0.25 then
                            offset = Vector3.new(radius, 0, -radius + 8 * radius * t)
                        elseif t < 0.5 then
                            offset = Vector3.new(radius - 8 * radius * (t - 0.25), 0, radius)
                        elseif t < 0.75 then
                            offset = Vector3.new(-radius, 0, radius - 8 * radius * (t - 0.5))
                        else
                            offset = Vector3.new(-radius + 8 * radius * (t - 0.75), 0, -radius)
                        end
                        hrp.CFrame = CFrame.new(center + offset, center)

                        KillShark()
                    end
                end
            end
        end
    end)
end

local function stopAutoKill()
    if runningConnection then
        runningConnection:Disconnect()
        runningConnection = nil
    end
    Camera.CameraType = Enum.CameraType.Custom
end

local AutoWinConnection = nil
local SharksDescendantConnection = nil
local DestructionParts = {}

local function addDestructionPart(part)
    table.insert(DestructionParts, part)
    part.AncestryChanged:Connect(function(_, parent)
        if parent then return end
        for i = #DestructionParts, 1, -1 do
            if DestructionParts[i] == part then
                table.remove(DestructionParts, i)
                break
            end
        end
    end)
end

local function getNearestSurvivorToPart(part)
    local nearestPlayer, nearestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Team and plr.Team.Name == "Survivor" then
            local char = plr.Character
            local hrpTarget = char and char:FindFirstChild("HumanoidRootPart")
            if hrpTarget and not hrpTarget:FindFirstChild("Attachment") then
                local dist = (hrpTarget.Position - part.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestPlayer = plr
                end
            end
        end
    end
    return nearestPlayer
end

local function startAutoWin()
    if AutoWinConnection then return end
    local sharksFolder = workspace:FindFirstChild("Sharks")
    if sharksFolder then
        for _, d in ipairs(sharksFolder:GetDescendants()) do
            if d:IsA("BasePart") and d.Name == "DestructionPart" then
                addDestructionPart(d)
            end
        end
        SharksDescendantConnection = sharksFolder.DescendantAdded:Connect(function(desc)
            if desc:IsA("BasePart") and desc.Name == "DestructionPart" then
                addDestructionPart(desc)
            end
        end)
    end

    AutoWinConnection = RunService.Heartbeat:Connect(function()
        if not (player.Team and player.Team.Name == "Shark" and #DestructionParts > 0) then return end

        for i = #DestructionParts, 1, -1 do
            if not DestructionParts[i] or not DestructionParts[i].Parent then
                table.remove(DestructionParts, i)
            end
        end

        local count = #DestructionParts
        if count == 0 then return end

        local randomPart = DestructionParts[math.random(1, count)]
        local targetPlayer = getNearestSurvivorToPart(randomPart)
        if randomPart and targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                randomPart.CFrame = CFrame.new(targetHRP.Position)
            end
        end
    end)
end

local function stopAutoWin()
    if AutoWinConnection then
        AutoWinConnection:Disconnect()
        AutoWinConnection = nil
    end
    if SharksDescendantConnection then
        SharksDescendantConnection:Disconnect()
        SharksDescendantConnection = nil
    end
    table.clear(DestructionParts)
end

local sharkESPConnections = {}

local function setSharkESP(enabled)
    local sharksFolder = workspace:FindFirstChild("Sharks")
    if not sharksFolder then return end

    for _, conn in ipairs(sharkESPConnections) do
        conn:Disconnect()
    end
    table.clear(sharkESPConnections)

    for _, shark in ipairs(sharksFolder:GetDescendants()) do
        if shark:IsA("Highlight") then
            shark.Enabled = enabled
            shark.OutlineTransparency = enabled and 0 or 1
            if enabled then
                table.insert(sharkESPConnections, shark:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if not shark.Enabled then shark.Enabled = true end
                end))
                table.insert(sharkESPConnections, shark:GetPropertyChangedSignal("OutlineTransparency"):Connect(function()
                    if shark.OutlineTransparency ~= 0 then shark.OutlineTransparency = 0 end
                end))
            end
        end
    end
end

local function watchForNewSharks(toggleState)
    local sharksFolder = workspace:FindFirstChild("Sharks")
    if not sharksFolder then return end
    table.insert(sharkESPConnections, sharksFolder.DescendantAdded:Connect(function(desc)
        if desc:IsA("Highlight") then
            setSharkESP(toggleState)
        end
    end))
end

local VaseTouchParts = {}
local VaseConnections = {}
local VaseHeartbeat = nil

local function AddVaseTouch(part)
    table.insert(VaseTouchParts, part)
    part.AncestryChanged:Connect(function(_, parent)
        if parent then return end
        for i, v in ipairs(VaseTouchParts) do
            if v == part then
                table.remove(VaseTouchParts, i)
                break
            end
        end
    end)
end

local function startAutoVase()
    if VaseHeartbeat then return end
    local folder = workspace:FindFirstChild("Vases")
    if folder then
        for _, d in ipairs(folder:GetDescendants()) do
            if d:IsA("TouchTransmitter") then
                AddVaseTouch(d)
            end
        end
        table.insert(VaseConnections, folder.DescendantAdded:Connect(function(desc)
            if desc:IsA("TouchTransmitter") then
                AddVaseTouch(desc)
            end
        end))
    end

    VaseHeartbeat = RunService.Heartbeat:Connect(function()
        local charHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not charHRP then return end
        for _, t in ipairs(VaseTouchParts) do
            if t and t.Parent and t.Parent:IsA("BasePart") then
                local part = t.Parent
                charHRP.CFrame = part.CFrame
                firetouchinterest(charHRP, part, 0)
                firetouchinterest(charHRP, part, 1)
            end
        end
    end)
end

local function stopAutoVase()
    for _, c in ipairs(VaseConnections) do c:Disconnect() end
    table.clear(VaseConnections)
    table.clear(VaseTouchParts)
    if VaseHeartbeat then
        VaseHeartbeat:Disconnect()
        VaseHeartbeat = nil
    end
end

local walkSpeedValue = 32
local function applyWalkSpeed()
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = walkSpeedValue
    end
end
player.CharacterAdded:Connect(function()
    task.wait(0.1)
    applyWalkSpeed()
end)

local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title or "Velocity X",
        Text = text or "",
        Icon = "rbxassetid://103887859853708",
        Duration = duration or 5
    })
end

Section:Toggle({
    Title = "Auto Collect Easter Egg",
    Desc = "Auto Teleport all egg",
    Value = false,
    Callback = function(s)
        getgenv().Autocollectegg = s
        task.spawn(function()
            while getgenv().Autocollectegg and task.wait(0.1) do
                pcall(function()
                    for _,v in pairs(workspace.Eggs.Special:GetDescendants()) do
                        if v:IsA("BasePart") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0,3,0)
                            for _,x in pairs(workspace.Eggs.MaunalSpawns:GetDescendants()) do
                                if x:IsA("MeshPart") and x:FindFirstChildOfClass("TouchTransmitter") then
                                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, x, 0)
                                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, x, 1)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

Section:Toggle({
    Title = "Auto Claim UGC",
    Desc = "Claim UGC When you claimed all Egg",
    Value = false,
    Callback = function(v)
        getgenv().Didntknow = v
        task.spawn(function()
            while getgenv().Didntknow and task.wait() do
                pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("EventsFolder"):WaitForChild("SeasonalEvents"):WaitForChild("ClaimUGC"):InvokeServer()
                end)
            end
        end)
    end
})

Section1:Toggle({
    Title = "Instant Kill Shark",
    Desc = "(Do Not equip projetitle for work)",
    Value = false,
    Callback = function(v)
        if v then
            if not getrawmetatable or not setreadonly or not newcclosure then
                task.delay(0.2, function() Section1:ToggleValue("Instant Kill Shark", false) end)
                notify("Executor too weak", "Your executor does not support getrawmetatable, setreadonly, or newcclosure.", 5)
                return
            end
            startAutoKill()
        else
            stopAutoKill()
        end
    end
})

Section1:Toggle({
    Title = "Auto win as shark",
    Desc = "Teleport all player kill for fuck",
    Value = false,
    Callback = function(v)
        if v then
            startAutoWin()
        else
            stopAutoWin()
        end
    end
})

Section1:Toggle({
    Title = "Highlight sharks [ESP]",
    Desc = "see your shark sex u",
    Value = false,
    Callback = function(v)
        setSharkESP(v)
        if v then
            watchForNewSharks(v)
        end
    end
})

Section1:Toggle({
    Title = "Auto touch vases",
    Desc = "auto get nigga",
    Value = false,
    Callback = function(v)
        if v then
            startAutoVase()
        else
            stopAutoVase()
        end
    end
})

Section:Slider({
    Title = "Walk Speed (useless) why i put this",
    Min = 16,
    Max = 100,
    Value = 32,
    Rounding = 1,
    CallBack = function(v)
        walkSpeedValue = v
        applyWalkSpeed()
    end
})
applyWalkSpeed()
