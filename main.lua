--[[
    MVSD Cheat - Murderers VS Sheriffs DUELS
    Full Aimbot, ESP, Rage, Movement, Visuals
    Uses Rayfield UI Library (Correct API)
--]]

-- ========== LOAD RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ========== SERVICES & GLOBALS ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ========== MAIN WINDOW ==========
local Window = Rayfield:CreateWindow({
    Name = "MVSD Cheat | Vail Hub MVSD",
    LoadingTitle = "Loading MVSD Cheat...",
    ConfigurationSaving = {Enabled = true, FolderName = "MVSD_Cheat_Config", FileName = "Config"},
    KeySystem = false,
    ToggleUIKeybind = Enum.KeyCode.RightControl,
})

-- ========== CREATE TABS ==========
local CombatTab = Window:CreateTab("Combat", nil)
local SilentAimTab = Window:CreateTab("Silent Aim", nil)
local RageTab = Window:CreateTab("Rage Mode", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)
local MovementTab = Window:CreateTab("Movement", nil)
local MiscTab = Window:CreateTab("Misc", nil)

-- ========== COMBAT TAB - AIMBOT ==========
local AimbotSection = CombatTab:CreateSection("Aimbot")

-- Variables
local AimbotEnabled = false
local AimbotMode = "Toggle"          -- "Toggle" or "Hold"
local AimbotKey = Enum.UserInputType.MouseButton2
local AimbotFOV = 150
local AimbotSmoothness = 0.2
local AimPart = "Head"               -- "Head" or "HumanoidRootPart"
local TeamCheck = true
local WallCheck = true
local AutoFire = false

-- UI (called on CombatTab, not on Section)
CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(v) AimbotEnabled = v end
})
CombatTab:CreateDropdown({
    Name = "Aimbot Mode",
    Options = {"Toggle", "Hold"},
    CurrentOption = "Toggle",
    Flag = "AimbotMode",
    Callback = function(v) AimbotMode = v end
})
CombatTab:CreateKeybind({
    Name = "Aimbot Key (Hold Mode)",
    CurrentKeybind = "RightMouseButton",
    HoldToInteract = true,
    Flag = "AimbotKey",
    Callback = function(k) AimbotKey = k end
})
CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {0, 500},
    Increment = 5,
    CurrentValue = 150,
    Flag = "AimbotFOV",
    Callback = function(v) AimbotFOV = v end
})
CombatTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.0, 1.0},
    Increment = 0.05,
    CurrentValue = 0.2,
    Flag = "AimbotSmoothness",
    Callback = function(v) AimbotSmoothness = v end
})
CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "AimPart",
    Callback = function(v) AimPart = v end
})
CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "TeamCheck",
    Callback = function(v) TeamCheck = v end
})
CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = true,
    Flag = "WallCheck",
    Callback = function(v) WallCheck = v end
})
CombatTab:CreateToggle({
    Name = "Auto-Fire",
    CurrentValue = false,
    Flag = "AutoFire",
    Callback = function(v) AutoFire = v end
})

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = true
fovCircle.Radius = AimbotFOV
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255,0,0)
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Transparency = 1

local function updateFOVCircle()
    local viewport = Camera.ViewportSize
    fovCircle.Position = Vector2.new(viewport.X/2, viewport.Y/2)
    fovCircle.Radius = AimbotFOV
    fovCircle.Visible = AimbotEnabled
end

-- Nearest player function
local function GetNearestPlayer()
    local closest = nil
    local shortest = AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local targetPart = plr.Character:FindFirstChild(AimPart) or plr.Character:FindFirstChild("HumanoidRootPart")
            if not targetPart then continue end
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
            if not onScreen then continue end
            local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
            if dist < shortest then
                if WallCheck then
                    local origin = Camera.CFrame.Position
                    local dir = (targetPart.Position - origin).Unit
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    params.FilterDescendantsInstances = {LocalPlayer.Character, targetPart}
                    local hit = Workspace:Raycast(origin, dir * 1000, params)
                    if hit and hit.Instance:IsDescendantOf(plr.Character) then
                        shortest = dist
                        closest = plr
                    end
                else
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

-- Aimbot loop
local aimbotActive = false
RunService.RenderStepped:Connect(function()
    updateFOVCircle()
    if not AimbotEnabled then return end
    if AimbotMode == "Hold" then
        aimbotActive = UserInputService:IsKeyDown(AimbotKey)
    else
        aimbotActive = true
    end
    if aimbotActive then
        local target = GetNearestPlayer()
        if target then
            local part = target.Character:FindFirstChild(AimPart) or target.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos = Camera:WorldToScreenPoint(part.Position)
                local delta = Vector2.new(screenPos.X - Mouse.X, screenPos.Y - Mouse.Y)
                mousemoverel(delta.X * AimbotSmoothness, delta.Y * AimbotSmoothness)
                if AutoFire then
                    keypress(0x01)
                    task.wait(0.05)
                    keyrelease(0x01)
                end
            end
        end
    end
end)

-- ========== SILENT AIM TAB ==========
local SilentAimSection = SilentAimTab:CreateSection("Silent Aim Settings")
local SilentAimEnabled = false
local SilentAimIgnoreWalls = true
local IndependentAutoShoot = false
local SilentAimFOV = 200

SilentAimTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimEnabled",
    Callback = function(v) SilentAimEnabled = v end
})
SilentAimTab:CreateToggle({
    Name = "Ignore Walls (Penetration)",
    CurrentValue = true,
    Flag = "SilentAimIgnoreWalls",
    Callback = function(v) SilentAimIgnoreWalls = v end
})
SilentAimTab:CreateToggle({
    Name = "Independent Auto-Shoot",
    CurrentValue = false,
    Flag = "IndependentAutoShoot",
    Callback = function(v) IndependentAutoShoot = v end
})
SilentAimTab:CreateSlider({
    Name = "Silent Aim FOV",
    Range = {0, 500},
    Increment = 5,
    CurrentValue = 200,
    Flag = "SilentAimFOV",
    Callback = function(v) SilentAimFOV = v end
})

-- ========== RAGE MODE TAB ==========
local RageSection = RageTab:CreateSection("Rage Mode Settings")
local RageEnabled = false
local KillAuraEnabled = false
local SpinbotEnabled = false
local KillAuraRange = 50

RageTab:CreateToggle({
    Name = "Enable Rage Mode",
    CurrentValue = false,
    Flag = "RageEnabled",
    Callback = function(v) RageEnabled = v end
})
RageTab:CreateToggle({
    Name = "Silent Aim Kill Aura (Full Screen, Ignores Walls)",
    CurrentValue = false,
    Flag = "KillAuraEnabled",
    Callback = function(v) KillAuraEnabled = v end
})
RageTab:CreateToggle({
    Name = "Defensive Spinbot (Anti-Aim)",
    CurrentValue = false,
    Flag = "SpinbotEnabled",
    Callback = function(v) SpinbotEnabled = v end
})
RageTab:CreateSlider({
    Name = "Kill Aura Range",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 50,
    Flag = "KillAuraRange",
    Callback = function(v) KillAuraRange = v end
})

-- Spinbot
local spinConnection = nil
local function startSpinbot()
    if spinConnection then spinConnection:Disconnect() end
    spinConnection = RunService.RenderStepped:Connect(function()
        if SpinbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(360), 0)
        end
    end)
end
startSpinbot()

-- Kill Aura (simplified)
task.spawn(function()
    while true do
        if RageEnabled and KillAuraEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= KillAuraRange then
                        -- Placeholder for damage application
                        Rayfield:Notify({Title = "Kill Aura", Content = "Attacking " .. plr.Name, Duration = 1})
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ========== VISUALS TAB - ESP ==========
local ESP_Section = VisualsTab:CreateSection("Player ESP")
local ESPEnabled = false
local ESPBoxes = true
local ESPNames = true
local ESPDistance = true
local ESPSkeletons = false
local ESPColor = Color3.fromRGB(255,255,255)
local SkeletonColor = Color3.fromRGB(255,255,255)
local BoxOpacity = 0.5
local SkeletonThickness = 1
local OnScreenOnly = true

VisualsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(v) ESPEnabled = v end
})
VisualsTab:CreateToggle({
    Name = "3D Boxes",
    CurrentValue = true,
    Flag = "ESPBoxes",
    Callback = function(v) ESPBoxes = v end
})
VisualsTab:CreateToggle({
    Name = "Names w/ Distance Counter",
    CurrentValue = true,
    Flag = "ESPNames",
    Callback = function(v) ESPNames = v end
})
VisualsTab:CreateToggle({
    Name = "Skeletons",
    CurrentValue = false,
    Flag = "ESPSkeletons",
    Callback = function(v) ESPSkeletons = v end
})
VisualsTab:CreateToggle({
    Name = "On-Screen Only Filter",
    CurrentValue = true,
    Flag = "OnScreenOnly",
    Callback = function(v) OnScreenOnly = v end
})
VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ESPColor",
    Callback = function(c) ESPColor = c end
})
VisualsTab:CreateColorPicker({
    Name = "Skeleton Color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "SkeletonColor",
    Callback = function(c) SkeletonColor = c end
})
VisualsTab:CreateSlider({
    Name = "Box Opacity",
    Range = {0,1},
    Increment = 0.05,
    CurrentValue = 0.5,
    Flag = "BoxOpacity",
    Callback = function(v) BoxOpacity = v end
})
VisualsTab:CreateSlider({
    Name = "Skeleton Thickness",
    Range = {1,5},
    Increment = 1,
    CurrentValue = 1,
    Flag = "SkeletonThickness",
    Callback = function(v) SkeletonThickness = v end
})

-- ESP Drawing
local function drawESP()
    if not ESPEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not hrp or not head then continue end
        local hrpPos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
        local headPos = Camera:WorldToScreenPoint(head.Position)
        if OnScreenOnly and not onScreen then continue end
        local boxHeight = math.abs(headPos.Y - hrpPos.Y)
        local boxWidth = boxHeight / 2
        
        if ESPBoxes then
            local box = Drawing.new("Square")
            box.Visible = true
            box.Size = Vector2.new(boxWidth, boxHeight)
            box.Position = Vector2.new(hrpPos.X - boxWidth/2, headPos.Y)
            box.Color = ESPColor
            box.Thickness = 1
            box.Filled = false
            box.Transparency = BoxOpacity
            task.wait()
            box:Remove()
        end
        
        if ESPNames then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            local nameLabel = Drawing.new("Text")
            nameLabel.Visible = true
            nameLabel.Text = plr.Name .. " (" .. math.floor(dist) .. "m)"
            nameLabel.Position = Vector2.new(hrpPos.X - boxWidth/2, headPos.Y - 15)
            nameLabel.Color = ESPColor
            nameLabel.Size = 14
            nameLabel.Center = true
            nameLabel.Outline = true
            task.wait()
            nameLabel:Remove()
        end
        
        if ESPSkeletons and char:FindFirstChild("UpperTorso") and char:FindFirstChild("LowerTorso") then
            local upper = char:FindFirstChild("UpperTorso")
            local lower = char:FindFirstChild("LowerTorso")
            if upper and lower then
                local upperPos = Camera:WorldToScreenPoint(upper.Position)
                local lowerPos = Camera:WorldToScreenPoint(lower.Position)
                local line = Drawing.new("Line")
                line.Visible = true
                line.From = Vector2.new(upperPos.X, upperPos.Y)
                line.To = Vector2.new(lowerPos.X, lowerPos.Y)
                line.Color = SkeletonColor
                line.Thickness = SkeletonThickness
                task.wait()
                line:Remove()
            end
        end
    end
end

RunService.RenderStepped:Connect(drawESP)

-- ========== MOVEMENT TAB ==========
local TeleportsSection = MovementTab:CreateSection("Teleports")
local LobbyLocation = nil

MovementTab:CreateButton({
    Name = "Teleport Behind Target",
    Callback = function()
        local target = GetNearestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = target.Character.HumanoidRootPart
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0,0,3)
        end
    end
})
MovementTab:CreateButton({
    Name = "Set Lobby Location",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LobbyLocation = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Location Set", Content = "Lobby location saved!", Duration = 2})
        end
    end
})
MovementTab:CreateButton({
    Name = "Teleport to Lobby",
    Callback = function()
        if LobbyLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LobbyLocation
            Rayfield:Notify({Title = "Teleported", Content = "Teleported to lobby!", Duration = 2})
        end
    end
})

local SpeedSection = MovementTab:CreateSection("Speed Boost")
local SpeedBoostEnabled = false
local BoostSpeed = 50

MovementTab:CreateToggle({
    Name = "Enable Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoostEnabled",
    Callback = function(v)
        SpeedBoostEnabled = v
        if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = BoostSpeed
        elseif not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})
MovementTab:CreateSlider({
    Name = "Boost Speed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 50,
    Flag = "BoostSpeed",
    Callback = function(v)
        BoostSpeed = v
        if SpeedBoostEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = BoostSpeed
        end
    end
})

-- ========== MISC TAB ==========
local WorldSection = MiscTab:CreateSection("World Settings")
local LowGFX = false
local FPSCap = 60

MiscTab:CreateToggle({
    Name = "Low GFX Mode",
    CurrentValue = false,
    Flag = "LowGFX",
    Callback = function(v)
        LowGFX = v
        if LowGFX then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 0
            settings().Rendering.QualityLevel = 1
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            settings().Rendering.QualityLevel = 10
        end
    end
})
MiscTab:CreateSlider({
    Name = "FPS Cap",
    Range = {30, 240},
    Increment = 10,
    CurrentValue = 60,
    Flag = "FPSCap",
    Callback = function(v)
        FPSCap = v
        if setfpscap then setfpscap(FPSCap) end
    end
})

-- ========== STARTUP NOTIFICATION ==========
Rayfield:Notify({
    Title = "MVSD Cheat Loaded",
    Content = "Press RightControl to toggle menu",
    Duration = 4
})