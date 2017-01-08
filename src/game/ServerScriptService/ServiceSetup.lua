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
local storage = require(services.Modules.RoutingStorage)

local function isAService(obj)
  -- Any ModuleScript that ends in "service".
  return obj:IsA("ModuleScript") and obj.Name:lower():match("service$")
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

local function newInstance(className, name, parent)
  local instance = Instance.new(className)
  instance.Name = name
  instance.Parent = parent

  return instance
end

local function newRemoteFunction(name, parent)
  return newInstance("RemoteFunction", name, parent)
end

local function newRemoteMethod(name, parent, serviceTable, callback)
  local remote = newRemoteFunction(name, parent)

  --[[ The first argument is the player, which we purposefully ignore.

    Our services work like ROBLOX's built in ones, which never have the player
    automatically passed to them.  If a service needs access to a player, it
    can be passed in manually. ]]
  function remote.OnServerInvoke(_, ...)
    -- We pass in serviceTable to propagate the Service's `self`,
    return callback(serviceTable, ...)
  end

  return remote
end

local function replicateMethods(methods, remoteStorage, serviceTable)
  for name, callback in pairs(methods) do
    newRemoteMethod(name, remoteStorage, serviceTable, callback)
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
