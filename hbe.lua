-- Ragdoll Battlegrounds Hitbox Expander v1.5 (Оптимизировано)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    Enabled = true,
    Size = 10,                    -- Размер hitbox (от 5 до 30+)
    Transparency = 0.75,
    Color = Color3.fromRGB(255, 0, 100),
    Material = Enum.Material.ForceField,
    TeamCheck = false,            -- В Ragdoll Battlegrounds обычно FFA
    UpdateInterval = 0.25
}

local expandedParts = {}  -- Для хранения оригинальных размеров

local function expandCharacter(character)
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not expandedParts[part] then
                expandedParts[part] = part.Size
            end
            
            part.Size = Vector3.new(Settings.Size, Settings.Size, Settings.Size)
            part.Transparency = Settings.Transparency
            part.Color = Settings.Color
            part.Material = Settings.Material
            part.CanCollide = false
            part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5) -- чуть легче
        end
    end
end

local function restoreCharacter(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and expandedParts[part] then
            part.Size = expandedParts[part]
            part.Transparency = 0
            part.Material = Enum.Material.Plastic
            part.Color = part.Color -- оригинальный цвет (или оставь как есть)
        end
    end
end

-- Основной цикл
local connection
local lastUpdate = 0

connection = RunService.Heartbeat:Connect(function()
    if not Settings.Enabled then return end
    if tick() - lastUpdate < Settings.UpdateInterval then return end
    lastUpdate = tick()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not Settings.TeamCheck or player.Team ~= LocalPlayer.Team then
                pcall(expandCharacter, player.Character)
            end
        end
    end
end)

-- Авто-обновление при респавне / смене персонажа
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.6)
        pcall(expandCharacter, char)
    end)
end)

-- Инициализация уже существующих
for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        task.spawn(function()
            task.wait(0.6)
            pcall(expandCharacter, plr.Character)
        end)
    end
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.6)
        pcall(expandCharacter, char)
    end)
end

-- Простой GUI для управления
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 220)
Frame.Position = UDim2.new(0.5, -130, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent
