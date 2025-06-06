-- Global Variables
getgenv().CatchSpeed       = 1      
getgenv().TouchRadius      = 15     
getgenv().AttackRadius     = 25     
getgenv().AutoCatchEnabled = false  

-- Load UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
local window  = library:CreateWindow("Sword Fight")
local botFolder = window:CreateFolder("Bot")

-- UI Controls
botFolder:Slider("Roto Speed", {min = 0, max = 1, precise = true}, function(value) getgenv().CatchSpeed = value end)
botFolder:Slider("Sword Range", {min = 0, max = 15, precise = false}, function(value) getgenv().TouchRadius = value end)
botFolder:Slider("Attack Range", {min = 0, max = 10000, precise = false}, function(value) getgenv().AttackRadius = value end)
botFolder:Toggle("Auto Catch", function(state) getgenv().AutoCatchEnabled = state print("Auto Catch Enabled:", state) end)

-- Reference to Player
local localPlayer = game.Players.LocalPlayer

-- Function to check if the player has an equipped tool
local function getEquippedTool()
    local character = localPlayer.Character
    return character and character:FindFirstChildOfClass("Tool") or nil
end

-- Fire Touch Event (Only if a tool is equipped)
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().AutoCatchEnabled then
        local tool = getEquippedTool()
        if tool and tool:FindFirstChild("Handle") then
            tool:Activate()
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local otherChar = player.Character
                    local humanoid = otherChar:FindFirstChild("Humanoid")
                    local hrp = otherChar:FindFirstChild("HumanoidRootPart")
                    if humanoid and humanoid.Health > 0 and hrp and localPlayer:DistanceFromCharacter(hrp.Position) <= getgenv().TouchRadius then
                        for _, part in ipairs(otherChar:GetChildren()) do
                            if part:IsA("BasePart") then
                            	for i=0,10 do
                	                firetouchinterest(tool.Handle, part, 0)
                             		firetouchinterest(tool.Handle, part, 1)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Function to get the closest player (Only if a tool is equipped)
local function getClosestPlayer()
    local tool = getEquippedTool()
    if not tool then return nil end  -- Exit if no tool equipped

    local closestPlayer, shortestDist = nil, getgenv().TouchRadius
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoid.Health > 0 and hrp and not char:FindFirstChildOfClass("ForceField") then
                    local dist = (hrp.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
                    if dist < shortestDist then
                        closestPlayer, shortestDist = player, dist
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Disable FallingDown & Ragdoll (Only if a tool is equipped)
local function disableHumanoidStates()
    local tool = getEquippedTool()
    if not tool then return end  

    local character = localPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end

if localPlayer.Character then disableHumanoidStates() end

-- Main Loop (Only runs when a tool is equipped)
while true do
    wait()
    spawn(function()
        local tool = getEquippedTool()
        if not tool then return end  -- Stop if no tool is equipped

        local targetPlayer = getClosestPlayer()
        if localPlayer.Character and localPlayer.Character.PrimaryPart and targetPlayer and getgenv().AutoCatchEnabled then
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            local localHRP = localPlayer.Character.HumanoidRootPart
            local localHumanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if localHumanoid then localHumanoid.AutoRotate = false end

            -- Move toward target
			local direction = targetHRP.Position - localHRP.Position
			direction = Vector3.new(direction.X, 0, direction.Z).unit  -- Ignore vertical movement
			localHRP.CFrame = localHRP.CFrame:Lerp(
			    CFrame.new(localHRP.Position, localHRP.Position + direction),
			    getgenv().CatchSpeed
			)
			
            localPlayer.Character.Humanoid:MoveTo((targetHRP.CFrame * CFrame.new(-3, 0, 0)).p)

            -- Jump if the target is in Freefall
            if targetPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                localPlayer.Character.Humanoid.Jump = true
            end
        else
            if localPlayer.Character then
                local localHumanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if localHumanoid then localHumanoid.AutoRotate = true end
            end
        end
    end)
end

if localPlayer.Character then disableHumanoidStates() end