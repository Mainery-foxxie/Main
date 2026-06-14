# 🌸 Kawai Lib v2

A lightweight, animated Roblox UI library with a built-in config system, notification toasts, and smooth Kawai-style aesthetics.

---

## 📦 Load

```lua
local Env = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Kawai%20Lib/Source.luau", true))()
```

---

## 🏗️ Structure

```
Env:Window()          →  Window  (Env.Tabs)
  Window:Add()        →  Tab     (Env.Section)
    Tab:Section()     →  Section (Env._Class)
      Section:*()     →  Element
```

---

## 🪟 Window

```lua
local Window = Env:Window({
    Title = "My Script",
    Desc  = "by me",
    Logo  = 128185233852701,  -- rbxassetid number
})
```

---

## 📑 Tab

```lua
local Tab = Window:Add({
    Title  = "General",
    Desc   = "Main features",
    Banner = 101849161408766,  -- rbxassetid number
})
```

---

## 📂 Section

```lua
local Section = Tab:Section({
    Title = "Player",
    Side  = "l",   -- "l" = left column, "r" = right column
})
```

---

## 🧩 Elements

### Button

```lua
-- Simple
Section:Button({
    Title    = "Click Me",
    Callback = function() end,
})

-- With icon + description
Section:Button({
    Title    = "Do Something",
    Desc     = "This does something",
    Icon     = 139073550150476,
    Callback = function() end,
})
```

**Methods:**
```lua
local btn = Section:Button({ ... })
btn:Fire()          -- trigger callback
btn:UpdateTitle(v)  -- change label text
btn:Visible(bool)   -- show/hide
```

---

### Toggle

```lua
Section:Toggle({
    Title    = "God Mode",
    Desc     = "Optional description",   -- omit for centered title
    Icon     = 94911502105059,           -- optional
    Value    = false,
    Flag     = "GodMode",               -- optional, auto-saves to config
    Callback = function(v) end,
})
```

**Methods:**
```lua
local t = Section:Toggle({ ... })
t:Value(bool)    -- set state
t:Icon(id)       -- change icon
t:Visible(bool)
```

---

### Slider

```lua
Section:Slider({
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 500,
    Value    = 16,
    Rounding = 0,       -- decimal places
    Flag     = "WalkSpeed",
    CallBack = function(v) end,
})
```

**Methods:**
```lua
local s = Section:Slider({ ... })
s:SetValue(n)
s:SetTitle("New Title")
s:SetVisible(bool)
```

---

### Dropdown

```lua
-- Single select
Section:Dropdown({
    Title    = "Team",
    List     = { "Red", "Blue", "Green" },
    Value    = "Red",
    Flag     = "Team",
    Callback = function(v) end,
})

-- Multi select
Section:Dropdown({
    Title    = "Items",
    List     = { "Sword", "Shield", "Bow" },
    Value    = { "Sword" },
    Multi    = true,
    Flag     = "Items",
    Callback = function(v) end,
})
```

**Methods:**
```lua
local d = Section:Dropdown({ ... })
d:Clear()           -- remove all items
d:AddList("Name")   -- add one item
```

---

### Textbox

```lua
Section:Textbox({
    Value        = "default text",
    PlaceHolder  = "Type here...",
    ClearOnFocus = false,
    Flag         = "MyText",
    Callback     = function(v) end,
})
```

**Methods:**
```lua
local tb = Section:Textbox({ ... })
tb:Title(v)
tb:Desc(v)
tb:Visible(bool)
```

---

### Keybind

```lua
Section:Keybind({
    Title    = "Toggle UI",
    Key      = Enum.KeyCode.F2,
    Value    = false,
    Flag     = "UIKey",
    Callback = function(key, value) end,
})
```

> Callback fires with `(KeyCode, bool)` — `bool` is the toggled state each press.

---

### Label

```lua
Section:Label({
    Title = "Some info text",
    Side  = "l",   -- "l" left, "c" center, "r" right
})
```

---

### Line

```lua
Section:Line()
```

---

### Discord

```lua
Section:Discord("discord.gg/yourserver")
```

---

### Paragraph

```lua
Section:Paragarp({
    Title = "Heading",
    Desc  = "Long description text that wraps automatically.",
})
```

---

### Thumbnail Image

```lua
Section:ThumnailsImage({
    Banner = 138127867432976,
    SizeY  = 110,   -- height in pixels
})
```

---

## 💾 Config System

### Init (call once at the top)

```lua
Env.Config:Init({
    Folder   = "KawaiConfig",   -- folder name on disk
    File     = "default",       -- save slot name
    AutoLoad = true,            -- load on init
    AutoSave = true,            -- save instantly on every flag change
})
```

### Save / Load / Delete

```lua
Env.Config:Save()           -- save to default slot
Env.Config:Save("slot2")    -- save to named slot
Env.Config:Load()           -- load from default slot
Env.Config:Load("slot2")    -- load from named slot
Env.Config:Delete()         -- delete default slot
Env.Config:ListFiles()      -- returns { "default", "slot2", ... }
```

> All three show a notification automatically on success or failure.

### Read / Write flags manually

```lua
Env.Config:GetFlag("GodMode")
Env.Config:SetFlag("GodMode", true)

-- shorthand (global table)
KawaiFlags.GodMode          -- read
KawaiFlags.GodMode = true   -- write
```

### Listen to flag changes

```lua
local disconnect = Env.Config:OnFlagChanged("GodMode", function(v)
    print("GodMode is now:", v)
end)

disconnect()   -- stop listening
```

### Using Flag= in elements

Any element that supports `Flag` will:
1. Read the saved value on load and apply it as the default
2. Write to config automatically whenever the value changes

```lua
Section:Toggle({
    Title    = "ESP",
    Value    = false,
    Flag     = "ESP",        -- ← that's all you need
    Callback = function(v) end,
})
```

---

## 🔔 Notifications

```lua
Env.Notify({
    Title    = "Hello",
    Desc     = "Optional subtitle",    -- omit for single-line
    Type     = "success",              -- "info" | "success" | "error" | "warning"
    Duration = 3,                      -- seconds (default 3)
    Icon     = 123456789,              -- optional custom rbxassetid
})
```

### With buttons

```lua
Env.Notify({
    Title    = "Delete config?",
    Desc     = "This cannot be undone",
    Type     = "warning",
    Duration = 0,            -- 0 = stays open until a button is clicked
    Buttons  = {
        {
            Title    = "Yes",
            Primary  = true,           -- gets gradient accent color
            Callback = function()
                Env.Config:Delete()
            end,
        },
        {
            Title    = "Cancel",
            Callback = function() end,
        },
    },
})
```

### Types & colors

| Type | Color |
|------|-------|
| `"info"` | Blue → Purple |
| `"success"` | Green → Blue |
| `"error"` | Red → Dark Red |
| `"warning"` | Yellow → Orange |

> Notifications slide in from the right with a Back easing spring animation, stack from bottom-right, and have a gradient progress bar that drains over the duration.

---

## 📋 Full Example

```lua
local Env = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Kawai%20Lib/Source.luau", true))()

Env.Config:Init({
    Folder   = "KawaiConfig",
    File     = "default",
    AutoLoad = true,
    AutoSave = true,
})

local Window = Env:Window({
    Title = "My Script",
    Desc  = "v1.0",
})

local General  = Window:Add({ Title = "General",  Desc = "Main",    Banner = 101849161408766 })
local Settings = Window:Add({ Title = "Settings", Desc = "Config",  Banner = 72210587662292  })

local Left  = General:Section({ Title = "Player", Side = "l" })
local Right = General:Section({ Title = "World",  Side = "r" })

Left:Toggle({
    Title    = "God Mode",
    Desc     = "Take no damage",
    Icon     = 94911502105059,
    Value    = false,
    Flag     = "GodMode",
    Callback = function(v)
        -- your code
    end,
})

Left:Slider({
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 500,
    Value    = 16,
    Rounding = 0,
    Flag     = "WalkSpeed",
    CallBack = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end,
})

Left:Keybind({
    Title    = "Noclip",
    Key      = Enum.KeyCode.N,
    Value    = false,
    Flag     = "NoclipKey",
    Callback = function(key, value) end,
})

Right:Dropdown({
    Title    = "Team",
    List     = { "Red", "Blue", "Green" },
    Value    = "Red",
    Flag     = "Team",
    Callback = function(v) end,
})

Right:Toggle({
    Title    = "Fullbright",
    Value    = false,
    Flag     = "Fullbright",
    Callback = function(v)
        game:GetService("Lighting").Brightness = v and 10 or 2
    end,
})

local SetL = Settings:Section({ Title = "Config", Side = "l" })

SetL:Button({
    Title    = "Save Config",
    Icon     = 139073550150476,
    Callback = function()
        Env.Config:Save()
    end,
})

SetL:Button({
    Title    = "Reset Config",
    Icon     = 139073550150476,
    Callback = function()
        Env.Notify({
            Title    = "Reset Config?",
            Desc     = "All settings will be lost",
            Type     = "warning",
            Duration = 0,
            Buttons  = {
                { Title = "Yes", Primary = true, Callback = function() Env.Config:Delete() end },
                { Title = "No" },
            },
        })
    end,
})
```
