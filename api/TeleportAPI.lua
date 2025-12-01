local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local function teleport(target, config)
    config = config or {}
    local speed = config.Speed or 100
    local underworldY = config.UnderworldY or 150
    local finishThreshold = config.FinishThreshold or 5
    local precision = config.Precision or 1
    
    local player = Players.LocalPlayer
    if not player then return false end
    
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return false end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local noclipConnection, activeGyro, activeVelocity
    
    local function cleanup()
        if activeGyro then activeGyro:Destroy() activeGyro = nil end
        if activeVelocity then activeVelocity:Destroy() activeVelocity = nil end
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        rootPart.Velocity = Vector3.zero
        rootPart.RotVelocity = Vector3.zero
    end
    
    local function move(targetCFrame)
        local success, err = pcall(function()
            local dt = RunService.RenderStepped:Wait()
            local currentPos, finalPos = rootPart.Position, targetCFrame.Position
            local flatDist = (Vector3.new(finalPos.X, 0, finalPos.Z) - Vector3.new(currentPos.X, 0, currentPos.Z)).Magnitude
            
            if (finalPos - currentPos).Magnitude < finishThreshold then
                rootPart.CFrame = targetCFrame
                cleanup()
                return
            end
            
            local activeY = flatDist > precision and underworldY or finalPos.Y
            local step = speed * dt
            
            local diffY = activeY - currentPos.Y
            if math.abs(diffY) > precision then
                rootPart.CFrame = rootPart.CFrame + Vector3.new(0, math.clamp(diffY, -step, step), 0)
                return move(targetCFrame)
            end
            
            local diffX = finalPos.X - currentPos.X
            if math.abs(diffX) > precision then
                rootPart.CFrame = rootPart.CFrame + Vector3.new(math.clamp(diffX, -step, step), 0, 0)
                return move(targetCFrame)
            end
            
            local diffZ = finalPos.Z - currentPos.Z
            if math.abs(diffZ) > precision then
                rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 0, math.clamp(diffZ, -step, step))
                return move(targetCFrame)
            end
            
            rootPart.CFrame = targetCFrame
            cleanup()
        end)
        
        if not success then
            cleanup()
            return false
        end
        return true
    end
    
    cleanup()
    
    local targetCF
    if typeof(target) == "Vector3" then
        targetCF = CFrame.new(target) * rootPart.CFrame.Rotation
    elseif typeof(target) == "CFrame" then
        targetCF = target
    else
        return false
    end
    
    local success = pcall(function()
        activeGyro = Instance.new("BodyGyro")
        activeGyro.P, activeGyro.D = 30000, 1000
        activeGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        activeGyro.CFrame = rootPart.CFrame
        activeGyro.Parent = rootPart
        
        activeVelocity = Instance.new("BodyVelocity")
        activeVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        activeVelocity.Velocity = Vector3.zero
        activeVelocity.Parent = rootPart
        
        noclipConnection = RunService.Stepped:Connect(function()
            for _, v in character:GetDescendants() do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    end)
    
    if not success then
        cleanup()
        return false
    end
    
    return move(targetCF)
end

print("Teleport API Loaded [✅] By XvasX and P'Lekkung.")

return teleport
