-- LocalScript (Запускай через Executor)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Создаём стильный GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "StealthHUD"
GUI.ResetOnSpawn = false
GUI.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 220)
Frame.Position = UDim2.new(0.5, -160, 0.3, -110)
Frame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
Frame.BackgroundTransparency = 0.5
Frame.BorderSizePixel = 0

-- Закруглённые углы
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.5
Stroke.Color = Color3.new(0.4, 0.7, 1)
Stroke.Transparency = 0.3
Stroke.Parent = Frame

Frame.Parent = GUI

local Title = Instance.new("TextLabel")
Title.Text = "COPY AVATAR v2.6"
Title.TextColor3 = Color3.new(0.4, 0.8, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0.05, 0)
Title.BackgroundTransparency = 1
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.8, 0, 0, 36)
TextBox.Position = UDim2.new(0.1, 0, 0.25, 0)
TextBox.PlaceholderText = "Введите ник цели..."
TextBox.BackgroundTransparency = 0.7
TextBox.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 16

local TBCorner = Instance.new("UICorner")
TBCorner.CornerRadius = UDim.new(0, 8)
TBCorner.Parent = TextBox
TextBox.Parent = Frame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0.65, 0, 0, 38)
CopyButton.Position = UDim2.new(0.175, 0, 0.5, 0)
CopyButton.Text = "СТАРТ КОПИРОВАНИЯ"
CopyButton.BackgroundColor3 = Color3.new(0, 0.4, 0.8)
CopyButton.BackgroundTransparency = 0.3
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.Font = Enum.Font.GothamSemibold
CopyButton.TextSize = 16
CopyButton.AutoButtonColor = false

local CopyBtnCorner = Instance.new("UICorner")
CopyBtnCorner.CornerRadius = UDim.new(0, 10)
CopyBtnCorner.Parent = CopyButton
CopyButton.Parent = Frame

-- Кнопка для возврата своего скина
local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(0.65, 0, 0, 38)
ResetButton.Position = UDim2.new(0.175, 0, 0.7, 0)
ResetButton.Text = "ВЕРНУТЬ СВОЙ СКИН"
ResetButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
ResetButton.BackgroundTransparency = 0.3
ResetButton.TextColor3 = Color3.new(1, 1, 1)
ResetButton.Font = Enum.Font.GothamSemibold
ResetButton.TextSize = 16
ResetButton.AutoButtonColor = false

local ResetBtnCorner = Instance.new("UICorner")
ResetBtnCorner.CornerRadius = UDim.new(0, 10)
ResetBtnCorner.Parent = ResetButton
ResetButton.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.8, 0, 0, 24)
Status.Position = UDim2.new(0.1, 0, 0.9, 0)
Status.Text = "Ожидание цели..."
Status.TextColor3 = Color3.new(0.7, 1, 0.9)
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.BackgroundTransparency = 1
Status.Parent = Frame

-- Переменные для хранения данных
local originalAppearance = nil
local currentCopiedUserId = nil
local player = Players.LocalPlayer

-- Анимация кнопок
local function setupButtonAnimation(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            TextSize = 17
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.3,
            TextSize = 16
        }):Play()
    end)
end

setupButtonAnimation(CopyButton)
setupButtonAnimation(ResetButton)

-- Сохраняем оригинальный внешний вид
local function saveOriginalAppearance()
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            originalAppearance = humanoid:GetAppliedDescription()
            Status.Text = "💾 Оригинальный скин сохранён"
        end
    end
end

-- Вызываем при старте
saveOriginalAppearance()

-- Функция для создания Blocky Body
local function applyBlockyBody(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return false
    end
    
    -- Создаём Blocky Body через HumanoidDescription
    local blockyDescription = Instance.new("HumanoidDescription")
    
    -- Устанавливаем Blocky масштаб тела
    blockyDescription.BodyTypeScale = 1
    blockyDescription.DepthScale = 1
    blockyDescription.HeadScale = 1
    blockyDescription.HeightScale = 1
    blockyDescription.ProportionScale = 0
    blockyDescription.WidthScale = 1
    
    -- Применяем Blocky тело
    humanoid:ApplyDescriptionClientServer(blockyDescription)
    
    return true
end

-- Функция для удаления всей одежды и аксессуаров
local function removeAllClothingAndAccessories(character)
    local itemsRemoved = 0
    
    -- Удаляем аксессуары
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Hat") or item:IsA("HairAccessory") then
            item:Destroy()
            itemsRemoved = itemsRemoved + 1
        end
    end
    
    -- Удаляем одежду (майки, штаны, шорты, кофты и т.д.)
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
            item:Destroy()
            itemsRemoved = itemsRemoved + 1
        end
    end
    
    -- Рекурсивный поиск во всех потомках
    for _, item in pairs(character:GetDescendants()) do
        if item:IsA("Accessory") or item:IsA("Hat") or item:IsA("HairAccessory") or 
           item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
            item:Destroy()
            itemsRemoved = itemsRemoved + 1
        end
    end
    
    return itemsRemoved
end

-- Функция для получения ID пользователя по нику (работает для любого игрока)
local function getUserIdFromUsername(username)
    Status.Text = "🌐 Поиск ID через Roblox API..."
    
    local success, result = pcall(function()
        -- Пробуем стандартный метод
        return Players:GetUserIdFromNameAsync(username)
    end)
    
    if not success then
        -- Если стандартный метод не работает, пробуем через HTTP
        Status.Text = "🔧 Альтернативный поиск ID..."
        local httpSuccess, httpResult = pcall(function()
            local response = game:HttpGet("https://api.roblox.com/users/get-by-username?username=" .. username)
            local data = HttpService:JSONDecode(response)
            if data and data.Id then
                return data.Id
            end
        end)
        
        if httpSuccess and httpResult then
            return httpResult
        else
            error("Не удалось найти игрока: " .. username)
        end
    end
    
    return result
end

-- Функция для копирования аватара через HumanoidDescription
local function copyAvatarThroughDescription(userId)
    Status.Text = "📦 Получение данных аватара..."
    
    local description = Players:GetHumanoidDescriptionFromUserId(userId)
    if not description then
        error("Не удалось получить описание аватара")
    end
    
    local character = player.Character
    if not character then
        error("Персонаж не найден")
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        error("Humanoid не найден")
    end
    
    -- Применяем Blocky Body
    Status.Text = "🔲 Применяю Blocky Body..."
    applyBlockyBody(character)
    task.wait(0.3)
    
    -- Удаляем всю одежду и аксессуары
    Status.Text = "🧹 Удаляю одежду и аксессуары..."
    local removedCount = removeAllClothingAndAccessories(character)
    Status.Text = "🗑️ Удалено предметов: "..removedCount
    task.wait(0.5)
    
    -- Применяем описание аватара
    Status.Text = "🎨 Применяю аватар..."
    humanoid:ApplyDescriptionClientServer(description)
    
    return true
end

-- Функция для применения аватара после respawn
local function applyCopiedAvatar()
    if currentCopiedUserId then
        task.wait(1) -- Ждём появления персонажа
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local description = Players:GetHumanoidDescriptionFromUserId(currentCopiedUserId)
                -- Применяем Blocky Body перед копированием
                applyBlockyBody(player.Character)
                removeAllClothingAndAccessories(player.Character)
                humanoid:ApplyDescriptionClientServer(description)
                Status.Text = "♻️ Аватар восстановлен после смерти"
            end
        end
    end
end

-- Слушаем смерть персонажа
player.CharacterAdded:Connect(function(character)
    if currentCopiedUserId then
        applyCopiedAvatar()
    end
end)

-- Основная функция копирования
local function copyAvatarByUsername(username)
    Status.Text = "🔍 Поиск: "..username
    
    -- Получаем UserId
    local userId = getUserIdFromUsername(username)
    Status.Text = "✅ ID найден: "..userId
    
    -- Сохраняем текущий скин если ещё не сохранён
    if not originalAppearance then
        saveOriginalAppearance()
    end
    
    -- Копируем аватар
    local success = copyAvatarThroughDescription(userId)
    
    if success then
        currentCopiedUserId = userId
        Status.Text = "✨ Аватар скопирован!"
        task.wait(1.5)
        Status.Text = "✅ Готово! Аватар сохранится после смерти"
    end
end

-- Функция для возврата своего скина
local function resetToOriginalAppearance()
    if originalAppearance then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Удаляем текущую одежду и аксессуары
                removeAllClothingAndAccessories(character)
                -- Применяем оригинальное описание
                humanoid:ApplyDescriptionClientServer(originalAppearance)
                currentCopiedUserId = nil
                Status.Text = "🔙 Скин возвращён к оригинальному"
                task.wait(1.5)
                Status.Text = "Ожидание цели..."
            end
        end
    else
        Status.Text = "❌ Оригинальный скин не сохранён"
    end
end

-- Обработка ошибок
local function safeCopyAvatar(username)
    local success, errorMsg = pcall(function()
        copyAvatarByUsername(username)
    end)
    
    if not success then
        Status.Text = "❌ Ошибка: " .. tostring(errorMsg)
        task.wait(2)
        Status.Text = "Введите ник и попробуйте снова"
    end
end

CopyButton.MouseButton1Click:Connect(function()
    local targetName = TextBox.Text
    if targetName and targetName ~= "" then
        safeCopyAvatar(targetName)
    else
        Status.Text = "⚠️ Введите ник игрока"
        task.wait(1.5)
        Status.Text = "Ожидание цели..."
    end
end)

ResetButton.MouseButton1Click:Connect(function()
    resetToOriginalAppearance()
end)

-- Плавное перетаскивание
local dragging, dragStart, dragPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        dragPos = Frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset + delta.X, dragPos.Y.Scale, dragPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.new(1, 0.3, 0.4)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = Frame

CloseBtn.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- Авто-фокус на текстовое поле
task.wait(1)
TextBox:CaptureFocus()

-- Обработка нажатия Enter
TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local targetName = TextBox.Text
        if targetName and targetName ~= "" then
            safeCopyAvatar(targetName)
        end
    end
end)
