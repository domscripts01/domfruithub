-- GUI + Gravity Skill XP Farm Script
local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local remote = rs:WaitForChild("ReplicatorNoYield")

local fruitName = "Gravity"
local skillList = {
    "Push",
    "Launch",
    "Avalanche",
    "Shoot",
    "PlanetaryDevastation",
    "GreatMeteor"
}

local farming = false
local safeFarmPosition = Vector3.new(3000, 50, -1200) -- update this if you find a better spot

-- MouseRay builder
local function getMouseRay()
    local origin = workspace.CurrentCamera.CFrame.Position
    local direction = Vector3.new(0, -1, 0) * 100
    return {
        MouseRay = {
            Origin = origin,
            Direction = direction,
            UnitRay = Ray.new(origin, direction)
        }
    }
end

-- Farming loop
task.spawn(function()
    while true do
        if farming then
            for _, skill in ipairs(skillList) do
                remote:FireServer(fruitName, skill, getMouseRay())
                task.wait(0.5)
            end
        end
        task.wait(2)
    end
end)

-- Teleport to safe zone
local function teleportToSafeSpot()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(safeFarmPosition)
    end
end

-- Simple GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FruitHubUI"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Size = UDim2.new(0, 180, 0, 40)
toggleButton.Text = "Toggle Farm: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

toggleButton.MouseButton1Click:Connect(function()
    farming = not farming
    toggleButton.Text = farming and "Toggle Farm: ON" or "Toggle Farm: OFF"
end)

local tpButton = Instance.new("TextButton", frame)
tpButton.Position = UDim2.new(0, 10, 0, 60)
tpButton.Size = UDim2.new(0, 180, 0, 40)
tpButton.Text = "📍 Teleport to Farm Spot"
tpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)

tpButton.MouseButton1Click:Connect(teleportToSafeSpot)
