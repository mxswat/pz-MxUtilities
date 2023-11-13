-- local DebugUtils = require "MxUtilities/DebugUtils"

local Utils = {}

---@param table table
function Utils:next(table)
  return not table.isempty(table)
end

---@param table table
function Utils:empty(table)
  return table.isempty(table)
end

---@param target table
---@param defaults table
function Utils:mergeWithDefaults(target, defaults)
  if not target then
    -- Return a new table to avoid modifying the input
    return { unpack(defaults) }
  end

  local result = {}
  for key, defaultValue in pairs(defaults) do
    result[key] = target[key] ~= nil and target[key] or defaultValue
  end

  return result
end

---@param modData table
---@param modDataKey string
---@param defaults table
function Utils:getModDataWithDefault(modData, modDataKey, defaults)
  local target = modData[modDataKey] or {}

  -- DebugUtils:printTable({
  --   modData = modData,
  --   modDataKey = modDataKey,
  --   defaults = defaults
  -- })

  -- Always return the modified modData[modDataKey]
  modData[modDataKey] = self:mergeWithDefaults(target, defaults)
  return modData[modDataKey]
end

return Utils
