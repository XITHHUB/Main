-- Script Saver for Roblox Executors
-- Saves all scripts organized by service folders with path info in file

local function saveAllScripts()
    local savedCount = 0
    local failedCount = 0
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name:gsub("[%.%:%/\\%*%?\"<>|]", "_")
    local baseFolder = "SavedScripts_" .. gameName .. "_" .. game.PlaceId
    
    -- Create base folder
    if makefolder then
        makefolder(baseFolder)
    end
    
    -- Function to create folder path recursively
    local function createFolderPath(path)
        if makefolder then
            local currentPath = ""
            for folder in string.gmatch(path, "[^/]+") do
                currentPath = currentPath == "" and folder or currentPath .. "/" .. folder
                pcall(function()
                    makefolder(currentPath)
                end)
            end
        end
    end
    
    -- Function to save scripts from a service
    local function saveScriptsFromService(service, serviceName)
        local serviceFolder = baseFolder .. "/" .. serviceName
        createFolderPath(serviceFolder)
        
        local function processDescendants(instance, currentPath)
            for _, child in pairs(instance:GetChildren()) do
                local childPath = currentPath .. "/" .. child.Name:gsub("[%.%:%/\\%*%?\"<>|]", "_")
                
                if child:IsA("LocalScript") or child:IsA("Script") or child:IsA("ModuleScript") then
                    local success, err = pcall(function()
                        local source
                        if decompile then
                            source = decompile(child)
                        else
                            source = child.Source
                        end
                        
                        if source and source ~= "" then
                            local scriptType = child.ClassName
                            local fullPath = child:GetFullName()
                            local fileName = childPath .. "_[" .. scriptType .. "].lua"
                            
                            -- Create parent folders
                            local parentPath = fileName:match("(.+)/[^/]+$")
                            if parentPath then
                                createFolderPath(parentPath)
                            end
                            
                            -- Add script info header with path
                            local header = string.format([[
--[[
    ============================================
    SCRIPT INFORMATION
    ============================================
    Script Name: %s
    Script Type: %s
    Full Path: %s
    Parent: %s
    Game Name: %s
    Place ID: %d
    ============================================
    Saved by Script Saver
    Date: %s
    ============================================
--]]

]], child.Name, scriptType, fullPath, child.Parent:GetFullName(), gameName, game.PlaceId, os.date("%Y-%m-%d %H:%M:%S"))
                            
                            -- Write file with header + source
                            local fileContent = header .. source
                            writefile(fileName, fileContent)
                            
                            savedCount = savedCount + 1
                            print("[SAVED] " .. fullPath)
                        end
                    end)
                    
                    if not success then
                        failedCount = failedCount + 1
                        warn("[FAILED] " .. child:GetFullName() .. " - " .. tostring(err))
                    end
                end
                
                -- Process children (folders/instances containing scripts)
                if #child:GetChildren() > 0 then
                    if not (child:IsA("LocalScript") or child:IsA("Script") or child:IsA("ModuleScript")) then
                        createFolderPath(childPath)
                    end
                    processDescendants(child, childPath)
                end
            end
        end
        
        local success = pcall(function()
            processDescendants(service, serviceFolder)
        end)
        
        if not success then
            warn("[SERVICE INACCESSIBLE] " .. serviceName)
        end
    end
    
    print("========================================")
    print("Script Saver - Starting...")
    print("Game: " .. gameName)
    print("PlaceId: " .. game.PlaceId)
    print("Save Location: " .. baseFolder)
    print("========================================")
    
    -- Save scripts from each service into separate folders
    local services = {
        {game:GetService("Workspace"), "Workspace"},
        {game:GetService("ReplicatedStorage"), "ReplicatedStorage"},
        {game:GetService("ReplicatedFirst"), "ReplicatedFirst"},
        {game:GetService("StarterGui"), "StarterGui"},
        {game:GetService("StarterPack"), "StarterPack"},
        {game:GetService("StarterPlayer"), "StarterPlayer"},
        {game:GetService("Lighting"), "Lighting"},
        {game:GetService("SoundService"), "SoundService"},
        {game:GetService("Chat"), "Chat"},
        {game:GetService("LocalizationService"), "LocalizationService"},
        {game:GetService("TestService"), "TestService"},
    }
    
    -- Try server services (may fail on client)
    pcall(function() table.insert(services, {game:GetService("ServerScriptService"), "ServerScriptService"}) end)
    pcall(function() table.insert(services, {game:GetService("ServerStorage"), "ServerStorage"}) end)
    
    for _, serviceData in pairs(services) do
        local service, serviceName = serviceData[1], serviceData[2]
        print("[SCANNING] " .. serviceName .. "...")
        saveScriptsFromService(service, serviceName)
    end
    
    print("========================================")
    print("Script Saver - Complete!")
    print("========================================")
    print("Total Saved: " .. savedCount .. " scripts")
    print("Total Failed: " .. failedCount .. " scripts")
    print("========================================")
end

saveAllScripts()
