if not cast_tick then
    getgenv().cast_tick = nil
end

local IsMobile = not game:GetService("UserInputService").KeyboardEnabled and not game:GetService("UserInputService").MouseEnabled and not game:GetService("UserInputService").GamepadEnabled
local a
game.Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(
    function(b)
        if b.Name == "playerbar" and b.Parent.Name == "bar" then
            a = b
        end
    end
)
if not Rod then
    getgenv().Rod = function()
        local c = game.Players.LocalPlayer.Character
        if not c then
            return nil
        end
        for d, e in ipairs(c:GetChildren()) do
            if e:IsA("Tool") and (e.Name:find("rod") or e.Name:find("Rod")) then
                return e
            end
        end
        return nil
    end
end
-- if not Shake_UI then
--     getgenv().Shake_UI = function()
--         local f = game.Players.LocalPlayer.PlayerGui:FindFirstChild("shakeui")
--         if f then
--             local g = f:FindFirstChild("safezone")
--             local h = g and g:FindFirstChild("button")
--             if h.Visible then
--                 if IsMobile then
--                     game:GetService("GuiService").SelectedObject = h
--                     game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
--                     game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
--                     task.wait(.00000000000001)
--                     game:GetService("GuiService").SelectedObject = nil
--                 else
--                     h.Size = UDim2.new(2, 0, 2, 0)
--                     game:GetService("VirtualInputManager"):SendMouseButtonEvent(h.AbsolutePosition.X + h.AbsoluteSize.X / 2, h.AbsolutePosition.Y + h.AbsoluteSize.Y / 2, 0, true, game, 1)
--                     game:GetService("VirtualInputManager"):SendMouseButtonEvent(h.AbsolutePosition.X + h.AbsoluteSize.X / 2, h.AbsolutePosition.Y + h.AbsoluteSize.Y / 2, 0, false, game, 1)
--                 end
--             end
--         end
--     end
-- end
if not Reel_ui then
    getgenv().Reel_ui = function()
        a:GetPropertyChangedSignal("Position"):Wait()
        game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
    end
end
if not Cast then
    getgenv().Cast = function()
        local c = game.Players.LocalPlayer.Character
        if not c then
            return
        end
        local i = Rod()
        if not i then
            return
        end
        local j = {[1] = 100, [2] = 1}
        i.events.cast:FireServer(unpack(j))
        cast_tick = 0
    end
end
if not auto_fish_Function then
    task.spawn(
    function()
        getgenv().auto_fish_Function = game:GetService("RunService").Heartbeat:Connect(
            function()
                pcall(
                    function()
                        local i = Rod()
                        if i then
                            -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0;
                            Cast()
                            -- Shake_UI()
                            Reel_ui()
                        end
                    end
                )
                task.wait()
            end
        )
    end
)
end

--button prees
game.Players.LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "button" then
        task.wait(.2)
        game:GetService('GuiService').SelectedObject = descendant;
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game);
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game);
    end
end)

-- Anti Afk System
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiAFKGui"
ScreenGui.ResetOnSpawn = false

-- Try to insert GUI into CoreGui (more secure) or PlayerGui
local success, _ = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Create Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.8, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Create Corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Create Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Anti-AFK System"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Create Status Label
local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.4, 0)
Status.BackgroundTransparency = 1
Status.Text = "Status: Active"
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.TextSize = 14
Status.Font = Enum.Font.SourceSans
Status.Parent = MainFrame

-- Create Time Label
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Size = UDim2.new(1, 0, 0, 30)
TimeLabel.Position = UDim2.new(0, 0, 0.7, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "Time Active: 0s"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextSize = 14
TimeLabel.Font = Enum.Font.SourceSans
TimeLabel.Parent = MainFrame

-- Make Frame Draggable
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Anti-AFK System
local startTime = tick()
local connection

local function updateTime()
    local currentTime = tick() - startTime
    local seconds = math.floor(currentTime % 60)
    local minutes = math.floor((currentTime / 60) % 60)
    local hours = math.floor(currentTime / 3600)
    TimeLabel.Text = string.format("Time Active: %02d:%02d:%02d", hours, minutes, seconds)
end

-- Anti-AFK Function
local function antiAFK()
    local lastMove = tick()
    
    -- Connect to PreRender for smoother updates
    connection = RunService.PreRender:Connect(function()
        updateTime()
        
        -- Simulate activity every 15 minutes
        if tick() - lastMove >= 15 * 60 then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                Status.Text = "Status: Simulating Activity"
                Status.TextColor3 = Color3.fromRGB(255, 165, 0)
                wait(0.1)
                Status.Text = "Status: Active"
                Status.TextColor3 = Color3.fromRGB(0, 255, 0)
            end)
            lastMove = tick()
        end
    end)
end

-- Handle Player Focus
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Start Anti-AFK
antiAFK()

-- Cleanup on script end
ScreenGui.Destroying:Connect(function()
    if connection then
        connection:Disconnect()
    end
end)
