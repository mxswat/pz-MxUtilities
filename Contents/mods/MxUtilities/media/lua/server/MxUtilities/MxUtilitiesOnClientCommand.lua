local LMServerGlobalModData = require "LM_ServerGlobalModData"
local MxDebug = require "MxUtilities/MxDebug"

local Commands = { MxUtilities = {} };

---@class (exact) RefreshNearbyPlayersUIArgs
---@field x number
---@field y number

---@param srcPlayer IsoPlayer
---@param args RefreshNearbyPlayersUIArgs
Commands.MxUtilities.RefreshNearbyPlayersUI = function(srcPlayer, args)
  local x, y = args.x, args.y;

  local players = getOnlinePlayers();

  for i = 0, players:size() - 1 do
    local player = players:get(i);

    if player:getOnlineID() ~= srcPlayer:getOnlineID() then
      local x2, y2 = player:getX(), player:getY();
      local vDist = math.sqrt(((x - x2) ^ 2) + ((y - y2) ^ 2));

      MxDebug:print(player:getUsername(), 'is in range:', vDist, 'notified to update ISInventoryPage UI')

      if vDist < 4 then -- Find the closest players.
        sendServerCommand(player, "MxUtilities", "RefreshUIOnClient", {});
      end
    end
  end
end

local onClientCommand = function(module, command, player, args) -- Events Constructor.
  if Commands[module] and Commands[module][command] then
    MxDebug:print('Received [', command, '] from playerID:', player:getOnlineID());
    Commands[module][command](player, args);
  end
end

Events.OnClientCommand.Add(onClientCommand); -- Listening Events from Client side.
