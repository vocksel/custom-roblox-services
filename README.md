# Custom ROBLOX Services

This is a system for creating your own custom services in ROBLOX.

There are many helpful built-in services, but games are complex and require very specific handling at times. The built in services can't account for every use case, which is where custom services come in.

This system is intended for use with FilteringEnabled. Your mileage may vary without it.

## Usage Example

Here's a service in its simplest form:

```lua
local run = game:GetService("RunService")

if run:IsServer() then
  local service = {}

  function service:Greet(player)
    print("Hello, " .. player.Name .. "!")
  end

  return service
else
  local route = require(script.Parent.Modules.Route)
  return route(script)
end
```

The server is given a plain table that makes up the service and all its properties and methods. The client on the other hand is returned a router. The router is what handles the client-server communication.

All services are initialized on the server. When a service is required from the client, all requests are routed to the server. You only ever have to worry about updating the service on the server to have all future requests from the client updated.
