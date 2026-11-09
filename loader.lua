--[[ 
    ⚡ SUPER LUCK DESTROYER - ULTIMATE CINEMATIC VFX ⚡
    - Menu chọn PC / Mobile
    - Hiệu ứng quét toàn map, sét, thiên thạch, âm thanh
    - Kết thúc bằng sét khổng lồ reset player
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ⚙️ CẤU HÌNH URL
local BASE_URL = "https://raw.githubusercontent.com/duongvantrong18102012-cmd/SUPER-LUCK-DESTROYER/refs/heads/main/"
local CONFIG = {
    PC     = BASE_URL .. "pc.lua",
    Mobile = BASE_URL .. "mobile.lua",
}

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- 🗑️ XOÁ GUI CŨ
local parentGui = (gethui and gethui()) or CoreGui or playerGui
if parentGui:FindFirstChild("SLD_Ultimate_Loader") then
    parentGui.SLD_Ultimate_Loader:Destroy()
end

-- ==========================================
-- 🎨 TẠO GUI CHÍNH (MENU CHỌN)
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "SLD_Ultimate_Loader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
gui.Parent = parentGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
bg.BorderSizePixel = 0
bg.Parent = gui

local bgParticles = Instance.new("ParticleEmitter")
bgParticles.Texture = "rbxassetid://6101261905"
bgParticles.Color = ColorSequence.new(Color3.fromRGB(0, 255, 200))
bgParticles.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
bgParticles.Transparency = NumberSequence.new(0.5)
bgParticles.Lifetime = NumberRange.new(2, 4)
bgParticles.Rate = 50
bgParticles.Speed = NumberRange.new(2, 5)
bgParticles.SpreadAngle = Vector2.new(180, 180)
bgParticles.Parent = Instance.new("Attachment", bg)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = bg
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local frameStroke = Instance.new("UIStroke", mainFrame)
frameStroke.Color = Color3.fromRGB(0, 255, 200)
frameStroke.Thickness = 2
frameStroke.Transparency = 0.2

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "SUPER LUCK DESTROYER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.Parent = mainFrame
local titleGlow = Instance.new("UIStroke", title)
titleGlow.Color = Color3.fromRGB(0, 255, 200)
titleGlow.Thickness = 3
titleGlow.Transparency = 0.5

local selectLabel = Instance.new("TextLabel")
selectLabel.Size = UDim2.new(1, 0, 0, 20)
selectLabel.Position = UDim2.new(0, 0, 0, 80)
selectLabel.BackgroundTransparency = 1
selectLabel.Text = "CHỌN PHIÊN BẢN ĐỂ TẢI:"
selectLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
selectLabel.Font = Enum.Font.GothamBold
selectLabel.TextSize = 14
selectLabel.Parent = mainFrame

local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0.9, 0, 0, 60)
btnContainer.Position = UDim2.new(0.05, 0, 0, 110)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = mainFrame

local function createBtn(name, text, color, isDefault)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.48, 0, 1, 0)
    btn.Position = UDim2.new(name == "PC" and 0 or 0.52, 0, 0, 0)
    btn.BackgroundColor3 = isDefault and color or Color3.fromRGB(20, 25, 35)
    btn.BackgroundTransparency = isDefault and 0.2 or 0.5
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = isDefault and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 18
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = isDefault and color or Color3.fromRGB(60, 60, 70)
    stroke.Thickness = isDefault and 3 or 1
    btn.Parent = btnContainer
    return btn, stroke
end

local COLOR_PC = Color3.fromRGB(0, 200, 255)
local COLOR_MOB = Color3.fromRGB(0, 255, 150)
local btnPC, strokePC = createBtn("PC", "💻 PC", COLOR_PC, not isMobile)
local btnMobile, strokeMobile = createBtn("Mobile", "📱 MOBILE", COLOR_MOB, isMobile)

local selectedPlatform = isMobile and "Mobile" or "PC"
local function selectPlatform(platform)
    selectedPlatform = platform
    TweenService:Create(btnPC, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 25, 35), BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    TweenService:Create(strokePC, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 70), Thickness = 1}):Play()
    TweenService:Create(btnMobile, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 25, 35), BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    TweenService:Create(strokeMobile, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 70), Thickness = 1}):Play()
    
    if platform == "PC" then
        TweenService:Create(btnPC, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_PC, BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        TweenService:Create(strokePC, TweenInfo.new(0.2), {Color = COLOR_PC, Thickness = 3}):Play()
    else
        TweenService:Create(btnMobile, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_MOB, BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        TweenService:Create(strokeMobile, TweenInfo.new(0.2), {Color = COLOR_MOB, Thickness = 3}):Play()
    end
end

btnPC.MouseButton1Click:Connect(function() selectPlatform("PC") end)
btnMobile.MouseButton1Click:Connect(function() selectPlatform("Mobile") end)

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.9, 0, 0, 50)
startBtn.Position = UDim2.new(0.05, 0, 0, 190)
startBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
startBtn.BackgroundTransparency = 0.1
startBtn.BorderSizePixel = 0
startBtn.Text = "🚀 BẮT ĐẦU TẢI"
startBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
startBtn.Font = Enum.Font.GothamBlack
startBtn.TextSize = 20
startBtn.AutoButtonColor = false
startBtn.Parent = mainFrame
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)
local startStroke = Instance.new("UIStroke", startBtn)
startStroke.Color = Color3.fromRGB(255, 255, 255)
startStroke.Thickness = 2
startStroke.Transparency = 0.5

local progressContainer = Instance.new("Frame")
progressContainer.Size = UDim2.new(0.9, 0, 0, 60)
progressContainer.Position = UDim2.new(0.05, 0, 0, 250)
progressContainer.BackgroundTransparency = 1
progressContainer.Visible = false
progressContainer.Parent = mainFrame

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, 0, 0, 12)
barBg.BackgroundColor3 = Color3.fromRGB(20, 30, 40)
barBg.BorderSizePixel = 0
barBg.Parent = progressContainer
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
local fillGradient = Instance.new("UIGradient", barFill)
fillGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255)),
}

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(1, 0, 0, 25)
percentText.Position = UDim2.new(0, 0, 0, 20)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentText.Font = Enum.Font.GothamBold
percentText.TextSize = 20
percentText.Parent = progressContainer

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 15)
statusText.Position = UDim2.new(0, 0, 0, 45)
statusText.BackgroundTransparency = 1
statusText.Text = "> WAITING..."
statusText.TextColor3 = Color3.fromRGB(150, 150, 160)
statusText.Font = Enum.Font.Code
statusText.TextSize = 12
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = progressContainer

local function setProgress(p, status)
    TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(p, 0, 1, 0)}):Play()
    percentText.Text = math.floor(p * 100) .. "%"
    if status then statusText.Text = "> " .. status end
end

-- ==========================================
-- 🔥 HÀM HIỆU ỨNG ĐIỆN ẢNH (VFX)
-- ==========================================

-- 1. Hiệu ứng quét toàn map (Scan Wave)
local function MapScanWave()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local center = root and root.Position or Vector3.new(0, 20, 0)
    
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanTouch = false
    ring.CanQuery = false
    ring.Material = Enum.Material.Neon
    ring.Color = Color3.fromRGB(0, 255, 200)
    ring.Size = Vector3.new(1, 10, 10)
    ring.CFrame = CFrame.new(center) * CFrame.Angles(0, 0, math.rad(90))
    ring.Transparency = 0.2
    ring.Parent = workspace
    
    -- Quét xa 5000 studs
    TweenService:Create(ring, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(1, 5000, 5000),
        Transparency = 1
    }):Play()
    Debris:AddItem(ring, 2.5)
end

-- 2. Sét đánh (Lightning)
local function LightningStrike(pos)
    local height = math.random(200, 400)
    local b = Instance.new("Part")
    b.Anchored = true
    b.CanCollide = false
    b.CanTouch = false
    b.CanQuery = false
    b.Material = Enum.Material.Neon
    b.Color = Color3.fromRGB(200, 255, 255)
    b.Size = Vector3.new(4, height, 4)
    b.CFrame = CFrame.new(pos + Vector3.new(0, height / 2, 0))
    b.Transparency = 0
    b.Parent = workspace
    TweenService:Create(b, TweenInfo.new(0.3), {Transparency = 1, Size = Vector3.new(0, height, 0)}):Play()
    Debris:AddItem(b, 0.5)
end

-- 3. Thiên thạch rơi (Meteor)
local function SpawnMeteor(target, color)
    local size = math.random(6, 15)
    local origin = target + Vector3.new(math.random(-100, 100), math.random(250, 350), math.random(-100, 100))
    
    local m = Instance.new("Part")
    m.Shape = Enum.PartType.Ball
    m.Material = Enum.Material.Neon
    m.Color = color or Color3.fromRGB(255, 100, 50)
    m.Size = Vector3.new(size, size, size)
    m.Anchored = true
    m.CanCollide = false
    m.CanTouch = false
    m.CanQuery = false
    m.CFrame = CFrame.new(origin)
    m.Parent = workspace
    
    local trail = Instance.new("Trail", m)
    local att0 = Instance.new("Attachment", m)
    local att1 = Instance.new("Attachment", m)
    att1.Position = Vector3.new(0, size, 0)
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Lifetime = 0.8
    trail.Color = ColorSequence.new(m.Color)
    trail.LightEmission = 1
    
    local light = Instance.new("PointLight", m)
    light.Color = m.Color
    light.Range = 40
    light.Brightness = 5
    
    local dist = (target - origin).Magnitude
    local dur = math.clamp(dist / 500, 0.4, 1.0)
    
    TweenService:Create(m, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        CFrame = CFrame.new(target)
    }):Play()
    
    task.delay(dur, function()
        if not m.Parent then return end
        local impact = m.Position
        m:Destroy()
        
        local explosion = Instance.new("Part")
        explosion.Shape = Enum.PartType.Ball
        explosion.Material = Enum.Material.Neon
        explosion.Color = m.Color
        explosion.Size = Vector3.new(5, 5, 5)
        explosion.Anchored = true
        explosion.CanCollide = false
        explosion.CanTouch = false
        explosion.CanQuery = false
        explosion.CFrame = CFrame.new(impact)
        explosion.Parent = workspace
        TweenService:Create(explosion, TweenInfo.new(0.4), {Size = Vector3.new(40, 40, 40), Transparency = 1}):Play()
        Debris:AddItem(explosion, 0.5)
    end)
    Debris:AddItem(m, dur + 0.2)
end

-- 4. Âm thanh (Sound)
local function PlaySound(id, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. id
    s.Volume = vol or 1
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    Debris:AddItem(s, 10)
end

-- 5. Sét khổng lồ kết liễu (Final Strike + Reset)
local function FinalStrikeAndReset()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local pos = root.Position
        
        -- Sét khổng lồ
        local height = 2000
        local b = Instance.new("Part")
        b.Anchored = true
        b.CanCollide = false
        b.CanTouch = false
        b.CanQuery = false
        b.Material = Enum.Material.Neon
        b.Color = Color3.fromRGB(255, 255, 255)
        b.Size = Vector3.new(20, height, 20)
        b.CFrame = CFrame.new(pos + Vector3.new(0, height / 2, 0))
        b.Transparency = 0
        b.Parent = workspace
        TweenService:Create(b, TweenInfo.new(0.5), {Transparency = 1, Size = Vector3.new(0, height, 0)}):Play()
        Debris:AddItem(b, 1)
        
        -- Flash trắng màn hình
        local flash = Instance.new("Frame", gui)
        flash.Size = UDim2.new(1, 0, 1, 0)
        flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        flash.BackgroundTransparency = 0
        flash.ZIndex = 100
        TweenService:Create(flash, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        Debris:AddItem(flash, 1.5)
        
        -- Âm thanh sét lớn
        PlaySound("138186576", 10, 0.5) -- Boom
        PlaySound("9118823103", 5, 0.4) -- Zap
        
        -- Reset Player
        task.wait(0.5)
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end
end

-- ==========================================
-- 🚀 LOGIC KHI BẤM "BẮT ĐẦU TẢI" (CHẠY CHUỖI VFX)
-- ==========================================
startBtn.MouseButton1Click:Connect(function()
    startBtn.Active = false
    startBtn.Text = "⏳ ĐANG KHỞI TẠO VFX..."
    TweenService:Create(startBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 100, 100), BackgroundTransparency = 0.5}):Play()
    
    btnContainer.Visible = false
    selectLabel.Visible = false
    progressContainer.Visible = true
    
    local targetURL = (selectedPlatform == "PC") and CONFIG.PC or CONFIG.Mobile
    local targetName = (selectedPlatform == "PC") and "PC.LUA" or "MOBILE.LUA"
    
    -- Ẩn GUI menu
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    for _, v in ipairs(mainFrame:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        elseif v:IsA("Frame") then
            TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        elseif v:IsA("UIStroke") then
            TweenService:Create(v, TweenInfo.new(0.3), {Transparency = 1}):Play()
        end
    end
    
    -- ==== CHUỖI HIỆU ỨNG ====
    task.spawn(function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local center = root and root.Position or Vector3.new(0, 20, 0)
        
        -- 1. Nhạc nền (Epic Music)
        PlaySound("1837879084", 1.5, 1) -- Thay bằng ID nhạc bạn thích
        
        -- 2. Quét toàn map
        MapScanWave()
        setProgress(0.3, "SCANNING MAP...")
        task.wait(1.5)
        
        -- 3. Sét đánh ngẫu nhiên (Lightning Storm)
        for i = 1, 15 do
            task.spawn(function()
                local angle = math.random() * math.pi * 2
                local dist = math.random(50, 300)
                local pos = center + Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)
                LightningStrike(pos)
                PlaySound("9118823103", 1, 1)
            end)
            task.wait(0.1)
        end
        setProgress(0.5, "LIGHTNING STORM...")
        task.wait(1)
        
        -- 4. Thiên thạch rơi (Meteor Rain)
        for i = 1, 10 do
            task.spawn(function()
                local target = center + Vector3.new(math.random(-150, 150), 0, math.random(-150, 150))
                SpawnMeteor(target, Color3.fromRGB(255, math.random(50, 150), 0))
            end)
            task.wait(0.15)
        end
        setProgress(0.7, "METEOR RAIN...")
        task.wait(2)
        
        -- 5. Sét khổng lồ kết liễu & Reset
        setProgress(0.9, "FINAL STRIKE...")
        FinalStrikeAndReset()
        
        task.wait(2)
        
        -- 6. Tải Script (sau khi reset)
        local success, err = pcall(function()
            local rawCode = game:HttpGet(targetURL)
            if not rawCode or #rawCode < 50 then error("File rỗng hoặc 404.") end
            local func = loadstring(rawCode)
            if not func then error("Lỗi cú pháp.") end
            func()
        end)
        
        if success then
            print("[SLD Loader] ✅ Tải " .. targetName .. " thành công!")
        else
            warn("[SLD Loader] ❌ Lỗi: " .. tostring(err))
        end
        
        -- Dọn dẹp GUI
        gui:Destroy()
    end)
end)
