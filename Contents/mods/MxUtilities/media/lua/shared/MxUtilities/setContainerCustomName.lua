local getContainerIndex = require "MxUtilities/getContainerIndex"
local getModDataSafe    = require "MxUtilities/getModDataSafe"

---@param container ItemContainer
---@param name string
local function setContainerCustomName(container, name)
  local modData = container:getParent():getModData()
  local customContainerNames = getModDataSafe(modData, 'CustomContainerName', {})

  local containerIndex = getContainerIndex(container)

  customContainerNames[containerIndex] = name

  container:getParent():transmitModData()

  -- TODO: Add command to send nearby clients to refresh their UIs

  ISInventoryPage.dirtyUI()
end

return setContainerCustomName
