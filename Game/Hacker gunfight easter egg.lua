if game.PlaceId == 138227677564191 then
    game:GetService("TeleportService"):Teleport(91674800582634, game.Players.LocalPlayer)

elseif game.PlaceId == 91674800582634 then

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if workspace.Game.Fragments:FindFirstChild("FakeEggs") then
                    for _, v in pairs(workspace.Game.Fragments.FakeEggs:GetChildren()) do
                        v:Destroy()
                    end
                end

                if workspace.Game.Fragments:FindFirstChild("MasterEgg") then
                    workspace.Game.Fragments.MasterEgg:Destroy()
                end
            end)
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                for _, descendant in ipairs(workspace.Basket:GetDescendants()) do
                    if descendant:IsA("ClickDetector") then
                        fireclickdetector(descendant)
                    end
                end
            end)
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if not game:GetService("Players").LocalPlayer.Character 
                or not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                    return 
                end

                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and string.find(v.Name:lower(), "egg") then
                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.5)

                        if v:FindFirstChildOfClass("ProximityPrompt") then
                            fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                        elseif v.Parent and v.Parent:FindFirstChildOfClass("ProximityPrompt") then
                            fireproximityprompt(v.Parent:FindFirstChildOfClass("ProximityPrompt"))
                        end
                    end
                end

                if workspace.Game.Build:FindFirstChild("Activator") 
                and workspace.Game.Build.Activator:IsA("BasePart") then
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                        workspace.Game.Build.Activator.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end)

end
