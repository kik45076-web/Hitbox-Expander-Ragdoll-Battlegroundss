-- =============================================
--   HITBOX EXPANDER v2.2 — FIX (Кнопка работает)
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    Enabled = false,
    Size = 10,
    Transparency = 0.65,
    Part = "Head",
    Material = Enum.Material.ForceField,
    Color = Color3.fromRGB(255, 50, 50),
    TeamCheck = true,
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HBExpander_v2_2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 460)
Frame.Position = UDim2.new(0.5, -150, 0.5, -230)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "🔥 Hitbox Expander v2.2"
Title.TextColor3 = Color3.fromRGB(0, 255, 180)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- Toggle (исправленная версия)
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0.9, 0, 0, 55)
Toggle.Position = UDim2.new(0.05, 0, 0, 65)
Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Toggle.Text = "ВКЛЮЧИТЬ"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 18
Toggle.Font = Enum.Font.GothamBold
Toggle.Parent = Frame
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)

-- Остальные элементы (Size, Transparency и т.д.)
local function createInput(name, y, default)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.45,0,0,30)
    lbl.Position = UDim2.new(0.05,0,0,y)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(200,200,200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.45,0,0,30)
    box.Position = UDim2.new(0.52,0,0,y)
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.Text = tostring(default)
    box.TextColor3 = Color3.new(1,1,1)
    box.Parent = Frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)
    return box
end

local SizeBox = createInput("Размер:", 130, Settings.Size)
local TransBox = createInput("Прозрачность:", 170, Settings.Transparency)

local PartBtn = Instance.new("TextButton")
PartBtn.Size = UDim2.new(0.9,0,0,40)
PartBtn.Position = UDim2.new(0.05,0,0,210)
PartBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
PartBtn.Text = "Часть: Head"
PartBtn.TextColor3 = Color3.new(1,1,1)
PartBtn.Parent = Frame

local TeamBtn = Instance.new("TextButton")
TeamBtn.Size = UDim2.new(0.9,0,0,40)
TeamBtn.Position = UDim2.new(0.05,0,0,260)
TeamBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
TeamBtn.Text = "Team Check: ON"
TeamBtn.TextColor3 = Color3.new(1,1,1)
TeamBtn.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9,0,0,40)
CloseBtn.Position = UDim2.new(0.05,0,0,320)
CloseBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
CloseBtn.Text = "Закрыть GUI"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = Frame

-- ==================== ЛОГИКА ====================
local function ApplyHitbox(char)
    if not char or not char:FindFirstChild("Humanoid") then return end
    local part = char:FindFirstChild(Settings.Part)
    if not part then return end

    if not part:FindFirstChild("OriginalSize") then
        local orig = Instance.new("Vector3Value")
        orig.Name = "OriginalSize"
        orig.Value = part.Size
        orig.Parent = part
    end

    part.Size = Vector3.new(Settings.Size, Settings.Size, Settings.Size)
    part.Transparency = Settings.Transparency
    part.Material = Settings.Material
    part.Color = Settings.Color
    part.CanCollide = false
    part.Massless = true
end

local function UpdateHitboxes()
    if not Settings.Enabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if not Settings.TeamCheck or plr.Team ~= LocalPlayer.Team then
                pcall(ApplyHitbox, plr.Character)
            end
        end
    end
end

-- Надёжное включение/выключение
Toggle.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    
    if Settings.Enabled then
        Toggle.Text = "ВЫКЛЮЧИТЬ"
        Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        print("✅ Hitbox Expander ВКЛЮЧЁН")
    else
        Toggle.Text = "ВКЛЮЧИТЬ"
        Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        print("⛔ Hitbox Expander ВЫКЛЮЧЕН")
    end
end)

-- Обработчики остальных кнопок
SizeBox.FocusLost:Connect(function() 
    local n = tonumber(SizeBox.Text)
    if n and n >= 1 then Settings.Size = n end
end)

TransBox.FocusLost:Connect(function()
    local n = tonumber(TransBox.Text)
    if n then Settings.Transparency = math.clamp(n, 0, 1) end
end)

PartBtn.MouseButton1Click:Connect(function()
    Settings.Part = Settings.Part == "Head" and "HumanoidRootPart" or "Head"
    PartBtn.Text = "Часть: " .. Settings.Part
end)

TeamBtn.MouseButton1Click:Connect(function()
    Settings.TeamCheck = not Settings.TeamCheck
    TeamBtn.Text = "Team Check: " .. (Settings.TeamCheck and "ON" or "OFF")
    TeamBtn.BackgroundColor3 = Settings.TeamCheck and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Главный цикл
RunService.Heartbeat:Connect(UpdateHitboxes)

-- Авто-обновление при респавне
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.7)
        if Settings.Enabled then pcall(ApplyHitbox, char) end
    end)
end)

print("✅ Hitbox Expander v2.2 загружен! Нажми кнопку ВКЛЮЧИТЬ.")

-- Для отладки
task.spawn(function()
    task.wait(2)
    if Toggle then
        print("GUI загружен успешно. Если кнопка всё ещё не работает — напиши.")
    end
end)
