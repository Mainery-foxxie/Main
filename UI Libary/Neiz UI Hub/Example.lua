local Neizgay = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Neiz%20UI%20Hub/Source.lua"))()

_G.SetTitle("Neiz Hub")

getgenv().AutoFarm = false
getgenv().AutoJump = false

_G.AddButton({
    Text = "Print Username",

    Callback = function()
        print(game.Players.LocalPlayer.Name)
    end
})

_G.AddToggle({
    Text = "Auto Farm",
    Default = false,
    Delay = 1,

    Callback = function(v)
        getgenv().AutoFarm = v
        print("Auto Farm:", v)
    end
})

_G.AddToggle({
    Text = "Auto Jump",
    Default = false,
    Delay = 0.5,

    Callback = function(v)
        getgenv().AutoJump = v
        print("Auto Jump:", v)
    end
})

_G.AddTextbox({
    Text = "WalkSpeed",
    Placeholder = "Type speed",

    Callback = function(text)
        local Humanoid =
            game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = tonumber(text) or 16
        end
    end
})

_G.AddDropdown({
    Text = "Teleport",

    List = {
        "Spawn",
        "Shop",
        "Finish"
    },

    Callback = function(v)
        local HRP =
            game.Players.LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if not HRP then
            return
        end

        if v == "Spawn" and workspace:FindFirstChild("SpawnLocation") then
            HRP.CFrame = workspace.SpawnLocation.CFrame
        end

        if v == "Shop" and workspace:FindFirstChild("Shop") then
            HRP.CFrame = workspace.Shop.CFrame
        end

        if v == "Finish" and workspace:FindFirstChild("Finish") then
            HRP.CFrame = workspace.Finish.CFrame
        end
    end
})

_G.AddSlider({
    Text = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,

    Callback = function(v)
        local Humanoid =
            game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

        if Humanoid then
            Humanoid.JumpPower = v
        end
    end
})

task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoFarm then
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    workspace.Finish.CFrame
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoJump then
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.Jump = true
            end)
        end
    end
end)
