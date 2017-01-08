-- Gets or creates a new folder if one doesn't already exist.
local function getFolder(parent, name)
  local folder = parent:FindFirstChild(name)

  if not folder then
    folder = Instance.new("Folder")
    folder.Name = name
    folder.Parent = parent
  end

  return folder
end

local storage = {}

function storage.getMethods(serviceModule)
  return getFolder(serviceModule, "Methods")
end

function storage.getEvents(serviceModule)
	return getFolder(serviceModule, "Events")
end

return storage
