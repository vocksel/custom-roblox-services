--[[
  Initializes ModuleScript-based Services.

  ROBLOX provides us with many useful services, but they can't do everything
  we'll ever need for our games.

  We have our own set of Services defined as ModuleScripts to reduce the amount
  of code we need in our Scripts and LocalScripts.

  For more information see the dedicated repository here:

  https://github.com/vocksel/custom-roblox-services
--]]

local replicatedStorage = game:GetService("ReplicatedStorage")

local services = replicatedStorage.Services
local setupRemoteAccess = require(services.Modules.SetupRemoteAccess)

local function isAService(obj)
  return obj:IsA("ModuleScript") and string.match(obj.Name:lower(), "service$")
end

local function init()
  local serviceModules = services:GetChildren()

  for _, serviceModule in ipairs(serviceModules) do
    if isAService(serviceModule) then
      setupRemoteAccess(serviceModule)
    end
  end
end

init()
