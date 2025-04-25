-- DOMFRUITHUB v2 - Full Script with All Fruit Skills (Remote-based Skill Spam)
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
    Barrier = {"Barrier Wall", "Barrier Crush", "Barrier Dome", "Barrier Pistol"},
    Chop = {"Chop Punch", "Chop Car", "Chop Festival"},
    Sand = {"Desert Spada", "Desert Funeral", "Sables", "Sandstorm"},
    Smoke = {"White Blow", "White Snake", "White Out", "White Launcher"},
    Rubber = {"Gum-Gum Pistol", "Gum-Gum Bazooka", "Gum-Gum Gatling", "Gum-Gum Balloon"},
    Falcon = {"Falcon Claw", "Falcon Dive", "Falcon Flight"},
    Gas = {"Gas Punch", "Gas Explosion", "Gas Flight", "Gastanet"},
    Bomb = {"Bomb Shot", "Bomb Rush", "Bomb Explosion"},
    Ice = {"Ice Lance", "Ice Age", "Ice Stomp", "Ice Slide"},
    Darkness = {"Black Hole", "Dark Vortex", "Dark Matter", "Dark End"},
    Ash = {"Ash Cloud", "Ash Explosion", "Ash Storm"},
    Light = {"Light Kick", "Light Beam", "Light Flight", "Light Barrage"},
    Flame = {"Fire Fist", "Fire Pillar", "Flame Flight", "Flame Emperor"},
    Magma = {"Magma Fist", "Magma Eruption", "Magma Floor", "Volcanic Storm"},
    Paw = {"Paw Punch", "Paw Repel", "Paw Barrage", "Ursus Shock"},
    String = {"String Bullet", "String Whip", "String Clone", "String Trap"},
    Love = {"Cupid's Arrows", "Bouquet of Pain", "Heartthrob", "Heartstrings", "Blossom Wind"},
    Snow = {"Snowball", "Snow Storm", "Snowman Summon", "Blizzard"},
    Quake = {"Quake Punch", "Quake Slam", "Sea Quake", "Quake Tsunami"},
    Gravity = {"Gravity Push", "Gravity Pull", "Meteor Shower", "Planetary Devastation"},
    Phoenix = {"Phoenix Claw", "Phoenix Flight", "Blue Flames", "Phoenix Rebirth"},
    Dragon = {"Dragon Roar", "Dragon Claw", "Dragon Flight", "Dragon Transformation"},
    TSRubber = {"Red Hawk", "Jet Pistol", "Jet Gatling", "Elephant Gun"},
    Magnet = {"Magnet Pull", "Magnet Repel", "Magnet Field", "Magnet Storm"},
    IceV2 = {"Piercing Glacier", "Blizzard Blade", "Ice Hail", "Absolute Zero", "Ice Skate"},
    MagmaV2 = {"Magma Fist V2", "Magma Eruption V2", "Magma Floor V2", "Volcanic Storm V2"},
    LightV2 = {"Light Kick V2", "Light Beam V2", "Light Flight V2", "Light Barrage V2"},
    FlameV2 = {"Fire Fist V2", "Fire Pillar V2", "Flame Flight V2", "Flame Emperor V2"},
    Venom = {"Venom Punch", "Venom Hydra", "Venom Explosion", "Venom Demon"},
    Dough = {"Dough Punch", "Dough Roll", "Dough Slam", "Dough Barrage"},
    Leopard = {"Leopard Claw", "Leopard Dash", "Leopard Roar", "Leopard Transformation"},
    DoughV2 = {"Dough Punch V2", "Dough Roll V2", "Dough Slam V2", "Dough Barrage V2"},
    Ope = {"Room", "Takt", "Wreckage", "Hurricane Shock", "Gamma Knife", "Mes", "Shambles"},
    Lightning = {"Voltage Up", "Lightning Palm", "Crashing Thunder", "Projected Burst", "Crushing Judgment", "Raigo"},
    Nika = {"Gum-Gum Pistol", "Gum-Gum Whip", "Gum-Gum Giant", "Gum-Gum Bajrang Gun"},
    ["Dragon V2"] = {"Dragon Roar V2", "Dragon Claw V2", "Dragon Flight V2", "Dragon Transformation V2"},
    Soul = {"Enthral Grasp", "Scorching Sickle", "Crimson Pillar", "Zeus Meadow", "Maser Cannon"},
    DarkXQuake = {"Black Hole", "Sea Quake", "Dark Matter", "Quake Tsunami"},
    Okuchi = {"Wolf Fang", "Wolf Howl", "Wolf Dash", "Wolf Transformation"}
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

spawn(function()
    while wait(1.5) do
        if farming then
            local fruit = getCurrentFruit()
            local skills = fruitSkills[fruit]
            local target = bossFarming and getBoss()
            if skills then
                for _, skill in ipairs(skills) do
                    local args = {
                        fruit,
                        skill,
                        getMouseRay(target and target.Position or (Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.Position - Vector3.new(0, 10, 0)))
                    }
                    remote:FireServer(unpack(args))
                    wait(0.4)
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

print("✅ DOMFRUITHUB v2 Loaded (Remote-based skill spam mode)")
