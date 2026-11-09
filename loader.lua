--[[ 
    ⚡ SUPER LUCK DESTROYER - ULTIMATE CINEMATIC VFX (V4 DEBUG) ⚡
    FIXED:
    - Không treo ở CharacterAdded:Wait() (dùng timeout + connect trước)
    - Chặn double-click bằng flag isRunning
    - Wrap VFX trong pcall để không crash cả script
    - Safety destroy sau 30s nếu có lỗi không mong muốn
    - Log chi tiết ra Output để debug
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function log(msg)
    print("[SLD Loader] " .. tostring(msg))
end
local function warnLog(msg)
    warn("[SLD Loader] " .. tostring(msg))
end

log("Khởi tạo loader...")

-- ⚙️ CONFIG
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
    log("Đã xoá GUI cũ")
end

-- ==========================================
-- 🎨 GUI
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "SLD_Ultimate_Loader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
gui.Parent = parentGui

-- SAFETY: Nếu có lỗi không mong muốn, tự destroy GUI sau 60s
local safetyKilled = false
task.delay(60, function()
    if not safetyKilled and gui and gui.Parent then
        warnLog("SAFETY TIMEOUT - destroy GUI sau 60s")
        gui:Destroy()
    end
end)

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.Parent = gui

local bgBlur = Instance.new("Frame")
bgBlur.Size = UDim2.new(1, 0, 1, 0)
bgBlur.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
bgBlur.BackgroundTransparency = 0.3
bgBlur.BorderSizePixel = 0
bgBlur.Parent = bg

-- ==========================================
-- 1️⃣ MENU
-- ==========================================
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 450, 0, 400)
menuFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
menuFrame.AnchorPoint = Vector2.new(0.5, 0.5)
menuFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
menuFrame.BackgroundTransparency = 0.05
menuFrame.BorderSizePixel = 0
menuFrame.Parent = bg
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)
local frameStroke = Instance.new("UIStroke", menuFrame)
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
title.Parent = menuFrame
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
selectLabel.Parent = menuFrame

local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0.9, 0, 0, 60)
btnContainer.Position = UDim2.new(0.05, 0, 0, 110)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = menuFrame

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
    btn.Active = true -- Quan trọng cho mobile
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
    log("Đã chọn: " .. platform)
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
startBtn.Active = true
startBtn.Parent = menuFrame
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)
local startStroke = Instance.new("UIStroke", startBtn)
startStroke.Color = Color3.fromRGB(255, 255, 255)
startStroke.Thickness = 2
startStroke.Transparency = 0.5

-- ==========================================
-- 2️⃣ LOADING
-- ==========================================
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 400, 0, 220)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
loadingFrame.BackgroundTransparency = 0.05
loadingFrame.BorderSizePixel = 0
loadingFrame.Visible = false
loadingFrame.Parent = bg
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 12)
local loadStroke = Instance.new("UIStroke", loadingFrame)
loadStroke.Color = Color3.fromRGB(255, 50, 50)
loadStroke.Thickness = 2
loadStroke.Transparency = 0.2

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 40)
loadTitle.Position = UDim2.new(0, 0, 0, 10)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "⚠️ ĐANG KÍCH HOẠT VFX ⚠️"
loadTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
loadTitle.Font = Enum.Font.GothamBlack
loadTitle.TextSize = 22
loadTitle.Parent = loadingFrame

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.9, 0, 0, 12)
barBg.Position = UDim2.new(0.05, 0, 0, 70)
barBg.BackgroundColor3 = Color3.fromRGB(20, 30, 40)
barBg.BorderSizePixel = 0
barBg.Parent = loadingFrame
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
percentText.Position = UDim2.new(0, 0, 0, 90)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentText.Font = Enum.Font.GothamBold
percentText.TextSize = 20
percentText.Parent = loadingFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.9, 0, 0, 30)
statusText.Position = UDim2.new(0.05, 0, 0, 120)
statusText.BackgroundTransparency = 1
statusText.Text = "> SYSTEM INITIALIZING..."
statusText.TextColor3 = Color3.fromRGB(150, 150, 160)
statusText.Font = Enum.Font.Code
statusText.TextSize = 14
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = loadingFrame

local function setProgress(p, status)
    if not barFill or not barFill.Parent then return end
    pcall(function()
        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(p, 0, 1, 0)}):Play()
    end)
    percentText.Text = math.floor(p * 100) .. "%"
    if status then statusText.Text = "> " .. status end
end

-- ==========================================
-- 🔥 VFX (wrap pcall để không crash)
-- ==========================================
local function MapScanWave(center)
    pcall(function()
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
        TweenService:Create(ring, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(1, 5000, 5000),
            Transparency = 1
        }):Play()
        Debris:AddItem(ring, 2.5)
    end)
end

local function LightningStrike(pos)
    pcall(function()
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
    end)
end

local function SpawnMeteor(target, color)
    pcall(function()
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
            pcall(function()
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
        end)
        Debris:AddItem(m, dur + 0.2)
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
        Debris:AddItem(s, 10)
        -- log nếu sound fail sau 1s
        task.delay(1, function()
            if s and s.IsPlaying == false and s.TimePosition == 0 then
                warnLog("Sound ID " .. id .. " có thể không tồn tại")
            end
        end)
    end)
end

local function FinalStrikeAndReset()
    pcall(function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then
            warnLog("Không tìm thấy HumanoidRootPart để Final Strike")
            return
        end
        local pos = root.Position
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
        PlaySound("138186576", 10, 0.5)
        PlaySound("9118823103", 5, 0.4)
        task.wait(0.3)
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
            log("Đã reset player")
        end
    end)
end

-- ==========================================
-- 🚀 MAIN
-- ==========================================
local isRunning = false -- ✅ FIX DOUBLE-CLICK

startBtn.MouseButton1Click:Connect(function()
    if isRunning then
        log("Đang chạy rồi, bỏ qua click")
        return
    end
    isRunning = true
    
    log("Bắt đầu quy trình load...")
    
    startBtn.Active = false
    startBtn.Text = "⏳ VUI LÒNG CHỜ..."
    pcall(function()
        TweenService:Create(startBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
    end)
    
    menuFrame.Visible = false
    loadingFrame.Visible = true
    
    local targetURL = (selectedPlatform == "PC") and CONFIG.PC or CONFIG.Mobile
    log("Target URL: " .. targetURL)
    
    task.spawn(function()
        local ok, err = pcall(function()
            -- ============ VFX SEQUENCE ============
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local center = root and root.Position or Vector3.new(0, 20, 0)
            
            PlaySound("1837879084", 1.5, 1)
            
            log("Bước 1: Map scan wave")
            MapScanWave(center)
            setProgress(0.3, "SCANNING MAP...")
            task.wait(1.5)
            
            log("Bước 2: Lightning storm")
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
            
            log("Bước 3: Meteor rain")
            for i = 1, 10 do
                task.spawn(function()
                    local target = center + Vector3.new(math.random(-150, 150), 0, math.random(-150, 150))
                    SpawnMeteor(target, Color3.fromRGB(255, math.random(50, 150), 0))
                end)
                task.wait(0.15)
            end
            setProgress(0.7, "METEOR RAIN...")
            task.wait(2)
            
            -- ============ FINAL STRIKE + WAIT RESPAWN (FIXED) ============
            log("Bước 4: Final strike")
            setProgress(0.9, "FINAL STRIKE...")
            
            -- ✅ FIX: Connect event TRƯỚC KHI kill
            local newChar = nil
            local conn = player.CharacterAdded:Connect(function(c)
                newChar = c
                log("Nhân vật mới đã spawn")
            end)
            
            FinalStrikeAndReset()
            
            -- ✅ FIX: Dùng timeout thay vì :Wait() (tránh treo)
            local timeout = 10
            local t0 = tick()
            while not newChar and tick() - t0 < timeout do
                task.wait(0.1)
            end
            conn:Disconnect()
            
            if not newChar then
                warnLog("Nhân vật KHÔNG respawn sau " .. timeout .. "s! Load script bất chấp...")
            end
            
            task.wait(1.5) -- Đợi game load nhân vật mới
            
            -- ============ LOAD SCRIPT ============
            log("Bước 5: Tải script chính")
            local rawCode = game:HttpGet(targetURL)
            if not rawCode or #rawCode < 50 then
                error("File rỗng hoặc 404 (độ dài: " .. #(rawCode or "") .. ")")
            end
            if rawCode:find("404: Not Found") or rawCode:find("<!DOCTYPE") then
                error("File không tồn tại trên GitHub (404)")
            end
            local func = loadstring(rawCode)
            if not func then
                error("Lỗi cú pháp code Lua")
            end
            log("Đã lấy code (" .. #rawCode .. " bytes), đang chạy...")
            func()
            log("Script chính đã chạy")
            
            setProgress(1, "✅ HOÀN TẤT")
            loadStroke.Color = Color3.fromRGB(0, 255, 150)
            loadTitle.Text = "✅ TẢI THÀNH CÔNG"
            loadTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
        end)
        
        if not ok then
            warnLog("LỖI: " .. tostring(err))
            setProgress(0, "❌ LỖI TẢI")
            loadStroke.Color = Color3.fromRGB(255, 50, 50)
            loadTitle.Text = "❌ LỖI TẢI SCRIPT"
            loadTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
            statusText.Text = "> " .. tostring(err):sub(1, 50)
            statusText.TextColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(5)
        end
        
        task.wait(1)
        
        -- ✅ FIX: Destroy hẳn GUI (không chỉ fade)
        log("Dọn dẹp GUI")
        safetyKilled = true
        pcall(function()
            TweenService:Create(loadingFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.4, 0)}):Play()
            TweenService:Create(bgBlur, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
            for _, v in ipairs(loadingFrame:GetDescendants()) do
                if v:IsA("TextLabel") then
                    TweenService:Create(v, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
                elseif v:IsA("UIStroke") then
                    TweenService:Create(v, TweenInfo.new(0.8), {Transparency = 1}):Play()
                elseif v:IsA("Frame") then
                    TweenService:Create(v, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
                end
            end
        end)
        task.wait(1)
        gui:Destroy()
        log("Đã destroy GUI, hoàn tất")
    end)
end)

log("Loader đã sẵn sàng - chọn PC hoặc Mobile rồi bấm BẮT ĐẦU TẢI")
