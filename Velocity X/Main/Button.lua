task.spawn(function()
    while task.wait() do
        pcall(function()
            local player = game.Players.LocalPlayer
            local c = player.Character or player.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")

            for _, p in ipairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Enabled then
                    local parent = p.Parent
                    if parent and parent:IsA("BasePart") then
                        h.CFrame = parent.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1) 
                        fireproximityprompt(p)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            local player = game.Players.LocalPlayer
            local c = player.Character or player.CharacterAdded:Wait()
            local h = c:FindFirstChildOfClass("Humanoid")

            if h and h.Health <= 70 then
                player:Kick("hi")
                game:GetService("TeleportService"):Teleport(
                    game.PlaceId,
                    player
                )
            end
        end)
    end
end)

wait(1) 
task.spawn(function()
    while task.wait() do
        pcall(function()
            wait(1) 
            local player = game.Players.LocalPlayer
            player:Kick("hi")
            game:GetService("TeleportService"):Teleport(
                game.PlaceId,
                player
            )
        end)
    end
end)
