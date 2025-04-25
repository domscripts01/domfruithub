-- DOMFRUITHUB v2 - Fixed MouseRay spam
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
        MouseRay = Ray.new(origin, direction)
    }
end
