local success, PromptLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Prompt%20ui/Source.lua"))()
end)

if success and PromptLib then
    print("PromptLib loaded successfully:", PromptLib)

    local playerName = game.Players.LocalPlayer.Name

    PromptLib(
        "Hello " .. playerName .. ".", 
        "Welcome To Velocity X! This Script Source By furry Keyless Version cracked Enjoy When Using! ",
        {
            {
                Text = "Copy Discord server",
                LayoutOrder = 1,
                Primary = true,
                Callback = function()
                warn("pretty") 
                end
            },
            {
                Text = "Closed",
                LayoutOrder = 2,
                Primary = false,
                Callback = function()
                    print(" Hello world ") 
                end
            }
        }
    )
else
    warn("Failed to load PromptLib.")
end
