---@param modData table
---@param modDataKey string
---@param defaults table
local function getModDataSafe(modData, modDataKey, defaults)
  -- Always return the modified modData[modDataKey]
  modData[modDataKey] = modData[modDataKey] or defaults
  return modData[modDataKey]
end

return getModDataSafe