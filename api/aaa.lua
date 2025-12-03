local a = {}
a.Enabled = false
a.Range = 50
a.Delay = 0.3
a.MineAll = true
a.AutoEquipPickaxe = true
a.VisualESP = false
a.TeleportToOre = false
a.InstantMine = true
local b = game:GetService("Players")
local c = game:GetService("ReplicatedStorage")
local d = game:GetService("RunService")
local e = game:GetService("Workspace")
local f = game:GetService("TweenService")
local g = game:GetService("UserInputService")
local h = b.LocalPlayer
a.Connections = {}
a.ESPObjects = {}
a.Ores = {}
a.Pickaxe = nil
a.ToolService = nil
a.Knit = nil
a.HitboxRemote = nil
a.ToolController = nil
a.OreFolders = {"Ores", "MineableOres", "Rocks", "Nodes", "MiningNodes", "Resources"}
a.OreNames = {
    "Ore",
    "Rock",
    "Node",
    "Stone",
    "Iron",
    "Gold",
    "Diamond",
    "Coal",
    "Copper",
    "Silver",
    "Mythril",
    "Adamantite",
    "Crystal",
    "Gem",
    "Mineral",
    "Vein"
}
function a:Init()
    print("============================================================")
    print("[AuraMine] Initializing...")
    print("============================================================")
    repeat
        task.wait()
    until h.Character
    pcall(
        function()
            for i, j in ipairs(getloadedmodules()) do
                if j.Name == "Knit" then
                    local k, l = pcall(require, j)
                    if k then
                        self.Knit = l
                        print("[AuraMine] Found Knit framework")
                    end
                    break
                end
            end
        end
    )
    if self.Knit then
        pcall(
            function()
                self.ToolService = self.Knit.GetService("ToolService")
                print("[AuraMine] Got ToolService")
            end
        )
        pcall(
            function()
                self.ToolController = self.Knit.GetController("ToolController")
                print("[AuraMine] Got ToolController")
            end
        )
    end
    self.HitboxRemote = c:FindFirstChild("HitboxClassRemote")
    if self.HitboxRemote then
        print("[AuraMine] Found HitboxClassRemote")
    end
    self:FindOreFolders()
    self:FindPickaxe()
    print("[AuraMine] Initialization complete!")
    print("============================================================")
    return self
end
function a:FindOreFolders()
    self.FoundOreFolders = {}
    for i, m in ipairs(self.OreFolders) do
        local n = e:FindFirstChild(m)
        if n then
            table.insert(self.FoundOreFolders, n)
            print("[AuraMine] Found ore folder: " .. m)
        end
    end
    for i, o in ipairs(e:GetChildren()) do
        if o:IsA("Folder") or o:IsA("Model") then
            local p = string.lower(o.Name)
            if string.find(p, "ore") or string.find(p, "mine") or string.find(p, "rock") then
                if not table.find(self.FoundOreFolders, o) then
                    table.insert(self.FoundOreFolders, o)
                    print("[AuraMine] Found ore folder: " .. o.Name)
                end
            end
        end
    end
    if #self.FoundOreFolders == 0 then
        print("[AuraMine] No ore folders found, will search entire workspace")
    end
end
function a:FindPickaxe()
    local q = h.Character
    local r = h:FindFirstChild("Backpack")
    if q then
        for i, s in ipairs(q:GetChildren()) do
            if s:IsA("Tool") then
                local p = string.lower(s.Name)
                if string.find(p, "pick") or string.find(p, "axe") or string.find(p, "mine") then
                    self.Pickaxe = s
                    print("[AuraMine] Found equipped pickaxe: " .. s.Name)
                    return s
                end
            end
        end
    end
    if r then
        for i, s in ipairs(r:GetChildren()) do
            if s:IsA("Tool") then
                local p = string.lower(s.Name)
                if string.find(p, "pick") or string.find(p, "axe") or string.find(p, "mine") then
                    self.Pickaxe = s
                    print("[AuraMine] Found pickaxe in backpack: " .. s.Name)
                    return s
                end
            end
        end
    end
    if r and not self.Pickaxe then
        local t = r:FindFirstChildWhichIsA("Tool")
        if t then
            self.Pickaxe = t
            print("[AuraMine] Using first tool: " .. t.Name)
            return t
        end
    end
    print("[AuraMine] No pickaxe found!")
    return nil
end
function a:EquipPickaxe()
    if not self.AutoEquipPickaxe then
        return
    end
    local q = h.Character
    if not q then
        return
    end
    local u = q:FindFirstChild("Humanoid")
    if not u then
        return
    end
    local v = q:FindFirstChildWhichIsA("Tool")
    if v and self.Pickaxe and v == self.Pickaxe then
        return true
    end
    self:FindPickaxe()
    if self.Pickaxe and self.Pickaxe.Parent == h.Backpack then
        u:EquipTool(self.Pickaxe)
        return true
    end
    return false
end
function a:GetAllOres()
    local w = {}
    local q = h.Character
    if not q then
        return w
    end
    local x = q:FindFirstChild("HumanoidRootPart")
    if not x then
        return w
    end
    local y = x.Position
    local function z(A)
        if not A:IsA("BasePart") and not A:IsA("Model") then
            return false
        end
        local p = string.lower(A.Name)
        for i, B in ipairs(self.OreNames) do
            if string.find(p, string.lower(B)) then
                return true
            end
        end
        if A:IsA("Model") then
            for i, C in ipairs(A:GetDescendants()) do
                if C:IsA("ClickDetector") then
                    return true
                end
            end
        elseif A:IsA("BasePart") then
            if A:FindFirstChild("ClickDetector") then
                return true
            end
        end
        if A:IsA("Model") then
            for i, C in ipairs(A:GetDescendants()) do
                if C:IsA("ProximityPrompt") then
                    local D = string.lower(C.ActionText or "")
                    if string.find(D, "mine") or string.find(D, "harvest") then
                        return true
                    end
                end
            end
        end
        return false
    end
    local function E(A)
        if A:IsA("Model") then
            local F = A.PrimaryPart or A:FindFirstChildWhichIsA("BasePart")
            if F then
                return F.Position
            end
        elseif A:IsA("BasePart") then
            return A.Position
        end
        return nil
    end
    if #self.FoundOreFolders > 0 then
        for i, n in ipairs(self.FoundOreFolders) do
            for i, A in ipairs(n:GetDescendants()) do
                if z(A) then
                    local G = E(A)
                    if G then
                        local H = (G - y).Magnitude
                        if H <= self.Range then
                            table.insert(w, {Object = A, Position = G, Distance = H})
                        end
                    end
                end
            end
        end
    else
        for i, A in ipairs(e:GetDescendants()) do
            if z(A) then
                local G = E(A)
                if G then
                    local H = (G - y).Magnitude
                    if H <= self.Range then
                        table.insert(w, {Object = A, Position = G, Distance = H})
                    end
                end
            end
        end
    end
    table.sort(
        w,
        function(I, J)
            return I.Distance < J.Distance
        end
    )
    return w
end
function a:MineOre(K)
    local A = K.Object
    if not A or not A.Parent then
        return false
    end
    local q = h.Character
    if not q then
        return false
    end
    local x = q:FindFirstChild("HumanoidRootPart")
    if not x then
        return false
    end
    local s = q:FindFirstChildWhichIsA("Tool")
    if not s then
        self:EquipPickaxe()
        task.wait(0.1)
        s = q:FindFirstChildWhichIsA("Tool")
        if not s then
            return false
        end
    end
    local L = s.Name
    local M = string.lower(L):find("pick") ~= nil
    if self.TeleportToOre and K.Distance > 10 then
        local N = K.Position + (x.Position - K.Position).Unit * 8
        x.CFrame = CFrame.new(N) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
        task.wait(0.05)
    end
    if self.ToolService then
        local k =
            pcall(
            function()
                self.ToolService:ToolActivated(L, false)
            end
        )
        if k then
            return true
        end
    end
    local O = {c:FindFirstChild("Remotes"), c:FindFirstChild("Events"), c:FindFirstChild("Network")}
    for i, n in ipairs(O) do
        if n then
            local P =
                n:FindFirstChild("ToolActivated") or n:FindFirstChild("ToolRemote") or n:FindFirstChild("UseToolRemote")
            if P and P:IsA("RemoteEvent") then
                P:FireServer(L, false)
                return true
            elseif P and P:IsA("RemoteFunction") then
                pcall(
                    function()
                        P:InvokeServer(L, false)
                    end
                )
                return true
            end
        end
    end
    for i, o in ipairs(s:GetDescendants()) do
        if o:IsA("RemoteEvent") then
            o:FireServer()
            return true
        end
    end
    pcall(
        function()
            s:Activate()
        end
    )
    local Q = nil
    if A:IsA("Model") then
        Q = A:FindFirstChildWhichIsA("ClickDetector", true)
    elseif A:IsA("BasePart") then
        Q = A:FindFirstChild("ClickDetector")
    end
    if Q then
        fireclickdetector(Q)
        return true
    end
    local R = nil
    if A:IsA("Model") then
        R = A:FindFirstChildWhichIsA("ProximityPrompt", true)
    elseif A:IsA("BasePart") then
        R = A:FindFirstChild("ProximityPrompt")
    end
    if R then
        fireproximityprompt(R)
        return true
    end
    return false
end
function a:ActivateTool()
    local q = h.Character
    if not q then
        return false
    end
    local s = q:FindFirstChildWhichIsA("Tool")
    if not s then
        return false
    end
    if self.ToolService then
        pcall(
            function()
                self.ToolService:ToolActivated(s.Name, false)
            end
        )
        return true
    end
    pcall(
        function()
            s:Activate()
        end
    )
    return true
end
function a:TeleportToOrePos(K)
    local q = h.Character
    if not q then
        return
    end
    local x = q:FindFirstChild("HumanoidRootPart")
    if not x then
        return
    end
    local S = (x.Position - K.Position).Unit
    local N = K.Position + S * 6 + Vector3.new(0, 2, 0)
    local T = CFrame.lookAt(N, K.Position)
    x.CFrame = T
end
function a:Start()
    if self.Enabled then
        return
    end
    self.Enabled = true
    print("[AuraMine] Starting auto mine...")
    self:EquipPickaxe()
    task.wait(0.2)
    self.Connections.MineLoop =
        task.spawn(
        function()
            while self.Enabled do
                local q = h.Character
                if q then
                    local s = q:FindFirstChildWhichIsA("Tool")
                    if not s then
                        self:EquipPickaxe()
                        task.wait(0.2)
                    end
                    local w = self:GetAllOres()
                    if #w > 0 then
                        if self.TeleportToOre then
                            local U = w[1]
                            self:TeleportToOrePos(U)
                            task.wait(0.05)
                        end
                        self:ActivateTool()
                        if self.MineAll and self.InstantMine then
                            for V = 1, math.min(#w, 5) do
                                task.wait(0.05)
                                self:ActivateTool()
                            end
                        end
                    end
                end
                task.wait(self.Delay)
            end
        end
    )
    self.Connections.EquipLoop =
        h.CharacterAdded:Connect(
        function(W)
            task.wait(1)
            if self.Enabled then
                self:FindPickaxe()
                self:EquipPickaxe()
            end
        end
    )
    print("[AuraMine] Auto mine started!")
    print("[AuraMine] Mining range: " .. self.Range .. " studs")
    print("[AuraMine] Mining delay: " .. self.Delay .. " seconds")
end
function a:Stop()
    self.Enabled = false
    for p, X in pairs(self.Connections) do
        if typeof(X) == "RBXScriptConnection" then
            X:Disconnect()
        elseif typeof(X) == "thread" then
            task.cancel(X)
        end
    end
    self.Connections = {}
    self:ClearESP()
    print("[AuraMine] Auto mine stopped!")
end
function a:Toggle()
    if self.Enabled then
        self:Stop()
    else
        self:Start()
    end
    return self.Enabled
end
function a:CreateESP()
    if not self.VisualESP then
        return
    end
    self:ClearESP()
    local w = self:GetAllOres()
    for i, K in ipairs(w) do
        local A = K.Object
        local Y = Instance.new("Highlight")
        Y.Name = "AuraMineESP"
        Y.FillColor = Color3.fromRGB(0, 255, 0)
        Y.OutlineColor = Color3.fromRGB(255, 255, 255)
        Y.FillTransparency = 0.5
        Y.OutlineTransparency = 0
        Y.Adornee = A
        Y.Parent = CoreGui
        table.insert(self.ESPObjects, Y)
        local Z = Instance.new("BillboardGui")
        Z.Name = "AuraMineLabel"
        Z.Size = UDim2.new(0, 100, 0, 30)
        Z.StudsOffset = Vector3.new(0, 3, 0)
        Z.AlwaysOnTop = true
        Z.Adornee = A:IsA("Model") and (A.PrimaryPart or A:FindFirstChildWhichIsA("BasePart")) or A
        Z.Parent = CoreGui
        local _ = Instance.new("TextLabel")
        _.Size = UDim2.new(1, 0, 1, 0)
        _.BackgroundTransparency = 1
        _.TextColor3 = Color3.fromRGB(0, 255, 0)
        _.TextStrokeTransparency = 0
        _.Text = string.format("%s [%.1f]", A.Name, K.Distance)
        _.Parent = Z
        table.insert(self.ESPObjects, Z)
    end
end
function a:ClearESP()
    for i, A in ipairs(self.ESPObjects) do
        if A and A.Parent then
            A:Destroy()
        end
    end
    self.ESPObjects = {}
end
function a:SetRange(a0)
    self.Range = a0 or 50
    print("[AuraMine] Range set to: " .. self.Range)
end
function a:SetDelay(a1)
    self.Delay = a1 or 0.3
    print("[AuraMine] Delay set to: " .. self.Delay)
end
function a:SetMineAll(a2)
    self.MineAll = a2
    print("[AuraMine] Mine all: " .. tostring(self.MineAll))
end
function a:SetESP(a2)
    self.VisualESP = a2
    if a2 then
        self:CreateESP()
    else
        self:ClearESP()
    end
    print("[AuraMine] ESP: " .. tostring(self.VisualESP))
end
function a:SetTeleport(a2)
    self.TeleportToOre = a2
    print("[AuraMine] Teleport to ore: " .. tostring(self.TeleportToOre))
end
function a:SetInstantMine(a2)
    self.InstantMine = a2
    print("[AuraMine] Instant mine: " .. tostring(self.InstantMine))
end
function a:SetupKeybind(a3)
    a3 = a3 or Enum.KeyCode.M
    self.Connections.Keybind =
        g.InputBegan:Connect(
        function(a4, a5)
            if a5 then
                return
            end
            if a4.KeyCode == a3 then
                self:Toggle()
            end
        end
    )
    print("[AuraMine] Keybind set to: " .. a3.Name)
end
return a
