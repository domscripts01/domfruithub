-- DOMFRUITHUB FULL FINAL BUILD
-- Features: Manual fruit picker, Toggle Farm, Toggle Boss Farm (auto-teleport & spam), TP to Kuma, TP to Safe Spot

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local remote = rs:WaitForChild("ReplicatorNoYield")

-- Fruit skills
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
    Gravity = {"Push", "Launch", "Avalanche", "Shoot", "PlanetaryDevastation", "GreatMeteor"},
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

-- State variables
local fruitName = "Gravity"
local skillList = fruitSkills[fruitName]
local farming = false
local bossFarm = false
local safeFarmPosition = Vector3.new(3000, 50, -1200)

-- Utility functions
local function getMouseRay()
    local origin = workspace.CurrentCamera.CFrame.Position
    local dir = Vector3.new(0, -1, 0) * 100
    return { MouseRay = { Origin = origin, Direction = dir, UnitRay = Ray.new(origin, dir) } }
end

local function getBoss()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name=="Marco" or v.Name=="Katakuri" or v.Name=="Kaido") then
            local hrp=v:FindFirstChild("HumanoidRootPart")
            local hum=v:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health>0 then return hrp end
        end
    end
end

local function teleportTo(name)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name==name and v:FindFirstChild("HumanoidRootPart") then
            local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,5,5) end
            return
        end
    end
end

-- Farming loop
spawn(function()
    while task.wait(1.5) do
        if farming and skillList then
            for _, skill in ipairs(skillList) do
                remote:FireServer(fruitName, skill, getMouseRay())
                task.wait(0.4)
            end
        end
        if bossFarm then
            local boss=getBoss()
            if boss then teleportTo(boss.Parent.Name) end
        end
    end
end)

-- GUI
local gui=Instance.new("ScreenGui",game.CoreGui)
local frame=Instance.new("Frame",gui)
frame.Position=UDim2.new(0.05,0,0.3,0)
frame.Size=UDim2.new(0,240,0,260)
frame.BackgroundColor3=Color3.fromRGB(30,30,30)
frame.BorderSizePixel=0

-- Toggle Farm Button
local farmBtn=Instance.new("TextButton",frame)
farmBtn.Position=UDim2.new(0,10,0,10)
farmBtn.Size=UDim2.new(0,220,0,30)
farmBtn.Text="Toggle Farm: OFF"
farmBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
farmBtn.TextColor3=Color3.fromRGB(255,255,255)
farmBtn.MouseButton1Click:Connect(function()
    farming=not farming
    farmBtn.Text=farming and "Toggle Farm: ON" or "Toggle Farm: OFF"
end)

-- Toggle Boss Farm Button
local bossBtn=Instance.new("TextButton",frame)
bossBtn.Position=UDim2.new(0,10,0,50)
bossBtn.Size=UDim2.new(0,220,0,30)
bossBtn.Text="Toggle Boss Farm: OFF"
bossBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
bossBtn.TextColor3=Color3.fromRGB(255,255,255)
bossBtn.MouseButton1Click:Connect(function()
    bossFarm=not bossFarm
    bossBtn.Text=bossFarm and "Toggle Boss Farm: ON" or "Toggle Boss Farm: OFF"
end)

-- Teleport to Safe Spot Button
local safeBtn=Instance.new("TextButton",frame)
safeBtn.Position=UDim2.new(0,10,0,90)
safeBtn.Size=UDim2.new(0,220,0,30)
safeBtn.Text="📍 Teleport to Safe Spot"
safeBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
safeBtn.TextColor3=Color3.fromRGB(255,255,255)
safeBtn.MouseButton1Click:Connect(function() teleportTo("SafeZone") end)

-- Teleport to Kuma Button
local kumaBtn=Instance.new("TextButton",frame)
kumaBtn.Position=UDim2.new(0,10,0,130)
kumaBtn.Size=UDim2.new(0,220,0,30)
kumaBtn.Text="🚢 Teleport to Kuma"
kumaBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
kumaBtn.TextColor3=Color3.fromRGB(255,255,255)
kumaBtn.MouseButton1Click:Connect(function() teleportTo("Kuma") end)

-- Fruit Selector Label
local fruitLabel=Instance.new("TextLabel",frame)
fruitLabel.Position=UDim2.new(0,10,0,170)
fruitLabel.Size=UDim2.new(0,220,0,20)
fruitLabel.BackgroundTransparency=1
fruitLabel.TextColor3=Color3.new(1,1,1)
fruitLabel.Text="Current Fruit: "..fruitName

-- Fruit Prev Button
local fruitList={} for name in pairs(fruitSkills) do table.insert(fruitList,name) end table.sort(fruitList)
local currentIndex=table.find(fruitList,fruitName) or 1
local prevBtn=Instance.new("TextButton",frame)
prevBtn.Position=UDim2.new(0,10,0,200)
prevBtn.Size=UDim2.new(0,100,0,30)
prevBtn.Text="< Prev Fruit"
prevBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
prevBtn.TextColor3=Color3.fromRGB(255,255,255)
prevBtn.MouseButton1Click:Connect(function()
    currentIndex=currentIndex-1 if currentIndex<1 then currentIndex=#fruitList end
    fruitName=fruitList[currentIndex]
    skillList=fruitSkills[fruitName]
    fruitLabel.Text="Current Fruit: "..fruitName
end)

-- Fruit Next Button
local nextBtn=Instance.new("TextButton",frame)
nextBtn.Position=UDim2.new(0,130,0,200)
nextBtn.Size=UDim2.new(0,100,0,30)
nextBtn.Text="Next Fruit >"
nextBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
nextBtn.TextColor3=Color3.fromRGB(255,255,255)
nextBtn.MouseButton1Click:Connect(function()
    currentIndex=currentIndex+1 if currentIndex>#fruitList then currentIndex=1 end
    fruitName=fruitList[currentIndex]
    skillList=fruitSkills[fruitName]
    fruitLabel.Text="Current Fruit: "..fruitName
end)
