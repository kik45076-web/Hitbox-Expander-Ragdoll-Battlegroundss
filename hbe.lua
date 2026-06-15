-- =============================================
--   HITBOX EXPANDER v2.1 — Ultra Quality
--   Работает на большинстве executor'ов 2026
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    Enabled = false,
    Size = 10,                    -- от 1 до очень больших значений
    Transparency = 0.65,
    Part = "Head",                -- "Head" или "HumanoidRootPart"
    Material = Enum.Material.ForceField,
    Color = Color3.fromRGB(255, 50, 50),
    TeamCheck = true,
    UpdateRate = 0.25,
    CanCollide = false
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HBExpanderGUI"
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

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "🔥 Hitbox Expander v2.1"
Title.TextColor3 = Color3.fromRGB(0, 255, 180)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

-- Toggle
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0.9, 0, 0, 50)
Toggle.Position = UDim2.new(0.05, 0, 0, 60)
Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Toggle.Text = "ВКЛЮЧИТЬ"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 18
Toggle.Font = Enum.Font.GothamSemibold
Toggle.Parent = Frame
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

-- Size
local function createSlider(name, pos, default, min, max)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, pos)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.45, 0, 0, 30)
    box.Position = UDim2.new(0.52, 0, 0, pos)
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.Text = tostring(default)
    box.TextColor3 = Color3.new(1,1,1)
    box.Parent = Frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    return box
end

local SizeBox = createSlider("Размер Hitbox:", 120, Settings.Size, 1, 9999)
local TransBox = createSlider("Прозрачность:", 160, Settings.Transparency, 0, 1)

-- Part
local PartBtn = Instance.new("TextButton")
PartBtn.Size = UDim2.new(0.9, 0, 0, 40)
PartBtn.Position = UDim2.new(0.05, 0, 0, 200)
PartBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
PartBtn.Text = "Часть: " .. Settings.Part
PartBtn.TextColor3 = Color3.new
