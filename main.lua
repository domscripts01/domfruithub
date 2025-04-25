-- DOMFRUITHUB FINAL FIX - GUI fixed, skill spam by current fruit, slot label added

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local remote = ReplicatedStorage:WaitForChild("ReplicatorNoYield")

local fruit = "Unknown"
local skillList = {}

local fruitSkills = {
    -- Common Fruits
    ["Barrier"] = {"Barrier Wall", "Barrier Crush", "Barrier Dome", "Barrier Pistol"},
    ["Chop"] = {"Chop Punch", "Chop Car", "Chop Festival"},
    ["Sand"] = {"Desert Spada", "Desert Funeral", "Sables", "Sandstorm"},
    ["Smoke"] = {"White Blow", "White Snake", "White Out", "White Launcher"},
    ["Rubber"] = {"Gum-Gum Pistol", "Gum-Gum Bazooka", "Gum-Gum Gatling", "Gum-Gum Balloon"},

    -- Uncommon Fruits
    ["Falcon"] = {"Falcon Claw", "Falcon Dive", "Falcon Flight"},
    ["Gas"] = {"Gas Punch", "Gas Explosion", "Gas Flight", "Gastanet"},

    -- Rare Fruits
    ["Bomb"] = {"Bomb Shot", "Bomb Rush", "Bomb Explosion"},
    ["Ice"] = {"Ice Lance", "Ice Age", "Ice Stomp", "Ice Slide"},
    ["Darkness"] = {"Black Hole", "Dark Vortex", "Dark Matter", "Dark End"},
    ["Ash"] = {"Ash Cloud", "Ash Explosion", "Ash Storm"},

    -- Epic Fruits
    ["Light"] = {"Light Kick", "Light Beam", "Light Flight", "Light Barrage"},
    ["Flame"] = {"Fire Fist", "Fire Pillar", "Flame Flight", "Flame Emperor"},
    ["Magma"] = {"Magma Fist", "Magma Eruption", "Magma Floor", "Volcanic Storm"},
    ["Paw"] = {"Paw Punch", "Paw Repel", "Paw Barrage", "Ursus Shock"},
    ["String"] = {"String Bullet", "String Whip", "String Clone", "String Trap"},
    ["Love"] = {"Cupid's Arrows", "Bouquet of Pain", "Heartthrob", "Heartstrings", "Blossom Wind"},
    ["Snow"] = {"Snowball", "Snow Storm", "Snowman Summon", "Blizzard"},

    -- Legendary Fruits
    ["Quake"] = {"Quake Punch", "Quake Slam", "Sea Quake", "Quake Tsunami"},
    ["Gravity"] = {"Push", "Launch", "Avalanche", "Shoot", "PlanetaryDevastation", "GreatMeteor"},
    ["Phoenix"] = {"Phoenix Claw", "Phoenix Flight", "Blue Flames", "Phoenix Rebirth"},
    ["Dragon"] = {"Dragon Roar", "Dragon Claw", "Dragon Flight", "Dragon Transformation"},
    ["TSRubber"] = {"Red Hawk", "Jet Pistol", "Jet Gatling", "Elephant Gun"},
    ["Magnet"] = {"Magnet Pull", "Magnet Repel", "Magnet Field", "Magnet Storm"},
    ["IceV2"] = {"Piercing Glacier", "Blizzard Blade", "Ice Hail", "Absolute Zero", "Ice Skate"},
    ["MagmaV2"] = {"Magma Fist V2", "Magma Eruption V2", "Magma Floor V2", "Volcanic Storm V2"},
    ["LightV2"] = {"Light Kick V2", "Light Beam V2", "Light Flight V2", "Light Barrage V2"},
    ["FlameV2"] = {"Fire Fist V2", "Fire Pillar V2", "Flame Flight V2", "Flame Emperor V2"},
    ["Venom"] = {"Venom Punch", "Venom Hydra", "Venom Explosion", "Venom Demon"},
    ["Dough"] = {"Dough Punch", "Dough Roll", "Dough Slam", "Dough Barrage"},
    ["Leopard"] = {"Leopard Claw", "Leopard Dash", "Leopard Roar", "Leopard Transformation"},

    -- Mythical Fruits
    ["DoughV2"] = {"Dough Punch V2", "Dough Roll V2", "Dough Slam V2", "Dough Barrage V2"},
    ["Ope"] = {"Room", "Takt", "Wreckage", "Hurricane Shock", "Gamma Knife", "Mes", "Shambles"},
    ["Lightning"] = {"Voltage Up", "Lightning Palm", "Crashing Thunder", "Projected Burst", "Crushing Judgment", "Raigo"},
    ["Nika"] = {"Gum-Gum Pistol", "Gum-Gum Whip", "Gum-Gum Giant", "Gum-Gum Bajrang Gun"},
    ["Dragon V2"] = {"Dragon Roar V2", "Dragon Claw V2", "Dragon Flight V2", "Dragon Transformation V2"},
    ["Soul"] = {"Enthral Grasp", "Scorching Sickle", "Crimson Pillar", "Zeus Meadow", "Maser Cannon"},
    ["DarkXQuake"] = {"Black Hole", "Sea Quake", "Dark Matter", "Quake Tsunami"},
    ["Okuchi"] = {"Wolf Fang", "Wolf Howl", "Wolf Dash", "Wolf Transformation"}
},
    -- Add more fruits/skills below if needed
}

local function getCurrentFruit()
    for _, v in ipairs(Character:GetChildren()) do
        if v:IsA("StringValue") and v.Name:lower():find("fruit") then
            return v.Value
        end
    end
    return "Unknown"
end

local function getMouseRay()
    local origin = workspace.CurrentCamera.CFrame.Position
    local direction = Vector3.new(0, -1, 0) * 100
    return { MouseRay = Ray.new(origin, direction) }
end

local function getBoss()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name == "Marco" or v.Name == "Kaido" or v.Name == "Katakuri") then
            local hrp = v:FindFirstChild("HumanoidRootPart")
            local hp = v:FindFirstChildOfClass("Humanoid")
            if hrp and hp and hp.Health > 0 then return hrp end
        end
    end
end

local function teleportToNPC(name)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == name and v:FindFirstChild("HumanoidRootPart") then
            Character:WaitForChild("HumanoidRootPart").CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            return
        end
    end
end

local farming = false
local bossFarm = false
local slot = 1
local saved = {[1]=nil,[2]=nil,[3]=nil,[4]=nil,[5]=nil}

-- Farming loop
spawn(function()
    while task.wait(1.5) do
        if farming then
            Character = player.Character or player.CharacterAdded:Wait()
            fruit = getCurrentFruit()
            skillList = fruitSkills[fruit] or {}
            if #skillList > 0 then
                local ray = getMouseRay()
                local target = bossFarm and getBoss()
                if target then ray = {MouseRay = Ray.new(workspace.CurrentCamera.CFrame.Position, (target.Position - workspace.CurrentCamera.CFrame.Position).Unit * 100)} end
                for _, skill in ipairs(skillList) do
                    remote:FireServer(fruit, skill, ray)
                    task.wait(0.4)
                end
            end
        end
    end
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.Size = UDim2.new(0, 260, 0, 280)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function makeBtn(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 240, 0, 30)
    b.Position = UDim2.new(0, 10, 0, y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    return b
end

makeBtn("Toggle Farm", 10).MouseButton1Click:Connect(function()
    farming = not farming
end)
makeBtn("Toggle Boss Farm", 50).MouseButton1Click:Connect(function()
    bossFarm = not bossFarm
end)
makeBtn("Teleport to Kuma", 90).MouseButton1Click:Connect(function()
    teleportToNPC("Kuma")
end)
makeBtn("Save Position", 130).MouseButton1Click:Connect(function()
    saved[slot] = Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.CFrame
end)
makeBtn("Teleport to Slot", 170).MouseButton1Click:Connect(function()
    if saved[slot] then Character.HumanoidRootPart.CFrame = saved[slot] end
end)

-- Slot label
local slotLabel = Instance.new("TextLabel", frame)
slotLabel.Position = UDim2.new(0, 10, 0, 210)
slotLabel.Size = UDim2.new(0, 240, 0, 20)
slotLabel.Text = "Selected Slot: 1"
slotLabel.BackgroundTransparency = 1
slotLabel.TextColor3 = Color3.new(1,1,1)

-- Slot buttons
local leftBtn = makeBtn("< Slot", 240)
leftBtn.Size = UDim2.new(0, 120, 0, 30)
leftBtn.MouseButton1Click:Connect(function()
    slot = math.max(1, slot - 1)
    slotLabel.Text = "Selected Slot: "..slot
end)

local rightBtn = makeBtn("Slot >", 240)
rightBtn.Position = UDim2.new(0, 140, 0, 240)
rightBtn.Size = UDim2.new(0, 110, 0, 30)
rightBtn.MouseButton1Click:Connect(function()
    slot = math.min(5, slot + 1)
    slotLabel.Text = "Selected Slot: "..slot
end)

print("✅ DOMFRUITHUB FINAL CLEAN BUILD READY")
