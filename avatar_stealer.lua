-- LocalScript (Запускай через Executor)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Создаём стильный GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "StealthHUD"
GUI.ResetOnSpawn = false
GUI.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 180)
Frame.Position = UDim2.new(0.5, -160, 0.3, -90)
Frame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
Frame.BackgroundTransparency = 0.5 -- Прозрачность
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
Title.Text = "COPY AVATAR v2.0"
Title.TextColor3 = Color3.new(0.4, 0.8, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0.05, 0)
Title.BackgroundTransparency = 1
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.8, 0, 0, 36)
TextBox.Position = UDim2.new(0.1, 0, 0.3, 0)
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

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.65, 0, 0, 42)
Button.Position = UDim2.new(0.175, 0, 0.6, 0)
Button.Text = "СТАРТ КОПИРОВАНИЯ"
Button.BackgroundColor3 = Color3.new(0, 0.4, 0.8)
Button.BackgroundTransparency = 0.3
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.GothamSemibold
Button.TextSize = 16
Button.AutoButtonColor = false

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = Button
Button.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.8, 0, 0, 24)
Status.Position = UDim2.new(0.1, 0, 0.85, 0)
Status.Text = "Ожидание цели..."
Status.TextColor3 = Color3.new(0.7, 1, 0.9)
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.BackgroundTransparency = 1
Status.Parent = Frame

-- Анимация кнопки
Button.MouseEnter:Connect(function()
    TweenService:Create(Button, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2,
        TextSize = 17
    }):Play()
end)

Button.MouseLeave:Connect(function()
    TweenService:Create(Button, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.3,
        TextSize = 16
    }):Play()
end)

-- Функция копирования
local function copyAvatar(username)
    Status.Text = "🔍 Поиск: "..username
    pcall(function()
        local UserId = Players:GetUserIdFromNameAsync(username)
        Status.Text = "✅ ID найден: "..UserId
        
        local player = Players.LocalPlayer
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local description = Players:GetHumanoidDescriptionFromUserId(UserId)
                humanoid:ApplyDescriptionClientServer(description)
                
                player.CharacterAppearanceLoaded:Connect(function(char)
                    char:SetAttribute("LocalOnly", true)
                end)
                
                Status.Text = "✨ Аватар скопирован!"
                task.wait(1.5)
                GUI:Destroy()
            end
        end
    end)
end

Button.MouseButton1Click:Connect(function()
    copyAvatar(TextBox.Text)
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