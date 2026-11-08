-- ============================================================
--  🍀 SUPER LUCK DESTROYER - ULTIMATE EDITION 🍀
--  - Client only, KHÔNG kill bản thân / KHÔNG ảnh hưởng NPC
--  - 25+ tính năng: Black Hole, Slow-mo, Combo, Random Events, ...
-- ============================================================

local Players      = game:GetService("Players")
local StarterGui   = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris       = game:GetService("Debris")
local HapticService = game:GetService("HapticService")
local UIS          = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Camera      = workspace.CurrentCamera

-- ============================================================
--  UTILITY
-- ============================================================

local function Notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=title, Text=text, Duration=dur or 5})
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
        if p:IsA("Model") and p:FindFirstChildOfClass("Humanoid") then return true end
        p = p.Parent
    end
    return false
end

local function HapticBuzz()
    pcall(function()
        if HapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 1)
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 1)
            task.delay(0.35, function()
                HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
                HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
            end)
        end
    end)
end

local function FpsGuard()
    return true -- place holder for potential auto-scale
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
Frame.Size = UDim2.new(0, 340, 0, 260)
Frame.Position = UDim2.new(0.5, -170, 0.5, -130)
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
Subtitle.Size = UDim2.new(1, 0, 0, 18)
Subtitle.Position = UDim2.new(0, 0, 0, 55)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Hold to charge • Client only • NPC Safe"
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham

local LuckButton = Instance.new("TextButton", Frame)
LuckButton.Size = UDim2.new(1, -60, 0, 70)
LuckButton.Position = UDim2.new(0, 30, 0, 85)
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

-- ===== CHARGE BAR =====

local ChargeGui = Instance.new("ScreenGui")
ChargeGui.Name = "ChargeGui"
ChargeGui.ResetOnSpawn = false
ChargeGui.IgnoreGuiInset = true
ChargeGui.DisplayOrder = 10000
ChargeGui.Enabled = false
ChargeGui.Parent = PlayerGui

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

local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(1, 0, 1, 0)
PercentText.BackgroundTransparency = 1
PercentText.Text = "0%"
PercentText.TextColor3 = Color3.new(1, 1, 1)
PercentText.TextSize = 18
PercentText.Font = Enum.Font.GothamBlack
PercentText.TextStrokeTransparency = 0.3
PercentText.ZIndex = 2
PercentText.Parent = BarBg

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

-- ===== SCREEN BORDER GLOW =====

local BorderFrames = {}
local function CreateBorderGlow()
    for _, side in ipairs({"Top", "Bottom", "Left", "Right"}) do
        local f = Instance.new("Frame")
        f.Name = "Border_" .. side
        f.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.ZIndex = 1001
        f.Parent = ScreenGui
        if side == "Top" then
            f.Size = UDim2.new(1, 0, 0, 20); f.Position = UDim2.new(0, 0, 0, 0)
        elseif side == "Bottom" then
            f.Size = UDim2.new(1, 0, 0, 20); f.Position = UDim2.new(0, 0, 1, -20)
        elseif side == "Left" then
            f.Size = UDim2.new(0, 20, 1, 0); f.Position = UDim2.new(0, 0, 0, 0)
        else
            f.Size = UDim2.new(0, 20, 1, 0); f.Position = UDim2.new(1, -20, 0, 0)
        end
        BorderFrames[side] = f
    end
end
CreateBorderGlow()

local function SetBorderGlow(transparency, color)
    for _, f in pairs(BorderFrames) do
        if f then
            f.BackgroundTransparency = transparency
            if color then f.BackgroundColor3 = color end
        end
    end
end

-- ===== KILL COUNTER =====

local KillCounter = Instance.new("TextLabel")
KillCounter.Size = UDim2.new(0, 400, 0, 50)
KillCounter.Position = UDim2.new(0.5, -200, 0, 30)
KillCounter.BackgroundTransparency = 1
KillCounter.Text = ""
KillCounter.TextColor3 = Color3.fromRGB(255, 220, 80)
KillCounter.TextSize = 32
KillCounter.Font = Enum.Font.GothamBlack
KillCounter.TextStrokeTransparency = 0.3
KillCounter.TextStrokeColor3 = Color3.new(0, 0, 0)
KillCounter.ZIndex = 999
KillCounter.Visible = false
KillCounter.Parent = ScreenGui

-- ===== COMBO DISPLAY =====

local ComboDisplay = Instance.new("TextLabel")
ComboDisplay.Size = UDim2.new(0, 300, 0, 60)
ComboDisplay.Position = UDim2.new(1, -320, 0, 100)
ComboDisplay.BackgroundTransparency = 1
ComboDisplay.Text = ""
ComboDisplay.TextColor3 = Color3.fromRGB(255, 100, 200)
ComboDisplay.TextSize = 36
ComboDisplay.Font = Enum.Font.GothamBlack
ComboDisplay.TextStrokeTransparency = 0.3
ComboDisplay.TextStrokeColor3 = Color3.new(0, 0, 0)
ComboDisplay.TextXAlignment = Enum.TextXAlignment.Right
ComboDisplay.ZIndex = 999
ComboDisplay.Parent = ScreenGui

-- ============================================================
--  FX: PARTICLE
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
    em.Speed = NumberRange.new(-40, -25)
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
--  FX: SHOCK RING + FIRE RING
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

-- 🔥 FIRE RING
local function FireRing(center, maxSize, duration)
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanTouch = false
    ring.CanQuery = false
    ring.Material = Enum.Material.Neon
    ring.Color = Color3.fromRGB(255, 120, 20)
    ring.Size = Vector3.new(2, 5, 5)
    ring.CFrame = CFrame.new(center) * CFrame.Angles(0, 0, math.rad(90))
    ring.Transparency = 0.05
    ring.Parent = workspace

    local att = Instance.new("Attachment", ring)
    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://6101261905"
    em.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 20, 0))
    })
    em.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(0.5, 2.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    em.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    em.Lifetime = NumberRange.new(0.5, 1.0)
    em.Speed = NumberRange.new(4, 12)
    em.Rate = 300
    em.LightEmission = 1
    em.SpreadAngle = Vector2.new(180, 180)
    em.Parent = att

    TweenService:Create(ring, TweenInfo.new(duration or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(2, maxSize, maxSize),
        Transparency = 1
    }):Play()
    task.delay(duration or 1, function()
        if em then em.Enabled = false end
    end)
    Debris:AddItem(ring, (duration or 1) + 0.3)
end

-- ============================================================
--  FX: LIGHTNING
-- ============================================================

local function LightningBeam(pos, height, color)
    height = height or 400
    local b = Instance.new("Part")
    b.Anchored = true
    b.CanCollide = false
    b.CanTouch = false
    b.CanQuery = false
    b.Material = Enum.Material.Neon
    b.Color = color or Color3.fromRGB(255, 255, 220)
    b.Size = Vector3.new(3, height, 3)
    b.CFrame = CFrame.new(pos + Vector3.new(0, height / 2, 0))
    b.Transparency = 0.1
    b.Parent = workspace
    TweenService:Create(b, TweenInfo.new(0.4), {
        Transparency = 1, Size = Vector3.new(0, height, 0)
    }):Play()
    Debris:AddItem(b, 0.6)
end

-- Chain lightning: nối 2 điểm
local function ChainBeam(pos1, pos2, color)
    local dist = (pos2 - pos1).Magnitude
    local beam = Instance.new("Part")
    beam.Anchored = true
    beam.CanCollide = false
    beam.CanTouch = false
    beam.CanQuery = false
    beam.Material = Enum.Material.Neon
    beam.Color = color or Color3.fromRGB(150, 200, 255)
    beam.Size = Vector3.new(0.6, dist, 0.6)
    beam.CFrame = CFrame.new((pos1 + pos2) / 2, pos2)
    beam.Transparency = 0.15
    beam.Parent = workspace
    TweenService:Create(beam, TweenInfo.new(0.35), {
        Transparency = 1, Size = Vector3.new(0, dist, 0)
    }):Play()
    Debris:AddItem(beam, 0.5)
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
--  FX: METEOR + MISSILE
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

-- 🚀 PREDATOR MISSILE
local function PredatorMissile(origin, target)
    local start = origin + Vector3.new(0, 300, 0) + Vector3.new(
        math.random(-40, 40), 0, math.random(-40, 40)
    )

    local m = Instance.new("Part")
    m.Size = Vector3.new(2, 2, 8)
    m.Material = Enum.Material.Metal
    m.Color = Color3.fromRGB(60, 60, 60)
    m.Anchored = true
    m.CanCollide = false
    m.CanTouch = false
    m.CanQuery = false
    m.CFrame = CFrame.new(start, target)
    m.Parent = workspace

    local att = Instance.new("Attachment", m)
    local trail = Instance.new("Trail", m)
    trail.Attachment0 = att
    trail.Lifetime = 1.2
    trail.Color = ColorSequence.new(Color3.fromRGB(255, 200, 100))
    trail.LightEmission = 1

    -- Thrust fire
    local fire = Instance.new("ParticleEmitter", m)
    fire.Texture = "rbxassetid://6101261905"
    fire.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    fire.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(1, 0)
    })
    fire.Lifetime = NumberRange.new(0.3, 0.6)
    fire.Speed = NumberRange.new(2, 6)
    fire.Rate = 250
    fire.LightEmission = 1
    fire.EmissionDirection = Enum.NormalId.Bottom

    local light = Instance.new("PointLight", m)
    light.Color = Color3.fromRGB(255, 180, 100)
    light.Range = 40
    light.Brightness = 6

    local dist = (target - start).Magnitude
    local dur = math.clamp(dist / 700, 0.35, 0.9)

    PlaySound("1684721563", 2, 1.2) -- missile launch

    TweenService:Create(m, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        CFrame = CFrame.new(target)
    }):Play()

    task.delay(dur, function()
        if not m.Parent then return end
        local pos = m.Position
        m:Destroy()
        CreateBurst(pos, Color3.fromRGB(255, 100, 50), 200)
        MultiShockRing(pos, Color3.fromRGB(255, 100, 50), 3, 80)
        LightningBeam(pos, 200, Color3.fromRGB(255, 150, 50))
        PlaySound("138186576", 3, 0.9)

        -- Phá part quanh vị trí missile
        task.spawn(function()
            for _, p in ipairs(workspace:GetDescendants()) do
                if p:IsA("BasePart") and p ~= workspace.Terrain and not shouldSkip(p) then
                    if (p.Position - pos).Magnitude <= 60 then
                        pcall(function() p:Destroy() end)
                    end
                end
            end
        end)
    end)
    Debris:AddItem(m, dur + 0.5)
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
--  FX: SCREEN
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
        if p < 0.25 then dist = 15 + (p / 0.25) * 120
        elseif p < 0.5 then dist = 135 - ((p - 0.25) / 0.25) * 110
        elseif p < 0.75 then dist = 25 + ((p - 0.5) / 0.25) * 90
        else dist = 115 - ((p - 0.75) / 0.25) * 95 end
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

-- 🌈 CHROMATIC ABERRATION (3 layer R/G/B + vignette image)
local function ChromaticAberration(duration)
    local colors = {Color3.fromRGB(255, 60, 60), Color3.fromRGB(60, 255, 60), Color3.fromRGB(60, 60, 255)}
    local offsets = {UDim2.new(0, -8, 0, 0), UDim2.new(0, 0, 0, 0), UDim2.new(0, 8, 0, 0)}
    local frames = {}
    for i, c in ipairs(colors) do
        local f = Instance.new("ImageLabel")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.Position = offsets[i]
        f.BackgroundTransparency = 1
        f.Image = "rbxassetid://9968344227"
        f.ImageColor3 = c
        f.ImageTransparency = 1
        f.ScaleType = Enum.ScaleType.Stretch
        f.ZIndex = 995
        f.Parent = ScreenGui
        frames[i] = f
        TweenService:Create(f, TweenInfo.new(0.12), {ImageTransparency = 0.65}):Play()
    end
    task.delay(duration or 0.4, function()
        for _, f in ipairs(frames) do
            TweenService:Create(f, TweenInfo.new(0.25), {ImageTransparency = 1}):Play()
        end
    end)
    task.delay((duration or 0.4) + 0.4, function()
        for _, f in ipairs(frames) do if f then f:Destroy() end end
    end)
end

-- 💢 SCREEN CRACK
local function ScreenCrack(duration)
    local center = UDim2.new(0.5, 0, 0.5, 0)
    local cracks = {}
    for i = 1, 22 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 2, 0, 0)
        line.Position = center
        line.AnchorPoint = Vector2.new(0.5, 1)
        line.BackgroundColor3 = Color3.fromRGB(230, 230, 255)
        line.BackgroundTransparency = 0.15
        line.BorderSizePixel = 0
        line.Rotation = math.random(0, 360)
        line.ZIndex = 993
        line.Parent = ScreenGui
        local length = math.random(200, 700)
        cracks[i] = line
        TweenService:Create(line, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 3, 0, length)
        }):Play()
    end
    task.delay(duration or 1.5, function()
        for _, c in ipairs(cracks) do
            TweenService:Create(c, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        end
    end)
    task.delay((duration or 1.5) + 0.6, function()
        for _, c in ipairs(cracks) do if c then c:Destroy() end end
    end)
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

-- 💢 DAMAGE NUMBER
local lastDmgTime = 0
local function SpawnDamageNumber(worldPos, text, color)
    if tick() - lastDmgTime < 0.04 then return end
    lastDmgTime = tick()
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Transparency = 1
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.CFrame = CFrame.new(worldPos)
    part.Parent = workspace
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 100, 0, 40)
    bb.AlwaysOnTop = true
    bb.Parent = part
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = color or Color3.fromRGB(255, 255, 100)
    t.TextSize = 22
    t.Font = Enum.Font.GothamBlack
    t.TextStrokeTransparency = 0
    t.Parent = bb
    TweenService:Create(part, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = CFrame.new(worldPos + Vector3.new(math.random(-3,3), 8, math.random(-3,3)))
    }):Play()
    TweenService:Create(t, TweenInfo.new(0.7), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    Debris:AddItem(part, 0.9)
end

-- 🪨 DEBRIS FRAGMENT
local function SpawnDebris(pos, color)
    local function makeShard()
        local s = Instance.new("Part")
        s.Size = Vector3.new(math.random(3, 8) / 10, math.random(3, 8) / 10, math.random(3, 8) / 10)
        s.Material = Enum.Material.Neon
        s.Color = color
        s.Anchored = false
        s.CanCollide = false
        s.CanTouch = false
        s.CanQuery = false
        s.CFrame = CFrame.new(pos)
        s.Velocity = Vector3.new(
            math.random(-50, 50), math.random(20, 70), math.random(-50, 50)
        )
        s.RotVelocity = Vector3.new(
            math.random(-20, 20), math.random(-20, 20), math.random(-20, 20)
        )
        s.Parent = workspace
        Debris:AddItem(s, 1.5)
    end
    for i = 1, 3 do makeShard() end
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
--  🕳️ BLACK HOLE
-- ============================================================

local function BlackHole(center, radius, duration, countRef)
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(6, 6, 6)
    sphere.CFrame = CFrame.new(center)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.CanTouch = false
    sphere.CanQuery = false
    sphere.Material = Enum.Material.SmoothPlastic
    sphere.Color = Color3.new(0, 0, 0)
    sphere.Transparency = 0
    sphere.Parent = workspace

    -- Purple accretion ring
    local att = Instance.new("Attachment", sphere)
    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://6101261905"
    em.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 60, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 40, 200))
    })
    em.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    em.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    em.Lifetime = NumberRange.new(0.4, 1.0)
    em.Speed = NumberRange.new(-15, -5)
    em.Rate = 400
    em.SpreadAngle = Vector2.new(180, 180)
    em.LightEmission = 1
    em.Parent = att

    -- Grow sphere
    TweenService:Create(sphere, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(radius * 0.6, radius * 0.6, radius * 0.6)
    }):Play()

    -- Collect parts
    local parts = {}
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("BasePart") and p ~= workspace.Terrain and p ~= sphere and not shouldSkip(p) then
            local d = (p.Position - center).Magnitude
            if d <= radius then
                parts[#parts + 1] = p
                if #parts >= 250 then break end
            end
        end
    end

    -- Tween each part inward
    for _, p in ipairs(parts) do
        if p.Parent then
            pcall(function()
                p.Anchored = true
                p.CanCollide = false
                local tweenDur = math.random(40, 90) / 100
                TweenService:Create(p, TweenInfo.new(tweenDur, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    CFrame = CFrame.new(center) * CFrame.Angles(math.random() * 6.28, math.random() * 6.28, 0)
                }):Play()
            end)
        end
    end

    PlaySound("1826262857", 2, 0.7) -- deep hum

    task.delay(duration + 0.15, function()
        local destroyed = 0
        for _, p in ipairs(parts) do
            if p and p.Parent then
                pcall(function() p:Destroy() end)
                destroyed += 1
            end
        end
        if countRef then countRef(destroyed) end

        -- Collapse sphere with burst
        local pos = sphere.Position
        CreateBurst(pos, Color3.fromRGB(180, 60, 255), 400)
        MultiShockRing(pos, Color3.fromRGB(180, 60, 255), 5, radius * 1.2)
        TweenService:Create(sphere, TweenInfo.new(0.25), {
            Size = Vector3.new(0, 0, 0), Transparency = 0
        }):Play()
        if em then em.Enabled = false end
        Debris:AddItem(sphere, 0.4)
    end)

    return #parts
end

-- ============================================================
--  💥 DESTROY MODES
-- ============================================================

local function ShockwaveDestroy(center, maxRadius, duration, eventType, countRef)
    local parts = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= workspace.Terrain and not shouldSkip(obj) then
            parts[#parts + 1] = obj
        end
    end

    local destroyed = 0
    local done = {}
    local t0 = tick()
    local destroyedList = {}

    -- Golden / Freeze tween trước
    if eventType == "Golden" then
        for _, p in ipairs(parts) do
            if (p.Position - center).Magnitude <= maxRadius then
                pcall(function()
                    p.Color = Color3.fromRGB(255, 215, 0)
                    p.Material = Enum.Material.Neon
                end)
            end
        end
        task.wait(0.4)
    elseif eventType == "Freeze" then
        for _, p in ipairs(parts) do
            if (p.Position - center).Magnitude <= maxRadius then
                pcall(function()
                    p.Color = Color3.fromRGB(150, 220, 255)
                    p.Material = Enum.Material.Ice
                end)
            end
        end
        task.wait(0.4)
    end

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
                    destroyedList[#destroyedList + 1] = p.Position

                    local color
                    if eventType == "Golden" then
                        color = Color3.fromRGB(255, 215, 0)
                    elseif eventType == "Freeze" then
                        color = Color3.fromRGB(150, 220, 255)
                    elseif eventType == "Rainbow" then
                        color = Color3.fromHSV(math.random(), 1, 1)
                        pcall(function()
                            p.Color = color
                            p.Material = Enum.Material.Neon
                        end)
                    else
                        color = Color3.fromHSV(math.random(), 1, 1)
                    end

                    if destroyed % 10 == 0 then
                        CreateBurst(p.Position, color, 30)
                        SpawnDamageNumber(p.Position, "+1", color)
                    end
                    if destroyed % 8 == 0 then
                        SpawnDebris(p.Position, color)
                    end

                    pcall(function() p:Destroy() end)
                end
            end
        end
        if prog >= 1 then conn:Disconnect() end
    end)

    -- Chain lightning
    if eventType == "Chain" then
        task.spawn(function()
            task.wait(duration * 0.5)
            for i = 1, #destroyedList, 10 do
                local a = destroyedList[i]
                local b = destroyedList[math.min(i + 5, #destroyedList)]
                if a and b then ChainBeam(a, b) end
                task.wait(0.02)
            end
        end)
    end

    task.delay(duration + 0.1, function()
        if countRef then countRef(destroyed) end
        -- Sụp đổ theo tầng: unanchor vài part còn sót trên cao
        local count = 0
        for _, p in ipairs(parts) do
            if p and p.Parent and not done[p] then
                local d = (p.Position - center).Magnitude
                if d <= maxRadius * 1.5 and p.Position.Y > center.Y + 15 then
                    pcall(function()
                        p.Anchored = false
                        p.CanCollide = true
                        p.Velocity = Vector3.new(math.random(-5,5), -5, math.random(-5,5))
                    end)
                    count += 1
                    if count >= 25 then break end
                end
            end
        end
    end)

    return destroyed
end

-- 🕳️ CRATER
local function CreateCrater(center, radius)
    local hole = Instance.new("Part")
    hole.Shape = Enum.PartType.Cylinder
    hole.Size = Vector3.new(2, radius * 1.8, radius * 1.8)
    hole.CFrame = CFrame.new(center + Vector3.new(0, -0.5, 0)) * CFrame.Angles(0, 0, math.rad(90))
    hole.Anchored = true
    hole.CanCollide = false
    hole.CanTouch = false
    hole.CanQuery = false
    hole.Material = Enum.Material.SmoothPlastic
    hole.Color = Color3.fromRGB(5, 5, 5)
    hole.Transparency = 0.1
    hole.Parent = workspace
    Debris:AddItem(hole, 20)
end

-- ============================================================
--  ⏱️ SLOW-MOTION
-- ============================================================

local function SlowMotion(duration, strength)
    duration = duration or 1.2
    strength = strength or 0.15

    local origGravity = workspace.Gravity
    local origFov = Camera.FieldOfView

    workspace.Gravity = origGravity * strength
    TweenService:Create(Camera, TweenInfo.new(0.2), {FieldOfView = origFov - 15}):Play()

    task.delay(duration, function()
        TweenService:Create(workspace, TweenInfo.new(0.4), {Gravity = origGravity}):Play()
        TweenService:Create(Camera, TweenInfo.new(0.5), {FieldOfView = origFov}):Play()
    end)
end

-- ============================================================
--  🎰 RARITY
-- ============================================================

local Rarities = {
    {name="COMMON",     color=Color3.fromRGB(200,200,200), weight=40},
    {name="UNCOMMON",   color=Color3.fromRGB(100,255,100), weight=25},
    {name="RARE",       color=Color3.fromRGB(100,180,255), weight=15},
    {name="EPIC",       color=Color3.fromRGB(200,100,255), weight=10},
    {name="LEGENDARY",  color=Color3.fromRGB(255,200,50),  weight=6},
    {name="MYTHIC",     color=Color3.fromRGB(255,80,80),   weight=3},
    {name="GOD TIER",   color=Color3.fromRGB(255,255,255), weight=1},
}
local function RollRarity()
    local total = 0
    for _, r in ipairs(Rarities) do total += r.weight end
    local roll = math.random() * total
    for _, r in ipairs(Rarities) do
        roll -= r.weight
        if roll <= 0 then return r end
    end
    return Rarities[1]
end

-- ============================================================
--  🎲 RANDOM EVENTS
-- ============================================================

local Events = {"Golden", "Reverse", "Freeze", "Chain", "Rainbow"}
local function PickEvent()
    return Events[math.random(1, #Events)]
end

-- ============================================================
--  ⚡ CHARGE SYSTEM (multi-charge + combo)
-- ============================================================

local running = false
local isCharging = false
local chargeStart = 0
local chargeConn, heartConn, scanConn
local lastDetonateTime = 0
local comboCount = 0
local CHARGE_MAX = 10
local comboConn

local function StopChargeEffects()
    if chargeConn then chargeConn:Disconnect() chargeConn = nil end
    if heartConn then heartConn:Disconnect() heartConn = nil end
    if scanConn then scanConn:Disconnect() scanConn = nil end
    ChargeGui.Enabled = false
    SetBorderGlow(1)
end

local function StartCharge()
    if running then return end
    isCharging = true
    chargeStart = tick()
    running = true

    ChargeGui.Enabled = true
    BarFill.Size = UDim2.new(0, 0, 1, -4)
    PercentText.Text = "0%"
    ChargeDesc.Text = "Đang tích tụ năng lượng..."
    ChargeStroke.Color = Color3.fromRGB(255, 50, 50)
    ChargeWarning.Text = "⚠  DANGER ZONE  ⚠"
    ChargeWarning.TextColor3 = Color3.fromRGB(255, 60, 60)

    LuckButton.Text = "⚡ CHARGING... 0%"
    LuckButton.BackgroundColor3 = Color3.fromRGB(120, 60, 40)
    LuckButton.AutoButtonColor = false
    Status.Text = "Đang tích tụ..."
    Status.TextColor3 = Color3.fromRGB(255, 200, 100)

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local center = root and root.Position or Vector3.new(0, 20, 0)

    if char then
        ChargeImplosion(char, CHARGE_MAX + 0.5)
        PlayerAura(char, Color3.fromRGB(255, 180, 50), CHARGE_MAX)
    end
    task.spawn(function() Vortex(center, CHARGE_MAX, 20) end)
    task.spawn(function() Vortex(center, CHARGE_MAX, 35) end)
    SparkleSwarm(center, 30, CHARGE_MAX)

    PlaySound("1843471464", 2, 0.6)
    PlaySound("1843471464", 1.5, 0.9)

    -- Heartbeat
    local nextPulse = 0
    local pulseInterval = 0.8
    heartConn = RunService.Heartbeat:Connect(function()
        if not isCharging then heartConn:Disconnect() return end
        if tick() >= nextPulse then
            nextPulse = tick() + pulseInterval
            pulseInterval = math.max(0.15, pulseInterval * 0.82)
            SetBorderGlow(0.3, Color3.fromRGB(255, 50, 50))
            task.delay(0.15, function() if isCharging then SetBorderGlow(0.65, Color3.fromRGB(255, 50, 50)) end end)
            ScreenShake(0.5, 0.12)
            PlaySound("131961136", 1.0, 0.8)
        end
    end)

    -- Scanline
    scanConn = RunService.Heartbeat:Connect(function()
        if not isCharging then scanConn:Disconnect() return end
        local t = (tick() * 2) % 1
        -- (already has scan visual via bar fill)
    end)

    -- Bar update
    chargeConn = RunService.Heartbeat:Connect(function()
        if not isCharging then chargeConn:Disconnect() return end
        local e = tick() - chargeStart
        local p = math.clamp(e / CHARGE_MAX, 0, 1)
        BarFill.Size = UDim2.new(p, 0, 1, -4)
        PercentText.Text = math.floor(p * 100) .. "%"
        LuckButton.Text = "⚡ " .. math.floor(p * 100) .. "%"

        if p > 0.7 then
            ChargeStroke.Color = Color3.fromRGB(255, 0, 0)
            ChargeWarning.TextColor3 = Color3.fromRGB(255, 20, 20)
            ChargeWarning.Text = "🔥 OVERCHARGE 🔥"
            SetBorderGlow(0.3, Color3.fromRGB(255, 255, 255))
        elseif p > 0.4 then
            ChargeStroke.Color = Color3.fromRGB(255, 80, 40)
            ChargeWarning.TextColor3 = Color3.fromRGB(255, 100, 60)
            ChargeWarning.Text = "⚠  NGUY HIỂM CAO  ⚠"
        end

        if p < 0.3 then
            ChargeDesc.Text = "Đang tích tụ năng lượng..."
        elseif p < 0.6 then
            ChargeDesc.Text = "Năng lượng đang tăng vọt!!!"
        elseif p < 0.85 then
            ChargeDesc.Text = "SẮP BÙNG NỔ!!!"
        else
            ChargeDesc.Text = "🌋 OVERCHARGE - SẴN SÀNG!!!"
        end

        -- Auto-fire at max
        if p >= 1 and isCharging then
            isCharging = false
            StopChargeEffects()
            task.spawn(function() Detonate(CHARGE_MAX) end)
        end
    end)
end

-- ============================================================
--  💥 DETONATE (main logic)
-- ============================================================

local function Detonate(chargeTime)
    chargeTime = math.max(0.5, math.min(chargeTime, CHARGE_MAX))

    -- Combo
    if tick() - lastDetonateTime < 5 then
        comboCount = math.min(comboCount + 1, 5)
    else
        comboCount = 1
    end
    lastDetonateTime = tick()

    -- Combo display
    if comboCount >= 2 then
        ComboDisplay.Text = "x" .. comboCount .. " COMBO!"
        ComboDisplay.TextColor3 = Color3.fromHSV((comboCount - 1) / 5, 1, 1)
        ComboDisplay.TextSize = 60
        TweenService:Create(ComboDisplay, TweenInfo.new(0.3, Enum.EasingStyle.Back), {TextSize = 40}):Play()
        PlaySound("138186576", 1, 1.5 + comboCount * 0.1)
    end

    -- Radius & power
    local comboMul = 1 + (comboCount - 1) * 0.3
    local radius = math.floor((150 + chargeTime ^ 1.5 * 30) * comboMul)
    radius = math.min(radius, 1200)

    local eventType = PickEvent()
    local isOvercharge = chargeTime >= 7

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local center = root and root.Position or Vector3.new(0, 20, 0)
    local targetCFrame = root and root.CFrame or CFrame.new(center)

    Notify("⚡ DETONATE", string.format("Charge %.1fs • Radius %d • %s", chargeTime, radius, eventType), 3)

    -- Kill counter setup
    local killCount = 0
    local function addKills(n)
        killCount += n
        KillCounter.Text = "💥 " .. killCount .. " PARTS"
    end
    KillCounter.Text = "💥 0 PARTS"
    KillCounter.Visible = true

    -- ============ PHASE 1: WOW MOMENT ============
    ScreenFlash(Color3.fromRGB(255, 255, 255), 0.35)
    BlurPulse(50, 0.4)
    ScreenZoom(120, 0.25)
    ScreenShake(5, 0.7)
    ChromaticAberration(0.5)
    ScreenCrack(1.2)
    SpeedLines(1.0, 80)
    LightingFlash()
    HapticBuzz()

    -- ⏱️ Slow-mo đầu tiên
    SlowMotion(1.0, 0.15)

    PlaySound("9118823103", 4, 0.85)
    PlaySound("138186576", 5, 0.75)
    PlaySound("138186576", 4, 0.6)

    BigTextAnimate("💥 " .. eventType:upper() .. " 💥", Color3.fromRGB(255, 220, 80), 140)
    TextRing("✨", Color3.fromRGB(255, 255, 180), 14)

    MultiShockRing(center, Color3.fromRGB(255, 255, 220), 4, radius * 0.5)
    FireRing(center, radius * 0.7, 0.8)
    task.wait(0.1)
    MultiShockRing(center, Color3.fromRGB(255, 180, 100), 4, radius * 0.8)
    FireRing(center, radius * 1.0, 1.0)

    GodRays(center, 16, 280)
    if char then PlayerAura(char, Color3.fromRGB(255, 220, 80), 4) end
    SparkleSwarm(center, 60, 5)

    -- 🚀 PREDATOR MISSILES (nếu combo hoặc overcharge)
    if comboCount >= 3 or isOvercharge then
        local missileCount = comboCount >= 5 and 8 or 5
        task.spawn(function()
            for i = 1, missileCount do
                local angle = math.random() * math.pi * 2
                local dist = radius * (0.5 + math.random() * 0.4)
                local target = center + Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)
                PredatorMissile(center, target)
                task.wait(0.1)
            end
        end)
    end

    -- ============ PHASE 2: BLACK HOLE / SHOCKWAVE ============
    task.spawn(function() CinematicCamera(targetCFrame, 4.0) end)
    task.spawn(function() LightningStorm(center, isOvercharge and 40 or 25, radius * 0.5, 3) end)

    local destroyed = 0

    if eventType == "Reverse" then
        -- 🕳️ Reverse: full black hole
        Status.Text = "HÚT VÀO TÂM!!!"
        BigTextAnimate("🌀 REVERSE 🌀", Color3.fromRGB(180, 60, 255), 100)
        PlaySound("1826262857", 3, 0.5)
        BlackHole(center, radius, 2.0, function(n) addKills(n) end)
        task.wait(2.3)
        destroyed = killCount
        -- Explosion ra ngoài sau khi hút
        MultiShockRing(center, Color3.fromRGB(180, 60, 255), 6, radius * 1.3)
        FireRing(center, radius * 1.2, 1.0)
        MeteorRain(center, 15, radius * 0.6, 3)
    else
        -- Base shockwave
        Status.Text = "PHÁ HỦY DIỆN RỘNG!!!"
        ShockwaveDestroy(center, radius, 2.0, eventType, function(n) addKills(n) end)
        task.wait(0.8)
        -- Black hole kèm theo (visual)
        task.spawn(function()
            BlackHole(center, radius * 0.4, 0.8, function(n) addKills(n) end)
        end)
        -- Meteors
        task.spawn(function() MeteorRain(center, 15 + comboCount * 3, radius * 0.7, 1) end)
        task.wait(0.4)
        task.spawn(function() MeteorRain(center, 20 + comboCount * 4, radius * 1.0, 2) end)
        task.wait(1.5)
    end

    -- 🕳️ CRATER
    CreateCrater(center, radius * 0.35)

    -- ============ PHASE 3: FINALE ============
    task.wait(0.5)
    destroyed = killCount

    ScreenShake(3, 0.7)
    ScreenFlash(Color3.fromRGB(200, 200, 255), 0.5)
    MultiShockRing(center, Color3.fromRGB(255, 220, 100), 6, radius)
    FireRing(center, radius * 1.4, 0.7)

    for i = 1, 10 do
        ShockRing(center, Color3.fromHSV(math.random(), 1, 1), radius * 0.5, 0.5)
        task.wait(0.05)
    end

    -- 🎰 RARITY
    local rarity = RollRarity()
    task.wait(0.4)
    BigTextAnimate(rarity.name .. " LUCK!", rarity.color, 100)
    TextRing("⭐", rarity.color, 16)
    PlaySound("6604916391", 2.5, 1)

    -- Confetti finale
    task.spawn(function()
        for i = 1, 40 do
            local off = Vector3.new(
                math.random(-radius/3, radius/3), math.random(40, 120), math.random(-radius/3, radius/3)
            )
            CreateBurst(center + off, rarity.color, 100)
            task.wait(0.03)
        end
    end)

    -- Update final kill counter
    KillCounter.Text = "💥 " .. destroyed .. " PARTS  •  " .. rarity.name

    Notify(
        "🍀 " .. rarity.name .. " LUCK!",
        string.format("Phá hủy %d parts! Combo x%d • %s", destroyed, comboCount, eventType),
        6
    )

    -- ============ CLEANUP ============
    task.wait(3)
    KillCounter.Visible = false
    ComboDisplay.Text = ""
    running = false

    -- Cooldown (nếu không combo)
    if tick() - lastDetonateTime >= 4.5 then
        for i = 5, 1, -1 do
            Status.Text = "Cooldown: " .. i .. "s"
            Status.TextColor3 = Color3.fromRGB(255, 180, 100)
            task.wait(1)
        end
    end
    Status.Text = "Sẵn sàng"
    Status.TextColor3 = Color3.fromRGB(180, 255, 180)

    LuckButton.Text = "✨  NHẬN MAY MẮN  ✨"
    LuckButton.BackgroundColor3 = Color3.fromRGB(40, 170, 65)
    LuckButton.AutoButtonColor = true
end

-- ============================================================
--  EVENT BINDING
-- ============================================================

LuckButton.MouseButton1Down:Connect(function()
    if running then return end
    StartCharge()
end)

UIS.InputEnded:Connect(function(input, processed)
    if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        if isCharging then
            isCharging = false
            local chargeTime = tick() - chargeStart
            StopChargeEffects()
            task.spawn(function() Detonate(chargeTime) end)
        end
    end
end)

-- Cleanup
LocalPlayer.CharacterRemoving:Connect(function()
    StopChargeEffects()
    running = false
    isCharging = false
end)

Notify("✅ Script Loaded", "Hold button để charge • Nhấn nhanh để nổ nhỏ", 4)
print("[SuperLuckDestroyer ULTIMATE] Loaded - 25+ features, client only, NPC safe.")
