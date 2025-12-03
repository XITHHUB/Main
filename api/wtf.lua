local a = {}
a.Enabled = false
a.Range = 50
a.Delay = 0.1
a.MineAll = true
a.AutoEquipPickaxe = true
a.VisualESP = false
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
    local L = nil
    if A:IsA("Model") then
        L = A:FindFirstChildWhichIsA("ClickDetector", true)
    elseif A:IsA("BasePart") then
        L = A:FindFirstChild("ClickDetector")
    end
    if L then
        fireclickdetector(L)
        return true
    end
    local M = nil
    if A:IsA("Model") then
        M = A:FindFirstChildWhichIsA("ProximityPrompt", true)
    elseif A:IsA("BasePart") then
        M = A:FindFirstChild("ProximityPrompt")
    end
    if M then
        fireproximityprompt(M)
        return true
    end
    if self.ToolService then
        pcall(
            function()
                self.ToolService:ToolActivated(self.Pickaxe and self.Pickaxe.Name or "Pickaxe")
            end
        )
    end
    local N = c:FindFirstChild("ToolRemote") or c:FindFirstChild("MineRemote") or c:FindFirstChild("HitRemote")
    if N and N:IsA("RemoteEvent") then
        N:FireServer(A)
        return true
    end
    local q = h.Character
    if q then
        local s = q:FindFirstChildWhichIsA("Tool")
        if s then
            pcall(
                function()
                    s:Activate()
                end
            )
            local O =
                s:FindFirstChild("ActivateRemote") or s:FindFirstChild("Remote") or
                s:FindFirstChildWhichIsA("RemoteEvent")
            if O then
                O:FireServer(A)
                return true
            end
        end
    end
    return false
end
function a:TeleportToOre(K)
    local q = h.Character
    if not q then
        return
    end
    local x = q:FindFirstChild("HumanoidRootPart")
    if not x then
        return
    end
    local P = K.Position + Vector3.new(0, 3, 0)
    x.CFrame = CFrame.new(P)
end
function a:Start()
    if self.Enabled then
        return
    end
    self.Enabled = true
    print("[AuraMine] Starting auto mine...")
    self:EquipPickaxe()
    self.Connections.MineLoop =
        d.Heartbeat:Connect(
        function()
            if not self.Enabled then
                return
            end
            local q = h.Character
            if not q then
                return
            end
            local w = self:GetAllOres()
            if #w > 0 then
                if self.MineAll then
                    for i, K in ipairs(w) do
                        if not self.Enabled then
                            break
                        end
                        self:MineOre(K)
                    end
                else
                    self:MineOre(w[1])
                end
            end
        end
    )
    self.Connections.DelayLoop =
        task.spawn(
        function()
            while self.Enabled do
                task.wait(self.Delay)
            end
        end
    )
    self.Connections.EquipLoop =
        d.Heartbeat:Connect(
        function()
            if not self.Enabled then
                return
            end
            self:EquipPickaxe()
        end
    )
    print("[AuraMine] Auto mine started!")
end
function a:Stop()
    self.Enabled = false
    for p, Q in pairs(self.Connections) do
        if typeof(Q) == "RBXScriptConnection" then
            Q:Disconnect()
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
        local R = Instance.new("Highlight")
        R.Name = "AuraMineESP"
        R.FillColor = Color3.fromRGB(0, 255, 0)
        R.OutlineColor = Color3.fromRGB(255, 255, 255)
        R.FillTransparency = 0.5
        R.OutlineTransparency = 0
        R.Adornee = A
        R.Parent = CoreGui
        table.insert(self.ESPObjects, R)
        local S = Instance.new("BillboardGui")
        S.Name = "AuraMineLabel"
        S.Size = UDim2.new(0, 100, 0, 30)
        S.StudsOffset = Vector3.new(0, 3, 0)
        S.AlwaysOnTop = true
        S.Adornee = A:IsA("Model") and (A.PrimaryPart or A:FindFirstChildWhichIsA("BasePart")) or A
        S.Parent = CoreGui
        local T = Instance.new("TextLabel")
        T.Size = UDim2.new(1, 0, 1, 0)
        T.BackgroundTransparency = 1
        T.TextColor3 = Color3.fromRGB(0, 255, 0)
        T.TextStrokeTransparency = 0
        T.Text = string.format("%s [%.1f]", A.Name, K.Distance)
        T.Parent = S
        table.insert(self.ESPObjects, S)
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
function a:SetRange(U)
    self.Range = U or 50
    print("[AuraMine] Range set to: " .. self.Range)
end
function a:SetDelay(V)
    self.Delay = V or 0.1
    print("[AuraMine] Delay set to: " .. self.Delay)
end
function a:SetMineAll(W)
    self.MineAll = W
    print("[AuraMine] Mine all: " .. tostring(self.MineAll))
end
function a:SetESP(W)
    self.VisualESP = W
    if W then
        self:CreateESP()
    else
        self:ClearESP()
    end
    print("[AuraMine] ESP: " .. tostring(self.VisualESP))
end
function a:SetupKeybind(X)
    X = X or Enum.KeyCode.M
    self.Connections.Keybind =
        g.InputBegan:Connect(
        function(Y, Z)
            if Z then
                return
            end
            if Y.KeyCode == X then
                self:Toggle()
            end
        end
    )
    print("[AuraMine] Keybind set to: " .. X.Name)
end
return a
