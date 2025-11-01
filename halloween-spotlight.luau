--Time To Run
task.wait(5);

--Game Load Check
if not game:IsLoaded() then
    repeat
        game.Loaded:Wait();
    until game:IsLoaded()
end

--In Game check
local Ingame = false;
if game.PlaceId == 11126398230 or game.PlaceId == 7633631103 or game.PlaceId == 7633631351 or game.PlaceId == 7633631511 then
    Ingame = true;
end

--Ui Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))();
local Window = Library.CreateLib("The Mimic Script || Halloween Spotlight 🎃👻🍬", "LightTheme");

--Tab
local BadgeTab = Window:NewTab("Badges");
local MainTab = Window:NewTab("Main");
local MiscTab = Window:NewTab("Misc");
local CreditTab = Window:NewTab("Credit");

--Section
local BadgeHeader = BadgeTab:NewSection("Badges Check [🏅]");
if not Ingame then
    local MainHeader = MainTab:NewSection("Halloween Spotlight [🎃]");
end
local MiscHeader = MiscTab:NewSection("Miscellaneous [⚙️]");
local CreditHeader = CreditTab:NewSection("Credit [💖]");


--Badge Check
local player = game:GetService("Players").LocalPlayer
local BadgeService = game:GetService("BadgeService")
if BadgeService:UserHasBadgeAsync(player.UserId, 3487087153721021) then
    BadgeHeader:NewLabel("Key Token Badge : Obtained ✅");
else
    BadgeHeader:NewLabel("Key Token Badge : Not Obtained ❌");
end
if BadgeService:UserHasBadgeAsync(player.UserId, 3821362812694001) then
    BadgeHeader:NewLabel("Rune Badge : Obtained ✅");
else
    BadgeHeader:NewLabel("Rune Badge : Not Obtained ❌");
end

--Halloween Spotlight Part Halloween Trials
if game.PlaceId == 7633631103 or game.PlaceId == 7633631351 or game.PlaceId == 7633631511 then
    local TrialsChapter = MainTab:NewSection("Halloween Trials [👻]");
    TrialsChapter:NewLabel("Section 0 : Candy Fram [🍬]");
    TrialsChapter:NewButton("Get Candy 🍬 [Recursive Method 🔁]", "Auto Get Candies all map.", function()
        local a=workspace.Candy:GetChildren()local function b()if not workspace.Candy:FindFirstChild("Candy")then return end;game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=workspace.Candy:FindFirstChild("Candy").CFrame+Vector3.new(0,5,0)task.wait(0.2)fireproximityprompt(workspace.Candy:FindFirstChild("Candy"):FindFirstChildOfClass("ProximityPrompt"))return b()end;b();
    end)
    if game.PlaceId == 7633631103 then
        TrialsChapter:NewLabel("Section 1 : Ghost Hunt [👻]");
        TrialsChapter:NewButton("Teleport [Recursive Method 🔁]", "Auto play Section 1", function()
            local a=workspace.GameInfo.PuzzleItems:GetChildren()local function b(c)if not a[c]then return end;game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=a[c].CFrame+Vector3.new(0,5,0)task.wait(0.2)fireproximityprompt(a[c]:FindFirstChildOfClass("ProximityPrompt"))task.wait(.2)game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=workspace.Map.Well.Burner.CFrame+Vector3.new(0,5,0)task.wait(0.2)fireproximityprompt(workspace.Map.Well.Burner:FindFirstChildOfClass("ProximityPrompt"))return b(c+1)end;b(1);
        end)
    end
    if game.PlaceId == 7633631351 then
        TrialsChapter:NewLabel("Section 2 : Candles [🏃‍♂️]");
        TrialsChapter:NewButton("Auto Complete [Recursive Method 🔁]", "Auto play Section 2", function()
            local a=workspace.Candles:GetChildren()local b=#a;local function c()return game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame end;local d=c()local function e()game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=d end;local function f(g)if g>b then return e()end;if a[g].Candles.ProximityPrompt.Enabled then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=a[g].Candles.CFrame+Vector3.new(0,3,0)task.wait(.2)fireproximityprompt(a[g].Candles:FindFirstChildOfClass("ProximityPrompt"))else g=g+1 end;return f(g)end;f(1);
        end)
    end
    if game.PlaceId == 7633631511 then
        TrialsChapter:NewLabel("Section 3 : Potions [🏃‍♂️]");
        TrialsChapter:NewButton("Auto Complete [Recursive Method 🔁]", "Auto Make Potion kill monster.", function()
            
        end)
    end
end

--Halloween Spotlight Part Cirus
if game.PlaceId == 11126398230 then
    local MainChapter = MainTab:NewSection("Nightmare Circus [🎪]");
    MainChapter:NewLabel("Section 1 : Out Side [🎪]");
    MainChapter:NewButton("Teleport", "Get to Inside", function()
        if workspace.Section1.Cutscene.Trigger:FindFirstChild("TouchInterest") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Section1.Cutscene.Trigger.CFrame + Vector3.new(0,5,0);
        else
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1484.90393, -59.5944595, 526.643494, -0.807071924, 0, 0.590453148, 0, 1, 0, -0.590453148, 0, -0.807071924);
        end
    end)
    MainChapter:NewLabel("Section 2 : Cards Passcode [🃏]");
    MainChapter:NewButton("Slove Cards [Recursive Method 🔁]", "Auto Slove Cards.", function()
        local CardsList = {
            ['1'] = false,
            ['2'] = false,
            ['3'] = false,
            ['4'] = false,
            ['5'] = false,
            ['6'] = false
        }
        for i,v in ipairs(workspace.Section2.Objective.Cards:GetChildren()) do
            CardsList[v:WaitForChild("Order"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel").Text] = v.Name;
        end

        local Passcode = workspace.Section2.Objective.PassCode:GetChildren();

        local function presssubmitbutton()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Section2.Objective.Submit.Part.CFrame + Vector3.new(0,5,0);
            task.wait(.2);
            fireproximityprompt(workspace.Section2.Objective.Submit.Part:FindFirstChildOfClass("ProximityPrompt"));
        end

        local function slovecard(a)
            if not CardsList[tostring(a)] then return presssubmitbutton() end;
            if Passcode[a][CardsList[Passcode[a].Name]].Transparency == 1 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Passcode[a].CFrame + Vector3.new(0,5,0)
                task.wait(1)
                fireproximityprompt(Passcode[a]:FindFirstChildOfClass("ProximityPrompt"));  
                task.wait(.5);
                return slovecard(a);
            else
                return slovecard(a + 1);
            end
        end
        slovecard(1);
    end)
    MainChapter:NewLabel("Section 3 : Ringmaster [🤡]");
    MainChapter:NewButton("Auto Kill Ringmaster [Don't spam]", "Make damage to ringmaster until die.", function()
        local a=game:GetService("Players")local b=game:GetService("VirtualUser")local c=game:GetService("RunService")local fireproximityprompt=fireproximityprompt or function(d)if d then d:InputHoldBegin()if d.HoldDuration>0 then task.wait(d.HoldDuration)end;d:InputHoldEnd()end end;local e=a.LocalPlayer;local f=e.Character;local g=e.Backpack;local h=f and f:WaitForChild("HumanoidRootPart")local i=CFrame.new(-1626.0211181640625,-20.439666748046875,-995.7735595703125)local function j()return g:FindFirstChild('Knife')end;local function k()local l=j()if l then local m=f:FindFirstChildOfClass('Humanoid')if m then m:EquipTool(l)task.wait()end end;b:CaptureController()b:Button1Down(Vector2.new(1280,672))end;local function n()if h then h.CFrame=i end end;local o=workspace.Section3;local p=o.Boss.WeaponGiver;local q=p.ProxPart;if q.ProximityPrompt.Enabled then if h then h.CFrame=q.CFrame+Vector3.new(0,5,0)task.wait(0.2)fireproximityprompt(q:FindFirstChildOfClass("ProximityPrompt"))task.wait(0.1)n()end end;local r=o.Boss.MagicianBoss;local s=r:FindFirstChild('RightHitbox')local t=r:FindFirstChild('LeftHitbox')local u=nil;local v=false;local w={}table.insert(w,r.Parent:WaitForChild('Death').Played:Connect(function()v=true end))table.insert(w,r:WaitForChild('AnimationController'):WaitForChild('Animator').AnimationPlayed:Connect(function(x)u=x end))local function y()for z,A in ipairs(w)do A:Disconnect()end end;local function B(C)if h then h.CFrame=C.CFrame*CFrame.new(0,-2.5,0)end end;local D;D=c.Heartbeat:Connect(function()if v then if h then h.CFrame=workspace:WaitForChild('Checkpoints'):FindFirstChild('Section3').CFrame end;y()D:Disconnect()return end;if u and u.Speed<=0.2 then local E=t.Position.Y<=s.Position.Y and t or s;B(E or t)k()else n()end end);
    end)
end

--Miscellaneous Functions
--Fullbright
MiscHeader:NewButton("Fullbright [🌕]", "Night Vision", function()
    if not _G.FullBrightExecuted then _G.FullBrightEnabled=false;_G.NormalLightingSettings={Brightness=game:GetService("Lighting").Brightness,ClockTime=game:GetService("Lighting").ClockTime,FogEnd=game:GetService("Lighting").FogEnd,GlobalShadows=game:GetService("Lighting").GlobalShadows,Ambient=game:GetService("Lighting").Ambient}game:GetService("Lighting"):GetPropertyChangedSignal("Brightness"):Connect(function()if game:GetService("Lighting").Brightness~=1 and game:GetService("Lighting").Brightness~=_G.NormalLightingSettings.Brightness then _G.NormalLightingSettings.Brightness=game:GetService("Lighting").Brightness;if not _G.FullBrightEnabled then repeat wait()until _G.FullBrightEnabled end;game:GetService("Lighting").Brightness=1 end end)game:GetService("Lighting"):GetPropertyChangedSignal("ClockTime"):Connect(function()if game:GetService("Lighting").ClockTime~=12 and game:GetService("Lighting").ClockTime~=_G.NormalLightingSettings.ClockTime then _G.NormalLightingSettings.ClockTime=game:GetService("Lighting").ClockTime;if not _G.FullBrightEnabled then repeat wait()until _G.FullBrightEnabled end;game:GetService("Lighting").ClockTime=12 end end)game:GetService("Lighting"):GetPropertyChangedSignal("FogEnd"):Connect(function()if game:GetService("Lighting").FogEnd~=786543 and game:GetService("Lighting").FogEnd~=_G.NormalLightingSettings.FogEnd then _G.NormalLightingSettings.FogEnd=game:GetService("Lighting").FogEnd;if not _G.FullBrightEnabled then repeat wait()until _G.FullBrightEnabled end;game:GetService("Lighting").FogEnd=786543 end end)game:GetService("Lighting"):GetPropertyChangedSignal("GlobalShadows"):Connect(function()if game:GetService("Lighting").GlobalShadows~=false and game:GetService("Lighting").GlobalShadows~=_G.NormalLightingSettings.GlobalShadows then _G.NormalLightingSettings.GlobalShadows=game:GetService("Lighting").GlobalShadows;if not _G.FullBrightEnabled then repeat wait()until _G.FullBrightEnabled end;game:GetService("Lighting").GlobalShadows=false end end)game:GetService("Lighting"):GetPropertyChangedSignal("Ambient"):Connect(function()if game:GetService("Lighting").Ambient~=Color3.fromRGB(178,178,178)and game:GetService("Lighting").Ambient~=_G.NormalLightingSettings.Ambient then _G.NormalLightingSettings.Ambient=game:GetService("Lighting").Ambient;if not _G.FullBrightEnabled then repeat wait()until _G.FullBrightEnabled end;game:GetService("Lighting").Ambient=Color3.fromRGB(178,178,178)end end)game:GetService("Lighting").Brightness=1;game:GetService("Lighting").ClockTime=12;game:GetService("Lighting").FogEnd=786543;game:GetService("Lighting").GlobalShadows=false;game:GetService("Lighting").Ambient=Color3.fromRGB(178,178,178)local a=true;spawn(function()repeat wait()until _G.FullBrightEnabled;while wait()do if _G.FullBrightEnabled~=a then if not _G.FullBrightEnabled then game:GetService("Lighting").Brightness=_G.NormalLightingSettings.Brightness;game:GetService("Lighting").ClockTime=_G.NormalLightingSettings.ClockTime;game:GetService("Lighting").FogEnd=_G.NormalLightingSettings.FogEnd;game:GetService("Lighting").GlobalShadows=_G.NormalLightingSettings.GlobalShadows;game:GetService("Lighting").Ambient=_G.NormalLightingSettings.Ambient else game:GetService("Lighting").Brightness=1;game:GetService("Lighting").ClockTime=12;game:GetService("Lighting").FogEnd=786543;game:GetService("Lighting").GlobalShadows=false;game:GetService("Lighting").Ambient=Color3.fromRGB(178,178,178)end;a=not a end end end)end;_G.FullBrightExecuted=true;_G.FullBrightEnabled=not _G.FullBrightEnabled;
end)
MiscHeader:NewButton("ESP GHOST [👀]", "Reveal a ghost location.", function()
    local a=game:GetService("RunService")local b=game:GetService("Players")local c=Color3.fromRGB(255,0,0)local d=0.5;local e={}local function f(g)if not g:IsA("Model")then return false end;local h=g:FindFirstChild("Humanoid")if not h then return false end;local i=b:GetPlayerFromCharacter(g)if i then return false end;return true end;local function j(g)if e[g]then return end;local k=Instance.new("Highlight")k.FillColor=c;k.FillTransparency=d;k.OutlineColor=c;k.OutlineTransparency=0;k.Adornee=g;k.Parent=g;e[g]=k;local l;l=g.AncestryChanged:Connect(function(m,n)if not n then if e[g]then e[g]:Destroy()e[g]=nil end;l:Disconnect()end end)end;local function o()for m,g in ipairs(workspace:GetDescendants())do if f(g)then j(g)end end end;workspace.DescendantAdded:Connect(function(p)if f(p)then task.wait()j(p)end end)workspace.DescendantRemoving:Connect(function(p)if e[p]then e[p]:Destroy()e[p]=nil end end)local function q()for g,k in pairs(e)do if k then k:Destroy()end end;table.clear(e)end;o()game:BindToClose(q);
end)
MiscHeader:NewKeybind("Toggle UI", "Open/Close Ui", Enum.KeyCode.Q, function()
	Library:ToggleUI()
end)
MiscHeader:NewLabel("Inf Satamina [💪]");
if getgc(true) then
    if Ingame then
        MiscHeader:NewLabel("Working ✅");
        local function a(b)local c={"RegenerationAmount","RegenerationDelay","DeductionDelay","DeductionAmount","Speed"}if type(b)~="table"then return false end;for d,e in ipairs(c)do if not rawget(b,e)then return false end end;b.Bobble=false;b.RegenerationAmount=1e6;b.RegenerationDelay=0;b.DeductionDelay=0.2;b.DeductionAmount=0;b.Speed=26.9;return true end;local f={}for d,g in next,getgc(true)do if not f[g]and a(g)then f[g]=true end end;f=nil;
    else
        MiscHeader:NewLabel("Join in support games ❌");
    end
else
    MiscHeader:NewLabel("getgc : Not Support ❌");
end


--Credit
CreditHeader:NewLabel("Script made by XvasX 💖");
CreditHeader:NewLabel("Vulnerability-X Discord Server 💖");
CreditHeader:NewButton("Join Discord", "Click to join Vulnerability-X Discord", function()
    --Join Discord Script
    (function()
    if not (request or http_request or (syn and syn.request)) then return end
    for i = 6453, 6463 do
        coroutine.resume(coroutine.create(function()
            pcall(function()
                (request or http_request or syn.request)({
                    Url = "http://127.0.0.1:" .. i .. "/rpc?v=1",
                    Method = "POST",
                    Headers = {["Content-Type"]="application/json",["Origin"]="https://discord.com"},
                    Body = game:GetService("HttpService"):JSONEncode({
                        cmd = "INVITE_BROWSER",
                        nonce = game:GetService("HttpService"):GenerateGUID(false),
                        args = {invite={code="atcTxAePuy"},code="atcTxAePuy"}
                    })
                })
            end)
        end))
    end
    end)()
end)
