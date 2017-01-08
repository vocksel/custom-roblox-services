local run = game:GetService("RunService")

local RoutingStorage = require(script.Parent.RoutingStorage)

local function setupMethodRouting(router, methodRemotes)
  for _, remote in ipairs(methodRemotes:GetChildren()) do
    -- Service methods require a colon instead of a dot. This gives us access
    -- to `self` so we can easily reference the Service in our methods.
    --
    -- We require that all methods on the router are called with a colon aswell.
    -- This is for consistency so that Services are used the same from the
    -- client and server.
    --
    -- When routing, we don't actually do anything with the Service's table. But
    -- it's helpful to be able to reserve it as the first argument so we don't
    -- have to worry about filtering it when passing the arguments to the server.
    router[remote.Name] = function(serviceTable, ...)
      if type(serviceTable) ~= "table" then
        error(string.format("Service methods must be called with colon "..
          "notation (ServiceName:%s())", remote.Name))
      end

      return remote:InvokeServer(...)
    end
  end
end

local function setupRouting(serviceName)
  local storage = RoutingStorage.new(serviceName)

  local router = {}

  setupMethodRouting(router, storage:GetMethodStorage())

  -- Set __newindex last so it doesn't get upset when we add on to the router
  -- in any above function calls.
  setmetatable(router, {
    __newindex = function()
      -- This is a safety percaution to ensure we don't attempt to change the
      -- properties of a Service from the client.
      --
      -- The server and client share the same Service table in play mode. This
      -- means any changes the client code makes to the Service will replicate
      -- to server.
      --
      -- There is no replication like this when online, so if we change
      -- properties of the Service client-side, we'll find once we go online
      -- that things might not work as expected.
      --
      -- This error is here to make sure that if we are setting any properties,
      -- that we know when running a test server that we're making a mistake.
      error("You cannot change Service properties from the client.")
    end
  })

  return router
end

local function route(serviceName, serviceTable)
  if run:IsClient() and not run:IsServer() then
    return setupRouting(serviceName)
  else
    return serviceTable
  end
end

return route
