--[[ 
    LOADING SCREEN - SUPER LUCK DESTROYER
    Tự động nhận diện Mobile/PC và load đúng phiên bản
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ⚙️ CẤU HÌNH URL (sửa tại đây nếu có 2 file riêng)
local CONFIG = {
    MobileURL = "https://raw.githubusercontent.com/duongvantrong18102012-cmd/SUPER-LUCK-DESTROYER/refs/heads/main/mobile.lua", -- đổi thành mobile.lua nếu có
    PCURL     = "https://raw.githubusercontent.com/duongvantrong18102012-cmd/SUPER-LUCK-DESTROYER/refs/heads/main/pc.lua",
}

-- 📱 Nhận diện nền tảng
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isPC     = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
local platformName = isMobile and "📱 MOBILE" or (isPC and "💻 PC" or "🕹️ CONSOLE")
local scriptURL    = isMobile and CONFIG.MobileURL or CONFIG.PCURL

-- 🎨 Tạo GUI Loading
local existing = CoreGui:FindFirstChild("SLD_Loading") or playerGui:FindFirstChild("SLD_Loading")
if existing then existing:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "SLD_Loading"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = (gethui and gethui()) or CoreGui

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
bg.BorderSizePixel = 0
bg.Parent = gui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 20, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 15, 40)),
}
bgGradient.Rotation = 45
bgGradient.Parent = bg

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.9, 0, 0, 50)
title.Position = UDim2.new(0.05, 0, 0.32, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ SUPER LUCK DESTROYER ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Parent = bg

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(0, 200, 255)
titleStroke.Thickness = 2
titleStroke.Transparency = 0.3
titleStroke.Parent = title

-- Platform label
local platformLabel = Instance.new("TextLabel")
platformLabel.Size = UDim2.new(0.9, 0, 0, 24)
platformLabel.Position = UDim2.new(0.05, 0, 0.42, 0)
platformLabel.BackgroundTransparency = 1
platformLabel.Text = "Đang tải phiên bản: " .. platformName
platformLabel.TextColor3 = Color3.fromRGB(100, 220, 255)
platformLabel.Font = Enum.Font.GothamSemibold
platformLabel.TextScaled = true
platformLabel.Parent = bg

-- Status text
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.9, 0, 0, 20)
statusText.Position = UDim2.new(0.05, 0, 0.47, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Đang khởi tạo..."
statusText.TextColor3 = Color3.fromRGB(180, 180, 200)
statusText.Font = Enum.Font.Gotham
statusText.TextScaled = true
statusText.Parent = bg

-- Progress bar background
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.6, 0, 0, 10)
barBg.Position = UDim2.new(0.2, 0, 0.55, 0)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
barBg.BorderSizePixel = 0
barBg.Parent = bg

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBg

-- Fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = barFill

local fillGradient = Instance.new("UIGradient")
fillGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255)),
}
fillGradient.Parent = barFill

-- Percentage
local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0.6, 0, 0, 22)
percentText.Position = UDim2.new(0.2, 0, 0.58, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentText.Font = Enum.Font.GothamBold
percentText.TextSize = 16
percentText.Parent = bg

-- Hàm cập nhật tiến trình
local function setProgress(p)
    TweenService:Create(barFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Size = UDim2.new(p, 0, 1, 0)
    }):Play()
    percentText.Text = math.floor(p * 100) .. "%"
end

-- Animation loading
local steps = {
    {0.15, "Kiểm tra nền tảng..."},
    {0.30, "Kết nối server..."},
    {0.50, "Tải script chính..."},
    {0.70, "Xác thực dữ liệu..."},
    {0.85, "Khởi tạo module..."},
    {1.00, "Hoàn tất!"},
}

for _, step in ipairs(steps) do
    task.wait(0.18)
    setProgress(step[1])
    statusText.Text = step[2]
end

-- 🚀 Load script theo nền tảng
task.spawn(function()
    task.wait(0.3)
    local ok, err = pcall(function()
        local code = game:HttpGet(scriptURL)
        local fn = loadstring(code)
        if not fn then error("loadstring trả về nil") end
        fn()
    end)

    if ok then
        title.Text = "✅ TẢI THÀNH CÔNG"
        title.TextColor3 = Color3.fromRGB(100, 255, 150)
        statusText.Text = "Phiên bản " .. platformName .. " đã sẵn sàng"
    else
        title.Text = "❌ LỖI TẢI SCRIPT"
        title.TextColor3 = Color3.fromRGB(255, 90, 90)
        statusText.Text = tostring(err):sub(1, 80)
    end

    task.wait(1.2)

    -- Fade out mượt
    local fadeTime = 0.6
    TweenService:Create(bg, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
    for _, v in ipairs(bg:GetDescendants()) do
        if v:IsA("TextLabel") then
            TweenService:Create(v, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
        elseif v:IsA("Frame") and v ~= bg then
            TweenService:Create(v, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
        elseif v:IsA("UIStroke") then
            TweenService:Create(v, TweenInfo.new(fadeTime), {Transparency = 1}):Play()
        end
    end
    task.wait(fadeTime + 0.1)
    gui:Destroy()
end)
