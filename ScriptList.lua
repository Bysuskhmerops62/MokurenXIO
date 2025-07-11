-- ScriptList.lua
local HttpService = game:GetService("HttpService")

-- 🔎 ចាប់ UID ពី URL
local requestUrl = tostring(getfenv().scriptURL or "")
local uid = string.match(requestUrl, "/([%w%-_]+)$")

-- ✅ URL Firebase
local firebaseURL = "https://synapse-roblox-default-rtdb.firebaseio.com/scripts/" .. uid .. ".json"

-- 🛠️ ដាក់ការពារ fallback
local success, response = pcall(function()
    return game:HttpGet(firebaseURL)
end)

if not success then
    warn("[×] Error while contacting Firebase.")
    return
end

-- ✅ Parse JSON
local ok, result = pcall(function()
    return HttpService:JSONDecode(response)
end)

if not ok or type(result) ~= "table" or not result.script then
    warn("[×] UID invalid or script missing.")
    return
end

-- ✅ Decode Base64 script
local decodedScript
local good, decode = pcall(function()
    return HttpService:Base64Decode(result.script)
end)

if good then
    decodedScript = decode
else
    warn("[×] Script decode error")
    return
end

-- ✅ Run script safely
local final, err = pcall(function()
    loadstring(decodedScript)()
end)

if not final then
    warn("[×] Script runtime error: ", err)
end
