local HttpService = game:GetService("HttpService")

-- យក UID ពី argument
local args = {...}
local uid = args[1]

if not uid or uid == "" then
    warn("[×] UID is missing!")
    return
end

-- Firebase URL (ផ្លាស់ប្តូរតាម project របស់អ្នក)
local firebaseURL = "https://synapse-roblox-default-rtdb.firebaseio.com/scripts/" .. uid .. ".json"

-- ព្យាយាមទាញ JSON ពី Firebase
local success, response = pcall(function()
    return game:HttpGet(firebaseURL)
end)

if not success then
    warn("[×] Cannot reach Firebase server.")
    return
end

-- Parse JSON response
local ok, result = pcall(function()
    return HttpService:JSONDecode(response)
end)

if not ok or type(result) ~= "table" or not result.script then
    warn("[×] Invalid UID or script missing in Firebase.")
    return
end

-- ត្រលប់ script តាមរយៈ Base64 decode (បើ script មិនបាន encode ត្រូវលុបផ្នែកនេះ)
local decodedScript
local decodeSuccess, decodeResult = pcall(function()
    return HttpService:Base64Decode(result.script)
end)

if decodeSuccess then
    decodedScript = decodeResult
else
    -- ប្រសិនបើ មិនបាន encode Base64, ដាក់ raw script ត្រលប់ត្រង់
    decodedScript = result.script
end

-- ព្យាយាម run script
local runSuccess, runError = pcall(function()
    loadstring(decodedScript)()
end)

if not runSuccess then
    warn("[×] Script runtime error: " .. tostring(runError))
end
