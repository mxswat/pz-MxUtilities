--- Safely retrieves mod data from a table, initializing it with defaults if not present.
--- If default has nested tables, use `getModDataSafeDeep` instead.
---@param modData table The table containing mod data.
---@param modDataKey string The key for the mod data.
---@param defaults table The default values to initialize if mod data is not present.
local function getModDataSafe(modData, modDataKey, defaults)
  -- If modData[modDataKey] is nil or not a table, initialize it with defaults.
  if not modData[modDataKey] or type(modData[modDataKey]) ~= "table" then
    modData[modDataKey] = defaults
  else
    -- Merge default values into modData[modDataKey] if the key exists but is not a table
    for k, v in pairs(defaults) do
      if modData[modDataKey][k] == nil then
        modData[modDataKey][k] = v
      end
    end
  end
  -- Always return the modified modData[modDataKey].
  return modData[modDataKey]
end

return getModDataSafe
