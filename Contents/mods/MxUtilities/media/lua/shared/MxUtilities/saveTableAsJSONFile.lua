local MxDebug = require "MxUtilities/MxDebug"
local Json    = require "MxUtilities/Json"

---@param path string The path to where to save the .json file
---@param tble table
local function saveTableAsJSONFile(path, tble)
  local file = getFileWriter(path, true, false);

  file:write(Json.Encode(tble));
  file:close();

  MxDebug:print('Wrote to file [', path, ']')
end

return saveTableAsJSONFile