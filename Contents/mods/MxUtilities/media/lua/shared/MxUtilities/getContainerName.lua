local getContainerIndex = require "MxUtilities/getContainerIndex"
local getModDataSafe    = require "MxUtilities/getModDataSafe"

--- Gets container name from `IGUI_ContainerTitle_[containerType]` or `modData['CustomContainerName']` or empty string
---@param container ItemContainer
---@return string
local function getContainerName(container)
  local modData = container:getParent():getModData()
  local containerIndex = getContainerIndex(container)
  local customName = getModDataSafe(modData, 'CustomContainerName', {})[containerIndex]

  return customName or getTextOrNull("IGUI_ContainerTitle_" .. container:getType()) or ""
end

return getContainerName