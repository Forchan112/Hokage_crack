-- ============================================================
--              HOKAGE SCRIPT [TSUM]  —  v2.1
--            Интерфейс точь-в-точь, прозрачный, заголовок справа
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- ===================== НАСТРОЙКИ =====================
local Settings = {
    LegendaryKeyword = "Legendary",
    TeleportCooldown = 1.5,
    ScanInterval = 2,
    SpeedValue = 16,
    ESPUpdateRate = 4,
}

-- ===================== UI (полупрозрачный, заголовок справа) =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HokageUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 530)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -265)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BackgroundTransparency = 0.25   -- прозрачный фон
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок HOKAGE (прижат к правому краю)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 0, 40)
title.Position = UDim2.new(0.5, 20, 0, 0)   -- смещён вправо
title.Text = "HOKAGE"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Right
title.Parent = mainFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 28)
statusLabel.Position = UDim2.new(0, 0, 0, 45)
statusLabel.Text = "❌ СТАТУС: НЕТ ЛЕГЕНДАРОВ"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 15
statusLabel.Parent = mainFrame

-- Найдено
local foundLabel = Instance.new("TextLabel")
foundLabel.Size = UDim2.new(1, 0, 0, 24)
foundLabel.Position = UDim2.new(0, 0, 0, 75)
foundLabel.Text = "📦 НАЙДЕНО: 0"
foundLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
foundLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
foundLabel.Font = Enum.Font.Gotham
foundLabel.TextSize = 15
foundLabel.Parent = mainFrame

-- Баланс
local balanceLabel = Instance.new("TextLabel")
balanceLabel.Size = UDim2.new(1, 0, 0, 24)
balanceLabel.Position = UDim2.new(0, 0, 0, 100)
balanceLabel.Text = "💰 ВАЛЮТА: ЗАГРУЗКА..."
balanceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
balanceLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
balanceLabel.Font = Enum.Font.Gotham
balanceLabel.TextSize = 15
balanceLabel.Parent = mainFrame

-- Разделитель
local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 130)
line.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
line.Parent = mainFrame

-- Телепорт по магазинам
local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.new(1, 0, 0, 24)
shopTitle.Position = UDim2.new(0, 0, 0, 140)
shopTitle.Text = "🏪 ТЕЛЕПОРТ ПО МАГАЗИНАМ"
shopTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
shopTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
shopTitle.Font = Enum.Font.GothamBold
shopTitle.TextSize = 14
shopTitle.Parent = mainFrame

local shops = {"НАЗАД", "ВТОРГА", "ШОФЕРС РИН"}
local shopBtns = {}
for i, name in ipairs(shops) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0, 30)
    btn.Position = UDim2.new(0.03 + (i-1)*0.33, 0, 0, 170)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = mainFrame
    shopBtns[name] = btn
end

-- Кнопки "ТЕЛЕПОРТ К ВАРКА" и "ТЕЛЕПОРТ К КАРКА"
local warpVarka = Instance.new("TextButton")
warpVarka.Size = UDim2.new(0.42, 0, 0, 30)
warpVarka.Position = UDim2.new(0.05, 0, 0, 210)
warpVarka.Text = "🚀 ТЕЛЕПОРТ К ВАРКА"
warpVarka.TextColor3 = Color3.fromRGB(255, 255, 255)
warpVarka.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
warpVarka.Font = Enum.Font.Gotham
warpVarka.TextSize = 12
warpVarka.Parent = mainFrame

local warpKarka = Instance.new("TextButton")
warpKarka.Size = UDim2.new(0.42, 0, 0, 30)
warpKarka.Position = UDim2.new(0.53, 0, 0, 210)
warpKarka.Text = "🚀 ТЕЛЕПОРТ К КАРКА"
warpKarka.TextColor3 = Color3.fromRGB(255, 255, 255)
warpKarka.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
warpKarka.Font = Enum.Font.Gotham
warpKarka.TextSize = 12
warpKarka.Parent = mainFrame

-- ESP, Скан, Ноклип
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.28, 0, 0, 30)
espBtn.Position = UDim2.new(0.03, 0, 0, 250)
espBtn.Text = "👁 ESP: ВКЛ"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
espBtn.Font = Enum.Font.Gotham
espBtn.TextSize = 13
espBtn.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.28, 0, 0, 30)
scanBtn.Position = UDim2.new(0.36, 0, 0, 250)
scanBtn.Text = "🔍 СКАН"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
scanBtn.Font = Enum.Font.Gotham
scanBtn.TextSize = 13
scanBtn.Parent = mainFrame

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.28, 0, 0, 30)
noclipBtn.Position = UDim2.new(0.69, 0, 0, 250)
noclipBtn.Text = "🌀 НОКЛИЧ: ВЫКЛ"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.TextSize = 13
noclipBtn.Parent = mainFrame

-- Регулировка скорости (слайдер)
local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(0.5, 0, 0, 24)
speedTitle.Position = UDim2.new(0.03, 0, 0, 290)
speedTitle.Text = "🏃 СКОРОСТЬ: " .. Settings.SpeedValue
speedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
speedTitle.Font = Enum.Font.Gotham
speedTitle.TextSize = 14
speedTitle.Parent = mainFrame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0.6, 0, 0, 8)
speedSlider.Position = UDim2.new(0.03, 0, 0, 318)
speedSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = mainFrame

local speedFill = Instance.new("Frame")
speedFill.Size = UDim2.new((Settings.SpeedValue - 10) / 90, 0, 1, 0)
speedFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
speedFill.BorderSizePixel = 0
speedFill.Parent = speedSlider

-- Свободные персонажи
local freeTitle = Instance.new("TextLabel")
freeTitle.Size = UDim2.new(1, 0, 0, 24)
freeTitle.Position = UDim2.new(0, 0, 0, 340)
freeTitle.Text = "👥 СВОБОДНЫЕ ПЕРСОНАЖИ"
freeTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
freeTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
freeTitle.Font = Enum.Font.GothamBold
freeTitle.TextSize = 14
freeTitle.Parent = mainFrame

local freeCount = Instance.new("TextLabel")
freeCount.Size = UDim2.new(1, 0, 0, 24)
freeCount.Position = UDim2.new(0, 0, 0, 365)
freeCount.Text = "16 | 5 | 5"
freeCount.TextColor3 = Color3.fromRGB(255, 255, 255)
freeCount.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.2)
freeCount.Font = Enum.Font.Gotham
freeCount.TextSize = 16
freeCount.Parent = mainFrame

-- Подпись внизу (как на скрине)
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 0, 395)
footer.Text = "Создаем скрипт... Специально для фарма в TSUM (скоро релиз)"
footer.TextColor3 = Color3.fromRGB(200, 200, 200)
footer.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.2)
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextWrapped = true
footer.Parent = mainFrame

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- (остальной код без изменений — функции те же, что и в v2.0)

-- ===================== ФУНКЦИИ =====================

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

local function findLegendaries()
    local items = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, Settings.LegendaryKeyword) then
            table.insert(items, obj)
        end
    end
    return items
end

local function teleportTo(pos)
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
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

local function teleportToNPC(npcName)
    local npcs = Workspace:FindFirstChild("NPCs") or Workspace
    for _, obj in pairs(npcs:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, npcName) then
            teleportTo(obj:GetPivot().Position)
            return true
        end
    end
    return false
end

local espObjects = {}
local espEnabled = true
local frameCounter = 0

local function createESP(item)
    if espObjects[item] then return end
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 215, 0)
    box.Thickness = 2
    box.Filled = false
    box.Visible = true
    local text = Drawing.new("Text")
    text.Text = item.Name
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0)
    text.Visible = true
    espObjects[item] = { box = box, text = text }
end

local function updateESP()
    if not espEnabled then
        for _, esp in pairs(espObjects) do
            esp.box.Visible = false
            esp.text.Visible = false
        end
        return
    end
    frameCounter = frameCounter + 1
    if frameCounter % Settings.ESPUpdateRate ~= 0 then return end
    local items = findLegendaries()
    local current = {}
    for _, item in pairs(items) do
        local pos = item:GetPivot().Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
        if onScreen then
            createESP(item)
            local esp = espObjects[item]
            esp.text.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
            esp.text.Visible = true
            local size = 3
            esp.box.Size = Vector2.new(size * 20, size * 30)
            esp.box.Position = Vector2.new(screenPos.X - size * 10, screenPos.Y - size * 15)
            esp.box.Visible = true
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

local function scan()
    local items = findLegendaries()
    local count = #items
    foundLabel.Text = "📦 НАЙДЕНО: " .. count
    if count > 0 then
        statusLabel.Text = "✅ СТАТУС: НАЙДЕНЫ ЛЕГЕНДАРКИ!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        statusLabel.Text = "❌ СТАТУС: НЕТ ЛЕГЕНДАРОВ"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    local balance = getBalance()
    if balance then
        balanceLabel.Text = "💰 ВАЛЮТА: " .. balance .. " МБ"
    end
end

local noclipEnabled = false
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    noclipBtn.Text = noclipEnabled and "🌀 НОКЛИЧ: ВКЛ" or "🌀 НОКЛИЧ: ВЫКЛ"
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled
            end
        end
    end
end

local function setSpeed(value)
    Settings.SpeedValue = math.clamp(value, 10, 100)
    speedTitle.Text = "🏃 СКОРОСТЬ: " .. Settings.SpeedValue
    speedFill.Size = UDim2.new((Settings.SpeedValue - 10) / 90, 0, 1, 0)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = Settings.SpeedValue
        end
    end
end

-- Обработка слайдера
local dragging = false
local function onSliderClick(x)
    local relativeX = (x - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X
    local value = 10 + relativeX * 90
    setSpeed(value)
end

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        onSliderClick(input.Position.X)
    end
end)
speedSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        onSliderClick(input.Position.X)
    end
end)

-- ===================== ПРИВЯЗКА КНОПОК =====================
for name, btn in pairs(shopBtns) do
    btn.MouseButton1Click:Connect(function()
        teleportToShop(name)
    end)
end

warpVarka.MouseButton1Click:Connect(function()
    teleportToNPC("Varka")
end)

warpKarka.MouseButton1Click:Connect(function()
    teleportToNPC("Karka")
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "👁 ESP: ВКЛ" or "👁 ESP: ВЫКЛ"
end)

scanBtn.MouseButton1Click:Connect(function()
    scan()
end)

noclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

-- ===================== ЦИКЛЫ =====================
RunService.RenderStepped:Connect(updateESP)

spawn(function()
    while task.wait(Settings.ScanInterval) do
        scan()
    end
end)

-- ===================== ГОРЯЧИЕ КЛАВИШИ =====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        screenGui.Enabled = not screenGui.Enabled
    end
    if input.KeyCode == Enum.KeyCode.E then
        teleportToNPC("Varka")
    end
    if input.KeyCode == Enum.KeyCode.R then
        teleportToNPC("Karka")
    end
    if input.KeyCode == Enum.KeyCode.Q then
        scan()
    end
    if input.KeyCode == Enum.KeyCode.X then
        toggleNoclip()
    end
end)

-- ===================== ИНИЦИАЛИЗАЦИЯ =====================
setSpeed(Settings.SpeedValue)
print("✅ HOKAGE v2.1 загружен. Интерфейс как на скрине.")
print("Insert — UI | E — Варка | R — Карка | Q — скан | X — ноклип")
