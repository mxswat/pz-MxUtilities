local getContainerIndex = require "MxUtilities/getContainerIndex"
local getModDataSafe    = require "MxUtilities/getModDataSafe"

---@param vehicle BaseVehicle
---@param container ItemContainer
---@param fallback string
local function getVehicleContainerName(vehicle, container, fallback)
  for partIndex = 1, vehicle:getPartCount() do
    local vehiclePart = vehicle:getPartByIndex(partIndex - 1)
    if vehiclePart:getItemContainer() == container then
      return getText("IGUI_VehiclePart" .. vehiclePart:getItemContainer():getType())
    end
  end

  return fallback
end

--- Gets container name from `IGUI_ContainerTitle_[containerType]` or `modData['CustomContainerName']` or empty string
---@param container ItemContainer
---@param fallback? string
---@return string
local function getContainerName(container, fallback)
  fallback = fallback or ""

  local object = container:getParent()
  if not object then
    return fallback
  end

  if instanceof(object, "BaseVehicle") then
    return getVehicleContainerName(object --[[@as BaseVehicle]], container, fallback)
  end

  local modData = object:getModData()
  local containerIndex = getContainerIndex(container)
  local customName = getModDataSafe(modData, 'CustomContainerName', {})[containerIndex]

  return customName or getTextOrNull("IGUI_ContainerTitle_" .. container:getType()) or ""
end

return getContainerName
