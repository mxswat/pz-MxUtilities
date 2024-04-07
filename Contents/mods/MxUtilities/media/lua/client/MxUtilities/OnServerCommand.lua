local MxDebug = require "MxUtilities/MxDebug"

local Commands = { MxUtilities = {} };

Commands.MxUtilities.RefreshUIOnClient = function(srcPlayer, args)
  ISInventoryPage.dirtyUI()
end

local onServerCommand = function(module, command, player, args) -- Events Constructor.
  if Commands[module] and Commands[module][command] then
    MxDebug:print("Received Command: ", command)
    Commands[module][command](player, args);
  end
end

Events.OnServerCommand.Add(onServerCommand);
