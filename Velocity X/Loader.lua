if getgenv().Velocity_X_Loader then
    local Kawai: any = nil
    pcall(function()
        local source = game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Kawai%20Lib/Source.luau", true)
        local func = loadstring(source)
        if not func then error("Kawai Lib failed to compile") end
        Kawai = func()
    end)
    if Kawai then
        local ALWI_RED: Color3 = Color3.fromRGB(255, 80, 80)
        pcall(function()
            Kawai.Notify({
                Title = "Alwi Hub",
                Desc = "This session is already loaded. Do you want to delete the config file?",
                Type = "warning",
                Duration = 15,
                Icon = "103887859853708",
                Color = { ALWI_RED, ALWI_RED },
                Buttons = {
                    {
                        Title = "Yes, delete",
                        Primary = true,
                        Callback = function()
                            local CONFIG_FILE: string = "Alwi Hub/AlwiHub_Settings.json"
                            local deleted: boolean = false
                            if isfile and delfile then
                                pcall(function()
                                    if isfile(CONFIG_FILE) then
                                        delfile(CONFIG_FILE)
                                        deleted = true
                                        getgenv().Velocity_X_Loader = false
                                    end
                                end)
                            end
                            if deleted then
                                pcall(function()
                                    Kawai.Notify({
                                        Title = "Config Deleted",
                                        Desc = "Settings file has been removed.",
                                        Type = "success",
                                        Duration = 3,
                                        Icon = "103887859853708",
                                        Color = { ALWI_RED, ALWI_RED },
                                    })
                                end)
                            end
                        end,
                    },
                    {
                        Title = "No",
                        Callback = function()
                            pcall(function()
                                Kawai.Notify({
                                    Title = "Loader Already Running",
                                    Desc = "Alwi Hub is already active in this session.",
                                    Type = "info",
                                    Duration = 4,
                                    Icon = "103887859853708",
                                    Color = { ALWI_RED, ALWI_RED },
                                })
                            end)
                        end,
                    },
                },
            })
        end)
    else
        warn("Alwi hub is already active.")
    end
    pcall(function()
        local containers: {Instance} = {}
        local okCg: boolean, cg: any = pcall(game.GetService, game, "CoreGui")
        if okCg and typeof(cg) == "Instance" then table.insert(containers, cg) end
        local _gh: any = rawget(_G, "gethui")
        if type(_gh) == "function" then
            local okH: boolean, h: any = pcall(_gh)
            if okH and typeof(h) == "Instance" then table.insert(containers, h) end
        end
        for _, c: Instance in containers do
            for _, g: Instance in c:GetChildren() do
                if g:IsA("ScreenGui") then
                    local n: string = g.Name
                    if n == "AlwiPerfHudGui" or n == "AlwiTourGui"
                        or (type(n) == "string" and n:sub(1, 9) == "Velocity_") then
                        pcall(function() (g :: ScreenGui):Destroy() end)
                    end
                end
            end
        end
    end)
end

getgenv().Velocity_X_Loader = true

local _syn:    any = rawget(_G, "syn")
local _fluxus: any = rawget(_G, "fluxus")
local _http:   any = rawget(_G, "http")

local http_request_fn: ((req: {[string]:any}) -> {[string]:any})?
    = (rawget(_G, "http_request") or rawget(_G, "request"))
    or (_syn    and _syn.request)
    or (_fluxus and _fluxus.request)
    or (_http   and _http.request)
    or nil

local function getThumbnail(userId: number): string
    local ok, url = pcall(function()
        return game:GetService("Players"):GetUserThumbnailAsync(
            userId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)
    if ok and url and #url > 4 then
        warn(string.format("[VelocityX] Thumb URL → %s", url))
        return url
    end
    local fallback = string.format(
        "rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", userId)
    warn(string.format("[VelocityX] Thumb fallback → %s", fallback))
    return fallback
end

if not cloneref then
    local _probe: Part = Instance.new("Part")
    local _instanceList: { [any]: any }? = nil

    for _: any, _tbl: any in getreg() do
        if type(_tbl) == "table" and #_tbl >= 0 then
            if rawget(_tbl, "__mode") == "kvs" then
                for _k: any, _v: any in _tbl do
                    if _v == _probe then
                        _instanceList = _tbl
                        break
                    end
                end
            end
        end
        if _instanceList then break end
    end

    local function _invalidate(obj: Instance): Instance?
        if not _instanceList then return obj end
        for k: any, v: any in _instanceList :: { [any]: any } do
            if v == obj then
                (_instanceList :: { [any]: any })[k] = nil
                return obj
            end
        end
        return obj
    end

    getgenv().cloneref = _invalidate
end
local cloneref: (obj: any) -> any = cloneref or function(obj: any): any return obj end
local HttpService  = cloneref(game:GetService("HttpService"))
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local player       = Players.LocalPlayer

local CoreGui: Instance
if RunService:IsStudio() then
    CoreGui = player.PlayerGui
else
    CoreGui = cloneref(game:GetService("CoreGui"))
end

local icons: {[string]: string} = {}
pcall(function()
    local loaded = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/Van1a/neriumR/refs/heads/main/components/icons.lua"
    ))().assets
    if loaded and type(loaded) == "table" then icons = loaded end
end)
local function icon(name: string): string
    return icons["lucide-" .. name] or ""
end
local function makeIconLabel(parent: Instance, assetId: string, size: number, col: Color3?): ImageLabel
    local img: ImageLabel = Instance.new("ImageLabel", parent)
    img.BackgroundTransparency = 1
    img.Size        = UDim2.new(0, size, 0, size)
    img.Image       = assetId
    img.ImageColor3 = col or Color3.fromRGB(160, 160, 160)
    img.ZIndex      = 5
    return img
end

local gui: ScreenGui = Instance.new("ScreenGui")
gui.Name            = "Introvert"
gui.Parent          = CoreGui
gui.IgnoreGuiInset  = true
gui.ResetOnSpawn    = false
gui.DisplayOrder    = 999999

local sound: Sound = Instance.new("Sound")
sound.Parent  = gui
sound.SoundId = "rbxassetid://8745692251"
sound.Volume  = 2

local _earlySkipIntro: boolean = false
pcall(function()
    if readfile and isfile then
        local _cfgPath: string = "Alwi Hub/AlwiHub_Settings.json"
        if isfile(_cfgPath) then
            local _d: any = HttpService:JSONDecode(readfile(_cfgPath))
            _earlySkipIntro = _d and _d.skipIntroUI == true
        end
    end
end)

local function log()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/Log.luau"))()
    end)
end

task.spawn(function()
    log()
end)
if not _earlySkipIntro then
    sound:Play()

    local bg: Frame = Instance.new("Frame")
    bg.Parent           = gui
    bg.Size             = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BorderSizePixel  = 0

    local image: ImageLabel = Instance.new("ImageLabel")
    image.Parent             = gui
    image.BackgroundTransparency = 1
    image.Image              = "rbxassetid://103887859853708"
    image.Size               = UDim2.new(0, 0, 0, 0)
    image.Position           = UDim2.new(0.5, 0, 0.5, 0)
    image.AnchorPoint        = Vector2.new(0.5, 0.5)
    image.ImageTransparency  = 1
    image.Rotation           = -180
    image.ZIndex             = 5

    local glow: ImageLabel = Instance.new("ImageLabel")
    glow.Parent              = gui
    glow.BackgroundTransparency = 1
    glow.Image               = "rbxassetid://5028857084"
    glow.Size                = UDim2.new(0, 0, 0, 0)
    glow.Position            = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint         = Vector2.new(0.5, 0.5)
    glow.ImageTransparency   = 1
    glow.ZIndex              = 4

    local title: TextLabel = Instance.new("TextLabel")
    title.Parent               = gui
    title.BackgroundTransparency = 1
    title.Size                 = UDim2.new(1, 0, 0.12, 0)
    title.Position             = UDim2.new(0, -1000, 0.34, 0)
    title.Text                 = "Alwi Hub"
    title.Font                 = Enum.Font.Arcade
    title.TextScaled           = true
    title.TextTransparency     = 1
    title.TextColor3           = Color3.fromRGB(255, 215, 0)
    title.TextStrokeTransparency = 0
    title.TextStrokeColor3     = Color3.fromRGB(120, 80, 0)
    title.ZIndex               = 10

    local sub: TextLabel = Instance.new("TextLabel")
    sub.Parent               = gui
    sub.BackgroundTransparency = 1
    sub.Size                 = UDim2.new(1, 0, 0.05, 0)
    sub.Position             = UDim2.new(0, 1000, 0.47, 0)
    sub.Text                 = "Loading your experience..."
    sub.Font                 = Enum.Font.Arcade
    sub.TextScaled           = true
    sub.TextColor3           = Color3.fromRGB(255, 255, 255)
    sub.TextTransparency     = 1
    sub.ZIndex               = 10

    local barBg: Frame = Instance.new("Frame")
    barBg.Parent           = gui
    barBg.Size             = UDim2.new(0.4, 0, 0, 6)
    barBg.Position         = UDim2.new(0.3, 0, 0.7, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    barBg.BorderSizePixel  = 0
    barBg.Visible          = false
    do
        local barBgStroke: UIStroke = Instance.new("UIStroke", barBg)
        barBgStroke.Color       = Color3.fromRGB(60, 60, 80)
        barBgStroke.Thickness   = 1
        barBgStroke.Transparency = 0.5
    end

    local corner: UICorner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent       = barBg

    local bar: Frame = Instance.new("Frame")
    bar.Parent        = barBg
    bar.Size          = UDim2.new(0, 0, 1, 0)
    bar.BorderSizePixel = 0
    bar.ZIndex        = 2

    local corner2: UICorner = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(1, 0)
    corner2.Parent       = bar

    local barGradient: UIGradient = Instance.new("UIGradient")
    barGradient.Parent = bar

    local progressText: TextLabel = Instance.new("TextLabel")
    progressText.Parent               = gui
    progressText.BackgroundTransparency = 1
    progressText.Size                 = UDim2.new(0.4, 0, 0.04, 0)
    progressText.Position             = UDim2.new(0.3, 0, 0.718, 0)
    progressText.Font                 = Enum.Font.Code
    progressText.TextScaled           = true
    progressText.TextColor3           = Color3.fromRGB(220, 220, 220)
    progressText.TextStrokeTransparency = 0.5
    progressText.TextStrokeColor3     = Color3.fromRGB(0, 0, 0)
    progressText.Text                 = "0%"
    progressText.ZIndex               = 20

    local progressGradient: UIGradient = Instance.new("UIGradient")
    progressGradient.Parent = progressText

    local flash: Frame = Instance.new("Frame")
    flash.Parent               = gui
    flash.Size                 = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3     = Color3.new(1, 1, 1)
    flash.BackgroundTransparency = 1
    flash.ZIndex               = 100

    local goldGradient: ColorSequence = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 240, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 220, 50)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 170, 0)),
    }

    barGradient.Color      = goldGradient
    progressGradient.Color = goldGradient

    task.spawn(function()
        local _gradFrame: number = 0
        while gui.Parent do
            _gradFrame += 1
            if _gradFrame % 4 == 0 then
                local t: number = tick()
                barGradient.Rotation      += 4
                progressGradient.Rotation += 4
                barGradient.Offset        = Vector2.new(math.sin(t) * 0.3, 0)
                progressGradient.Offset   = Vector2.new(math.sin(t) * 0.3, 0)
            end
            task.wait()
        end
    end)

    local scanlineVig: Frame = Instance.new("Frame", gui)
    scanlineVig.Size               = UDim2.new(1, 0, 1, 0)
    scanlineVig.BackgroundColor3   = Color3.new(0, 0, 0)
    scanlineVig.BackgroundTransparency = 1
    scanlineVig.BorderSizePixel    = 0
    scanlineVig.ZIndex             = 3
    do
        local vigGrad: UIGradient = Instance.new("UIGradient", scanlineVig)
        vigGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0,   Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1,   Color3.new(0, 0, 0)),
        }
        vigGrad.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0,   0.5),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(1,   0.5),
        }
        vigGrad.Rotation = 90
    end
    task.spawn(function()
        task.wait(3.5)
        pcall(function()
            TweenService:Create(scanlineVig, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0.85
            }):Play()
        end)
    end)

    TweenService:Create(flash, TweenInfo.new(0.15), { BackgroundTransparency = 0.4 }):Play()
    task.wait(0.15)
    TweenService:Create(flash, TweenInfo.new(0.5),  { BackgroundTransparency = 1   }):Play()

    TweenService:Create(image, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 500), Rotation = 0, ImageTransparency = 0
    }):Play()
    TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 700, 0, 700), ImageTransparency = 0.5
    }):Play()

    task.wait(0.3)

    TweenService:Create(title, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.34, 0), TextTransparency = 0
    }):Play()

    task.wait(0.2)

    TweenService:Create(sub, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.47, 0), TextTransparency = 0
    }):Play()

    task.wait(0.5)
    barBg.Visible = true

    task.spawn(function()
        for i: number = 0, 100 do
            progressText.Text = i .. "%"
            bar.Size = UDim2.new(i / 100, 0, 1, 0)
            task.wait(0.03)
        end
        progressText.Text = "✓ Ready"
        TweenService:Create(progressText, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Rotation = 2
        }):Play()
        TweenService:Create(flash, TweenInfo.new(0.2), { BackgroundTransparency = 0.7 }):Play()
        task.wait(0.2)
        TweenService:Create(flash, TweenInfo.new(0.4), { BackgroundTransparency = 1   }):Play()
    end)

    task.spawn(function()
        while gui.Parent do
            TweenService:Create(image, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = 8, Size = UDim2.new(0, 530, 0, 530)
            }):Play()
            TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = -15, Size = UDim2.new(0, 760, 0, 760)
            }):Play()
            task.wait(2)
            TweenService:Create(image, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = -8, Size = UDim2.new(0, 500, 0, 500)
            }):Play()
            TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = 15, Size = UDim2.new(0, 700, 0, 700)
            }):Play()
            task.wait(2)
        end
    end)

    task.wait(4)

    TweenService:Create(flash, TweenInfo.new(0.4), { BackgroundTransparency = 0.2 }):Play()
    task.wait(0.3)

    TweenService:Create(image, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), Rotation = 180, ImageTransparency = 1
    }):Play()
    TweenService:Create(glow, TweenInfo.new(1), { ImageTransparency = 1, Size = UDim2.new(0, 0, 0, 0) }):Play()
    TweenService:Create(title, TweenInfo.new(1), { Position = UDim2.new(0, -1000, 0.34, 0), TextTransparency = 1 }):Play()
    TweenService:Create(sub, TweenInfo.new(1),   { Position = UDim2.new(0, 1000,  0.47, 0), TextTransparency = 1 }):Play()
    TweenService:Create(barBg, TweenInfo.new(1), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(bar, TweenInfo.new(1),   { BackgroundTransparency = 1 }):Play()
    TweenService:Create(progressText, TweenInfo.new(1), { TextTransparency = 1 }):Play()

    task.wait(1.5)
    gui:Destroy()
end

if _earlySkipIntro then
    pcall(function() gui:Destroy() end)
end

local Kawai: any = nil
do
local notifyOk: boolean, notifyErr: any = pcall(function()
    local source = game:HttpGet(
        "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Kawai%20Lib/Source.luau", true
    )
    if not source or #source == 0 then error("Empty Kawai library response") end
    local func = loadstring(source)
    if not func then error("Kawai Lib failed to compile") end
    Kawai = func()
end)

if not notifyOk then
    print("[VelocityX] ❌ Notification UI failed to load.")
    print("[VelocityX] Reason: " .. tostring(notifyErr))
    print("[VelocityX] Falling back to core notifications.")
end
end

local ALWI_ICON: string = "103887859853708"
local HUB_GREEN: Color3 = Color3.fromRGB(0, 255, 150)
local HUB_BLUE:  Color3 = Color3.fromRGB(0, 170, 255)

local function showNotification(
    title: string,
    desc: string,
    outlineColor: Color3?,
    duration: number?,
    imageId: string?
)
    local col: Color3 = outlineColor or HUB_BLUE
    if Kawai and Kawai.Notify then
        pcall(function()
            Kawai.Notify({
                Title    = title,
                Desc     = desc,
                Type     = "info",
                Duration = duration or 4,
                Icon     = imageId or ALWI_ICON,
                Color    = { col, col },
            })
        end)
    else
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title    = title,
                Text     = desc,
                Duration = duration or 4,
            })
        end)
        print("[VelocityX] 🔔 " .. title .. " | " .. desc)
    end
end

local function randomString(len: number): string
    local chars: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local str: string = ""
    for _: number = 1, len do
        local r: number = math.random(1, #chars)
        str ..= chars:sub(r, r)
    end
    return str
end

local function GetGreetingAndTime(): (string, string, string)
    local currentTime: any = os.date("*t")
    local hour: number   = currentTime.hour
    local minute: number = currentTime.min
    local greeting: string
    local emoji: string

    if hour >= 6 and hour < 12 then
        greeting = "Good Morning"
        emoji    = "🌅"
    elseif hour >= 12 and hour < 15 then
        greeting = "Good Noon"
        emoji    = "☀️🕛"
    elseif hour >= 15 and hour < 18 then
        greeting = "Good Afternoon"
        emoji    = "🌞"
    elseif hour >= 18 or hour < 6 then
        greeting = "Good Night"
        emoji    = "🌙"
    else
        greeting = "Hello"
        emoji    = "🌄"
    end

    local hour12: number = hour % 12
    if hour12 == 0 then hour12 = 12 end
    local ampm: string   = hour < 12 and "AM" or "PM"
    local timeStr: string = string.format("%02d:%02d %s", hour12, minute, ampm)

    return greeting, emoji, timeStr
end

local _b64chars: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local _b64lut: { [number]: number } = {}
for i: number = 1, #_b64chars do
    _b64lut[string.byte(_b64chars, i)] = i - 1
end

local function base64_decode(data: string): string

    data = data:gsub("[^A-Za-z0-9+/=]", "")
    local out: { string } = {}
    local len: number = #data
    local i:   number = 1
    while i <= len do
        local b0: number = _b64lut[string.byte(data, i)]     or 0
        local b1: number = _b64lut[string.byte(data, i + 1)] or 0
        local b2: number = _b64lut[string.byte(data, i + 2)] or 0
        local b3: number = _b64lut[string.byte(data, i + 3)] or 0
        local n:  number = (b0 * 0x40000) + (b1 * 0x1000) + (b2 * 0x40) + b3
        out[#out + 1] = string.char(
            math.floor(n / 0x10000) % 256,
            math.floor(n / 0x100)   % 256,
            n % 256
        )
        i += 4
    end
    local result: string = table.concat(out)

    local pad: number = 0
    if data:sub(-1) == "=" then pad += 1 end
    if data:sub(-2, -2) == "=" then pad += 1 end
    return pad > 0 and result:sub(1, #result - pad) or result
end

local _b64Pattern: string = "^[A-Za-z0-9+/]+=?=?$"
local function _isBase64(s: string): boolean
    return (#s > 0) and (#s % 4 == 0) and (s:match(_b64Pattern) ~= nil)
end

local function decode_obfuscated(obj: any): any
    if type(obj) == "table" then
        local new: { [any]: any } = {}
        for k: any, v: any in obj do
            local sk: string = tostring(k)
            local dk: string = _isBase64(sk) and base64_decode(sk) or sk
            new[dk] = decode_obfuscated(v)
        end
        return new
    elseif type(obj) == "string" then
        local s: string = obj :: string
        return _isBase64(s) and base64_decode(s) or s
    end
    return obj
end

local RealZzHub: ScreenGui = Instance.new("ScreenGui")
RealZzHub.Name            = "Velocity_" .. randomString(10)
RealZzHub.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling

pcall(function()
    if _syn and _syn.protect_gui then
        _syn.protect_gui(RealZzHub)
        RealZzHub.Parent = CoreGui
    else
        local _gethui: any = rawget(_G, "gethui")
        if _gethui then
            RealZzHub.Parent = _gethui()
        end
    end
end)

if not RealZzHub.Parent then
    RealZzHub.Parent = CoreGui
end

local LoaderScale: UIScale = Instance.new("UIScale", RealZzHub)
LoaderScale.Scale = 1
local function fitLoaderScale()
    pcall(function()
        local vp: Vector2 = workspace.CurrentCamera.ViewportSize
        LoaderScale.Scale = math.clamp(math.min(vp.X / 1100, vp.Y / 650), 0.62, 1)
    end)
end
fitLoaderScale()
pcall(function()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitLoaderScale)
end)

local MainBackground: ImageLabel = Instance.new("ImageLabel", RealZzHub)
MainBackground.AnchorPoint        = Vector2.new(0.5, 0.5)
MainBackground.Position           = UDim2.new(0.5, 0, 0.5, 0)
MainBackground.Size               = UDim2.new(0, 1, 0, 1)
MainBackground.Image              = "rbxassetid://7877641241"
MainBackground.BackgroundColor3   = Color3.new(1, 1, 1)
MainBackground.BorderSizePixel    = 0
MainBackground.ClipsDescendants   = false
MainBackground.Visible            = false
MainBackground.ImageTransparency  = 1

local Gradient: UIGradient = Instance.new("UIGradient", MainBackground)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
}
Gradient.Rotation = 45

do
local ShadowStroke: UIStroke = Instance.new("UIStroke", MainBackground)
ShadowStroke.Color       = Color3.fromRGB(0, 100, 150)
ShadowStroke.Thickness   = 4.5
ShadowStroke.Transparency = 0.6
end

do
local EdgeStroke: UIStroke = Instance.new("UIStroke", MainBackground)
EdgeStroke.Thickness   = 3.5
EdgeStroke.Transparency = 0.3
EdgeStroke.Color       = Color3.fromRGB(0, 255, 120)
end

do
    local Corner: UICorner = Instance.new("UICorner", MainBackground)
    Corner.CornerRadius = UDim.new(0, 8)
end

local TopShimmer: Frame = Instance.new("Frame", MainBackground)
TopShimmer.Size             = UDim2.new(0.7, 0, 0, 1)
TopShimmer.Position         = UDim2.new(0.15, 0, 0, 2)
TopShimmer.BorderSizePixel  = 0
TopShimmer.ZIndex           = 2
do
    local ShimmerCorner: UICorner = Instance.new("UICorner", TopShimmer)
    ShimmerCorner.CornerRadius = UDim.new(1, 0)
    local ShimmerGrad: UIGradient = Instance.new("UIGradient", TopShimmer)
    ShimmerGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 255, 240)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255)),
    }
    ShimmerGrad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,   1),
        NumberSequenceKeypoint.new(0.2, 0.55),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(0.8, 0.55),
        NumberSequenceKeypoint.new(1,   1),
    }
end

local HeaderAccent: Frame = Instance.new("Frame", MainBackground)
HeaderAccent.Size             = UDim2.new(1, 0, 0, 1)
HeaderAccent.Position         = UDim2.new(0, 0, 0, 32)
HeaderAccent.BorderSizePixel  = 0
HeaderAccent.ZIndex           = 2
do
    local HAccentGrad: UIGradient = Instance.new("UIGradient", HeaderAccent)
    HAccentGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 255, 120)),
    }
    HAccentGrad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,   1),
        NumberSequenceKeypoint.new(0.1, 0.2),
        NumberSequenceKeypoint.new(0.9, 0.2),
        NumberSequenceKeypoint.new(1,   1),
    }
end

local Logo: ImageButton = Instance.new("ImageButton", MainBackground)
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 6, 0, 6)
Logo.Size     = UDim2.new(0, 22, 0, 22)
Logo.Image    = "rbxassetid://103887859853708"
Logo.Visible  = false

local Name: TextLabel = Instance.new("TextLabel", MainBackground)
Name.BackgroundTransparency = 1
Name.Position             = UDim2.new(0, 33, 0, 7)
Name.Size                 = UDim2.new(0.72, 0, 0, 18)
Name.Font                 = Enum.Font.Arcade
Name.Text                 = "Alwi Hub"
Name.TextSize             = 13
Name.TextXAlignment       = Enum.TextXAlignment.Left
Name.TextColor3           = Color3.fromRGB(0, 255, 160)
Name.TextStrokeTransparency = 0.3
Name.TextStrokeColor3     = Color3.fromRGB(0, 80, 40)
Name.Visible              = false
do
    local NameStroke: UIStroke = Instance.new("UIStroke", Name)
    NameStroke.Color       = Color3.fromRGB(0, 200, 120)
    NameStroke.Thickness   = 1
    NameStroke.Transparency = 0.7
end

local InjectButton: TextButton = Instance.new("TextButton", MainBackground)
InjectButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
InjectButton.BackgroundTransparency = 1
InjectButton.AnchorPoint          = Vector2.new(0.5, 0.5)
InjectButton.Position             = UDim2.new(0.5, 0, 0.48, 0)
InjectButton.Size                 = UDim2.new(0.80, 0, 0, 44)
InjectButton.Font                 = Enum.Font.Arcade
InjectButton.Text                 = "Initializing..."
InjectButton.TextScaled           = true
InjectButton.TextColor3           = Color3.fromRGB(5, 5, 5)
InjectButton.Visible              = false
InjectButton.AutoButtonColor      = false

Instance.new("UICorner", InjectButton).CornerRadius = UDim.new(0, 8)

local BtnGlowRing: Frame = Instance.new("Frame", MainBackground)
BtnGlowRing.AnchorPoint        = Vector2.new(0.5, 0.5)
BtnGlowRing.Position           = UDim2.new(0.5, 0, 0.48, 0)
BtnGlowRing.Size               = UDim2.new(0.80, 0, 0, 44)
BtnGlowRing.BackgroundTransparency = 1
BtnGlowRing.BorderSizePixel    = 0
BtnGlowRing.ZIndex             = 0
Instance.new("UICorner", BtnGlowRing).CornerRadius = UDim.new(0, 10)
do
    local GlowStroke: UIStroke = Instance.new("UIStroke", BtnGlowRing)
    GlowStroke.Color       = Color3.fromRGB(0, 255, 140)
    GlowStroke.Thickness   = 3
    GlowStroke.Transparency = 0.7
    task.spawn(function()
        while BtnGlowRing and BtnGlowRing.Parent do
            pcall(function()
                TweenService:Create(GlowStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Transparency = 0.3, Thickness = 5
                }):Play()
            end)
            task.wait(1.2)
            pcall(function()
                TweenService:Create(GlowStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Transparency = 0.7, Thickness = 3
                }):Play()
            end)
            task.wait(1.2)
        end
    end)
end

local BtnGradient: UIGradient
local BtnStroke:   UIStroke
local BtnScale:    UIScale
do
    BtnGradient          = Instance.new("UIGradient", InjectButton)
    BtnGradient.Color    = Gradient.Color
    BtnGradient.Rotation = 90

    BtnStroke            = Instance.new("UIStroke", InjectButton)
    BtnStroke.Color      = Color3.fromRGB(0, 255, 150)
    BtnStroke.Thickness  = 1.5

    BtnScale       = Instance.new("UIScale", InjectButton)
    BtnScale.Scale = 1
end

local _btnNormalGrad: ColorSequence = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
}
local _btnErrorGrad: ColorSequence = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 30)),
}
local _btnSuccessGrad: ColorSequence = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 80)),
}

local function setBtnState(state: string)
    pcall(function()
        if state == "error" then
            BtnGradient.Color = _btnErrorGrad
            BtnStroke.Color   = Color3.fromRGB(255, 80, 80)
            for _ = 1, 3 do
                TweenService:Create(BtnScale, TweenInfo.new(0.055, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Scale = 1.03 }):Play()
                task.wait(0.06)
                TweenService:Create(BtnScale, TweenInfo.new(0.055, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Scale = 0.97 }):Play()
                task.wait(0.06)
            end
            TweenService:Create(BtnScale, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            task.delay(1.8, function()
                pcall(function()
                    BtnGradient.Color = _btnNormalGrad
                    BtnStroke.Color   = Color3.fromRGB(0, 255, 150)
                end)
            end)
        elseif state == "success" then
            BtnGradient.Color = _btnSuccessGrad
            BtnStroke.Color   = Color3.fromRGB(0, 255, 120)
            TweenService:Create(BtnScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.06 }):Play()
            task.delay(0.2, function()
                pcall(function()
                    TweenService:Create(BtnScale, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 1 }):Play()
                end)
            end)
        else
            BtnGradient.Color = _btnNormalGrad
            BtnStroke.Color   = Color3.fromRGB(0, 255, 150)
        end
    end)
end

InjectButton.MouseEnter:Connect(function()
    if not InjectButton.Active then return end
    pcall(function()
        TweenService:Create(BtnScale,  TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.05 }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Thickness = 2.5, Transparency = 0 }):Play()
    end)
end)
InjectButton.MouseLeave:Connect(function()
    pcall(function()
        TweenService:Create(BtnScale,  TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Thickness = 1.5, Transparency = 0 }):Play()
    end)
end)
InjectButton.MouseButton1Down:Connect(function()
    if not InjectButton.Active then return end
    pcall(function()
        TweenService:Create(BtnScale, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.94 }):Play()
    end)
end)
InjectButton.MouseButton1Up:Connect(function()
    pcall(function()
        TweenService:Create(BtnScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    end)
end)

local Version: TextLabel = Instance.new("TextLabel", MainBackground)
Version.BackgroundTransparency = 1
Version.AnchorPoint        = Vector2.new(1, 1)
Version.Position           = UDim2.new(1, -6, 1, -4)
Version.Size               = UDim2.new(0.40, 0, 0, 12)
Version.Font               = Enum.Font.Arcade
Version.Text               = "Loading..."
Version.TextSize           = 10
Version.TextXAlignment     = Enum.TextXAlignment.Right
Version.TextColor3         = Color3.fromRGB(0, 180, 240)
Version.TextStrokeTransparency = 0.6
Version.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
Version.Visible            = false

local _DISCORD_INVITE_CODE: string = "mJm4etTYjk"
local _DISCORD_SERVER_ID:   string = "1525943679133552811"
local _DISCORD_BASE_URL:    string = "https://discord.gg/" .. _DISCORD_INVITE_CODE
local DISCORD_LINK: string         = _DISCORD_BASE_URL

local _DISCORD_HEADERS: {[string]: string} = {
    ["Accept"]     = "application/json",
    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
}

local function _discordIsSupported(fn: any): boolean
    return type(fn) == "function"
end

local function _discordFetch(url: string): {success: boolean, statusCode: number?, body: string?}
    local ok, res = pcall(HttpService.RequestAsync, HttpService, {
        Url = url, Method = "GET", Headers = _DISCORD_HEADERS,
    })
    if ok and res then return { success = true, statusCode = res.StatusCode, body = res.Body } end

    if _discordIsSupported(_syn and _syn.request or nil) then
        local ok2, r2 = pcall(_syn.request, { Url = url, Method = "GET", Headers = _DISCORD_HEADERS })
        if ok2 and r2 then return { success = true, statusCode = r2.StatusCode, body = r2.Body } end
    end
    if _discordIsSupported(_http and _http.request or nil) then
        local ok3, r3 = pcall(_http.request, { Url = url, Method = "GET", Headers = _DISCORD_HEADERS })
        if ok3 and r3 then return { success = true, statusCode = r3.StatusCode, body = r3.Body } end
    end
    local _req = rawget(_G, "request")
    if _discordIsSupported(_req) then
        local ok4, r4 = pcall(_req, { Url = url, Method = "GET", Headers = _DISCORD_HEADERS })
        if ok4 and r4 then return { success = true, statusCode = r4.StatusCode, body = r4.Body } end
    end
    return { success = false, statusCode = nil, body = nil }
end

local function _discordCopyToClipboard(text: string): boolean
    local _sc = rawget(_G, "setclipboard")
    if _discordIsSupported(_sc) then
        local ok = pcall(_sc, text); if ok then return true end
    end
    local _tc = rawget(_G, "toclipboard")
    if _discordIsSupported(_tc) then
        local ok = pcall(_tc, text); if ok then return true end
    end
    local _Clipboard: any = rawget(_G, "Clipboard")
    if _discordIsSupported(_Clipboard) and _discordIsSupported(_Clipboard and _Clipboard.set or nil) then
        local ok = pcall(_Clipboard.set, text); if ok then return true end
    end
    return false
end

local function _discordResolveLink(): string
    local inviteUrl = string.format(
        "https://discord.com/api/v10/invites/%s?with_counts=true&with_expiration=true",
        _DISCORD_INVITE_CODE
    )
    local r1 = _discordFetch(inviteUrl)
    if r1.success and r1.statusCode == 200 then return _DISCORD_BASE_URL end

    local widgetUrl = string.format(
        "https://discord.com/api/v10/guilds/%s/widget.json",
        _DISCORD_SERVER_ID
    )
    local r2 = _discordFetch(widgetUrl)
    if r2.success and r2.statusCode == 200 and r2.body then
        local ok, data = pcall(HttpService.JSONDecode, HttpService, r2.body)
        if ok and type(data) == "table" and type(data.instant_invite) == "string" then
            return data.instant_invite
        end
    end
    return _DISCORD_BASE_URL
end

task.spawn(function()
    local ok, resolved = pcall(_discordResolveLink)
    DISCORD_LINK = (ok and type(resolved) == "string") and resolved or _DISCORD_BASE_URL

    local displayName: string = "Player"
    pcall(function() displayName = Players.LocalPlayer.DisplayName end)

    task.wait(1.5)
    pcall(showNotification,
        "Welcome, " .. displayName .. "! 👋",
        "Alwi Hub is ready. Join our Discord for updates!",
        Color3.fromRGB(0, 200, 255),
        5,
        "rbxassetid://7733960981"
    )
end)

local GreetingCard: Frame = Instance.new("Frame", MainBackground)
GreetingCard.Name                   = "GreetingCard"
GreetingCard.AnchorPoint            = Vector2.new(0, 1)
GreetingCard.Position               = UDim2.new(0, 6, 1, -5)

GreetingCard.Size                   = UDim2.new(0.60, 0, 0, 26)
GreetingCard.BackgroundColor3       = Color3.fromRGB(8, 18, 14)
GreetingCard.BackgroundTransparency = 0.25
GreetingCard.BorderSizePixel        = 0
GreetingCard.ClipsDescendants       = true
GreetingCard.Visible                = false

Instance.new("UICorner", GreetingCard).CornerRadius = UDim.new(0, 7)

local GCardBar: Frame = Instance.new("Frame", GreetingCard)
GCardBar.Size             = UDim2.new(0, 2, 1, 0)
GCardBar.Position         = UDim2.new(0, 0, 0, 0)
GCardBar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
GCardBar.BorderSizePixel  = 0
Instance.new("UICorner", GCardBar).CornerRadius = UDim.new(0, 2)

local GCardStroke: UIStroke = Instance.new("UIStroke", GreetingCard)
GCardStroke.Thickness    = 1
GCardStroke.Transparency = 0.55
GCardStroke.Color        = Color3.fromRGB(0, 200, 255)

local GCardIcon: ImageLabel = Instance.new("ImageLabel", GreetingCard)
GCardIcon.AnchorPoint           = Vector2.new(0, 0.5)
GCardIcon.Position              = UDim2.new(0, 5, 0.5, 0)
GCardIcon.Size                  = UDim2.new(0, 13, 0, 13)
GCardIcon.BackgroundTransparency = 1
GCardIcon.Image                 = icon("star")
GCardIcon.ImageColor3           = Color3.fromRGB(0, 255, 150)
GCardIcon.ImageTransparency     = 0
GCardIcon.ScaleType             = Enum.ScaleType.Fit

local GreetingLabel: TextLabel = Instance.new("TextLabel", GreetingCard)
GreetingLabel.AnchorPoint            = Vector2.new(0, 0.5)
GreetingLabel.Position               = UDim2.new(0, 6, 0.5, 0)
GreetingLabel.Size                   = UDim2.new(1, -8, 1, 0)
GreetingLabel.BackgroundTransparency = 1
GreetingLabel.Font                   = Enum.Font.Arcade
GreetingLabel.TextScaled             = true
GreetingLabel.TextXAlignment         = Enum.TextXAlignment.Left
GreetingLabel.TextColor3             = Color3.fromRGB(0, 255, 150)
GreetingLabel.TextStrokeTransparency = 0.5
GreetingLabel.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)

do
    local GreetingConstraint: UITextSizeConstraint = Instance.new("UITextSizeConstraint", GreetingLabel)
    GreetingConstraint.MinTextSize = 6
    GreetingConstraint.MaxTextSize = 11
end

local GCardSub: TextLabel = Instance.new("TextLabel", GreetingCard)
GCardSub.AnchorPoint            = Vector2.new(0, 1)
GCardSub.Position               = UDim2.new(0, 22, 1, -1)
GCardSub.Size                   = UDim2.new(1, -24, 0, 9)
GCardSub.BackgroundTransparency = 1
GCardSub.Font                   = Enum.Font.Arcade
GCardSub.TextScaled             = true
GCardSub.TextXAlignment         = Enum.TextXAlignment.Left
GCardSub.TextColor3             = Color3.fromRGB(160, 160, 255)
GCardSub.TextTransparency       = 1
GCardSub.Text = DISCORD_LINK
task.spawn(function()
    task.wait(0.1)
    repeat task.wait(0.2) until DISCORD_LINK ~= _DISCORD_BASE_URL or task.wait(3)
    pcall(function() GCardSub.Text = DISCORD_LINK end)
end)

do
    local GCardSubConstraint: UITextSizeConstraint = Instance.new("UITextSizeConstraint", GCardSub)
    GCardSubConstraint.MinTextSize = 5
    GCardSubConstraint.MaxTextSize = 8
end

local GCardRipple: Frame = Instance.new("Frame", GreetingCard)
GCardRipple.AnchorPoint            = Vector2.new(0.5, 0.5)
GCardRipple.Position               = UDim2.new(0.5, 0, 0.5, 0)
GCardRipple.Size                   = UDim2.new(0, 0, 0, 0)
GCardRipple.BackgroundColor3       = Color3.fromRGB(88, 101, 242)
GCardRipple.BackgroundTransparency = 0.5
GCardRipple.BorderSizePixel        = 0
GCardRipple.ZIndex                 = 10
Instance.new("UICorner", GCardRipple).CornerRadius = UDim.new(1, 0)

local GCardClick: TextButton = Instance.new("TextButton", GreetingCard)
GCardClick.Size                   = UDim2.new(1, 0, 1, 0)
GCardClick.BackgroundTransparency = 1
GCardClick.Text                   = ""
GCardClick.ZIndex                 = 11

local GreetingScale: UIScale = Instance.new("UIScale", GreetingCard)
GreetingScale.Scale = 0.85

local _greetingShowDiscord: boolean = false

local function GetNormalGreetingText(): string
    local ok: boolean, result: string = pcall(function(): string
        local playerName: string = Players.LocalPlayer.DisplayName
        local greeting: string, emoji: string, timeStr: string = GetGreetingAndTime()
        return string.format("%s, %s %s %s", greeting, playerName, emoji, timeStr)
    end)
    if ok then return result end
    return "Hello, " .. tostring(Players.LocalPlayer.DisplayName)
end

local function ApplyGreetingState()
    if _greetingShowDiscord then

        GreetingCard.Size          = UDim2.new(0.60, 0, 0, 34)
        GreetingLabel.Position     = UDim2.new(0, 22, 0.30, 0)
        GreetingLabel.Size         = UDim2.new(1, -24, 0.45, 0)
        GreetingLabel.Text         = "Need help? Join Discord!"
        GreetingLabel.TextColor3   = Color3.fromRGB(160, 150, 255)
        GCardBar.BackgroundColor3  = Color3.fromRGB(88, 101, 242)
        GCardStroke.Color          = Color3.fromRGB(88, 101, 242)
        GCardStroke.Transparency   = 0.4
        GCardIcon.Image            = "rbxassetid://94937742565147"
        GCardIcon.ImageColor3      = Color3.fromRGB(255, 255, 255)
    else

        GreetingCard.Size          = UDim2.new(0.60, 0, 0, 24)
        GreetingLabel.Position     = UDim2.new(0, 6, 0.5, 0)
        GreetingLabel.Size         = UDim2.new(1, -8, 1, 0)
        GreetingLabel.Text         = GetNormalGreetingText()
        GreetingLabel.TextColor3   = Color3.fromRGB(0, 255, 150)
        GCardBar.BackgroundColor3  = Color3.fromRGB(0, 255, 150)
        GCardStroke.Color          = Color3.fromRGB(0, 200, 255)
        GCardStroke.Transparency   = 0.55
        local _gi: string = icon("party-popper")
        if _gi == "" then _gi = icon("star") end
        GCardIcon.Image            = _gi
        GCardIcon.ImageColor3      = Color3.fromRGB(0, 255, 150)
    end
end

local function UpdateGreeting()
    pcall(ApplyGreetingState)
end

pcall(UpdateGreeting)

GCardClick.MouseButton1Click:Connect(function()
    if not _greetingShowDiscord then return end
    _discordCopyToClipboard(DISCORD_LINK)
    task.spawn(function()
        local ok, fresh = pcall(_discordResolveLink)
        if ok and type(fresh) == "string" then
            DISCORD_LINK = fresh
            _discordCopyToClipboard(fresh)
        end
    end)

    GCardRipple.Size                 = UDim2.new(0, 0, 0, 0)
    GCardRipple.BackgroundTransparency = 0.55
    GCardRipple.Position             = UDim2.new(0.5, 0, 0.5, 0)
    pcall(function()
        TweenService:Create(GCardRipple, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(2.5, 0, 6, 0),
            BackgroundTransparency = 1,
        }):Play()
    end)

    pcall(function()
        TweenService:Create(GreetingScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 0.93,
        }):Play()
    end)
    task.delay(0.12, function()
        pcall(function()
            TweenService:Create(GreetingScale, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                Scale = 1,
            }):Play()
        end)
    end)

    pcall(function()
        TweenService:Create(GCardIcon, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Rotation = -18,
        }):Play()
    end)
    task.delay(0.12, function()
        pcall(function()
            TweenService:Create(GCardIcon, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
                Rotation = 18,
            }):Play()
        end)
        task.delay(0.16, function()
            pcall(function()
                TweenService:Create(GCardIcon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Rotation = 0,
                }):Play()
            end)
        end)
    end)

    GreetingLabel.Text = "Copied! ✓"
    GreetingLabel.TextColor3 = Color3.fromRGB(100, 255, 160)
    task.delay(1.2, function()
        pcall(function()
            if _greetingShowDiscord then
                TweenService:Create(GreetingLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    TextTransparency = 1,
                }):Play()
                task.wait(0.32)
                GreetingLabel.Text = "Need help? Join our Discord!"
                GreetingLabel.TextColor3 = Color3.fromRGB(170, 160, 255)
                TweenService:Create(GreetingLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    TextTransparency = 0,
                }):Play()
            end
        end)
    end)
end)

local CloseButton: TextButton = Instance.new("TextButton", MainBackground)
CloseButton.BackgroundTransparency = 1
CloseButton.AnchorPoint   = Vector2.new(1, 0)
CloseButton.Position      = UDim2.new(1, -2, 0, -2)
CloseButton.Rotation      = 45
CloseButton.Size          = UDim2.new(0, 25, 0, 25)
CloseButton.Font          = Enum.Font.Arcade
CloseButton.Text          = "+"
CloseButton.TextSize      = 29
CloseButton.Visible       = false

local SettingsIcon: ImageButton = Instance.new("ImageButton", MainBackground)
SettingsIcon.BackgroundTransparency = 1
SettingsIcon.AnchorPoint       = Vector2.new(1, 0)
SettingsIcon.Position          = UDim2.new(1, -30, 0, 5)
SettingsIcon.Size              = UDim2.new(0, 22, 0, 22)
SettingsIcon.Image             = "rbxassetid://101339235267993"
SettingsIcon.Visible           = false
SettingsIcon.ImageTransparency = 0.2

local SettingsIconScale: UIScale = Instance.new("UIScale", SettingsIcon)
SettingsIconScale.Scale = 1

local PerfHudGui: ScreenGui = Instance.new("ScreenGui")
PerfHudGui.Name           = "AlwiPerfHudGui"
PerfHudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
PerfHudGui.ResetOnSpawn   = false
PerfHudGui.DisplayOrder   = 999998
pcall(function()
    for _, gui: Instance in CoreGui:GetChildren() do
        if gui.Name == "AlwiPerfHudGui" then gui:Destroy() end
    end
end)
pcall(function()
    if _syn and _syn.protect_gui then
        _syn.protect_gui(PerfHudGui)
        PerfHudGui.Parent = CoreGui
    else
        local _gethui: any = rawget(_G, "gethui")
        if _gethui then PerfHudGui.Parent = _gethui() end
    end
end)
if not PerfHudGui.Parent then
    PerfHudGui.Parent = CoreGui
end

local HudScale: UIScale = Instance.new("UIScale", PerfHudGui)
HudScale.Scale = 1
local function fitHudScale()
    pcall(function()
        local vp: Vector2 = workspace.CurrentCamera.ViewportSize
        HudScale.Scale = math.clamp(math.min(vp.X / 1100, vp.Y / 650), 0.7, 1)
    end)
end
fitHudScale()
pcall(function()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitHudScale)
end)

local PerfHud: Frame = Instance.new("Frame", PerfHudGui)
PerfHud.Name                   = "AlwiPerfHud"
PerfHud.AnchorPoint            = Vector2.new(1, 0)
PerfHud.Position               = UDim2.new(1, 340, 0, 10)
PerfHud.Size                   = UDim2.new(0, 320, 0, 30)
PerfHud.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
PerfHud.BackgroundTransparency = 0.7
PerfHud.BorderSizePixel        = 0
PerfHud.ZIndex                 = 40
PerfHud.Visible                = true
PerfHud.ClipsDescendants       = false
Instance.new("UICorner", PerfHud).CornerRadius = UDim.new(0, 10)
do
    local PerfStroke: UIStroke = Instance.new("UIStroke", PerfHud)
    PerfStroke.Color        = Color3.fromRGB(255, 255, 255)
    PerfStroke.Thickness    = 3
    PerfStroke.Transparency = 0
    local PerfStrokeGrad: UIGradient = Instance.new("UIGradient", PerfStroke)
    PerfStrokeGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
    }
    PerfStrokeGrad.Rotation = 45
end
do
    local PerfShadow: Frame = Instance.new("Frame", PerfHud)
    PerfShadow.Name                      = "GlowShadow"
    PerfShadow.AnchorPoint               = Vector2.new(0.5, 0.5)
    PerfShadow.Position                  = UDim2.new(0.5, 0, 0.5, 2)
    PerfShadow.Size                      = UDim2.new(1, 8, 1, 8)
    PerfShadow.BackgroundColor3          = Color3.fromRGB(0, 0, 0)
    PerfShadow.BackgroundTransparency    = 0.6
    PerfShadow.BorderSizePixel           = 0
    PerfShadow.ZIndex                    = 39
    Instance.new("UICorner", PerfShadow).CornerRadius = UDim.new(0, 13)
end

local function _makePerfSeg(xOff: number, segW: number, iconName: string, iconCol: Color3, title: string, valueColor: Color3): TextLabel
    local iconImg: ImageLabel = Instance.new("ImageLabel", PerfHud)
    iconImg.BackgroundTransparency = 1
    iconImg.AnchorPoint = Vector2.new(0, 0.5)
    iconImg.Position    = UDim2.new(0, xOff + 6, 0.5, 0)
    iconImg.Size        = UDim2.new(0, 14, 0, 14)
    iconImg.Image       = icon(iconName)
    iconImg.ImageColor3 = iconCol
    iconImg.ZIndex      = 41
    local titleLbl: TextLabel = Instance.new("TextLabel", PerfHud)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position  = UDim2.new(0, xOff + 23, 0.5, -9)
    titleLbl.Size      = UDim2.new(0, 52, 0, 18)
    titleLbl.Font      = Enum.Font.Arcade
    titleLbl.TextSize  = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextColor3     = Color3.fromRGB(20, 20, 20)
    titleLbl.TextStrokeTransparency = 1
    titleLbl.ZIndex         = 41
    titleLbl.Text           = title
    local valLbl: TextLabel = Instance.new("TextLabel", PerfHud)
    valLbl.BackgroundTransparency = 1
    valLbl.AnchorPoint = Vector2.new(1, 0.5)
    valLbl.Position    = UDim2.new(0, xOff + segW - 6, 0.5, 0)
    valLbl.Size        = UDim2.new(0, segW - 70, 0, 18)
    valLbl.Font        = Enum.Font.Arcade
    valLbl.TextSize    = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.TextColor3     = valueColor
    valLbl.TextStrokeTransparency = 1
    valLbl.ZIndex         = 41
    valLbl.Text           = "—"
    return valLbl
end

local function _makePerfDivider(xOff: number)
    local div: Frame = Instance.new("Frame", PerfHud)
    div.AnchorPoint      = Vector2.new(0, 0.5)
    div.Position         = UDim2.new(0, xOff, 0.5, 0)
    div.Size             = UDim2.new(0, 1, 0, 16)
    div.BackgroundColor3 = Color3.fromRGB(0, 220, 160)
    div.BackgroundTransparency = 0.45
    div.BorderSizePixel  = 0
    div.ZIndex           = 41
end

local PerfPingVal:    TextLabel = _makePerfSeg(0,   130, "signal", Color3.fromRGB(30, 120, 230),   "Ping :",    Color3.fromRGB(30, 120, 230))
_makePerfDivider(130)
local PerfFpsVal:     TextLabel = _makePerfSeg(130, 80,  "gauge",  Color3.fromRGB(0, 170, 80),    "FPS :",     Color3.fromRGB(0, 170, 80))
_makePerfDivider(210)
local PerfPlayersVal: TextLabel = _makePerfSeg(210, 110, "users",  Color3.fromRGB(0, 170, 230),   "Players :", Color3.fromRGB(20, 20, 20))

local PerfHudDrag: UIDragDetector? = nil
pcall(function()
    local probe: UIDragDetector = Instance.new("UIDragDetector")
    probe:Destroy()
    local hudDrag: UIDragDetector = Instance.new("UIDragDetector")
    hudDrag.Parent = PerfHud
    PerfHudDrag = hudDrag
end)

local ConfirmFrame: ImageLabel = Instance.new("ImageLabel", MainBackground)
ConfirmFrame.AnchorPoint        = Vector2.new(0.5, 0.5)
ConfirmFrame.Position           = UDim2.new(0.5, 0, 0.5, 0)
ConfirmFrame.Size               = UDim2.new(0, 200, 0, 100)
ConfirmFrame.Image              = "rbxassetid://7877641241"
ConfirmFrame.BackgroundColor3   = Color3.new(1, 1, 1)
ConfirmFrame.BorderSizePixel    = 0
ConfirmFrame.Visible            = false
ConfirmFrame.ZIndex             = 3

local ConfirmGradient: UIGradient = Instance.new("UIGradient", ConfirmFrame)
ConfirmGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
}
ConfirmGradient.Rotation = 45
do
local ConfirmStroke: UIStroke = Instance.new("UIStroke", ConfirmFrame)
ConfirmStroke.Color        = Color3.fromRGB(0, 200, 255)
ConfirmStroke.Thickness    = 2
ConfirmStroke.Transparency = 0.3
end
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 8)

do
    local ConfirmText: TextLabel = Instance.new("TextLabel", ConfirmFrame)
    ConfirmText.BackgroundTransparency = 1
    ConfirmText.Position           = UDim2.new(0, 0, 0.2, 0)
    ConfirmText.Size               = UDim2.new(1, 0, 0.3, 0)
    ConfirmText.Font               = Enum.Font.Arcade
    ConfirmText.Text               = "Are you sure you want\nto close Alwi hub?"
    ConfirmText.TextSize           = 12
    ConfirmText.TextColor3         = Color3.fromRGB(0, 255, 150)
    ConfirmText.TextStrokeTransparency = 0
    ConfirmText.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
end

local YesButton: TextButton = Instance.new("TextButton", ConfirmFrame)
YesButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
YesButton.BackgroundTransparency = 1
YesButton.Position             = UDim2.new(0.15, 0, 0.65, 0)
YesButton.Size                 = UDim2.new(0, 70, 0, 30)
YesButton.Font                 = Enum.Font.Arcade
YesButton.Text                 = "Yes"
YesButton.TextScaled           = true
YesButton.TextColor3           = Color3.new(0, 0, 0)
Instance.new("UICorner", YesButton).CornerRadius = UDim.new(0, 4)
do
    local YesGradient: UIGradient = Instance.new("UIGradient", YesButton)
    YesGradient.Color    = ConfirmGradient.Color
    YesGradient.Rotation = 90
end
do
local YesStroke: UIStroke = Instance.new("UIStroke", YesButton)
YesStroke.Color     = Color3.fromRGB(0, 255, 150)
YesStroke.Thickness = 1.5
end

local NoButton: TextButton = Instance.new("TextButton", ConfirmFrame)
NoButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
NoButton.BackgroundTransparency = 1
NoButton.Position             = UDim2.new(0.55, 0, 0.65, 0)
NoButton.Size                 = UDim2.new(0, 70, 0, 30)
NoButton.Font                 = Enum.Font.Arcade
NoButton.Text                 = "No"
NoButton.TextScaled           = true
NoButton.TextColor3           = Color3.new(0, 0, 0)
Instance.new("UICorner", NoButton).CornerRadius = UDim.new(0, 4)
do
    local NoGradient: UIGradient = Instance.new("UIGradient", NoButton)
    NoGradient.Color    = ConfirmGradient.Color
    NoGradient.Rotation = 90
end
do
local NoStroke: UIStroke = Instance.new("UIStroke", NoButton)
NoStroke.Color     = Color3.fromRGB(0, 255, 150)
NoStroke.Thickness = 1.5
end

local DeleteConfirmFrame: ImageLabel = Instance.new("ImageLabel", MainBackground)
DeleteConfirmFrame.Name             = "DeleteConfirmFrame"
DeleteConfirmFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
DeleteConfirmFrame.Position         = UDim2.new(0.5, 0, 0.5, 0)
DeleteConfirmFrame.Size             = UDim2.new(0, 200, 0, 100)
DeleteConfirmFrame.Image            = "rbxassetid://7877641241"
DeleteConfirmFrame.BackgroundColor3 = Color3.new(1, 1, 1)
DeleteConfirmFrame.BorderSizePixel  = 0
DeleteConfirmFrame.Visible          = false
DeleteConfirmFrame.ZIndex           = 3

do
    local DeleteConfirmGradient: UIGradient = Instance.new("UIGradient", DeleteConfirmFrame)
    DeleteConfirmGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50)),
    }
    DeleteConfirmGradient.Rotation = 45
    local DeleteConfirmStroke: UIStroke = Instance.new("UIStroke", DeleteConfirmFrame)
    DeleteConfirmStroke.Color        = Color3.fromRGB(255, 100, 100)
    DeleteConfirmStroke.Thickness    = 2
    DeleteConfirmStroke.Transparency = 0.3
    Instance.new("UICorner", DeleteConfirmFrame).CornerRadius = UDim.new(0, 8)

    local DeleteConfirmText: TextLabel = Instance.new("TextLabel", DeleteConfirmFrame)
    DeleteConfirmText.BackgroundTransparency = 1
    DeleteConfirmText.Position           = UDim2.new(0, 0, 0.2, 0)
    DeleteConfirmText.Size               = UDim2.new(1, 0, 0.3, 0)
    DeleteConfirmText.Font               = Enum.Font.Arcade
    DeleteConfirmText.Text               = "Delete config file?"
    DeleteConfirmText.TextSize           = 12
    DeleteConfirmText.TextColor3         = Color3.fromRGB(255, 255, 255)
    DeleteConfirmText.TextStrokeTransparency = 0
    DeleteConfirmText.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
end

local DeleteYesButton: TextButton = Instance.new("TextButton", DeleteConfirmFrame)
DeleteYesButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
DeleteYesButton.BackgroundTransparency = 1
DeleteYesButton.Position             = UDim2.new(0.15, 0, 0.65, 0)
DeleteYesButton.Size                 = UDim2.new(0, 70, 0, 30)
DeleteYesButton.Font                 = Enum.Font.Arcade
DeleteYesButton.Text                 = "Yes"
DeleteYesButton.TextScaled           = true
DeleteYesButton.TextColor3           = Color3.new(0, 0, 0)
Instance.new("UICorner", DeleteYesButton).CornerRadius = UDim.new(0, 4)
do
    local DeleteYesGradient: UIGradient = Instance.new("UIGradient", DeleteYesButton)
    DeleteYesGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50)),
    }
    DeleteYesGradient.Rotation = 90
end
do
local DeleteYesStroke: UIStroke = Instance.new("UIStroke", DeleteYesButton)
DeleteYesStroke.Color     = Color3.fromRGB(255, 100, 100)
DeleteYesStroke.Thickness = 1.5
end

local DeleteNoButton: TextButton = Instance.new("TextButton", DeleteConfirmFrame)
DeleteNoButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
DeleteNoButton.BackgroundTransparency = 1
DeleteNoButton.Position             = UDim2.new(0.55, 0, 0.65, 0)
DeleteNoButton.Size                 = UDim2.new(0, 70, 0, 30)
DeleteNoButton.Font                 = Enum.Font.Arcade
DeleteNoButton.Text                 = "No"
DeleteNoButton.TextScaled           = true
DeleteNoButton.TextColor3           = Color3.new(0, 0, 0)
Instance.new("UICorner", DeleteNoButton).CornerRadius = UDim.new(0, 4)
do
    local DeleteNoGradient: UIGradient = Instance.new("UIGradient", DeleteNoButton)
    DeleteNoGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50)),
    }
    DeleteNoGradient.Rotation = 90
end
do
local DeleteNoStroke: UIStroke = Instance.new("UIStroke", DeleteNoButton)
DeleteNoStroke.Color     = Color3.fromRGB(255, 100, 100)
DeleteNoStroke.Thickness = 1.5
end

local PANEL_W: number = 234
local PANEL_H: number = 256

local SettingsPanel: ImageLabel = Instance.new("ImageLabel", MainBackground)
SettingsPanel.AnchorPoint      = Vector2.new(1, 0)
SettingsPanel.Position         = UDim2.new(1, -2, 0, 33)
SettingsPanel.Size             = UDim2.new(0, PANEL_W, 0, PANEL_H)
SettingsPanel.Image            = "rbxassetid://7877641241"
SettingsPanel.BackgroundColor3 = Color3.new(1, 1, 1)
SettingsPanel.BorderSizePixel  = 0
SettingsPanel.ClipsDescendants = true
SettingsPanel.Visible          = false
SettingsPanel.ZIndex           = 2

do
    local PanelGradient: UIGradient = Instance.new("UIGradient", SettingsPanel)
    PanelGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
    }
    PanelGradient.Rotation = 45

    local PanelStroke: UIStroke = Instance.new("UIStroke", SettingsPanel)
    PanelStroke.Color        = Color3.fromRGB(0, 200, 255)
    PanelStroke.Thickness    = 2
    PanelStroke.Transparency = 0.3

    local PanelCorner: UICorner = Instance.new("UICorner", SettingsPanel)
    PanelCorner.CornerRadius = UDim.new(0, 8)
end

local GameThumbnailBG: ImageLabel = Instance.new("ImageLabel", SettingsPanel)
GameThumbnailBG.BackgroundTransparency = 1
GameThumbnailBG.Size              = UDim2.new(1, 0, 1, 0)
GameThumbnailBG.ScaleType         = Enum.ScaleType.Crop
GameThumbnailBG.ImageTransparency = 0.4
GameThumbnailBG.ZIndex            = 1
GameThumbnailBG.Image             = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150"

task.spawn(function()
    local fetchStatus: Enum.AssetFetchStatus? = nil
    local ok: boolean = pcall(function()
        game:GetService("ContentProvider"):PreloadAsync({ GameThumbnailBG }, function(_, status: Enum.AssetFetchStatus)
            fetchStatus = status
        end)
    end)
    if not ok or fetchStatus ~= Enum.AssetFetchStatus.Success then
        GameThumbnailBG.Visible = false
    end
end)

local TabBar: Frame = Instance.new("Frame", SettingsPanel)
TabBar.Size               = UDim2.new(1, 0, 0, 28)
TabBar.Position           = UDim2.new(0, 0, 0, 0)
TabBar.BackgroundColor3   = Color3.fromRGB(0, 0, 0)
TabBar.BackgroundTransparency = 0.6
TabBar.BorderSizePixel    = 0
TabBar.ZIndex             = 4
TabBar.ClipsDescendants   = false

do
    local TabBarCorner: UICorner = Instance.new("UICorner", TabBar)
    TabBarCorner.CornerRadius = UDim.new(0, 8)

    local TabSep: Frame = Instance.new("Frame", TabBar)
    TabSep.Size               = UDim2.new(1, 0, 0, 1)
    TabSep.AnchorPoint        = Vector2.new(0, 1)
    TabSep.Position           = UDim2.new(0, 0, 1, 0)
    TabSep.BackgroundColor3   = Color3.fromRGB(0, 200, 255)
    TabSep.BackgroundTransparency = 0.55
    TabSep.BorderSizePixel    = 0
    TabSep.ZIndex             = 5
end

local TabIndicator: Frame = Instance.new("Frame", TabBar)
TabIndicator.AnchorPoint        = Vector2.new(0, 1)
TabIndicator.Size               = UDim2.new(0, 60, 0, 2)
TabIndicator.Position           = UDim2.new(0, 5, 1, 0)
TabIndicator.BackgroundColor3   = Color3.fromRGB(0, 255, 150)
TabIndicator.BorderSizePixel    = 0
TabIndicator.ZIndex             = 6
do
    local TabIndGrad: UIGradient = Instance.new("UIGradient", TabIndicator)
    TabIndGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255)),
    }
end
Instance.new("UICorner", TabIndicator).CornerRadius = UDim.new(1, 0)

local function makeTabButton(
    text: string,
    xPos: number,
    w: number,
    iconName: string
): TextButton
    local btn: TextButton = Instance.new("TextButton", TabBar)
    btn.BackgroundTransparency = 1
    btn.Position           = UDim2.new(0, xPos, 0, 0)
    btn.Size               = UDim2.new(0, w, 1, -2)
    btn.Font               = Enum.Font.Arcade
    btn.TextSize           = 9
    btn.TextColor3         = Color3.fromRGB(140, 140, 140)
    btn.TextXAlignment     = Enum.TextXAlignment.Center
    btn.ZIndex             = 6
    btn.Text               = ""
    btn.AutoButtonColor    = false

    local row: Frame = Instance.new("Frame", btn)
    row.BackgroundTransparency = 1
    row.AnchorPoint = Vector2.new(0.5, 0.5)
    row.Position    = UDim2.new(0.5, 0, 0.5, 0)
    row.Size        = UDim2.new(1, -4, 1, 0)
    row.ZIndex      = 7

    local iconImg: ImageLabel = Instance.new("ImageLabel", row)
    iconImg.BackgroundTransparency = 1
    iconImg.Name        = "TabIcon"
    iconImg.AnchorPoint = Vector2.new(0, 0.5)
    iconImg.Position    = UDim2.new(0, 0, 0.5, 0)
    iconImg.Size        = UDim2.new(0, 10, 0, 10)
    iconImg.Image       = icon(iconName)
    iconImg.ImageColor3 = Color3.fromRGB(140, 140, 140)
    iconImg.ZIndex      = 7

    local lbl: TextLabel = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1
    lbl.Name           = "TabLabel"
    lbl.AnchorPoint    = Vector2.new(0, 0.5)
    lbl.Position       = UDim2.new(0, 14, 0.5, 0)
    lbl.Size           = UDim2.new(1, -14, 1, 0)
    lbl.Font           = Enum.Font.Arcade
    lbl.TextSize       = 9
    lbl.TextColor3     = Color3.fromRGB(140, 140, 140)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex         = 7
    lbl.Text           = text

    return btn
end

local TabBtnSettings: TextButton = makeTabButton("Settings", 4,   76, "settings")
local TabBtnInfo:     TextButton = makeTabButton("Info",     82,  74, "info")
local TabBtnCredit:   TextButton = makeTabButton("Credit",   158, 72, "star")

local function updateTabIcons(activeTab: string)
    local map: {[TextButton]: {iconName: string, tab: string}} = {
        [TabBtnSettings] = { iconName = "settings", tab = "settings" },
        [TabBtnInfo]     = { iconName = "info",     tab = "info"     },
        [TabBtnCredit]   = { iconName = "star",     tab = "credit"   },
    }
    for btn, v in map do
        local isActive = (v.tab == activeTab)
        local col = isActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(140, 140, 140)
        local iconImg = btn:FindFirstChild("TabIcon", true)
        local lbl     = btn:FindFirstChild("TabLabel", true)
        if iconImg then iconImg.ImageColor3 = col end
        if lbl     then lbl.TextColor3      = col end
    end
end

local CONTENT_Y: number = 28

local ScrollingFrame: ScrollingFrame = Instance.new("ScrollingFrame", SettingsPanel)
ScrollingFrame.Name                  = "SettingsContent"
ScrollingFrame.Position              = UDim2.new(0, 0, 0, CONTENT_Y)
ScrollingFrame.Size                  = UDim2.new(1, 0, 1, -CONTENT_Y - 4)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel       = 0
ScrollingFrame.ClipsDescendants      = true
ScrollingFrame.ScrollBarThickness    = 5
ScrollingFrame.ScrollBarImageColor3  = Color3.fromRGB(0, 255, 150)
ScrollingFrame.CanvasSize            = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ZIndex                = 3
ScrollingFrame.Visible               = true

local ToggleList: UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
ToggleList.Padding             = UDim.new(0, 5)
ToggleList.HorizontalAlignment = Enum.HorizontalAlignment.Center
do
    local ScrollPad: UIPadding = Instance.new("UIPadding", ScrollingFrame)
    ScrollPad.PaddingTop    = UDim.new(0, 6)
    ScrollPad.PaddingBottom = UDim.new(0, 6)
end

local InfoContent: ScrollingFrame = Instance.new("ScrollingFrame", SettingsPanel)
InfoContent.Name                   = "InfoContent"
InfoContent.Position               = UDim2.new(0, 0, 0, CONTENT_Y)
InfoContent.Size                   = UDim2.new(1, 0, 1, -CONTENT_Y - 4)
InfoContent.BackgroundTransparency = 1
InfoContent.BorderSizePixel        = 0
InfoContent.ClipsDescendants       = true
InfoContent.ScrollBarThickness     = 5
InfoContent.ScrollBarImageColor3   = Color3.fromRGB(0, 200, 255)
InfoContent.CanvasSize             = UDim2.new(0, 0, 0, 0)
InfoContent.ZIndex                 = 3
InfoContent.Visible                = false
InfoContent.ScrollingDirection     = Enum.ScrollingDirection.Y
InfoContent.AutomaticCanvasSize    = Enum.AutomaticSize.Y

do
    local InfoList: UIListLayout = Instance.new("UIListLayout", InfoContent)
    InfoList.Padding             = UDim.new(0, 2)
    InfoList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    InfoList.VerticalAlignment   = Enum.VerticalAlignment.Top
    InfoList.SortOrder           = Enum.SortOrder.LayoutOrder

    local InfoPad: UIPadding = Instance.new("UIPadding", InfoContent)
    InfoPad.PaddingTop    = UDim.new(0, 5)
    InfoPad.PaddingLeft   = UDim.new(0, 6)
    InfoPad.PaddingRight  = UDim.new(0, 8)
    InfoPad.PaddingBottom = UDim.new(0, 5)
end

local _infoOrder: number = 0
local function addInfoRow(iconName: string, label: string, value: string, col: Color3?): TextLabel
    _infoOrder += 1
    local row: Frame = Instance.new("Frame", InfoContent)
    row.Size                   = UDim2.new(1, -6, 0, 17)
    row.BackgroundColor3       = Color3.fromRGB(0, 255, 150)
    row.BackgroundTransparency = 1
    row.BorderSizePixel        = 0
    row.ZIndex                 = 4
    row.LayoutOrder            = _infoOrder
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 3)

    local iconImg: ImageLabel = Instance.new("ImageLabel", row)
    iconImg.BackgroundTransparency = 1
    iconImg.AnchorPoint = Vector2.new(0, 0.5)
    iconImg.Position    = UDim2.new(0, 1, 0.5, 0)
    iconImg.Size        = UDim2.new(0, 10, 0, 10)
    iconImg.Image       = icon(iconName)
    iconImg.ImageColor3 = Color3.fromRGB(120, 120, 120)
    iconImg.ZIndex      = 5

    local lbl: TextLabel = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1
    lbl.Position  = UDim2.new(0, 14, 0, 0)
    lbl.Size      = UDim2.new(0.44, -14, 1, 0)
    lbl.Font      = Enum.Font.Arcade
    lbl.TextSize  = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3     = Color3.fromRGB(140, 140, 140)
    lbl.ZIndex         = 4
    lbl.Text           = label

    local val: TextLabel = Instance.new("TextLabel", row)
    val.BackgroundTransparency = 1
    val.Position  = UDim2.new(0.46, 0, 0, 0)
    val.Size      = UDim2.new(0.54, 0, 1, 0)
    val.Font      = Enum.Font.Arcade
    val.TextSize  = 8
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.TextTruncate   = Enum.TextTruncate.AtEnd
    val.TextColor3     = col or Color3.fromRGB(0, 220, 180)
    val.ZIndex         = 4
    val.Text           = value

    return val
end

local function addInfoDivider(layoutOrder: number)
    local d: Frame = Instance.new("Frame", InfoContent)
    d.Size               = UDim2.new(1, -10, 0, 1)
    d.BackgroundColor3   = Color3.fromRGB(0, 200, 255)
    d.BackgroundTransparency = 0.65
    d.BorderSizePixel    = 0
    d.ZIndex             = 4
    d.LayoutOrder        = layoutOrder
    _infoOrder           = layoutOrder
end

local function addInfoHeader(iconName: string, txt: string): TextLabel
    _infoOrder += 1
    local wrap: Frame = Instance.new("Frame", InfoContent)
    wrap.Size                   = UDim2.new(1, -6, 0, 16)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel        = 0
    wrap.ZIndex                 = 4
    wrap.LayoutOrder            = _infoOrder

    local iconImg: ImageLabel = Instance.new("ImageLabel", wrap)
    iconImg.BackgroundTransparency = 1
    iconImg.AnchorPoint = Vector2.new(0, 0.5)
    iconImg.Position    = UDim2.new(0, 0, 0.5, 0)
    iconImg.Size        = UDim2.new(0, 11, 0, 11)
    iconImg.Image       = icon(iconName)
    iconImg.ImageColor3 = Color3.fromRGB(0, 255, 150)
    iconImg.ZIndex      = 5

    local h: TextLabel = Instance.new("TextLabel", wrap)
    h.BackgroundTransparency = 1
    h.Position  = UDim2.new(0, 15, 0, 0)
    h.Size      = UDim2.new(1, -15, 1, 0)
    h.Font      = Enum.Font.Arcade
    h.TextSize  = 9
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.TextColor3     = Color3.fromRGB(0, 255, 150)
    h.ZIndex         = 4
    h.Text           = txt
    return h
end

local function addCopyRow(iconName: string, label: string, value: string, col: Color3?)
    _infoOrder += 1
    local row: Frame = Instance.new("Frame", InfoContent)
    row.Size                   = UDim2.new(1, -6, 0, 17)
    row.BackgroundTransparency = 1
    row.BorderSizePixel        = 0
    row.ZIndex                 = 4
    row.LayoutOrder            = _infoOrder

    local iconImg: ImageLabel = Instance.new("ImageLabel", row)
    iconImg.BackgroundTransparency = 1
    iconImg.AnchorPoint = Vector2.new(0, 0.5)
    iconImg.Position    = UDim2.new(0, 1, 0.5, 0)
    iconImg.Size        = UDim2.new(0, 10, 0, 10)
    iconImg.Image       = icon(iconName)
    iconImg.ImageColor3 = Color3.fromRGB(120, 120, 120)
    iconImg.ZIndex      = 5

    local lbl: TextLabel = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1
    lbl.Position  = UDim2.new(0, 14, 0, 0)
    lbl.Size      = UDim2.new(0.42, -14, 1, 0)
    lbl.Font      = Enum.Font.Arcade
    lbl.TextSize  = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3     = Color3.fromRGB(140, 140, 140)
    lbl.ZIndex         = 4
    lbl.Text           = label

    local copyBtn: TextButton = Instance.new("TextButton", row)
    copyBtn.BackgroundColor3       = Color3.fromRGB(0, 150, 200)
    copyBtn.BackgroundTransparency = 0.75
    copyBtn.BorderSizePixel        = 0
    copyBtn.AnchorPoint            = Vector2.new(1, 0.5)
    copyBtn.Position               = UDim2.new(1, 0, 0.5, 0)
    copyBtn.Size                   = UDim2.new(0.52, 0, 0, 13)
    copyBtn.Font                   = Enum.Font.Arcade
    copyBtn.TextSize               = 7
    copyBtn.TextColor3             = col or Color3.fromRGB(0, 230, 200)
    copyBtn.ZIndex                 = 5
    copyBtn.TextTruncate           = Enum.TextTruncate.AtEnd
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 3)

    local copyIconImg: ImageLabel = Instance.new("ImageLabel", copyBtn)
    copyIconImg.BackgroundTransparency = 1
    copyIconImg.AnchorPoint = Vector2.new(0, 0.5)
    copyIconImg.Position    = UDim2.new(0, 2, 0.5, 0)
    copyIconImg.Size        = UDim2.new(0, 8, 0, 8)
    copyIconImg.Image       = icon("clipboard")
    copyIconImg.ImageColor3 = col or Color3.fromRGB(0, 230, 200)
    copyIconImg.ZIndex      = 6

    local shortVal: string = #value > 14 and value:sub(1, 11) .. "…" or value
    copyBtn.Text = "  " .. shortVal

    copyBtn.MouseButton1Click:Connect(function()
        pcall(setclipboard, value)
        copyIconImg.Image = icon("check")
        copyIconImg.ImageColor3 = Color3.fromRGB(0, 255, 150)
        copyBtn.Text = "  Copied!"
        copyBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.delay(1.5, function()
            pcall(function()
                copyIconImg.Image = icon("clipboard")
                copyIconImg.ImageColor3 = col or Color3.fromRGB(0, 230, 200)
                copyBtn.Text = "  " .. shortVal
                copyBtn.TextColor3 = col or Color3.fromRGB(0, 230, 200)
            end)
        end)
    end)
end

local function addActionCopyRow(iconName: string, label: string, fn: () -> string, col: Color3?)
    _infoOrder += 1
    local row: Frame = Instance.new("Frame", InfoContent)
    row.Size                   = UDim2.new(1, -6, 0, 17)
    row.BackgroundTransparency = 1
    row.BorderSizePixel        = 0
    row.ZIndex                 = 4
    row.LayoutOrder            = _infoOrder

    local iconImg: ImageLabel = Instance.new("ImageLabel", row)
    iconImg.BackgroundTransparency = 1
    iconImg.AnchorPoint = Vector2.new(0, 0.5)
    iconImg.Position    = UDim2.new(0, 1, 0.5, 0)
    iconImg.Size        = UDim2.new(0, 10, 0, 10)
    iconImg.Image       = icon(iconName)
    iconImg.ImageColor3 = Color3.fromRGB(120, 120, 120)
    iconImg.ZIndex      = 5

    local lbl: TextLabel = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1
    lbl.Position  = UDim2.new(0, 14, 0, 0)
    lbl.Size      = UDim2.new(0.40, -14, 1, 0)
    lbl.Font      = Enum.Font.Arcade
    lbl.TextSize  = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3     = Color3.fromRGB(140, 140, 140)
    lbl.ZIndex         = 4
    lbl.Text           = label

    local copyBtn: TextButton = Instance.new("TextButton", row)
    copyBtn.BackgroundColor3       = Color3.fromRGB(0, 150, 200)
    copyBtn.BackgroundTransparency = 0.70
    copyBtn.BorderSizePixel        = 0
    copyBtn.AnchorPoint            = Vector2.new(1, 0.5)
    copyBtn.Position               = UDim2.new(1, 0, 0.5, 0)
    copyBtn.Size                   = UDim2.new(0.55, 0, 0, 13)
    copyBtn.Font                   = Enum.Font.Arcade
    copyBtn.TextSize               = 7
    copyBtn.TextColor3             = col or Color3.fromRGB(0, 230, 200)
    copyBtn.ZIndex                 = 5
    copyBtn.Text                   = "  Copy"
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 3)

    local copyIconImg: ImageLabel = Instance.new("ImageLabel", copyBtn)
    copyIconImg.BackgroundTransparency = 1
    copyIconImg.AnchorPoint = Vector2.new(0, 0.5)
    copyIconImg.Position    = UDim2.new(0, 2, 0.5, 0)
    copyIconImg.Size        = UDim2.new(0, 8, 0, 8)
    copyIconImg.Image       = icon("clipboard")
    copyIconImg.ImageColor3 = col or Color3.fromRGB(0, 230, 200)
    copyIconImg.ZIndex      = 6

    copyBtn.MouseButton1Click:Connect(function()
        local content = fn()
        pcall(setclipboard, content)
        copyIconImg.Image = icon("check")
        copyIconImg.ImageColor3 = Color3.fromRGB(0, 255, 150)
        copyBtn.Text      = "  Copied!"
        copyBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.delay(1.5, function()
            pcall(function()
                copyIconImg.Image = icon("clipboard")
                copyIconImg.ImageColor3 = col or Color3.fromRGB(0, 230, 200)
                copyBtn.Text       = "  Copy"
                copyBtn.TextColor3 = col or Color3.fromRGB(0, 230, 200)
            end)
        end)
    end)
end

local function safeStr(fn: () -> any, fallback: string?): string
    local ok, r = pcall(fn)
    return (ok and r ~= nil) and tostring(r) or (fallback or "N/A")
end

local function checkPremium(): string
    local ok, mt = pcall(function() return Players.LocalPlayer.MembershipType end)
    if ok then return mt == Enum.MembershipType.None and "None" or "Premium" end
    return "N/A"
end

local infoDeviceType = safeStr(function()
    local uis: any = game:GetService("UserInputService")
    local plat = uis:GetPlatform()
    return plat == Enum.Platform.Windows  and "PC"
        or plat == Enum.Platform.OSX      and "Mac"
        or plat == Enum.Platform.Android  and "Android"
        or plat == Enum.Platform.IOS      and "iOS"
        or "Unknown"
end, "Unknown")

local infoExe  = safeStr(function() return identifyexecutor() end, "Unknown")
local infoTime = safeStr(function() return os.date("%Y-%m-%d %H:%M:%S") end, "N/A")

local infoGameName = safeStr(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end, "Unknown Game")

local infoGameId   = tostring(game.PlaceId)
local infoJobId    = tostring(game.JobId)
local infoPlrName  = safeStr(function() return Players.LocalPlayer.Name end, "?")
local infoPlrId    = safeStr(function() return tostring(Players.LocalPlayer.UserId) end, "?")
local infoPremium  = checkPremium()
local infoHwid     = safeStr(function()
    local ras: any = game:GetService("RbxAnalyticsService")
    return ras:GetClientId()
end, "N/A")

local infoTeleport = "game:GetService('TeleportService'):TeleportToPlaceInstance("
    .. infoGameId .. ", '" .. infoJobId .. "', game.Players.LocalPlayer)"

addInfoHeader("layout-dashboard", "Session")
addInfoDivider(_infoOrder + 1)

local timeValLbl = addInfoRow("clock",   "Time",     infoTime,    Color3.fromRGB(200, 200, 100))
addInfoRow("smartphone",                 "Device",   infoDeviceType, Color3.fromRGB(150, 210, 255))
addInfoRow("cog",                        "Executor", infoExe,     Color3.fromRGB(180, 180, 255))
local premiumValLbl = addInfoRow("crown","Premium",  infoPremium, Color3.fromRGB(255, 215, 0))

addInfoDivider(_infoOrder + 1)
addInfoHeader("trending-up", "Performance")
addInfoDivider(_infoOrder + 1)

local fpsValLbl  = addInfoRow("gauge",  "FPS",  "—",    Color3.fromRGB(80, 255, 120))
local pingValLbl = addInfoRow("signal", "Ping", "— ms", Color3.fromRGB(80, 200, 255))

addInfoDivider(_infoOrder + 1)
addInfoHeader("gamepad-2", "Game")
addInfoDivider(_infoOrder + 1)

addInfoRow("tag",  "Name",     infoGameName, Color3.fromRGB(0, 220, 180))
addInfoRow("hash", "Place ID", infoGameId,   Color3.fromRGB(200, 200, 200))
addCopyRow("link", "Job ID",   infoJobId,    Color3.fromRGB(100, 200, 255))

addInfoDivider(_infoOrder + 1)
addInfoHeader("user", "Player")
addInfoDivider(_infoOrder + 1)

addInfoRow("tag",  "Name",    infoPlrName, Color3.fromRGB(0, 220, 180))
addInfoRow("hash", "User ID", infoPlrId,   Color3.fromRGB(200, 200, 200))
addCopyRow("key",  "HWID",    infoHwid,    Color3.fromRGB(255, 150, 100))

addInfoDivider(_infoOrder + 1)
addInfoHeader("map-pin", "Position (live)")
addInfoDivider(_infoOrder + 1)

local posXLbl = addInfoRow("move-horizontal", "X", "—", Color3.fromRGB(255, 100, 100))
local posYLbl = addInfoRow("arrow-up",        "Y", "—", Color3.fromRGB(100, 255, 100))
local posZLbl = addInfoRow("move-3d",         "Z", "—", Color3.fromRGB(100, 150, 255))

local function _tweenCopyFn(): string
    local ok, po = pcall(function()
        return Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end)
    if not ok then return "" end
    local x, y, z = math.floor(po.X), math.floor(po.Y), math.floor(po.Z)
    return string.format(
        "local tweenInfo = TweenInfo.new(2)\n"
        .. "local goal = {CFrame = CFrame.new(%d, %d, %d)}\n"
        .. "local tween = game:GetService('TweenService')"
        .. ":Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, goal)\n"
        .. "tween:Play()",
        x, y, z)
end
addActionCopyRow("rotate-cw", "Copy Tween", _tweenCopyFn, Color3.fromRGB(100, 200, 255))

local function _cfCopyFn(): string
    local ok, pos = pcall(function()
        return Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end)
    if not ok then return "" end
    local o = string.format("%d, %d, %d",
        math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5), math.floor(pos.Z + 0.5))
    return string.format(
        "game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(%s)))", o)
end
addActionCopyRow("move-3d", "Copy CFrame", _cfCopyFn, Color3.fromRGB(0, 255, 150))

addInfoDivider(_infoOrder + 1)
addInfoHeader("send", "Teleport Cmd")
addInfoDivider(_infoOrder + 1)
addCopyRow("rocket", "Copy cmd", infoTeleport, Color3.fromRGB(0, 255, 150))

local CREATOR_USER_ID: number = 1291925

local STATUS_COLOR_INGAME: Color3  = Color3.fromRGB(0, 255, 110)
local STATUS_COLOR_ONLINE: Color3  = Color3.fromRGB(255, 200, 0)
local STATUS_COLOR_OFFLINE: Color3 = Color3.fromRGB(120, 120, 130)

local function getPresence(userId: number): (number, string?, number?)
    if not http_request_fn then
        return 0, nil, nil
    end

    local resultType: number      = 0
    local resultGame: string?     = nil
    local resultUniverse: number? = nil

    local wholeOk: boolean = pcall(function()
        local function fetch(token: string?): any
            return http_request_fn({
                Url     = "https://presence.roblox.com/v1/presence/users",
                Method  = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["X-CSRF-TOKEN"] = token,
                },
                Body    = HttpService:JSONEncode({ userIds = { userId } }),
            })
        end

        local res: any = fetch(nil)
        if type(res) == "table" then
            local status: any = res.StatusCode or res.statusCode
            if status == 403 then
                local headers: any = res.Headers or res.headers
                local token: string? = (type(headers) == "table")
                    and (headers["x-csrf-token"] or headers["X-CSRF-TOKEN"])
                    or nil
                if token then
                    res = fetch(token)
                end
            end
        end

        if type(res) ~= "table" then return end
        local body: any = res.Body or res.body
        if type(body) ~= "string" or #body == 0 then return end

        local data: any = HttpService:JSONDecode(body)
        if type(data) ~= "table" or type(data.userPresences) ~= "table" then return end

        local presence: any = data.userPresences[1]
        if type(presence) ~= "table" then return end

        if type(presence.userPresenceType) == "number" then
            resultType = presence.userPresenceType
        end
        if type(presence.lastLocation) == "string" then
            resultGame = presence.lastLocation
        end
        if type(presence.universeId) == "number" then
            resultUniverse = presence.universeId
        end
    end)

    if not wholeOk then
        return 0, nil, nil
    end
    return resultType, resultGame, resultUniverse
end

local function resolveGameName(universeId: number?): string?
    if not http_request_fn or type(universeId) ~= "number" or universeId == 0 then
        return nil
    end

    local result: string? = nil
    pcall(function()
        local res: any = http_request_fn({
            Url    = "https://games.roblox.com/v1/games?universeIds=" .. tostring(universeId),
            Method = "GET",
        })
        if type(res) ~= "table" then return end
        local body: any = res.Body or res.body
        if type(body) ~= "string" or #body == 0 then return end
        local data: any = HttpService:JSONDecode(body)
        if type(data) ~= "table" or type(data.data) ~= "table" then return end
        local first: any = data.data[1]
        if type(first) ~= "table" or type(first.name) ~= "string" then return end
        result = first.name
    end)
    return result
end

local CreditContent: ScrollingFrame = Instance.new("ScrollingFrame", SettingsPanel)
CreditContent.Name                   = "CreditContent"
CreditContent.Position               = UDim2.new(0, 0, 0, CONTENT_Y)
CreditContent.Size                   = UDim2.new(1, 0, 1, -CONTENT_Y - 4)
CreditContent.BackgroundTransparency = 1
CreditContent.BorderSizePixel        = 0
CreditContent.ClipsDescendants       = true
CreditContent.ScrollBarThickness     = 4
CreditContent.ScrollBarImageColor3   = Color3.fromRGB(0, 255, 150)
CreditContent.ScrollingDirection     = Enum.ScrollingDirection.Y
CreditContent.AutomaticCanvasSize    = Enum.AutomaticSize.Y
CreditContent.CanvasSize             = UDim2.new(0, 0, 0, 0)
CreditContent.ZIndex                 = 3
CreditContent.Visible                = false

do
    local CreditList: UIListLayout = Instance.new("UIListLayout", CreditContent)
    CreditList.Padding             = UDim.new(0, 6)
    CreditList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CreditList.VerticalAlignment   = Enum.VerticalAlignment.Top
    CreditList.SortOrder           = Enum.SortOrder.LayoutOrder

    local CreditPad: UIPadding = Instance.new("UIPadding", CreditContent)
    CreditPad.PaddingTop    = UDim.new(0, 6)
    CreditPad.PaddingLeft   = UDim.new(0, 6)
    CreditPad.PaddingRight  = UDim.new(0, 6)
    CreditPad.PaddingBottom = UDim.new(0, 8)
end

local AvatarCard: Frame = Instance.new("Frame", CreditContent)
AvatarCard.LayoutOrder        = 1
AvatarCard.Size               = UDim2.new(1, 0, 0, 268)
AvatarCard.BackgroundColor3   = Color3.fromRGB(6, 14, 12)
AvatarCard.BackgroundTransparency = 0.2
AvatarCard.BorderSizePixel    = 0
AvatarCard.ZIndex             = 4
AvatarCard.ClipsDescendants   = false
Instance.new("UICorner", AvatarCard).CornerRadius = UDim.new(0, 8)
do
    local AvatarCardStroke: UIStroke = Instance.new("UIStroke", AvatarCard)
    AvatarCardStroke.Color        = Color3.fromRGB(0, 255, 150)
    AvatarCardStroke.Thickness    = 1.5
    AvatarCardStroke.Transparency = 0.35
    task.spawn(function()
        while AvatarCard and AvatarCard.Parent do
            pcall(function()
                TweenService:Create(AvatarCardStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Color = Color3.fromRGB(0, 200, 255), Transparency = 0.6
                }):Play()
            end)
            task.wait(2)
            pcall(function()
                TweenService:Create(AvatarCardStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Color = Color3.fromRGB(0, 255, 150), Transparency = 0.35
                }):Play()
            end)
            task.wait(2)
        end
    end)
end

local AvatarImg: ImageLabel = Instance.new("ImageLabel", AvatarCard)
AvatarImg.AnchorPoint        = Vector2.new(0, 0)
AvatarImg.Position           = UDim2.new(0, 6, 0, 6)
AvatarImg.Size               = UDim2.new(0, 50, 0, 50)
AvatarImg.BackgroundColor3   = Color3.fromRGB(20, 20, 30)
AvatarImg.BorderSizePixel    = 0
AvatarImg.Image              = ""
AvatarImg.ImageTransparency  = 1
AvatarImg.ZIndex             = 5
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
do
    local AvatarStroke: UIStroke = Instance.new("UIStroke", AvatarImg)
    AvatarStroke.Color        = Color3.fromRGB(0, 255, 150)
    AvatarStroke.Thickness    = 1.5
    AvatarStroke.Transparency = 0.2
end

local StatusRing: Frame = Instance.new("Frame", AvatarImg)
StatusRing.AnchorPoint      = Vector2.new(1, 1)
StatusRing.Position         = UDim2.new(1, 3, 1, 3)
StatusRing.Size             = UDim2.new(0, 18, 0, 18)
StatusRing.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
StatusRing.BorderSizePixel  = 0
StatusRing.ZIndex           = 6
Instance.new("UICorner", StatusRing).CornerRadius = UDim.new(1, 0)

local StatusDot: Frame = Instance.new("Frame", StatusRing)
StatusDot.AnchorPoint      = Vector2.new(0.5, 0.5)
StatusDot.Position         = UDim2.new(0.5, 0, 0.5, 0)
StatusDot.Size             = UDim2.new(0, 12, 0, 12)
StatusDot.BackgroundColor3 = STATUS_COLOR_OFFLINE
StatusDot.BorderSizePixel  = 0
StatusDot.ZIndex           = 7
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local AvatarLoadingLbl: TextLabel = Instance.new("TextLabel", AvatarImg)
AvatarLoadingLbl.Size              = UDim2.new(1, 0, 1, 0)
AvatarLoadingLbl.BackgroundTransparency = 1
AvatarLoadingLbl.Font              = Enum.Font.GothamBold
AvatarLoadingLbl.Text              = "..."
AvatarLoadingLbl.TextSize          = 10
AvatarLoadingLbl.TextColor3        = Color3.fromRGB(0, 200, 255)
AvatarLoadingLbl.ZIndex            = 6

do
    local CreatorName: TextLabel = Instance.new("TextLabel", AvatarCard)
    CreatorName.Position           = UDim2.new(0, 62, 0, 6)
    CreatorName.Size               = UDim2.new(0, 30, 0, 14)
    CreatorName.BackgroundTransparency = 1
    CreatorName.Font               = Enum.Font.Arcade
    CreatorName.Text               = "alwi"
    CreatorName.TextScaled         = true
    CreatorName.TextXAlignment     = Enum.TextXAlignment.Left
    CreatorName.TextColor3         = Color3.fromRGB(0, 255, 150)
    CreatorName.TextStrokeTransparency = 0.3
    CreatorName.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
    CreatorName.ZIndex             = 5

    local OwnerTagPill: Frame = Instance.new("Frame", AvatarCard)
    OwnerTagPill.Position        = UDim2.new(0, 96, 0, 7)
    OwnerTagPill.Size            = UDim2.new(0, 40, 0, 12)
    OwnerTagPill.BorderSizePixel = 0
    OwnerTagPill.ZIndex          = 7
    Instance.new("UICorner", OwnerTagPill).CornerRadius = UDim.new(1, 0)
    do
        local OGrad: UIGradient = Instance.new("UIGradient", OwnerTagPill)
        OGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255)),
        }
        OGrad.Rotation = 90
    end
    local OwnerTagLbl: TextLabel = Instance.new("TextLabel", OwnerTagPill)
    OwnerTagLbl.Size = UDim2.new(1, 0, 1, 0)
    OwnerTagLbl.BackgroundTransparency = 1
    OwnerTagLbl.Font = Enum.Font.Arcade
    OwnerTagLbl.Text = "Owner"
    OwnerTagLbl.TextScaled = true
    OwnerTagLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    OwnerTagLbl.ZIndex = 8

    local CreatorTitle: TextLabel = Instance.new("TextLabel", AvatarCard)
    CreatorTitle.Position          = UDim2.new(0, 62, 0, 22)
    CreatorTitle.Size              = UDim2.new(1, -68, 0, 11)
    CreatorTitle.BackgroundTransparency = 1
    CreatorTitle.Font              = Enum.Font.Arcade
    CreatorTitle.Text              = "Creator of Alwi Hub"
    CreatorTitle.TextSize          = 8
    CreatorTitle.TextXAlignment    = Enum.TextXAlignment.Left
    CreatorTitle.TextColor3        = Color3.fromRGB(180, 180, 255)
    CreatorTitle.ZIndex            = 5
end

local StatusLabel: TextLabel = Instance.new("TextLabel", AvatarCard)
StatusLabel.Position          = UDim2.new(0, 62, 0, 34)
StatusLabel.Size              = UDim2.new(1, -68, 0, 12)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font              = Enum.Font.Arcade
StatusLabel.Text              = "Offline"
StatusLabel.TextSize          = 8
StatusLabel.TextXAlignment    = Enum.TextXAlignment.Left
StatusLabel.TextColor3        = STATUS_COLOR_OFFLINE
StatusLabel.ZIndex            = 5

local RobloxBadge: TextButton = Instance.new("TextButton", AvatarCard)
RobloxBadge.Position          = UDim2.new(0, 62, 0, 48)
RobloxBadge.Size              = UDim2.new(1, -68, 0, 16)
RobloxBadge.BackgroundColor3  = Color3.fromRGB(226, 35, 26)
RobloxBadge.BackgroundTransparency = 0.15
RobloxBadge.BorderSizePixel   = 0
RobloxBadge.Font              = Enum.Font.Arcade
RobloxBadge.Text              = "Roblox Profile"
RobloxBadge.TextSize          = 8
RobloxBadge.TextColor3        = Color3.fromRGB(255, 255, 255)
RobloxBadge.ZIndex            = 5
Instance.new("UICorner", RobloxBadge).CornerRadius = UDim.new(0, 4)
do
    local RobloxBadgeStroke: UIStroke = Instance.new("UIStroke", RobloxBadge)
    RobloxBadgeStroke.Color        = Color3.fromRGB(255, 80, 80)
    RobloxBadgeStroke.Thickness    = 1
    RobloxBadgeStroke.Transparency = 0.4
end

local RobloxBadgeScale: UIScale = Instance.new("UIScale", RobloxBadge)
RobloxBadgeScale.Scale = 1

EffectClick2 = function(c, p)
    local Mouse = Players.LocalPlayer:GetMouse()
    local relativeX = Mouse.X - c.AbsolutePosition.X
    local relativeY = Mouse.Y - c.AbsolutePosition.Y
    if relativeX < 0 or relativeY < 0 or relativeX > c.AbsoluteSize.X or relativeY > c.AbsoluteSize.Y then return end
    local ClickButtonCircle = Instance.new("Frame")
    ClickButtonCircle.Parent = p
    ClickButtonCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClickButtonCircle.BackgroundTransparency = 0.5
    ClickButtonCircle.BorderSizePixel = 0
    ClickButtonCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    ClickButtonCircle.Position = UDim2.new(0, relativeX, 0, relativeY)
    ClickButtonCircle.Size = UDim2.new(0, 0, 0, 0)
    ClickButtonCircle.ZIndex = 10
    local UIGradient_2 = Instance.new("UIGradient")
    UIGradient_2.Parent = ClickButtonCircle
    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 127)), ColorSequenceKeypoint.new(0.482699, Color3.fromRGB(0, 170, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 85, 255))}
    UIGradient_2.Rotation = 48
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ClickButtonCircle
    local expandTween = TweenService:Create(ClickButtonCircle, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, c.AbsoluteSize.X * 1.5, 0, c.AbsoluteSize.X * 1.5),
        BackgroundTransparency = 1
    })
    expandTween.Completed:Connect(function() ClickButtonCircle:Destroy() end)
    expandTween:Play()
end

RobloxBadge.MouseButton1Click:Connect(function()
    pcall(setclipboard, "https://www.roblox.com/users/1291925/profile")
    task.spawn(function()
        pcall(function()
            TweenService:Create(RobloxBadgeScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.88 }):Play()
            task.wait(0.09)
            TweenService:Create(RobloxBadgeScale, TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end)
    end)
    RobloxBadge.Text = "✓ Copied!"
    task.delay(2, function() pcall(function() RobloxBadge.Text = "Roblox Profile" end) end)
end)

do
    local Div1: Frame = Instance.new("Frame", AvatarCard)
    Div1.Position = UDim2.new(0, 4, 0, 68)
    Div1.Size     = UDim2.new(1, -8, 0, 1)
    Div1.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    Div1.BackgroundTransparency = 0.6
    Div1.BorderSizePixel = 0
    Div1.ZIndex = 5
end

do
    local AboutHdr: TextLabel = Instance.new("TextLabel", AvatarCard)
    AboutHdr.Position = UDim2.new(0, 6, 0, 71)
    AboutHdr.Size     = UDim2.new(1, -8, 0, 11)
    AboutHdr.BackgroundTransparency = 1
    AboutHdr.Font     = Enum.Font.Arcade
    AboutHdr.Text     = "About me :"
    AboutHdr.TextSize = 8
    AboutHdr.TextXAlignment = Enum.TextXAlignment.Left
    AboutHdr.TextColor3 = Color3.fromRGB(0, 200, 255)
    AboutHdr.ZIndex   = 5

    local BioText: TextLabel = Instance.new("TextLabel", AvatarCard)
    BioText.Position  = UDim2.new(0, 6, 0, 83)
    BioText.Size      = UDim2.new(1, -12, 0, 42)
    BioText.BackgroundTransparency = 1
    BioText.Font      = Enum.Font.Arcade
    BioText.Text      = "Hey is me Alwi, creator of Alwi Hub!\nI like furry 🦊 (fox / kenomo) & fabulous beast\n\"you shou yan\" :3  Enjoy the script! ❤"
    BioText.TextSize  = 8
    BioText.TextXAlignment = Enum.TextXAlignment.Left
    BioText.TextYAlignment = Enum.TextYAlignment.Top
    BioText.TextWrapped = true
    BioText.TextColor3 = Color3.fromRGB(210, 210, 210)
    BioText.ZIndex    = 5

    local FoxPaw: TextLabel = Instance.new("TextLabel", AvatarCard)
    FoxPaw.AnchorPoint = Vector2.new(1, 0)
    FoxPaw.Position    = UDim2.new(1, -4, 0, 107)
    FoxPaw.Size        = UDim2.new(0, 20, 0, 18)
    FoxPaw.BackgroundTransparency = 1
    FoxPaw.Font        = Enum.Font.GothamBold
    FoxPaw.Text        = "🐾"
    FoxPaw.TextSize    = 12
    FoxPaw.TextTransparency = 0.3
    FoxPaw.ZIndex      = 5
end

do
    local Div2: Frame = Instance.new("Frame", AvatarCard)
    Div2.Position = UDim2.new(0, 4, 0, 128)
    Div2.Size     = UDim2.new(1, -8, 0, 1)
    Div2.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    Div2.BackgroundTransparency = 0.6
    Div2.BorderSizePixel = 0
    Div2.ZIndex = 5
end

do
    local TagsHdr: TextLabel = Instance.new("TextLabel", AvatarCard)
    TagsHdr.Position = UDim2.new(0, 6, 0, 131)
    TagsHdr.Size     = UDim2.new(1, -8, 0, 10)
    TagsHdr.BackgroundTransparency = 1
    TagsHdr.Font     = Enum.Font.Arcade
    TagsHdr.Text     = "Tags :"
    TagsHdr.TextSize = 7
    TagsHdr.TextXAlignment = Enum.TextXAlignment.Left
    TagsHdr.TextColor3 = Color3.fromRGB(0, 200, 255)
    TagsHdr.ZIndex   = 5

    local TS_a = game:GetService("TextService")
    local function makeARow(yOff: number): Frame
        local row: Frame = Instance.new("Frame", AvatarCard)
        row.Position = UDim2.new(0, 4, 0, yOff)
        row.Size     = UDim2.new(1, -8, 0, 16)
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.ZIndex   = 5
        local ll: UIListLayout = Instance.new("UIListLayout", row)
        ll.FillDirection       = Enum.FillDirection.Horizontal
        ll.HorizontalAlignment = Enum.HorizontalAlignment.Left
        ll.VerticalAlignment   = Enum.VerticalAlignment.Center
        ll.Padding             = UDim.new(0, 4)
        return row
    end
    local ARow1: Frame = makeARow(143)
    local ARow2: Frame = makeARow(161)

    local function addATag(parent: Frame, txt: string, col: Color3)
        local tag: TextLabel = Instance.new("TextLabel", parent)
        tag.BackgroundColor3       = col
        tag.BackgroundTransparency = 0.4
        tag.BorderSizePixel        = 0
        tag.Font                   = Enum.Font.Arcade
        tag.Text                   = txt
        tag.TextSize               = 7
        tag.TextColor3             = Color3.fromRGB(255, 255, 255)
        tag.ZIndex                 = 6
        Instance.new("UICorner", tag).CornerRadius = UDim.new(1, 0)
        local sz: Vector2 = TS_a:GetTextSize(txt, 7, Enum.Font.Arcade, Vector2.new(200, 20))
        tag.Size = UDim2.new(0, sz.X + 12, 0, 14)
    end

    addATag(ARow1, "fox",                 Color3.fromRGB(255, 115, 15))
    addATag(ARow1, "kenomo",              Color3.fromRGB(110, 70,  210))
    addATag(ARow1, "furry",               Color3.fromRGB(190, 55,  115))
    addATag(ARow1, "like fabulous beast", Color3.fromRGB(0,   150, 220))
    addATag(ARow2, "Lua 3yr",             Color3.fromRGB(30,  160, 100))
    addATag(ARow2, "Introvert",           Color3.fromRGB(60,  90,  180))
    addATag(ARow2, "Ragebait",            Color3.fromRGB(200, 50,  50))
end

do
    local Div3: Frame = Instance.new("Frame", AvatarCard)
    Div3.Position = UDim2.new(0, 4, 0, 181)
    Div3.Size     = UDim2.new(1, -8, 0, 1)
    Div3.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    Div3.BackgroundTransparency = 0.6
    Div3.BorderSizePixel = 0
    Div3.ZIndex = 5
end

do
    local SocialHdr: TextLabel = Instance.new("TextLabel", AvatarCard)
    SocialHdr.Position = UDim2.new(0, 6, 0, 184)
    SocialHdr.Size     = UDim2.new(1, -8, 0, 11)
    SocialHdr.BackgroundTransparency = 1
    SocialHdr.Font     = Enum.Font.Arcade
    SocialHdr.Text     = "Social :"
    SocialHdr.TextSize = 8
    SocialHdr.TextXAlignment = Enum.TextXAlignment.Left
    SocialHdr.TextColor3 = Color3.fromRGB(0, 200, 255)
    SocialHdr.ZIndex   = 5
end

local SocialRow: ScrollingFrame = Instance.new("ScrollingFrame", AvatarCard)
SocialRow.Position               = UDim2.new(0, 0, 0, 197)
SocialRow.Size                   = UDim2.new(1, 0, 0, 58)
SocialRow.BackgroundTransparency = 1
SocialRow.BorderSizePixel        = 0
SocialRow.ZIndex                 = 4
SocialRow.ScrollBarThickness     = 3
SocialRow.ScrollBarImageColor3   = Color3.fromRGB(0, 200, 255)
SocialRow.ScrollingDirection     = Enum.ScrollingDirection.X
SocialRow.AutomaticCanvasSize    = Enum.AutomaticSize.X
SocialRow.CanvasSize             = UDim2.new(0, 0, 0, 0)
do
    local SocialList: UIListLayout = Instance.new("UIListLayout", SocialRow)
    SocialList.FillDirection       = Enum.FillDirection.Horizontal
    SocialList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    SocialList.VerticalAlignment   = Enum.VerticalAlignment.Center
    SocialList.Padding             = UDim.new(0, 10)
    local SocialPad: UIPadding = Instance.new("UIPadding", SocialRow)
    SocialPad.PaddingLeft   = UDim.new(0, 4)
    SocialPad.PaddingRight  = UDim.new(0, 4)
    SocialPad.PaddingTop    = UDim.new(0, 6)
    SocialPad.PaddingBottom = UDim.new(0, 4)
end

local function makeSocialBtn(
    iconId: string,
    imgId: string?,
    label: string,
    link: string,
    bgCol: Color3,
    strokeCol: Color3
)
    local btn: TextButton = Instance.new("TextButton", SocialRow)
    btn.BackgroundColor3       = bgCol
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel        = 0
    btn.Size                   = UDim2.new(0, 80, 0, 44)
    btn.Font                   = Enum.Font.Arcade
    btn.Text                   = ""
    btn.ZIndex                 = 5
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    do
        local btnStroke: UIStroke = Instance.new("UIStroke", btn)
        btnStroke.Color       = strokeCol
        btnStroke.Thickness   = 1
        btnStroke.Transparency = 0.5
    end

    local img: ImageLabel = Instance.new("ImageLabel", btn)
    img.AnchorPoint            = Vector2.new(0.5, 0)
    img.Position               = UDim2.new(0.5, 0, 0, 4)
    img.Size                   = UDim2.new(0, 22, 0, 22)
    img.BackgroundTransparency = 1
    img.Image                  = imgId or ("rbxassetid://" .. iconId)
    img.ImageColor3            = Color3.fromRGB(255, 255, 255)
    img.ZIndex                 = 6

    local lbl: TextLabel = Instance.new("TextLabel", btn)
    lbl.AnchorPoint            = Vector2.new(0.5, 1)
    lbl.Position               = UDim2.new(0.5, 0, 1, -4)
    lbl.Size                   = UDim2.new(1, -4, 0, 12)
    lbl.BackgroundTransparency = 1
    lbl.Font                   = Enum.Font.Arcade
    lbl.Text                   = label
    lbl.TextSize               = 7
    lbl.TextColor3             = Color3.fromRGB(230, 230, 230)
    lbl.ZIndex                 = 6

    local btnScale: UIScale = Instance.new("UIScale", btn)
    btnScale.Scale = 1

    btn.MouseButton1Click:Connect(function()
        pcall(setclipboard, link)
        pcall(function()
            TweenService:Create(btnScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.88 }):Play()
            task.wait(0.09)
            TweenService:Create(btnScale, TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end)
        local prev = lbl.Text
        lbl.Text = "✓ Copied"
        task.delay(2, function() pcall(function() lbl.Text = prev end) end)
    end)
end

makeSocialBtn("94937742565147",   nil, "Discord", "https://discord.com/users/1136652082091409468", Color3.fromRGB(88,  101, 242), Color3.fromRGB(58,  30,  180))
makeSocialBtn("140193697070787",  nil, "YouTube", "https://youtube.com/@IkuraJust",                Color3.fromRGB(255, 30,  30),  Color3.fromRGB(180, 0,   60))
makeSocialBtn("99316223126384",   nil, "Roblox",  "https://www.roblox.com/users/1291925/profile",  Color3.fromRGB(226, 35,  26),  Color3.fromRGB(180, 60,  20))
makeSocialBtn("117782741969829",  nil, "GitHub",  "https://github.com/mainery-foxxie",             Color3.fromRGB(30,  30,  30),  Color3.fromRGB(80,  80,  80))

local SINQUE_USER_ID: number = 1930806367

local HelperAvatarImg: ImageLabel
local HelperLoadingLbl: TextLabel
local HelperRobloxBtnScale: UIScale

do
local HelperCard: Frame = Instance.new("Frame", CreditContent)
HelperCard.LayoutOrder        = 2
HelperCard.Size               = UDim2.new(1, 0, 0, 248)
HelperCard.BackgroundColor3   = Color3.fromRGB(8, 10, 22)
HelperCard.BackgroundTransparency = 0.2
HelperCard.BorderSizePixel    = 0
HelperCard.ZIndex             = 4
HelperCard.ClipsDescendants   = false
Instance.new("UICorner", HelperCard).CornerRadius = UDim.new(0, 8)

do
    local HelperCardStroke: UIStroke = Instance.new("UIStroke", HelperCard)
    HelperCardStroke.Color        = Color3.fromRGB(100, 120, 255)
    HelperCardStroke.Thickness    = 1.5
    HelperCardStroke.Transparency = 0.35
    task.spawn(function()
        while HelperCard and HelperCard.Parent do
            pcall(function()
                TweenService:Create(HelperCardStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Color = Color3.fromRGB(180, 100, 255), Transparency = 0.6
                }):Play()
            end)
            task.wait(2)
            pcall(function()
                TweenService:Create(HelperCardStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Color = Color3.fromRGB(100, 120, 255), Transparency = 0.35
                }):Play()
            end)
            task.wait(2)
        end
    end)
end

HelperAvatarImg = Instance.new("ImageLabel", HelperCard)
HelperAvatarImg.AnchorPoint       = Vector2.new(0, 0)
HelperAvatarImg.Position          = UDim2.new(0, 6, 0, 6)
HelperAvatarImg.Size              = UDim2.new(0, 50, 0, 50)
HelperAvatarImg.BackgroundColor3  = Color3.fromRGB(15, 15, 30)
HelperAvatarImg.BorderSizePixel   = 0
HelperAvatarImg.Image             = ""
HelperAvatarImg.ImageTransparency = 1
HelperAvatarImg.ZIndex            = 5
Instance.new("UICorner", HelperAvatarImg).CornerRadius = UDim.new(1, 0)
do
    local HelperAvatarStroke: UIStroke = Instance.new("UIStroke", HelperAvatarImg)
    HelperAvatarStroke.Color        = Color3.fromRGB(130, 100, 255)
    HelperAvatarStroke.Thickness    = 1.5
    HelperAvatarStroke.Transparency = 0.2
end

HelperLoadingLbl = Instance.new("TextLabel", HelperAvatarImg)
HelperLoadingLbl.Size                  = UDim2.new(1, 0, 1, 0)
HelperLoadingLbl.BackgroundTransparency = 1
HelperLoadingLbl.Font                  = Enum.Font.GothamBold
HelperLoadingLbl.Text                  = "..."
HelperLoadingLbl.TextSize              = 10
HelperLoadingLbl.TextColor3            = Color3.fromRGB(130, 100, 255)
HelperLoadingLbl.ZIndex                = 6

do
    local HelperName: TextLabel = Instance.new("TextLabel", HelperCard)
    HelperName.Position           = UDim2.new(0, 62, 0, 6)
    HelperName.Size               = UDim2.new(0, 36, 0, 14)
    HelperName.BackgroundTransparency = 1
    HelperName.Font               = Enum.Font.Arcade
    HelperName.Text               = "sinque"
    HelperName.TextScaled         = true
    HelperName.TextXAlignment     = Enum.TextXAlignment.Left
    HelperName.TextColor3         = Color3.fromRGB(130, 150, 255)
    HelperName.TextStrokeTransparency = 0.3
    HelperName.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
    HelperName.ZIndex             = 5

    local HelperTagPill: Frame = Instance.new("Frame", HelperCard)
    HelperTagPill.Position        = UDim2.new(0, 102, 0, 7)
    HelperTagPill.Size            = UDim2.new(0, 40, 0, 12)
    HelperTagPill.BorderSizePixel = 0
    HelperTagPill.ZIndex          = 7
    Instance.new("UICorner", HelperTagPill).CornerRadius = UDim.new(1, 0)
    do
        local HPGrad: UIGradient = Instance.new("UIGradient", HelperTagPill)
        HPGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 120, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80,  255)),
        }
        HPGrad.Rotation = 90
    end
    local HelperTagLbl: TextLabel = Instance.new("TextLabel", HelperTagPill)
    HelperTagLbl.Size = UDim2.new(1, 0, 1, 0)
    HelperTagLbl.BackgroundTransparency = 1
    HelperTagLbl.Font = Enum.Font.Arcade
    HelperTagLbl.Text = "Helper"
    HelperTagLbl.TextScaled = true
    HelperTagLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    HelperTagLbl.ZIndex = 8

    local HelperTitle: TextLabel = Instance.new("TextLabel", HelperCard)
    HelperTitle.Position          = UDim2.new(0, 62, 0, 22)
    HelperTitle.Size              = UDim2.new(1, -68, 0, 11)
    HelperTitle.BackgroundTransparency = 1
    HelperTitle.Font              = Enum.Font.Arcade
    HelperTitle.Text              = "Helper of Alwi Hub"
    HelperTitle.TextSize          = 8
    HelperTitle.TextXAlignment    = Enum.TextXAlignment.Left
    HelperTitle.TextColor3        = Color3.fromRGB(180, 180, 255)
    HelperTitle.ZIndex            = 5
end

local HelperStatusRing: Frame = Instance.new("Frame", HelperAvatarImg)
HelperStatusRing.AnchorPoint      = Vector2.new(1, 1)
HelperStatusRing.Position         = UDim2.new(1, 3, 1, 3)
HelperStatusRing.Size             = UDim2.new(0, 18, 0, 18)
HelperStatusRing.BackgroundColor3 = Color3.fromRGB(8, 10, 22)
HelperStatusRing.BorderSizePixel  = 0
HelperStatusRing.ZIndex           = 6
Instance.new("UICorner", HelperStatusRing).CornerRadius = UDim.new(1, 0)

local HelperStatusDot: Frame = Instance.new("Frame", HelperStatusRing)
HelperStatusDot.AnchorPoint      = Vector2.new(0.5, 0.5)
HelperStatusDot.Position         = UDim2.new(0.5, 0, 0.5, 0)
HelperStatusDot.Size             = UDim2.new(0, 12, 0, 12)
HelperStatusDot.BackgroundColor3 = STATUS_COLOR_OFFLINE
HelperStatusDot.BorderSizePixel  = 0
HelperStatusDot.ZIndex           = 7
Instance.new("UICorner", HelperStatusDot).CornerRadius = UDim.new(1, 0)

local HelperStatusLabel: TextLabel = Instance.new("TextLabel", HelperCard)
HelperStatusLabel.Position          = UDim2.new(0, 62, 0, 34)
HelperStatusLabel.Size              = UDim2.new(1, -68, 0, 12)
HelperStatusLabel.BackgroundTransparency = 1
HelperStatusLabel.Font              = Enum.Font.Arcade
HelperStatusLabel.Text              = "Offline"
HelperStatusLabel.TextSize          = 8
HelperStatusLabel.TextXAlignment    = Enum.TextXAlignment.Left
HelperStatusLabel.TextColor3        = STATUS_COLOR_OFFLINE
HelperStatusLabel.ZIndex            = 5

task.spawn(function()
    local ok, presType = pcall(function()
        local ps = game:GetService("Players")
        local data = ps:GetFriendInfoAsync(SINQUE_USER_ID)
        return data and data.IsOnline and 2 or 0
    end)
    local col = (ok and presType and presType > 0) and STATUS_COLOR_ONLINE or STATUS_COLOR_OFFLINE
    local txt = (ok and presType and presType > 0) and "Online" or "Offline"
    pcall(function()
        HelperStatusDot.BackgroundColor3  = col
        HelperStatusLabel.TextColor3      = col
        HelperStatusLabel.Text            = txt
    end)
end)

local HelperProfileBtn: TextButton = Instance.new("TextButton", HelperCard)
HelperProfileBtn.Position          = UDim2.new(0, 62, 0, 48)
HelperProfileBtn.Size              = UDim2.new(1, -68, 0, 16)
HelperProfileBtn.BackgroundColor3  = Color3.fromRGB(100, 80, 220)
HelperProfileBtn.BackgroundTransparency = 0.15
HelperProfileBtn.BorderSizePixel   = 0
HelperProfileBtn.Font              = Enum.Font.Arcade
HelperProfileBtn.Text              = "Roblox Profile"
HelperProfileBtn.TextSize          = 8
HelperProfileBtn.TextColor3        = Color3.fromRGB(255, 255, 255)
HelperProfileBtn.ZIndex            = 5
Instance.new("UICorner", HelperProfileBtn).CornerRadius = UDim.new(0, 4)
do
    local HelperRobloxBtnStroke: UIStroke = Instance.new("UIStroke", HelperProfileBtn)
    HelperRobloxBtnStroke.Color        = Color3.fromRGB(130, 100, 255)
    HelperRobloxBtnStroke.Thickness    = 1
    HelperRobloxBtnStroke.Transparency = 0.4
end

HelperRobloxBtnScale = Instance.new("UIScale", HelperProfileBtn)
HelperRobloxBtnScale.Scale = 1

HelperProfileBtn.MouseButton1Click:Connect(function()
    pcall(setclipboard, "https://www.roblox.com/users/1930806367/profile")
    task.spawn(function()
        pcall(function()
            TweenService:Create(HelperRobloxBtnScale,
                TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Scale = 0.88 }):Play()
            task.wait(0.09)
            TweenService:Create(HelperRobloxBtnScale,
                TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                { Scale = 1 }):Play()
        end)
    end)
    HelperProfileBtn.Text = "✓ Copied!"
    task.delay(2, function() pcall(function() HelperProfileBtn.Text = "Roblox Profile" end) end)
end)

do
    local HDiv1: Frame = Instance.new("Frame", HelperCard)
    HDiv1.Position = UDim2.new(0, 4, 0, 78)
    HDiv1.Size     = UDim2.new(1, -8, 0, 1)
    HDiv1.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    HDiv1.BackgroundTransparency = 0.55
    HDiv1.BorderSizePixel = 0
    HDiv1.ZIndex = 5
end

do
    local HAboutHdr: TextLabel = Instance.new("TextLabel", HelperCard)
    HAboutHdr.Position = UDim2.new(0, 6, 0, 81)
    HAboutHdr.Size     = UDim2.new(1, -8, 0, 11)
    HAboutHdr.BackgroundTransparency = 1
    HAboutHdr.Font     = Enum.Font.Arcade
    HAboutHdr.Text     = "About me :"
    HAboutHdr.TextSize = 8
    HAboutHdr.TextXAlignment = Enum.TextXAlignment.Left
    HAboutHdr.TextColor3 = Color3.fromRGB(130, 150, 255)
    HAboutHdr.ZIndex   = 5

    local HBioText: TextLabel = Instance.new("TextLabel", HelperCard)
    HBioText.Position  = UDim2.new(0, 6, 0, 93)
    HBioText.Size      = UDim2.new(1, -12, 0, 36)
    HBioText.BackgroundTransparency = 1
    HBioText.Font      = Enum.Font.Arcade
    HBioText.Text      = "Hiya!! I am friend of school of alwi :3\nwe both are best friends!"
    HBioText.TextSize  = 8
    HBioText.TextXAlignment = Enum.TextXAlignment.Left
    HBioText.TextYAlignment = Enum.TextYAlignment.Top
    HBioText.TextWrapped = true
    HBioText.TextColor3 = Color3.fromRGB(210, 210, 210)
    HBioText.ZIndex    = 5
end

do
    local HDiv2: Frame = Instance.new("Frame", HelperCard)
    HDiv2.Position = UDim2.new(0, 4, 0, 133)
    HDiv2.Size     = UDim2.new(1, -8, 0, 1)
    HDiv2.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    HDiv2.BackgroundTransparency = 0.55
    HDiv2.BorderSizePixel = 0
    HDiv2.ZIndex = 5
end

do
    local HTagsHdr: TextLabel = Instance.new("TextLabel", HelperCard)
    HTagsHdr.Position = UDim2.new(0, 6, 0, 136)
    HTagsHdr.Size     = UDim2.new(1, -8, 0, 10)
    HTagsHdr.BackgroundTransparency = 1
    HTagsHdr.Font     = Enum.Font.Arcade
    HTagsHdr.Text     = "Tags :"
    HTagsHdr.TextSize = 7
    HTagsHdr.TextXAlignment = Enum.TextXAlignment.Left
    HTagsHdr.TextColor3 = Color3.fromRGB(130, 150, 255)
    HTagsHdr.ZIndex   = 5

    local TS_h = game:GetService("TextService")
    local function makeHRow(yOff: number): Frame
        local row: Frame = Instance.new("Frame", HelperCard)
        row.Position = UDim2.new(0, 4, 0, yOff)
        row.Size     = UDim2.new(1, -8, 0, 16)
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.ZIndex   = 5
        local ll: UIListLayout = Instance.new("UIListLayout", row)
        ll.FillDirection       = Enum.FillDirection.Horizontal
        ll.HorizontalAlignment = Enum.HorizontalAlignment.Left
        ll.VerticalAlignment   = Enum.VerticalAlignment.Center
        ll.Padding             = UDim.new(0, 4)
        return row
    end
    local HTagRow1: Frame = makeHRow(148)
    local HTagRow2: Frame = makeHRow(166)

    local function addHTag(parent: Frame, txt: string, col: Color3)
        local tag: TextLabel = Instance.new("TextLabel", parent)
        tag.BackgroundColor3       = col
        tag.BackgroundTransparency = 0.4
        tag.BorderSizePixel        = 0
        tag.Font                   = Enum.Font.Arcade
        tag.Text                   = txt
        tag.TextSize               = 7
        tag.TextColor3             = Color3.fromRGB(255, 255, 255)
        tag.ZIndex                 = 6
        Instance.new("UICorner", tag).CornerRadius = UDim.new(1, 0)
        local sz: Vector2 = TS_h:GetTextSize(txt, 7, Enum.Font.Arcade, Vector2.new(200, 20))
        tag.Size = UDim2.new(0, sz.X + 12, 0, 14)
    end

    addHTag(HTagRow1, "Furry",             Color3.fromRGB(230, 90,  180))
    addHTag(HTagRow1, "Friendly",          Color3.fromRGB(80,  200, 120))
    addHTag(HTagRow1, "Like cat",          Color3.fromRGB(255, 170, 40))
    addHTag(HTagRow2, "Introvert",         Color3.fromRGB(100, 130, 255))
    addHTag(HTagRow2, "Naughty",           Color3.fromRGB(255, 90,  50))
    addHTag(HTagRow2, "Not like retarded", Color3.fromRGB(50,  180, 220))
end

do
    local HDiv3: Frame = Instance.new("Frame", HelperCard)
    HDiv3.Position = UDim2.new(0, 4, 0, 186)
    HDiv3.Size     = UDim2.new(1, -8, 0, 1)
    HDiv3.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    HDiv3.BackgroundTransparency = 0.55
    HDiv3.BorderSizePixel = 0
    HDiv3.ZIndex = 5
end

do
    local HSocialHdr: TextLabel = Instance.new("TextLabel", HelperCard)
    HSocialHdr.Position = UDim2.new(0, 6, 0, 189)
    HSocialHdr.Size     = UDim2.new(1, -8, 0, 11)
    HSocialHdr.BackgroundTransparency = 1
    HSocialHdr.Font     = Enum.Font.Arcade
    HSocialHdr.Text     = "Social :"
    HSocialHdr.TextSize = 8
    HSocialHdr.TextXAlignment = Enum.TextXAlignment.Left
    HSocialHdr.TextColor3 = Color3.fromRGB(130, 150, 255)
    HSocialHdr.ZIndex   = 5

    local HComingSoon: TextLabel = Instance.new("TextLabel", HelperCard)
    HComingSoon.Position = UDim2.new(0, 6, 0, 203)
    HComingSoon.Size     = UDim2.new(1, -12, 0, 40)
    HComingSoon.BackgroundTransparency = 1
    HComingSoon.Font     = Enum.Font.Arcade
    HComingSoon.Text     = "— Social links coming soon —"
    HComingSoon.TextSize = 7
    HComingSoon.TextXAlignment = Enum.TextXAlignment.Center
    HComingSoon.TextYAlignment = Enum.TextYAlignment.Center
    HComingSoon.TextColor3 = Color3.fromRGB(90, 90, 130)
    HComingSoon.ZIndex   = 5
end

end

task.spawn(function()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(
            SINQUE_USER_ID,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)
    if ok and url then
        pcall(function()
            HelperAvatarImg.Image = url
            TweenService:Create(HelperAvatarImg,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { ImageTransparency = 0 }):Play()
            TweenService:Create(HelperLoadingLbl,
                TweenInfo.new(0.2),
                { TextTransparency = 1 }):Play()
        end)
    end
end)

local ACTIVE_COL:   Color3 = Color3.fromRGB(0, 255, 150)
local INACTIVE_COL: Color3 = Color3.fromRGB(140, 140, 140)

local TAB_POSITIONS: {[string]: {xPos: number, width: number, btn: TextButton}} = {
    settings = { xPos = 4,   width = 76, btn = TabBtnSettings },
    info     = { xPos = 82,  width = 74, btn = TabBtnInfo     },
    credit   = { xPos = 158, width = 72, btn = TabBtnCredit   },
}

local currentTab: string = "settings"

local function tabIndex(name: string): number
    local _tab_order = { "settings", "info", "credit" }
    for i, v in _tab_order do if v == name then return i end end
    return 1
end

local function getContent(name: string): GuiObject?
    if name == "settings" then return ScrollingFrame
    elseif name == "info"  then return InfoContent
    elseif name == "credit" then return CreditContent
    end
    return nil
end

local _btnScales: {[TextButton]: UIScale} = {}
for _, tbl in TAB_POSITIONS do
    local s: UIScale = Instance.new("UIScale", tbl.btn)
    s.Scale = 1
    _btnScales[tbl.btn] = s
end

local _tabAnimating: boolean = false

local function setTabColor(btn: TextButton, col: Color3)
    local lbl  = btn:FindFirstChild("TabLabel", true)
    local iimg = btn:FindFirstChild("TabIcon",  true)
    if lbl  then lbl.TextColor3   = col end
    if iimg then iimg.ImageColor3 = col end
end

local function tweenTabColor(btn: TextButton, col: Color3, t: number)
    local lbl  = btn:FindFirstChild("TabLabel", true)
    local iimg = btn:FindFirstChild("TabIcon",  true)
    if lbl then
        pcall(function() TweenService:Create(lbl,  TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextColor3  = col }):Play() end)
    end
    if iimg then
        pcall(function() TweenService:Create(iimg, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageColor3 = col }):Play() end)
    end
end

local function switchTab(tabName: string)
    if tabName == currentTab or _tabAnimating then return end
    _tabAnimating = true

    local fromName: string  = currentTab
    local fromContent: GuiObject? = getContent(fromName)
    local toContent:   GuiObject? = getContent(tabName)
    if not toContent then
        _tabAnimating = false
        return
    end

    local fromIdx: number = tabIndex(fromName)
    local toIdx:   number = tabIndex(tabName)
    local goRight: boolean = toIdx > fromIdx
    local slideOut: number = goRight and -PANEL_W or  PANEL_W
    local slideIn:  number = goRight and  PANEL_W or -PANEL_W

    currentTab = tabName

    local tbl: any = TAB_POSITIONS[tabName]
    pcall(function()
        TweenService:Create(TabIndicator,
            TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Size = UDim2.new(0, 4, 0, 3) }
        ):Play()
    end)
    task.delay(0.12, function()
        pcall(function()
            TabIndicator.Position = UDim2.new(0, tbl.xPos + tbl.width * 0.5 - 2, 1, 0)
            TweenService:Create(TabIndicator,
                TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0, tbl.xPos, 1, 0),
                    Size     = UDim2.new(0, tbl.width, 0, 2),
                }
            ):Play()
        end)
    end)

    for name: string, t: any in TAB_POSITIONS do
        local btn: TextButton = t.btn
        local isActive: boolean = (name == tabName)
        local sc: UIScale? = _btnScales[btn]

        if isActive then
            if sc then
                pcall(function()
                    TweenService:Create(sc,
                        TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                        { Scale = 0.80 }
                    ):Play()
                end)
                task.delay(0.10, function()
                    pcall(function()
                        TweenService:Create(sc,
                            TweenInfo.new(0.38, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                            { Scale = 1 }
                        ):Play()
                    end)
                end)
            end
            pcall(function()
                tweenTabColor(btn, ACTIVE_COL, 0.20)
            end)
        else
            pcall(function()
                tweenTabColor(btn, INACTIVE_COL, 0.18)
            end)
        end
    end

    if fromContent then
        fromContent.ClipsDescendants = true
        pcall(function()
            TweenService:Create(fromContent,
                TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Position = UDim2.new(0, slideOut, 0, CONTENT_Y) }
            ):Play()
        end)
        task.delay(0.18, function()
            if fromContent then
                fromContent.Visible  = false
                fromContent.Position = UDim2.new(0, 0, 0, CONTENT_Y)
            end
        end)
    end

    toContent.Position = UDim2.new(0, slideIn, 0, CONTENT_Y)
    toContent.Visible  = true
    toContent.ClipsDescendants = true

    task.delay(0.10, function()
        pcall(function()
            TweenService:Create(toContent,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Position = UDim2.new(0, 0, 0, CONTENT_Y) }
            ):Play()
        end)
        task.delay(0.25, function()
            _tabAnimating = false
        end)
    end)
end

local function resetToSettingsTab()
    currentTab = "settings"
    _tabAnimating = false

    ScrollingFrame.Position  = UDim2.new(0, 0, 0, CONTENT_Y)
    InfoContent.Position     = UDim2.new(0, 0, 0, CONTENT_Y)
    CreditContent.Position   = UDim2.new(0, 0, 0, CONTENT_Y)

    ScrollingFrame.Visible = true
    InfoContent.Visible    = false
    CreditContent.Visible  = false

    setTabColor(TabBtnSettings, ACTIVE_COL)
    setTabColor(TabBtnInfo,     INACTIVE_COL)
    setTabColor(TabBtnCredit,   INACTIVE_COL)

    for _, sc in _btnScales do sc.Scale = 1 end

    TabIndicator.Position = UDim2.new(0, 4, 1, 0)
    TabIndicator.Size     = UDim2.new(0, 76, 0, 2)
end

local function connectTabHover(btn: TextButton)
    btn.MouseEnter:Connect(function()
        local lbl = btn:FindFirstChild("TabLabel", true)
        if lbl and lbl.TextColor3 == ACTIVE_COL then return end
        local sc: UIScale? = _btnScales[btn]
        pcall(function()
            if sc then
                TweenService:Create(sc,
                    TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    { Scale = 1.12 }):Play()
            end
            tweenTabColor(btn, Color3.fromRGB(200, 200, 200), 0.15)
        end)
    end)
    btn.MouseLeave:Connect(function()
        local lbl = btn:FindFirstChild("TabLabel", true)
        if lbl and lbl.TextColor3 == ACTIVE_COL then return end
        local sc: UIScale? = _btnScales[btn]
        pcall(function()
            if sc then
                TweenService:Create(sc,
                    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    { Scale = 1 }):Play()
            end
            tweenTabColor(btn, INACTIVE_COL, 0.18)
        end)
    end)
end

connectTabHover(TabBtnSettings)
connectTabHover(TabBtnInfo)
connectTabHover(TabBtnCredit)

TabBtnSettings.MouseButton1Click:Connect(function() switchTab("settings") end)
TabBtnInfo.MouseButton1Click:Connect(function()     switchTab("info")     end)
TabBtnCredit.MouseButton1Click:Connect(function()   switchTab("credit")   end)

setTabColor(TabBtnSettings, ACTIVE_COL)
setTabColor(TabBtnInfo,     INACTIVE_COL)
setTabColor(TabBtnCredit,   INACTIVE_COL)

task.spawn(function()
    local imgUrl: string = getThumbnail(CREATOR_USER_ID)

    AvatarImg.Image = imgUrl

    task.wait()
    pcall(function()
        AvatarLoadingLbl.Text    = ""
        AvatarLoadingLbl.Visible = false
        TweenService:Create(AvatarImg,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { ImageTransparency = 0 }
        ):Play()
    end)
end)

local function applyCreatorStatus(presenceType: number, gameName: string?)
    if presenceType == 2 then
        StatusDot.BackgroundColor3 = STATUS_COLOR_INGAME
        StatusLabel.TextColor3     = STATUS_COLOR_INGAME
        StatusLabel.Text           = "Playing " .. ((gameName and #gameName > 0) and gameName or "a game")
    elseif presenceType == 1 or presenceType == 3 then
        StatusDot.BackgroundColor3 = STATUS_COLOR_ONLINE
        StatusLabel.TextColor3     = STATUS_COLOR_ONLINE
        StatusLabel.Text           = (presenceType == 3) and "In Roblox Studio" or "Online"
    else
        StatusDot.BackgroundColor3 = STATUS_COLOR_OFFLINE
        StatusLabel.TextColor3     = STATUS_COLOR_OFFLINE
        StatusLabel.Text           = "Offline"
    end
end

task.spawn(function()
    while RealZzHub and RealZzHub.Parent do
        local presenceType: number, gameName: string?, universeId: number? = getPresence(CREATOR_USER_ID)
        if presenceType == 2 and (not gameName or #gameName == 0) then
            gameName = resolveGameName(universeId)
        end
        pcall(applyCreatorStatus, presenceType, gameName)
        task.wait(20)
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            local char = Players.LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local p = hrp.CFrame.Position
                posXLbl.Text = string.format("%d", math.floor(p.X))
                posYLbl.Text = string.format("%d", math.floor(p.Y))
                posZLbl.Text = string.format("%d", math.floor(p.Z))
            else
                posXLbl.Text = "—"
                posYLbl.Text = "—"
                posZLbl.Text = "—"
            end
        end)
    end
end)

task.spawn(function()
    local RS    = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local fpsCount  = 0
    local fpsTimer  = tick()

    RS.Heartbeat:Connect(function()
        fpsCount += 1
    end)

    while task.wait(1) do
        if not PerfHudGui or not PerfHudGui.Parent then break end

        pcall(function()
            local now = tick()
            local fps = math.floor(fpsCount / (now - fpsTimer))
            fpsCount  = 0
            fpsTimer  = now
            if PerfFpsVal then
                PerfFpsVal.Text = string.format("%d", fps)
                PerfFpsVal.TextColor3 = (fps >= 50) and Color3.fromRGB(0, 170, 80)
                    or (fps >= 30) and Color3.fromRGB(200, 150, 0)
                    or Color3.fromRGB(230, 60, 60)
            end
            fpsValLbl.Text = string.format("%d fps", fps)
        end)

        pcall(function()
            local ping = math.floor(
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            )
            if PerfPingVal then
                PerfPingVal.Text = string.format("%d ms", ping)
                PerfPingVal.TextColor3 = (ping <= 80) and Color3.fromRGB(0, 170, 80)
                    or (ping <= 180) and Color3.fromRGB(200, 150, 0)
                    or Color3.fromRGB(230, 60, 60)
            end
            pingValLbl.Text = string.format("%d ms", ping)
        end)

        pcall(function()
            if PerfPlayersVal then
                PerfPlayersVal.Text = tostring(#Players:GetPlayers())
            end
        end)

        pcall(function()
            timeValLbl.Text = string.format("%s", os.date("%H:%M:%S"))
        end)
    end
end)

task.spawn(function()
    while task.wait(15) do
        local ok, mt    = pcall(function() return Players.LocalPlayer.MembershipType end)
        local hasPremium = ok and mt ~= Enum.MembershipType.None
        pcall(function()
            premiumValLbl.Text = string.format("%s",
                hasPremium and "✓ Premium" or "✗ None")
            premiumValLbl.TextColor3 = hasPremium
                and Color3.fromRGB(255, 215, 0)
                or  Color3.fromRGB(170, 170, 170)
        end)
    end
end)

type ToggleControl = {
    Frame: Frame,
    Get:   () -> boolean,
    Set:   (value: boolean) -> (),
}

local function addToggle(
    parent: Instance,
    labelText: string,
    defaultValue: boolean,
    callback: ((val: boolean) -> ())?
): ToggleControl
    local PILL_W:   number = 34
    local PILL_H:   number = 18
    local THUMB_SZ: number = 12
    local THUMB_OFF_X_ON:  number = PILL_W - THUMB_SZ - 3
    local THUMB_OFF_X_OFF: number = 3

    local COL_ON_A:    Color3 = Color3.fromRGB(0, 255, 120)
    local COL_ON_B:    Color3 = Color3.fromRGB(0, 170, 255)
    local COL_OFF:     Color3 = Color3.fromRGB(38, 38, 44)
    local COL_ERROR:   Color3 = Color3.fromRGB(255, 60, 60)
    local COL_STROKE_ON:  Color3 = Color3.fromRGB(0, 220, 160)
    local COL_STROKE_OFF: Color3 = Color3.fromRGB(70, 70, 80)

    local toggleFrame: Frame = Instance.new("Frame", parent)
    toggleFrame.Size                 = UDim2.new(1, -8, 0, 28)
    toggleFrame.BackgroundColor3     = Color3.fromRGB(0, 20, 14)
    toggleFrame.BackgroundTransparency = 0.75
    toggleFrame.BorderSizePixel      = 0
    toggleFrame.ZIndex               = 2
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 5)

    local label: TextLabel = Instance.new("TextLabel", toggleFrame)
    label.BackgroundTransparency = 1
    label.Position          = UDim2.new(0, 8, 0, 0)
    label.Size              = UDim2.new(1, -(PILL_W + 18), 1, 0)
    label.Font              = Enum.Font.Arcade
    label.Text              = labelText
    label.TextColor3        = Color3.fromRGB(200, 200, 200)
    label.TextSize          = 10
    label.TextXAlignment    = Enum.TextXAlignment.Left
    label.ZIndex            = 2

    local pill: Frame = Instance.new("Frame", toggleFrame)
    pill.Name             = "Pill"
    pill.AnchorPoint      = Vector2.new(1, 0.5)
    pill.Position         = UDim2.new(1, -2, 0.5, 0)
    pill.Size             = UDim2.new(0, PILL_W, 0, PILL_H)
    pill.BackgroundColor3 = COL_OFF
    pill.BorderSizePixel  = 0
    pill.ZIndex           = 2
    pill.ClipsDescendants = false
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local pillStroke: UIStroke = Instance.new("UIStroke", pill)
    pillStroke.Color       = COL_STROKE_OFF
    pillStroke.Thickness   = 1.2
    pillStroke.Transparency = 0.2

    local pillFill: Frame = Instance.new("Frame", pill)
    pillFill.Size             = UDim2.new(1, 0, 1, 0)
    pillFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
    pillFill.BackgroundTransparency = 1
    pillFill.BorderSizePixel  = 0
    pillFill.ZIndex           = 2
    Instance.new("UICorner", pillFill).CornerRadius = UDim.new(1, 0)
    local fillGrad: UIGradient = Instance.new("UIGradient", pillFill)
    fillGrad.Color    = ColorSequence.new{
        ColorSequenceKeypoint.new(0, COL_ON_A),
        ColorSequenceKeypoint.new(1, COL_ON_B),
    }
    fillGrad.Rotation = 90

    local thumb: Frame = Instance.new("Frame", pill)
    thumb.AnchorPoint      = Vector2.new(0, 0.5)
    thumb.Position         = UDim2.new(0, THUMB_OFF_X_OFF, 0.5, 0)
    thumb.Size             = UDim2.new(0, THUMB_SZ, 0, THUMB_SZ)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel  = 0
    thumb.ZIndex           = 4
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    local thumbShadow: UIStroke = Instance.new("UIStroke", thumb)
    thumbShadow.Color       = Color3.fromRGB(0, 0, 0)
    thumbShadow.Thickness   = 1
    thumbShadow.Transparency = 0.55

    local thumbScale: UIScale = Instance.new("UIScale", thumb)
    thumbScale.Scale = 1

    local ripple: Frame = Instance.new("Frame", pill)
    ripple.AnchorPoint            = Vector2.new(0.5, 0.5)
    ripple.Position               = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size                   = UDim2.new(0, 0, 0, 0)
    ripple.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel        = 0
    ripple.ZIndex                 = 3
    Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)

    local function flashError()
        pcall(function()
            TweenService:Create(pill, TweenInfo.new(0.08), {
                BackgroundColor3 = COL_ERROR
            }):Play()
            TweenService:Create(pillStroke, TweenInfo.new(0.08), {
                Color = COL_ERROR, Transparency = 0
            }):Play()
            for _ = 1, 2 do
                TweenService:Create(thumbScale, TweenInfo.new(0.055, Enum.EasingStyle.Sine), { Scale = 1.25 }):Play()
                task.wait(0.065)
                TweenService:Create(thumbScale, TweenInfo.new(0.055, Enum.EasingStyle.Sine), { Scale = 0.80 }):Play()
                task.wait(0.065)
            end
            TweenService:Create(thumbScale, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            task.wait(0.55)
            TweenService:Create(pill, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
                BackgroundColor3 = COL_OFF
            }):Play()
            TweenService:Create(pillStroke, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
                Color = COL_STROKE_OFF, Transparency = 0.2
            }):Play()
        end)
    end

    local function updateUI(value: boolean, instant: boolean?)
        pcall(function()
            local dur: number = instant and 0 or 0.22
            local style: Enum.EasingStyle = Enum.EasingStyle.Back

            TweenService:Create(thumb, TweenInfo.new(dur, style, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, value and THUMB_OFF_X_ON or THUMB_OFF_X_OFF, 0.5, 0)
            }):Play()

            if not instant then
                TweenService:Create(thumb, TweenInfo.new(dur * 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, THUMB_SZ + 4, 0, THUMB_SZ - 2)
                }):Play()
                task.delay(dur * 0.4, function()
                    pcall(function()
                        TweenService:Create(thumb, TweenInfo.new(dur * 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            Size = UDim2.new(0, THUMB_SZ, 0, THUMB_SZ)
                        }):Play()
                    end)
                end)
            end

            TweenService:Create(pill, TweenInfo.new(dur, Enum.EasingStyle.Quad), {
                BackgroundColor3 = value and Color3.fromRGB(15, 25, 20) or COL_OFF
            }):Play()
            TweenService:Create(pillFill, TweenInfo.new(dur, Enum.EasingStyle.Quad), {
                BackgroundTransparency = value and 0 or 1
            }):Play()
            TweenService:Create(pillStroke, TweenInfo.new(dur, Enum.EasingStyle.Quad), {
                Color       = value and COL_STROKE_ON or COL_STROKE_OFF,
                Transparency = value and 0 or 0.2
            }):Play()

            TweenService:Create(label, TweenInfo.new(dur, Enum.EasingStyle.Quad), {
                TextColor3 = value
                    and Color3.fromRGB(255, 255, 255)
                    or  Color3.fromRGB(180, 180, 180)
            }):Play()
        end)
    end

    local clickBtn: TextButton = Instance.new("TextButton", toggleFrame)
    clickBtn.Name               = "Click"
    clickBtn.BackgroundTransparency = 1
    clickBtn.Size               = UDim2.new(1, 0, 1, 0)
    clickBtn.Text               = ""
    clickBtn.ZIndex             = 5
    clickBtn.AutoButtonColor    = false

    clickBtn.MouseEnter:Connect(function()
        pcall(function()
            TweenService:Create(thumbScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.18 }):Play()
            TweenService:Create(pillStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { Transparency = 0 }):Play()
        end)
    end)
    clickBtn.MouseLeave:Connect(function()
        pcall(function()
            TweenService:Create(thumbScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            TweenService:Create(pillStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Transparency = 0.2 }):Play()
        end)
    end)

    clickBtn.MouseButton1Down:Connect(function()
        pcall(function()
            TweenService:Create(thumbScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.85 }):Play()
        end)
    end)
    clickBtn.MouseButton1Up:Connect(function()
        pcall(function()
            TweenService:Create(thumbScale, TweenInfo.new(0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
        end)
    end)

    local currentValue: boolean = defaultValue
    updateUI(currentValue, true)

    clickBtn.MouseButton1Click:Connect(function()
        currentValue = not currentValue
        updateUI(currentValue)

        pcall(function()
            ripple.Size                   = UDim2.new(0, 0, 0, 0)
            ripple.BackgroundTransparency = 0.7
            TweenService:Create(ripple, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1.6, 0, 2.4, 0), BackgroundTransparency = 1
            }):Play()
        end)

        if callback then
            local ok: boolean, err: any = pcall(callback, currentValue)
            if not ok then
                warn("[VelocityX] Toggle '" .. labelText .. "' callback error: " .. tostring(err))
                currentValue = not currentValue
                updateUI(currentValue)
                task.spawn(flashError)
            end
        end
    end)

    return {
        Frame = toggleFrame,
        Get   = function(): boolean return currentValue end,
        Set   = function(_self: any, value: boolean)
            if value ~= currentValue then
                currentValue = value
                updateUI(currentValue)
                if callback then
                    local ok: boolean, err: any = pcall(callback, currentValue)
                    if not ok then
                        warn("[VelocityX] Toggle '" .. labelText .. "' Set() callback error: " .. tostring(err))
                        currentValue = not currentValue
                        updateUI(currentValue)
                        task.spawn(flashError)
                    end
                end
            end
        end,
    }
end

local CONFIG_FOLDER: string = "Alwi Hub"
local CONFIG_FILE:   string = CONFIG_FOLDER .. "/AlwiHub_Settings.json"
local CONFIG_VER:    string = "v1.3"

if makefolder then
    local folderOk: boolean = pcall(function()
        if not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
    end)
    if not folderOk then
        warn("[VelocityX] Could not create config folder — settings won't be saved this session.")
    end
end

type Config = {
    autoSave:           boolean,
    autoInject:         boolean,
    autoExecutorLoader: boolean,
    antiAfk:            boolean,
    antiFling:          boolean,
    antiGameplayPause:  boolean,
    skipIntroUI:        boolean,
    showPerfHud:        boolean,
    skipTutorial:       boolean,
    hudPos:             {number}?,
}

local config: Config = {
    autoSave           = false,
    autoInject         = false,
    autoExecutorLoader = false,
    antiAfk            = false,
    antiFling          = false,
    antiGameplayPause  = false,
    skipIntroUI        = false,
    showPerfHud        = true,
    skipTutorial       = false,
    hudPos             = nil,
}

local function loadConfig()
    if not (readfile and isfile) then return end
    local loadOk: boolean, loadErr: any = pcall(function()
        if not isfile(CONFIG_FILE) then return end
        local raw:  string = readfile(CONFIG_FILE)
        local data: any    = HttpService:JSONDecode(raw)
        if type(data) ~= "table" then
            error("Config root is not a table — file is corrupted.")
        end
        config.autoSave           = data.autoSave           == true
        config.autoInject         = data.autoInject         == true
        config.autoExecutorLoader = data.autoExecutorLoader == true
        config.antiAfk            = data.antiAfk            == true
        config.antiFling          = data.antiFling          == true
        config.antiGameplayPause  = data.antiGameplayPause  == true
        config.skipIntroUI        = data.skipIntroUI        == true
        config.showPerfHud        = data.showPerfHud        ~= false
        config.skipTutorial       = data.skipTutorial       == true
        do
            local hp: any = data.hudPos
            if type(hp) == "table" and #hp == 4
                and type(hp[1]) == "number" and type(hp[2]) == "number"
                and type(hp[3]) == "number" and type(hp[4]) == "number" then
                config.hudPos = { hp[1], hp[2], hp[3], hp[4] }
            else
                config.hudPos = nil
            end
        end
    end)
    if not loadOk then
        warn("[VelocityX] Config corrupted (" .. tostring(loadErr) .. ") — resetting to defaults.")
        pcall(function()
            if isfile(CONFIG_FILE) then delfile(CONFIG_FILE) end
        end)
        pcall(function()
            if isfolder and isfolder(CONFIG_FOLDER) then
                pcall(delfolder, CONFIG_FOLDER)
            end
            if makefolder then makefolder(CONFIG_FOLDER) end
        end)
    end
end

local function saveConfig()
    if not (writefile and config.autoSave) then return end
    pcall(function()
        if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
        local data: string = HttpService:JSONEncode({
            _version           = CONFIG_VER,
            autoSave           = config.autoSave,
            autoInject         = config.autoInject,
            autoExecutorLoader = config.autoExecutorLoader,
            antiAfk            = config.antiAfk,
            antiFling          = config.antiFling,
            antiGameplayPause  = config.antiGameplayPause,
            skipIntroUI        = config.skipIntroUI,
            showPerfHud        = config.showPerfHud,
            skipTutorial       = config.skipTutorial,
            hudPos             = config.hudPos,
        })
        writefile(CONFIG_FILE, data)
    end)
end

local function saveSkipIntro()
    if not writefile then return end
    pcall(function()
        if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
        local existing: {[string]: any} = {}
        if readfile and isfile and isfile(CONFIG_FILE) then
            pcall(function()
                local raw: string = readfile(CONFIG_FILE)
                local parsed: any = HttpService:JSONDecode(raw)
                if type(parsed) == "table" then
                    existing = parsed
                end
            end)
        end
        existing.skipIntroUI = config.skipIntroUI
        existing._version    = CONFIG_VER
        writefile(CONFIG_FILE, HttpService:JSONEncode(existing))
    end)
end

local function saveUiPrefs()
    if not writefile then return end
    pcall(function()
        if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
        local existing: {[string]: any} = {}
        if readfile and isfile and isfile(CONFIG_FILE) then
            pcall(function()
                local raw: string = readfile(CONFIG_FILE)
                local parsed: any = HttpService:JSONDecode(raw)
                if type(parsed) == "table" then
                    existing = parsed
                end
            end)
        end
        existing.showPerfHud  = config.showPerfHud
        existing.skipTutorial = config.skipTutorial
        existing.hudPos       = config.hudPos
        existing._version     = CONFIG_VER
        writefile(CONFIG_FILE, HttpService:JSONEncode(existing))
    end)
end

local function setupAutoExecutorLoader(): boolean
    local _env: {[string]: any} = getfenv()
    local queueFn: any =
        _env["queue_on_teleport"]
        or _env["queueonteleport"]
        or _env["queueteleport"]
        or _env["QueueOnTeleport"]
        or rawget(_G, "queue_on_teleport")
        or rawget(_G, "queueonteleport")
        or rawget(_G, "queueteleport")
        or (_fluxus and (_fluxus.queue_on_teleport or _fluxus.queueonteleport))
        or (_syn    and (_syn.queue_on_teleport    or _syn.queueonteleport))
    if not queueFn then
        pcall(function()
            local renv = getrenv()
            if type(renv) == "table" then
                for k, v in renv do
                    if type(k) == "string" and type(v) == "function" then
                        local lower = k:lower()
                        if lower:find("queue") and lower:find("teleport") then
                            queueFn = v; break
                        end
                    end
                end
            end
        end)
    end

    if not queueFn then return false end

    task.spawn(function()
        pcall(function()
            queueFn(
                "loadstring(game:HttpGet('https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Loader.lua'))()"
            )
        end)
    end)
    return true
end

local function clearTeleportQueue()
    local _env: {[string]: any} = getfenv()
    local _cqot = _env["clearqueueonteleport"] or rawget(_G, "clearqueueonteleport")
    local _ctq  = _env["clearteleportqueue"]   or rawget(_G, "clearteleportqueue")
    local _ctq2 = _env["clear_teleport_queue"] or rawget(_G, "clear_teleport_queue")
    if _cqot then pcall(_cqot) end
    if _ctq  then pcall(_ctq)  end
    if _ctq2 then pcall(_ctq2) end
    showNotification("Alwi Hub", "Auto Executor cleared", Color3.fromRGB(255, 200, 0), 2)
end

local function _buildUI()
local function setButtonActive(button: GuiButton?, active: boolean)
    if not button or not button.Parent then return end
    button.Active = active
    if button:IsA("TextButton") then
        (button :: TextButton).TextTransparency = active and 0 or 0.5
    elseif button:IsA("ImageButton") then
        (button :: ImageButton).ImageTransparency = active and 0.2 or 0.6
    end
end

local scriptUrl:  string? = nil
local gameName:   string  = "Universal"
local injected:   boolean = false

local UNIVERSAL_URL: string = "https://raw.githubusercontent.com/Mainery-foxxie/Main/ac587f929f922ff7fc1f682101631ad491e19f8d/Velocity%20X/Main/Universal/Main.lua"

local BACKUP_API_URL: string = "https://pastefy.app/dqXuWWb4/raw"

local function is404or503(err: string?): boolean
    if type(err) ~= "string" or #err == 0 then return false end
    return err:find("404") ~= nil or err:find("503") ~= nil
end

local function httpBodyIsError(body: any): boolean
    if type(body) ~= "string" then return true end
    if #body == 0 then return true end
    local head: string = body:sub(1, 64)
    return head:find("^404") ~= nil
        or head:find("^503") ~= nil
        or head:find("^400") ~= nil
        or head:find("^500") ~= nil
end

local function fetchBackupScriptUrl(): string?
    local gid: string = tostring(game.GameId)
    local found: string? = nil
    pcall(function()
        local data: string = game:HttpGet(BACKUP_API_URL .. "?t=" .. tostring(math.floor(tick())))
        if type(data) ~= "string" or #data == 0 then return end
        local parsed: any = nil
        pcall(function() parsed = HttpService:JSONDecode(data) end)
        if type(parsed) ~= "table" then
            parsed = decode_obfuscated(HttpService:JSONDecode(data))
        end
        local entry: any = parsed and (parsed[gid] or parsed[tonumber(gid)])
        if type(entry) ~= "table" or type(entry.Path) ~= "string" or #entry.Path == 0 then return end
        local path: string = entry.Path
        local rs: string = entry.randomstring or ""
        if path:sub(1, 4) == "http" then
            found = path .. rs
        else
            local base: string = UNIVERSAL_URL:match("^(.*/)[^/]*$") or ""
            found = base .. path .. rs
        end
    end)
    return found
end

local function _detectGame()
    local GITHUB_BASE:       string = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/"
    local GITHUB_JSON_URL:   string = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/SupportedGames.json"
    local PASTEBIN_JSON_URL: string = string.char(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,82,101,108,105,103,105,117,115,45,83,116,97,114,47,77,97,105,110,47,114,101,102,115,47,104,101,97,100,115,47,109,97,105,110,47,99,111,110,102,105,103,47,71,97,109,101,37,50,48,115,117,112,112,111,114,116,37,50,48,50,46,106,115,111,110)
    local LOCALGAME2_JSON_URL: string = "https://raw.githubusercontent.com/Religius-Star/Main/refs/heads/main/config/Game%20support.json"
    local LOCALGAME2_BASE:     string = "https://raw.githubusercontent.com/Religius-Star/Main/refs/heads/main/Script/Game0/"
    local BACKUP_JSON_URL:     string = "https://pastefy.app/dqXuWWb4/raw"

    local function fetchEx(url: string): (string?, string?)
        local success: boolean, result: any = pcall(function()
            return game:HttpGet(url)
        end)
        if success then
            local body: string = tostring(result)
            if httpBodyIsError(body) then
                return nil, body
            end
            return body, nil
        end
        return nil, tostring(result)
    end

    local function fetch(url: string): string?
        local data: string?, _err: string? = fetchEx(url)
        return data
    end

    local function is404or503(err: string?): boolean
        if type(err) ~= "string" or #err == 0 then return false end
        return err:find("404") ~= nil or err:find("503") ~= nil
    end

    local gameId: string = tostring(game.GameId)

    local githubResult:     { url: string, name: string }? = nil
    local pastebinResult:   { url: string, name: string }? = nil
    local localGame2Result: { url: string, name: string }? = nil
    local backupResult:     { url: string, name: string }? = nil
    local done1: boolean = false
    local done2: boolean = false
    local done3: boolean = false
    local done4: boolean = false
    local cacheBust: string = tostring(math.floor(tick()))

    task.spawn(function()
        local fetchErr: string? = nil
        local ok: boolean = pcall(function()
            local data: string?
            data, fetchErr = fetchEx(GITHUB_JSON_URL .. "?t=" .. cacheBust)
            if not data or #(data :: string) == 0 then
                error("Empty (HttpGet err: " .. tostring(fetchErr) .. ")")
            end
            local json: any = HttpService:JSONDecode(data :: string)
            if json and json[gameId] then
                githubResult = { url = GITHUB_BASE .. json[gameId].Path, name = json[gameId].Name }
            end
        end)
        if not ok then
            if is404or503(fetchErr) then
                warn("[VelocityX] GitHub game list got 404/503 — will use backup API: " .. tostring(fetchErr))
            else
                warn("[VelocityX] GitHub game list failed")
            end
        end
        done1 = true
    end)

    task.spawn(function()
        local fetchErr: string? = nil
        local ok: boolean, err: any = pcall(function()
            local data: string?
            data, fetchErr = fetchEx(PASTEBIN_JSON_URL .. "?t=" .. cacheBust)
            if not data or #(data :: string) == 0 then
                error("Empty response (HttpGet err: " .. tostring(fetchErr) .. ")")
            end
            local json: any = decode_obfuscated(HttpService:JSONDecode(data :: string))
            if json and json[gameId] then
                local path: string = json[gameId].Path
                local rs:   string = json[gameId].randomstring or ""
                pastebinResult = { url = path .. rs, name = json[gameId].Name }
            end
        end)
        if not ok then
            if is404or503(fetchErr) or is404or503(tostring(err)) then
                warn("[VelocityX] Pastefy game list got 404/503 — will use backup API: " .. tostring(err) .. " | " .. tostring(fetchErr))
            else
                warn("[VelocityX] Pastefy game list failed: " .. tostring(err))
            end
        end
        done2 = true
    end)

    task.spawn(function()
        local fetchErr: string? = nil
        local ok: boolean, err: any = pcall(function()
            local data: string?
            data, fetchErr = fetchEx(LOCALGAME2_JSON_URL)
            if not data or #(data :: string) == 0 then
                error("Empty response (HttpGet err: " .. tostring(fetchErr) .. ")")
            end
            local json: any  = HttpService:JSONDecode(data :: string)
            local entry: any = json[gameId] or json[tonumber(gameId)]
            if json and entry then
                local path: string = (entry.Path or ""):gsub("%%20", " ")
                local resolvedUrl: string = (path:sub(1, 4) == "http") and path or (LOCALGAME2_BASE .. path)
                localGame2Result = { url = resolvedUrl, name = entry.Name or "LocalGame2" }
            end
        end)
        if not ok then
            if is404or503(fetchErr) or is404or503(tostring(err)) then
                warn("[VelocityX] LocalGame2 game list got 404/503 — will use backup API: " .. tostring(err) .. " | " .. tostring(fetchErr))
            else
                warn("[VelocityX] LocalGame2 game list failed: " .. tostring(err))
            end
        end
        done3 = true
    end)

    task.spawn(function()
        local fetchErr: string? = nil
        local ok: boolean, err: any = pcall(function()
            local data: string?
            data, fetchErr = fetchEx(BACKUP_JSON_URL .. "?t=" .. cacheBust)
            if not data or #(data :: string) == 0 then
                error("Empty response (backup HttpGet err: " .. tostring(fetchErr) .. ")")
            end
            local parsed: any = nil
            local plainOk: boolean = pcall(function()
                parsed = HttpService:JSONDecode(data :: string)
            end)
            if not plainOk or type(parsed) ~= "table" then
                parsed = decode_obfuscated(HttpService:JSONDecode(data :: string))
            end
            local entry: any = parsed and (parsed[gameId] or parsed[tonumber(gameId)])
            if parsed and entry then
                local path: string = entry.Path or ""
                local rs:   string = entry.randomstring or ""
                local resolved: string
                if path:sub(1, 4) == "http" then
                    resolved = path .. rs
                elseif #path > 0 then
                    resolved = GITHUB_BASE .. path .. rs
                else
                    error("Empty Path in backup entry")
                end
                backupResult = { url = resolved, name = entry.Name or "Backup" }
            end
        end)
        if not ok then warn("[VelocityX] Backup game list failed: " .. tostring(err) .. " | " .. tostring(fetchErr)) end
        done4 = true
    end)

    local deadline: number = tick() + 8
    while (not done1 or not done2 or not done3 or not done4) and tick() < deadline do
        task.wait(0.05)
    end

    if githubResult then
        scriptUrl = githubResult.url
        gameName  = githubResult.name
    elseif localGame2Result then
        scriptUrl = localGame2Result.url
        gameName  = localGame2Result.name
    elseif pastebinResult then
        scriptUrl = pastebinResult.url
        gameName  = pastebinResult.name
    elseif backupResult then
        scriptUrl = backupResult.url
        gameName  = backupResult.name
        warn("[VelocityX] Using backup API for game list (primaries hit 404/503 or missed)")
    end

    if not scriptUrl then
        scriptUrl = UNIVERSAL_URL
        gameName  = "Universal"
        showNotification("🌐 Universal Mode", "No script found for this game — using Universal.", Color3.fromRGB(0, 180, 255), 4)
    else
        showNotification("✅ Game Detected!", gameName .. " script is ready.", Color3.fromRGB(0, 220, 100), 3)
    end
end
_detectGame()

InjectButton.Text = gameName .. ".lua"

task.spawn(function()
    local ok: boolean = pcall(function()
        local versionStr: string = game:HttpGet(
            "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/version.json"
        )
        if not versionStr or #versionStr == 0 then error("Empty version response") end
        Version.Text = "Version: " .. versionStr
    end)
    if not ok then
        Version.Text = "Version: ?"
        warn("[VelocityX] Version fetch failed")
    end
end)

local function clearText()
    for _, v: Instance in MainBackground:GetDescendants() do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            (v :: TextLabel).Text = ""
        end
    end
end

local function cleanupAntiFeatures()
end

local ErrorPanel: Frame = Instance.new("Frame", MainBackground)
ErrorPanel.Name                   = "ErrorPanel"
ErrorPanel.AnchorPoint            = Vector2.new(0, 1)
ErrorPanel.Position               = UDim2.new(0, 0, 1.05, 0)
ErrorPanel.Size                   = UDim2.new(1, 0, 0, 60)
ErrorPanel.BackgroundColor3       = Color3.fromRGB(20, 8, 8)
ErrorPanel.BackgroundTransparency = 0.10
ErrorPanel.BorderSizePixel        = 0
ErrorPanel.ClipsDescendants       = true
ErrorPanel.ZIndex                 = 5
ErrorPanel.Visible                = false

Instance.new("UICorner", ErrorPanel).CornerRadius = UDim.new(0, 8)

do
    do
local ErrStroke: UIStroke = Instance.new("UIStroke", ErrorPanel)
    ErrStroke.Color       = Color3.fromRGB(255, 60, 60)
    ErrStroke.Thickness   = 1.5
    ErrStroke.Transparency = 0.3
end

    do
local ErrTopBar: Frame = Instance.new("Frame", ErrorPanel)
    ErrTopBar.Size             = UDim2.new(1, 0, 0, 2)
    ErrTopBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    ErrTopBar.BorderSizePixel  = 0
    local ErrTopGrad: UIGradient = Instance.new("UIGradient", ErrTopBar)
    ErrTopGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 160, 60)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 80, 80)),
    }
end

    local ErrIcon: TextLabel = Instance.new("TextLabel", ErrorPanel)
    ErrIcon.AnchorPoint            = Vector2.new(0, 0.5)
    ErrIcon.Position               = UDim2.new(0, 8, 0.38, 0)
    ErrIcon.Size                   = UDim2.new(0, 18, 0, 18)
    ErrIcon.BackgroundTransparency = 1
    ErrIcon.Font                   = Enum.Font.GothamBold
    ErrIcon.Text                   = "⚠"
    ErrIcon.TextScaled             = true
    ErrIcon.TextColor3             = Color3.fromRGB(255, 140, 40)
    ErrIcon.ZIndex                 = 6
end

local ErrTitle:      TextLabel  = Instance.new("TextLabel",  ErrorPanel)
local ErrDesc:       TextLabel  = Instance.new("TextLabel",  ErrorPanel)
local ErrRetryBtn:   TextButton = Instance.new("TextButton", ErrorPanel)
local ErrDismissBtn: TextButton = Instance.new("TextButton", ErrorPanel)

do
    ErrTitle.AnchorPoint            = Vector2.new(0, 0)
    ErrTitle.Position               = UDim2.new(0, 30, 0, 6)
    ErrTitle.Size                   = UDim2.new(0.7, 0, 0, 16)
    ErrTitle.BackgroundTransparency = 1
    ErrTitle.Font                   = Enum.Font.Arcade
    ErrTitle.Text                   = "Failed to Load"
    ErrTitle.TextSize               = 12
    ErrTitle.TextXAlignment         = Enum.TextXAlignment.Left
    ErrTitle.TextColor3             = Color3.fromRGB(255, 100, 100)
    ErrTitle.TextStrokeTransparency = 0.4
    ErrTitle.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    ErrTitle.ZIndex                 = 6

    ErrDesc.AnchorPoint            = Vector2.new(0, 0)
    ErrDesc.Position               = UDim2.new(0, 30, 0, 23)
    ErrDesc.Size                   = UDim2.new(0.68, 0, 0, 22)
    ErrDesc.BackgroundTransparency = 1
    ErrDesc.Font                   = Enum.Font.Arcade
    ErrDesc.Text                   = "Server unreachable or script was removed."
    ErrDesc.TextSize               = 9
    ErrDesc.TextWrapped            = true
    ErrDesc.TextXAlignment         = Enum.TextXAlignment.Left
    ErrDesc.TextYAlignment         = Enum.TextYAlignment.Top
    ErrDesc.TextColor3             = Color3.fromRGB(220, 180, 180)
    ErrDesc.ZIndex                 = 6

    ErrRetryBtn.AnchorPoint            = Vector2.new(1, 0.5)
    ErrRetryBtn.Position               = UDim2.new(0.98, 0, 0.55, 0)
    ErrRetryBtn.Size                   = UDim2.new(0, 54, 0, 22)
    ErrRetryBtn.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    ErrRetryBtn.BackgroundTransparency = 1
    ErrRetryBtn.BorderSizePixel        = 0
    ErrRetryBtn.Font                   = Enum.Font.Arcade
    ErrRetryBtn.Text                   = "Retry"
    ErrRetryBtn.TextSize               = 11
    ErrRetryBtn.TextColor3             = Color3.fromRGB(255, 255, 255)
    ErrRetryBtn.ZIndex                 = 7
    Instance.new("UICorner", ErrRetryBtn).CornerRadius = UDim.new(0, 4)
    do
        local g: UIGradient = Instance.new("UIGradient", ErrRetryBtn)
        g.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 40, 40)),
        }
        g.Rotation = 90
        local s: UIStroke = Instance.new("UIStroke", ErrRetryBtn)
        s.Color     = Color3.fromRGB(255, 80, 80)
        s.Thickness = 1
    end

    ErrDismissBtn.AnchorPoint            = Vector2.new(1, 0)
    ErrDismissBtn.Position               = UDim2.new(1, -2, 0, 2)
    ErrDismissBtn.Size                   = UDim2.new(0, 14, 0, 14)
    ErrDismissBtn.BackgroundTransparency = 1
    ErrDismissBtn.BorderSizePixel        = 0
    ErrDismissBtn.Font                   = Enum.Font.GothamBold
    ErrDismissBtn.Text                   = "×"
    ErrDismissBtn.TextSize               = 13
    ErrDismissBtn.TextColor3             = Color3.fromRGB(180, 100, 100)
    ErrDismissBtn.ZIndex                 = 8
end

local _errPanelOpen: boolean = false
local function showErrorPanel(title: string, desc: string, onRetry: (() -> ())?)
    if not ErrorPanel or not ErrorPanel.Parent then return end
    ErrTitle.Text = title
    ErrDesc.Text  = desc
    _errPanelOpen  = true
    ErrorPanel.Visible  = true
    ErrorPanel.Position = UDim2.new(0, 0, 1.05, 0)
    TweenService:Create(ErrorPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.62, 0),
    }):Play()

    local retryConn: RBXScriptConnection
    retryConn = ErrRetryBtn.MouseButton1Click:Connect(function()
        retryConn:Disconnect()
        pcall(function()
            TweenService:Create(ErrorPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 0, 1.05, 0),
            }):Play()
        end)
        task.wait(0.22)
        ErrorPanel.Visible = false
        _errPanelOpen = false
        if onRetry then task.spawn(onRetry) end
    end)
end

local function hideErrorPanel()
    if not _errPanelOpen then return end
    _errPanelOpen = false
    pcall(function()
        TweenService:Create(ErrorPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 0, 1.05, 0),
        }):Play()
    end)
    task.delay(0.22, function()
        if not _errPanelOpen and ErrorPanel then ErrorPanel.Visible = false end
    end)
end

ErrDismissBtn.MouseButton1Click:Connect(function()
    hideErrorPanel()
end)

local function shakeError()
    pcall(function()
        local orig: UDim2 = MainBackground.Position
        local shakeInfo: TweenInfo = TweenInfo.new(0.07, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 4, true)
        TweenService:Create(MainBackground, shakeInfo, {
            Position = UDim2.new(orig.X.Scale, orig.X.Offset + 8, orig.Y.Scale, orig.Y.Offset)
        }):Play()
        task.wait(0.6)
        TweenService:Create(MainBackground, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = orig
        }):Play()
    end)
end

local MAX_RETRIES: number = 3
local RETRY_DELAY: number = 2

local FETCH_TIMEOUT: number = 5

local function tryFetchAndRun(url: string): (boolean, string)
    local result:  string?  = nil
    local fetchErr: string? = nil
    local fetchOk: boolean  = false
    local done:    boolean  = false

    task.spawn(function()
        local ok: boolean, content: any = pcall(game.HttpGet, game, url)
        if ok and type(content) == "string" then
            result  = content
            fetchOk = true
        else
            fetchErr = tostring(content)
        end
        done = true
    end)

    local deadline: number = tick() + FETCH_TIMEOUT
    while not done and tick() < deadline do
        task.wait(0.05)
    end

    if fetchOk and httpBodyIsError(result) then
        fetchOk = false
        fetchErr = result :: string
    end

    if not done or not fetchOk or not result or #(result :: string) == 0 then
        if is404or503(fetchErr) then
            local code: string = (fetchErr :: string):find("404") and "404" or "503"
            return false, "HTTP " .. code .. " from URL"
        end
        return false, "Timeout or empty response from URL"
    end

    local loadOk: boolean, loadErr: any = pcall(loadstring(result :: string))
    if not loadOk then
        return false, "Script runtime error: " .. tostring(loadErr)
    end
    return true, ""
end

local function injectScript()
    if injected then return end
    injected = true

    setButtonActive(InjectButton, false)

    local currentUrl:  string = scriptUrl :: string
    local currentName: string = gameName
    local lastErr:     string = ""

    local phase1Ok: boolean = false
    for attempt: number = 1, MAX_RETRIES do
        InjectButton.Text = string.format("Loading... (%d/%d)", attempt, MAX_RETRIES)
        local ok: boolean, err: string = tryFetchAndRun(currentUrl)
        if ok then
            phase1Ok = true
            break
        end
        lastErr = err
        warn(string.format("[VelocityX] %s attempt %d/%d failed: %s", currentName, attempt, MAX_RETRIES, err))
        if err:find("404") then
            warn("[VelocityX] 404 is permanent — skipping remaining retries, going to backup")
            break
        end
        if attempt < MAX_RETRIES then
            showNotification(
                "⚠️ Connection Issue",
                string.format("Couldn't reach server, retrying... (%d/%d)", attempt, MAX_RETRIES),
                Color3.fromRGB(255, 160, 0), RETRY_DELAY
            )
            task.wait(RETRY_DELAY)
        end
    end

    if phase1Ok then
        task.spawn(function() pcall(setBtnState, "success") end)
        setButtonActive(InjectButton, true)
        return
    end

    if is404or503(lastErr) and currentUrl ~= UNIVERSAL_URL then
        local backupUrl: string? = nil
        pcall(function() backupUrl = fetchBackupScriptUrl() end)
        if backupUrl and #backupUrl > 0 and backupUrl ~= currentUrl then
            local code: string = lastErr:find("404") and "404" or "503"
            showNotification(
                "🔁 Trying Backup Host",
                "Main link failed (" .. code .. ") — loading from Pastefy...",
                Color3.fromRGB(0, 200, 255), 3
            )
            for attempt: number = 1, MAX_RETRIES do
                InjectButton.Text = string.format("Backup... (%d/%d)", attempt, MAX_RETRIES)
                local ok2: boolean, err2: string = tryFetchAndRun(backupUrl :: string)
                if ok2 then
                    phase1Ok = true
                    break
                end
                lastErr = err2
                warn(string.format("[VelocityX] Pastefy backup attempt %d/%d failed: %s", attempt, MAX_RETRIES, err2))
                if err2:find("404") then break end
                if attempt < MAX_RETRIES then task.wait(RETRY_DELAY) end
            end
            if phase1Ok then
                scriptUrl = backupUrl
            end
        else
            warn("[VelocityX] No Pastefy backup URL for this game — falling back to Universal")
        end
    end

    if phase1Ok then
        task.spawn(function() pcall(setBtnState, "success") end)
        setButtonActive(InjectButton, true)
        return
    end

    if currentUrl ~= UNIVERSAL_URL then
        showNotification(
            "⚠️ Game Script Unavailable",
            "Couldn't load " .. currentName .. " — falling back to Universal...",
            Color3.fromRGB(255, 160, 0), 3
        )
        task.spawn(shakeError)
        scriptUrl = UNIVERSAL_URL
        gameName  = "Universal"

        local phase2Ok: boolean = false
        for attempt: number = 1, MAX_RETRIES do
            InjectButton.Text = string.format("Fallback... (%d/%d)", attempt, MAX_RETRIES)
            local ok: boolean, err: string = tryFetchAndRun(UNIVERSAL_URL)
            if ok then
                phase2Ok = true
                break
            end
            lastErr = err
            warn(string.format("[VelocityX] Universal attempt %d/%d failed: %s", attempt, MAX_RETRIES, err))
            if err:find("404") then break end
            if attempt < MAX_RETRIES then
                showNotification(
                    "⚠️ Still Can't Connect",
                    string.format("Retrying Universal script... (%d/%d)", attempt, MAX_RETRIES),
                    Color3.fromRGB(255, 160, 0), RETRY_DELAY
                )
                task.wait(RETRY_DELAY)
            end
        end

        if phase2Ok then
            task.spawn(function() pcall(setBtnState, "success") end)
            setButtonActive(InjectButton, true)
            return
        end
    end

    injected          = false
    InjectButton.Text = gameName .. ".lua"
    setButtonActive(InjectButton, true)
    task.spawn(shakeError)
    task.spawn(function() pcall(setBtnState, "error") end)

    showErrorPanel(
        "❌ Failed to Load Script",
        "Server unreachable or script was removed.\nCheck your connection and try again.",
        function()
            pcall(setBtnState, "normal")
            task.spawn(injectScript)
        end
    )
    showNotification(
        "❌ Script Failed to Load",
        "Server is down or the script no longer exists.",
        Color3.fromRGB(255, 60, 60), 8
    )
end

local function performAutoInject()
    if injected then return end
    delay(5, function()
        if not RealZzHub or not RealZzHub.Parent then return end
        local txt = InjectButton.Text or ""
        if txt:find("Loading") or txt:find("Fallback") then
            pcall(function() RealZzHub:Destroy() end)
        end
    end)
    injectScript()
    if not injected then return end
    InjectButton.Text = "Injecting..."
    TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
    }):Play()
    clearText()
    task.wait(0.35)
    cleanupAntiFeatures()
    if RealZzHub then RealZzHub:Destroy() end
end

pcall(fitLoaderScale)
pcall(fitHudScale)

MainBackground.Visible = true
MainBackground.Size    = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainBackground, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 330, 0, 172), ImageTransparency = 0.15
}):Play()
task.wait(0.4)

CloseButton.Visible   = true
InjectButton.Visible  = true
Name.Visible          = true
Logo.Visible          = true
Version.Visible       = true
SettingsIcon.Visible  = true
GreetingCard.Visible  = true

loadConfig()

local autoSaveCtrl:   {Set: (any, boolean) -> ()} = addToggle(ScrollingFrame, "Auto Save Config", config.autoSave, function(val: boolean)
    config.autoSave = val
    if config.autoSave then saveConfig() end
    showNotification("Auto Save Config", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

local autoInjectCtrl: {Set: (any, boolean) -> ()} = addToggle(ScrollingFrame, "Auto Inject", config.autoInject, function(val: boolean)
    config.autoInject = val
    if config.autoSave then saveConfig() end
    showNotification("Auto Inject", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
    if val and not injected then
        performAutoInject()
    end
end)

local _queueSupported: boolean = false
pcall(function()
    local _env: {[string]: any} = getfenv()
    local fn: any =
        _env["queue_on_teleport"]
        or _env["queueonteleport"]
        or _env["queueteleport"]
        or _env["QueueOnTeleport"]
        or rawget(_G, "queue_on_teleport")
        or rawget(_G, "queueonteleport")
        or rawget(_G, "queueteleport")
        or (_fluxus and (_fluxus.queue_on_teleport or _fluxus.queueonteleport))
        or (_syn    and (_syn.queue_on_teleport    or _syn.queueonteleport))
    if not fn then
        pcall(function()
            local renv = getrenv()
            if type(renv) == "table" then
                for k, v in renv do
                    if type(k) == "string" and type(v) == "function" then
                        local lower = k:lower()
                        if lower:find("queue") and lower:find("teleport") then
                            fn = v; break
                        end
                    end
                end
            end
        end)
    end
    _queueSupported = fn ~= nil
end)

local autoLoaderCtrl: {Set: (any, boolean) -> ()}

if _queueSupported then
    autoLoaderCtrl = addToggle(ScrollingFrame, "Auto Executor Loader", config.autoExecutorLoader, function(val: boolean)
        config.autoExecutorLoader = val
        if config.autoSave then saveConfig() end
        if val then
            setupAutoExecutorLoader()
            showNotification("Auto Executor Loader", "Enabled – will reload on teleport", Color3.fromRGB(0, 255, 120), 3)
        else
            clearTeleportQueue()
        end
    end)
else
    config.autoExecutorLoader = false
    local unsupportedRow: Frame = Instance.new("Frame", ScrollingFrame)
    unsupportedRow.Size                   = UDim2.new(1, -8, 0, 28)
    unsupportedRow.BackgroundColor3       = Color3.fromRGB(20, 10, 10)
    unsupportedRow.BackgroundTransparency = 0.75
    unsupportedRow.BorderSizePixel        = 0
    unsupportedRow.ZIndex                 = 2
    Instance.new("UICorner", unsupportedRow).CornerRadius = UDim.new(0, 5)
    do
        local rowStroke: UIStroke = Instance.new("UIStroke", unsupportedRow)
        rowStroke.Color       = Color3.fromRGB(180, 60, 60)
        rowStroke.Thickness   = 1
        rowStroke.Transparency = 0.6
    end
    local warnIcon: TextLabel = Instance.new("TextLabel", unsupportedRow)
    warnIcon.BackgroundTransparency = 1
    warnIcon.AnchorPoint            = Vector2.new(0, 0.5)
    warnIcon.Position               = UDim2.new(0, 6, 0.5, 0)
    warnIcon.Size                   = UDim2.new(0, 14, 0, 14)
    warnIcon.Font                   = Enum.Font.GothamBold
    warnIcon.Text                   = "⚠"
    warnIcon.TextScaled             = true
    warnIcon.TextColor3             = Color3.fromRGB(255, 120, 60)
    warnIcon.ZIndex                 = 3
    local unsupportedLbl: TextLabel = Instance.new("TextLabel", unsupportedRow)
    unsupportedLbl.BackgroundTransparency = 1
    unsupportedLbl.AnchorPoint            = Vector2.new(0, 0.5)
    unsupportedLbl.Position               = UDim2.new(0, 24, 0.5, 0)
    unsupportedLbl.Size                   = UDim2.new(1, -28, 1, 0)
    unsupportedLbl.Font                   = Enum.Font.Arcade
    unsupportedLbl.Text                   = "Ur executor does not support queue_on_teleport sorry!"
    unsupportedLbl.TextSize               = 7
    unsupportedLbl.TextScaled             = false
    unsupportedLbl.TextXAlignment         = Enum.TextXAlignment.Left
    unsupportedLbl.TextColor3             = Color3.fromRGB(180, 100, 100)
    unsupportedLbl.TextWrapped            = true
    unsupportedLbl.ZIndex                 = 3
    autoLoaderCtrl = { Set = function() end }
end

local antiAfkConnection:          RBXScriptConnection? = nil
local antiFlingConnection:        RBXScriptConnection? = nil
local antiGameplayPauseRunning:   boolean              = false
local antiGameplayPauseThread:    thread?              = nil

local antiAfkCtrl: {Set: (any, boolean) -> ()} = addToggle(ScrollingFrame, "Anti AFK", config.antiAfk, function(val: boolean)
    config.antiAfk = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiAfkConnection then
            antiAfkConnection = player.Idled:Connect(function()
                pcall(function()
                    local VirtualUser: VirtualUser = game:GetService("VirtualUser")
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end)
        end
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end
    showNotification("Anti AFK", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

local antiFlingCtrl: {Set: (any, boolean) -> ()} = addToggle(ScrollingFrame, "Anti Fling", config.antiFling, function(val: boolean)
    config.antiFling = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiFlingConnection then
            antiFlingConnection = RunService.Stepped:Connect(function()
                for _, p: Player in Players:GetPlayers() do
                    if p == player or not p.Character then continue end
                    for _, v: Instance in p.Character:GetDescendants() do
                        if v:IsA("BasePart") then
                            (v :: BasePart).CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if antiFlingConnection then
            antiFlingConnection:Disconnect()
            antiFlingConnection = nil
        end
    end
    showNotification("Anti Fling", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

local antiGameplayPauseCtrl: {Set: (any, boolean) -> ()} = addToggle(ScrollingFrame, "Anti Gameplay Pause", config.antiGameplayPause, function(val: boolean)
    config.antiGameplayPause = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiGameplayPauseRunning then
            antiGameplayPauseRunning = true
            antiGameplayPauseThread  = task.spawn(function()
                local GuiService: GuiService = game:GetService("GuiService")
                while antiGameplayPauseRunning do
                    pcall(function()
                        GuiService:SetGameplayPausedNotificationEnabled(false)
                        player.GameplayPaused = false
                    end)
                    task.wait(0.1)
                end
            end)
        end
    else
        antiGameplayPauseRunning = false
        if antiGameplayPauseThread then
            task.cancel(antiGameplayPauseThread)
            antiGameplayPauseThread = nil
        end
    end
    showNotification("Anti Gameplay Pause", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

local skipIntroCtrl: {Set: (any, boolean) -> ()} = addToggle(ScrollingFrame, "Skip Intro UI", config.skipIntroUI, function(val: boolean)
    config.skipIntroUI = val
    saveSkipIntro()
    if config.autoSave then saveConfig() end
    showNotification("Skip Intro UI", val and "Will skip next session" or "Intro restored", Color3.fromRGB(0, 255, 120), 2)
end)

pcall(function()
    if PerfHud then PerfHud.Visible = config.showPerfHud ~= false end
end)

local perfHudCtrl: {Set: (any, boolean) -> ()} = addToggle(ScrollingFrame, "Show FPS / Ping / Players", config.showPerfHud ~= false, function(val: boolean)
    config.showPerfHud = val
    pcall(function()
        if PerfHud then PerfHud.Visible = val end
    end)
    saveUiPrefs()
    if config.autoSave then saveConfig() end
    showNotification("Perf HUD", val and "Visible (top-right)" or "Hidden", Color3.fromRGB(0, 200, 255), 2)
end)

pcall(function()
    if PerfHudDrag then
        PerfHudDrag.DragEnd:Connect(function()
            pcall(function()
                local p: UDim2 = PerfHud.Position
                config.hudPos = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
                saveUiPrefs()
            end)
        end)
    end
end)

local _openTutorialFn: (() -> ())? = nil

local tutorialCtrl: {Set: (any, boolean) -> ()} = addToggle(ScrollingFrame, "Show Tutorial on Start", config.skipTutorial ~= true, function(val: boolean)
    config.skipTutorial = not val
    saveUiPrefs()
    if config.autoSave then saveConfig() end
    showNotification("Tutorial", val and "Will show next session" or "Skipped next session", Color3.fromRGB(0, 200, 255), 2)
    if val and _openTutorialFn then task.spawn(_openTutorialFn) end
end)

do
    local openConsoleButton: TextButton = Instance.new("TextButton")
    openConsoleButton.Name               = "OpenConsoleButton"
    openConsoleButton.Size               = UDim2.new(1, -8, 0, 28)
    openConsoleButton.BackgroundColor3   = Color3.fromRGB(0, 30, 50)
    openConsoleButton.BackgroundTransparency = 0.65
    openConsoleButton.BorderSizePixel    = 0
    openConsoleButton.Font               = Enum.Font.Arcade
    openConsoleButton.Text               = "  Open Console"
    openConsoleButton.TextColor3         = Color3.fromRGB(0, 200, 255)
    openConsoleButton.TextSize           = 11
    openConsoleButton.ZIndex             = 2
    Instance.new("UICorner", openConsoleButton).CornerRadius = UDim.new(0, 5)
    do
        local consoleBtnStroke: UIStroke = Instance.new("UIStroke", openConsoleButton)
        consoleBtnStroke.Color       = Color3.fromRGB(0, 200, 255)
        consoleBtnStroke.Thickness   = 1.2
        consoleBtnStroke.Transparency = 0.45
    end
    openConsoleButton.Parent = ScrollingFrame
    do
        local consoleIcon: ImageLabel = Instance.new("ImageLabel", openConsoleButton)
        consoleIcon.BackgroundTransparency = 1
        consoleIcon.AnchorPoint = Vector2.new(0, 0.5)
        consoleIcon.Position    = UDim2.new(0, 6, 0.5, 0)
        consoleIcon.Size        = UDim2.new(0, 13, 0, 13)
        consoleIcon.Image       = icon("terminal")
        consoleIcon.ImageColor3 = Color3.fromRGB(0, 200, 255)
        consoleIcon.ZIndex      = 3
    end
    openConsoleButton.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
        end)
    end)
end

local deleteConfigButton: TextButton = Instance.new("TextButton")
deleteConfigButton.Name               = "DeleteConfigButton"
deleteConfigButton.Size               = UDim2.new(1, -8, 0, 28)
deleteConfigButton.BackgroundColor3   = Color3.fromRGB(50, 10, 10)
deleteConfigButton.BackgroundTransparency = 0.60
deleteConfigButton.BorderSizePixel    = 0
deleteConfigButton.Font               = Enum.Font.Arcade
deleteConfigButton.Text               = "  Delete Config"
deleteConfigButton.TextColor3         = Color3.fromRGB(255, 100, 100)
deleteConfigButton.TextSize           = 11
deleteConfigButton.ZIndex             = 2
Instance.new("UICorner", deleteConfigButton).CornerRadius = UDim.new(0, 5)
do
local delBtnStroke: UIStroke = Instance.new("UIStroke", deleteConfigButton)
    delBtnStroke.Color       = Color3.fromRGB(255, 80, 80)
    delBtnStroke.Thickness   = 1.2
    delBtnStroke.Transparency = 0.45
end
deleteConfigButton.Parent = ScrollingFrame
do
local deleteIcon: ImageLabel = Instance.new("ImageLabel", deleteConfigButton)
    deleteIcon.BackgroundTransparency = 1
    deleteIcon.AnchorPoint = Vector2.new(0, 0.5)
    deleteIcon.Position    = UDim2.new(0, 6, 0.5, 0)
    deleteIcon.Size        = UDim2.new(0, 13, 0, 13)
    deleteIcon.Image       = icon("trash-2")
    deleteIcon.ImageColor3 = Color3.fromRGB(255, 100, 100)
    deleteIcon.ZIndex      = 3
end

local function updateCanvasSize()
    local totalHeight: number = 0
    for _, child: Instance in ScrollingFrame:GetChildren() do
        if child:IsA("GuiObject") and child ~= (ToggleList :: Instance) then
            totalHeight += (child :: GuiObject).Size.Y.Offset + 8
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, 150))
end
updateCanvasSize()

local function onPanelOpen()
    updateCanvasSize()
end

if config.autoInject         then performAutoInject()         end
if config.autoExecutorLoader and _queueSupported then setupAutoExecutorLoader() end

UpdateGreeting()
pcall(function()
    TweenService:Create(GreetingScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end)

task.spawn(function()
    while RealZzHub and RealZzHub.Parent do
        task.wait(3)
        if not (RealZzHub and RealZzHub.Parent) then break end

        pcall(function()
            TweenService:Create(GreetingScale, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Scale = 0.88,
            }):Play()
            TweenService:Create(GreetingLabel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            }):Play()
            TweenService:Create(GCardSub, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
            }):Play()
            TweenService:Create(GCardIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1,
            }):Play()
        end)
        task.wait(0.25)

        _greetingShowDiscord = not _greetingShowDiscord
        pcall(ApplyGreetingState)

        if _greetingShowDiscord then

            pcall(function()
                TweenService:Create(GCardIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    ImageTransparency = 0,
                }):Play()
                TweenService:Create(GCardSub, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0.2,
                }):Play()
            end)
        else

            pcall(function()
                GCardIcon.ImageTransparency = 1
                GCardSub.TextTransparency   = 1
            end)
        end

        pcall(function()
            TweenService:Create(GreetingScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1,
            }):Play()
            TweenService:Create(GreetingLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0,
                TextStrokeTransparency = 0.6,
            }):Play()
        end)
    end
end)

task.spawn(function()
    task.wait(8)
    local lastKey: string? = nil
    while RealZzHub and RealZzHub.Parent do
        local ok: boolean, key: string?, greeting: string?, emoji: string?, timeStr: string? = pcall(function()
            local t: any = os.date("*t")
            local h: number = t.hour
            local k: string, g: string, e: string
            if h >= 6 and h < 12 then
                k, g, e = "morning", "Good Morning", "🌅"
            elseif h >= 12 and h < 15 then
                k, g, e = "noon", "Good Noon", "☀️"
            elseif h >= 15 and h < 18 then
                k, g, e = "afternoon", "Good Afternoon", "🌞"
            else
                k, g, e = "night", "Good Night", "🌙"
            end
            local h12: number = h % 12
            if h12 == 0 then h12 = 12 end
            local ap: string = h < 12 and "AM" or "PM"
            return k, g, e, string.format("%02d:%02d %s", h12, t.min, ap)
        end)
        if ok and key and key ~= lastKey then
            lastKey = key
            local col: Color3 = Color3.fromRGB(0, 200, 255)
            local tip: string = "Have fun with Alwi Hub!"
            if key == "morning" then
                col = Color3.fromRGB(255, 200, 80)
                tip = "Quiet servers — perfect time to grind. ☀️"
            elseif key == "noon" then
                col = Color3.fromRGB(0, 220, 255)
                tip = "Take breaks and stay hydrated. 🥤"
            elseif key == "afternoon" then
                col = Color3.fromRGB(0, 255, 150)
                tip = "Peak hours — Anti Fling is in Settings if it gets wild."
            else
                col = Color3.fromRGB(150, 140, 255)
                tip = "Chill late-night servers. Anti AFK before dozing. 🌙"
            end
            local who: string = "Player"
            pcall(function() who = Players.LocalPlayer.DisplayName end)
            pcall(showNotification,
                (greeting or "Hello") .. ", " .. who .. "! " .. (emoji or ""),
                "It's " .. (timeStr or "") .. ". " .. tip,
                col, 6,
                "rbxassetid://103887859853708"
            )
        end
        task.wait(20)
    end
end)

InjectButton.MouseButton1Click:Connect(function()
    if not InjectButton.Active then return end

    delay(5, function()
        if not RealZzHub or not RealZzHub.Parent then return end
        local txt = InjectButton.Text or ""
        if txt:find("Loading") or txt:find("Fallback") then
            pcall(function() RealZzHub:Destroy() end)
        end
    end)

    task.spawn(injectScript)
end)

local PanelScale: UIScale = Instance.new("UIScale", SettingsPanel)
PanelScale.Scale = 1

local _settingsPanelAnimating: boolean = false

local function openSettingsPanel()
    if _settingsPanelAnimating then return end
    _settingsPanelAnimating = true

    pcall(function()
        TweenService:Create(SettingsIconScale,
            TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Scale = 0.72 }):Play()
    end)
    task.delay(0.10, function()
        pcall(function()
            TweenService:Create(SettingsIconScale,
                TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                { Scale = 1 }):Play()
            TweenService:Create(SettingsIcon,
                TweenInfo.new(0.40, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Rotation = 90, ImageTransparency = 0 }):Play()
        end)
    end)

    resetToSettingsTab()
    SettingsPanel.Visible           = true
    SettingsPanel.Size              = UDim2.new(0, PANEL_W, 0, 0)
    SettingsPanel.ImageTransparency = 1
    PanelScale.Scale                = 0.88

    task.delay(0.05, function()
        pcall(function()
            TweenService:Create(SettingsPanel,
                TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, PANEL_W, 0, PANEL_H), ImageTransparency = 0 }):Play()
            TweenService:Create(PanelScale,
                TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Scale = 1 }):Play()
        end)
    end)

    task.delay(0.38, function()
        _settingsPanelAnimating = false
    end)

    setButtonActive(InjectButton, false)
    setButtonActive(CloseButton,  false)
    onPanelOpen()
end

local function closeSettingsPanel(callback: (() -> ())?)
    if _settingsPanelAnimating then
        if callback then callback() end
        return
    end
    _settingsPanelAnimating = true

    pcall(function()
        TweenService:Create(SettingsIconScale,
            TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Scale = 0.78 }):Play()
    end)
    task.delay(0.08, function()
        pcall(function()
            TweenService:Create(SettingsIconScale,
                TweenInfo.new(0.50, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                { Scale = 1 }):Play()
            TweenService:Create(SettingsIcon,
                TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                { Rotation = 0, ImageTransparency = 0.2 }):Play()
        end)
    end)

    pcall(function()
        TweenService:Create(PanelScale,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Scale = 0.92 }):Play()
        TweenService:Create(SettingsPanel,
            TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Size = UDim2.new(0, PANEL_W, 0, 0), ImageTransparency = 1 }):Play()
    end)

    task.delay(0.24, function()
        if SettingsPanel then
            SettingsPanel.Visible           = false
            SettingsPanel.Size              = UDim2.new(0, PANEL_W, 0, PANEL_H)
            SettingsPanel.ImageTransparency = 0
        end
        PanelScale.Scale = 1
        _settingsPanelAnimating = false
        resetToSettingsTab()
        if callback then callback() end
    end)
end

SettingsIcon.MouseEnter:Connect(function()
    if SettingsPanel and not SettingsPanel.Visible and not _settingsPanelAnimating then
        pcall(function()
            TweenService:Create(SettingsIconScale,
                TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Scale = 1.25 }):Play()
            TweenService:Create(SettingsIcon,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Rotation = 36, ImageTransparency = 0 }):Play()
        end)
    end
end)

SettingsIcon.MouseLeave:Connect(function()
    if SettingsPanel and not SettingsPanel.Visible and not _settingsPanelAnimating then
        pcall(function()
            TweenService:Create(SettingsIconScale,
                TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Scale = 1 }):Play()
            TweenService:Create(SettingsIcon,
                TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                { Rotation = 0, ImageTransparency = 0.2 }):Play()
        end)
    end
end)

SettingsIcon.MouseButton1Click:Connect(function()
    if not SettingsPanel then return end
    if SettingsPanel.Visible then
        closeSettingsPanel(function()
            if ConfirmFrame and not ConfirmFrame.Visible and DeleteConfirmFrame and not DeleteConfirmFrame.Visible then
                setButtonActive(InjectButton, true)
                setButtonActive(CloseButton,  true)
                setButtonActive(SettingsIcon, true)
            end
        end)
    else
        openSettingsPanel()
    end
end)

local confirmClosing: boolean = false
local function closeConfirmDialog(callback: (() -> ())?)
    if not ConfirmFrame or not ConfirmFrame.Parent or not ConfirmFrame.Visible or confirmClosing then
        if callback then callback() end
        return
    end
    confirmClosing = true
    local tween: Tween = TweenService:Create(ConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
    })
    tween.Completed:Connect(function()
        if ConfirmFrame and ConfirmFrame.Parent then
            ConfirmFrame.Visible           = false
            ConfirmFrame.Size              = UDim2.new(0, 200, 0, 100)
            ConfirmFrame.ImageTransparency = 0
        end
        confirmClosing = false
        if SettingsPanel and SettingsPanel.Visible then
            setButtonActive(InjectButton, false)
            setButtonActive(CloseButton,  false)
            setButtonActive(SettingsIcon, true)
        else
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton,  true)
            setButtonActive(SettingsIcon, true)
        end
        if callback then callback() end
    end)
    tween:Play()
end

CloseButton.MouseButton1Click:Connect(function()
    if not ConfirmFrame or ConfirmFrame.Visible or (DeleteConfirmFrame and DeleteConfirmFrame.Visible) then return end
    setButtonActive(InjectButton, false)
    setButtonActive(CloseButton,  false)
    setButtonActive(SettingsIcon, false)
    if SettingsPanel and SettingsPanel.Visible then
        SettingsPanel.Visible           = false
        SettingsPanel.Size              = UDim2.new(0, PANEL_W, 0, PANEL_H)
        SettingsPanel.ImageTransparency = 0
    end
    ConfirmFrame.Visible           = true
    ConfirmFrame.Size              = UDim2.new(0, 0, 0, 0)
    ConfirmFrame.ImageTransparency = 1
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200, 0, 100), ImageTransparency = 0
    }):Play()
end)

YesButton.MouseButton1Click:Connect(function()
    closeConfirmDialog(function()
        clearText()
        TweenService:Create(MainBackground, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
        }):Play()
        task.wait(0.3)
        cleanupAntiFeatures()
        if RealZzHub then RealZzHub:Destroy() end
    end)
end)

NoButton.MouseButton1Click:Connect(function()
    closeConfirmDialog()
end)

local deleteConfirmClosing: boolean = false
local function closeDeleteConfirmDialog(callback: (() -> ())?)
    if not DeleteConfirmFrame or not DeleteConfirmFrame.Parent
        or not DeleteConfirmFrame.Visible or deleteConfirmClosing then
        if callback then callback() end
        return
    end
    deleteConfirmClosing = true
    local tween: Tween = TweenService:Create(DeleteConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
    })
    tween.Completed:Connect(function()
        if DeleteConfirmFrame and DeleteConfirmFrame.Parent then
            DeleteConfirmFrame.Visible           = false
            DeleteConfirmFrame.Size              = UDim2.new(0, 200, 0, 100)
            DeleteConfirmFrame.ImageTransparency = 0
        end
        deleteConfirmClosing = false
        if SettingsPanel and SettingsPanel.Visible then
            setButtonActive(InjectButton, false)
            setButtonActive(CloseButton,  false)
            setButtonActive(SettingsIcon, true)
        else
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton,  true)
            setButtonActive(SettingsIcon, true)
        end
        if callback then callback() end
    end)
    tween:Play()
end

deleteConfigButton.MouseButton1Click:Connect(function()
    if (DeleteConfirmFrame and DeleteConfirmFrame.Visible) or (ConfirmFrame and ConfirmFrame.Visible) then return end
    if not DeleteConfirmFrame then return end
    setButtonActive(InjectButton, false)
    setButtonActive(CloseButton,  false)
    setButtonActive(SettingsIcon, false)
    local _dcf: ImageLabel = DeleteConfirmFrame :: ImageLabel
    _dcf.Visible           = true
    _dcf.Size              = UDim2.new(0, 0, 0, 0)
    _dcf.ImageTransparency = 1
    TweenService:Create(_dcf, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200, 0, 100), ImageTransparency = 0
    }):Play()
end)

DeleteYesButton.MouseButton1Click:Connect(function()
    closeDeleteConfirmDialog(function()
        local fileDeleted: boolean = false
        if isfile and delfile then
            pcall(function()
                if isfile(CONFIG_FILE) then
                    delfile(CONFIG_FILE)
                    fileDeleted = true
                end
            end)
        end
        if fileDeleted then
            config.autoSave           = false
            config.autoInject         = false
            config.autoExecutorLoader = false
            config.antiAfk            = false
            config.antiFling          = false
            config.antiGameplayPause  = false
            config.skipIntroUI        = false
            config.showPerfHud        = true
            config.skipTutorial       = false
            config.hudPos             = nil

            autoSaveCtrl:Set(false)
            autoInjectCtrl:Set(false)
            autoLoaderCtrl:Set(false)
            antiAfkCtrl:Set(false)
            antiFlingCtrl:Set(false)
            antiGameplayPauseCtrl:Set(false)
            skipIntroCtrl:Set(false)
            pcall(function() perfHudCtrl:Set(true) end)
            pcall(function() tutorialCtrl:Set(true) end)
            pcall(function()
                if PerfHud then
                    PerfHud.Visible = true
                    PerfHud.Position = UDim2.new(1, -10, 0, 10)
                end
            end)

            showNotification("Config Deleted", "Settings file has been removed.", Color3.fromRGB(255, 100, 100), 3)
        end
    end)
end)

DeleteNoButton.MouseButton1Click:Connect(function()
    closeDeleteConfirmDialog()
end)

local _dragOk: boolean, _dragErr: any = pcall(function()
    local probe: UIDragDetector = Instance.new("UIDragDetector")
    probe:Destroy()

    local drag: UIDragDetector = Instance.new("UIDragDetector")
    drag.Parent = MainBackground

    local dragScale: UIScale = Instance.new("UIScale")
    dragScale.Scale  = 1
    dragScale.Parent = MainBackground

    local pressTweenInfo: TweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out)
    local snapTweenInfo:  TweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Elastic,  Enum.EasingDirection.Out)

    local function applyTween(obj: Instance, props: { [string]: any }, info: TweenInfo?)
        local ok: boolean, err: any = pcall(function()
            TweenService:Create(obj, info or pressTweenInfo, props):Play()
        end)
        if not ok then warn("[VelocityX] Drag tween error:", err) end
    end

    local isDragging:    boolean = false
    local lastSwayTime:  number  = 0
    local SWAY_THROTTLE: number  = 0.06
    local SWAY_SPEED:    number  = 3.2
    local SWAY_AMP:      number  = 5

    local function settingsOpen(): boolean
        return SettingsPanel ~= nil and SettingsPanel.Visible
    end

    drag.DragStart:Connect(function()
        if settingsOpen() then return end
        isDragging   = true
        lastSwayTime = tick()
        applyTween(dragScale,      { Scale = 0.96 })
        applyTween(MainBackground, { BackgroundTransparency = 0.5 })
    end)

    drag.DragContinue:Connect(function()
        if not isDragging or settingsOpen() then return end
        local now: number = tick()
        if (now - lastSwayTime) < SWAY_THROTTLE then return end
        lastSwayTime = now
        local sway: number = math.sin(now * SWAY_SPEED) * SWAY_AMP
        applyTween(MainBackground, { Rotation = sway })
    end)

    drag.DragEnd:Connect(function()
        isDragging   = false
        lastSwayTime = 0
        applyTween(dragScale,      { Scale = 1 },                                      snapTweenInfo)
        applyTween(MainBackground, { BackgroundTransparency = 0, Rotation = 0 }, snapTweenInfo)
    end)
end)

if not _dragOk then
    warn("[VelocityX] UIDragDetector unavailable — using fallback drag. Reason:", _dragErr)

    local UserInputService = game:GetService("UserInputService")
    local dragging:       boolean       = false
    local dragStartMouse: Vector2?      = nil
    local dragStartPos:   UDim2?        = nil

    local function isDragInput(input: InputObject): boolean
        return input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
    end

    local function isMotionInput(input: InputObject): boolean
        return input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
    end

    MainBackground.InputBegan:Connect(function(input: InputObject)
        if not isDragInput(input) then return end
        if SettingsPanel and SettingsPanel.Visible then return end
        dragging       = true
        dragStartMouse = Vector2.new(input.Position.X, input.Position.Y)
        dragStartPos   = MainBackground.Position
        pcall(function()
            TweenService:Create(MainBackground, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0.5
            }):Play()
        end)
    end)

    UserInputService.InputChanged:Connect(function(input: InputObject)
        if not dragging or not isMotionInput(input) then return end
        if SettingsPanel and SettingsPanel.Visible then return end
        local delta:    Vector2 = Vector2.new(input.Position.X, input.Position.Y) - (dragStartMouse :: Vector2)
        local viewport: Vector2 = workspace.CurrentCamera.ViewportSize
        local sp: UDim2 = dragStartPos :: UDim2
        MainBackground.Position = UDim2.new(
            sp.X.Scale + delta.X / viewport.X,
            sp.X.Offset,
            sp.Y.Scale + delta.Y / viewport.Y,
            sp.Y.Offset
        )
    end)

    UserInputService.InputEnded:Connect(function(input: InputObject)
        if not isDragInput(input) or not dragging then return end
        dragging = false
        pcall(function()
            TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
        end)
    end)
end

pcall(function()
    if PerfHud then
        local tx: UDim2 = UDim2.new(1, -10, 0, 10)
        local hp: any = config.hudPos
        if type(hp) == "table" and #hp == 4 then
            local okp: boolean = pcall(function()
                tx = UDim2.new(hp[1], hp[2], hp[3], hp[4])
            end)
            if okp then
                pcall(function()
                    local vp: Vector2 = workspace.CurrentCamera.ViewportSize
                    local ox: number = math.clamp(tx.X.Offset, 60, vp.X)
                    local oy: number = math.clamp(tx.Y.Offset, 0, vp.Y - 40)
                    tx = UDim2.new(tx.X.Scale, ox, tx.Y.Scale, oy)
                end)
            else
                tx = UDim2.new(1, -10, 0, 10)
            end
        end
        TweenService:Create(PerfHud, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = tx,
        }):Play()
    end
end)

local TutorialOpen:      boolean = false
local TutorialStep:      number  = 1
local TutorialDontShow:  boolean = false
local TUTOR_TOTAL:       number  = 7

local TUTOR_STEPS = {
    {
        target = "MainBackground", icon = "layout-dashboard",
        title = "Welcome to Alwi Hub!",
        desc  = "Alwi Hub auto-detected your game and picked {GAME}.lua for you. No match? It falls back to Universal. This tour points at everything you need.",
    },
    {
        target = "InjectButton", icon = "rocket",
        title = "Step 1: press INJECT",
        desc  = "Hit this big button. It flashes green and a NEW game window pops up — that is your script, use all its features from there. Red button + error panel? Bad connection: press Retry.",
    },
    {
        target = "SettingsIcon", icon = "settings",
        title = "Step 2: the gear icon",
        desc  = "This gear opens Settings. Next step takes you inside: Auto Inject, Auto Executor Loader, Anti AFK, Anti Fling and more.",
    },
    {
        target = "TabBtnSettings", panel = true, tab = "settings", icon = "cog",
        title = "Step 3: Settings tab",
        desc  = "Helpers that play for you: Auto Inject loads on start, Auto Executor Loader reloads after teleport, Anti AFK stops kicks, plus Anti Fling and Anti Gameplay Pause.",
    },
    {
        target = "TabBtnInfo", panel = true, tab = "info", icon = "info",
        title = "Step 4: Info tab",
        desc  = "Live FPS/Ping, copyable Job ID + teleport command, and your XYZ position with Copy Tween / Copy CFrame buttons for getting around.",
    },
    {
        target = "TabBtnCredit", panel = true, tab = "credit", icon = "star",
        title = "Step 5: Credit tab",
        desc  = "Meet the owner + helper: live status, Roblox profiles and socials. Tap any button to copy its link.",
    },
    {
        target = "PerfHud", panel = false, icon = "gauge",
        title = "Step 6: always-on HUD",
        desc  = "This pill shows Ping / FPS / Players and survives inject — drag it anywhere. The ? button reopens this tour. Stuck? Tap the greeting card to copy the Discord. Enjoy {GAME}!",
    },
}

local TourGui: ScreenGui = Instance.new("ScreenGui")
TourGui.Name           = "AlwiTourGui"
TourGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TourGui.ResetOnSpawn   = false
TourGui.DisplayOrder   = 999999
TourGui.IgnoreGuiInset = true
pcall(function()
    for _, gui: Instance in CoreGui:GetChildren() do
        if gui.Name == "AlwiTourGui" then gui:Destroy() end
    end
end)
pcall(function()
    local _gethui2: any = rawget(_G, "gethui")
    if _syn and _syn.protect_gui then
        _syn.protect_gui(TourGui)
        TourGui.Parent = CoreGui
    elseif _gethui2 then
        TourGui.Parent = _gethui2()
    else
        TourGui.Parent = CoreGui
    end
end)
if not TourGui.Parent then
    TourGui.Parent = CoreGui
end

local TourScale: UIScale = Instance.new("UIScale", TourGui)
TourScale.Scale = 1
local function tourFitScale()
    pcall(function()
        local cam: Camera? = workspace.CurrentCamera
        local vp: Vector2 = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        TourScale.Scale = math.clamp(math.min(vp.X / 1280, vp.Y / 720), 0.7, 1.15)
    end)
end
local function tourS(): number
    local s: number = 1
    pcall(function() s = TourScale.Scale end)
    return (s and s > 0) and s or 1
end
tourFitScale()

local TutorDim: TextButton = Instance.new("TextButton", TourGui)
TutorDim.Name                   = "AlwiTutorDim"
TutorDim.Size                   = UDim2.new(1, 0, 1, 0)
TutorDim.BackgroundColor3       = Color3.new(0, 0, 0)
TutorDim.BackgroundTransparency = 0.45
TutorDim.BorderSizePixel        = 0
TutorDim.Text                   = ""
TutorDim.AutoButtonColor        = false
TutorDim.ZIndex                 = 60
TutorDim.Visible                = false

local TutorCard: Frame = Instance.new("Frame", TourGui)
TutorCard.Name                   = "AlwiTutorCard"
TutorCard.AnchorPoint            = Vector2.new(0.5, 0.5)
TutorCard.Position               = UDim2.new(0.5, 0, 0.5, 0)
TutorCard.Size                   = UDim2.new(0, 340, 0, 220)
TutorCard.BackgroundColor3       = Color3.fromRGB(8, 16, 13)
TutorCard.BackgroundTransparency = 0.05
TutorCard.BorderSizePixel        = 0
TutorCard.ZIndex                 = 62
TutorCard.Visible                = false
TutorCard.ClipsDescendants       = true
Instance.new("UICorner", TutorCard).CornerRadius = UDim.new(0, 10)
do
    local TutorStroke: UIStroke = Instance.new("UIStroke", TutorCard)
    TutorStroke.Color        = Color3.fromRGB(0, 220, 160)
    TutorStroke.Thickness    = 1.5
    TutorStroke.Transparency = 0.3
    local TutorTopBar: Frame = Instance.new("Frame", TutorCard)
    TutorTopBar.Size             = UDim2.new(1, 0, 0, 2)
    TutorTopBar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    TutorTopBar.BorderSizePixel  = 0
    TutorTopBar.ZIndex           = 62
end
local TutorCardScale: UIScale = Instance.new("UIScale", TutorCard)
TutorCardScale.Scale = 1

local TourRing: Frame = Instance.new("Frame", TourGui)
TourRing.Name                   = "AlwiTourRing"
TourRing.AnchorPoint            = Vector2.new(0.5, 0.5)
TourRing.BackgroundTransparency = 1
TourRing.BorderSizePixel        = 0
TourRing.ZIndex                 = 61
TourRing.Visible                = false
Instance.new("UICorner", TourRing).CornerRadius = UDim.new(0, 10)
do
    local RingStroke: UIStroke = Instance.new("UIStroke", TourRing)
    RingStroke.Color        = Color3.fromRGB(0, 255, 150)
    RingStroke.Thickness    = 2.5
    RingStroke.Transparency = 0.05
end

local function tourResolveTarget(ref: any): GuiObject?
    if typeof(ref) == "Instance" and (ref :: Instance):IsA("GuiObject") then
        return ref :: GuiObject
    end
    local name: string? = (type(ref) == "string") and ref or nil
    if name == "MainBackground" then return MainBackground
    elseif name == "InjectButton" then return InjectButton
    elseif name == "SettingsIcon" then return SettingsIcon
    elseif name == "HelpBtn" then return HelpBtn
    elseif name == "TabBtnSettings" then return TabBtnSettings
    elseif name == "TabBtnInfo" then return TabBtnInfo
    elseif name == "TabBtnCredit" then return TabBtnCredit
    elseif name == "PerfHud" then return PerfHud
    elseif name == "GreetingCard" then return GreetingCard
    end
    return nil
end

local TOUR_TIP_H: number = 220
local tourPlaceToken: number = 0
local tourLastTarget: GuiObject? = nil
local tourFollowConns: {RBXScriptConnection} = {}

local function tourStopFollow()
    for _, c: RBXScriptConnection in tourFollowConns do
        pcall(function() c:Disconnect() end)
    end
    table.clear(tourFollowConns)
end

local function tourTargetShown(t: GuiObject): boolean
    local n: Instance? = t
    while n do
        if n:IsA("GuiObject") and not (n :: GuiObject).Visible then return false end
        if n:IsA("ScreenGui") then break end
        n = n.Parent
    end
    return true
end

local function tourRehug()
    local target: GuiObject? = tourLastTarget
    if not TutorialOpen or not target or not target.Parent then return end
    if not tourTargetShown(target :: GuiObject) then return end
    pcall(function()
        local s: number = tourS()
        local t: GuiObject = target :: GuiObject
        local tp: Vector2 = t.AbsolutePosition
        local ts: Vector2 = t.AbsoluteSize
        local ix: number, iy: number = 0, 0
        pcall(function()
            local inset: Vector2 = game:GetService("GuiService"):GetGuiInset()
            ix, iy = inset.X, inset.Y
        end)
        TourRing.Visible     = true
        TourRing.AnchorPoint = Vector2.new(0.5, 0.5)
        TourRing.Position    = UDim2.new(0, (tp.X + ts.X / 2 + ix) / s, 0, (tp.Y + ts.Y / 2 + iy) / s)
        TourRing.Size        = UDim2.new(0, (ts.X + 16) / s, 0, (ts.Y + 16) / s)
    end)
end

local _tourLog: {string} = {}
local function tourLog(line: string)
    pcall(function()
        table.insert(_tourLog, os.date("%H:%M:%S") .. " " .. line)
        while #_tourLog > 40 do table.remove(_tourLog, 1) end
        if writefile then
            if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
                makefolder(CONFIG_FOLDER)
            end
            writefile(CONFIG_FOLDER .. "/tour_debug.txt", table.concat(_tourLog, "\n"))
        end
    end)
end

local function tourPlaceTip(target: GuiObject?, settle: number, label: string?)
    tourPlaceToken += 1
    local myToken: number = tourPlaceToken
    tourLastTarget = target
    tourStopFollow()
    task.spawn(function()
        task.wait(settle)
        if myToken ~= tourPlaceToken or not TutorialOpen then return end
        local cam: Camera? = workspace.CurrentCamera
        local vp: Vector2 = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        if not target or not target.Parent
            or (target:IsA("GuiObject") and not tourTargetShown(target :: GuiObject)) then
            pcall(function()
                TourRing.Visible = false
                TweenService:Create(TutorCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                }):Play()
            end)
            return
        end
        pcall(function()
            local s: number = tourS()
            local topEdge: number = 8
            local insetX: number = 0
            local insetY: number = 0
            pcall(function()
                local inset: Vector2 = game:GetService("GuiService"):GetGuiInset()
                insetX, insetY = inset.X, inset.Y
                topEdge = inset.Y + 8
            end)
            local t: GuiObject = target :: GuiObject
            local tp: Vector2 = t.AbsolutePosition
            local ts: Vector2 = t.AbsoluteSize
            TourRing.Visible     = true
            TourRing.AnchorPoint = Vector2.new(0.5, 0.5)
            TourRing.Position    = UDim2.new(0, (tp.X + ts.X / 2 + insetX) / s, 0, (tp.Y + ts.Y / 2 + insetY) / s)
            TourRing.Size        = UDim2.new(0, (ts.X + 16) / s, 0, (ts.Y + 16) / s)
            local halfW:   number = (340 * s) / 2
            local halfH:   number = (TOUR_TIP_H * s) / 2
            local cx: number = tp.X + ts.X / 2
            local xScreen: number = math.clamp(cx, halfW + 8, vp.X - halfW - 8)
            local fitsBelow: boolean = (tp.Y + ts.Y + 12 + halfH * 2) <= (vp.Y - 8)
            local fitsAbove: boolean = (tp.Y - 12 - halfH * 2) >= topEdge
            local nearTop:   boolean = tp.Y < vp.Y * 0.4
            local anchor: Vector2 = Vector2.new(0.5, 0.5)
            local pos: UDim2 = UDim2.new(0, (xScreen + insetX) / s, 0, (tp.Y + ts.Y / 2 + insetY) / s)
            if (nearTop and fitsBelow) or (fitsBelow and not fitsAbove) then
                anchor = Vector2.new(0.5, 0)
                pos = UDim2.new(0, (xScreen + insetX) / s, 0, (tp.Y + ts.Y + 12 + insetY) / s)
            elseif fitsAbove then
                anchor = Vector2.new(0.5, 1)
                pos = UDim2.new(0, (xScreen + insetX) / s, 0, (tp.Y - 12 + insetY) / s)
            end
            local _dbg: string = string.format(
                "[AlwiTour] place[%s] tp=(%d,%d) ts=(%d,%d) ring=(%s) card=(%s,%s)",
                tostring(label), tp.X, tp.Y, ts.X, ts.Y,
                tostring(TourRing.Position), tostring(anchor), tostring(pos))
            print(_dbg)
            tourLog(_dbg)
            TweenService:Create(TutorCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                AnchorPoint = anchor,
                Position = pos,
            }):Play()
        end)
        task.wait(0.6)
        if myToken ~= tourPlaceToken or not TutorialOpen then return end
        tourRehug()
        if tourLastTarget and tourLastTarget.Parent then
            pcall(function()
                local t: GuiObject = tourLastTarget :: GuiObject
                table.insert(tourFollowConns, t:GetPropertyChangedSignal("AbsolutePosition"):Connect(tourRehug))
                table.insert(tourFollowConns, t:GetPropertyChangedSignal("AbsoluteSize"):Connect(tourRehug))
            end)
        end
    end)
end

local TutorStepIcon: ImageLabel = Instance.new("ImageLabel", TutorCard)
TutorStepIcon.BackgroundTransparency = 1
TutorStepIcon.AnchorPoint = Vector2.new(0, 0.5)
TutorStepIcon.Position    = UDim2.new(0, 10, 0, 19)
TutorStepIcon.Size        = UDim2.new(0, 15, 0, 15)
TutorStepIcon.Image       = icon("info")
TutorStepIcon.ImageColor3 = Color3.fromRGB(0, 255, 150)
TutorStepIcon.ZIndex      = 62

local TutorTitle: TextLabel = Instance.new("TextLabel", TutorCard)
TutorTitle.BackgroundTransparency = 1
TutorTitle.Position = UDim2.new(0, 30, 0, 10)
TutorTitle.Size     = UDim2.new(1, -178, 0, 18)
TutorTitle.Font     = Enum.Font.Arcade
TutorTitle.TextScaled = true
do
    local TitleLimits: UITextSizeConstraint = Instance.new("UITextSizeConstraint", TutorTitle)
    TitleLimits.MinTextSize = 9
    TitleLimits.MaxTextSize = 14
end
TutorTitle.TextXAlignment = Enum.TextXAlignment.Left
TutorTitle.TextColor3     = Color3.fromRGB(0, 255, 150)
TutorTitle.ZIndex         = 62

local TutorStepLbl: TextLabel = Instance.new("TextLabel", TutorCard)
TutorStepLbl.BackgroundTransparency = 1
TutorStepLbl.AnchorPoint = Vector2.new(1, 0)
TutorStepLbl.Position    = UDim2.new(1, -60, 0, 10)
TutorStepLbl.Size        = UDim2.new(0, 86, 0, 18)
TutorStepLbl.Font        = Enum.Font.Arcade
TutorStepLbl.TextSize    = 10
TutorStepLbl.TextXAlignment = Enum.TextXAlignment.Right
TutorStepLbl.TextColor3     = Color3.fromRGB(140, 140, 140)
TutorStepLbl.ZIndex         = 62

local TutorSkipBtn: TextButton = Instance.new("TextButton", TutorCard)
TutorSkipBtn.AnchorPoint = Vector2.new(1, 0)
TutorSkipBtn.Position    = UDim2.new(1, -8, 0, 8)
TutorSkipBtn.Size        = UDim2.new(0, 46, 0, 20)
TutorSkipBtn.BackgroundColor3       = Color3.fromRGB(50, 16, 16)
TutorSkipBtn.BackgroundTransparency = 0.3
TutorSkipBtn.BorderSizePixel        = 0
TutorSkipBtn.Font        = Enum.Font.Arcade
TutorSkipBtn.Text        = "Skip"
TutorSkipBtn.TextSize    = 10
TutorSkipBtn.TextColor3  = Color3.fromRGB(255, 130, 130)
TutorSkipBtn.ZIndex      = 63
Instance.new("UICorner", TutorSkipBtn).CornerRadius = UDim.new(1, 0)

local TutorDescScroll: ScrollingFrame = Instance.new("ScrollingFrame", TutorCard)
TutorDescScroll.BackgroundTransparency = 1
TutorDescScroll.Position = UDim2.new(0, 12, 0, 34)
TutorDescScroll.Size     = UDim2.new(1, -24, 0, 92)
TutorDescScroll.BorderSizePixel        = 0
TutorDescScroll.ScrollBarThickness     = 4
TutorDescScroll.ScrollBarImageColor3   = Color3.fromRGB(0, 220, 160)
TutorDescScroll.ScrollingDirection     = Enum.ScrollingDirection.Y
TutorDescScroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
TutorDescScroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
TutorDescScroll.ZIndex                 = 62

local TutorDesc: TextLabel = Instance.new("TextLabel", TutorDescScroll)
TutorDesc.BackgroundTransparency = 1
TutorDesc.Position = UDim2.new(0, 0, 0, 0)
TutorDesc.Size     = UDim2.new(1, -8, 1, 0)
TutorDesc.Font     = Enum.Font.Arcade
TutorDesc.TextScaled = true
do
    local DescLimits: UITextSizeConstraint = Instance.new("UITextSizeConstraint", TutorDesc)
    DescLimits.MinTextSize = 8
    DescLimits.MaxTextSize = 11
end
TutorDesc.TextWrapped = true
TutorDesc.TextXAlignment = Enum.TextXAlignment.Left
TutorDesc.TextYAlignment  = Enum.TextYAlignment.Top
TutorDesc.TextColor3      = Color3.fromRGB(215, 215, 215)
TutorDesc.ZIndex          = 62

local TutorDots: {Frame} = {}
do
    local dotsRow: Frame = Instance.new("Frame", TutorCard)
    dotsRow.BackgroundTransparency = 1
    dotsRow.AnchorPoint = Vector2.new(0.5, 0)
    dotsRow.Position    = UDim2.new(0.5, 0, 0, 130)
    dotsRow.Size        = UDim2.new(1, -24, 0, 10)
    dotsRow.ZIndex      = 62
    local dotsLayout: UIListLayout = Instance.new("UIListLayout", dotsRow)
    dotsLayout.FillDirection       = Enum.FillDirection.Horizontal
    dotsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    dotsLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    dotsLayout.Padding             = UDim.new(0.03, 4)
    dotsLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    for i: number = 1, TUTOR_TOTAL do
        local dot: Frame = Instance.new("Frame", dotsRow)
        dot.Size        = UDim2.new(0, 8, 0, 8)
        dot.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        dot.BorderSizePixel  = 0
        dot.ZIndex           = 63
        dot.LayoutOrder      = i
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        TutorDots[i] = dot
    end
end

local TutorNavRow: Frame = Instance.new("Frame", TutorCard)
TutorNavRow.BackgroundTransparency = 1
TutorNavRow.AnchorPoint = Vector2.new(0, 1)
TutorNavRow.Position    = UDim2.new(0, 12, 1, -38)
TutorNavRow.Size        = UDim2.new(1, -24, 0, 26)
TutorNavRow.ZIndex      = 62
do
    local navLayout: UIListLayout = Instance.new("UIListLayout", TutorNavRow)
    navLayout.FillDirection       = Enum.FillDirection.Horizontal
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    navLayout.Padding             = UDim.new(0.04, 8)
    navLayout.SortOrder           = Enum.SortOrder.LayoutOrder
end

local TutorBackBtn: TextButton = Instance.new("TextButton", TutorNavRow)
TutorBackBtn.Size        = UDim2.new(0, 70, 0, 26)
TutorBackBtn.LayoutOrder = 1
TutorBackBtn.BackgroundColor3       = Color3.fromRGB(30, 30, 38)
TutorBackBtn.BackgroundTransparency = 0.2
TutorBackBtn.BorderSizePixel        = 0
TutorBackBtn.Font        = Enum.Font.Arcade
TutorBackBtn.Text        = "< Back"
TutorBackBtn.TextSize    = 11
TutorBackBtn.TextColor3  = Color3.fromRGB(200, 200, 200)
TutorBackBtn.ZIndex      = 63
Instance.new("UICorner", TutorBackBtn).CornerRadius = UDim.new(0, 5)

local TutorNextBtn: TextButton = Instance.new("TextButton", TutorNavRow)
TutorNextBtn.Size        = UDim2.new(0, 110, 0, 26)
TutorNextBtn.LayoutOrder = 2
TutorNextBtn.BackgroundColor3       = Color3.fromRGB(0, 255, 120)
TutorNextBtn.BackgroundTransparency = 0
TutorNextBtn.BorderSizePixel        = 0
TutorNextBtn.Font        = Enum.Font.Arcade
TutorNextBtn.Text        = "Next >"
TutorNextBtn.TextSize    = 11
TutorNextBtn.TextColor3  = Color3.fromRGB(5, 5, 5)
TutorNextBtn.ZIndex      = 63
Instance.new("UICorner", TutorNextBtn).CornerRadius = UDim.new(0, 5)
do
    local NextGrad: UIGradient = Instance.new("UIGradient", TutorNextBtn)
    NextGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
    }
    NextGrad.Rotation = 90
end

local TutorCheckBtn: TextButton = Instance.new("TextButton", TutorCard)
TutorCheckBtn.BackgroundTransparency = 1
TutorCheckBtn.AnchorPoint = Vector2.new(0, 1)
TutorCheckBtn.Position    = UDim2.new(0, 12, 1, -8)
TutorCheckBtn.Size        = UDim2.new(1, -24, 0, 18)
TutorCheckBtn.Font        = Enum.Font.Arcade
TutorCheckBtn.Text        = ""
TutorCheckBtn.ZIndex      = 63
TutorCheckBtn.AutoButtonColor = false
local TutorCheckBox: Frame = Instance.new("Frame", TutorCheckBtn)
TutorCheckBox.AnchorPoint = Vector2.new(0, 0.5)
TutorCheckBox.Position    = UDim2.new(0, 0, 0.5, 0)
TutorCheckBox.Size        = UDim2.new(0, 13, 0, 13)
TutorCheckBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
TutorCheckBox.BorderSizePixel  = 0
TutorCheckBox.ZIndex           = 64
Instance.new("UICorner", TutorCheckBox).CornerRadius = UDim.new(0, 3)
do
    local CheckStroke: UIStroke = Instance.new("UIStroke", TutorCheckBox)
    CheckStroke.Color       = Color3.fromRGB(0, 220, 160)
    CheckStroke.Thickness   = 1
    CheckStroke.Transparency = 0.4
end
local TutorCheckTick: TextLabel = Instance.new("TextLabel", TutorCheckBox)
TutorCheckTick.Size = UDim2.new(1, 0, 1, 0)
TutorCheckTick.BackgroundTransparency = 1
TutorCheckTick.Font      = Enum.Font.GothamBold
TutorCheckTick.Text      = "✓"
TutorCheckTick.TextSize  = 11
TutorCheckTick.TextColor3 = Color3.fromRGB(0, 255, 150)
TutorCheckTick.Visible   = false
TutorCheckTick.ZIndex    = 65
local TutorCheckLbl: TextLabel = Instance.new("TextLabel", TutorCheckBtn)
TutorCheckLbl.BackgroundTransparency = 1
TutorCheckLbl.Position = UDim2.new(0, 19, 0, 0)
TutorCheckLbl.Size     = UDim2.new(1, -19, 1, 0)
TutorCheckLbl.Font     = Enum.Font.Arcade
TutorCheckLbl.Text     = "Don't show again"
TutorCheckLbl.TextSize = 9
TutorCheckLbl.TextXAlignment = Enum.TextXAlignment.Left
TutorCheckLbl.TextColor3     = Color3.fromRGB(150, 150, 150)
TutorCheckLbl.ZIndex         = 64

local function renderTutorStep()
    local step: any = TUTOR_STEPS[TutorialStep]
    if not step then return end
    local gname: string = "Universal"
    pcall(function() gname = gameName end)
    pcall(function()
        if type(gname) ~= "string" or #gname == 0 or gname:find("YOUR_") then
            gname = "Universal"
        end
    end)
    pcall(function()
        TutorTitle.Text = (step.title:gsub("{GAME}", gname))
        TutorDesc.Text  = (step.desc:gsub("{GAME}", gname))
        local _si: string = icon(step.icon or "info")
        if _si == "" then _si = icon("info") end
        TutorStepIcon.Image = _si
    end)
    TutorStepLbl.Text = "STEP " .. TutorialStep .. " OF " .. TUTOR_TOTAL
    TutorBackBtn.Visible = TutorialStep > 1
    TutorNextBtn.Text    = (TutorialStep == TUTOR_TOTAL) and "✓ Done" or "Next >"
    pcall(function() TutorDescScroll.CanvasPosition = Vector2.new(0, 0) end)
    for i: number = 1, TUTOR_TOTAL do
        local dot: Frame? = TutorDots[i]
        if dot then
            dot.BackgroundColor3 = (i == TutorialStep)
                and Color3.fromRGB(0, 255, 150)
                or ((i < TutorialStep) and Color3.fromRGB(0, 150, 200) or Color3.fromRGB(80, 80, 80))
        end
    end
    pcall(function()
        local target: GuiObject? = tourResolveTarget(step.target)
        if step.panel == true then
            if SettingsPanel and not SettingsPanel.Visible then openSettingsPanel() end
            if step.tab then
                local tabName: string = step.tab
                task.spawn(function()
                    task.wait(0.5)
                    pcall(switchTab, tabName)
                end)
                tourPlaceTip(target, 1.0, tostring(step.target))
            else
                tourPlaceTip(target, 0.6, tostring(step.target))
            end
        else
            if SettingsPanel and SettingsPanel.Visible then closeSettingsPanel() end
            tourPlaceTip(target, 0.4, tostring(step.target))
        end
    end)
end

local function tourPersistSkip()
    config.skipTutorial = true
    saveUiPrefs()
    if config.autoSave then saveConfig() end
    pcall(function() tutorialCtrl:Set(false) end)
end

local function closeTutorial()
    if not TutorialOpen then return end
    TutorialOpen = false
    tourPlaceToken += 1
    tourStopFollow()
    pcall(function() TourRing.Visible = false end)
    pcall(function()
        if ConfirmFrame and ConfirmFrame.Visible then return end
        if DeleteConfirmFrame and DeleteConfirmFrame.Visible then return end
        if SettingsPanel and SettingsPanel.Visible then
            setButtonActive(InjectButton, false)
            setButtonActive(CloseButton, false)
            setButtonActive(SettingsIcon, true)
        else
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton, true)
            setButtonActive(SettingsIcon, true)
        end
    end)
    if TutorialDontShow then
        tourPersistSkip()
    end
    pcall(function()
        TweenService:Create(TutorCard, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
        }):Play()
    end)
    task.delay(0.2, function()
        if not TutorialOpen then
            pcall(function()
                TutorDim.Visible  = false
                TutorCard.Visible = false
                TutorCard.Size    = UDim2.new(0, 340, 0, 220)
            end)
        end
    end)
end

local function openTutorial()
    if TutorialOpen then return end
    if not RealZzHub or not RealZzHub.Parent then return end
    TutorialOpen = true
    TutorialStep = 1
    TutorCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    TutorCard.AnchorPoint = Vector2.new(0.5, 0.5)
    pcall(function() TourRing.Visible = false end)
    renderTutorStep()
    TutorDim.Visible  = true
    TutorCard.Visible = true
    TutorCard.Size    = UDim2.new(0, 0, 0, 0)
    TutorCardScale.Scale = 1
    pcall(function()
        TweenService:Create(TutorCard, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 340, 0, 220),
        }):Play()
    end)
end

_openTutorialFn = openTutorial

TutorBackBtn.MouseButton1Click:Connect(function()
    if TutorialStep > 1 then
        TutorialStep -= 1
        renderTutorStep()
    end
end)
TutorNextBtn.MouseButton1Click:Connect(function()
    if TutorialStep < TUTOR_TOTAL then
        TutorialStep += 1
        renderTutorStep()
    else
        TutorialDontShow = true
        TutorCheckTick.Visible = true
        tourPersistSkip()
        closeTutorial()
        pcall(showNotification, "Alwi Hub", "Tour done — enjoy! Reopen it with the ? button.", Color3.fromRGB(0, 255, 150), 4)
    end
end)
TutorSkipBtn.MouseButton1Click:Connect(function() closeTutorial() end)
TutorDim.MouseButton1Click:Connect(function() closeTutorial() end)
TutorCheckBtn.MouseButton1Click:Connect(function()
    TutorialDontShow = not TutorialDontShow
    TutorCheckTick.Visible = TutorialDontShow
    config.skipTutorial = TutorialDontShow
    saveUiPrefs()
    if config.autoSave then saveConfig() end
    pcall(function() tutorialCtrl:Set(not TutorialDontShow) end)
    pcall(function()
        TweenService:Create(TutorCheckBox, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundColor3 = TutorialDontShow and Color3.fromRGB(0, 120, 80) or Color3.fromRGB(35, 35, 42),
        }):Play()
    end)
end)

local HelpBtn: TextButton = Instance.new("TextButton", MainBackground)
HelpBtn.Name                   = "HelpButton"
HelpBtn.AnchorPoint            = Vector2.new(1, 0)
HelpBtn.Position               = UDim2.new(1, -56, 0, 5)
HelpBtn.Size                   = UDim2.new(0, 22, 0, 22)
HelpBtn.BackgroundColor3       = Color3.fromRGB(0, 40, 60)
HelpBtn.BackgroundTransparency = 0.4
HelpBtn.BorderSizePixel        = 0
HelpBtn.Font                   = Enum.Font.Arcade
HelpBtn.Text                   = "?"
HelpBtn.TextSize               = 14
HelpBtn.TextColor3             = Color3.fromRGB(0, 200, 255)
HelpBtn.Visible                = true
HelpBtn.ZIndex                 = 5
Instance.new("UICorner", HelpBtn).CornerRadius = UDim.new(1, 0)
do
    local HelpStroke: UIStroke = Instance.new("UIStroke", HelpBtn)
    HelpStroke.Color       = Color3.fromRGB(0, 200, 255)
    HelpStroke.Thickness   = 1
    HelpStroke.Transparency = 0.5
end
HelpBtn.MouseEnter:Connect(function()
    pcall(function()
        TweenService:Create(HelpBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.1 }):Play()
    end)
end)
HelpBtn.MouseLeave:Connect(function()
    pcall(function()
        TweenService:Create(HelpBtn, TweenInfo.new(0.2), { BackgroundTransparency = 0.4 }):Play()
    end)
end)
HelpBtn.MouseButton1Click:Connect(function() task.spawn(openTutorial) end)

task.spawn(function()
    task.wait(1.5)
    if not RealZzHub or not RealZzHub.Parent then return end
    if config.skipTutorial == true then return end
    if TutorialOpen then return end
    openTutorial()
end)

pcall(function()
    local cam: Camera? = workspace.CurrentCamera
    if cam then
        cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            tourFitScale()
            if TutorialOpen then
                tourPlaceTip(tourLastTarget, 0.05, "resize")
            end
        end)
    end
end)
end
_buildUI()
