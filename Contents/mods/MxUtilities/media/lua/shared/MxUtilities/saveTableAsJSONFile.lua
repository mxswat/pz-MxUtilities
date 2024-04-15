local MxDebug = require "MxUtilities/MxDebug"
local Json    = require "MxUtilities/Json"

---@param path string The path to where to save the .json file
---@param tableData table
local function saveTableAsJSONFile(path, tableData)
  local file = getFileWriter(path, true, false);

  file:write(Json:encode_pretty(tableData));
  file:close();

  MxDebug:print('Wrote to file [', path, ']')
end

return saveTableAsJSONFile