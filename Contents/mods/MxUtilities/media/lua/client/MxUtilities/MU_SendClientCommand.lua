local MUSendClientCommand = {}

---@param args RefreshNearbyPlayersUIArgs
function MUSendClientCommand.RefreshNearbyPlayersUI(args)
  sendClientCommand("MxUtilities", "RefreshNearbyPlayersUI", args)
end

return MUSendClientCommand
