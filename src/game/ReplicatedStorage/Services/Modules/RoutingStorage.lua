local replicatedStorage = game:GetService("ReplicatedStorage")

local ROUTER_STORAGE_NAME = "CleintRouting"
local ROUTER_STORAGE_PARENT = replicatedStorage.Services

-- Gets or creates a new folder if one doesn't already exist.
local function _getFolder(parent, name)
  local folder = parent:FindFirstChild(name)

  if not folder then
    folder = Instance.new("Folder")
    folder.Name = name
    folder.Parent = parent
  end

  return folder
end

local function _getRouterStorage()
  return _getFolder(ROUTER_STORAGE_PARENT, ROUTER_STORAGE_NAME)
end

--------------------------------------------------------------------------------

local RoutingStorage = {}
RoutingStorage.__index = RoutingStorage

function RoutingStorage.new(serviceName)
  local self = {}
  setmetatable(self, RoutingStorage)

  self.ServiceName = serviceName

  return self
end

function RoutingStorage:GetRootStorage()
  local storage = _getRouterStorage()
  return _getFolder(storage, self.ServiceName)
end

function RoutingStorage:GetMethodStorage()
  local root = self:GetRootStorage()
  return _getFolder(root, "Methods")
end

function RoutingStorage:GetEventStorage()
  local root = self:GetRootStorage()
  return _getFolder(root, "Events")
end

return RoutingStorage
