---@class Hooks
local Hooks = {}

function Hooks.print(...)
  if not isDebugEnabled() then
    return
  end
  local arguments = { ... }
  local printResult = ''
  for _, v in ipairs(arguments) do
    printResult = printResult .. tostring(v and v or 'nil') .. " "
  end
  print('[MxUtilities] ' .. printResult)
end

---@type table<string, table<string, function>> The registry for hooked functions.
Hooks.hookRegistry = {}

---@type boolean Indicates whether hooks are active or not.
Hooks.isActive = true

--- Registers a hook for the specified function.
---@param targetTable table The table containing the target function.
---@param targetFunctionName string The name of the target function.
function Hooks:registerHook(targetTable, targetFunctionName)
  self.hookRegistry[targetTable] = self.hookRegistry[targetTable] or {}
  self.hookRegistry[targetTable][targetFunctionName] = targetTable[targetFunctionName]
end

--- Applies a pre-hook to the specified function.
---@param targetTable table The table containing the target function.
---@param targetFunctionName string The name of the target function.
---@param preHookFunction fun(...):void The pre-hook function to apply.
function Hooks:applyPreHook(targetTable, targetFunctionName, preHookFunction)
  self:registerHook(targetTable, targetFunctionName)
  local originalFunction = self.hookRegistry[targetTable][targetFunctionName]
  targetTable[targetFunctionName] = function(...)
    if self.isActive then
      preHookFunction(...)           -- Call the pre-hook function before the original function
    end
    return originalFunction(...)     -- Call the original function
  end
end

--- Applies a post-hook to the specified function.
---@param targetTable table The table containing the target function.
---@param targetFunctionName string The name of the target function.
---@param postHookFunction fun(...):any The post-hook function to apply.
function Hooks:applyPostHook(targetTable, targetFunctionName, postHookFunction)
  self:registerHook(targetTable, targetFunctionName)
  local originalFunction = self.hookRegistry[targetTable][targetFunctionName]
  targetTable[targetFunctionName] = function(...)
    local lastResult = { originalFunction(...) }     -- Call the original function and store its result
    self.lastResult = lastResult                     -- Store the last result for later access
    self.print('Post Hook Called for ' .. targetFunctionName)
    if self.isActive then
      local newResult = postHookFunction(...)       -- Call the post-hook function with the original arguments
      return newResult or unpack(lastResult)        -- Return the modified result or the original result if nil
    end
    return unpack(lastResult)                       -- Return the original result
  end
end

--- Toggles the hooks on or off.
---@param active boolean Whether to activate or deactivate the hooks.
function Hooks:toggleHooks(active)
  self.isActive = active
end

--- Removes the hook from the specified function.
---@param targetTable table The table containing the target function.
---@param targetFunctionName string The name of the target function.
function Hooks:removeHook(targetTable, targetFunctionName)
  if self.hookRegistry[targetTable] and self.hookRegistry[targetTable][targetFunctionName] then
    targetTable[targetFunctionName] = self.hookRegistry[targetTable][targetFunctionName]
    self.hookRegistry[targetTable][targetFunctionName] = nil
  end
end

--- Gets the last result returned by the original function.
---@return any result The unpacked components of the last result.
function Hooks:getLastResult()
  return unpack(self.lastResult)
end

--- Applies hooks automatically based on function names and target class.
---@param targetClass table The target class to hook into.
---@param targetTable table The table containing the functions to be hooked.
function Hooks:autoApplyPostHooks(targetClass, targetTable)
  for key, func in pairs(targetTable) do
    if type(func) == "function" and type(targetClass[key]) == "function" then
      Hooks:applyPostHook(targetClass, key, func)
    end
  end
end

return Hooks
