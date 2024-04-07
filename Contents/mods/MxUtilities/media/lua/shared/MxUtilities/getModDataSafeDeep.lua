--- Recursively merges tables.
---@param dest table Destination table to merge into.
---@param src table Source table to merge from.
local function mergeTables(dest, src)
  for key, value in pairs(src) do
    if type(value) == "table" and type(dest[key]) == "table" then
      mergeTables(dest[key], value)
    else
      dest[key] = value
    end
  end
end

--- Safely retrieves mod data from a table, initializing it with defaults if not present.
---@param modData table The table containing mod data.
---@param modDataKey string The key for the mod data.
---@param defaults table The default values to initialize if mod data is not present.
local function getModDataSafeDeep(modData, modDataKey, defaults)
  local newData = {}

  -- If modData[modDataKey] is nil or not a table, initialize it with defaults.
  if not modData[modDataKey] or type(modData[modDataKey]) ~= "table" then
    newData = defaults
  else
    -- If modData[modDataKey] is a table, merge it with defaults.
    mergeTables(newData, modData[modDataKey])
  end

  -- Apply defaults for any missing keys in newData
  for k, v in pairs(defaults) do
    if newData[k] == nil then
      newData[k] = v
    end
  end

  -- Return a new table with the modified modData[modDataKey].
  local result = {}
  for k, v in pairs(modData) do
    if k ~= modDataKey then
      result[k] = v
    end
  end
  result[modDataKey] = newData
  return result
end

return getModDataSafeDeep

-- Example usage
-- local modData = {
--   settings = {
--       -- volume = 0.5, -- Commented out
--       graphics = {
--           brightness = 0.8,
--           resolution = "1920x1080"
--       }
--   }
-- }

-- local defaults = {
--   volume = 0.7,
--   graphics = {
--       brightness = 1.0,
--       resolution = "1280x720"
--   }
-- }

-- print("Before merging:")
-- print("Volume:", modData.settings.volume) -- Will print nil
-- print("Brightness:", modData.settings.graphics.brightness)
-- print("Resolution:", modData.settings.graphics.resolution)

-- local mergedData = getModDataSafe(modData, "settings", defaults)

-- print("\nAfter merging:")
-- print("Volume:", mergedData.settings.volume) -- Will print the default value 0.7
-- print("Brightness:", mergedData.settings.graphics.brightness)
-- print("Resolution:", mergedData.settings.graphics.resolution)
