---@param object IsoObject?
local function getObjectContainerCapacity(object)
  -- NOTE: 50 is the default value coming from ItemContainer.java => public int Capacity = 50;
  ---@type number
  return object and object:getProperties():Val("ContainerCapacity") or 50
end

return getObjectContainerCapacity