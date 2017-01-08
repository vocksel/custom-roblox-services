# Custom ROBLOX Services

This is a system for creating your own custom services in ROBLOX.

There are many helpful built-in services, but games are complex and require very specific handling at times. The built in services can't account for every use case, which is where custom services come in.

## Usage Example

Here's a service in its simplest form:

```lua
local services = game.ReplicatedStorage.Services
local route = require(services.Modules.Route)

local service = {}

function service:Greet(player)
  print("Hello, " .. player.Name .. "!")
end

return route(script.Name, service)
```

It's defined just like a module, but when returning you pass it into the `route` function. This is what handles the client-server communication.

All services are initialized on the server. When a service is required from the client, all requests are routed to the server. You only ever have to worry about updating the service on the server to have all future requests from the client updated.
