local HttpService = game:GetService("HttpService")

-- ត្រូវបានផ្តល់ UID តាម URL (simulate environment)
local requestUrl = tostring(getfenv().scriptURL or "")
local uid = string.match(requestUrl, "/([%w_]+)$")

if not uid then
    warn("[×] UID missing from URL")
    return
end

local firebaseURL = "https://synapse-roblox-default-rtdb.firebaseio.com/scripts/" .. uid .. ".json"

local success, response = pcall(function()
    return game:HttpGet(firebaseURL)
end)

if not success or not response then
    warn("[×] Failed to get script from Firebase")
    return
end

local ok, data = pcall(function()
    return HttpService:JSONDecode(response)
end)

if not ok or type(data) ~= "table" or not data.script then
    warn("[×] Invalid JSON or script missing")
    return
end

local final, err = pcall(function()
    loadstring(data.script)()
end)

if not final then
    warn("[×] Script runtime error: " .. tostring(err))
end
