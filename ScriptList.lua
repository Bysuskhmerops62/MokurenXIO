local Http = game:GetService("HttpService")

-- UID from URL path
local UID = ... or "none"

if not UID or #UID < 8 then
    error("[×] Invalid UID Supplied")
end

local success, response = pcall(function()
    return game:HttpGet("https://synapse-roblox-default-rtdb.firebaseio.com/scripts/" .. UID .. ".json")
end)

if not success then
    error("[×] Failed to fetch script from Firebase")
end

local ok, data = pcall(function()
    return Http:JSONDecode(response)
end)

if not ok or not data or not data.script then
    error("[×] UID NOT Found or Invalid Script")
end

local raw = Http:Base64Decode(data.script)
return loadstring(raw)
