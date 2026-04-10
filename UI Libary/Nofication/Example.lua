--loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/Bocus%20Move.lua"))()
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
Notify:Notify({
    Title = "Adonis Not Found",
    Description = "Adonis wasn't found in this game. Continue anyway?",
}, {
    OutlineColor = Color3.fromRGB(0, 0, 255),
    Time = 10,
    Type = "option", -- Required for Yes/No buttons
}, {
    Callback = function(choice)
        if choice then
            Notify:Notify({
                Title = "Confirmed",
                Description = "Continuing execution...",
            }, {
                OutlineColor = Color3.fromRGB(0, 170, 0),
                Time = 3,
                Type = "default",
            })
            
            print("User selected YES") 
        else
            Notify:Notify({
                Title = "Cancelled",
                Description = "Execution stopped.",
            }, {
                OutlineColor = Color3.fromRGB(255, 0, 0),
                Time = 3,
                Type = "default",
            })
            
            print("User selected NO") 
        end
    end
})
