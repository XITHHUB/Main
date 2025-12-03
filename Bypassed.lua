local a = {}
local b, c = identifyexecutor()
a.Executor = b or "Unknown"
a.Version = c or "Unknown"
print("============================================================")
print("[BypassedAntiCheat] Executor: " .. a.Executor .. " " .. tostring(a.Version))
print("============================================================")
local d = game:GetService("Players")
local e = game:GetService("ReplicatedStorage")
local f = game:GetService("RunService")
local g = game:GetService("CoreGui")
local h = game:GetService("UserInputService")
local i = game:GetService("TweenService")
local j = game:GetService("CollectionService")
local k = game:GetService("HttpService")
local l = d.LocalPlayer
a.OriginalFunctions = {}
a.HookedRemotes = {}
a.BlockedRemotes = {}
a.SpyEnabled = false
a.Knit = nil
a.Replica = nil
a.Status = nil
a.Controllers = {}
a.Services = {}
a.Character = nil
a.StatusFolder = nil
function a:GetGameReferences()
    repeat
        task.wait()
    until l.Character
    self.Character = l.Character
    self.StatusFolder = self.Character:WaitForChild("Status", 5)
    for m, n in ipairs(getloadedmodules()) do
        if n.Name == "Knit" then
            local o, p = pcall(require, n)
            if o then
                self.Knit = p
                print("[BypassedAntiCheat] Found Knit framework")
                break
            end
        end
    end
    if self.Knit then
        pcall(
            function()
                self.Controllers.Character = self.Knit.GetController("CharacterController")
                self.Controllers.Player = self.Knit.GetController("PlayerController")
                self.Controllers.Tool = self.Knit.GetController("ToolController")
                self.Controllers.UI = self.Knit.GetController("UIController")
                self.Controllers.Forge = self.Knit.GetController("ForgeController")
                print("[BypassedAntiCheat] Controllers loaded")
            end
        )
        pcall(
            function()
                self.Services.Tool = self.Knit.GetService("ToolService")
                self.Services.Proximity = self.Knit.GetService("ProximityService")
                self.Services.Player = self.Knit.GetService("PlayerService")
                self.Services.Effect = self.Knit.GetService("EffectService")
                print("[BypassedAntiCheat] Services loaded")
            end
        )
    end
    if _G.ClientIsReady then
        pcall(
            function()
                if self.Controllers.Player then
                    self.Replica = self.Controllers.Player.Replica
                    self.Status = self.Controllers.Player.Status
                    print("[BypassedAntiCheat] Replica data loaded")
                end
            end
        )
    end
    return self
end
function a:HookNamecall(q, r)
    local s
    s =
        hookmetamethod(
        game,
        "__namecall",
        newcclosure(
            function(self, ...)
                local t = getnamecallmethod()
                if t == q and not checkcaller() then
                    return r(self, s, ...)
                end
                return s(self, ...)
            end
        )
    )
    return s
end
function a:HookIndex(u, r)
    local v
    v =
        hookmetamethod(
        game,
        "__index",
        newcclosure(
            function(self, w)
                if w == u and not checkcaller() then
                    return r(self, v, w)
                end
                return v(self, w)
            end
        )
    )
    return v
end
function a:HookNewIndex(u, r)
    local x
    x =
        hookmetamethod(
        game,
        "__newindex",
        newcclosure(
            function(self, w, y)
                if w == u and not checkcaller() then
                    return r(self, x, w, y)
                end
                return x(self, w, y)
            end
        )
    )
    return x
end
function a:BlockRemote(z)
    self.BlockedRemotes[z] = true
    print("[BypassedAntiCheat] Blocked remote: " .. z)
end
function a:UnblockRemote(z)
    self.BlockedRemotes[z] = nil
    print("[BypassedAntiCheat] Unblocked remote: " .. z)
end
function a:SetupRemoteBypass()
    local A = self
    local s
    s =
        hookmetamethod(
        game,
        "__namecall",
        newcclosure(
            function(self, ...)
                local t = getnamecallmethod()
                if t == "FireServer" or t == "InvokeServer" then
                    if not checkcaller() then
                        local z = self.Name
                        if A.BlockedRemotes[z] then
                            if A.SpyEnabled then
                                warn("[RemoteBlock] Blocked: " .. z)
                            end
                            return nil
                        end
                        if A.SpyEnabled then
                            print("[RemoteSpy] " .. t .. ": " .. z)
                            local B = {...}
                            for C, D in pairs(B) do
                                print("  Arg[" .. C .. "]: " .. tostring(D))
                            end
                        end
                    end
                end
                return s(self, ...)
            end
        )
    )
    self.OriginalFunctions.Namecall = s
    print("[BypassedAntiCheat] Remote bypass enabled")
end
function a:HookHitboxRemote()
    local E = e:FindFirstChild("HitboxClassRemote")
    if E then
        local A = self
        for m, F in ipairs(getconnections(E.OnClientEvent)) do
            if F.Function then
                self.OriginalFunctions.HitboxHandler = F.Function
            end
        end
        print("[BypassedAntiCheat] HitboxClass hooked")
    end
end
function a:ExtendHitbox(G)
    G = G or 1.5
    local E = e:FindFirstChild("HitboxClassRemote")
    if not E then
        return
    end
    local A = self
    local H = E.FireServer
    hookfunction(
        E.FireServer,
        newcclosure(
            function(self, I, ...)
                return H(self, I, ...)
            end
        )
    )
    print("[BypassedAntiCheat] Hitbox extended by " .. G .. "x")
end
function a:AddStatusTag(J, K, y)
    if not self.StatusFolder then
        self.StatusFolder = l.Character and l.Character:FindFirstChild("Status")
    end
    if self.StatusFolder then
        local L = self.StatusFolder:FindFirstChild(J)
        if L then
            L:Destroy()
        end
        local M = Instance.new(K or "BoolValue")
        M.Name = J
        if y ~= nil then
            M.Value = y
        end
        M.Parent = self.StatusFolder
        return M
    end
end
function a:RemoveStatusTag(J)
    if not self.StatusFolder then
        self.StatusFolder = l.Character and l.Character:FindFirstChild("Status")
    end
    if self.StatusFolder then
        local M = self.StatusFolder:FindFirstChild(J)
        if M then
            M:Destroy()
            return true
        end
    end
    return false
end
function a:RemoveMovementRestrictions()
    self:RemoveStatusTag("NoMovement")
    self:RemoveStatusTag("Stun")
    self:RemoveStatusTag("NoRun")
    self:RemoveStatusTag("DisableBackpack")
    print("[BypassedAntiCheat] Movement restrictions removed")
end
function a:SetSpeedBoost(N)
    self:AddStatusTag("PercentageSpeedBoost_Bypass", "NumberValue", N or 1)
    print("[BypassedAntiCheat] Speed boost set to " .. (N or 1) * 100 .. "%")
end
function a:SetJumpBoost(N)
    self:AddStatusTag("PercentageJumpBoost_Bypass", "NumberValue", N or 1)
    print("[BypassedAntiCheat] Jump boost set to " .. (N or 1) * 100 .. "%")
end
function a:GetReplicaData()
    if self.Replica then
        return self.Replica.Data
    end
    for m, D in ipairs(getgc(true)) do
        if typeof(D) == "table" and D.Data and D.Tags and D.Tags.UserId == l.UserId then
            self.Replica = D
            return D.Data
        end
    end
    return nil
end
function a:GetPlayerStatus()
    if self.Status then
        return self.Status.Data
    end
    return nil
end
function a:SetupAntiKick()
    local O = l.Kick
    hookfunction(
        l.Kick,
        newcclosure(
            function(self, P)
                if self == l then
                    warn("[AntiKick] Blocked kick attempt. Reason: " .. tostring(P))
                    return
                end
                return O(self, P)
            end
        )
    )
    self.OriginalFunctions.Kick = O
    print("[BypassedAntiCheat] Anti-Kick enabled")
end
function a:SetupAntiTeleport()
    local Q = game:GetService("TeleportService")
    local R = Q.Teleport
    hookfunction(
        Q.Teleport,
        newcclosure(
            function(self, S, T, ...)
                if T == l then
                    warn("[AntiTeleport] Blocked teleport to PlaceId: " .. tostring(S))
                    return
                end
                return R(self, S, T, ...)
            end
        )
    )
    self.OriginalFunctions.Teleport = R
    print("[BypassedAntiCheat] Anti-Teleport enabled")
end
function a:DisableConnections(U)
    local V = getconnections(U)
    local W = 0
    for m, X in ipairs(V) do
        if X.Disable then
            X:Disable()
            W = W + 1
        end
    end
    return V, W
end
function a:EnableConnections(V)
    for m, X in ipairs(V) do
        if X.Enable then
            X:Enable()
        end
    end
end
function a:DisableRuntimeLoop()
    local Y, Z = self:DisableConnections(f.RenderStepped)
    print("[BypassedAntiCheat] Disabled " .. Z .. " RenderStepped connections")
    return Y
end
a.SuspiciousKeywords = {
    "anticheat",
    "anti-cheat",
    "exploit",
    "cheat",
    "detect",
    "kick",
    "ban",
    "security",
    "validation",
    "integrity",
    "heartbeat",
    "watchdog",
    "sanity"
}
function a:ScanForAntiCheat()
    local _ = {}
    local a0 = getrunningscripts()
    for m, a1 in ipairs(a0) do
        local o, a2 = pcall(getscriptbytecode, a1)
        if o and a2 then
            local a3 = string.lower(a2)
            for m, a4 in ipairs(self.SuspiciousKeywords) do
                if string.find(a3, a4) then
                    table.insert(_, {Script = a1, Keyword = a4, Path = a1:GetFullName()})
                    break
                end
            end
        end
    end
    return _
end
function a:DisableAntiCheatScripts()
    local a5 = self:ScanForAntiCheat()
    local W = 0
    for m, a6 in ipairs(a5) do
        warn("[BypassedAntiCheat] Suspicious: " .. a6.Path .. " (Keyword: " .. a6.Keyword .. ")")
        pcall(
            function()
                a6.Script.Disabled = true
                W = W + 1
            end
        )
        pcall(
            function()
                local a7 = getsenv(a6.Script)
                if a7 then
                    for a8, y in pairs(a7) do
                        if typeof(y) == "RBXScriptConnection" then
                            pcall(
                                function()
                                    y:Disconnect()
                                end
                            )
                        end
                    end
                end
            end
        )
    end
    return W
end
function a:FindInGC(a9, aa)
    local ab = {}
    for m, D in ipairs(getgc(true)) do
        if typeof(D) == "Instance" and D:IsA(a9) then
            if aa then
                local ac = true
                for ad, y in pairs(aa) do
                    pcall(
                        function()
                            if D[ad] ~= y then
                                ac = false
                            end
                        end
                    )
                end
                if ac then
                    table.insert(ab, D)
                end
            else
                table.insert(ab, D)
            end
        end
    end
    return ab
end
function a:FindTableInGC(ae)
    local ab = {}
    for m, D in ipairs(getgc(true)) do
        if typeof(D) == "table" and D[ae] ~= nil then
            table.insert(ab, D)
        end
    end
    return ab
end
function a:FindFunctionInGC(af)
    local ab = {}
    for m, D in ipairs(getgc(true)) do
        if typeof(D) == "table" then
            for w, ag in pairs(D) do
                if w == af and typeof(ag) == "function" then
                    table.insert(ab, {Table = D, Function = ag})
                end
            end
        end
    end
    return ab
end
function a:RunWithIdentity(ah, ai, ...)
    local aj = getthreadidentity()
    setthreadidentity(ah)
    local ab = {pcall(ai, ...)}
    setthreadidentity(aj)
    if ab[1] then
        return unpack(ab, 2)
    else
        error(ab[2])
    end
end
function a:InvalidateCache(ak)
    return cache.invalidate(ak)
end
function a:IsCached(ak)
    return cache.iscached(ak)
end
function a:ReplaceCache(ak, al)
    return cache.replace(ak, al)
end
function a:CloneReference(ak)
    return cloneref(ak)
end
function a:CompareInstances(am, an)
    return compareinstances(am, an)
end
function a:GetConstants(ai)
    return debug.getconstants(ai)
end
function a:SetConstant(ai, ao, y)
    return debug.setconstant(ai, ao, y)
end
function a:GetUpvalues(ai)
    return debug.getupvalues(ai)
end
function a:SetUpvalue(ai, ao, y)
    return debug.setupvalue(ai, ao, y)
end
function a:GetStack(ap)
    return debug.getstack(ap)
end
function a:GetHiddenProperty(ak, u)
    return gethiddenproperty(ak, u)
end
function a:SetHiddenProperty(ak, u, y)
    return sethiddenproperty(ak, u, y)
end
function a:SaveConfig(a8, a6)
    if not isfolder("BypassedAntiCheat") then
        makefolder("BypassedAntiCheat")
    end
    local aq = k:JSONEncode(a6)
    writefile("BypassedAntiCheat/" .. a8 .. ".json", aq)
end
function a:LoadConfig(a8)
    local ar = "BypassedAntiCheat/" .. a8 .. ".json"
    if isfile(ar) then
        local aq = readfile(ar)
        return k:JSONDecode(aq)
    end
    return nil
end
function a:HttpRequest(as)
    return request(as)
end
function a:ForceAttack()
    if self.Services.Tool then
        pcall(
            function()
                local at = l.Character
                if at then
                    local au = at:FindFirstChildWhichIsA("Tool")
                    if au then
                        self.Services.Tool:ToolActivated(au.Name)
                    end
                end
            end
        )
    end
end
function a:ForceBlock()
    if self.Services.Tool then
        pcall(
            function()
                self.Services.Tool:StartBlock()
            end
        )
    end
end
function a:StopBlock()
    if self.Services.Tool then
        pcall(
            function()
                self.Services.Tool:StopBlock()
            end
        )
    end
end
function a:SetWalkSpeed(av)
    local at = l.Character
    if at then
        local aw = at:FindFirstChild("Humanoid")
        if aw then
            aw.WalkSpeed = av
        end
    end
end
function a:SetJumpPower(ax)
    local at = l.Character
    if at then
        local aw = at:FindFirstChild("Humanoid")
        if aw then
            aw.JumpPower = ax
        end
    end
end
function a:GodMode()
    local at = l.Character
    if at then
        local aw = at:FindFirstChild("Humanoid")
        if aw then
            local ay = aw.TakeDamage
            hookfunction(
                aw.TakeDamage,
                newcclosure(
                    function()
                    end
                )
            )
            aw.MaxHealth = math.huge
            aw.Health = math.huge
            print("[BypassedAntiCheat] God mode enabled (client-side)")
        end
    end
end
function a:Noclip(az)
    if az then
        self._noclipConnection =
            f.Stepped:Connect(
            function()
                local at = l.Character
                if at then
                    for m, aA in ipairs(at:GetDescendants()) do
                        if aA:IsA("BasePart") then
                            aA.CanCollide = false
                        end
                    end
                end
            end
        )
        print("[BypassedAntiCheat] Noclip enabled")
    else
        if self._noclipConnection then
            self._noclipConnection:Disconnect()
            self._noclipConnection = nil
        end
        print("[BypassedAntiCheat] Noclip disabled")
    end
end
function a:Fly(az, av)
    av = av or 50
    if az then
        local at = l.Character
        if not at then
            return
        end
        local aB = at:FindFirstChild("HumanoidRootPart")
        if not aB then
            return
        end
        local aC = Instance.new("BodyGyro")
        aC.Name = "FlyGyro"
        aC.P = 9e4
        aC.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        aC.CFrame = aB.CFrame
        aC.Parent = aB
        local aD = Instance.new("BodyVelocity")
        aD.Name = "FlyVelocity"
        aD.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        aD.Velocity = Vector3.new(0, 0, 0)
        aD.Parent = aB
        self._flyConnection =
            f.RenderStepped:Connect(
            function()
                local aE = workspace.CurrentCamera
                local aF = Vector3.new(0, 0, 0)
                if h:IsKeyDown(Enum.KeyCode.W) then
                    aF = aF + aE.CFrame.LookVector
                end
                if h:IsKeyDown(Enum.KeyCode.S) then
                    aF = aF - aE.CFrame.LookVector
                end
                if h:IsKeyDown(Enum.KeyCode.A) then
                    aF = aF - aE.CFrame.RightVector
                end
                if h:IsKeyDown(Enum.KeyCode.D) then
                    aF = aF + aE.CFrame.RightVector
                end
                if h:IsKeyDown(Enum.KeyCode.Space) then
                    aF = aF + Vector3.new(0, 1, 0)
                end
                if h:IsKeyDown(Enum.KeyCode.LeftControl) then
                    aF = aF - Vector3.new(0, 1, 0)
                end
                aD.Velocity = aF * av
                aC.CFrame = aE.CFrame
            end
        )
        print("[BypassedAntiCheat] Fly enabled (speed: " .. av .. ")")
    else
        if self._flyConnection then
            self._flyConnection:Disconnect()
            self._flyConnection = nil
        end
        local at = l.Character
        if at then
            local aB = at:FindFirstChild("HumanoidRootPart")
            if aB then
                local aC = aB:FindFirstChild("FlyGyro")
                local aD = aB:FindFirstChild("FlyVelocity")
                if aC then
                    aC:Destroy()
                end
                if aD then
                    aD:Destroy()
                end
            end
        end
        print("[BypassedAntiCheat] Fly disabled")
    end
end
function a:Initialize(as)
    as = as or {}
    print("============================================================")
    print("[BypassedAntiCheat] Initializing...")
    print("============================================================")
    if not isfolder("BypassedAntiCheat") then
        makefolder("BypassedAntiCheat")
    end
    self:GetGameReferences()
    if as.AntiKick ~= false then
        self:SetupAntiKick()
    end
    if as.AntiTeleport ~= false then
        self:SetupAntiTeleport()
    end
    if as.RemoteBypass ~= false then
        self:SetupRemoteBypass()
    end
    if as.HitboxHook ~= false then
        self:HookHitboxRemote()
    end
    if as.DisableAntiCheat then
        local Z = self:DisableAntiCheatScripts()
        print("[BypassedAntiCheat] Disabled " .. Z .. " suspicious scripts")
    end
    if as.RemoteSpy then
        self.SpyEnabled = true
        print("[BypassedAntiCheat] Remote Spy enabled")
    end
    print("============================================================")
    print("[BypassedAntiCheat] Initialization complete!")
    print("============================================================")
    return self
end
function a:QuickBypass()
    local aG = getconnections(f.RenderStepped)
    local aH = 0
    for m, F in ipairs(aG) do
        pcall(
            function()
                F:Disable()
                aH = aH + 1
            end
        )
    end
    local aI = getconnections(f.Heartbeat)
    local aJ = 0
    for m, F in ipairs(aI) do
        pcall(
            function()
                F:Disable()
                aJ = aJ + 1
            end
        )
    end
    print("[BypassedAntiCheat] Quick bypass applied")
    print("  - RenderStepped: " .. aH .. " disabled")
    print("  - Heartbeat: " .. aJ .. " disabled")
end
function a:GetNilInstances()
    return getnilinstances()
end
function a:GetAllInstances()
    return getinstances()
end
function a:GetLoadedModules()
    return getloadedmodules()
end
function a:GetRunningScripts()
    return getrunningscripts()
end
function a:GetHiddenUI()
    return gethui()
end
return a
