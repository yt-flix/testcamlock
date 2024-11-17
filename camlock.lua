local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local targetPart = nil -- The part to lock onto (set dynamically)
local isCamLocked = false -- State to track if camlock is active
local toggleKey = Enum.KeyCode.Q -- Key to toggle camlock

-- Function to find the closest target
local function findClosestTarget(position, range)
    local closestPart = nil
    local closestDistance = range or 50 -- Default range of 50 studs

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "Target" then -- Replace "Target" with the desired part name
            local distance = (position - v.Position).Magnitude
            if distance < closestDistance then
                closestPart = v
                closestDistance = distance
            end
        end
    end

    return closestPart
end

-- Function to lock camera onto the target
local function lockCamera()
    if targetPart and isCamLocked then
        local targetPosition = targetPart.Position
        local cameraPosition = camera.CFrame.Position
        local newCFrame = CFrame.new(cameraPosition, targetPosition)
        camera.CFrame = newCFrame
    end
end

-- Toggle camlock state
local function toggleCamlock()
    if isCamLocked then
        isCamLocked = false
        targetPart = nil
        print("Camlock disabled.")
    else
        targetPart = findClosestTarget(player.Character.Head.Position, 100) -- Range of 100 studs
        if targetPart then
            isCamLocked = true
            print("Camlock enabled on target:", targetPart.Name)
        else
            print("No target found within range.")
        end
    end
end

-- Listen for toggle key
UIS.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == toggleKey then
        toggleCamlock()
    end
end)

-- Update camera every frame if camlock is active
RunService.RenderStepped:Connect(function()
    if isCamLocked then
        lockCamera()
    end
end)
