local Flux = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Fluxus%20Lib/Source.lua"))()

local Window = Flux:CreateWindow("Example Hub")

local Main = Window:NewTab("Main")
local Player = Window:NewTab("Player")
local Misc = Window:NewTab("Misc")

Main:AddButton("Print Hello","Test button",function()
    print("Hello World")
end)

Main:AddToggle("Auto Farm","Example toggle",false,function(state)
    print("Auto Farm:",state)
end)

Player:AddSlider("WalkSpeed","Change speed",0,200,16,function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

Misc:AddDropdown("Select Mode","Mode selector",{
    "Normal",
    "Fast",
    "Ultra"
},function(v)
    print("Selected:",v)
end)

Misc:AddTextbox("Enter Name","Type username",function(text)
    print("Textbox value:",text)
end)
