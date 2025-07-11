local HttpService = game:GetService("HttpService")

local url = tostring(getfenv().scriptURL or "")
local uid = string.match(url, "/([%w_%-]+)$") or ""

if string.sub(uid, 1, 1) == "-" then
    uid = "s" .. string.sub(uid, 2)
end

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

if not parsed then
    warn("[×] JSON Decode Error")
    return
end

if not data or not data.script or type(data.script) ~= "string" then
    warn("[×] Script missing")
    return
end

print("[✓] Script pulled: " .. data.script)

local ok, err = pcall(function()
    loadstring(data.script)()
end)

if not ok then
    warn("[×] Script error: " .. tostring(err))
end
