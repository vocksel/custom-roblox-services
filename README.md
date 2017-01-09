# Custom ROBLOX Services

This is a system for creating your own custom services in ROBLOX.

ROBLOX comes with an assortment of built in services, but games are complex and require lots of specialized handling. The built in services can't account for every scenario, which is where custom services come in.

Custom services are designed to give you seamless client-server communication, with the added benefit of modularizing your boilerplate code to reduce the size of your script files.

## Basic Service Definition

A service in its simplest form looks like this:

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

The server is returned a plain table that makes up the service, while the client is returned a router. The router handles client-server communication.

All services are initialized on the server. When a service is required from the client, all requests are routed to the server. You only ever have to worry about updating the service on the server to have all future requests from the client updated.
