-- ScriptList.lua (Server-side Lua script - run on Vercel or Lua supported server)

local Http = game:GetService and game:GetService("HttpService") or require("HttpService")

-- អ្នកប្រើ URL param ជា UID
local args = {...}
local uid = args[1] or ""

if uid == "" then
    return "error('No UID specified')"
end

-- Firebase URL
local url = "https://synapse-roblox-default-rtdb.firebaseio.com/scripts/" .. uid .. ".json"

local res, err = pcall(function()
    if game then
        return game:HttpGet(url)
    else
        -- ប្រសិន run នៅ luarocks ឬ server ផ្សេង (optional)
        local http = require("socket.http")
        local body, code = http.request(url)
        if code == 200 then
            return body
        else
            error("HTTP request failed: " .. tostring(code))
        end
    end
end)

if not res or not err then
    return "error('Failed to fetch from Firebase')"
end

local HttpService = Http or (game and game:GetService("HttpService")) or nil
if not HttpService then
    return "error('HttpService not found')"
end

local data = HttpService:JSONDecode(err)

if not data or not data.script then
    return "error('Script not found for UID: " .. uid .. "')"
end

-- Decode Base64 to raw Lua code
local decodedScript = HttpService:Base64Decode(data.script)

-- Return Lua script raw so client can run loadstring on it
return decodedScript
