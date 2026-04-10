loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/Bocus%20Move.lua"))()
local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/BocusLuke.lua"))()

local NEW_ASSET_ID = "http://www.roblox.com/asset/?id=8904334671"
local VIDEO_ASSET_ID = "rbxassetid://9478562327"

Notify:Notify({
    Title = "Error...",
    Description = "Adonis wasn't found in this game",
}, {
    OutlineColor = Color3.fromRGB(0, 0, 255),
    Time = 5,
    Type = "image",
}, {
    Image = NEW_ASSET_ID,
    ImageColor = Color3.fromRGB(255, 255, 255),
})
