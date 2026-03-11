local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Fluxus%20Lib/Source.lua"))()

local Window = Library:CreateWindow("Fluxus Lib")

local MainTab = Window:NewTab("Main")
local PlayerSection = MainTab:AddSection("Player Settings")

PlayerSection:AddButton("Print Hello", "Click to print a message", function()
    print("Hello from the button!")
end)

local ToggleExample = PlayerSection:AddToggle("Enable WalkSpeed", "Toggles walkspeed modification", false, function(state)
    print("Toggle is now:", state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

PlayerSection:AddTextBox("Set Walkspeed", "Enter a number (16-100)", "16", "50", function(value)
    local speed = tonumber(value)
    if speed then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end)

local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:AddSection("Extra Options")

local dropdown = MiscSection:AddDropdown("Choose Color", "Pick a color from the list", {
    ["Red"] = "Red",
    ["Green"] = "Green",
    ["Blue"] = "Blue"
}, "Red", function(selected)
    print("Selected color:", selected)
    game.Players.LocalPlayer.Character.HumanoidRootPart.BrickColor = BrickColor.new(selected)
end)

local slider = MiscSection:AddSlider("Jump Power", "Adjust jump height", 0, 100, 50, false, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

local ExtraTab = Window:NewTab("Extra")
local ExtraSection = ExtraTab:AddSection("Dynamic Controls")

ExtraSection:AddButton("Toggle WalkSpeed ON", "Set toggle to true", function()
    ToggleExample:SetState(true)
end)

ExtraSection:AddButton("Toggle WalkSpeed OFF", "Set toggle to false", function()
    ToggleExample:SetState(false)
end)

ExtraSection:AddButton("Update Dropdown", "Change dropdown items", function()
    dropdown:Update({
        ["Yellow"] = "Yellow",
        ["Purple"] = "Purple",
        ["Orange"] = "Orange"
    })
end)

ExtraSection:AddButton("Set Slider to 75", "", function()
    slider:SetValue(75)
end)

ExtraSection:AddButton("Print Slider Value", "", function()
    print("Current slider value:", slider:GetValue())
end)
