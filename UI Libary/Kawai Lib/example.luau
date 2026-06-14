local Env = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Kawai%20Lib/Source.luau", true))()

Env.Config:Init({
	Folder = "KawaiConfig",
	File = "default",
	AutoLoad = true,
	AutoSave = true,
})
-- Window
local Window = Env:Window({
	Title = "Nong Khaw",
	Desc  = "- Project",
	Logo  = 128185233852701,
})

-- Tabs
local General  = Window:Add({ Title = "General",  Desc = "General features",   Banner = 101849161408766 })
local Combat   = Window:Add({ Title = "Combat",   Desc = "Combat options",     Banner = 112935442242481 })
local Visual   = Window:Add({ Title = "Visual",   Desc = "Visual & ESP",       Banner = 123257335719276 })
local Misc     = Window:Add({ Title = "Misc",     Desc = "Miscellaneous",      Banner = 84034775913393  })
local Settings = Window:Add({ Title = "Settings", Desc = "Config & keybinds",  Banner = 72210587662292  })

-- ══════════════════════════════════════════
--               GENERAL TAB
-- ══════════════════════════════════════════
local GenL = General:Section({ Title = "Player",  Side = "l" })
local GenR = General:Section({ Title = "World",   Side = "r" })

GenL:Toggle({
	Title    = "God Mode",
	Desc     = "Take no damage",
	Icon     = 94911502105059,
	Value    = false,
	Callback = function(v) print("GodMode:", v) end,
})

GenL:Toggle({
	Title    = "Infinite Jump",
	Value    = false,
	Callback = function(v)
		local UIS = game:GetService("UserInputService")
		local char = game.Players.LocalPlayer.Character
		if v then
			UIS.JumpRequest:Connect(function()
				if char and char:FindFirstChild("Humanoid") then
					char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		end
	end,
})

GenL:Slider({
	Title    = "Walk Speed",
	Min      = 16,
	Max      = 500,
	Value    = 16,
	Rounding = 0,
	CallBack = function(v)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = v
		end
	end,
})

GenL:Slider({
	Title    = "Jump Power",
	Min      = 50,
	Max      = 500,
	Value    = 50,
	Rounding = 0,
	CallBack = function(v)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.JumpPower = v
		end
	end,
})

GenR:Toggle({
	Title    = "Fullbright",
	Desc     = "Max brightness",
	Value    = false,
	Callback = function(v)
		game:GetService("Lighting").Brightness = v and 10 or 2
	end,
})

GenR:Toggle({
	Title    = "No Fog",
	Desc     = "Remove atmosphere fog",
	Value    = false,
	Callback = function(v)
		local atm = game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere")
		if atm then atm.Density = v and 0 or 0.395 end
	end,
})

GenR:Dropdown({
	Title    = "Game Speed",
	List     = { "0.5x", "1x", "2x", "3x", "5x" },
	Value    = "1x",
	Callback = function(v)
		local speeds = { ["0.5x"]=0.5, ["1x"]=1, ["2x"]=2, ["3x"]=3, ["5x"]=5 }
		game:GetService("RunService").Stepped:Wait()
		workspace.DistributedGameTime = speeds[v] or 1
	end,
})

GenR:ThumnailsImage({
	Banner = 138127867432976,
	SizeY  = 110,
})

-- ══════════════════════════════════════════
--               COMBAT TAB
-- ══════════════════════════════════════════
local CombatL = Combat:Section({ Title = "Aimbot",   Side = "l" })
local CombatR = Combat:Section({ Title = "Weapon",   Side = "r" })

local aimbotEnabled = false
local aimbotPart    = "Head"
local aimbotFOV     = 90

CombatL:Toggle({
	Title    = "Aimbot",
	Desc     = "Auto-aim at nearest player",
	Icon     = 94911502105059,
	Value    = false,
	Callback = function(v) aimbotEnabled = v end,
})

CombatL:Slider({
	Title    = "Aim FOV",
	Min      = 10,
	Max      = 360,
	Value    = 90,
	Rounding = 0,
	CallBack = function(v) aimbotFOV = v end,
})

CombatL:Dropdown({
	Title    = "Aim Part",
	List     = { "Head", "HumanoidRootPart", "Torso" },
	Value    = "Head",
	Callback = function(v) aimbotPart = v end,
})

CombatL:Keybind({
	Title    = "Aimbot Key",
	Key      = Enum.KeyCode.Q,
	Value    = false,
	Callback = function(key, value)
		print("AimbotKey:", key, value)
	end,
})

CombatR:Toggle({
	Title    = "Silent Aim",
	Desc     = "Bullets snap to target",
	Value    = false,
	Callback = function(v) print("SilentAim:", v) end,
})

CombatR:Toggle({
	Title    = "Rapid Fire",
	Desc     = "Remove fire rate delay",
	Value    = false,
	Callback = function(v) print("RapidFire:", v) end,
})

CombatR:Slider({
	Title    = "Hit Chance (%)",
	Min      = 0,
	Max      = 100,
	Value    = 100,
	Rounding = 0,
	CallBack = function(v) print("HitChance:", v) end,
})

-- ══════════════════════════════════════════
--               VISUAL TAB
-- ══════════════════════════════════════════
local VisL = Visual:Section({ Title = "ESP",    Side = "l" })
local VisR = Visual:Section({ Title = "Chams",  Side = "r" })

VisL:Toggle({
	Title    = "Player ESP",
	Desc     = "Boxes around players",
	Value    = false,
	Callback = function(v) print("PlayerESP:", v) end,
})

VisL:Toggle({
	Title    = "Name ESP",
	Desc     = "Names above heads",
	Value    = false,
	Callback = function(v) print("NameESP:", v) end,
})

VisL:Toggle({
	Title    = "Health Bar",
	Value    = false,
	Callback = function(v) print("HealthBar:", v) end,
})

VisL:Slider({
	Title    = "ESP Distance",
	Min      = 50,
	Max      = 2000,
	Value    = 500,
	Rounding = 0,
	CallBack = function(v) print("ESPDist:", v) end,
})

VisR:Toggle({
	Title    = "Chams",
	Desc     = "See players through walls",
	Value    = false,
	Callback = function(v) print("Chams:", v) end,
})

VisR:Dropdown({
	Title    = "Chams Style",
	List     = { "Flat", "Neon", "Glass" },
	Value    = "Flat",
	Callback = function(v) print("ChamsStyle:", v) end,
})

VisR:Label({ Title = "More visual options coming soon" })

-- ══════════════════════════════════════════
--               MISC TAB
-- ══════════════════════════════════════════
local MiscL = Misc:Section({ Title = "Actions",  Side = "l" })
local MiscR = Misc:Section({ Title = "Info",     Side = "r" })

MiscL:Button({
	Title    = "Rejoin Server",
	Callback = function()
		local TS = game:GetService("TeleportService")
		TS:Teleport(game.PlaceId, game.Players.LocalPlayer)
	end,
})

MiscL:Button({
	Title    = "Copy Game ID",
	Desc     = "Copy current Place ID",
	Icon     = 139073550150476,
	Callback = function()
		pcall(setclipboard, tostring(game.PlaceId))
	end,
})

MiscL:Textbox({
	Value        = "",
	PlaceHolder  = "Player name to teleport to...",
	ClearOnFocus = true,
	Callback     = function(v)
		local target = game.Players:FindFirstChild(v)
		if target and target.Character then
			local char = game.Players.LocalPlayer.Character
			if char then
				char:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame)
			end
		end
	end,
})

MiscL:Keybind({
	Title    = "Hide UI (F2)",
	Key      = Enum.KeyCode.F2,
	Value    = false,
	Callback = function(key, value)
		print("HideUI toggled:", value)
	end,
})

MiscR:Discord("discord.gg/kawai")
MiscR:Line()
MiscR:Paragarp({
	Title = "About Kawai Lib",
	Desc  = "A lightweight Roblox UI library with smooth animations, config save/load, flag system, and all the elements you need. Made by Nong Khaw.",
})
MiscR:Line()
MiscR:Paragarp({
	Title = "Changelog v2",
	Desc  = "Added config system with save/load flags, fixed text scaling for long text, added Flag= to Toggle/Slider/Dropdown/Textbox/Keybind.",
})

-- ══════════════════════════════════════════
--              SETTINGS TAB
-- ══════════════════════════════════════════
local SetL = Settings:Section({ Title = "Config",      Side = "l" })
local SetR = Settings:Section({ Title = "Preferences", Side = "r" })

SetL:Button({
	Title    = "Save Config",
	Desc     = "Save all settings to disk",
	Icon     = 139073550150476,
	Callback = function()
		Env.Config:Save()
		print("Config saved!")
	end,
})

SetL:Button({
	Title    = "Load Config",
	Desc     = "Load settings from disk",
	Icon     = 139073550150476,
	Callback = function()
		Env.Config:Load()
		print("Config loaded!")
	end,
})

SetL:Button({
	Title    = "Reset Config",
	Desc     = "Delete saved config file",
	Icon     = 139073550150476,
	Callback = function()
		Env.Config:Delete()
		print("Config deleted!")
	end,
})

SetL:Textbox({
	Value        = "default",
	PlaceHolder  = "Config slot name...",
	ClearOnFocus = false,
	Callback     = function(v)
		Env.Config:Save(v)
		print("Saved to slot:", v)
	end,
})

SetR:Toggle({
	Title    = "Auto Save",
	Desc     = "Save config every 30 seconds",
	Value    = false,
	Callback = function(v)
		if v then
			task.spawn(function()
				while v do
					task.wait(30)
					Env.Config:Save()
				end
			end)
		end
	end,
})

SetR:Line()

SetR:Label({ Title = "Kawai Lib v2 — Nong Khaw" })
