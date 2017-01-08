local run = game:GetService("RunService")

local storage = require(script.Parent.RoutingStorage)

local function setupMethodRouting(router, methodRemotes)
  for _, remote in ipairs(methodRemotes:GetChildren()) do
    --[[ All of our Services use colon notation for their methods.

      This is to stay consistent with ROBLOX's Services, and also gives us
      access to `self` so we can easily refernece the service when coding.

      We require that all methods on the router are called with a colon aswell.
      This is for consistency so that Services are used the same between client
      and server.

      When routing, we don't actually do anything with the Service's table. We
      reserve it as the first argument so we don't have to filter it out of the
      variadic arguments when passing them to the server. ]]
    router[remote.Name] = function(serviceTable, ...)
      if type(serviceTable) ~= "table" then
        error(string.format("Service methods must be called with colon "..
          "notation (ServiceName:%s())", remote.Name))
      end

      return remote:InvokeServer(...)
    end
  end
end

local function route(serviceModule)
  local router = {}

  setupMethodRouting(router, storage.getMethods(serviceModule))

  -- Set __newindex last so it doesn't get upset when we add on to the router
  -- in any above function calls.
  setmetatable(router, {
    __newindex = function()
      --[[ This is a safety percaution to ensure we don't attempt to change the
        properties of a Service from the client.

        The server and client share the same Service table in play mode. This
        means any changes the client code makes to the Service will replicate
        to server.

        There is no replication like this when online, so if we change
        properties of the Service client-side, we'll find once we go online
        that things might not work as expected.

        This error is here to make sure that if we are setting any properties,
        that we know when running a test server that we're making a mistake. ]]
      error("You cannot change Service properties from the client.")
    end
  })

  return router
end

return route
