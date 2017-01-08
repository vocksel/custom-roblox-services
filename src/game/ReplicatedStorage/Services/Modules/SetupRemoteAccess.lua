local replicatedStorage = game:GetService("ReplicatedStorage")

local RoutingStorage = require(script.Parent.RoutingStorage)

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

local function newRemoteFunction(name, parent, callback)
  local function invoke(player, ...)
    -- NOTE I'm not sure if this will be enough for setting up remote access.
    -- It doesn't reference the serviceTable at all which could be a problem.
    return callback(player, ...)
  end

  local remote = Instance.new("RemoteFunction")
  remote.Name = name
  remote.OnServerInvoke = invoke
  remote.Parent = parent

  return remote
end

local function copyMethodsTo(methods, storage)
  for name, callback in pairs(methods) do
    newRemoteFunction(name, storage, callback)
  end
end

--------------------------------------------------------------------------------

local function setupRemoteAccess(serviceName, serviceTable)
  local storage = RoutingStorage.new(serviceName)
  local methods = getMethods(serviceTable)

  copyMethodsTo(methods, storage:GetMethodStorage())
end

return setupRemoteAccess
