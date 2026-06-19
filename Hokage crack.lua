-- ============================================================
--              MONOLITH X TSUM  —  Colaba Style
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- ===================== НАСТРОЙКИ =====================
local Settings = {
    ESP = { Enabled = false, Mode = "Box", Color = Color3.fromRGB(255, 215, 0) },
    Misc = { Noclip = false, Speed = 16 },
    Autoloot = { Enabled = false, Delay = 1.2 },
    Theme = { Accent = Color3.fromRGB(255, 215, 0), Background = Color3.fromRGB(20, 20, 35), Floral = false },
    Configs = { Current = "Default" },
}

local ConfigFileName = "Monolith_Config.json"

-- ===================== ЗАГРУЗКА КОНФИГА =====================
local function loadConfig()
    if readfile then
        local success, data = pcall(readfile, ConfigFileName)
        if success and data then
            local decoded = HttpService:JSONDecode(data)
            if decoded then
                for k, v in pairs(decoded) do
                    if type(v) == "table" and Settings[k] then
                        for k2, v2 in pairs(v) do Settings[k][k2] = v2 end
                    else
                        Settings[k] = v
                    end
                end
            end
        end
    end
end
loadConfig()

local function saveConfig()
    if writefile then
        local encoded = HttpService:JSONEncode(Settings)
        pcall(writefile, ConfigFileName, encoded)
    end
end

-- ===================== UI =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MonolithUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 520)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
mainFrame.BackgroundColor3 = Settings.Theme.Background
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Settings.Theme.Accent
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Monolith x Tsum Colaba"
title.TextColor3 = Settings.Theme.Accent
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

-- Закрытие
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ===================== ВКЛАДКИ =====================
local tabs = {"Menu", "ESP", "Misc", "Autoloot", "Settings"}
local currentTab = 1
local tabButtons = {}
local tabContents = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.18, 0, 0, 30)
    btn.Position = UDim2.new(0.02 + (i-1)*0.19, 0, 0, 46)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = (i == 1) and Settings.Theme.Accent or Color3.fromRGB(40, 40, 60)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = mainFrame
    tabButtons[i] = btn
    btn.MouseButton1Click:Connect(function()
        currentTab = i
        for j, cont in pairs(tabContents) do
            cont.Visible = (j == i)
        end
        for j, b in pairs(tabButtons) do
            b.BackgroundColor3 = (j == i) and Settings.Theme.Accent or Color3.fromRGB(40, 40, 60)
        end
    end)
end

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0.94, 0, 0, 410)
contentFrame.Position = UDim2.new(0.03, 0, 0, 82)
contentFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.2)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- ===================== ВКЛАДКА MENU =====================
local menuTab = Instance.new("Frame")
menuTab.Size = UDim2.new(1, 0, 1, 0)
menuTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
menuTab.Visible = true
menuTab.Parent = contentFrame
tabContents[1] = menuTab

local menuLabel = Instance.new("TextLabel")
menuLabel.Size = UDim2.new(1, 0, 0, 30)
menuLabel.Position = UDim2.new(0, 0, 0, 10)
menuLabel.Text = "📊 Dashboard"
menuLabel.TextColor3 = Settings.Theme.Accent
menuLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
menuLabel.Font = Enum.Font.GothamBold
menuLabel.TextSize = 18
menuLabel.TextXAlignment = Enum.TextXAlignment.Left
menuLabel.Parent = menuTab

local balLabel = Instance.new("TextLabel")
balLabel.Size = UDim2.new(0.5, 0, 0, 24)
balLabel.Position = UDim2.new(0, 5, 0, 45)
balLabel.Text = "💰 Balance: ..."
balLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
balLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
balLabel.Font = Enum.Font.Gotham
balLabel.TextSize = 15
balLabel.TextXAlignment = Enum.TextXAlignment.Left
balLabel.Parent = menuTab

local foundLabel = Instance.new("TextLabel")
foundLabel.Size = UDim2.new(0.5, 0, 0, 24)
foundLabel.Position = UDim2.new(0, 5, 0, 70)
foundLabel.Text = "📦 Legendaries: 0"
foundLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
foundLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
foundLabel.Font = Enum.Font.Gotham
foundLabel.TextSize = 15
foundLabel.TextXAlignment = Enum.TextXAlignment.Left
foundLabel.Parent = menuTab

local lootLabel = Instance.new("TextLabel")
lootLabel.Size = UDim2.new(0.5, 0, 0, 24)
lootLabel.Position = UDim2.new(0, 5, 0, 95)
lootLabel.Text = "⏳ Autoloot: Off"
lootLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
lootLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
lootLabel.Font = Enum.Font.Gotham
lootLabel.TextSize = 15
lootLabel.TextXAlignment = Enum.TextXAlignment.Left
lootLabel.Parent = menuTab

-- ===================== ВКЛАДКА ESP =====================
local espTab = Instance.new("Frame")
espTab.Size = UDim2.new(1, 0, 1, 0)
espTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
espTab.Visible = false
espTab.Parent = contentFrame
tabContents[2] = espTab

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0.45, 0, 0, 30)
espToggle.Position = UDim2.new(0.03, 0, 0, 10)
espToggle.Text = "ESP: OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
espToggle.Font = Enum.Font.Gotham
espToggle.TextSize = 14
espToggle.Parent = espTab
espToggle.MouseButton1Click:Connect(function()
    Settings.ESP.Enabled = not Settings.ESP.Enabled
    espToggle.Text = Settings.ESP.Enabled and "ESP: ON" or "ESP: OFF"
    saveConfig()
end)

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(0.4, 0, 0, 22)
modeLabel.Position = UDim2.new(0.03, 0, 0, 46)
modeLabel.Text = "Mode: " .. Settings.ESP.Mode
modeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
modeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = 14
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = espTab

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0.3, 0, 0, 24)
modeBtn.Position = UDim2.new(0.45, 0, 0, 46)
modeBtn.Text = "Change"
modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
modeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
modeBtn.Font = Enum.Font.Gotham
modeBtn.TextSize = 12
modeBtn.Parent = espTab
modeBtn.MouseButton1Click:Connect(function()
    local modes = {"Box", "Corner", "Text", "Tracer"}
    for i, m in ipairs(modes) do
        if m == Settings.ESP.Mode then
            local next = (i % #modes) + 1
            Settings.ESP.Mode = modes[next]
            break
        end
    end
    modeLabel.Text = "Mode: " .. Settings.ESP.Mode
    saveConfig()
end)

local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(0.3, 0, 0, 24)
colorBtn.Position = UDim2.new(0.45, 0, 0, 76)
colorBtn.Text = "Change Color"
colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
colorBtn.Font = Enum.Font.Gotham
colorBtn.TextSize = 12
colorBtn.Parent = espTab
colorBtn.MouseButton1Click:Connect(function()
    local colors = {
        Color3.fromRGB(255, 215, 0),
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 150, 255),
        Color3.fromRGB(255, 0, 255),
    }
    for i, c in ipairs(colors) do
        if c == Settings.ESP.Color then
            local next = (i % #colors) + 1
            Settings.ESP.Color = colors[next]
            break
        end
    end
    saveConfig()
end)

-- ===================== ВКЛАДКА MISC =====================
local miscTab = Instance.new("Frame")
miscTab.Size = UDim2.new(1, 0, 1, 0)
miscTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
miscTab.Visible = false
miscTab.Parent = contentFrame
tabContents[3] = miscTab

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.45, 0, 0, 30)
noclipBtn.Position = UDim2.new(0.03, 0, 0, 10)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.TextSize = 14
noclipBtn.Parent = miscTab
noclipBtn.MouseButton1Click:Connect(function()
    Settings.Misc.Noclip = not Settings.Misc.Noclip
    noclipBtn.Text = Settings.Misc.Noclip and "Noclip: ON" or "Noclip: OFF"
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not Settings.Misc.Noclip
            end
        end
    end
    saveConfig()
end)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0, 22)
speedLabel.Position = UDim2.new(0.03, 0, 0, 46)
speedLabel.Text = "Speed: " .. Settings.Misc.Speed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = miscTab

local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.15, 0, 0, 24)
speedUp.Position = UDim2.new(0.4, 0, 0, 46)
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedUp.Font = Enum.Font.Gotham
speedUp.TextSize = 16
speedUp.Parent = miscTab
speedUp.MouseButton1Click:Connect(function()
    Settings.Misc.Speed = math.min(Settings.Misc.Speed + 2, 100)
    speedLabel.Text = "Speed: " .. Settings.Misc.Speed
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Settings.Misc.Speed
    end
    saveConfig()
end)

local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.15, 0, 0, 24)
speedDown.Position = UDim2.new(0.55, 0, 0, 46)
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedDown.Font = Enum.Font.Gotham
speedDown.TextSize = 16
speedDown.Parent = miscTab
speedDown.MouseButton1Click:Connect(function()
    Settings.Misc.Speed = math.max(Settings.Misc.Speed - 2, 10)
    speedLabel.Text = "Speed: " .. Settings.Misc.Speed
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Settings.Misc.Speed
    end
    saveConfig()
end)

-- ===================== ВКЛАДКА AUTOLOOT =====================
local lootTab = Instance.new("Frame")
lootTab.Size = UDim2.new(1, 0, 1, 0)
lootTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
lootTab.Visible = false
lootTab.Parent = contentFrame
tabContents[4] = lootTab

local lootToggle = Instance.new("TextButton")
lootToggle.Size = UDim2.new(0.45, 0, 0, 30)
lootToggle.Position = UDim2.new(0.03, 0, 0, 10)
lootToggle.Text = "Autoloot: OFF"
lootToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
lootToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
lootToggle.Font = Enum.Font.Gotham
lootToggle.TextSize = 14
lootToggle.Parent = lootTab
lootToggle.MouseButton1Click:Connect(function()
    Settings.Autoloot.Enabled = not Settings.Autoloot.Enabled
    lootToggle.Text = Settings.Autoloot.Enabled and "Autoloot: ON" or "Autoloot: OFF"
    if Settings.Autoloot.Enabled then
        startAutoloot()
    else
        stopAutoloot()
    end
    saveConfig()
end)

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0.4, 0, 0, 22)
delayLabel.Position = UDim2.new(0.03, 0, 0, 46)
delayLabel.Text = "Delay: " .. Settings.Autoloot.Delay .. "s"
delayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
delayLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 14
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = lootTab

local delayUp = Instance.new("TextButton")
delayUp.Size = UDim2.new(0.15, 0, 0, 24)
delayUp.Position = UDim2.new(0.4, 0, 0, 46)
delayUp.Text = "+"
delayUp.TextColor3 = Color3.fromRGB(255, 255, 255)
delayUp.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
delayUp.Font = Enum.Font.Gotham
delayUp.TextSize = 16
delayUp.Parent = lootTab
delayUp.MouseButton1Click:Connect(function()
    Settings.Autoloot.Delay = math.min(Settings.Autoloot.Delay + 0.2, 5)
    delayLabel.Text = "Delay: " .. Settings.Autoloot.Delay .. "s"
    saveConfig()
end)

local delayDown = Instance.new("TextButton")
delayDown.Size = UDim2.new(0.15, 0, 0, 24)
delayDown.Position = UDim2.new(0.55, 0, 0, 46)
delayDown.Text = "-"
delayDown.TextColor3 = Color3.fromRGB(255, 255, 255)
delayDown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
delayDown.Font = Enum.Font.Gotham
delayDown.TextSize = 16
delayDown.Parent = lootTab
delayDown.MouseButton1Click:Connect(function()
    Settings.Autoloot.Delay = math.max(Settings.Autoloot.Delay - 0.2, 0.4)
    delayLabel.Text = "Delay: " .. Settings.Autoloot.Delay .. "s"
    saveConfig()
end)

-- ===================== ВКЛАДКА SETTINGS =====================
local settingsTab = Instance.new("Frame")
settingsTab.Size = UDim2.new(1, 0, 1, 0)
settingsTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
settingsTab.Visible = false
settingsTab.Parent = contentFrame
tabContents[5] = settingsTab

-- Accent Color
local accLabel = Instance.new("TextLabel")
accLabel.Size = UDim2.new(0.5, 0, 0, 22)
accLabel.Position = UDim2.new(0.03, 0, 0, 10)
accLabel.Text = "Accent Color"
accLabel.TextColor3 = Settings.Theme.Accent
accLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
accLabel.Font = Enum.Font.GothamBold
accLabel.TextSize = 14
accLabel.TextXAlignment = Enum.TextXAlignment.Left
accLabel.Parent = settingsTab

local accBtn = Instance.new("TextButton")
accBtn.Size = UDim2.new(0.3, 0, 0, 24)
accBtn.Position = UDim2.new(0.5, 0, 0, 10)
accBtn.Text = "Change"
accBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
accBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
accBtn.Font = Enum.Font.Gotham
accBtn.TextSize = 12
accBtn.Parent = settingsTab
accBtn.MouseButton1Click:Connect(function()
    local colors = {
        Color3.fromRGB(255, 215, 0),
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 150, 255),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(255, 165, 0),
    }
    for i, c in ipairs(colors) do
        if c == Settings.Theme.Accent then
            local next = (i % #colors) + 1
            Settings.Theme.Accent = colors[next]
            break
        end
    end
    applyTheme()
    saveConfig()
end)

-- Background
local bgLabel = Instance.new("TextLabel")
bgLabel.Size = UDim2.new(0.5, 0, 0, 22)
bgLabel.Position = UDim2.new(0.03, 0, 0, 42)
bgLabel.Text = "Background"
bgLabel.TextColor3 = Settings.Theme.Accent
bgLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
bgLabel.Font = Enum.Font.GothamBold
bgLabel.TextSize = 14
bgLabel.TextXAlignment = Enum.TextXAlignment.Left
bgLabel.Parent = settingsTab

local bgBtn = Instance.new("TextButton")
bgBtn.Size = UDim2.new(0.3, 0, 0, 24)
bgBtn.Position = UDim2.new(0.5, 0, 0, 42)
bgBtn.Text = "Change"
bgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bgBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
bgBtn.Font = Enum.Font.Gotham
bgBtn.TextSize = 12
bgBtn.Parent = settingsTab
bgBtn.MouseButton1Click:Connect(function()
    local bgColors = {
        Color3.fromRGB(20, 20, 35),
        Color3.fromRGB(10, 10, 20),
        Color3.fromRGB(40, 40, 50),
        Color3.fromRGB(30, 20, 40),
    }
    for i, c in ipairs(bgColors) do
        if c == Settings.Theme.Background then
            local next = (i % #bgColors) + 1
            Settings.Theme.Background = bgColors[next]
            break
        end
    end
    applyTheme()
    saveConfig()
end)

-- Floral (Toggle)
local floralBtn = Instance.new("TextButton")
floralBtn.Size = UDim2.new(0.45, 0, 0, 30)
floralBtn.Position = UDim2.new(0.03, 0, 0, 76)
floralBtn.Text = Settings.Theme.Floral and "Floral: ON" or "Floral: OFF"
floralBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floralBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
floralBtn.Font = Enum.Font.Gotham
floralBtn.TextSize = 14
floralBtn.Parent = settingsTab
floralBtn.MouseButton1Click:Connect(function()
    Settings.Theme.Floral = not Settings.Theme.Floral
    floralBtn.Text = Settings.Theme.Floral and "Floral: ON" or "Floral: OFF"
    applyTheme()
    saveConfig()
end)

-- ===================== КОНФИГИ =====================
local configSection = Instance.new("Frame")
configSection.Size = UDim2.new(1, 0, 0, 140)
configSection.Position = UDim2.new(0, 0, 0, 120)
configSection.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
configSection.BorderSizePixel = 1
configSection.BorderColor3 = Color3.fromRGB(80, 80, 100)
configSection.Parent = settingsTab

local confTitle = Instance.new("TextLabel")
confTitle.Size = UDim2.new(1, 0, 0, 22)
confTitle.Position = UDim2.new(0, 5, 0, 2)
confTitle.Text = "Configs"
confTitle.TextColor3 = Settings.Theme.Accent
confTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
confTitle.Font = Enum.Font.GothamBold
confTitle.TextSize = 14
confTitle.TextXAlignment = Enum.TextXAlignment.Left
confTitle.Parent = configSection

local confNameBox = Instance.new("TextBox")
confNameBox.Size = UDim2.new(0.4, 0, 0, 24)
confNameBox.Position = UDim2.new(0.03, 0, 0, 28)
confNameBox.Text = "config name"
confNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
confNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
confNameBox.Font = Enum.Font.Gotham
confNameBox.TextSize = 13
confNameBox.PlaceholderText = "config name"
confNameBox.Parent = configSection

local confList = Instance.new("TextBox")
confList.Size = UDim2.new(0.4, 0, 0, 24)
confList.Position = UDim2.new(0.5, 0, 0, 28)
confList.Text = "config list"
confList.TextColor3 = Color3.fromRGB(255, 255, 255)
confList.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
confList.Font = Enum.Font.Gotham
confList.TextSize = 13
confList.PlaceholderText = "config list"
confList.Parent = configSection

local function createConfigBtn(text, x, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.15, 0, 0, 24)
    btn.Position = UDim2.new(x, 0, y, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = configSection
    btn.MouseButton1Click:Connect(callback)
end

createConfigBtn("Create", 0.03, 0.62, function()
    Settings.Configs.Current = confNameBox.Text
    saveConfig()
    print("✅ Config saved as: " .. confNameBox.Text)
end)

createConfigBtn("Save", 0.2, 0.62, function()
    saveConfig()
    print("✅ Config saved")
end)

createConfigBtn("Load", 0.37, 0.62, function()
    loadConfig()
    applyTheme()
    updateUI()
    print("✅ Config loaded")
end)

createConfigBtn("Delete", 0.54, 0.62, function()
    if writefile then
        pcall(function() writefile(ConfigFileName, "") end)
        print("🗑️ Config deleted")
    end
end)

-- ===================== ФУНКЦИИ =====================

local function findLegendaries()
    local items = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, "Legendary") then
            table.insert(items, obj)
        end
    end
    return items
end

local function getBalance()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        local cash = ls:FindFirstChild("Cash") or ls:FindFirstChild("Coins")
        if cash then return cash.Value end
    end
    local remote = ReplicatedStorage:FindFirstChild("GetBalance")
    if remote and remote:IsA("RemoteFunction") then
        local success, result = pcall(remote.InvokeServer, remote)
        if success then return result end
    end
    return nil
end

local function teleportTo(pos)
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(pos) end
end

local function instaGrab(item)
    local cd = item:FindFirstChild("ClickDetector")
    if cd then fireclickdetector(cd) end
end

local espObjects = {}
local function updateESP()
    if not Settings.ESP.Enabled then
        for _, esp in pairs(espObjects) do
            if esp.box then esp.box.Visible = false end
            if esp.tracer then esp.tracer.Visible = false end
            if esp.text then esp.text.Visible = false end
        end
        return
    end
    local items = findLegendaries()
    local current = {}
    for _, item in pairs(items) do
        local pos = item:GetPivot().Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
        if onScreen then
            if not espObjects[item] then
                local box = Drawing.new("Square")
                box.Color = Settings.ESP.Color
                box.Thickness = 2
                box.Filled = false
                box.Visible = false
                local text = Drawing.new("Text")
                text.Color = Color3.fromRGB(255, 255, 255)
                text.Size = 14
                text.Center = true
                text.Outline = true
                text.OutlineColor = Color3.fromRGB(0, 0, 0)
                text.Visible = false
                espObjects[item] = { box = box, text = text }
            end
            local esp = espObjects[item]
            if Settings.ESP.Mode == "Box" then
                local size = 3
                esp.box.Size = Vector2.new(size * 20, size * 30)
                esp.box.Position = Vector2.new(screenPos.X - size * 10, screenPos.Y - size * 15)
                esp.box.Visible = true
            else
                esp.box.Visible = false
            end
            local dist = (LocalPlayer.Character and LocalPlayer.Character:GetPivot().Position - pos).Magnitude
            esp.text.Text = item.Name .. " [" .. math.floor(dist) .. "m]"
            esp.text.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
            esp.text.Visible = true
            current[item] = true
        end
    end
    for item, esp in pairs(espObjects) do
        if not current[item] then
            esp.box.Visible = false
            esp.text.Visible = false
        end
    end
end

local lootRunning = false
local function startAutoloot()
    if lootRunning then return end
    lootRunning = true
    spawn(function()
        while lootRunning do
            local items = findLegendaries()
            if #items > 0 then
                for _, item in pairs(items) do
                    teleportTo(item:GetPivot().Position)
                    instaGrab(item)
                    wait(Settings.Autoloot.Delay)
                end
            else
                wait(0.5)
            end
        end
    end)
end

local function stopAutoloot()
    lootRunning = false
end

local function applyTheme()
    mainFrame.BackgroundColor3 = Settings.Theme.Background
    mainFrame.BorderColor3 = Settings.Theme.Accent
    title.TextColor3 = Settings.Theme.Accent
    for i, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (i == currentTab) and Settings.Theme.Accent or Color3.fromRGB(40, 40, 60)
    end
    if Settings.Theme.Floral then
        -- добавить флоральный паттерн (упрощённо: меняем фон на что-то)
        mainFrame.BackgroundColor3 = Settings.Theme.Background:Lerp(Color3.fromRGB(255, 200, 200), 0.1)
    end
end

local function updateUI()
    espToggle.Text = Settings.ESP.Enabled and "ESP: ON" or "ESP: OFF"
    modeLabel.Text = "Mode: " .. Settings.ESP.Mode
    noclipBtn.Text = Settings.Misc.Noclip and "Noclip: ON" or "Noclip: OFF"
    speedLabel.Text = "Speed: " .. Settings.Misc.Speed
    lootToggle.Text = Settings.Autoloot.Enabled and "Autoloot: ON" or "Autoloot: OFF"
    delayLabel.Text = "Delay: " .. Settings.Autoloot.Delay .. "s"
    floralBtn.Text = Settings.Theme.Floral and "Floral: ON" or "Floral: OFF"
    applyTheme()
end

-- ===================== ЦИКЛЫ =====================
spawn(function()
    while task.wait(2) do
        local bal = getBalance()
        if bal then balLabel.Text = "💰 Balance: " .. bal .. " MB" end
        local items = findLegendaries()
        foundLabel.Text = "📦 Legendaries: " .. #items
        lootLabel.Text = Settings.Autoloot.Enabled and "⏳ Autoloot: ON" or "⏳ Autoloot: OFF"
    end
end)

local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if frameCount % 5 == 0 then
        updateESP()
    end
end)

-- ===================== ГОРЯЧИЕ КЛАВИШИ =====================
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.CapsLock then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

updateUI()
print("✅ Monolith x Tsum Colaba loaded. CapsLock — toggle UI.")
