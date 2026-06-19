-- ============================================================
--              TSUM UTILITY SCRIPT  —  v1.0
--        ESP | Noclip | Insta Grab | TP Drop | Auto Farm
--       Auto Sell | Themes | Configs | Dashboard
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- ===================== НАСТРОЙКИ ПО УМОЛЧАНИЮ =====================
local Settings = {
    ESP = {
        Enabled = false,
        Mode = "Box",       -- "Box", "Corner", "Text", "Tracer"
        Color = Color3.fromRGB(255, 215, 0),
        ShowName = true,
        ShowDistance = true,
    },
    Noclip = false,
    InstaGrab = false,
    TPtoDrop = false,
    AutoFarm = false,
    AutoSell = false,
    FarmDelay = 1.2,
    SellDelay = 1.5,
    Theme = "Dark",        -- "Dark", "Light", "Blue", "Pink"
    LegendaryKeyword = "Legendary",
    ScanInterval = 2,
}

-- ===================== ЗАГРУЗКА КОНФИГА =====================
local ConfigFileName = "TSUM_Config.json"
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
screenGui.Name = "TSUMUtility"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 580)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "⚡ TSUM UTILITY"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.Parent = mainFrame

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 4)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Информационная панель (Dashboard)
local dashFrame = Instance.new("Frame")
dashFrame.Size = UDim2.new(0.94, 0, 0, 80)
dashFrame.Position = UDim2.new(0.03, 0, 0, 48)
dashFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
dashFrame.BorderSizePixel = 1
dashFrame.BorderColor3 = Color3.fromRGB(100, 100, 120)
dashFrame.Parent = mainFrame

local dashTitle = Instance.new("TextLabel")
dashTitle.Size = UDim2.new(0.3, 0, 0, 20)
dashTitle.Position = UDim2.new(0.02, 0, 0, 2)
dashTitle.Text = "📊 ДАШБОРД"
dashTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
dashTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
dashTitle.Font = Enum.Font.GothamBold
dashTitle.TextSize = 14
dashTitle.TextXAlignment = Enum.TextXAlignment.Left
dashTitle.Parent = dashFrame

local balanceLabel = Instance.new("TextLabel")
balanceLabel.Size = UDim2.new(0.4, 0, 0, 20)
balanceLabel.Position = UDim2.new(0.02, 0, 0, 22)
balanceLabel.Text = "💰 Баланс: ..."
balanceLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
balanceLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
balanceLabel.Font = Enum.Font.Gotham
balanceLabel.TextSize = 14
balanceLabel.TextXAlignment = Enum.TextXAlignment.Left
balanceLabel.Parent = dashFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.5, 0, 0, 20)
statusLabel.Position = UDim2.new(0.02, 0, 0, 42)
statusLabel.Text = "📦 Легендарок: 0"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = dashFrame

local farmStatus = Instance.new("TextLabel")
farmStatus.Size = UDim2.new(0.5, 0, 0, 20)
farmStatus.Position = UDim2.new(0.5, 0, 0, 42)
farmStatus.Text = "⏳ Фарм: Выкл"
farmStatus.TextColor3 = Color3.fromRGB(255, 200, 100)
farmStatus.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
farmStatus.Font = Enum.Font.Gotham
farmStatus.TextSize = 14
farmStatus.TextXAlignment = Enum.TextXAlignment.Left
farmStatus.Parent = dashFrame

-- Вкладки (переключение)
local tabs = {"ESP", "Телепорты", "Фарм", "Продажа", "Темы", "Конфиги"}
local currentTab = 1
local tabButtons = {}
local tabContent = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.15, 0, 0, 28)
    btn.Position = UDim2.new(0.02 + (i-1)*0.16, 0, 0, 136)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = mainFrame
    tabButtons[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = i
        for j, cont in pairs(tabContent) do
            cont.Visible = (j == i)
        end
        for j, b in pairs(tabButtons) do
            b.BackgroundColor3 = (j == i) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(50, 50, 70)
        end
    end)
end

-- Содержимое вкладок
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0.94, 0, 0, 380)
contentFrame.Position = UDim2.new(0.03, 0, 0, 172)
contentFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.2)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Вкладка ESP
local espTab = Instance.new("Frame")
espTab.Size = UDim2.new(1, 0, 1, 0)
espTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
espTab.Visible = true
espTab.Parent = contentFrame
tabContent[1] = espTab

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0.45, 0, 0, 30)
espToggle.Position = UDim2.new(0.03, 0, 0, 5)
espToggle.Text = "ESP: ВЫКЛ"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
espToggle.Font = Enum.Font.Gotham
espToggle.TextSize = 14
espToggle.Parent = espTab
espToggle.MouseButton1Click:Connect(function()
    Settings.ESP.Enabled = not Settings.ESP.Enabled
    espToggle.Text = Settings.ESP.Enabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
    saveConfig()
end)

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(0.4, 0, 0, 22)
modeLabel.Position = UDim2.new(0.03, 0, 0, 40)
modeLabel.Text = "Режим: " .. Settings.ESP.Mode
modeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
modeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = 14
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = espTab

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0.3, 0, 0, 24)
modeBtn.Position = UDim2.new(0.45, 0, 0, 40)
modeBtn.Text = "Сменить"
modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
modeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
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
    modeLabel.Text = "Режим: " .. Settings.ESP.Mode
    saveConfig()
end)

local showName = Instance.new("TextButton")
showName.Size = UDim2.new(0.45, 0, 0, 26)
showName.Position = UDim2.new(0.03, 0, 0, 70)
showName.Text = "Имя: Вкл"
showName.TextColor3 = Color3.fromRGB(255, 255, 255)
showName.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
showName.Font = Enum.Font.Gotham
showName.TextSize = 13
showName.Parent = espTab
showName.MouseButton1Click:Connect(function()
    Settings.ESP.ShowName = not Settings.ESP.ShowName
    showName.Text = Settings.ESP.ShowName and "Имя: Вкл" or "Имя: Выкл"
    saveConfig()
end)

local showDist = Instance.new("TextButton")
showDist.Size = UDim2.new(0.45, 0, 0, 26)
showDist.Position = UDim2.new(0.52, 0, 0, 70)
showDist.Text = "Дист.: Вкл"
showDist.TextColor3 = Color3.fromRGB(255, 255, 255)
showDist.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
showDist.Font = Enum.Font.Gotham
showDist.TextSize = 13
showDist.Parent = espTab
showDist.MouseButton1Click:Connect(function()
    Settings.ESP.ShowDistance = not Settings.ESP.ShowDistance
    showDist.Text = Settings.ESP.ShowDistance and "Дист.: Вкл" or "Дист.: Выкл"
    saveConfig()
end)

-- Вкладка Телепорты
local tpTab = Instance.new("Frame")
tpTab.Size = UDim2.new(1, 0, 1, 0)
tpTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
tpTab.Visible = false
tpTab.Parent = contentFrame
tabContent[2] = tpTab

local btnNoclip = Instance.new("TextButton")
btnNoclip.Size = UDim2.new(0.45, 0, 0, 30)
btnNoclip.Position = UDim2.new(0.03, 0, 0, 5)
btnNoclip.Text = "Ноклип: Выкл"
btnNoclip.TextColor3 = Color3.fromRGB(255, 255, 255)
btnNoclip.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
btnNoclip.Font = Enum.Font.Gotham
btnNoclip.TextSize = 14
btnNoclip.Parent = tpTab
btnNoclip.MouseButton1Click:Connect(function()
    Settings.Noclip = not Settings.Noclip
    btnNoclip.Text = Settings.Noclip and "Ноклип: Вкл" or "Ноклип: Выкл"
    if Settings.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
    saveConfig()
end)

local btnInstaGrab = Instance.new("TextButton")
btnInstaGrab.Size = UDim2.new(0.45, 0, 0, 30)
btnInstaGrab.Position = UDim2.new(0.52, 0, 0, 5)
btnInstaGrab.Text = "Insta Grab: Выкл"
btnInstaGrab.TextColor3 = Color3.fromRGB(255, 255, 255)
btnInstaGrab.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
btnInstaGrab.Font = Enum.Font.Gotham
btnInstaGrab.TextSize = 14
btnInstaGrab.Parent = tpTab
btnInstaGrab.MouseButton1Click:Connect(function()
    Settings.InstaGrab = not Settings.InstaGrab
    btnInstaGrab.Text = Settings.InstaGrab and "Insta Grab: Вкл" or "Insta Grab: Выкл"
    saveConfig()
end)

local btnTPdrop = Instance.new("TextButton")
btnTPdrop.Size = UDim2.new(0.45, 0, 0, 30)
btnTPdrop.Position = UDim2.new(0.03, 0, 0, 45)
btnTPdrop.Text = "ТП на дроп: Выкл"
btnTPdrop.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTPdrop.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
btnTPdrop.Font = Enum.Font.Gotham
btnTPdrop.TextSize = 14
btnTPdrop.Parent = tpTab
btnTPdrop.MouseButton1Click:Connect(function()
    Settings.TPtoDrop = not Settings.TPtoDrop
    btnTPdrop.Text = Settings.TPtoDrop and "ТП на дроп: Вкл" or "ТП на дроп: Выкл"
    saveConfig()
end)

local tpShopLabel = Instance.new("TextLabel")
tpShopLabel.Size = UDim2.new(1, 0, 0, 22)
tpShopLabel.Position = UDim2.new(0.03, 0, 0, 85)
tpShopLabel.Text = "Телепорт к магазинам:"
tpShopLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
tpShopLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
tpShopLabel.Font = Enum.Font.GothamBold
tpShopLabel.TextSize = 14
tpShopLabel.TextXAlignment = Enum.TextXAlignment.Left
tpShopLabel.Parent = tpTab

local shopNames = {"НАЗАД", "ВТОРГА", "ШОФЕРС РИН", "ВАРКА", "КАРКА"}
for i, name in ipairs(shopNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.18, 0, 0, 26)
    btn.Position = UDim2.new(0.03 + (i-1)*0.19, 0, 0, 112)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.Parent = tpTab
    btn.MouseButton1Click:Connect(function()
        teleportToShop(name)
    end)
end

-- Вкладка Фарм
local farmTab = Instance.new("Frame")
farmTab.Size = UDim2.new(1, 0, 1, 0)
farmTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
farmTab.Visible = false
farmTab.Parent = contentFrame
tabContent[3] = farmTab

local btnAutoFarm = Instance.new("TextButton")
btnAutoFarm.Size = UDim2.new(0.45, 0, 0, 30)
btnAutoFarm.Position = UDim2.new(0.03, 0, 0, 5)
btnAutoFarm.Text = "Автофарм: Выкл"
btnAutoFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAutoFarm.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
btnAutoFarm.Font = Enum.Font.Gotham
btnAutoFarm.TextSize = 14
btnAutoFarm.Parent = farmTab
btnAutoFarm.MouseButton1Click:Connect(function()
    Settings.AutoFarm = not Settings.AutoFarm
    btnAutoFarm.Text = Settings.AutoFarm and "Автофарм: Вкл" or "Автофарм: Выкл"
    if Settings.AutoFarm then
        startAutoFarm()
    else
        stopAutoFarm()
    end
    saveConfig()
end)

local farmDelaySlider = Instance.new("TextLabel")
farmDelaySlider.Size = UDim2.new(0.5, 0, 0, 22)
farmDelaySlider.Position = UDim2.new(0.03, 0, 0, 42)
farmDelaySlider.Text = "Задержка: " .. Settings.FarmDelay .. "с"
farmDelaySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
farmDelaySlider.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
farmDelaySlider.Font = Enum.Font.Gotham
farmDelaySlider.TextSize = 14
farmDelaySlider.TextXAlignment = Enum.TextXAlignment.Left
farmDelaySlider.Parent = farmTab

local delayBtn = Instance.new("TextButton")
delayBtn.Size = UDim2.new(0.2, 0, 0, 24)
delayBtn.Position = UDim2.new(0.5, 0, 0, 42)
delayBtn.Text = "+0.2"
delayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
delayBtn.Font = Enum.Font.Gotham
delayBtn.TextSize = 12
delayBtn.Parent = farmTab
delayBtn.MouseButton1Click:Connect(function()
    Settings.FarmDelay = math.min(Settings.FarmDelay + 0.2, 5)
    farmDelaySlider.Text = "Задержка: " .. Settings.FarmDelay .. "с"
    saveConfig()
end)

local delayBtn2 = Instance.new("TextButton")
delayBtn2.Size = UDim2.new(0.2, 0, 0, 24)
delayBtn2.Position = UDim2.new(0.72, 0, 0, 42)
delayBtn2.Text = "-0.2"
delayBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBtn2.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
delayBtn2.Font = Enum.Font.Gotham
delayBtn2.TextSize = 12
delayBtn2.Parent = farmTab
delayBtn2.MouseButton1Click:Connect(function()
    Settings.FarmDelay = math.max(Settings.FarmDelay - 0.2, 0.4)
    farmDelaySlider.Text = "Задержка: " .. Settings.FarmDelay .. "с"
    saveConfig()
end)

-- Вкладка Продажа
local sellTab = Instance.new("Frame")
sellTab.Size = UDim2.new(1, 0, 1, 0)
sellTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
sellTab.Visible = false
sellTab.Parent = contentFrame
tabContent[4] = sellTab

local btnAutoSell = Instance.new("TextButton")
btnAutoSell.Size = UDim2.new(0.45, 0, 0, 30)
btnAutoSell.Position = UDim2.new(0.03, 0, 0, 5)
btnAutoSell.Text = "Автопродажа: Выкл"
btnAutoSell.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAutoSell.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
btnAutoSell.Font = Enum.Font.Gotham
btnAutoSell.TextSize = 14
btnAutoSell.Parent = sellTab
btnAutoSell.MouseButton1Click:Connect(function()
    Settings.AutoSell = not Settings.AutoSell
    btnAutoSell.Text = Settings.AutoSell and "Автопродажа: Вкл" or "Автопродажа: Выкл"
    if Settings.AutoSell then
        startAutoSell()
    else
        stopAutoSell()
    end
    saveConfig()
end)

local sellDelaySlider = Instance.new("TextLabel")
sellDelaySlider.Size = UDim2.new(0.5, 0, 0, 22)
sellDelaySlider.Position = UDim2.new(0.03, 0, 0, 42)
sellDelaySlider.Text = "Задержка: " .. Settings.SellDelay .. "с"
sellDelaySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
sellDelaySlider.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
sellDelaySlider.Font = Enum.Font.Gotham
sellDelaySlider.TextSize = 14
sellDelaySlider.TextXAlignment = Enum.TextXAlignment.Left
sellDelaySlider.Parent = sellTab

local sellDelayBtn = Instance.new("TextButton")
sellDelayBtn.Size = UDim2.new(0.2, 0, 0, 24)
sellDelayBtn.Position = UDim2.new(0.5, 0, 0, 42)
sellDelayBtn.Text = "+0.2"
sellDelayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sellDelayBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
sellDelayBtn.Font = Enum.Font.Gotham
sellDelayBtn.TextSize = 12
sellDelayBtn.Parent = sellTab
sellDelayBtn.MouseButton1Click:Connect(function()
    Settings.SellDelay = math.min(Settings.SellDelay + 0.2, 5)
    sellDelaySlider.Text = "Задержка: " .. Settings.SellDelay .. "с"
    saveConfig()
end)

local sellDelayBtn2 = Instance.new("TextButton")
sellDelayBtn2.Size = UDim2.new(0.2, 0, 0, 24)
sellDelayBtn2.Position = UDim2.new(0.72, 0, 0, 42)
sellDelayBtn2.Text = "-0.2"
sellDelayBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
sellDelayBtn2.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
sellDelayBtn2.Font = Enum.Font.Gotham
sellDelayBtn2.TextSize = 12
sellDelayBtn2.Parent = sellTab
sellDelayBtn2.MouseButton1Click:Connect(function()
    Settings.SellDelay = math.max(Settings.SellDelay - 0.2, 0.4)
    sellDelaySlider.Text = "Задержка: " .. Settings.SellDelay .. "с"
    saveConfig()
end)

-- Вкладка Темы
local themeTab = Instance.new("Frame")
themeTab.Size = UDim2.new(1, 0, 1, 0)
themeTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
themeTab.Visible = false
themeTab.Parent = contentFrame
tabContent[5] = themeTab

local themeList = {"Dark", "Light", "Blue", "Pink"}
for i, th in ipairs(themeList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.22, 0, 0, 30)
    btn.Position = UDim2.new(0.03 + (i-1)*0.24, 0, 0, 5 + math.floor((i-1)/4)*40)
    btn.Text = th
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = (th == Settings.Theme) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(50, 50, 70)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = themeTab
    btn.MouseButton1Click:Connect(function()
        Settings.Theme = th
        applyTheme(th)
        saveConfig()
        for _, b in pairs(themeTab:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = (b.Text == th) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(50, 50, 70)
            end
        end
    end)
end

-- Вкладка Конфиги
local configTab = Instance.new("Frame")
configTab.Size = UDim2.new(1, 0, 1, 0)
configTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
configTab.Visible = false
configTab.Parent = contentFrame
tabContent[6] = configTab

local saveConfBtn = Instance.new("TextButton")
saveConfBtn.Size = UDim2.new(0.45, 0, 0, 30)
saveConfBtn.Position = UDim2.new(0.03, 0, 0, 5)
saveConfBtn.Text = "Сохранить конфиг"
saveConfBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveConfBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
saveConfBtn.Font = Enum.Font.Gotham
saveConfBtn.TextSize = 14
saveConfBtn.Parent = configTab
saveConfBtn.MouseButton1Click:Connect(function()
    saveConfig()
    print("✅ Конфиг сохранён")
end)

local loadConfBtn = Instance.new("TextButton")
loadConfBtn.Size = UDim2.new(0.45, 0, 0, 30)
loadConfBtn.Position = UDim2.new(0.52, 0, 0, 5)
loadConfBtn.Text = "Загрузить конфиг"
loadConfBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadConfBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
loadConfBtn.Font = Enum.Font.Gotham
loadConfBtn.TextSize = 14
loadConfBtn.Parent = configTab
loadConfBtn.MouseButton1Click:Connect(function()
    loadConfig()
    print("✅ Конфиг загружен")
    -- Обновить UI
    updateUI()
end)

-- ===================== ФУНКЦИИ =====================

-- Телепорты
local function teleportTo(pos)
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(pos) end
end

local function teleportToShop(name)
    local shops = Workspace:FindFirstChild("Shops") or Workspace
    for _, obj in pairs(shops:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, name) then
            teleportTo(obj:GetPivot().Position)
            return true
        end
    end
    return false
end

-- Поиск легендарок
local function findLegendaries()
    local items = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, Settings.LegendaryKeyword) then
            table.insert(items, obj)
        end
    end
    return items
end

-- Получение баланса
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

-- Insta Grab
local function instaGrab(item)
    if not Settings.InstaGrab then return end
    local clickDetector = item:FindFirstChild("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
    else
        local remote = ReplicatedStorage:FindFirstChild("GrabItem")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(item)
        end
    end
end

-- ТП на дроп (автоматический)
local function tpToDrop()
    if not Settings.TPtoDrop then return end
    local drops = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, "Drop") then
            table.insert(drops, obj)
        end
    end
    if #drops > 0 then
        teleportTo(drops[1]:GetPivot().Position)
    end
end

-- ESP (обновляется в цикле)
local espObjects = {}
local function createESP(item)
    if espObjects[item] then return end
    local box, corner, tracer, text
    if Settings.ESP.Mode == "Box" or Settings.ESP.Mode == "Corner" then
        box = Drawing.new("Square")
        box.Color = Settings.ESP.Color
        box.Thickness = 2
        box.Filled = false
        box.Visible = false
    end
    if Settings.ESP.Mode == "Tracer" then
        tracer = Drawing.new("Line")
        tracer.Color = Settings.ESP.Color
        tracer.Thickness = 1.5
        tracer.Visible = false
    end
    text = Drawing.new("Text")
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0)
    text.Visible = false
    espObjects[item] = { box = box, corner = corner, tracer = tracer, text = text }
end

local function updateESP()
    if not Settings.ESP.Enabled then
        for _, esp in pairs(espObjects) do
            if esp.box then esp.box.Visible = false end
            if esp.tracer then esp.tracer.Visible = false end
            esp.text.Visible = false
        end
        return
    end
    local items = findLegendaries()
    local current = {}
    for _, item in pairs(items) do
        local pos = item:GetPivot().Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
        if onScreen then
            createESP(item)
            local esp = espObjects[item]
            if Settings.ESP.Mode == "Box" then
                local size = 3
                esp.box.Size = Vector2.new(size * 20, size * 30)
                esp.box.Position = Vector2.new(screenPos.X - size * 10, screenPos.Y - size * 15)
                esp.box.Visible = true
            elseif Settings.ESP.Mode == "Tracer" then
                esp.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                esp.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                esp.tracer.Visible = true
            end
            local txt = ""
            if Settings.ESP.ShowName then txt = txt .. item.Name end
            if Settings.ESP.ShowDistance then
                local dist = (LocalPlayer.Character and LocalPlayer.Character:GetPivot().Position - pos).Magnitude
                txt = txt .. " [" .. math.floor(dist) .. "m]"
            end
            esp.text.Text = txt
            esp.text.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
            esp.text.Visible = true
            current[item] = true
        end
    end
    for item, esp in pairs(espObjects) do
        if not current[item] then
            if esp.box then esp.box.Visible = false end
            if esp.tracer then esp.tracer.Visible = false end
            esp.text.Visible = false
        end
    end
end

-- Автофарм
local farmRunning = false
local farmCoroutine

local function startAutoFarm()
    if farmRunning then return end
    farmRunning = true
    farmCoroutine = coroutine.create(function()
        while farmRunning do
            local items = findLegendaries()
            if #items > 0 then
                for _, item in pairs(items) do
                    teleportTo(item:GetPivot().Position)
                    if Settings.InstaGrab then
                        instaGrab(item)
                    end
                    wait(Settings.FarmDelay)
                end
            else
                wait(0.5)
            end
        end
    end)
    coroutine.resume(farmCoroutine)
end

local function stopAutoFarm()
    farmRunning = false
end

-- Автопродажа
local sellRunning = false
local sellCoroutine

local function startAutoSell()
    if sellRunning then return end
    sellRunning = true
    sellCoroutine = coroutine.create(function()
        while sellRunning do
            -- Ищем в инвентаре предметы (обычно в LocalPlayer:FindFirstChild("Inventory") или в Backpack)
            local inv = LocalPlayer:FindFirstChild("Inventory") or LocalPlayer:FindFirstChild("Backpack")
            if inv then
                for _, item in pairs(inv:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Model") then
                        -- Пытаемся продать через RemoteEvent
                        local sellRemote = ReplicatedStorage:FindFirstChild("SellItem")
                        if sellRemote and sellRemote:IsA("RemoteEvent") then
                            sellRemote:FireServer(item)
                        elseif sellRemote and sellRemote:IsA("RemoteFunction") then
                            sellRemote:InvokeServer(item)
                        end
                        wait(Settings.SellDelay)
                    end
                end
            end
            wait(1)
        end
    end)
    coroutine.resume(sellCoroutine)
end

local function stopAutoSell()
    sellRunning = false
end

-- Темы
local function applyTheme(theme)
    local colors = {
        Dark = { bg = Color3.fromRGB(20,20,35), border = Color3.fromRGB(255,215,0), text = Color3.fromRGB(255,255,255) },
        Light = { bg = Color3.fromRGB(220,220,230), border = Color3.fromRGB(0,0,0), text = Color3.fromRGB(0,0,0) },
        Blue = { bg = Color3.fromRGB(10,20,50), border = Color3.fromRGB(100,180,255), text = Color3.fromRGB(255,255,255) },
        Pink = { bg = Color3.fromRGB(50,10,40), border = Color3.fromRGB(255,100,200), text = Color3.fromRGB(255,255,255) },
    }
    local c = colors[theme] or colors.Dark
    mainFrame.BackgroundColor3 = c.bg
    mainFrame.BorderColor3 = c.border
    title.TextColor3 = c.border
    for _, btn in pairs(tabButtons) do
        btn.TextColor3 = c.text
        btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
    end
end

-- Обновление UI после загрузки конфига
local function updateUI()
    espToggle.Text = Settings.ESP.Enabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
    modeLabel.Text = "Режим: " .. Settings.ESP.Mode
    showName.Text = Settings.ESP.ShowName and "Имя: Вкл" or "Имя: Выкл"
    showDist.Text = Settings.ESP.ShowDistance and "Дист.: Вкл" or "Дист.: Выкл"
    btnNoclip.Text = Settings.Noclip and "Ноклип: Вкл" or "Ноклип: Выкл"
    btnInstaGrab.Text = Settings.InstaGrab and "Insta Grab: Вкл" or "Insta Grab: Выкл"
    btnTPdrop.Text = Settings.TPtoDrop and "ТП на дроп: Вкл" or "ТП на дроп: Выкл"
    btnAutoFarm.Text = Settings.AutoFarm and "Автофарм: Вкл" or "Автофарм: Выкл"
    btnAutoSell.Text = Settings.AutoSell and "Автопродажа: Вкл" or "Автопродажа: Выкл"
    farmDelaySlider.Text = "Задержка: " .. Settings.FarmDelay .. "с"
    sellDelaySlider.Text = "Задержка: " .. Settings.SellDelay .. "с"
    applyTheme(Settings.Theme)
end

-- ===================== ОСНОВНОЙ ЦИКЛ =====================
spawn(function()
    while task.wait(Settings.ScanInterval) do
        local bal = getBalance()
        if bal then balanceLabel.Text = "💰 Баланс: " .. bal .. " МБ" end
        local items = findLegendaries()
        statusLabel.Text = "📦 Легендарок: " .. #items
        if Settings.AutoFarm then
            farmStatus.Text = "⏳ Фарм: Вкл"
        else
            farmStatus.Text = "⏳ Фарм: Выкл"
        end
    end
end)

-- Обновление ESP (раз в 5 кадров)
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if frameCount % 5 == 0 then
        updateESP()
        if Settings.TPtoDrop then
            tpToDrop()
        end
    end
end)

-- Горячие клавиши
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.CapsLock then
        screenGui.Enabled = not screenGui.Enabled
    end
    if input.KeyCode == Enum.KeyCode.E then
        teleportToShop("ВАРКА")
    end
    if input.KeyCode == Enum.KeyCode.R then
        teleportToShop("КАРКА")
    end
    if input.KeyCode == Enum.KeyCode.Q then
        Settings.InstaGrab = not Settings.InstaGrab
        btnInstaGrab.Text = Settings.InstaGrab and "Insta Grab: Вкл" or "Insta Grab: Выкл"
        saveConfig()
    end
    if input.KeyCode == Enum.KeyCode.X then
        Settings.Noclip = not Settings.Noclip
        btnNoclip.Text = Settings.Noclip and "Ноклип: Вкл" or "Ноклип: Выкл"
        if Settings.Noclip then
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
        saveConfig()
    end
end)

updateUI()
print("✅ TSUM Utility загружен. CapsLock — открыть/закрыть UI.")
print("E — Варка | R — Карка | Q — Insta Grab | X — Ноклип")
