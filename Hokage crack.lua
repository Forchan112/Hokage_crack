-- ============================================================
--                   HOKAGE SCRIPT [TSUM]
--          Статус | Баланс | Телепорт | ESP | Скан
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    LegendaryKeyword = "Legendary",
    TeleportCooldown = 2,
    ScanInterval = 1,
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HokageUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(0, 350, 0, 500)
bg.Position = UDim2.new(0.5, -175, 0.5, -250)
bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
bg.BorderSizePixel = 2
bg.BorderColor3 = Color3.fromRGB(255, 215, 0)
bg.Active = true
bg.Draggable = true
bg.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "⚡ HOKAGE ⚡"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = bg

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 45)
statusLabel.Text = "🔍 СТАТУС: НЕТ ЛЕГЕНДАРОВ"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 16
statusLabel.Parent = bg

local foundLabel = Instance.new("TextLabel")
foundLabel.Size = UDim2.new(1, 0, 0, 25)
foundLabel.Position = UDim2.new(0, 0, 0, 75)
foundLabel.Text = "📦 НАЙДЕНО: 0"
foundLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
foundLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.2)
foundLabel.Font = Enum.Font.Gotham
foundLabel.TextSize = 15
foundLabel.Parent = bg

local balanceLabel = Instance.new("TextLabel")
balanceLabel.Size = UDim2.new(1, 0, 0, 25)
balanceLabel.Position = UDim2.new(0, 0, 0, 100)
balanceLabel.Text = "💰 ВАЛЮТА: ЗАГРУЗКА..."
balanceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
balanceLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.2)
balanceLabel.Font = Enum.Font.Gotham
balanceLabel.TextSize = 15
balanceLabel.Parent = bg

local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.new(1, 0, 0, 25)
shopTitle.Position = UDim2.new(0, 0, 0, 135)
shopTitle.Text = "🏪 ТЕЛЕПОРТ ПО МАГАЗИНАМ"
shopTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
shopTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
shopTitle.Font = Enum.Font.GothamBold
shopTitle.TextSize = 14
shopTitle.Parent = bg

local shops = {"НАЗАД", "ВТОРГА", "ШОФЕРС РИН"}
local shopButtons = {}
for i, shopName in ipairs(shops) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0, 30)
    btn.Position = UDim2.new(0.03 + (i-1)*0.33, 0, 0, 165)
    btn.Text = shopName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = bg
    shopButtons[shopName] = btn
end

local warpTitle = Instance.new("TextLabel")
warpTitle.Size = UDim2.new(1, 0, 0, 25)
warpTitle.Position = UDim2.new(0, 0, 0, 205)
warpTitle.Text = "👤 ТЕЛЕПОРТ К ПРОДАВЦУ"
warpTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
warpTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
warpTitle.Font = Enum.Font.GothamBold
warpTitle.TextSize = 14
warpTitle.Parent = bg

local warpBtn = Instance.new("TextButton")
warpBtn.Size = UDim2.new(0.4, 0, 0, 30)
warpBtn.Position = UDim2.new(0.05, 0, 0, 235)
warpBtn.Text = "🚀 ТЕЛЕПОРТ"
warpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
warpBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
warpBtn.Font = Enum.Font.Gotham
warpBtn.TextSize = 14
warpBtn.Parent = bg

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.4, 0, 0, 30)
espBtn.Position = UDim2.new(0.55, 0, 0, 235)
espBtn.Text = "👁 ESP: ВКЛ"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
espBtn.Font = Enum.Font.Gotham
espBtn.TextSize = 14
espBtn.Parent = bg

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.4, 0, 0, 30)
scanBtn.Position = UDim2.new(0.05, 0, 0, 275)
scanBtn.Text = "🔍 СКАН"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
scanBtn.Font = Enum.Font.Gotham
scanBtn.TextSize = 14
scanBtn.Parent = bg

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.4, 0, 0, 30)
noclipBtn.Position = UDim2.new(0.55, 0, 0, 275)
noclipBtn.Text = "🌀 НОКЛИЧ: ВЫКЛ"
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
noclipBtn.Font = Enum.Font.Gotham
noclipBtn.TextSize = 14
noclipBtn.Parent = bg

local freeTitle = Instance.new("TextLabel")
freeTitle.Size = UDim2.new(1, 0, 0, 25)
freeTitle.Position = UDim2.new(0, 0, 0, 315)
freeTitle.Text = "👥 СВОБОДНЫЕ ПЕРСОНАЖИ"
freeTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
freeTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.3)
freeTitle.Font = Enum.Font.GothamBold
freeTitle.TextSize = 14
freeTitle.Parent = bg

local freeCount = Instance.new("TextLabel")
freeCount.Size = UDim2.new(1, 0, 0, 25)
freeCount.Position = UDim2.new(0, 0, 0, 340)
freeCount.Text = "16 | 5 | 5"
freeCount.TextColor3 = Color3.fromRGB(255, 255, 255)
freeCount.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0.2)
freeCount.Font = Enum.Font.Gotham
freeCount.TextSize = 15
freeCount.Parent = bg

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = bg
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local function getBalance()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        local cash = ls:FindFirstChild("Cash") or ls:FindFirstChild("Coins")
        if cash then return cash.Value end
    end
    local remote = ReplicatedStorage:FindFirstChild("GetBalance")
    if remote and remote:IsA("RemoteFunction") then
        local success, result = pcall(function()
            return remote:InvokeServer()
        end)
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

local function teleportToShop(shopName)
    local shops = Workspace:FindFirstChild("Shops") or Workspace
    for _, obj in pairs(shops:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, shopName) then
            teleportTo(obj:GetPivot().Position)
            return true
        end
    end
    return false
end

local function teleportToVarka()
    local npcs = Workspace:FindFirstChild("NPCs") or Workspace
    for _, obj in pairs(npcs:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, "Varka") then
            teleportTo(obj:GetPivot().Position)
            return true
        end
    end
    return false
end

local espObjects = {}
local espEnabled = true

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
    local items = findLegendaries()
    local currentItems = {}
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
            currentItems[item] = true
        end
    end
    for item, esp in pairs(espObjects) do
        if not currentItems[item] then
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
    if noclipEnabled then
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
end

for shopName, btn in pairs(shopButtons) do
    btn.MouseButton1Click:Connect(function()
        if teleportToShop(shopName) then
            print("🚀 Телепорт к: " .. shopName)
        else
            print("❌ Магазин не найден: " .. shopName)
        end
    end)
end

warpBtn.MouseButton1Click:Connect(function()
    if teleportToVarka() then
        print("🚀 Телепорт к Варка-продавцу")
    else
        print("❌ Варка не найден")
    end
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "👁 ESP: ВКЛ" or "👁 ESP: ВЫКЛ"
end)

scanBtn.MouseButton1Click:Connect(function()
    scan()
    print("🔍 Скан выполнен")
end)

noclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

RunService.RenderStepped:Connect(updateESP)

spawn(function()
    while task.wait(Settings.ScanInterval) do
        scan()
    end
end)

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        screenGui.Enabled = not screenGui.Enabled
    end
    if input.KeyCode == Enum.KeyCode.E then
        teleportToVarka()
    end
    if input.KeyCode == Enum.KeyCode.Q then
        scan()
    end
    if input.KeyCode == Enum.KeyCode.X then
        toggleNoclip()
    end
end)

print("✅ HOKAGE SCRIPT загружен!")
print("🔹 Insert - показать/скрыть UI")
print("🔹 E - телепорт к продавцу")
print("🔹 Q - скан")
print("🔹 X - ноклич")