getgenv().Toggle = true;

task.spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            if getgenv().Toggle then
                local args = {
                    [1] = "collectOrb",
                    [2] = "Blue Orb",
                    [3] = "Legends Highway"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
                local args2 = {
                    [1] = "collectOrb",
                    [2] = "Yellow Orb",
                    [3] = "Legends Highway"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args2))
                local args3 = {
                    [1] = "collectOrb",
                    [2] = "Orange Orb",
                    [3] = "Legends Highway"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args3))
                local args4 = {
                    [1] = "collectOrb",
                    [2] = "Gem",
                    [3] = "Legends Highway"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args4))
                local args5 = {
                    [1] = "collectOrb",
                    [2] = "Red Orb",
                    [3] = "City"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args5))
                local args6 = {
                    [1] = "collectOrb",
                    [2] = "Gem",
                    [3] = "City"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args6))
                local LevelPath = game:GetService("Players").LocalPlayer.level.Value;
                local MaxLevel = tonumber(string.split(tostring(game:GetService("Players").LocalPlayer.PlayerGui.gameGui.rebirthMenu.neededLabel.amountLabel.Text), " ")[1]);
                if LevelPath == MaxLevel then
                    --FireServer Rebirth
                end
            end
        end)
        task.wait();
    end)
end)
