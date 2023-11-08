local Hooks = {}
Hooks.hookRegistry = {}
Hooks.isActive = true --@type boolean

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
---@param preHookFunction function The pre-hook function to apply.
function Hooks:applyPreHook(targetTable, targetFunctionName, preHookFunction)
    self:registerHook(targetTable, targetFunctionName)
    local originalFunction = self.hookRegistry[targetTable][targetFunctionName]
    targetTable[targetFunctionName] = function(...)
        if self.isActive then
            preHookFunction(...) -- Call the pre-hook function before the original function
        end
        return originalFunction(...) -- Call the original function
    end
end

--- Applies a post-hook to the specified function.
---@param targetTable table The table containing the target function.
---@param targetFunctionName string The name of the target function.
---@param postHookFunction function The post-hook function to apply.
function Hooks:applyPostHook(targetTable, targetFunctionName, postHookFunction)
    self:registerHook(targetTable, targetFunctionName)
    local originalFunction = self.hookRegistry[targetTable][targetFunctionName]
    targetTable[targetFunctionName] = function(...)
        local result = originalFunction(...) -- Call the original function
        if self.isActive then
            postHookFunction(result) -- Call the post-hook function after the original function with the result
        end
        return result
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

return Hooks
