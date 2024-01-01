local Json = require "MxUtilities/Json"
local MxDebug = require "MxUtilities/MxDebug"

---@class Utils
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

  -- MxDebug:printTable({
  --   modData = modData,
  --   modDataKey = modDataKey,
  --   defaults = defaults
  -- })

  -- Always return the modified modData[modDataKey]
  modData[modDataKey] = self:mergeWithDefaults(target, defaults)
  return modData[modDataKey]
end

---@param font UIFont
---@param text string
---@param maxWidth number
function Utils:trimTextWithEllipsis(font, text, maxWidth)
  local nameWidth = getTextManager():MeasureStringX(font, text)

  local newName = text
  if nameWidth > maxWidth then
    local low = 1
    local high = string.len(text)

    while low <= high do
      local mid = math.floor((low + high) / 2)
      local midWidth = getTextManager():MeasureStringX(font, text:sub(1, mid))

      if midWidth > maxWidth then
        high = mid - 1
      else
        low = mid + 1
      end
    end

    newName = text:sub(1, high) .. "..."
  end

  return newName
end

---@param path string The path to where to save the .json file
---@param tble table
function Utils:saveTableAsJSONFile(path, tble)
  local file = getFileWriter(path, true, false);

  file:write(Json.Encode(tble));
  file:close();

  MxDebug:print('Wrote to file [', path, ']')
end

---@param path string The path to where to load the .json file
---@return table|nil
function Utils:loadTableFromJSONFile(path)
  local file = getFileReader(path, false);

  if file == nil then
    return nil;
  end

  local content = "";
  local line = file:readLine();
  while line ~= nil do
    content = content .. line;
    line = file:readLine();
  end

  file:close();

  MxDebug:print('read from file [', path, ']')

  return content ~= "" and Json.Decode(content) or nil;
end

function Utils:getUserID()
  return isClient()
      and "player-" .. getWorld():getWorld() .. "-" .. getClientUsername()
      or "player-" .. getWorld():getWorld();
end

--- To use with the `OnFillWorldObjectContextMenu` event's worldObjects table
---@param worldObjects table<number, IsoObject>
---@param customName string
---@param groupName string
---@return IsoObject?
function Utils:findObjectByNameAndGroup(worldObjects, groupName, customName)
  for _, object in ipairs(worldObjects) do
    local props = object:getSprite():getProperties()
    local objCustomName = props and props:Val('CustomName')
    local objGroupName = props and props:Val('GroupName')
    MxDebug:print('objCustomName:', objCustomName, 'objGroupName:', objGroupName)
    if objGroupName == groupName and objCustomName == customName then
      return object
    end
  end
end

return Utils
