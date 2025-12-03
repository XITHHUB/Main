local a = {}
a.Enabled = false
a.Range = 100
a.Delay = 0.1
a.AutoEquipPickaxe = true
a.VisualESP = false
local b = game:GetService("Players")
local c = game:GetService("ReplicatedStorage")
local d = game:GetService("RunService")
local e = game:GetService("Workspace")
local f = game:GetService("UserInputService")
local g = b.LocalPlayer
a.Connections = {}
a.ESPObjects = {}
a.Pickaxe = nil
a.ToolService = nil
a.Knit = nil
a.HitboxRemote = nil
a.CurrentTick = nil
function a:Init()
    print("============================================================")
    print("[AuraMine] Initializing Instant Ore Damage...")
    print("============================================================")
    repeat
        task.wait()
    until g.Character
    self.HitboxRemote = c:WaitForChild("HitboxClassRemote", 10)
    if self.HitboxRemote then
        print("[AuraMine] Found HitboxClassRemote - Instant damage enabled!")
    else
        warn("[AuraMine] HitboxClassRemote not found! Falling back to normal method.")
    end
    pcall(
        function()
            for h, i in ipairs(getloadedmodules()) do
                if i.Name == "Knit" then
                    local j, k = pcall(require, i)
                    if j then
                        self.Knit = k
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
    self:FindPickaxe()
    print("[AuraMine] Initialization complete!")
    print("============================================================")
    return self
end
function a:FindPickaxe()
    local l = g.Character
    local m = g:FindFirstChild("Backpack")
    if l then
        for h, n in ipairs(l:GetChildren()) do
            if n:IsA("Tool") then
                local o = string.lower(n.Name)
                if string.find(o, "pick") then
                    self.Pickaxe = n
                    return n
                end
            end
        end
    end
    if m then
        for h, n in ipairs(m:GetChildren()) do
            if n:IsA("Tool") then
                local o = string.lower(n.Name)
                if string.find(o, "pick") then
                    self.Pickaxe = n
                    return n
                end
            end
        end
    end
    return nil
end
function a:EquipPickaxe()
    if not self.AutoEquipPickaxe then
        return
    end
    local l = g.Character
    if not l then
        return
    end
    local p = l:FindFirstChild("Humanoid")
    if not p then
        return
    end
    local q = l:FindFirstChildWhichIsA("Tool")
    if q and string.lower(q.Name):find("pick") then
        return true
    end
    self:FindPickaxe()
    if self.Pickaxe and self.Pickaxe.Parent == g.Backpack then
        p:EquipTool(self.Pickaxe)
        return true
    end
    return false
end
function a:GetAllOres()
    local r = {}
    local l = g.Character
    if not l then
        return r
    end
    local s = l:FindFirstChild("HumanoidRootPart")
    if not s then
        return r
    end
    local t = s.Position
    for h, u in ipairs(e:GetDescendants()) do
        if u:IsA("BasePart") and u.Parent and u.Parent ~= l then
            local o = string.lower(u.Name)
            local v = u.Parent and string.lower(u.Parent.Name) or ""
            local w = false
            local x = {
                "ore",
                "rock",
                "node",
                "stone",
                "vein",
                "mineral",
                "crystal",
                "gem",
                "iron",
                "gold",
                "copper",
                "coal",
                "diamond",
                "silver",
                "mythril",
                "adamant"
            }
            for h, y in ipairs(x) do
                if string.find(o, y) or string.find(v, y) then
                    w = true
                    break
                end
            end
            if not w and u.Parent then
                local z = u.Parent.Parent
                if z then
                    local A = string.lower(z.Name)
                    for h, y in ipairs({"ore", "rock", "mine", "node", "resource"}) do
                        if string.find(A, y) then
                            w = true
                            break
                        end
                    end
                end
            end
            if not w then
                if
                    u:FindFirstChild("ClickDetector") or
                        u.Parent and u.Parent:FindFirstChildWhichIsA("ClickDetector", true)
                 then
                    w = true
                end
            end
            if w then
                local B = (u.Position - t).Magnitude
                if B <= self.Range then
                    table.insert(r, {Object = u, Position = u.Position, Distance = B})
                end
            end
        end
    end
    table.sort(
        r,
        function(C, D)
            return C.Distance < D.Distance
        end
    )
    return r
end
function a:InstantDamageOres()
    local l = g.Character
    if not l then
        return 0
    end
    local n = l:FindFirstChildWhichIsA("Tool")
    if not n then
        self:EquipPickaxe()
        task.wait(0.1)
        n = l:FindFirstChildWhichIsA("Tool")
        if not n then
            return 0
        end
    end
    if self.ToolService then
        pcall(
            function()
                self.ToolService:ToolActivated(n.Name, false)
            end
        )
    end
    local r = self:GetAllOres()
    if #r == 0 then
        return 0
    end
    if self.HitboxRemote then
        local E = workspace:GetServerTimeNow()
        local F = {}
        for h, G in ipairs(r) do
            table.insert(F, G.Object)
        end
        pcall(
            function()
                self.HitboxRemote:FireServer(E, F)
            end
        )
        return #F
    end
    return 0
end
function a:ClickAllOres()
    local r = self:GetAllOres()
    local H = 0
    for h, G in ipairs(r) do
        local u = G.Object
        local I = u:FindFirstChild("ClickDetector")
        if not I and u.Parent then
            I = u.Parent:FindFirstChildWhichIsA("ClickDetector", true)
        end
        if I then
            pcall(
                function()
                    fireclickdetector(I)
                    H = H + 1
                end
            )
        end
        local J = u:FindFirstChild("ProximityPrompt")
        if not J and u.Parent then
            J = u.Parent:FindFirstChildWhichIsA("ProximityPrompt", true)
        end
        if J then
            pcall(
                function()
                    fireproximityprompt(J)
                    H = H + 1
                end
            )
        end
    end
    return H
end
function a:Start()
    if self.Enabled then
        return
    end
    self.Enabled = true
    print("[AuraMine] Starting instant ore damage...")
    print("[AuraMine] Range: " .. self.Range .. " studs")
    print("[AuraMine] Delay: " .. self.Delay .. " seconds")
    self:EquipPickaxe()
    task.wait(0.2)
    self.Connections.MainLoop =
        task.spawn(
        function()
            while self.Enabled do
                local l = g.Character
                if l then
                    local n = l:FindFirstChildWhichIsA("Tool")
                    if not n then
                        self:EquipPickaxe()
                        task.wait(0.2)
                    end
                    local K = self:InstantDamageOres()
                    if K == 0 then
                        self:ClickAllOres()
                    end
                end
                task.wait(self.Delay)
            end
        end
    )
    self.Connections.Respawn =
        g.CharacterAdded:Connect(
        function()
            task.wait(1)
            if self.Enabled then
                self:FindPickaxe()
                self:EquipPickaxe()
            end
        end
    )
    print("[AuraMine] Instant mining started!")
end
function a:Stop()
    self.Enabled = false
    for h, L in pairs(self.Connections) do
        if typeof(L) == "RBXScriptConnection" then
            L:Disconnect()
        elseif typeof(L) == "thread" then
            pcall(
                function()
                    task.cancel(L)
                end
            )
        end
    end
    self.Connections = {}
    self:ClearESP()
    print("[AuraMine] Stopped!")
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
    self:ClearESP()
    local r = self:GetAllOres()
    for h, G in ipairs(r) do
        local M = Instance.new("Highlight")
        M.FillColor = Color3.fromRGB(0, 255, 0)
        M.OutlineColor = Color3.fromRGB(255, 255, 255)
        M.FillTransparency = 0.5
        M.Adornee = G.Object.Parent:IsA("Model") and G.Object.Parent or G.Object
        M.Parent = game:GetService("CoreGui")
        table.insert(self.ESPObjects, M)
    end
end
function a:ClearESP()
    for h, u in ipairs(self.ESPObjects) do
        if u and u.Parent then
            u:Destroy()
        end
    end
    self.ESPObjects = {}
end
function a:SetRange(N)
    self.Range = N or 100
    print("[AuraMine] Range: " .. self.Range)
end
function a:SetDelay(O)
    self.Delay = O or 0.1
    print("[AuraMine] Delay: " .. self.Delay)
end
function a:SetESP(P)
    self.VisualESP = P
    if P then
        self:CreateESP()
    else
        self:ClearESP()
    end
end
function a:SetupKeybind(Q)
    Q = Q or Enum.KeyCode.M
    self.Connections.Keybind =
        f.InputBegan:Connect(
        function(R, S)
            if S then
                return
            end
            if R.KeyCode == Q then
                self:Toggle()
            end
        end
    )
    print("[AuraMine] Keybind: " .. Q.Name)
end
return a
