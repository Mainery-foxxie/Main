local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Neiz%20UI%20Hub/Source.lua"))()

_G.AddButton({
    Text = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(
            game.PlaceId,
            game.Players.LocalPlayer
        )
    end
})

_G.AddButton({
    Text = "Copy Discord",
    Callback = function()
        setclipboard("https://discord.gg/example")
    end
})

_G.AddDropdown({
    Text = "Select WalkSpeed",
    List = {
        16,
        50,
        100,
        200
    },

    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

_G.AddDropdown({
    Text = "Select Place",
    List = {
        "Spawn",
        "Shop",
        "Finish"
    },

    Callback = function(v)
        if v == "Spawn" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                workspace.SpawnLocation.CFrame
        end

        if v == "Shop" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                workspace.Shop.CFrame
        end

        if v == "Finish" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                workspace.Finish.CFrame
        end
    end
})

_G.AddSlider({
    Text = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,

    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
    end
})

_G.AddSlider({
    Text = "Tween Speed",
    Min = 50,
    Max = 500,
    Default = 100,

    Callback = function(v)
        getgenv().TweenSpeed = v
    end
})
