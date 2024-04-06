---@param container ItemContainer
local function getContainerIndex(container)
  local parent = container:getParent()

  for i = 0, parent:getContainerCount() - 1 do
    if parent:getContainerByIndex(i) == container then
      return i
    end
  end

  return -1
end


return getContainerIndex
