---@param player IsoPlayer
---@return nil|Faction
local function getPlayerFaction(player)
  local username = player:getUsername();
  local factions = Faction:getFactions();
  local factionCount = factions:size();

  if factionCount == 0 then return nil end

  for i = 1, factionCount, 1 do
    ---@type Faction
    local faction = factions:get(i - 1);

    if faction then
      local factionOwnerUsername = faction:getOwner();

      if factionOwnerUsername == username then return faction end

      local members = faction:getPlayers();
      local membersCount = members:size();

      for memberIdx = 1, membersCount, 1 do
        if members:get(memberIdx - 1) == username then
          return faction
        end
      end
    end
  end

  return nil;
end

return getPlayerFaction
