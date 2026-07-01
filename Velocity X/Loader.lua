if getgenv().Velocity_X_Loader then
    local a

    pcall(function()
        a = loadstring(game:HttpGet'https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/BocusLuke.lua')()
    end)

    if a then
        pcall(function()
            a:Notify({
                Title = 'Velocity X',
                Description = 'This session is already loaded. Do you want to delete the config file?',
            }, {
                OutlineColor = Color3.fromRGB(255, 80, 80),
                Time = 10,
                Type = 'option',
            }, {
                Callback = function(b)
                    if b then
                        local c, d = 'Velocity X/VelocityX_Settings.json', false

                        if isfile and delfile then
                            pcall(function()
                                if isfile(c) then
                                    delfile(c)

                                    d = true
                                    getgenv().Velocity_X_Loader = false
                                end
                            end)
                        end
                        if d then
                            pcall(function()
                                a:Notify({
                                    Title = 'Config Deleted',
                                    Description = 'Settings file has been removed.',
                                }, {
                                    OutlineColor = Color3.fromRGB(255, 100, 100),
                                    Time = 3,
                                    Type = 'default',
                                }, {
                                    Image = 'rbxassetid://103887859853708',
                                    ImageColor = Color3.fromRGB(255, 255, 255),
                                })
                            end)
                        end
                    else
                        pcall(function()
                            a:Notify({
                                Title = 'Loader Already Running',
                                Description = 'Velocity X is already active in this session.',
                            }, {
                                OutlineColor = Color3.fromRGB(255, 50, 50),
                                Time = 4,
                                Type = 'default',
                            }, {
                                Image = 'rbxassetid://103887859853708',
                                ImageColor = Color3.fromRGB(255, 255, 255),
                            })
                        end)
                    end
                end,
            })
        end)
    else
        warn'Velocity X is already active.'
    end

    return
end

getgenv().Velocity_X_Loader = true

local a = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or nil

local function getThumbnail(b)
    local c, d = pcall(function()
        return game:GetService'Players':GetUserThumbnailAsync(b, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)

    if c and d and #d > 4 then
        warn(string.format('[VelocityX] Thumb URL \u{2192} %s', d))

        return d
    end

    local e = string.format('rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150', b)

    warn(string.format('[VelocityX] Thumb fallback \u{2192} %s', e))

    return e
end

if not cloneref then
    local b, c = (Instance.new'Part')

    for d, e in getreg()do
        if type(e) == 'table' and #e >= 0 then
            if rawget(e, '__mode') == 'kvs' then
                for f, g in e do
                    if g == b then
                        c = e

                        break
                    end
                end
            end
        end
        if c then
            break
        end
    end

    local function _invalidate(d)
        if not c then
            return d
        end

        for e, f in c do
            if f == d then
                (c)[e] = nil

                return d
            end
        end

        return d
    end

    getgenv().cloneref = _invalidate
end

local b = cloneref or function(b)
    return b
end
local c, d, e, f = b(game:GetService'HttpService'), game:GetService'TweenService', game:GetService'RunService', game:GetService'Players'
local g, h = (f.LocalPlayer)

if e:IsStudio() then
    h = g.PlayerGui
else
    h = b(game:GetService'CoreGui')
end

local i = Instance.new'ScreenGui'

i.Name = 'Introvert'
i.Parent = h
i.IgnoreGuiInset = true
i.ResetOnSpawn = false
i.DisplayOrder = 999999

local j = Instance.new'Sound'

j.Parent = i
j.SoundId = 'rbxassetid://8745692251'
j.Volume = 2

local k = false

pcall(function()
    if readfile and isfile then
        local l = 'Velocity X/VelocityX_Settings.json'

        if isfile(l) then
            local m = c:JSONDecode(readfile(l))

            k = m and m.skipIntroUI == true
        end
    end
end)

local function log()
    task.spawn(function()
        loadstring(game:HttpGet'https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/Log.luau')()
    end)
end

task.spawn(function()
    log()
end)

if not k then
    j:Play()

    local l = Instance.new'Frame'

    l.Parent = i
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundColor3 = Color3.new(0, 0, 0)
    l.BorderSizePixel = 0

    local m = Instance.new'ImageLabel'

    m.Parent = i
    m.BackgroundTransparency = 1
    m.Image = 'rbxassetid://103887859853708'
    m.Size = UDim2.new(0, 0, 0, 0)
    m.Position = UDim2.new(0.5, 0, 0.5, 0)
    m.AnchorPoint = Vector2.new(0.5, 0.5)
    m.ImageTransparency = 1
    m.Rotation = -180
    m.ZIndex = 5

    local n = Instance.new'ImageLabel'

    n.Parent = i
    n.BackgroundTransparency = 1
    n.Image = 'rbxassetid://5028857084'
    n.Size = UDim2.new(0, 0, 0, 0)
    n.Position = UDim2.new(0.5, 0, 0.5, 0)
    n.AnchorPoint = Vector2.new(0.5, 0.5)
    n.ImageTransparency = 1
    n.ZIndex = 4

    local o = Instance.new'TextLabel'

    o.Parent = i
    o.BackgroundTransparency = 1
    o.Size = UDim2.new(1, 0, 0.1, 0)
    o.Position = UDim2.new(0, -1E3, 0.37, 0)
    o.Text = 'Velocity X Loader V.1.1'
    o.Font = Enum.Font.Arcade
    o.TextScaled = true
    o.TextTransparency = 1
    o.TextColor3 = Color3.fromRGB(255, 215, 0)
    o.TextStrokeTransparency = 0
    o.TextStrokeColor3 = Color3.fromRGB(120, 80, 0)
    o.ZIndex = 10

    local p = Instance.new'TextLabel'

    p.Parent = i
    p.BackgroundTransparency = 1
    p.Size = UDim2.new(1, 0, 0.05, 0)
    p.Position = UDim2.new(0, 1000, 0.47, 0)
    p.Text = 'UwU Does need furry?'
    p.Font = Enum.Font.Arcade
    p.TextScaled = true
    p.TextColor3 = Color3.fromRGB(255, 255, 255)
    p.TextTransparency = 1
    p.ZIndex = 10

    local q = Instance.new'Frame'

    q.Parent = i
    q.Size = UDim2.new(0.4, 0, 0.015, 0)
    q.Position = UDim2.new(0.3, 0, 0.7, 0)
    q.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    q.BorderSizePixel = 0
    q.Visible = false

    local r = Instance.new'UICorner'

    r.CornerRadius = UDim.new(1, 0)
    r.Parent = q

    local s = Instance.new'Frame'

    s.Parent = q
    s.Size = UDim2.new(0, 0, 1, 0)
    s.BorderSizePixel = 0

    local t = Instance.new'UICorner'

    t.CornerRadius = UDim.new(1, 0)
    t.Parent = s

    local u = Instance.new'UIGradient'

    u.Parent = s

    local v = Instance.new'TextLabel'

    v.Parent = i
    v.BackgroundTransparency = 1
    v.Size = UDim2.new(0.4, 0, 0.03, 0)
    v.Position = UDim2.new(0.3, 0, 0.725, 0)
    v.Font = Enum.Font.Code
    v.TextScaled = true
    v.TextColor3 = Color3.fromRGB(255, 255, 255)
    v.TextStrokeTransparency = 0.4
    v.TextStrokeColor3 = Color3.fromRGB(120, 80, 0)
    v.Text = '0/100'
    v.ZIndex = 20

    local w = Instance.new'UIGradient'

    w.Parent = v

    local x = Instance.new'Frame'

    x.Parent = i
    x.Size = UDim2.new(1, 0, 1, 0)
    x.BackgroundColor3 = Color3.new(1, 1, 1)
    x.BackgroundTransparency = 1
    x.ZIndex = 100

    local y = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 240, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 220, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 0)),
    }

    u.Color = y
    w.Color = y

    task.spawn(function()
        local z = 0

        while i.Parent do
            z = z + 1

            if z % 4 == 0 then
                local A = tick()

                u.Rotation = u.Rotation + 4
                w.Rotation = w.Rotation + 4
                u.Offset = Vector2.new(math.sin(A) * 0.3, 0)
                w.Offset = Vector2.new(math.sin(A) * 0.3, 0)
            end

            task.wait()
        end
    end)
    d:Create(x, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play()
    task.wait(0.15)
    d:Create(x, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    d:Create(m, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 500),
        Rotation = 0,
        ImageTransparency = 0,
    }):Play()
    d:Create(n, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 700, 0, 700),
        ImageTransparency = 0.5,
    }):Play()
    task.wait(0.3)
    d:Create(o, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.37, 0),
        TextTransparency = 0,
    }):Play()
    task.wait(0.2)
    d:Create(p, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.47, 0),
        TextTransparency = 0,
    }):Play()
    task.wait(0.5)

    q.Visible = true

    task.spawn(function()
        for z = 0, 100 do
            v.Text = z .. '/100'
            s.Size = UDim2.new(z / 100, 0, 1, 0)

            task.wait(0.03)
        end

        v.Text = 'Loaded!'

        d:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 2}):Play()
        d:Create(x, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
        task.wait(0.2)
        d:Create(x, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    end)
    task.spawn(function()
        while i.Parent do
            d:Create(m, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = 8,
                Size = UDim2.new(0, 530, 0, 530),
            }):Play()
            d:Create(n, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = -15,
                Size = UDim2.new(0, 760, 0, 760),
            }):Play()
            task.wait(2)
            d:Create(m, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = -8,
                Size = UDim2.new(0, 500, 0, 500),
            }):Play()
            d:Create(n, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = 15,
                Size = UDim2.new(0, 700, 0, 700),
            }):Play()
            task.wait(2)
        end
    end)
    task.wait(4)
    d:Create(x, TweenInfo.new(0.4), {BackgroundTransparency = 0.2}):Play()
    task.wait(0.3)
    d:Create(m, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Rotation = 180,
        ImageTransparency = 1,
    }):Play()
    d:Create(n, TweenInfo.new(1), {
        ImageTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0),
    }):Play()
    d:Create(o, TweenInfo.new(1), {
        Position = UDim2.new(0, -1E3, 0.37, 0),
        TextTransparency = 1,
    }):Play()
    d:Create(p, TweenInfo.new(1), {
        Position = UDim2.new(0, 1000, 0.47, 0),
        TextTransparency = 1,
    }):Play()
    d:Create(q, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    d:Create(s, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    d:Create(v, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1.5)
    i:Destroy()
end
if k then
    pcall(function()
        i:Destroy()
    end)
end

local l
local m, n = pcall(function()
    local m = game:HttpGet'https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/BocusLuke.lua'

    if not m or #m == 0 then
        error'Empty notification library response'
    end

    l = loadstring(m)()
end)

if not m then
    print'[VelocityX] \u{274c} Notification UI failed to load.'
    print('[VelocityX] Reason: ' .. tostring(n))
    print'[VelocityX] Falling back to print-based notifications.'
end

local function showNotification(o, p, q, r, s)
    if l then
        pcall(function()
            l:Notify({
                Title = o,
                Description = p,
            }, {
                OutlineColor = q or Color3.fromRGB(0, 170, 255),
                Time = r or 4,
                Type = 'default',
            }, {
                Image = s or 'rbxassetid://103887859853708',
                ImageColor = Color3.fromRGB(255, 255, 255),
            })
        end)
    else
        print('[VelocityX] \u{1f514} ' .. o .. ' | ' .. p)
    end
end
local function randomString(o)
    local p, q = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789', ''

    for r = 1, o do
        local s = math.random(1, #p)

        q = q .. p:sub(s, s)
    end

    return q
end
local function GetGreetingAndTime()
    local o = os.date'*t'
    local p, q, r, s = o.hour, (o.min)

    if p >= 6 and p < 12 then
        r = 'Good Morning'
        s = '\u{1f305}'
    elseif p >= 12 and p < 15 then
        r = 'Good Noon'
        s = '\u{2600}\u{fe0f}\u{1f55b}'
    elseif p >= 15 and p < 18 then
        r = 'Good Afternoon'
        s = '\u{1f31e}'
    elseif p >= 18 or p < 6 then
        r = 'Good Night'
        s = '\u{1f319}'
    else
        r = 'Hello'
        s = '\u{1f304}'
    end

    local t = p % 12

    if t == 0 then
        t = 12
    end

    local u = p < 12 and 'AM' or 'PM'
    local v = string.format('%02d:%02d %s', t, q, u)

    return r, s, v
end

local o, p = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/', {}

for q = 1, #o do
    p[string.byte(o, q)] = q - 1
end

local function base64_decode(q)
    q = q:gsub('[^A-Za-z0-9+/=]', '')

    local r, s, t = {}, #q, 1

    while t <= s do
        local u, v, w, x = p[string.byte(q, t)] or 0, p[string.byte(q, t + 1)] or 0, p[string.byte(q, t + 2)] or 0, p[string.byte(q, t + 3)] or 0
        local y = (u * 0x40000) + (v * 0x1000) + (w * 0x40) + x

        r[#r + 1] = string.char(math.floor(y / 0x10000) % 256, math.floor(y / 0x100) % 256, y % 256)
        t = t + 4
    end

    local u, v = table.concat(r), 0

    if q:sub(-1) == '=' then
        v = v + 1
    end
    if q:sub(-2, -2) == '=' then
        v = v + 1
    end

    return v > 0 and u:sub(1, #u - v) or u
end

local q = '^[A-Za-z0-9+/]+=?=?$'

local function _isBase64(r)
    return (#r > 0) and (#r % 4 == 0) and (r:match(q) ~= nil)
end
local function decode_obfuscated(r)
    if type(r) == 'table' then
        local s = {}

        for t, u in r do
            local v = tostring(t)
            local w = _isBase64(v) and base64_decode(v) or v

            s[w] = decode_obfuscated(u)
        end

        return s
    elseif type(r) == 'string' then
        local s = r

        return _isBase64(s) and base64_decode(s) or s
    end

    return r
end

local r = Instance.new'ScreenGui'

r.Name = 'Velocity_' .. randomString(10)
r.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(r)

        r.Parent = h
    elseif gethui then
        r.Parent = gethui()
    else
        r.Parent = h
    end
end)

local s = Instance.new('ImageLabel', r)

s.AnchorPoint = Vector2.new(0.5, 0.5)
s.Position = UDim2.new(0.5, 0, 0.5, 0)
s.Size = UDim2.new(0, 1, 0, 1)
s.Image = 'rbxassetid://7877641241'
s.BackgroundColor3 = Color3.new(1, 1, 1)
s.BorderSizePixel = 0
s.ClipsDescendants = false
s.Visible = false
s.ImageTransparency = 1

local t = Instance.new('UIGradient', s)

t.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
}
t.Rotation = 45

local u = Instance.new('UIStroke', s)

u.Color = Color3.fromRGB(0, 100, 150)
u.Thickness = 4.5
u.Transparency = 0.6

local v = Instance.new('UIStroke', s)

v.Thickness = 3.5
v.Transparency = 0.3
v.Color = Color3.fromRGB(0, 255, 120)

do
    local w = Instance.new('UICorner', s)

    w.CornerRadius = UDim.new(0, 8)
end

local w = Instance.new('ImageButton', s)

w.BackgroundTransparency = 1
w.Position = UDim2.new(0, 6, 0, 6)
w.Size = UDim2.new(0, 25, 0, 25)
w.Image = 'rbxassetid://103887859853708'
w.Visible = false

local x = Instance.new('TextLabel', s)

x.BackgroundTransparency = 1
x.Position = UDim2.new(0.11, 0, 0.035, 0)
x.Size = UDim2.new(0.72, 0, 0, 20)
x.Font = Enum.Font.Arcade
x.Text = 'Velocity X Loader'
x.TextSize = 14
x.TextXAlignment = Enum.TextXAlignment.Left
x.TextColor3 = Color3.fromRGB(0, 255, 150)
x.TextStrokeTransparency = 0
x.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
x.Visible = false

local y = Instance.new('TextButton', s)

y.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
y.BackgroundTransparency = 1
y.AnchorPoint = Vector2.new(0.5, 0.5)
y.Position = UDim2.new(0.5, 0, 0.46, 0)
y.Size = UDim2.new(0.82, 0, 0, 48)
y.Font = Enum.Font.Arcade
y.Text = 'Initializing...'
y.TextScaled = true
y.TextColor3 = Color3.new(0, 0, 0)
y.Visible = false
Instance.new('UICorner', y).CornerRadius = UDim.new(0, 4)

do
    local z = Instance.new('UIGradient', y)

    z.Color = t.Color
    z.Rotation = 90

    local A = Instance.new('UIStroke', y)

    A.Color = Color3.fromRGB(0, 255, 150)
    A.Thickness = 1.5
end

local z = Instance.new('TextLabel', s)

z.BackgroundTransparency = 1
z.AnchorPoint = Vector2.new(1, 1)
z.Position = UDim2.new(0.99, 0, 0.985, 0)
z.Size = UDim2.new(0.36, 0, 0, 14)
z.Font = Enum.Font.Arcade
z.Text = 'Loading...'
z.TextSize = 11
z.TextXAlignment = Enum.TextXAlignment.Right
z.TextColor3 = Color3.fromRGB(0, 200, 255)
z.TextStrokeTransparency = 0.4
z.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
z.Visible = false

local A, B = 'https://discord.gg/jc6SAYtVNf', Instance.new('Frame', s)

B.Name = 'GreetingCard'
B.AnchorPoint = Vector2.new(0, 1)
B.Position = UDim2.new(0.01, 0, 0.99, 0)
B.Size = UDim2.new(0.6, 0, 0, 24)
B.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
B.BackgroundTransparency = 0.3
B.BorderSizePixel = 0
B.ClipsDescendants = true
B.Visible = false
Instance.new('UICorner', B).CornerRadius = UDim.new(0, 5)

local C = Instance.new('Frame', B)

C.Size = UDim2.new(0, 2, 1, 0)
C.Position = UDim2.new(0, 0, 0, 0)
C.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
C.BorderSizePixel = 0
Instance.new('UICorner', C).CornerRadius = UDim.new(0, 2)

local D = Instance.new('UIStroke', B)

D.Thickness = 1
D.Transparency = 0.55
D.Color = Color3.fromRGB(0, 200, 255)

local E = Instance.new('ImageLabel', B)

E.AnchorPoint = Vector2.new(0, 0.5)
E.Position = UDim2.new(0, 5, 0.5, 0)
E.Size = UDim2.new(0, 13, 0, 13)
E.BackgroundTransparency = 1
E.Image = 'rbxassetid://94937742565147'
E.ImageTransparency = 1
E.ScaleType = Enum.ScaleType.Fit

local F = Instance.new('TextLabel', B)

F.AnchorPoint = Vector2.new(0, 0.5)
F.Position = UDim2.new(0, 6, 0.5, 0)
F.Size = UDim2.new(1, -8, 1, 0)
F.BackgroundTransparency = 1
F.Font = Enum.Font.Arcade
F.TextScaled = true
F.TextXAlignment = Enum.TextXAlignment.Left
F.TextColor3 = Color3.fromRGB(0, 255, 150)
F.TextStrokeTransparency = 0.5
F.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

do
    local G = Instance.new('UITextSizeConstraint', F)

    G.MinTextSize = 6
    G.MaxTextSize = 11
end

local G = Instance.new('TextLabel', B)

G.AnchorPoint = Vector2.new(0, 1)
G.Position = UDim2.new(0, 22, 1, -1)
G.Size = UDim2.new(1, -24, 0, 9)
G.BackgroundTransparency = 1
G.Font = Enum.Font.Arcade
G.TextScaled = true
G.TextXAlignment = Enum.TextXAlignment.Left
G.TextColor3 = Color3.fromRGB(160, 160, 255)
G.TextTransparency = 1
G.Text = A

do
    local H = Instance.new('UITextSizeConstraint', G)

    H.MinTextSize = 5
    H.MaxTextSize = 8
end

local H = Instance.new('Frame', B)

H.AnchorPoint = Vector2.new(0.5, 0.5)
H.Position = UDim2.new(0.5, 0, 0.5, 0)
H.Size = UDim2.new(0, 0, 0, 0)
H.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
H.BackgroundTransparency = 0.5
H.BorderSizePixel = 0
H.ZIndex = 10
Instance.new('UICorner', H).CornerRadius = UDim.new(1, 0)

local I = Instance.new('TextButton', B)

I.Size = UDim2.new(1, 0, 1, 0)
I.BackgroundTransparency = 1
I.Text = ''
I.ZIndex = 11

local J = Instance.new('UIScale', B)

J.Scale = 0.85

local K = false

local function GetNormalGreetingText()
    local L, M = pcall(function()
        local L, M, N, O = f.LocalPlayer.DisplayName, GetGreetingAndTime()

        return string.format('%s, %s %s %s', M, L, N, O)
    end)

    if L then
        return M
    end

    return 'Hello, ' .. tostring(f.LocalPlayer.DisplayName)
end
local function ApplyGreetingState()
    if K then
        B.Size = UDim2.new(0.6, 0, 0, 34)
        F.Position = UDim2.new(0, 22, 0.3, 0)
        F.Size = UDim2.new(1, -24, 0.45, 0)
        F.Text = 'Need help? Join Discord!'
        F.TextColor3 = Color3.fromRGB(160, 150, 255)
        C.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        D.Color = Color3.fromRGB(88, 101, 242)
        D.Transparency = 0.4
    else
        B.Size = UDim2.new(0.6, 0, 0, 24)
        F.Position = UDim2.new(0, 6, 0.5, 0)
        F.Size = UDim2.new(1, -8, 1, 0)
        F.Text = GetNormalGreetingText()
        F.TextColor3 = Color3.fromRGB(0, 255, 150)
        C.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        D.Color = Color3.fromRGB(0, 200, 255)
        D.Transparency = 0.55
    end
end
local function UpdateGreeting()
    pcall(ApplyGreetingState)
end

pcall(UpdateGreeting)
I.MouseButton1Click:Connect(function()
    if not K then
        return
    end

    pcall(setclipboard, A)

    H.Size = UDim2.new(0, 0, 0, 0)
    H.BackgroundTransparency = 0.55
    H.Position = UDim2.new(0.5, 0, 0.5, 0)

    pcall(function()
        d:Create(H, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(2.5, 0, 6, 0),
            BackgroundTransparency = 1,
        }):Play()
    end)
    pcall(function()
        d:Create(J, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.93}):Play()
    end)
    task.delay(0.12, function()
        pcall(function()
            d:Create(J, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)
    end)
    pcall(function()
        d:Create(E, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Rotation = -18,
        }):Play()
    end)
    task.delay(0.12, function()
        pcall(function()
            d:Create(E, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Rotation = 18}):Play()
        end)
        task.delay(0.16, function()
            pcall(function()
                d:Create(E, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
            end)
        end)
    end)

    F.Text = 'Copied! \u{2713}'
    F.TextColor3 = Color3.fromRGB(100, 255, 160)

    task.delay(1.2, function()
        pcall(function()
            if K then
                d:Create(F, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
                task.wait(0.32)

                F.Text = 'Need help? Join our Discord!'
                F.TextColor3 = Color3.fromRGB(170, 160, 255)

                d:Create(F, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
            end
        end)
    end)
end)

local L = Instance.new('TextButton', s)

L.BackgroundTransparency = 1
L.Position = UDim2.new(0.928, 0, 0, -2)
L.Rotation = 45
L.Size = UDim2.new(0, 25, 0, 25)
L.Font = Enum.Font.Arcade
L.Text = '+'
L.TextSize = 29
L.Visible = false

local M = Instance.new('ImageButton', s)

M.BackgroundTransparency = 1
M.Position = UDim2.new(0.85, 0, 0.01, 0)
M.Size = UDim2.new(0, 22, 0, 22)
M.Image = 'rbxassetid://101339235267993'
M.Visible = false
M.ImageTransparency = 0.2

local N = Instance.new('UIScale', M)

N.Scale = 1

local O = Instance.new('ImageLabel', s)

O.AnchorPoint = Vector2.new(0.5, 0.5)
O.Position = UDim2.new(0.5, 0, 0.5, 0)
O.Size = UDim2.new(0, 200, 0, 100)
O.Image = 'rbxassetid://7877641241'
O.BackgroundColor3 = Color3.new(1, 1, 1)
O.BorderSizePixel = 0
O.Visible = false
O.ZIndex = 3

local P = Instance.new('UIGradient', O)

P.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
}
P.Rotation = 45

local Q = Instance.new('UIStroke', O)

Q.Color = Color3.fromRGB(0, 200, 255)
Q.Thickness = 2
Q.Transparency = 0.3
Instance.new('UICorner', O).CornerRadius = UDim.new(0, 8)

do
    local R = Instance.new('TextLabel', O)

    R.BackgroundTransparency = 1
    R.Position = UDim2.new(0, 0, 0.2, 0)
    R.Size = UDim2.new(1, 0, 0.3, 0)
    R.Font = Enum.Font.Arcade
    R.Text = 'Are you sure you want\nto close Velocity X?'
    R.TextSize = 12
    R.TextColor3 = Color3.fromRGB(0, 255, 150)
    R.TextStrokeTransparency = 0
    R.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

local R = Instance.new('TextButton', O)

R.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
R.BackgroundTransparency = 1
R.Position = UDim2.new(0.15, 0, 0.65, 0)
R.Size = UDim2.new(0, 70, 0, 30)
R.Font = Enum.Font.Arcade
R.Text = 'Yes'
R.TextScaled = true
R.TextColor3 = Color3.new(0, 0, 0)
Instance.new('UICorner', R).CornerRadius = UDim.new(0, 4)

do
    local S = Instance.new('UIGradient', R)

    S.Color = P.Color
    S.Rotation = 90
end

local S = Instance.new('UIStroke', R)

S.Color = Color3.fromRGB(0, 255, 150)
S.Thickness = 1.5

local T = Instance.new('TextButton', O)

T.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
T.BackgroundTransparency = 1
T.Position = UDim2.new(0.55, 0, 0.65, 0)
T.Size = UDim2.new(0, 70, 0, 30)
T.Font = Enum.Font.Arcade
T.Text = 'No'
T.TextScaled = true
T.TextColor3 = Color3.new(0, 0, 0)
Instance.new('UICorner', T).CornerRadius = UDim.new(0, 4)

do
    local U = Instance.new('UIGradient', T)

    U.Color = P.Color
    U.Rotation = 90
end

local U = Instance.new('UIStroke', T)

U.Color = Color3.fromRGB(0, 255, 150)
U.Thickness = 1.5

local V = Instance.new('ImageLabel', s)

V.Name = 'DeleteConfirmFrame'
V.AnchorPoint = Vector2.new(0.5, 0.5)
V.Position = UDim2.new(0.5, 0, 0.5, 0)
V.Size = UDim2.new(0, 200, 0, 100)
V.Image = 'rbxassetid://7877641241'
V.BackgroundColor3 = Color3.new(1, 1, 1)
V.BorderSizePixel = 0
V.Visible = false
V.ZIndex = 3

do
    local W = Instance.new('UIGradient', V)

    W.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50)),
    }
    W.Rotation = 45

    local X = Instance.new('UIStroke', V)

    X.Color = Color3.fromRGB(255, 100, 100)
    X.Thickness = 2
    X.Transparency = 0.3
    Instance.new('UICorner', V).CornerRadius = UDim.new(0, 8)

    local Y = Instance.new('TextLabel', V)

    Y.BackgroundTransparency = 1
    Y.Position = UDim2.new(0, 0, 0.2, 0)
    Y.Size = UDim2.new(1, 0, 0.3, 0)
    Y.Font = Enum.Font.Arcade
    Y.Text = 'Delete config file?'
    Y.TextSize = 12
    Y.TextColor3 = Color3.fromRGB(255, 255, 255)
    Y.TextStrokeTransparency = 0
    Y.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

local W = Instance.new('TextButton', V)

W.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
W.BackgroundTransparency = 1
W.Position = UDim2.new(0.15, 0, 0.65, 0)
W.Size = UDim2.new(0, 70, 0, 30)
W.Font = Enum.Font.Arcade
W.Text = 'Yes'
W.TextScaled = true
W.TextColor3 = Color3.new(0, 0, 0)
Instance.new('UICorner', W).CornerRadius = UDim.new(0, 4)

do
    local X = Instance.new('UIGradient', W)

    X.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50)),
    }
    X.Rotation = 90
end

local X = Instance.new('UIStroke', W)

X.Color = Color3.fromRGB(255, 100, 100)
X.Thickness = 1.5

local Y = Instance.new('TextButton', V)

Y.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Y.BackgroundTransparency = 1
Y.Position = UDim2.new(0.55, 0, 0.65, 0)
Y.Size = UDim2.new(0, 70, 0, 30)
Y.Font = Enum.Font.Arcade
Y.Text = 'No'
Y.TextScaled = true
Y.TextColor3 = Color3.new(0, 0, 0)
Instance.new('UICorner', Y).CornerRadius = UDim.new(0, 4)

do
    local Z = Instance.new('UIGradient', Y)

    Z.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50)),
    }
    Z.Rotation = 90
end

local Z = Instance.new('UIStroke', Y)

Z.Color = Color3.fromRGB(255, 100, 100)
Z.Thickness = 1.5

local _, aa, ab = 222, 245, Instance.new('ImageLabel', s)

ab.AnchorPoint = Vector2.new(1, 0)
ab.Position = UDim2.new(0.85, 0, 0.09, 0)
ab.Size = UDim2.new(0, _, 0, aa)
ab.Image = 'rbxassetid://7877641241'
ab.BackgroundColor3 = Color3.new(1, 1, 1)
ab.BorderSizePixel = 0
ab.ClipsDescendants = true
ab.Visible = false
ab.ZIndex = 2

do
    local ac = Instance.new('UIGradient', ab)

    ac.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
    }
    ac.Rotation = 45

    local ad = Instance.new('UIStroke', ab)

    ad.Color = Color3.fromRGB(0, 200, 255)
    ad.Thickness = 2
    ad.Transparency = 0.3

    local ae = Instance.new('UICorner', ab)

    ae.CornerRadius = UDim.new(0, 8)
end

local ac = Instance.new('ImageLabel', ab)

ac.BackgroundTransparency = 1
ac.Size = UDim2.new(1, 0, 1, 0)
ac.ScaleType = Enum.ScaleType.Crop
ac.ImageTransparency = 0.4
ac.ZIndex = 1
ac.Image = 'rbxthumb://type=GameIcon&id=' .. tostring(game.GameId) .. '&w=150&h=150'

task.spawn(function()
    local ad
    local ae = pcall(function()
        game:GetService'ContentProvider':PreloadAsync({ac}, function(ae, af)
            ad = af
        end)
    end)

    if not ae or ad ~= Enum.AssetFetchStatus.Success then
        ac.Visible = false
    end
end)

local ad = Instance.new('Frame', ab)

ad.Size = UDim2.new(1, 0, 0, 28)
ad.Position = UDim2.new(0, 0, 0, 0)
ad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ad.BackgroundTransparency = 0.6
ad.BorderSizePixel = 0
ad.ZIndex = 4
ad.ClipsDescendants = false

do
    local ae = Instance.new('UICorner', ad)

    ae.CornerRadius = UDim.new(0, 8)

    local af = Instance.new('Frame', ad)

    af.Size = UDim2.new(1, 0, 0, 1)
    af.AnchorPoint = Vector2.new(0, 1)
    af.Position = UDim2.new(0, 0, 1, 0)
    af.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    af.BackgroundTransparency = 0.55
    af.BorderSizePixel = 0
    af.ZIndex = 5
end

local ae = Instance.new('Frame', ad)

ae.AnchorPoint = Vector2.new(0, 1)
ae.Size = UDim2.new(0, 60, 0, 2)
ae.Position = UDim2.new(0, 5, 1, 0)
ae.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
ae.BorderSizePixel = 0
ae.ZIndex = 6

do
    local af = Instance.new('UIGradient', ae)

    af.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255)),
    }
end

Instance.new('UICorner', ae).CornerRadius = UDim.new(1, 0)

local af = 5

local function makeTabButton(ag, ah, ai, aj)
    local ak = Instance.new('TextButton', ad)

    ak.BackgroundTransparency = 1
    ak.Position = UDim2.new(0, ah, 0, af)
    ak.Size = UDim2.new(0, ai, 0, 18)
    ak.Font = Enum.Font.Arcade
    ak.TextSize = 9
    ak.TextColor3 = Color3.fromRGB(160, 160, 160)
    ak.TextXAlignment = Enum.TextXAlignment.Center
    ak.ZIndex = 6
    ak.Text = ag

    return ak
end

local ag, ah, ai, aj, ak = makeTabButton('\u{2699} Settings', 4, 66), makeTabButton('\u{2139} Information', 73, 82), makeTabButton('\u{2605} Credit', 158, 60), 28, Instance.new('ScrollingFrame', ab)

ak.Name = 'SettingsContent'
ak.Position = UDim2.new(0, 0, 0, aj)
ak.Size = UDim2.new(1, 0, 1, -aj - 4)
ak.BackgroundTransparency = 1
ak.BorderSizePixel = 0
ak.ClipsDescendants = true
ak.ScrollBarThickness = 5
ak.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
ak.CanvasSize = UDim2.new(0, 0, 0, 0)
ak.ZIndex = 3
ak.Visible = true

local al = Instance.new('UIListLayout', ak)

al.Padding = UDim.new(0, 8)
al.HorizontalAlignment = Enum.HorizontalAlignment.Center

local am = Instance.new('ScrollingFrame', ab)

am.Name = 'InfoContent'
am.Position = UDim2.new(0, 0, 0, aj)
am.Size = UDim2.new(1, 0, 1, -aj - 4)
am.BackgroundTransparency = 1
am.BorderSizePixel = 0
am.ClipsDescendants = true
am.ScrollBarThickness = 5
am.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
am.CanvasSize = UDim2.new(0, 0, 0, 0)
am.ZIndex = 3
am.Visible = false
am.ScrollingDirection = Enum.ScrollingDirection.Y
am.AutomaticCanvasSize = Enum.AutomaticSize.Y

do
    local an = Instance.new('UIListLayout', am)

    an.Padding = UDim.new(0, 2)
    an.HorizontalAlignment = Enum.HorizontalAlignment.Center
    an.VerticalAlignment = Enum.VerticalAlignment.Top
    an.SortOrder = Enum.SortOrder.LayoutOrder

    local ao = Instance.new('UIPadding', am)

    ao.PaddingTop = UDim.new(0, 5)
    ao.PaddingLeft = UDim.new(0, 6)
    ao.PaddingRight = UDim.new(0, 8)
    ao.PaddingBottom = UDim.new(0, 5)
end

local an = 0

local function addInfoRow(ao, ap, aq, ar)
    an = an + 1

    local as = Instance.new('Frame', am)

    as.Size = UDim2.new(1, -6, 0, 17)
    as.BackgroundTransparency = 1
    as.BorderSizePixel = 0
    as.ZIndex = 4
    as.LayoutOrder = an

    local at = Instance.new('TextLabel', as)

    at.BackgroundTransparency = 1
    at.Position = UDim2.new(0, 0, 0, 0)
    at.Size = UDim2.new(0.46, 0, 1, 0)
    at.Font = Enum.Font.Arcade
    at.TextSize = 8
    at.TextXAlignment = Enum.TextXAlignment.Left
    at.TextColor3 = Color3.fromRGB(140, 140, 140)
    at.ZIndex = 4
    at.Text = ao .. ' ' .. ap

    local au = Instance.new('TextLabel', as)

    au.BackgroundTransparency = 1
    au.Position = UDim2.new(0.46, 0, 0, 0)
    au.Size = UDim2.new(0.54, 0, 1, 0)
    au.Font = Enum.Font.Arcade
    au.TextSize = 8
    au.TextXAlignment = Enum.TextXAlignment.Right
    au.TextTruncate = Enum.TextTruncate.AtEnd
    au.TextColor3 = ar or Color3.fromRGB(0, 220, 180)
    au.ZIndex = 4
    au.Text = aq

    return au
end
local function addInfoDivider(ao)
    local ap = Instance.new('Frame', am)

    ap.Size = UDim2.new(1, -10, 0, 1)
    ap.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    ap.BackgroundTransparency = 0.65
    ap.BorderSizePixel = 0
    ap.ZIndex = 4
    ap.LayoutOrder = ao
    an = ao
end
local function addInfoHeader(ao)
    an = an + 1

    local ap = Instance.new('TextLabel', am)

    ap.Size = UDim2.new(1, -6, 0, 16)
    ap.BackgroundTransparency = 1
    ap.Font = Enum.Font.Arcade
    ap.TextSize = 9
    ap.TextXAlignment = Enum.TextXAlignment.Left
    ap.TextColor3 = Color3.fromRGB(0, 255, 150)
    ap.ZIndex = 4
    ap.LayoutOrder = an
    ap.Text = ao

    return ap
end
local function addCopyRow(ao, ap, aq, ar)
    an = an + 1

    local as = Instance.new('Frame', am)

    as.Size = UDim2.new(1, -6, 0, 17)
    as.BackgroundTransparency = 1
    as.BorderSizePixel = 0
    as.ZIndex = 4
    as.LayoutOrder = an

    local at = Instance.new('TextLabel', as)

    at.BackgroundTransparency = 1
    at.Position = UDim2.new(0, 0, 0, 0)
    at.Size = UDim2.new(0.45, 0, 1, 0)
    at.Font = Enum.Font.Arcade
    at.TextSize = 8
    at.TextXAlignment = Enum.TextXAlignment.Left
    at.TextColor3 = Color3.fromRGB(140, 140, 140)
    at.ZIndex = 4
    at.Text = ao .. ' ' .. ap

    local au = Instance.new('TextButton', as)

    au.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    au.BackgroundTransparency = 0.75
    au.BorderSizePixel = 0
    au.AnchorPoint = Vector2.new(1, 0.5)
    au.Position = UDim2.new(1, 0, 0.5, 0)
    au.Size = UDim2.new(0.52, 0, 0, 13)
    au.Font = Enum.Font.Arcade
    au.TextSize = 7
    au.TextColor3 = ar or Color3.fromRGB(0, 230, 200)
    au.ZIndex = 5
    au.TextTruncate = Enum.TextTruncate.AtEnd
    Instance.new('UICorner', au).CornerRadius = UDim.new(0, 3)

    local av = #aq > 16 and aq:sub(1, 13) .. '\u{2026}' or aq

    au.Text = av

    au.MouseButton1Click:Connect(function()
        pcall(setclipboard, aq)

        au.Text = '\u{2713} Copied!'

        task.delay(1.5, function()
            pcall(function()
                au.Text = av
            end)
        end)
    end)
end
local function addActionCopyRow(ao, ap, aq, ar)
    an = an + 1

    local as = Instance.new('Frame', am)

    as.Size = UDim2.new(1, -6, 0, 17)
    as.BackgroundTransparency = 1
    as.BorderSizePixel = 0
    as.ZIndex = 4
    as.LayoutOrder = an

    local at = Instance.new('TextLabel', as)

    at.BackgroundTransparency = 1
    at.Position = UDim2.new(0, 0, 0, 0)
    at.Size = UDim2.new(0.42, 0, 1, 0)
    at.Font = Enum.Font.Arcade
    at.TextSize = 8
    at.TextXAlignment = Enum.TextXAlignment.Left
    at.TextColor3 = Color3.fromRGB(140, 140, 140)
    at.ZIndex = 4
    at.Text = ao .. ' ' .. ap

    local au = Instance.new('TextButton', as)

    au.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    au.BackgroundTransparency = 0.7
    au.BorderSizePixel = 0
    au.AnchorPoint = Vector2.new(1, 0.5)
    au.Position = UDim2.new(1, 0, 0.5, 0)
    au.Size = UDim2.new(0.55, 0, 0, 13)
    au.Font = Enum.Font.Arcade
    au.TextSize = 7
    au.TextColor3 = ar or Color3.fromRGB(0, 230, 200)
    au.ZIndex = 5
    au.Text = '\u{1f4cb} Copy'
    Instance.new('UICorner', au).CornerRadius = UDim.new(0, 3)

    au.MouseButton1Click:Connect(function()
        local av = aq()

        pcall(setclipboard, av)

        au.Text = '\u{2713} Copied!'

        task.delay(1.5, function()
            pcall(function()
                au.Text = '\u{1f4cb} Copy'
            end)
        end)
    end)
end
local function safeStr(ao, ap)
    local aq, ar = pcall(ao)

    return (aq and ar ~= nil) and tostring(ar) or (ap or 'N/A')
end
local function checkPremium()
    local ao, ap = pcall(function()
        return f.LocalPlayer.MembershipType
    end)

    if ao then
        return ap == Enum.MembershipType.None and '\u{2717} None' or '\u{2713} Premium'
    end

    return 'N/A'
end

local ao, ap, aq, ar, as, at, au, av, aw, ax = safeStr(function()
    local ao = game:GetService'UserInputService':GetPlatform()

    return ao == Enum.Platform.Windows and '\u{1f4bb} PC' or ao == Enum.Platform.OSX and '\u{1f34e} Mac' or ao == Enum.Platform.Android and '\u{1f4f1} Android' or ao == Enum.Platform.IOS and '\u{1f4f1} iOS' or '\u{2753} Unknown'
end, '\u{2753} Unknown'), safeStr(function()
    return identifyexecutor()
end, 'Unknown'), safeStr(function()
    return os.date'%Y-%m-%d %H:%M:%S'
end, 'N/A'), safeStr(function()
    return game:GetService'MarketplaceService':GetProductInfo(game.PlaceId).Name
end, 'Unknown Game'), tostring(game.PlaceId), tostring(game.JobId), safeStr(function()
    return f.LocalPlayer.Name
end, '?'), safeStr(function()
    return tostring(f.LocalPlayer.UserId)
end, '?'), checkPremium(), safeStr(function()
    return game:GetService'RbxAnalyticsService':GetClientId()
end, 'N/A')
local ay = "game:GetService('TeleportService'):TeleportToPlaceInstance(" .. as .. ", '" .. at .. "', game.Players.LocalPlayer)"

addInfoHeader'\u{1f4ca} Session Information'
addInfoDivider(an + 1)

local az = addInfoRow('\u{1f550}', 'Time', aq, Color3.fromRGB(200, 200, 100))

addInfoRow(ao:sub(1, 2), 'Device', ao:sub(4), Color3.fromRGB(150, 210, 255))
addInfoRow('\u{2699}', 'Executor', ap, Color3.fromRGB(180, 180, 255))

local aA = addInfoRow('\u{1f451}', 'Premium', aw, Color3.fromRGB(255, 215, 0))

addInfoDivider(an + 1)
addInfoHeader'\u{1f4c8} Performance'
addInfoDivider(an + 1)

local aB, aC = addInfoRow('\u{26a1}', 'FPS', '\u{2014}', Color3.fromRGB(80, 255, 120)), addInfoRow('\u{1f4e1}', 'Ping', '\u{2014} ms', Color3.fromRGB(80, 200, 255))

addInfoDivider(an + 1)
addInfoHeader'\u{1f3ae} Game'
addInfoDivider(an + 1)
addInfoRow('\u{1f4db}', 'Name', ar, Color3.fromRGB(0, 220, 180))
addInfoRow('\u{1f194}', 'Place ID', as, Color3.fromRGB(200, 200, 200))
addCopyRow('\u{1f517}', 'Job ID', at, Color3.fromRGB(100, 200, 255))
addInfoDivider(an + 1)
addInfoHeader'\u{1f464} Player'
addInfoDivider(an + 1)
addInfoRow('\u{1f4db}', 'Name', au, Color3.fromRGB(0, 220, 180))
addInfoRow('\u{1f194}', 'User ID', av, Color3.fromRGB(200, 200, 200))
addCopyRow('\u{1f511}', 'HWID', ax, Color3.fromRGB(255, 150, 100))
addInfoDivider(an + 1)
addInfoHeader'\u{1f4cd} Position  (live)'
addInfoDivider(an + 1)

local aD, aE, aF = addInfoRow('\u{27a1}', 'X', '\u{2014}', Color3.fromRGB(255, 100, 100)), addInfoRow('\u{2b06}', 'Y', '\u{2014}', Color3.fromRGB(100, 255, 100)), addInfoRow('\u{1f535}', 'Z', '\u{2014}', Color3.fromRGB(100, 150, 255))

local function _tweenCopyFn()
    local aG, aH = pcall(function()
        return f.LocalPlayer.Character.HumanoidRootPart.CFrame
    end)

    if not aG then
        return ''
    end

    local aI, aJ, aK = math.floor(aH.X), math.floor(aH.Y), math.floor(aH.Z)

    return string.format("local tweenInfo = TweenInfo.new(2)\nlocal goal = {CFrame = CFrame.new(%d, %d, %d)}\nlocal tween = game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, goal)\ntween:Play()", aI, aJ, aK)
end

addActionCopyRow('\u{1f3ac}', 'Copy Tween', _tweenCopyFn, Color3.fromRGB(100, 200, 255))

local function _cfCopyFn()
    local aG, aH = pcall(function()
        return f.LocalPlayer.Character.HumanoidRootPart.CFrame
    end)

    if not aG then
        return ''
    end

    local aI = string.format('%d, %d, %d', math.floor(aH.X + 0.5), math.floor(aH.Y + 0.5), math.floor(aH.Z + 0.5))

    return string.format('game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(%s)))', aI)
end

addActionCopyRow('\u{1f4cc}', 'Copy CFrame', _cfCopyFn, Color3.fromRGB(0, 255, 150))
addInfoDivider(an + 1)
addInfoHeader'\u{1f4cb} Teleport Statement'
addInfoDivider(an + 1)
addCopyRow('\u{1f680}', 'Copy cmd', ay, Color3.fromRGB(0, 255, 150))

local aG, aH, aI, aJ = 1291925, Color3.fromRGB(0, 255, 110), Color3.fromRGB(255, 200, 0), Color3.fromRGB(120, 120, 130)

local function getPresence(aK)
    if not a then
        return 0, nil, nil
    end

    local aL, aM, aN = 0
    local aO = pcall(function()
        local function fetch(aO)
            return a{
                Url = 'https://presence.roblox.com/v1/presence/users',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    ['X-CSRF-TOKEN'] = aO,
                },
                Body = c:JSONEncode{
                    userIds = {aK},
                },
            }
        end

        local aO = fetch(nil)

        if type(aO) == 'table' then
            local aP = aO.StatusCode or aO.statusCode

            if aP == 403 then
                local aQ = aO.Headers or aO.headers
                local aR = (type(aQ) == 'table') and (aQ['x-csrf-token'] or aQ['X-CSRF-TOKEN']) or nil

                if aR then
                    aO = fetch(aR)
                end
            end
        end
        if type(aO) ~= 'table' then
            return
        end

        local aP = aO.Body or aO.body

        if type(aP) ~= 'string' or #aP == 0 then
            return
        end

        local aQ = c:JSONDecode(aP)

        if type(aQ) ~= 'table' or type(aQ.userPresences) ~= 'table' then
            return
        end

        local aR = aQ.userPresences[1]

        if type(aR) ~= 'table' then
            return
        end
        if type(aR.userPresenceType) == 'number' then
            aL = aR.userPresenceType
        end
        if type(aR.lastLocation) == 'string' then
            aM = aR.lastLocation
        end
        if type(aR.universeId) == 'number' then
            aN = aR.universeId
        end
    end)

    if not aO then
        return 0, nil, nil
    end

    return aL, aM, aN
end
local function resolveGameName(aK)
    if not a or type(aK) ~= 'number' or aK == 0 then
        return nil
    end

    local aL

    pcall(function()
        local aM = a{
            Url = 'https://games.roblox.com/v1/games?universeIds=' .. tostring(aK),
            Method = 'GET',
        }

        if type(aM) ~= 'table' then
            return
        end

        local aN = aM.Body or aM.body

        if type(aN) ~= 'string' or #aN == 0 then
            return
        end

        local aO = c:JSONDecode(aN)

        if type(aO) ~= 'table' or type(aO.data) ~= 'table' then
            return
        end

        local aP = aO.data[1]

        if type(aP) ~= 'table' or type(aP.name) ~= 'string' then
            return
        end

        aL = aP.name
    end)

    return aL
end

local aK = Instance.new('ScrollingFrame', ab)

aK.Name = 'CreditContent'
aK.Position = UDim2.new(0, 0, 0, aj)
aK.Size = UDim2.new(1, 0, 1, -aj - 4)
aK.BackgroundTransparency = 1
aK.BorderSizePixel = 0
aK.ClipsDescendants = true
aK.ScrollBarThickness = 4
aK.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
aK.ScrollingDirection = Enum.ScrollingDirection.Y
aK.AutomaticCanvasSize = Enum.AutomaticSize.Y
aK.CanvasSize = UDim2.new(0, 0, 0, 0)
aK.ZIndex = 3
aK.Visible = false

do
    local aL = Instance.new('UIListLayout', aK)

    aL.Padding = UDim.new(0, 6)
    aL.HorizontalAlignment = Enum.HorizontalAlignment.Center
    aL.VerticalAlignment = Enum.VerticalAlignment.Top
    aL.SortOrder = Enum.SortOrder.LayoutOrder

    local aM = Instance.new('UIPadding', aK)

    aM.PaddingTop = UDim.new(0, 6)
    aM.PaddingLeft = UDim.new(0, 6)
    aM.PaddingRight = UDim.new(0, 6)
    aM.PaddingBottom = UDim.new(0, 8)
end

local aL = Instance.new('Frame', aK)

aL.LayoutOrder = 1
aL.Size = UDim2.new(1, 0, 0, 78)
aL.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
aL.BackgroundTransparency = 0.3
aL.BorderSizePixel = 0
aL.ZIndex = 4
Instance.new('UICorner', aL).CornerRadius = UDim.new(0, 6)

do
    local aM = Instance.new('UIStroke', aL)

    aM.Color = Color3.fromRGB(0, 200, 255)
    aM.Thickness = 1
    aM.Transparency = 0.5
end

local aM = Instance.new('ImageLabel', aL)

aM.AnchorPoint = Vector2.new(0, 0.5)
aM.Position = UDim2.new(0, 6, 0.5, 0)
aM.Size = UDim2.new(0, 50, 0, 50)
aM.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
aM.BorderSizePixel = 0
aM.Image = ''
aM.ImageTransparency = 1
aM.ZIndex = 5
Instance.new('UICorner', aM).CornerRadius = UDim.new(1, 0)

do
    local aN = Instance.new('UIStroke', aM)

    aN.Color = Color3.fromRGB(0, 255, 150)
    aN.Thickness = 1.5
    aN.Transparency = 0.2
end

local aN = Instance.new('Frame', aM)

aN.AnchorPoint = Vector2.new(1, 1)
aN.Position = UDim2.new(1, 3, 1, 3)
aN.Size = UDim2.new(0, 18, 0, 18)
aN.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
aN.BorderSizePixel = 0
aN.ZIndex = 6
Instance.new('UICorner', aN).CornerRadius = UDim.new(1, 0)

local aO = Instance.new('Frame', aN)

aO.AnchorPoint = Vector2.new(0.5, 0.5)
aO.Position = UDim2.new(0.5, 0, 0.5, 0)
aO.Size = UDim2.new(0, 12, 0, 12)
aO.BackgroundColor3 = aJ
aO.BorderSizePixel = 0
aO.ZIndex = 7
Instance.new('UICorner', aO).CornerRadius = UDim.new(1, 0)

local aP = Instance.new('TextLabel', aM)

aP.Size = UDim2.new(1, 0, 1, 0)
aP.BackgroundTransparency = 1
aP.Font = Enum.Font.GothamBold
aP.Text = '...'
aP.TextSize = 10
aP.TextColor3 = Color3.fromRGB(0, 200, 255)
aP.ZIndex = 6

local aQ = Instance.new('TextLabel', aL)

aQ.AnchorPoint = Vector2.new(0, 0)
aQ.Position = UDim2.new(0, 62, 0, 6)
aQ.Size = UDim2.new(1, -68, 0, 16)
aQ.BackgroundTransparency = 1
aQ.Font = Enum.Font.Arcade
aQ.Text = 'zachparsons1 (alwi)'
aQ.TextSize = 13
aQ.TextXAlignment = Enum.TextXAlignment.Left
aQ.TextColor3 = Color3.fromRGB(0, 255, 150)
aQ.TextStrokeTransparency = 0.3
aQ.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
aQ.ZIndex = 5

local aR = Instance.new('TextLabel', aL)

aR.AnchorPoint = Vector2.new(0, 0)
aR.Position = UDim2.new(0, 62, 0, 22)
aR.Size = UDim2.new(1, -68, 0, 12)
aR.BackgroundTransparency = 1
aR.Font = Enum.Font.Arcade
aR.Text = 'Creator of Velocity X'
aR.TextSize = 8
aR.TextXAlignment = Enum.TextXAlignment.Left
aR.TextColor3 = Color3.fromRGB(180, 180, 255)
aR.ZIndex = 5

local aS = Instance.new('TextLabel', aL)

aS.AnchorPoint = Vector2.new(0, 0)
aS.Position = UDim2.new(0, 62, 0, 34)
aS.Size = UDim2.new(1, -68, 0, 14)
aS.BackgroundTransparency = 1
aS.Font = Enum.Font.Arcade
aS.Text = 'Offline'
aS.TextSize = 8
aS.TextXAlignment = Enum.TextXAlignment.Left
aS.TextColor3 = aJ
aS.ZIndex = 5

local aT = Instance.new('TextButton', aL)

aT.AnchorPoint = Vector2.new(0, 0)
aT.Position = UDim2.new(0, 62, 0, 50)
aT.Size = UDim2.new(1, -68, 0, 18)
aT.BackgroundColor3 = Color3.fromRGB(226, 35, 26)
aT.BackgroundTransparency = 0.15
aT.BorderSizePixel = 0
aT.Font = Enum.Font.Arcade
aT.Text = 'Roblox Profile'
aT.TextSize = 8
aT.TextColor3 = Color3.fromRGB(255, 255, 255)
aT.ZIndex = 5
Instance.new('UICorner', aT).CornerRadius = UDim.new(0, 4)

do
    local aU = Instance.new('UIStroke', aT)

    aU.Color = Color3.fromRGB(255, 80, 80)
    aU.Thickness = 1
    aU.Transparency = 0.4
end

local aU = Instance.new('UIScale', aT)

aU.Scale = 1
EffectClick2 = function(aV, aW)
    local aX = game.Players.LocalPlayer:GetMouse()
    local aY, aZ = aX.X - aV.AbsolutePosition.X, aX.Y - aV.AbsolutePosition.Y

    if aY < 0 or aZ < 0 or aY > aV.AbsoluteSize.X or aZ > aV.AbsoluteSize.Y then
        return
    end

    local a_ = Instance.new'Frame'

    a_.Parent = aW
    a_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    a_.BackgroundTransparency = 0.5
    a_.BorderSizePixel = 0
    a_.AnchorPoint = Vector2.new(0.5, 0.5)
    a_.Position = UDim2.new(0, aY, 0, aZ)
    a_.Size = UDim2.new(0, 0, 0, 0)
    a_.ZIndex = 10

    local a0 = Instance.new'UIGradient'

    a0.Parent = a_
    a0.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 127)),
        ColorSequenceKeypoint.new(0.482699, Color3.fromRGB(0, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 85, 255)),
    }
    a0.Rotation = 48

    local a1 = Instance.new'UICorner'

    a1.CornerRadius = UDim.new(1, 0)
    a1.Parent = a_

    local a2, a3 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, aV.AbsoluteSize.X * 1.5, 0, aV.AbsoluteSize.X * 1.5),
        BackgroundTransparency = 1,
    }
    local a4 = d:Create(a_, a2, a3)

    a4.Completed:Connect(function()
        a_:Destroy()
    end)
    a4:Play()
end

aT.MouseButton1Click:Connect(function()
    pcall(setclipboard, 'https://www.roblox.com/users/1291925/profile')
    task.spawn(function()
        pcall(function()
            d:Create(aU, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.88}):Play()
            task.wait(0.09)
            d:Create(aU, TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)
    end)

    aT.Text = '\u{2713} Copied!'

    task.delay(2, function()
        pcall(function()
            aT.Text = 'Roblox Profile'
        end)
    end)
end)

local aV = Instance.new('Frame', aK)

aV.LayoutOrder = 2
aV.Size = UDim2.new(1, 0, 0, 70)
aV.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
aV.BackgroundTransparency = 0.3
aV.BorderSizePixel = 0
aV.ZIndex = 4
aV.ClipsDescendants = true
Instance.new('UICorner', aV).CornerRadius = UDim.new(0, 6)

do
    local aW = Instance.new('UIStroke', aV)

    aW.Color = Color3.fromRGB(0, 200, 255)
    aW.Thickness = 1
    aW.Transparency = 0.5

    local aX = Instance.new('TextLabel', aV)

    aX.Position = UDim2.new(0, 6, 0, 4)
    aX.Size = UDim2.new(1, -8, 0, 12)
    aX.BackgroundTransparency = 1
    aX.Font = Enum.Font.Arcade
    aX.Text = 'About'
    aX.TextSize = 9
    aX.TextXAlignment = Enum.TextXAlignment.Left
    aX.TextColor3 = Color3.fromRGB(0, 200, 255)
    aX.ZIndex = 5

    local aY = Instance.new('Frame', aV)

    aY.Position = UDim2.new(0, 4, 0, 17)
    aY.Size = UDim2.new(1, -8, 0, 1)
    aY.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    aY.BackgroundTransparency = 0.6
    aY.BorderSizePixel = 0
    aY.ZIndex = 5

    local aZ = Instance.new('TextLabel', aV)

    aZ.Position = UDim2.new(0, 6, 0, 20)
    aZ.Size = UDim2.new(1, -8, 1, -24)
    aZ.BackgroundTransparency = 1
    aZ.Font = Enum.Font.Arcade
    aZ.Text = 'Hey is me Alwi, creator of Velocity X!\nI like furry \u{1f98a} (fox / kenomo) & fabulous beast\n"you shou yan" :3\nEnjoy the script! \u{2764}'
    aZ.TextSize = 8
    aZ.TextXAlignment = Enum.TextXAlignment.Left
    aZ.TextYAlignment = Enum.TextYAlignment.Top
    aZ.TextWrapped = true
    aZ.TextColor3 = Color3.fromRGB(210, 210, 210)
    aZ.ZIndex = 5

    local a_ = Instance.new('TextLabel', aV)

    a_.AnchorPoint = Vector2.new(1, 1)
    a_.Position = UDim2.new(1, -4, 1, -4)
    a_.Size = UDim2.new(0, 24, 0, 24)
    a_.BackgroundTransparency = 1
    a_.Font = Enum.Font.GothamBold
    a_.Text = '\u{1f43e}'
    a_.TextSize = 14
    a_.TextTransparency = 0.3
    a_.ZIndex = 5
end
do
    local aW = Instance.new('Frame', aK)

    aW.LayoutOrder = 3
    aW.Size = UDim2.new(1, 0, 0, 40)
    aW.BackgroundTransparency = 1
    aW.BorderSizePixel = 0
    aW.ZIndex = 4

    local function makeTagsRow(aX, aY)
        local aZ = Instance.new('Frame', aX)

        aZ.Position = UDim2.new(0, 0, 0, aY)
        aZ.Size = UDim2.new(1, 0, 0, 16)
        aZ.BackgroundTransparency = 1
        aZ.BorderSizePixel = 0
        aZ.ZIndex = 4

        local a_ = Instance.new('UIListLayout', aZ)

        a_.FillDirection = Enum.FillDirection.Horizontal
        a_.HorizontalAlignment = Enum.HorizontalAlignment.Left
        a_.VerticalAlignment = Enum.VerticalAlignment.Center
        a_.Padding = UDim.new(0, 4)

        return aZ
    end

    local aX, aY, aZ = makeTagsRow(aW, 0), makeTagsRow(aW, 22), game:GetService'TextService'

    local function addTag(a_, a0, a1)
        local a2 = Instance.new('TextLabel', a_)

        a2.BackgroundColor3 = a1
        a2.BackgroundTransparency = 0.5
        a2.BorderSizePixel = 0
        a2.Font = Enum.Font.Arcade
        a2.Text = a0
        a2.TextSize = 7
        a2.TextColor3 = Color3.fromRGB(255, 255, 255)
        a2.ZIndex = 5
        Instance.new('UICorner', a2).CornerRadius = UDim.new(1, 0)

        local a3 = aZ:GetTextSize(a0, 7, Enum.Font.Arcade, Vector2.new(200, 20))

        a2.Size = UDim2.new(0, a3.X + 10, 0, 14)
    end

    addTag(aX, 'fox', Color3.fromRGB(255, 115, 15))
    addTag(aX, 'kenomo', Color3.fromRGB(110, 70, 210))
    addTag(aX, 'furry', Color3.fromRGB(190, 55, 115))
    addTag(aX, 'like fabulous beast', Color3.fromRGB(0, 150, 220))
    addTag(aY, 'Lua 3yr', Color3.fromRGB(30, 160, 100))
    addTag(aY, 'Introvert', Color3.fromRGB(60, 90, 180))
    addTag(aY, 'Ragebait', Color3.fromRGB(200, 50, 50))
end

game:GetService'UserInputService'

do
    local aX = Instance.new('Frame', aK)

    aX.LayoutOrder = 4
    aX.Size = UDim2.new(1, 0, 0, 1)
    aX.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    aX.BackgroundTransparency = 0.6
    aX.BorderSizePixel = 0
    aX.ZIndex = 4

    local aY = Instance.new('TextLabel', aK)

    aY.LayoutOrder = 5
    aY.Size = UDim2.new(1, 0, 0, 14)
    aY.BackgroundTransparency = 1
    aY.Font = Enum.Font.Arcade
    aY.Text = '\u{1f310} Social'
    aY.TextSize = 8
    aY.TextXAlignment = Enum.TextXAlignment.Left
    aY.TextColor3 = Color3.fromRGB(0, 200, 255)
    aY.ZIndex = 4
end

local aX = Instance.new('ScrollingFrame', aK)

aX.LayoutOrder = 6
aX.Size = UDim2.new(1, 0, 0, 80)
aX.BackgroundTransparency = 1
aX.BorderSizePixel = 0
aX.ZIndex = 4
aX.ScrollBarThickness = 3
aX.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
aX.ScrollingDirection = Enum.ScrollingDirection.X
aX.AutomaticCanvasSize = Enum.AutomaticSize.X
aX.CanvasSize = UDim2.new(0, 0, 0, 0)

do
    local aY = Instance.new('UIListLayout', aX)

    aY.FillDirection = Enum.FillDirection.Horizontal
    aY.HorizontalAlignment = Enum.HorizontalAlignment.Left
    aY.VerticalAlignment = Enum.VerticalAlignment.Center
    aY.Padding = UDim.new(0, 10)

    local aZ = Instance.new('UIPadding', aX)

    aZ.PaddingLeft = UDim.new(0, 4)
    aZ.PaddingRight = UDim.new(0, 4)
    aZ.PaddingTop = UDim.new(0, 4)
    aZ.PaddingBottom = UDim.new(0, 4)
end

local function makeSocialBtn(aY, aZ, a_, a0, a1, a2)
    local a3 = Instance.new('Frame', aX)

    a3.BackgroundTransparency = 1
    a3.BorderSizePixel = 0
    a3.Size = UDim2.new(0, 58, 1, 0)
    a3.ZIndex = 4

    local a4 = Instance.new('UIScale', a3)

    a4.Scale = 1

    local a5 = Instance.new('ImageButton', a3)

    a5.AnchorPoint = Vector2.new(0.5, 0)
    a5.Position = UDim2.new(0.5, 0, 0, 4)
    a5.Size = UDim2.new(0, 40, 0, 40)
    a5.BackgroundColor3 = a1
    a5.BackgroundTransparency = 0.25
    a5.BorderSizePixel = 0
    a5.ZIndex = 5
    a5.Image = ''
    a5.ClipsDescendants = true
    Instance.new('UICorner', a5).CornerRadius = UDim.new(1, 0)

    local a6 = Instance.new('UIGradient', a5)

    a6.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, a1),
        ColorSequenceKeypoint.new(1, a2),
    }
    a6.Rotation = 135

    local a7 = Instance.new('UIStroke', a5)

    a7.Color = a1
    a7.Thickness = 1.5
    a7.Transparency = 0.35

    if aY then
        local a8 = Instance.new('ImageLabel', a5)

        a8.AnchorPoint = Vector2.new(0.5, 0.5)
        a8.Position = UDim2.new(0.5, 0, 0.5, 0)
        a8.Size = UDim2.new(0.65, 0, 0.65, 0)
        a8.BackgroundTransparency = 1
        a8.Image = 'rbxassetid://' .. aY
        a8.ZIndex = 6
    else
        local a8 = Instance.new('TextLabel', a5)

        a8.AnchorPoint = Vector2.new(0.5, 0.5)
        a8.Position = UDim2.new(0.5, 0, 0.5, 0)
        a8.Size = UDim2.new(1, 0, 1, 0)
        a8.BackgroundTransparency = 1
        a8.Font = Enum.Font.GothamBold
        a8.Text = aZ or '?'
        a8.TextSize = 18
        a8.TextColor3 = Color3.fromRGB(255, 255, 255)
        a8.ZIndex = 6
    end

    local a8 = Instance.new('TextLabel', a3)

    a8.AnchorPoint = Vector2.new(0.5, 0)
    a8.Position = UDim2.new(0.5, 0, 0, 46)
    a8.Size = UDim2.new(1, 4, 0, 12)
    a8.BackgroundTransparency = 1
    a8.Font = Enum.Font.Arcade
    a8.Text = a_
    a8.TextSize = 7
    a8.TextXAlignment = Enum.TextXAlignment.Center
    a8.TextColor3 = Color3.fromRGB(175, 175, 175)
    a8.ZIndex = 4

    a5.MouseEnter:Connect(function()
        pcall(function()
            d:Create(a4, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.14}):Play()
            d:Create(a5, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.08,
                Position = UDim2.new(0.5, 0, 0, 0),
            }):Play()
            d:Create(a7, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 0,
                Thickness = 2.2,
            }):Play()
            d:Create(a8, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(230, 230, 230),
            }):Play()
        end)
    end)
    a5.MouseLeave:Connect(function()
        pcall(function()
            d:Create(a4, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 1}):Play()
            d:Create(a5, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 0.25,
                Position = UDim2.new(0.5, 0, 0, 4),
            }):Play()
            d:Create(a7, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Transparency = 0.35,
                Thickness = 1.5,
            }):Play()

            if a8.Text ~= '\u{2713} Copied!' then
                d:Create(a8, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    TextColor3 = Color3.fromRGB(175, 175, 175),
                }):Play()
            end
        end)
    end)
    a5.MouseButton1Click:Connect(function()
        pcall(setclipboard, a0)
        task.spawn(function()
            pcall(function()
                d:Create(a4, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.8}):Play()
                task.wait(0.09)
                d:Create(a4, TweenInfo.new(0.52, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end)
        end)
        task.spawn(function()
            pcall(function()
                local a9 = a5:FindFirstChildOfClass'ImageLabel' or a5:FindFirstChildOfClass'TextLabel'

                if a9 then
                    d:Create(a9, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Rotation = -22,
                    }):Play()
                    task.wait(0.11)
                    d:Create(a9, TweenInfo.new(0.13, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Rotation = 15}):Play()
                    task.wait(0.14)
                    d:Create(a9, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                end
            end)
        end)
        pcall(function()
            d:Create(a7, TweenInfo.new(0.06), {
                Transparency = 0,
                Thickness = 2.8,
            }):Play()
            task.delay(0.28, function()
                pcall(function()
                    d:Create(a7, TweenInfo.new(0.28), {
                        Transparency = 0.35,
                        Thickness = 1.5,
                    }):Play()
                end)
            end)
        end)
        task.spawn(function()
            pcall(function()
                local a9 = Instance.new('TextLabel', a3)

                a9.AnchorPoint = Vector2.new(0.5, 1)
                a9.Position = UDim2.new(0.5, 0, 0.02, 0)
                a9.Size = UDim2.new(0.9, 0, 0, 20)
                a9.BackgroundTransparency = 1
                a9.Font = Enum.Font.GothamBold
                a9.Text = '\u{2713}'
                a9.TextSize = 14
                a9.TextColor3 = Color3.fromRGB(0, 255, 150)
                a9.TextStrokeTransparency = 0.35
                a9.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                a9.ZIndex = 12

                d:Create(a9, TweenInfo.new(0.72, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, -0.4, 0),
                    TextTransparency = 1,
                }):Play()
                task.wait(0.74)
                pcall(function()
                    a9:Destroy()
                end)
            end)
        end)

        a8.Text = '\u{2713} Copied!'
        a8.TextColor3 = Color3.fromRGB(0, 255, 150)

        task.delay(2, function()
            pcall(function()
                a8.Text = a_
                a8.TextColor3 = Color3.fromRGB(175, 175, 175)
            end)
        end)
    end)
end

makeSocialBtn('94937742565147', nil, 'Discord', 'https://discord.com/users/1136652082091409468', Color3.fromRGB(88, 101, 242), Color3.fromRGB(58, 30, 180))
makeSocialBtn('140193697070787', nil, 'YouTube', 'https://youtube.com/@IkuraJust', Color3.fromRGB(255, 30, 30), Color3.fromRGB(180, 0, 60))
makeSocialBtn('99316223126384', nil, 'Roblox', 'https://www.roblox.com/users/1291925/profile', Color3.fromRGB(226, 35, 26), Color3.fromRGB(180, 60, 20))
makeSocialBtn('117782741969829', nil, 'GitHub', 'https://github.com/mainery-foxxie', Color3.fromRGB(30, 30, 30), Color3.fromRGB(80, 80, 80))

local aY, aZ, a_, a0 = Color3.fromRGB(0, 255, 150), Color3.fromRGB(140, 140, 140), {
    settings = {
        xPos = 4,
        width = 66,
        btn = ag,
    },
    info = {
        xPos = 73,
        width = 82,
        btn = ah,
    },
    credit = {
        xPos = 158,
        width = 60,
        btn = ai,
    },
}, 'settings'

local function switchTab(a1)
    if a1 == a0 then
        return
    end

    a0 = a1
    ak.Visible = (a1 == 'settings')
    am.Visible = (a1 == 'info')
    aK.Visible = (a1 == 'credit')

    for a2, a3 in a_ do
        a3.btn.TextColor3 = (a2 == a1) and aY or aZ
    end

    local a2 = a_[a1]

    pcall(function()
        d:Create(ae, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, a2.xPos, 1, 0),
            Size = UDim2.new(0, a2.width, 0, 2),
        }):Play()
    end)
end
local function resetToSettingsTab()
    a0 = 'settings'
    ak.Visible = true
    am.Visible = false
    aK.Visible = false
    ag.TextColor3 = aY
    ah.TextColor3 = aZ
    ai.TextColor3 = aZ
    ae.Position = UDim2.new(0, 4, 1, 0)
    ae.Size = UDim2.new(0, 66, 0, 2)
end

ag.MouseButton1Click:Connect(function()
    switchTab'settings'
end)
ah.MouseButton1Click:Connect(function()
    switchTab'info'
end)
ai.MouseButton1Click:Connect(function()
    switchTab'credit'
end)

ag.TextColor3 = aY

task.spawn(function()
    local a1 = getThumbnail(aG)

    aM.Image = a1

    task.wait()
    pcall(function()
        aP.Text = ''
        aP.Visible = false

        d:Create(aM, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
    end)
end)

local function applyCreatorStatus(a1, a2)
    if a1 == 2 then
        aO.BackgroundColor3 = aH
        aS.TextColor3 = aH
        aS.Text = 'Playing ' .. ((a2 and #a2 > 0) and a2 or 'a game')
    elseif a1 == 1 or a1 == 3 then
        aO.BackgroundColor3 = aI
        aS.TextColor3 = aI
        aS.Text = (a1 == 3) and 'In Roblox Studio' or 'Online'
    else
        aO.BackgroundColor3 = aJ
        aS.TextColor3 = aJ
        aS.Text = 'Offline'
    end
end

task.spawn(function()
    while r and r.Parent do
        local a1, a2, a3 = getPresence(aG)

        if a1 == 2 and (not a2 or #a2 == 0) then
            a2 = resolveGameName(a3)
        end

        pcall(applyCreatorStatus, a1, a2)
        task.wait(20)
    end
end)
task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            local a1 = f.LocalPlayer.Character
            local a2 = a1 and a1:FindFirstChild'HumanoidRootPart'

            if a2 then
                local a3 = a2.CFrame.Position

                aD.Text = string.format('%d', math.floor(a3.X))
                aE.Text = string.format('%d', math.floor(a3.Y))
                aF.Text = string.format('%d', math.floor(a3.Z))
            else
                aD.Text = '\u{2014}'
                aE.Text = '\u{2014}'
                aF.Text = '\u{2014}'
            end
        end)
    end
end)
task.spawn(function()
    local a1, a2, a3, a4 = game:GetService'RunService', game:GetService'Stats', 0, tick()

    a1.Heartbeat:Connect(function()
        a3 = a3 + 1
    end)

    while task.wait(1) do
        pcall(function()
            local a5 = tick()
            local a6 = math.floor(a3 / (a5 - a4))

            a3 = 0
            a4 = a5
            aB.Text = string.format('%d fps', a6)
        end)
        pcall(function()
            local a5 = math.floor(a2.Network.ServerStatsItem['Data Ping']:GetValue())

            aC.Text = string.format('%d ms', a5)
        end)
        pcall(function()
            az.Text = string.format('%s', os.date'%H:%M:%S')
        end)
    end
end)
task.spawn(function()
    while task.wait(15) do
        local a1, a2 = pcall(function()
            return f.LocalPlayer.MembershipType
        end)
        local a3 = a1 and a2 ~= Enum.MembershipType.None

        pcall(function()
            aA.Text = string.format('%s', a3 and '\u{2713} Premium' or '\u{2717} None')
            aA.TextColor3 = a3 and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(170, 170, 170)
        end)
    end
end)

local function addToggle(a1, a2, a3, a4)
    local a5 = Instance.new('Frame', a1)

    a5.Size = UDim2.new(0, 180, 0, 25)
    a5.BackgroundTransparency = 1
    a5.ZIndex = 2

    local a6 = Instance.new('TextLabel', a5)

    a6.BackgroundTransparency = 1
    a6.Position = UDim2.new(0, 0, 0, 0)
    a6.Size = UDim2.new(0, 130, 1, 0)
    a6.Font = Enum.Font.Arcade
    a6.Text = a2
    a6.TextColor3 = Color3.fromRGB(255, 255, 255)
    a6.TextSize = 10
    a6.TextXAlignment = Enum.TextXAlignment.Left
    a6.ZIndex = 2

    local a7 = Instance.new('Frame', a5)

    a7.Name = 'Check'
    a7.AnchorPoint = Vector2.new(1, 0.5)
    a7.Position = UDim2.new(1, -5, 0.5, 0)
    a7.Size = UDim2.new(0, 20, 0, 20)
    a7.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    a7.BorderSizePixel = 0
    a7.ZIndex = 2

    local a8 = Instance.new('Frame', a7)

    a8.AnchorPoint = Vector2.new(0.5, 0.5)
    a8.Position = UDim2.new(0.5, 0, 0.5, 0)
    a8.Size = UDim2.new(1, 0, 1, 0)
    a8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    a8.BackgroundTransparency = 1
    a8.ZIndex = 2

    local a9 = Instance.new('UICorner', a8)

    a9.CornerRadius = UDim.new(1, 0)

    local ba = Instance.new('UIGradient', a8)

    ba.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
    }
    ba.Rotation = 48

    local bb = Instance.new('UICorner', a7)

    bb.CornerRadius = UDim.new(1, 0)

    local function updateUI(bc)
        pcall(function()
            if bc then
                d:Create(a8, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0.8, 0, 0.8, 0),
                    BackgroundTransparency = 0,
                }):Play()
                d:Create(a7, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                }):Play()
            else
                d:Create(a8, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                }):Play()
                d:Create(a7, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(42, 42, 42),
                }):Play()
            end
        end)
    end

    local bc = Instance.new('TextButton', a5)

    bc.Name = 'Click'
    bc.BackgroundTransparency = 1
    bc.Size = UDim2.new(1, 0, 1, 0)
    bc.Text = ''
    bc.ZIndex = 3

    local bd = a3

    updateUI(bd)
    bc.MouseButton1Click:Connect(function()
        bd = not bd

        updateUI(bd)

        if a4 then
            pcall(a4, bd)
        end
    end)

    return {
        Frame = a5,
        Get = function()
            return bd
        end,
        Set = function(be)
            if be ~= bd then
                bd = be

                updateUI(bd)

                if a4 then
                    pcall(a4, bd)
                end
            end
        end,
    }
end

local a1 = 'Velocity X'
local a2, a3 = a1 .. '/VelocityX_Settings.json', 'v1.1'

if makefolder then
    local a4 = pcall(function()
        if not isfolder(a1) then
            makefolder(a1)
        end
    end)

    if not a4 then
        warn"[VelocityX] Could not create config folder \u{2014} settings won't be saved this session."
    end
end

local a4 = {
    autoSave = false,
    autoInject = false,
    autoExecutorLoader = false,
    antiAfk = false,
    antiFling = false,
    antiGameplayPause = false,
    skipIntroUI = false,
}

local function loadConfig()
    if not (readfile and isfile) then
        return
    end

    local a5, a6 = pcall(function()
        if not isfile(a2) then
            return
        end

        local a5 = readfile(a2)
        local a6 = c:JSONDecode(a5)

        if type(a6) ~= 'table' then
            error'Config root is not a table \u{2014} file is corrupted.'
        end

        a4.autoSave = a6.autoSave == true
        a4.autoInject = a6.autoInject == true
        a4.autoExecutorLoader = a6.autoExecutorLoader == true
        a4.antiAfk = a6.antiAfk == true
        a4.antiFling = a6.antiFling == true
        a4.antiGameplayPause = a6.antiGameplayPause == true
        a4.skipIntroUI = a6.skipIntroUI == true
    end)

    if not a5 then
        warn('[VelocityX] Config corrupted (' .. tostring(a6) .. ') \u{2014} resetting to defaults.')
        pcall(function()
            if isfile(a2) then
                delfile(a2)
            end
        end)
        pcall(function()
            if isfolder and isfolder(a1) then
                pcall(delfolder, a1)
            end
            if makefolder then
                makefolder(a1)
            end
        end)
    end
end
local function saveConfig()
    if not (writefile and a4.autoSave) then
        return
    end

    pcall(function()
        if makefolder and isfolder and not isfolder(a1) then
            makefolder(a1)
        end

        local a5 = c:JSONEncode{
            _version = a3,
            autoSave = a4.autoSave,
            autoInject = a4.autoInject,
            autoExecutorLoader = a4.autoExecutorLoader,
            antiAfk = a4.antiAfk,
            antiFling = a4.antiFling,
            antiGameplayPause = a4.antiGameplayPause,
            skipIntroUI = a4.skipIntroUI,
        }

        writefile(a2, a5)
    end)
end
local function setupAutoExecutorLoader()
    local a5 = queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

    if a5 then
        task.spawn(function()
            pcall(function()
                a5"loadstring(game:HttpGet('https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Loader.lua'))()"
            end)
        end)
    else
        showNotification('Executor Not Supported', 'queue_on_teleport is not available.', Color3.fromRGB(255, 50, 50), 5)
    end
end
local function clearTeleportQueue()
    if clearteleportqueue then
        pcall(clearteleportqueue)
    end
    if clear_teleport_queue then
        pcall(clear_teleport_queue)
    end
    if clearqueueonteleport then
        pcall(clearqueueonteleport)
    end
    if queue_on_teleport then
        pcall(queue_on_teleport, nil)
    end
    if fluxus and fluxus.queue_on_teleport then
        pcall(fluxus.queue_on_teleport, nil)
    end
    if syn and syn.queue_on_teleport then
        pcall(syn.queue_on_teleport, nil)
    end
    if setclipboard then
        pcall(function()
            setclipboard''
        end)
    end

    showNotification('Velocity X', 'Auto Executor cleared', Color3.fromRGB(255, 200, 0), 2)
end
local function setButtonActive(a5, a6)
    if not a5 or not a5.Parent then
        return
    end

    a5.Active = a6

    if a5:IsA'TextButton' then
        (a5).TextTransparency = a6 and 0 or 0.5
    elseif a5:IsA'ImageButton' then
        (a5).ImageTransparency = a6 and 0.2 or 0.6
    end
end

local a6, a7, a8, a9, ba, bb, a5 = 'Universal', false, 'https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/Universal/Main.lua', 'https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/', 'https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/SupportedGames.json', (string.char(104, 116, 116, 112, 115, 58, 47, 47, 112, 97, 115, 116, 101, 102, 121, 46, 97, 112, 112, 47, 76, 90, 79, 85, 112, 49, 105, 82, 47, 114, 97, 119))

local function fetch(bc)
    local bd, be = pcall(function()
        return game:HttpGet(bc)
    end)

    return (bd and be) or nil
end

local bc = tostring(game.GameId)

do
    local bf, bg, bh, bd, be = false, false, (tostring(math.floor(tick())))

    local function tryGithub()
        local bi = pcall(function()
            local bi = fetch(ba .. '?t=' .. bh)

            if not bi or #(bi) == 0 then
                error'Empty'
            end

            local bj = c:JSONDecode(bi)

            if bj and bj[bc] then
                bd = {
                    url = a9 .. bj[bc].Path,
                    name = bj[bc].Name,
                }
            end
        end)

        if not bi then
            warn'[VelocityX] GitHub game list failed'
        end

        bf = true
    end
    local function tryPastebin()
        local bi = pcall(function()
            local bi = fetch(bb .. '?t=' .. bh)

            if not bi or #(bi) == 0 then
                error'Empty'
            end

            local bj = c:JSONDecode(bi)
            local bk = decode_obfuscated(bj)

            if bk and bk[bc] then
                local bl, bm = bk[bc].Path, bk[bc].randomstring or ''

                be = {
                    url = bl .. bm,
                    name = bk[bc].Name,
                }
            end
        end)

        if not bi then
            warn'[VelocityX] Pastefy game list failed'
        end

        bg = true
    end

    task.spawn(tryGithub)
    task.spawn(tryPastebin)

    local bi = tick() + 8

    while(not bf or not bg) and tick() < bi do
        task.wait(0.05)
    end

    if bd then
        a5 = bd.url
        a6 = bd.name
    elseif be then
        a5 = be.url
        a6 = be.name
    end
end

if not a5 then
    a5 = a8
    a6 = 'Universal'

    showNotification('Using Universal Script', 'No game-specific script found.', Color3.fromRGB(0, 170, 255), 3)
else
    showNotification('Game Supported', 'Loaded: ' .. a6, Color3.fromRGB(0, 255, 120), 3)
end

y.Text = a6 .. '.lua'

task.spawn(function()
    local bd = pcall(function()
        local bd = game:HttpGet'https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/version.json'

        if not bd or #bd == 0 then
            error'Empty version response'
        end

        z.Text = 'Version: ' .. bd
    end)

    if not bd then
        z.Text = 'Version: ?'

        warn'[VelocityX] Version fetch failed'
    end
end)

local function clearText()
    for bd, be in s:GetDescendants()do
        if be:IsA'TextLabel' or be:IsA'TextButton' then
            (be).Text = ''
        end
    end
end
local function cleanupAntiFeatures() end

local bd = Instance.new('Frame', s)

bd.Name = 'ErrorPanel'
bd.AnchorPoint = Vector2.new(0, 1)
bd.Position = UDim2.new(0, 0, 1.05, 0)
bd.Size = UDim2.new(1, 0, 0, 60)
bd.BackgroundColor3 = Color3.fromRGB(20, 8, 8)
bd.BackgroundTransparency = 0.1
bd.BorderSizePixel = 0
bd.ClipsDescendants = true
bd.ZIndex = 5
bd.Visible = false
Instance.new('UICorner', bd).CornerRadius = UDim.new(0, 8)

do
    local be = Instance.new('UIStroke', bd)

    be.Color = Color3.fromRGB(255, 60, 60)
    be.Thickness = 1.5
    be.Transparency = 0.3

    local bf = Instance.new('Frame', bd)

    bf.Size = UDim2.new(1, 0, 0, 2)
    bf.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    bf.BorderSizePixel = 0

    local bg = Instance.new('UIGradient', bf)

    bg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 160, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 80)),
    }

    local bh = Instance.new('TextLabel', bd)

    bh.AnchorPoint = Vector2.new(0, 0.5)
    bh.Position = UDim2.new(0, 8, 0.38, 0)
    bh.Size = UDim2.new(0, 18, 0, 18)
    bh.BackgroundTransparency = 1
    bh.Font = Enum.Font.GothamBold
    bh.Text = '\u{26a0}'
    bh.TextScaled = true
    bh.TextColor3 = Color3.fromRGB(255, 140, 40)
    bh.ZIndex = 6
end

local be = Instance.new('TextLabel', bd)

be.AnchorPoint = Vector2.new(0, 0)
be.Position = UDim2.new(0, 30, 0, 6)
be.Size = UDim2.new(0.7, 0, 0, 16)
be.BackgroundTransparency = 1
be.Font = Enum.Font.Arcade
be.Text = 'Network Error'
be.TextSize = 12
be.TextXAlignment = Enum.TextXAlignment.Left
be.TextColor3 = Color3.fromRGB(255, 100, 100)
be.TextStrokeTransparency = 0.4
be.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
be.ZIndex = 6

local bf = Instance.new('TextLabel', bd)

bf.AnchorPoint = Vector2.new(0, 0)
bf.Position = UDim2.new(0, 30, 0, 23)
bf.Size = UDim2.new(0.68, 0, 0, 22)
bf.BackgroundTransparency = 1
bf.Font = Enum.Font.Arcade
bf.Text = 'Failed to fetch script.'
bf.TextSize = 9
bf.TextWrapped = true
bf.TextXAlignment = Enum.TextXAlignment.Left
bf.TextYAlignment = Enum.TextYAlignment.Top
bf.TextColor3 = Color3.fromRGB(220, 180, 180)
bf.ZIndex = 6

local bg = Instance.new('TextButton', bd)

bg.AnchorPoint = Vector2.new(1, 0.5)
bg.Position = UDim2.new(0.98, 0, 0.55, 0)
bg.Size = UDim2.new(0, 54, 0, 22)
bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.Font = Enum.Font.Arcade
bg.Text = 'Retry'
bg.TextSize = 11
bg.TextColor3 = Color3.fromRGB(255, 255, 255)
bg.ZIndex = 7
Instance.new('UICorner', bg).CornerRadius = UDim.new(0, 4)

do
    local bh = Instance.new('UIGradient', bg)

    bh.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 40, 40)),
    }
    bh.Rotation = 90
end

local bh = Instance.new('UIStroke', bg)

bh.Color = Color3.fromRGB(255, 80, 80)
bh.Thickness = 1

local bi = Instance.new('TextButton', bd)

bi.AnchorPoint = Vector2.new(1, 0)
bi.Position = UDim2.new(1, -2, 0, 2)
bi.Size = UDim2.new(0, 14, 0, 14)
bi.BackgroundTransparency = 1
bi.BorderSizePixel = 0
bi.Font = Enum.Font.GothamBold
bi.Text = '\u{d7}'
bi.TextSize = 13
bi.TextColor3 = Color3.fromRGB(180, 100, 100)
bi.ZIndex = 8

local bj = false

local function showErrorPanel(bk, bl, bm)
    if not bd or not bd.Parent then
        return
    end

    be.Text = bk
    bf.Text = bl
    bj = true
    bd.Visible = true
    bd.Position = UDim2.new(0, 0, 1.05, 0)

    d:Create(bd, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.62, 0),
    }):Play()

    local bn

    bn = bg.MouseButton1Click:Connect(function()
        bn:Disconnect()
        pcall(function()
            d:Create(bd, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 0, 1.05, 0),
            }):Play()
        end)
        task.wait(0.22)

        bd.Visible = false
        bj = false

        if bm then
            task.spawn(bm)
        end
    end)
end
local function hideErrorPanel()
    if not bj then
        return
    end

    bj = false

    pcall(function()
        d:Create(bd, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 0, 1.05, 0),
        }):Play()
    end)
    task.delay(0.22, function()
        if not bj and bd then
            bd.Visible = false
        end
    end)
end

bi.MouseButton1Click:Connect(function()
    hideErrorPanel()
end)

local function shakeError()
    pcall(function()
        local bk, bl = s.Position, TweenInfo.new(0.07, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 4, true)

        d:Create(s, bl, {
            Position = UDim2.new(bk.X.Scale, bk.X.Offset + 8, bk.Y.Scale, bk.Y.Offset),
        }):Play()
        task.wait(0.6)
        d:Create(s, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = bk}):Play()
    end)
end

local bk, bl = 3, 2

local function tryFetchAndRun(bm)
    local bn, bo = pcall(function()
        local bn = game:HttpGet(bm)

        if not bn or #bn == 0 then
            error'Empty response from URL'
        end

        local bo, bp = pcall(loadstring(bn))

        if not bo then
            error('Script runtime error: ' .. tostring(bp))
        end
    end)

    return bn, tostring(bo)
end
local function injectScript()
    if a7 then
        return
    end

    a7 = true

    setButtonActive(y, false)

    local bm, bn, bo, bp = a5, a6, '', false

    for bq = 1, bk do
        y.Text = string.format('Attempt %d/%d...', bq, bk)

        local br, bs = tryFetchAndRun(bm)

        if br then
            bp = true

            break
        end

        bo = bs

        warn(string.format('[VelocityX] %s attempt %d/%d failed: %s', bn, bq, bk, bs))

        if bq < bk then
            showNotification(string.format('\u{26a0} Attempt %d/%d Failed', bq, bk), 'Retrying in ' .. bl .. 's...', Color3.fromRGB(255, 150, 0), bl)
            task.wait(bl)
        end
    end

    if bp then
        setButtonActive(y, true)

        return
    end
    if bm ~= a8 then
        showNotification('\u{26a0} Game Script Failed', 'All 3 attempts failed \u{2014} switching to Universal script...', Color3.fromRGB(255, 150, 0), 3)
        task.spawn(shakeError)

        a5 = a8
        a6 = 'Universal'

        local bq = false

        for br = 1, bk do
            y.Text = string.format('Universal %d/%d...', br, bk)

            local bs, bt = tryFetchAndRun(a8)

            if bs then
                bq = true

                break
            end

            bo = bt

            warn(string.format('[VelocityX] Universal attempt %d/%d failed: %s', br, bk, bt))

            if br < bk then
                showNotification(string.format('\u{26a0} Universal %d/%d Failed', br, bk), 'Retrying in ' .. bl .. 's...', Color3.fromRGB(255, 150, 0), bl)
                task.wait(bl)
            end
        end

        if bq then
            setButtonActive(y, true)

            return
        end
    end

    a7 = false
    y.Text = a6 .. '.lua'

    setButtonActive(y, true)
    task.spawn(shakeError)
    showErrorPanel('\u{2718} All 3 Attempts Failed', 'Check your connection or the URL\nmay have been deleted.', function()
        task.spawn(injectScript)
    end)
    showNotification('\u{2718} All Attempts Failed (3/3)', 'Check your connection \u{2014} the URL may have been deleted.', Color3.fromRGB(255, 50, 50), 8)
end
local function performAutoInject()
    if a7 then
        return
    end

    injectScript()

    if not a7 then
        return
    end

    y.Text = 'Injecting...'

    d:Create(s, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        ImageTransparency = 1,
    }):Play()
    clearText()
    task.wait(0.35)
    cleanupAntiFeatures()

    if r then
        r:Destroy()
    end
end

s.Visible = true
s.Size = UDim2.new(0, 0, 0, 0)

d:Create(s, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 318, 0, 162),
    ImageTransparency = 0.2,
}):Play()
task.wait(0.4)

L.Visible = true
y.Visible = true
x.Visible = true
w.Visible = true
z.Visible = true
M.Visible = true
B.Visible = true

loadConfig()

local bm, bn, bo, bp, bq, br, bs, bt = addToggle(ak, 'Auto Save Config', a4.autoSave, function(bm)
    a4.autoSave = bm

    if a4.autoSave then
        saveConfig()
    end

    showNotification('Auto Save Config', bm and 'Enabled' or 'Disabled', Color3.fromRGB(0, 255, 120), 2)
end), addToggle(ak, 'Auto Inject', a4.autoInject, function(bn)
    a4.autoInject = bn

    if a4.autoSave then
        saveConfig()
    end

    showNotification('Auto Inject', bn and 'Enabled' or 'Disabled', Color3.fromRGB(0, 255, 120), 2)

    if bn and not a7 then
        performAutoInject()
    end
end), addToggle(ak, 'Auto Executor Loader', a4.autoExecutorLoader, function(bo)
    a4.autoExecutorLoader = bo

    if a4.autoSave then
        saveConfig()
    end
    if bo then
        setupAutoExecutorLoader()
        showNotification('Auto Executor Loader', 'Enabled \u{2013} will reload on teleport', Color3.fromRGB(0, 255, 120), 2)
    else
        clearTeleportQueue()
    end
end), addToggle(ak, 'Anti AFK', a4.antiAfk, function(bp)
    a4.antiAfk = bp

    if a4.autoSave then
        saveConfig()
    end
    if bp then
        if not antiAfkConnection then
            antiAfkConnection = g.Idled:Connect(function()
                pcall(function()
                    local bq = game:GetService'VirtualUser'

                    bq:CaptureController()
                    bq:ClickButton2(Vector2.new())
                end)
            end)
        end
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()

            antiAfkConnection = nil
        end
    end

    showNotification('Anti AFK', bp and 'Enabled' or 'Disabled', Color3.fromRGB(0, 255, 120), 2)
end), addToggle(ak, 'Anti Fling', a4.antiFling, function(bq)
    a4.antiFling = bq

    if a4.autoSave then
        saveConfig()
    end
    if bq then
        if not antiFlingConnection then
            antiFlingConnection = e.Stepped:Connect(function()
                for br, bs in f:GetPlayers()do
                    local __DARKLUA_CONTINUE_20 = false

                    repeat
                        if bs == g or not bs.Character then
                            __DARKLUA_CONTINUE_20 = true

                            break
                        end

                        for bt, bu in bs.Character:GetDescendants()do
                            if bu:IsA'BasePart' then
                                (bu).CanCollide = false
                            end
                        end

                        __DARKLUA_CONTINUE_20 = true
                    until true

                    if not __DARKLUA_CONTINUE_20 then
                        break
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

    showNotification('Anti Fling', bq and 'Enabled' or 'Disabled', Color3.fromRGB(0, 255, 120), 2)
end), addToggle(ak, 'Anti Gameplay Pause', a4.antiGameplayPause, function(br)
    a4.antiGameplayPause = br

    if a4.autoSave then
        saveConfig()
    end
    if br then
        if not antiGameplayPauseRunning then
            antiGameplayPauseRunning = true
            antiGameplayPauseThread = task.spawn(function()
                local bs = game:GetService'GuiService'

                while antiGameplayPauseRunning do
                    pcall(function()
                        bs:SetGameplayPausedNotificationEnabled(false)

                        g.GameplayPaused = false
                    end)
                    task.wait()
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

    showNotification('Anti Gameplay Pause', br and 'Enabled' or 'Disabled', Color3.fromRGB(0, 255, 120), 2)
end), addToggle(ak, 'Skip Intro UI', a4.skipIntroUI, function(bs)
    a4.skipIntroUI = bs

    if a4.autoSave then
        saveConfig()
    end

    showNotification('Skip Intro UI', bs and 'Will skip next session' or 'Intro restored', Color3.fromRGB(0, 255, 120), 2)
end), Instance.new'TextButton'

bt.Name = 'OpenConsoleButton'
bt.Size = UDim2.new(0, 180, 0, 30)
bt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bt.BackgroundTransparency = 0.9
bt.BorderSizePixel = 0
bt.Font = Enum.Font.Arcade
bt.Text = 'Open Console'
bt.TextColor3 = Color3.fromRGB(0, 200, 255)
bt.TextSize = 12
bt.ZIndex = 2
Instance.new('UICorner', bt).CornerRadius = UDim.new(0, 4)

do
    local bu = Instance.new('UIStroke', bt)

    bu.Color = Color3.fromRGB(0, 200, 255)
    bu.Thickness = 1.5
    bu.Transparency = 0.5
end

bt.Parent = ak

bt.MouseButton1Click:Connect(function()
    pcall(function()
        game:GetService'StarterGui':SetCore('DevConsoleVisible', true)
    end)
end)

local bu = Instance.new'TextButton'

bu.Name = 'DeleteConfigButton'
bu.Size = UDim2.new(0, 180, 0, 30)
bu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bu.BackgroundTransparency = 0.9
bu.BorderSizePixel = 0
bu.Font = Enum.Font.Arcade
bu.Text = 'Delete Config'
bu.TextColor3 = Color3.fromRGB(255, 100, 100)
bu.TextSize = 12
bu.ZIndex = 2
Instance.new('UICorner', bu).CornerRadius = UDim.new(0, 4)

do
    local bv = Instance.new('UIStroke', bu)

    bv.Color = Color3.fromRGB(255, 100, 100)
    bv.Thickness = 1.5
    bv.Transparency = 0.5
end

bu.Parent = ak

local function updateCanvasSize()
    local bv = 0

    for bw, bx in ak:GetChildren()do
        if bx:IsA'GuiObject' and bx ~= (al) then
            bv = bv + ((bx).Size.Y.Offset + 8)
        end
    end

    ak.CanvasSize = UDim2.new(0, 0, 0, math.max(bv, 150))
end

updateCanvasSize()

local function onPanelOpen()
    updateCanvasSize()
end

if a4.autoInject then
    performAutoInject()
end
if a4.autoExecutorLoader then
    setupAutoExecutorLoader()
end

UpdateGreeting()
pcall(function()
    d:Create(J, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
end)
task.spawn(function()
    while r and r.Parent do
        task.wait(3)

        if not (r and r.Parent) then
            break
        end

        pcall(function()
            d:Create(J, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.88}):Play()
            d:Create(F, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            }):Play()
            d:Create(G, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
            d:Create(E, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
        end)
        task.wait(0.25)

        K = not K

        pcall(ApplyGreetingState)

        if K then
            pcall(function()
                d:Create(E, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                d:Create(G, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.2}):Play()
            end)
        else
            pcall(function()
                E.ImageTransparency = 1
                G.TextTransparency = 1
            end)
        end

        pcall(function()
            d:Create(J, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            d:Create(F, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0,
                TextStrokeTransparency = 0.6,
            }):Play()
        end)
    end
end)
y.MouseButton1Click:Connect(function()
    if not y.Active then
        return
    end

    injectScript()

    y.Text = 'Injecting...'

    d:Create(s, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        ImageTransparency = 1,
    }):Play()
    clearText()
    task.wait(0.35)
    cleanupAntiFeatures()

    if r then
        r:Destroy()
    end
end)
M.MouseEnter:Connect(function()
    if ab and not ab.Visible then
        pcall(function()
            d:Create(N, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.22}):Play()
            d:Create(M, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 42,
                ImageTransparency = 0,
            }):Play()
        end)
    end
end)
M.MouseLeave:Connect(function()
    if ab and not ab.Visible then
        pcall(function()
            d:Create(N, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 1}):Play()
            d:Create(M, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                Rotation = 0,
                ImageTransparency = 0.2,
            }):Play()
        end)
    end
end)
M.MouseButton1Click:Connect(function()
    if not ab then
        return
    end
    if ab.Visible then
        pcall(function()
            d:Create(N, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.76}):Play()
            d:Create(M, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = -30,
            }):Play()
            task.delay(0.12, function()
                pcall(function()
                    d:Create(N, TweenInfo.new(0.42, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Scale = 1}):Play()
                    d:Create(M, TweenInfo.new(0.48, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                        Rotation = 0,
                        ImageTransparency = 0.2,
                    }):Play()
                end)
            end)
        end)
        d:Create(ab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            ImageTransparency = 1,
        }):Play()
        task.wait(0.15)

        if ab then
            ab.Visible = false
            ab.Size = UDim2.new(0, _, 0, aa)
            ab.ImageTransparency = 0
        end

        resetToSettingsTab()

        if O and not O.Visible and V and not V.Visible then
            setButtonActive(y, true)
            setButtonActive(L, true)
        end
    else
        pcall(function()
            d:Create(N, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.76}):Play()
            d:Create(M, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 82}):Play()
            task.delay(0.12, function()
                pcall(function()
                    d:Create(N, TweenInfo.new(0.42, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Scale = 1}):Play()
                    d:Create(M, TweenInfo.new(0.48, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Rotation = 45,
                        ImageTransparency = 0,
                    }):Play()
                end)
            end)
        end)
        resetToSettingsTab()

        ab.Visible = true
        ab.Size = UDim2.new(0, 0, 0, 0)

        d:Create(ab, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, _, 0, aa),
            ImageTransparency = 0,
        }):Play()
        setButtonActive(y, false)
        setButtonActive(L, false)
        onPanelOpen()
    end
end)

local bv = false

local function closeConfirmDialog(bw)
    if not O or not O.Parent or not O.Visible or bv then
        if bw then
            bw()
        end

        return
    end

    bv = true

    local bx = d:Create(O, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        ImageTransparency = 1,
    })

    bx.Completed:Connect(function()
        if O and O.Parent then
            O.Visible = false
            O.Size = UDim2.new(0, 200, 0, 100)
            O.ImageTransparency = 0
        end

        bv = false

        if ab and ab.Visible then
            setButtonActive(y, false)
            setButtonActive(L, false)
            setButtonActive(M, true)
        else
            setButtonActive(y, true)
            setButtonActive(L, true)
            setButtonActive(M, true)
        end
        if bw then
            bw()
        end
    end)
    bx:Play()
end

L.MouseButton1Click:Connect(function()
    if not O or O.Visible or (V and V.Visible) then
        return
    end

    setButtonActive(y, false)
    setButtonActive(L, false)
    setButtonActive(M, false)

    if ab and ab.Visible then
        ab.Visible = false
        ab.Size = UDim2.new(0, _, 0, aa)
        ab.ImageTransparency = 0
    end

    O.Visible = true
    O.Size = UDim2.new(0, 0, 0, 0)
    O.ImageTransparency = 1

    d:Create(O, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200, 0, 100),
        ImageTransparency = 0,
    }):Play()
end)
R.MouseButton1Click:Connect(function()
    closeConfirmDialog(function()
        clearText()
        d:Create(s, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            ImageTransparency = 1,
        }):Play()
        task.wait(0.3)
        cleanupAntiFeatures()

        if r then
            r:Destroy()
        end
    end)
end)
T.MouseButton1Click:Connect(function()
    closeConfirmDialog()
end)

local bw = false

local function closeDeleteConfirmDialog(bx)
    if not V or not V.Parent or not V.Visible or bw then
        if bx then
            bx()
        end

        return
    end

    bw = true

    local by = d:Create(V, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        ImageTransparency = 1,
    })

    by.Completed:Connect(function()
        if V and V.Parent then
            V.Visible = false
            V.Size = UDim2.new(0, 200, 0, 100)
            V.ImageTransparency = 0
        end

        bw = false

        if ab and ab.Visible then
            setButtonActive(y, false)
            setButtonActive(L, false)
            setButtonActive(M, true)
        else
            setButtonActive(y, true)
            setButtonActive(L, true)
            setButtonActive(M, true)
        end
        if bx then
            bx()
        end
    end)
    by:Play()
end

bu.MouseButton1Click:Connect(function()
    if (V and V.Visible) or (O and O.Visible) then
        return
    end

    setButtonActive(y, false)
    setButtonActive(L, false)
    setButtonActive(M, false)

    V.Visible = true
    V.Size = UDim2.new(0, 0, 0, 0)
    V.ImageTransparency = 1

    d:Create(V, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200, 0, 100),
        ImageTransparency = 0,
    }):Play()
end)
W.MouseButton1Click:Connect(function()
    closeDeleteConfirmDialog(function()
        local bx = false

        if isfile and delfile then
            pcall(function()
                if isfile(a2) then
                    delfile(a2)

                    bx = true
                end
            end)
        end
        if bx then
            a4.autoSave = false
            a4.autoInject = false
            a4.autoExecutorLoader = false
            a4.antiAfk = false
            a4.antiFling = false
            a4.antiGameplayPause = false
            a4.skipIntroUI = false

            bm:Set(false)
            bn:Set(false)
            bo:Set(false)
            bp:Set(false)
            bq:Set(false)
            br:Set(false)
            bs:Set(false)
            showNotification('Config Deleted', 'Settings file has been removed.', Color3.fromRGB(255, 100, 100), 3)
        end
    end)
end)
Y.MouseButton1Click:Connect(function()
    closeDeleteConfirmDialog()
end)

local bx, by = pcall(function()
    local bx = Instance.new'UIDragDetector'

    bx:Destroy()

    local by = Instance.new'UIDragDetector'

    by.Parent = s

    local bz = Instance.new'UIScale'

    bz.Scale = 1
    bz.Parent = s

    local bA, bB = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

    local function applyTween(bC, bD, bE)
        local bF, bG = pcall(function()
            d:Create(bC, bE or bA, bD):Play()
        end)

        if not bF then
            warn('[VelocityX] Drag tween error:', bG)
        end
    end

    local bC, bD, bE, bF, bG = false, 0, 0.06, 3.2, 5

    local function settingsOpen()
        return ab ~= nil and ab.Visible
    end

    by.DragStart:Connect(function()
        if settingsOpen() then
            return
        end

        bC = true
        bD = tick()

        applyTween(bz, {Scale = 0.96})
        applyTween(s, {BackgroundTransparency = 0.5})
    end)
    by.DragContinue:Connect(function()
        if not bC or settingsOpen() then
            return
        end

        local bH = tick()

        if (bH - bD) < bE then
            return
        end

        bD = bH

        local bI = math.sin(bH * bF) * bG

        applyTween(s, {Rotation = bI})
    end)
    by.DragEnd:Connect(function()
        bC = false
        bD = 0

        applyTween(bz, {Scale = 1}, bB)
        applyTween(s, {
            BackgroundTransparency = 0,
            Rotation = 0,
        }, bB)
    end)
end)

if not bx then
    warn('[VelocityX] UIDragDetector unavailable \u{2014} using fallback drag. Reason:', by)

    local bz, bA, bB, bC = game:GetService'UserInputService', false

    local function isDragInput(bD)
        return bD.UserInputType == Enum.UserInputType.MouseButton1 or bD.UserInputType == Enum.UserInputType.Touch
    end
    local function isMotionInput(bD)
        return bD.UserInputType == Enum.UserInputType.MouseMovement or bD.UserInputType == Enum.UserInputType.Touch
    end

    s.InputBegan:Connect(function(bD)
        if not isDragInput(bD) then
            return
        end
        if ab and ab.Visible then
            return
        end

        bA = true
        bB = Vector2.new(bD.Position.X, bD.Position.Y)
        bC = s.Position

        pcall(function()
            d:Create(s, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5}):Play()
        end)
    end)
    bz.InputChanged:Connect(function(bD)
        if not bA or not isMotionInput(bD) then
            return
        end
        if ab and ab.Visible then
            return
        end

        local bE, bF, bG = Vector2.new(bD.Position.X, bD.Position.Y) - (bB), workspace.CurrentCamera.ViewportSize, bC

        s.Position = UDim2.new(bG.X.Scale + bE.X / bF.X, bG.X.Offset, bG.Y.Scale + bE.Y / bF.Y, bG.Y.Offset)
    end)
    bz.InputEnded:Connect(function(bD)
        if not isDragInput(bD) or not bA then
            return
        end

        bA = false

        pcall(function()
            d:Create(s, TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        end)
    end)
end
