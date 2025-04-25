-- DOMFRUITHUB v2 - Full Script
-- Features: Dynamic fruit skill spam, auto boss farming, teleport to Kuma, saved positions, anti-detection

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local remote = ReplicatedStorage:WaitForChild("ReplicatorNoYield")

local farming = false
local bossFarming = false
local selectedSlot = 1
local savedPositions = {[1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil}

local fruitSkills = {
    Gravity = {"Push", "Launch", "Avalanche", "Shoot", "PlanetaryDevastation", "GreatMeteor"},
    Flame = {"FireBall", "FirePillar", "FlameDash", "HellRain"},
    Light = {"LightKick", "Teleport", "HeavenlyBeam", "LightSpeed"},
    -- Add more fruits/skills here
}

local function getCurrentFruit()
    local char = LocalPlayer.Character
    if not char then return "Unknown" end
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("StringValue") and v.Name:lower():find("fruit") then
            return v.Value
        end
    end
    return "Unknown"
end

local function getMouseRay(targetPos)
    local origin = workspace.CurrentCamera.CFrame.Position
    local direction = (targetPos - origin).Unit * 100
    return {
        MouseRay = {
            Origin = origin,
            Direction = direction,
            UnitRay = Ray.new(origin, direction)
        }
    }
end

local function getBoss()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name == "Marco" or v.Name == "Katakuri" or v.Name == "Kaido") then
            local hrp = v:FindFirstChild("HumanoidRootPart")
            local hp = v:FindFirstChildOfClass("Humanoid")
            if hrp and hp and hp.Health > 0 then
                return hrp
            end
        end
    end
    return nil
end

local function teleportToNPC(name)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == name and v:FindFirstChild("HumanoidRootPart") then
            Character:WaitForChild("HumanoidRootPart").CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            return
        end
    end
end

-- Skill spam loop
spawn(function()
    while wait(math.random(1.2, 2.5)) do
        if farming then
            local fruit = getCurrentFruit()
            local skills = fruitSkills[fruit]
            if skills then
                local rayTarget = bossFarming and getBoss() or (Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.Position - Vector3.new(0, 10, 0))
                if rayTarget then
                    for _, skill in ipairs(skills) do
                        remote:FireServer(fruit, skill, getMouseRay(rayTarget.Position or rayTarget))
                        wait(math.random(0.4, 0.8))
                    end
                end
            end
        end
    end
end)

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.Size = UDim2.new(0, 260, 0, 250)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local function createButton(text, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 240, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    return btn
end

-- GUI Buttons
local farmBtn = createButton("Toggle Skill Farm: OFF", 10)
farmBtn.MouseButton1Click:Connect(function()
    farming = not farming
    farmBtn.Text = farming and "Toggle Skill Farm: ON" or "Toggle Skill Farm: OFF"
end)

local bossBtn = createButton("Toggle Boss Farm: OFF", 50)
bossBtn.MouseButton1Click:Connect(function()
    bossFarming = not bossFarming
    bossBtn.Text = bossFarming and "Toggle Boss Farm: ON" or "Toggle Boss Farm: OFF"
end)

local kumaBtn = createButton("🧍‍♂️ Teleport to Kuma", 90)
kumaBtn.MouseButton1Click:Connect(function()
    teleportToNPC("Kuma")
end)

-- Saved slot controls
local slotLabel = Instance.new("TextLabel", frame)
slotLabel.Position = UDim2.new(0, 10, 0, 130)
slotLabel.Size = UDim2.new(0, 240, 0, 20)
slotLabel.Text = "Selected Slot: 1"
slotLabel.BackgroundTransparency = 1
slotLabel.TextColor3 = Color3.new(1,1,1)

local prevSlot = createButton("< Slot", 155)
prevSlot.Size = UDim2.new(0, 115, 0, 30)
prevSlot.MouseButton1Click:Connect(function()
    selectedSlot = math.max(1, selectedSlot - 1)
    slotLabel.Text = "Selected Slot: "..selectedSlot
end)

local nextSlot = createButton("Slot >", 155)
nextSlot.Position = UDim2.new(0, 135, 0, 155)
nextSlot.Size = UDim2.new(0, 115, 0, 30)
nextSlot.MouseButton1Click:Connect(function()
    selectedSlot = math.min(5, selectedSlot + 1)
    slotLabel.Text = "Selected Slot: "..selectedSlot
end)

local saveBtn = createButton("💾 Save Position", 195)
saveBtn.MouseButton1Click:Connect(function()
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPositions[selectedSlot] = hrp.CFrame
    end
end)

local tpSlotBtn = createButton("📍 Teleport to Slot", 235)
tpSlotBtn.MouseButton1Click:Connect(function()
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if hrp and savedPositions[selectedSlot] then
        hrp.CFrame = savedPositions[selectedSlot]
    end
end)

print("✅ DOMFRUITHUB v2 Loaded")
