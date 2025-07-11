local HttpService = game:GetService("HttpService")

local requestUrl = tostring(getfenv().scriptURL or "")
local uid = string.match(requestUrl, "/([%w%-_]+)$")

local firebaseURL = "https://synapse-roblox-default-rtdb.firebaseio.com/scripts/" .. uid .. ".json"

local success, response = pcall(function()
    return game:HttpGet(firebaseURL)
end)

if not success then
    warn("[×] Error contacting Firebase.")
    return
end

local ok, result = pcall(function()
    return HttpService:JSONDecode(response)
end)

if not ok or type(result) ~= "table" or not result.script then
    warn("[×] UID invalid or script missing.")
    return
end

local good, decodedScript = pcall(function()
    return HttpService:Base64Decode(result.script)
end)

if not good then
    warn("[×] Script decode error.")
    return
end

local final, err = pcall(function()
    loadstring(decodedScript)()
end)

if not final then
    warn("[×] Script runtime error: ", err)
end
