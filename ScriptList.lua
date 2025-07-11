local HttpService = game:GetService("HttpService")

-- ចាប់ UID ពី URL
local url = tostring(getfenv().scriptURL or "")
local uid = string.match(url, "/([%w_%-]+)$") or ""

-- Handle UID ដែលចាប់ផ្តើមដោយ "-"
if string.sub(uid, 1, 1) == "-" then
    uid = "s" .. string.sub(uid, 2)
end

-- Firebase URL
local firebaseURL = "https://synapse-roblox-default-rtdb.firebaseio.com/scripts/" .. uid .. ".json"

-- Fetch script
local success, response = pcall(function()
    return game:HttpGet(firebaseURL)
end)

if not success then
    warn("[×] Error contacting Firebase")
    return
end

-- Parse JSON
local parsed, result = pcall(function()
    return HttpService:JSONDecode(response)
end)

if not parsed or not result.script then
    warn("[×] Invalid UID or missing script")
    return
end

-- Run script directly (no Base64)
local final, err = pcall(function()
    loadstring(result.script)()
end)

if not final then
    warn("[×] Script Error: " .. tostring(err))
end
