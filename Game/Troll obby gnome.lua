-- this script made by chatgpt by gubbyscriptere.luua
--==================================================
-- [Free Ugc] Gnome troll obby
--==================================================

if not game:IsLoaded() then game.Loaded:Wait() end

---------------- GUI ----------------
local RyuuTrace = loadstring(game:HttpGet("https://raw.githubusercontent.com/RyuuSecretLua/RyuuTraceLibrary.Lua.TxT.UwU/refs/heads/main/ExecuterLibrary/WorkAllExe/RyuuTrace/UwU"))()

local Window = RyuuTrace.NewWindow({
    Title = "[Free Ugc] Gnome troll obby",
    Subtitle = "Teleport Helper",
    LoadTitle = "[Free Ugc] Gnome troll obby",
    LoadSubtitle = "Easy UGC 🤑",
    Icon = "😎",
})

local MainTab = Window:NewTab("Main")

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

---------------- TELEPORT FUNCTION ----------------

local function TeleportClearStage()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hrp and workspace:FindFirstChild("ClearStage25") then
        hrp.CFrame = workspace.ClearStage25.CFrame + Vector3.new(0,3,0)
    end
end

---------------- BUTTON ----------------

MainTab:AddButton("TP ClearStage25",function()
    TeleportClearStage()
end)
MainTab:AddButton("removed cooldown pp",function()
    for _, v in next, workspace:GetDescendants() do
        if v:IsA("ProximityPrompt") then
            v.HoldDuration = 0
        end
    end
end) 
