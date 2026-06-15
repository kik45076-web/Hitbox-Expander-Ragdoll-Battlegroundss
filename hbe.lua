-- =============================================
--   HITBOX EXPANDER v2.3 — FIX (Без лагов движения)
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    Enabled = false,
    Size = 10,
    Transparency = 0.7,
    TargetPart = "Head",           -- Head или HumanoidRootPart
    Material = Enum.Material.ForceField,
    Color = Color3.fromRGB(255, 60, 60),
    TeamCheck = true,
}

local FakeHitboxes = {}  -- храним созданные фейковые hitbox'ы

-- GUI (оставил почти такой же)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 310, 0, 480)
Frame.Position = UDim2.new(0.5, -155, 0.5, -240)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Hitbox Expander v2.3"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0.9,0,0,55)
Toggle.Position = UDim2.new(0.05,0,0,60)
Toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
Toggle.Text = "ВКЛЮЧИТЬ"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 18
Toggle.Font = Enum.Font.GothamBold
Toggle.Parent = Frame
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,8)

-- Inputs
local function createBox(text, y, def)
    local l = Instance.new("TextLabel", Frame)
    l.Size = UDim2.new(0.45,0,0,30)
    l.Position = UDim2.new(0.05,0,0,y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(190,190,190)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local b = Instance.new("TextBox", Frame)
    b.Size = UDim2.new(0.45,0,0,30)
    b.Position = UDim2.new(0.52,0,0,y)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.Text = tostring(def)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

local SizeBox = createBox("Размер:", 130, Settings.Size)
local TransBox = createBox("Прозрачность:", 170, Settings.Transparency)

local PartBtn = Instance.new("TextButton")
PartBtn.Size = UDim2.new(0.9,0,0,42)
PartBtn.Position = UDim2.new(0.05,0,0,210)
PartBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
PartBtn.Text = "Цель: Head"
PartBtn.TextColor3 = Color3.new(1,1,1)
PartBtn.Parent = Frame

local TeamBtn = Instance.new("TextButton")
TeamBtn.Size = UDim2.new(0.9,0,0,42)
TeamBtn.Position = UDim2.new(0.05,0,0,260)
TeamBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
TeamBtn.Text = "Team Check: ON"
TeamBtn.TextColor3 = Color3.new(1,1,1)
TeamBtn.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9,0,0,42)
CloseBtn.Position = UDim2.new(0.05,0,0,320)
CloseBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
CloseBtn.Text = "Закрыть"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = Frame

-- ==================== ОСНОВНАЯ ЛОГИКА ====================
local function CreateFakeHitbox(character)
    if FakeHitboxes[character] then
        FakeHitboxes[character]:Destroy()
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    local target = character:FindFirstChild(Settings.TargetPart)
    if not root or not target then return end

    local fake = Instance.new("Part")
    fake.Name = "FakeHitbox"
    fake.Size = Vector3.new(Settings.Size, Settings.Size, Settings.Size)
    fake.Transparency = Settings.Transparency
    fake.Material = Settings.Material
    fake.Color = Settings.Color
    fake.CanCollide = false
    fake.Massless = true
    fake.Anchored = true
    fake.Parent = character

    FakeHitboxes[character] = fake

    -- Прикрепляем к персонажу
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = target
    weld.Part1 = fake
    weld.Parent = fake
end

local function UpdateAll()
    if not Settings.Enabled then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not Settings.TeamCheck or plr.Team ~= LocalPlayer.Team then
                pcall(function()
                    CreateFakeHitbox(plr.Character)
                end)
            end
        end
    end
end

-- Обработчики
Toggle.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    Toggle.Text = Settings.Enabled and "ВЫКЛЮЧИТЬ" or "ВКЛЮЧИТЬ"
    Toggle.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
end)

SizeBox.FocusLost:Connect(function()
    local n = tonumber(SizeBox.Text)
    if n and n >= 1 then
        Settings.Size = n
    end
end)

TransBox.FocusLost:Connect(function()
    local n = tonumber(TransBox.Text)
    if n then Settings.Transparency = math.clamp(n, 0, 1) end
end)

PartBtn.MouseButton1Click:Connect(function()
    Settings.TargetPart = Settings.TargetPart == "Head" and "HumanoidRootPart" or "Head"
    PartBtn.Text = "Цель: " .. Settings.TargetPart
end)

TeamBtn.MouseButton1Click:Connect(function()
    Settings.TeamCheck = not Settings.TeamCheck
    TeamBtn.Text = "Team Check: " .. (Settings.TeamCheck and "ON" or "OFF")
    TeamBtn.BackgroundColor3 = Settings.TeamCheck and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    for _, hb in pairs(FakeHitboxes) do hb:Destroy() end
end)

-- Цикл обновления
RunService.Heartbeat:Connect(UpdateAll)

-- Респавн
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.8)
        if Settings.Enabled then
            task.spawn(function() CreateFakeHitbox(char) end)
        end
    end)
end)

print("✅ Hitbox Expander v2.3 загружен (метод fake hitbox)")
print("Теперь можно спокойно использовать HumanoidRootPart!")
