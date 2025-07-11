local HttpService = game:GetService("HttpService")

-- CUSTOM: Hardcode UID ឬ ប្តូរជាផ្លូវការបាន
local uid = "sOUsl0NJtLiiMcDq3WIi" -- ប្តូរជា UID របស់ script

local firebaseURL = "https://synapse-roblox-default-rtdb.firebaseio.com/scripts/" .. uid .. ".json"

local success, response = pcall(function()
    return game:HttpGet(firebaseURL)
end)

if not success then
    warn("[×] Firebase Error")
    return
end

local parsed, data = pcall(function()
    return HttpService:JSONDecode(response)
end)

if not parsed or not data or not data.script then
    warn("[×] JSON invalid or script missing")
    return
end

-- 🔎 Debug: print Script pulled from Firebase
print("[✓] Script: ", data.script)

-- ✅ Run script
local ok, err = pcall(function()
    loadstring(data.script)()
end)

if not ok then
    warn("[×] Script error: " .. tostring(err))
end
