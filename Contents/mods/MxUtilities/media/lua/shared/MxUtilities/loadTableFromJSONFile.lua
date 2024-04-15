local MxDebug = require "MxUtilities/MxDebug"
local Json    = require "MxUtilities/Json"
---@param path string The path to where to load the .json file
local function loadTableFromJSONFile(path)
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

  return content ~= "" and Json:decode(content) or nil;
end

return loadTableFromJSONFile