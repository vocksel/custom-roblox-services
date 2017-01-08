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

local function isAService(obj)
  return obj:IsA("ModuleScript") and string.match(obj.Name:lower(), "service$")
end

-- Gets all the methods from a table.
local function getMethods(t)
  local methods = {}
  for key, value in pairs(t) do
    if type(value) == "function" then
      methods[key] = value
    end
  end
  return methods
end

local function newRemoteFunction(name, parent, serviceTable, callback)
  --[[ The first argument is the player, which we purposefully ignore.

    Our services work like ROBLOX's built in ones, which never have the player
    automatically passed to them.  If a service needs access to a player, it
    can be passed in manually. ]]
  local function invoke(_, ...)
    -- We pass in serviceTable to propagate the Service's `self`,
    return callback(serviceTable, ...)
  end

  local remote = Instance.new("RemoteFunction")
  remote.Name = name
  remote.OnServerInvoke = invoke
  remote.Parent = parent

  return remote
end

local function replicateMethods(methods, remoteStorage, serviceTable)
  for name, callback in pairs(methods) do
    newRemoteFunction(name, remoteStorage, serviceTable, callback)
  end
end

local function setupRemoteAccess(serviceModule)
  local serviceTable = require(serviceModule)
  local methods = getMethods(serviceTable)
  local remoteStorage = storage.getMethods(serviceModule)

  replicateMethods(methods, remoteStorage, serviceTable)
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
