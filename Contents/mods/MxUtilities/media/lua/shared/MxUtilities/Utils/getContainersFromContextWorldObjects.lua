---@param worldObjects table<number, IsoObject>
local function getContainersFromContextWorldObjects(worldObjects)
  ---@type table<number, ItemContainer>
  local containersMap = {}
  for _, object in ipairs(worldObjects) do
    local container = object:getContainer()
    if container then
      containersMap[tostring(container)] = container
    end
  end

  ---@type table<number, ItemContainer>
  local containers = {}
  for key, container in ipairs(containersMap) do
    table.insert(containers, container)
  end

  return containers
end

return getContainersFromContextWorldObjects