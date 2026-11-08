-- ============================================================
--  🍀 SUPER LUCK DESTROYER - CINEMATIC EDITION v3 🍀
--  - Client only, KHÔNG kill bản thân / KHÔNG đụng NPC
--  - Charging với thanh tiến độ NGUY HIỂM (không tối màn)
--  - Camera điện ảnh + Meteor storm + Phá hủy siêu rộng
-- ============================================================

local Players      = game:GetService("Players")
local StarterGui   = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris       = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Camera      = workspace.CurrentCamera

-- ============================================================
--  UTILITY
-- ============================================================

local function Notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = dur or 5
        })
    end)
end

local function PlaySound(id, vol, pitch)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id
        s.Volume = vol or 1
        s.PlaybackSpeed = pitch or 1
        s.Parent = SoundService
        s:Play()
        Debris:AddItem(s, 8)
    end)
end

local function shouldSkip(part)
    local p = part.Parent
    while p and p ~= workspace do
        if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid") then
            return true
        end
        p = p.Parent
    end
    return false
end

-- ============================================================
--  GUI
-- ============================================================

local oldGui = PlayerGui:FindFirstChild("LuckGui")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuckGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 340, 0, 240)
Frame.Position = UDim2.new(0.5, -170, 0.5, -120)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Frame.BackgroundTransparency = 0.05
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Color = Color3.fromRGB(255, 220, 80)
Stroke.Thickness = 2
Stroke.Transparency = 0.2

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundTransparency = 1
Title.Text = "🍀  SUPER LUCK DESTROYER  🍀"
Title.TextColor3 = Color3.fromRGB(255, 230, 80)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack

local Subtitle = Instance.new("TextLabel", Frame)
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 55)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Client only • NPC Safe • Cinematic"
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham

local LuckButton = Instance.new("TextButton", Frame)
LuckButton.Size = UDim2.new(1, -60, 0, 65)
LuckButton.Position = UDim2.new(0, 30, 0, 90)
LuckButton.BackgroundColor3 = Color3.fromRGB(40, 170, 65)
LuckButton.BorderSizePixel = 0
LuckButton.Text = "✨  NHẬN MAY MẮN  ✨"
LuckButton.TextColor3 = Color3.new(1, 1, 1)
LuckButton.TextSize = 22
LuckButton.Font = Enum.Font.GothamBlack
LuckButton.Parent = Frame
Instance.new("UICorner", LuckButton).CornerRadius = UDim.new(0, 12)

local BtnStroke = Instance.new("UIStroke", LuckButton)
BtnStroke.Color = Color3.fromRGB(120, 255, 140)
BtnStroke.Thickness = 2
BtnStroke.Transparency = 0.3

LuckButton.MouseEnter:Connect(function()
    TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Transparency = 0}):Play()
end)
LuckButton.MouseLeave:Connect(function()
    TweenService:Create(BtnStroke, TweenInfo.new(0.15), {Transparency = 0.3}):Play()
end)

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 1, -35)
Status.BackgroundTransparency = 1
Status.Text = "Sẵn sàng"
Status.TextColor3 = Color3.fromRGB(180, 255, 180)
Status.TextSize = 13
Status.Font = Enum.Font.Gotham
Status.Parent = Frame

-- ============================================================
--  ⚠️ DANGER CHARGE BAR ⚠️
-- ============================================================

local ChargeGui = Instance.new("ScreenGui")
ChargeGui.Name = "ChargeGui"
ChargeGui.ResetOnSpawn = false
ChargeGui.IgnoreGuiInset = true
ChargeGui.DisplayOrder = 10000
ChargeGui.Enabled = false
ChargeGui.Parent = PlayerGui

-- Container
local ChargeContainer = Instance.new("Frame")
ChargeContainer.Size = UDim2.new(0, 600, 0, 90)
ChargeContainer.Position = UDim2.new(0.5, -300, 0.78, 0)
ChargeContainer.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
ChargeContainer.BackgroundTransparency = 0.15
ChargeContainer.BorderSizePixel = 0
ChargeContainer.Parent = ChargeGui
Instance.new("UICorner", ChargeContainer).CornerRadius = UDim.new(0, 14)

local ChargeStroke = Instance.new("UIStroke", ChargeContainer)
ChargeStroke.Color = Color3.fromRGB(255, 50, 50)
ChargeStroke.Thickness = 3
ChargeStroke.Transparency = 0.2

-- Cảnh báo
local ChargeWarning = Instance.new("TextLabel")
ChargeWarning.Size = UDim2.new(1, 0, 0, 28)
ChargeWarning.Position = UDim2.new(0, 0, 0, -8)
ChargeWarning.BackgroundTransparency = 1
ChargeWarning.Text = "⚠  DANGER ZONE  ⚠"
ChargeWarning.TextColor3 = Color3.fromRGB(255, 60, 60)
ChargeWarning.TextSize = 20
ChargeWarning.Font = Enum.Font.GothamBlack
ChargeWarning.TextStrokeTransparency = 0.4
ChargeWarning.TextStrokeColor3 = Color3.new(0, 0, 0)
ChargeWarning.Parent = ChargeContainer

-- Thanh nền
local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, -30, 0, 30)
BarBg.Position = UDim2.new(0, 15, 0, 32)
BarBg.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
BarBg.BorderSizePixel = 0
BarBg.Parent = ChargeContainer
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(0, 8)

local BarBgStroke = Instance.new("UIStroke", BarBg)
BarBgStroke.Color = Color3.fromRGB(100, 20, 20)
BarBgStroke.Thickness = 2

-- Thanh fill
local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, -4)
BarFill.Position = UDim2.new(0, 2, 0, 2)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 220, 80)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 6)

local BarGradient = Instance.new("UIGradient")
BarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 100)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 200, 60)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 100, 40)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 20, 20)),
})
BarGradient.Parent = BarFill

local BarFillStroke = Instance.new("UIStroke", BarFill)
BarFillStroke.Color = Color3.fromRGB(255, 255, 200)
BarFillStroke.Thickness = 1
BarFillStroke.Transparency = 0.3

-- Text phần trăm
local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(1, 0, 1, 0)
PercentText.Position = UDim2.new(0, 0, 0, 0)
PercentText.BackgroundTransparency = 1
PercentText.Text = "0%"
PercentText.TextColor3 = Color3.new(1, 1, 1)
PercentText.TextSize = 18
PercentText.Font = Enum.Font.GothamBlack
PercentText.TextStrokeTransparency = 0.3
PercentText.ZIndex = 2
PercentText.Parent = BarBg

-- Text mô tả
local ChargeDesc = Instance.new("TextLabel")
ChargeDesc.Size = UDim2.new(1, 0, 0, 22)
ChargeDesc.Position = UDim2.new(0, 0, 1, 2)
ChargeDesc.BackgroundTransparency = 1
ChargeDesc.Text = "Đang tích tụ năng lượng..."
ChargeDesc.TextColor3 = Color3.fromRGB(255, 200, 150)
ChargeDesc.TextSize = 14
ChargeDesc.Font = Enum.Font.GothamBold
ChargeDesc.TextStrokeTransparency = 0.5
ChargeDesc.Parent = ChargeContainer

-- Scanline chạy trên thanh
local ScanLine = Instance.new("Frame")
ScanLine.Size = UDim2.new(0, 40, 1, 0)
ScanLine.Position = UDim2.new(-0.1, 0, 0, 0)
ScanLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScanLine.BackgroundTransparency = 0.4
ScanLine.BorderSizePixel = 0
ScanLine.ZIndex = 1
ScanLine.Visible = false
ScanLine.Parent = BarBg
Instance.new("UICorner", ScanLine).CornerRadius = UDim.new(0, 6)

-- ============================================================
--  FX: PARTICLE BURST
-- ============================================================

local function CreateBurst(pos, color, count)
    local att = Instance.new("Attachment")
    att.WorldPosition = pos
    att.Parent = workspace.Terrain

    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://6101261905"
    em.Color = ColorSequence.new(color)
    em.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2.0),
        NumberSequenceKeypoint.new(0.5, 0.9),
        NumberSequenceKeypoint.new(1, 0)
    })
    em.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    em.Lifetime = NumberRange.new(0.6, 1.4)
    em.Speed = NumberRange.new(30, 70)
    em.SpreadAngle = Vector2.new(180, 180)
    em.LightEmission = 1
    em.Rate = 0
    em.Parent = att
    em:Emit(count or 200)
    Debris:AddItem(att, 1.8)
end

local function SparkleSwarm(center, radius, duration)
    local att = Instance.new("Attachment")
    att.WorldPosition = center
    att.Parent = workspace.Terrain

    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://6101261905"
    em.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 180)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(180, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 180, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
    })
    em.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(0.5, 2.4),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    em.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    em.Lifetime = NumberRange.new(1.2, 2.6)
    em.Speed = NumberRange.new(20, 50)
    em.Drag = 4
    em.Acceleration = Vector3.new(0, 25, 0)
    em.SpreadAngle = Vector2.new(180, 180)
    em.LightEmission = 1
    em.Rate = 400
    em.EmissionDirection = Enum.NormalId.Top
    em.Parent = att

    task.delay(duration or 3, function()
        if em then em.Enabled = false end
        task.delay(3, function() if att then att:Destroy() end end)
    end)
end

-- Charge particles - hạt bay vào player (implosion)
local function ChargeImplosion(character, duration)
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local att = Instance.new("Attachment", root)
    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://6101261905"
    em.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 180, 50)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 60, 60)),
    })
    em.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2.5),
        NumberSequenceKeypoint.new(0.5, 1.2),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    em.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    em.Lifetime = NumberRange.new(0.6, 1.0)
    em.Speed = NumberRange.new(-40, -25)  -- âm = bay vào
    em.SpreadAngle = Vector2.new(180, 180)
    em.LightEmission = 1
    em.Rate = 500
    em.Parent = att

    task.delay(duration or 3, function()
        if em then em.Enabled = false end
        Debris:AddItem(att, 2)
    end)
end

-- ============================================================
--  FX: SHOCK RING
-- ============================================================

local function ShockRing(pos, color, maxSize, dur)
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanTouch = false
    ring.CanQuery = false
    ring.Material = Enum.Material.Neon
    ring.Color = color or Color3.fromRGB(255, 220, 80)
    ring.Size = Vector3.new(0.5, 2, 2)
    ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
    ring.Transparency = 0.05
    ring.Parent = workspace
    TweenService:Create(ring, TweenInfo.new(dur or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.5, maxSize or 200, maxSize or 200),
        Transparency = 1
    }):Play()
    Debris:AddItem(ring, (dur or 1) + 0.3)
end

local function MultiShockRing(pos, baseColor, layers, maxSize)
    for i = 1, (layers or 4) do
        task.spawn(function()
            local c = baseColor or Color3.fromHSV(math.random(), 1, 1)
            ShockRing(pos, c, (maxSize or 200) * (i / layers), 0.6 + i * 0.15)
            task.wait(0.08)
        end)
    end
end

-- ============================================================
--  FX: LIGHTNING
-- ============================================================

local function LightningBeam(pos, height)
    height = height or 400
    local b = Instance.new("Part")
    b.Anchored = true
    b.CanCollide = false
    b.CanTouch = false
    b.CanQuery = false
    b.Material = Enum.Material.Neon
    b.Color = Color3.fromRGB(255, 255, 220)
    b.Size = Vector3.new(3, height, 3)
    b.CFrame = CFrame.new(pos + Vector3.new(0, height / 2, 0))
    b.Transparency = 0.1
    b.Parent = workspace
    TweenService:Create(b, TweenInfo.new(0.4), {
        Transparency = 1, Size = Vector3.new(0, height, 0)
    }):Play()
    Debris:AddItem(b, 0.6)
end

local function LightningStorm(center, count, radius, duration)
    for i = 1, count do
        task.spawn(function()
            task.wait(math.random() * duration)
            local angle = math.random() * math.pi * 2
            local dist = math.random() * radius
            local pos = center + Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)
            LightningBeam(pos, math.random(200, 400))
            PlaySound("9118823103", 1.5, math.random(80, 120) / 100)
        end)
    end
end

-- ============================================================
--  FX: METEOR
-- ============================================================

local function SpawnBigMeteor(target, color, size)
    size = size or 12
    color = color or Color3.fromRGB(255, 140, 40)

    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = { LocalPlayer.Character }
    local down = workspace:Raycast(target + Vector3.new(0, 300, 0), Vector3.new(0, -600, 0), rp)
    if down then target = down.Position end

    local origin = target + Vector3.new(
        math.random(-100, 100), math.random(280, 380), math.random(-100, 100)
    )

    local m = Instance.new("Part")
    m.Shape = Enum.PartType.Ball
    m.Material = Enum.Material.Neon
    m.Color = color
    m.Size = Vector3.new(size, size, size)
    m.Anchored = true
    m.CanCollide = false
    m.CanTouch = false
    m.CanQuery = false
    m.CFrame = CFrame.new(origin)
    m.Parent = workspace

    local att0 = Instance.new("Attachment", m)
    local att1 = Instance.new("Attachment", m)
    att1.Position = Vector3.new(0, size, 0)
    local trail = Instance.new("Trail", m)
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Lifetime = 0.8
    trail.Color = ColorSequence.new(color)
    trail.LightEmission = 1
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })

    local fire = Instance.new("ParticleEmitter", m)
    fire.Texture = "rbxassetid://6101261905"
    fire.Color = ColorSequence.new(color)
    fire.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, size * 0.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    fire.Transparency = NumberSequence.new(0.3)
    fire.Lifetime = NumberRange.new(0.4, 0.8)
    fire.Speed = NumberRange.new(5, 15)
    fire.SpreadAngle = Vector2.new(180, 180)
    fire.Rate = 80
    fire.LightEmission = 1

    local light = Instance.new("PointLight", m)
    light.Color = color
    light.Range = 50
    light.Brightness = 8

    local dist = (target - origin).Magnitude
    local dur = math.clamp(dist / 500, 0.5, 1.5)

    TweenService:Create(m, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        CFrame = CFrame.new(target)
    }):Play()

    task.delay(dur, function()
        if not m.Parent then return end
        local impactPos = m.Position
        m:Destroy()
        CreateBurst(impactPos, color, 250)
        MultiShockRing(impactPos, color, 3, 100)
        LightningBeam(impactPos, 300)
        PlaySound("138186576", 3, math.random(70, 110) / 100)

        local pillar = Instance.new("Part")
        pillar.Anchored = true
        pillar.CanCollide = false
        pillar.CanTouch = false
        pillar.CanQuery = false
        pillar.Material = Enum.Material.Neon
        pillar.Color = color
        pillar.Size = Vector3.new(6, 2, 6)
        pillar.CFrame = CFrame.new(impactPos + Vector3.new(0, 1, 0))
        pillar.Transparency = 0.1
        pillar.Parent = workspace
        TweenService:Create(pillar, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(3, 120, 3), Transparency = 1
        }):Play()
        Debris:AddItem(pillar, 0.8)
    end)

    Debris:AddItem(m, dur + 0.5)
end

local function MeteorRain(center, count, spread, wave)
    spread = spread or 200
    wave = wave or 1
    for i = 1, count do
        task.spawn(function()
            task.wait(math.random() * 0.8)
            local target = center + Vector3.new(
                math.random(-spread, spread), 0, math.random(-spread, spread)
            )
            SpawnBigMeteor(
                target, Color3.fromHSV(math.random(), 0.9, 1),
                math.random(8, 18) + wave * 2
            )
        end)
    end
end

-- ============================================================
--  FX: VORTEX / AURA / GOD RAYS
-- ============================================================

local function Vortex(center, duration, radius)
    radius = radius or 30
    local att = Instance.new("Attachment")
    att.WorldPosition = center
    att.Parent = workspace.Terrain
    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://6101261905"
    em.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(120, 220, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 80)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 120, 255)),
    })
    em.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.5, 1.6),
        NumberSequenceKeypoint.new(1, 0)
    })
    em.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    em.Lifetime = NumberRange.new(1.2, 2)
    em.Speed = NumberRange.new(8, 18)
    em.Rate = 500
    em.LightEmission = 1
    em.SpreadAngle = Vector2.new(20, 20)
    em.RotSpeed = NumberRange.new(-360, 360)
    em.EmissionDirection = Enum.NormalId.Top
    em.Parent = att

    local start = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not att.Parent then conn:Disconnect() return end
        local e = tick() - start
        if e >= (duration or 3) then
            conn:Disconnect()
            em.Enabled = false
            Debris:AddItem(att, 3)
            return
        end
        local angle = e * 20
        local off = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        att.WorldPosition = center + off
    end)
end

local function PlayerAura(character, color, duration)
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local att = Instance.new("Attachment", root)
    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://6101261905"
    em.Color = ColorSequence.new(color or Color3.fromRGB(255, 220, 80))
    em.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.5, 1.4),
        NumberSequenceKeypoint.new(1, 0)
    })
    em.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    em.Lifetime = NumberRange.new(0.6, 1.4)
    em.Speed = NumberRange.new(6, 14)
    em.Rate = 200
    em.LightEmission = 1
    em.SpreadAngle = Vector2.new(180, 180)
    em.Parent = att
    task.delay(duration or 3, function()
        if em then em.Enabled = false end
        Debris:AddItem(att, 2)
    end)
end

local function GodRays(center, count, height)
    height = height or 260
    for i = 1, count do
        task.spawn(function()
            local angle = (i / count) * math.pi * 2
            local off = Vector3.new(math.cos(angle) * 15, 0, math.sin(angle) * 15)
            local p = Instance.new("Part")
            p.Anchored = true
            p.CanCollide = false
            p.CanTouch = false
            p.CanQuery = false
            p.Material = Enum.Material.Neon
            p.Color = Color3.fromHSV((i / count), 0.7, 1)
            p.Size = Vector3.new(2, height, 2)
            p.CFrame = CFrame.new(center + off + Vector3.new(0, height / 2, 0))
            p.Transparency = 0.2
            p.Parent = workspace
            TweenService:Create(p, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 1, Size = Vector3.new(0.2, height * 1.5, 0.2)
            }):Play()
            Debris:AddItem(p, 2.2)
        end)
    end
end

-- ============================================================
--  FX: MÀN HÌNH
-- ============================================================

local function ScreenFlash(color, dur)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundColor3 = color or Color3.fromRGB(255, 255, 220)
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0
    f.ZIndex = 999
    f.Parent = ScreenGui
    TweenService:Create(f, TweenInfo.new(dur or 0.6), {BackgroundTransparency = 1}):Play()
    Debris:AddItem(f, (dur or 0.6) + 0.1)
end

local function ScreenShake(intensity, dur)
    if not Camera then return end
    local orig = Camera.CFrame
    local t0 = tick()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        local e = tick() - t0
        if e >= dur then
            conn:Disconnect()
            Camera.CFrame = orig
            return
        end
        local i = (1 - e / dur) * (intensity or 2)
        Camera.CFrame = orig * CFrame.new(
            (math.random() - 0.5) * 2 * i,
            (math.random() - 0.5) * 2 * i,
            (math.random() - 0.5) * 2 * i
        ) * CFrame.Angles(
            (math.random() - 0.5) * 0.06 * i,
            (math.random() - 0.5) * 0.06 * i,
            (math.random() - 0.5) * 0.1 * i
        )
    end)
end

-- ⭐ CINEMATIC CAMERA: pin nhân vật, orbit, zoom xa/gần, rung
local function CinematicCamera(targetCFrame, duration)
    if not Camera then return end
    local orig = Camera.CFrame
    local t0 = tick()
    local camType = Camera.CameraType
    Camera.CameraType = Enum.CameraType.Scriptable

    local conn
    conn = RunService.RenderStepped:Connect(function()
        local e = tick() - t0
        local p = math.clamp(e / duration, 0, 1)
        if p >= 1 then
            conn:Disconnect()
            Camera.CameraType = camType
            Camera.CFrame = orig
            return
        end

        local dist
        if p < 0.25 then
            dist = 15 + (p / 0.25) * 120
        elseif p < 0.5 then
            dist = 135 - ((p - 0.25) / 0.25) * 110
        elseif p < 0.75 then
            dist = 25 + ((p - 0.5) / 0.25) * 90
        else
            dist = 115 - ((p - 0.75) / 0.25) * 95
        end

        local angle = p * math.pi * 2 * 2.5
        local height = 25 + math.sin(p * math.pi * 3) * 25

        local offset = Vector3.new(
            math.cos(angle) * dist, height, math.sin(angle) * dist
        )

        local lookAt = CFrame.new(targetCFrame.Position + offset, targetCFrame.Position)
        local shakeAmt = (0.8 + math.sin(p * math.pi) * 4) * (0.5 + math.random())
        lookAt = lookAt * CFrame.new(
            (math.random() - 0.5) * shakeAmt,
            (math.random() - 0.5) * shakeAmt,
            (math.random() - 0.5) * shakeAmt
        ) * CFrame.Angles(
            (math.random() - 0.5) * shakeAmt * 0.04,
            (math.random() - 0.5) * shakeAmt * 0.04,
            (math.random() - 0.5) * shakeAmt * 0.06
        )

        Camera.CFrame = lookAt
    end)
end

local function ScreenZoom(targetFov, dur)
    if not Camera then return end
    local orig = Camera.FieldOfView
    TweenService:Create(Camera, TweenInfo.new(dur or 0.4, Enum.EasingStyle.Back), {FieldOfView = targetFov}):Play()
    task.delay((dur or 0.4) + 0.1, function()
        TweenService:Create(Camera, TweenInfo.new(0.8), {FieldOfView = orig}):Play()
    end)
end

local function BlurPulse(amount, dur)
    local b = Instance.new("BlurEffect")
    b.Size = 0
    b.Parent = Lighting
    TweenService:Create(b, TweenInfo.new(0.25), {Size = amount or 25}):Play()
    task.delay(dur or 0.5, function()
        TweenService:Create(b, TweenInfo.new(0.6), {Size = 0}):Play()
        Debris:AddItem(b, 1.5)
    end)
end

local function SpeedLines(duration, count)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 1, 0)
    cont.BackgroundTransparency = 1
    cont.ZIndex = 997
    cont.Parent = ScreenGui

    for i = 1, (count or 60) do
        task.spawn(function()
            local line = Instance.new("Frame")
            line.Size = UDim2.new(0, math.random(2, 7), 0, math.random(150, 400))
            line.BackgroundColor3 = Color3.fromHSV(math.random(), 0.5, 1)
            line.BackgroundTransparency = 0.15
            line.BorderSizePixel = 0
            line.ZIndex = 997
            line.Parent = cont
            local angle = math.random() * math.pi * 2
            local x = 0.5 + math.cos(angle) * 1.5
            local y = 0.5 + math.sin(angle) * 1.5
            line.Position = UDim2.new(x, 0, y, 0)
            line.Rotation = math.deg(angle) + 90
            TweenService:Create(line, TweenInfo.new(0.4 + math.random() * 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1
            }):Play()
            Debris:AddItem(line, 0.9)
        end)
        task.wait(0.01)
    end
    Debris:AddItem(cont, (duration or 1) + 0.5)
end

local function ChromaticPulse()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Saturation = 0
    cc.Contrast = 0
    cc.TintColor = Color3.new(1, 1, 1)
    cc.Parent = Lighting
    local seq = {
        {Saturation = 1.8, Contrast = 0.5, TintColor = Color3.fromRGB(255, 200, 100)},
        {Saturation = -1.2, Contrast = 0.6, TintColor = Color3.fromRGB(100, 200, 255)},
        {Saturation = 1.8,  Contrast = 0.4, TintColor = Color3.fromRGB(255, 100, 255)},
        {Saturation = 0,    Contrast = 0,   TintColor = Color3.new(1, 1, 1)},
    }
    for _, props in ipairs(seq) do
        TweenService:Create(cc, TweenInfo.new(0.25), props):Play()
        task.wait(0.25)
    end
    Debris:AddItem(cc, 0.5)
end

local function BigTextAnimate(text, color, size)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 200)
    t.Position = UDim2.new(0, 0, 0.5, -100)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = color or Color3.fromRGB(255, 220, 80)
    t.TextSize = 10
    t.Font = Enum.Font.GothamBlack
    t.TextTransparency = 1
    t.TextStrokeTransparency = 1
    t.TextStrokeColor3 = Color3.new(0, 0, 0)
    t.ZIndex = 998
    t.Parent = ScreenGui
    TweenService:Create(t, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextTransparency = 0, TextSize = size or 120, TextStrokeTransparency = 0.3
    }):Play()
    task.delay(1.8, function()
        TweenService:Create(t, TweenInfo.new(0.5), {
            TextTransparency = 1, TextSize = (size or 120) * 1.4
        }):Play()
        Debris:AddItem(t, 0.7)
    end)
end

local function TextRing(text, color, count)
    count = count or 12
    for i = 1, count do
        task.spawn(function()
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(0, 120, 0, 40)
            t.Position = UDim2.new(0.5, -60, 0.5, -20)
            t.BackgroundTransparency = 1
            t.Text = text
            t.TextColor3 = color or Color3.fromHSV(math.random(), 1, 1)
            t.TextSize = 28
            t.Font = Enum.Font.GothamBold
            t.TextStrokeTransparency = 0.3
            t.ZIndex = 998
            t.Parent = ScreenGui
            local angle = (i / count) * math.pi * 2
            local dx = math.cos(angle) * 700
            local dy = math.sin(angle) * 450
            TweenService:Create(t, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -60 + dx, 0.5, -20 + dy),
                TextTransparency = 1, TextSize = 45
            }):Play()
            Debris:AddItem(t, 1.5)
        end)
    end
end

-- ============================================================
--  SHOCKWAVE DESTROY
-- ============================================================

local function ShockwaveDestroy(center, maxRadius, duration)
    local parts = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart")
            and obj ~= workspace.Terrain
            and not shouldSkip(obj)
        then
            parts[#parts + 1] = obj
        end
    end

    local destroyed = 0
    local done = {}
    local t0 = tick()

    local conn
    conn = RunService.Heartbeat:Connect(function()
        local e = tick() - t0
        local prog = math.clamp(e / duration, 0, 1)
        local radius = maxRadius * prog

        for _, p in ipairs(parts) do
            if not done[p] and p.Parent then
                local d = (p.Position - center).Magnitude
                if d <= radius then
                    done[p] = true
                    destroyed += 1
                    if destroyed % 10 == 0 then
                        CreateBurst(p.Position, Color3.fromHSV(math.random(), 1, 1), 30)
                    end
                    pcall(function() p:Destroy() end)
                end
            end
        end
        if prog >= 1 then conn:Disconnect() end
    end)
    return function() return destroyed end
end

local function RainbowConfetti(count)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local center = root and root.Position or Vector3.new(0, 20, 0)
    for i = 1, count do
        local off = Vector3.new(
            math.random(-70, 70), math.random(40, 120), math.random(-70, 70)
        )
        CreateBurst(center + off, Color3.fromHSV(math.random(), 1, 1), 120)
        task.wait(0.02)
    end
end

local function LightingFlash()
    local origBrightness = Lighting.Brightness
    local origAmbient    = Lighting.OutdoorAmbient
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    local bloom = Instance.new("BloomEffect", Lighting)
    bloom.Intensity = 0
    bloom.Size = 60
    bloom.Threshold = 0.4
    cc.Saturation = 0.5
    cc.Contrast = 0.2
    cc.TintColor = Color3.fromRGB(255, 245, 210)
    TweenService:Create(Lighting, TweenInfo.new(0.2), {
        Brightness = 5, OutdoorAmbient = Color3.fromRGB(255, 240, 220)
    }):Play()
    TweenService:Create(bloom, TweenInfo.new(0.2), {Intensity = 3}):Play()
    task.delay(3, function()
        TweenService:Create(Lighting, TweenInfo.new(1.2), {
            Brightness = origBrightness, OutdoorAmbient = origAmbient
        }):Play()
        TweenService:Create(bloom, TweenInfo.new(1.2), {Intensity = 0}):Play()
        TweenService:Create(cc, TweenInfo.new(1.2), {
            Saturation = 0, Contrast = 0, TintColor = Color3.new(1,1,1)
        }):Play()
        Debris:AddItem(bloom, 1.6)
        Debris:AddItem(cc, 1.6)
    end)
end

-- ============================================================
--  ⚠️ CHARGING SEQUENCE (không tối màn - dùng thanh tiến độ)
-- ============================================================

local function RunCharge(center, character, duration)
    duration = duration or 3
    ChargeGui.Enabled = true
    BarFill.Size = UDim2.new(0, 0, 1, -4)
    PercentText.Text = "0%"
    ChargeDesc.Text = "Đang tích tụ năng lượng..."
    ScanLine.Visible = true
    ScanLine.Position = UDim2.new(-0.1, 0, 0, 0)
    ChargeStroke.Color = Color3.fromRGB(255, 50, 50)

    -- Scanline loop
    local scanConn
    scanConn = RunService.Heartbeat:Connect(function()
        if not ScanLine.Visible then scanConn:Disconnect() return end
        local t = tick() * 2 % 1
        ScanLine.Position = UDim2.new(t - 0.1, 0, 0, 0)
    end)

    -- Charge effects
    if character then ChargeImplosion(character, duration + 0.5) end
    task.spawn(function() Vortex(center, duration, 20) end)
    task.spawn(function() Vortex(center, duration, 35) end)
    SparkleSwarm(center, 30, duration)
    if character then PlayerAura(character, Color3.fromRGB(255, 180, 50), duration) end

    -- Âm thanh charge
    PlaySound("1843471464", 2, 0.6)  -- charge slow
    PlaySound("1843471464", 1.5, 0.9)

    -- Flash nhịp tim (không tối, chỉ pulse sáng)
    local heartConn
    local nextPulse = 0
    local pulseInterval = 0.8
    heartConn = RunService.Heartbeat:Connect(function()
        if tick() >= nextPulse then
            nextPulse = tick() + pulseInterval
            pulseInterval = math.max(0.15, pulseInterval * 0.82)  -- nhanh dần

            -- pulse viền đỏ
            ChargeStroke.Transparency = 0
            TweenService:Create(ChargeStroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()

            -- sáng nhẹ màn hình
            ScreenFlash(Color3.fromRGB(255, 220, 150), 0.15)

            -- rung camera nhẹ
            ScreenShake(0.6 + (duration - pulseInterval) * 0.4, 0.15)

            -- âm thanh nhịp tim
            PlaySound("131961136", 1.2, 0.8)
        end
        if not ChargeGui.Enabled then heartConn:Disconnect() end
    end)

    -- Cập nhật thanh tiến độ mượt
    local t0 = tick()
    local fillConn
    fillConn = RunService.Heartbeat:Connect(function()
        local e = tick() - t0
        local p = math.clamp(e / duration, 0, 1)
        BarFill.Size = UDim2.new(p, 0, 1, -4)
        PercentText.Text = math.floor(p * 100) .. "%"

        -- Đổi màu viền theo %
        if p > 0.7 then
            ChargeStroke.Color = Color3.fromRGB(255, 0, 0)
            ChargeWarning.TextColor3 = Color3.fromRGB(255, 20, 20)
            ChargeWarning.Text = "🔥 CỰC KỲ NGUY HIỂM 🔥"
        elseif p > 0.4 then
            ChargeStroke.Color = Color3.fromRGB(255, 80, 40)
            ChargeWarning.TextColor3 = Color3.fromRGB(255, 100, 60)
            ChargeWarning.Text = "⚠  NGUY HIỂM CAO  ⚠"
        end

        -- Cập nhật text mô tả
        if p < 0.3 then
            ChargeDesc.Text = "Đang tích tụ năng lượng..."
        elseif p < 0.6 then
            ChargeDesc.Text = "Năng lượng đang tăng vọt!!!"
        elseif p < 0.9 then
            ChargeDesc.Text = "SẮP BÙNG NỔ!!!"
        else
            ChargeDesc.Text = "🌋 KÍCH HOẠT!!!"
        end

        -- Rung theo %
        if math.random() < 0.3 then
            ScreenShake(p * 2, 0.1)
        end

        if p >= 1 then
            fillConn:Disconnect()
        end
    end)

    task.wait(duration)

    -- Dừng mọi thứ charge
    ChargeGui.Enabled = false
    if scanConn then scanConn:Disconnect() end
    if heartConn then heartConn:Disconnect() end
    if fillConn then fillConn:Disconnect() end
    ScanLine.Visible = false
end

-- ============================================================
--  HÀM CHÍNH
-- ============================================================

local running = false
local COOLDOWN = 10
local CHARGE_TIME = 3

local function OnLuck()
    if running then return end
    running = true

    LuckButton.Text = "⏳ ĐANG KÍCH HOẠT..."
    LuckButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    LuckButton.AutoButtonColor = false
    Status.Text = "Đang tích tụ..."
    Status.TextColor3 = Color3.fromRGB(255, 200, 100)

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local center = root and root.Position or Vector3.new(0, 20, 0)
    local targetCFrame = root and root.CFrame or CFrame.new(center)

    Notify("⚠️ DANGER", "Đang tích tụ năng lượng nguy hiểm!", 3)

    -- ============ PHA 0: CHARGING (không tối màn) ============
    RunCharge(center, char, CHARGE_TIME)

    -- ============ PHA 1: BÙNG NỔ ============
    Status.Text = "KÍCH HOẠT!!!"

    ScreenFlash(Color3.fromRGB(255, 255, 255), 0.4)
    BlurPulse(45, 0.4)
    ScreenZoom(115, 0.3)
    ScreenShake(4, 0.7)
    ChromaticPulse()
    SpeedLines(1.0, 80)
    LightingFlash()

    PlaySound("9118823103", 4, 0.85)
    PlaySound("138186576", 4, 0.8)

    BigTextAnimate("💥 MAY MẮN 💥", Color3.fromRGB(255, 220, 80), 140)
    TextRing("✨", Color3.fromRGB(255, 255, 180), 14)

    MultiShockRing(center, Color3.fromRGB(255, 255, 220), 4, 200)
    task.wait(0.1)
    MultiShockRing(center, Color3.fromRGB(255, 180, 100), 4, 280)
    task.wait(0.1)
    MultiShockRing(center, Color3.fromRGB(255, 100, 255), 4, 350)

    GodRays(center, 16, 280)
    if char then PlayerAura(char, Color3.fromRGB(255, 220, 80), 4) end
    SparkleSwarm(center, 60, 5)
    Vortex(center, 2.5, 30)
    task.spawn(function() Vortex(center, 2.5, 50) end)

    -- ============ PHA 2: CAMERA + METEOR ============
    Status.Text = "Thiên thạch giáng thế!!!"

    task.spawn(function() CinematicCamera(targetCFrame, 4.5) end)
    LightningStorm(center, 30, 180, 4)

    task.spawn(function() MeteorRain(center, 20, 150, 1) end)
    task.wait(0.6)
    task.spawn(function() MeteorRain(center, 25, 220, 2) end)
    task.wait(0.6)
    task.spawn(function() MeteorRain(center, 30, 300, 3) end)
    task.wait(0.6)
    task.spawn(function() MeteorRain(center, 20, 350, 4) end)

    task.spawn(function()
        for i = 1, 40 do
            local off = Vector3.new(
                math.random(-120, 120), math.random(0, 35), math.random(-120, 120)
            )
            CreateBurst(center + off, Color3.fromHSV(math.random(), 1, 1), 200)
            task.wait(0.05)
        end
    end)

    ScreenShake(3, 3.5)
    task.wait(3.5)

    -- ============ PHA 3: PHÁ HỦY ============
    Status.Text = "PHÁ HỦY TOÀN MAP!!!"

    PlaySound("138186576", 5, 0.6)
    ScreenShake(5, 1.2)
    ScreenFlash(Color3.fromRGB(255, 180, 100), 0.4)
    BlurPulse(50, 0.5)
    ChromaticPulse()

    BigTextAnimate("🌪  ANNIHILATE  🌪", Color3.fromRGB(255, 80, 80), 130)
    TextRing("💥", Color3.fromRGB(255, 100, 100), 16)

    local getCount = ShockwaveDestroy(center, 500, 2.0)

    task.spawn(function() LightningStorm(center, 40, 250, 2) end)
    task.spawn(function() MeteorRain(center, 20, 400, 5) end)
    task.spawn(function()
        for i = 1, 12 do
            ShockRing(center, Color3.fromHSV(math.random(), 1, 1), 100 + i * 50, 0.8)
            task.wait(0.08)
        end
    end)

    task.wait(2.2)
    local destroyed = getCount()

    -- ============ PHA 4: KẾT THÚC ============
    Status.Text = "Hoàn tất!"
    ScreenShake(2, 0.6)
    ScreenFlash(Color3.fromRGB(200, 200, 255), 0.5)
    MultiShockRing(center, Color3.fromRGB(255, 220, 100), 6, 400)
    task.spawn(function() RainbowConfetti(50) end)

    for i = 1, 10 do
        ShockRing(center, Color3.fromHSV(math.random(), 1, 1), 120, 0.5)
        task.wait(0.06)
    end

    PlaySound("6604916391", 2.5, 1)
    task.wait(0.6)
    BigTextAnimate("💥 " .. destroyed .. " PARTS 💥", Color3.fromRGB(255, 120, 120), 110)

    Notify(
        "🍀 MAY MẮN ĐÃ ĐẾN!",
        string.format("Đã phá hủy %d parts (local).", destroyed),
        5
    )

    Status.Text = "Hoàn tất! (" .. destroyed .. " parts)"

    -- ============ KHÔI PHỤC ============
    task.wait(2)
    LuckButton.Text = "✨  NHẬN MAY MẮN  ✨"
    LuckButton.BackgroundColor3 = Color3.fromRGB(40, 170, 65)
    LuckButton.AutoButtonColor = true

    for i = COOLDOWN, 1, -1 do
        Status.Text = "Cooldown: " .. i .. "s"
        Status.TextColor3 = Color3.fromRGB(255, 180, 100)
        task.wait(1)
    end
    Status.Text = "Sẵn sàng"
    Status.TextColor3 = Color3.fromRGB(180, 255, 180)

    running = false
end

LuckButton.MouseButton1Click:Connect(OnLuck)

Notify("✅ Script Loaded", "Nhấn nút để nhận may mắn!", 3)
print("[SuperLuckDestroyer CINEMATIC v3] Loaded - client only, NPC & self safe.")
