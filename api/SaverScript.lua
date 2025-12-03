local a = {}
local function b(c)
    table.insert(a, c)
    print(c)
end
local function d(c)
    table.insert(a, c)
    warn(c)
end
local function e(f)
    local g = f:gsub('[<>:"/\\|?*%z]', "_")
    g = g:gsub("%.+$", "")
    if g == "" then
        g = "_"
    end
    return g
end
local function h(i)
    local j = {}
    local k = i
    while k and k ~= game do
        table.insert(j, 1, e(k.Name))
        k = k.Parent
    end
    return j
end
local function l(j)
    local m = "ScriptDump"
    if not isfolder(m) then
        makefolder(m)
    end
    for n = 1, #j - 1 do
        m = m .. "/" .. j[n]
        if not isfolder(m) then
            makefolder(m)
        end
    end
    return m
end
b("\n")
b("📜 Script Saver - Dumping all scripts")
b("=====================================\n")
local o = {}
if not getscripts then
    table.insert(o, "getscripts")
end
if not writefile then
    table.insert(o, "writefile")
end
if not makefolder then
    table.insert(o, "makefolder")
end
if not isfolder then
    table.insert(o, "isfolder")
end
if #o > 0 then
    d("⛔ Missing required functions: " .. table.concat(o, ", "))
    d("⛔ Script dumping cannot proceed.")
    return
end
if not isfolder("ScriptDump") then
    makefolder("ScriptDump")
end
local p = getscripts()
local q = 0
local r = 0
local s = 0
b("📊 Found " .. #p .. " scripts in game\n")
for t, u in ipairs(p) do
    local v = u.ClassName
    local w = h(u)
    local x = ".lua"
    if v == "ModuleScript" then
        x = ".module.lua"
    elseif v == "LocalScript" then
        x = ".client.lua"
    elseif v == "Script" then
        x = ".server.lua"
    end
    local y = nil
    if decompile then
        local z, A =
            pcall(
            function()
                return decompile(u)
            end
        )
        if z and A and #A > 0 then
            y = A
        end
    end
    if not y and getscriptbytecode then
        local z, A =
            pcall(
            function()
                return getscriptbytecode(u)
            end
        )
        if z and A and #A > 0 then
            y = "-- Raw bytecode (decompile not available)\n" .. A
        end
    end
    if y then
        l(w)
        local B = w[#w] .. x
        local C = "ScriptDump"
        for n = 1, #w - 1 do
            C = C .. "/" .. w[n]
        end
        local D = C .. "/" .. B
        local E, F =
            pcall(
            function()
                writefile(D, y)
            end
        )
        if E then
            q = q + 1
            b("✅ Saved: " .. D)
        else
            r = r + 1
            d("⛔ Failed to save: " .. D .. " - " .. tostring(F))
        end
    else
        s = s + 1
        d("⚠️ Skipped (no source): " .. table.concat(w, "/"))
    end
    if (q + r + s) % 10 == 0 then
        task.wait()
    end
end
b("\n=====================================")
b("📜 Script Saver - Complete")
b("=====================================")
b("✅ Saved: " .. q .. " scripts")
b("⛔ Failed: " .. r .. " scripts")
b("⚠️ Skipped: " .. s .. " scripts")
b("📁 Output folder: ScriptDump/")
pcall(
    function()
        writefile("scriptsaver_results.txt", table.concat(a, "\n"))
        print("\n📄 Log saved to scriptsaver_results.txt")
    end
)
