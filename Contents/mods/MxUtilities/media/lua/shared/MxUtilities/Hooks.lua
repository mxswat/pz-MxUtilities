-- The MIT License (MIT)
-- Copyright (c) 2014 James Wilkinson, Timothy Clissold
-- Copyright (c) 2023 Massimo Mx (Modified from: https://gitlab.com/znixian/payday2-superblt-lua/-/blob/master/req/core/Hooks.lua)
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local debug = require('MxUtilities/Debug')
local Debug = debug:new('MxUtilities')

-- next() is not avaiable in zomboid
local function _next(table)
  return table ~= nil and #table > 0
end

---@class Hooks
local Hooks = {}
Hooks._registered_hooks = Hooks._registered_hooks or {}
Hooks._function_hooks = Hooks._function_hooks or {}

---Registers a hook so that functions can be added to it, and later called
---@param key string @Unique hook name
function Hooks:RegisterHook(key)
  self._registered_hooks[key] = self._registered_hooks[key] or {}
end

---Registers a hook so that functions can be added to it, and later called
---Functionally the same as `Hooks:RegisterHook`
---@param key string @Unique hook name
function Hooks:Register(key)
  self:RegisterHook(key)
end

---Adds a function call to a hook, so that it will be called when the hook is called
---@param key string @Name of the hook to be called on
---@param id string @Unique name for this specific function call
---@param func function @The function to call with the hook
function Hooks:AddHook(key, id, func)
  self._registered_hooks[key] = self._registered_hooks[key] or {}
  -- Update existing hook
  for k, v in pairs(self._registered_hooks[key]) do
    if v.id == id then
      v.func = func
      return
    end
  end
  -- Add new hook, if id doesn't exist
  local tbl = {
    id = id,
    func = func
  }
  table.insert(self._registered_hooks[key], tbl)
end

---Adds a function call to a hook, so that it will be called when the hook is called
---Functionally the same as `Hooks:AddHook`
---@param key string @Name of the hook to be called on
---@param id string @Unique name for this specific function call
---@param func function @Function to call with the hook
function Hooks:Add(key, id, func)
  self:AddHook(key, id, func)
end

---Removes a hook, so that it will not call any functions
---@param key string @Name of the hook to remove
function Hooks:UnregisterHook(key)
  self._registered_hooks[key] = nil
end

---Removes a hook, so that it will not call any functions
---Functionally the same as `Hooks:UnregisterHook`
---@param key string @Name of the hook to remove
function Hooks:Unregister(key)
  self:UnregisterHook(key)
end

---Removes a hooked function call with the specified id to prevent it from being called
---@param id string @Name of the function call to remove
function Hooks:Remove(id)
  for k, v in pairs(self._registered_hooks) do
    if type(v) == "table" then
      for x, y in pairs(v) do
        if y.id == id then
          y = nil
        end
      end
    end
  end
end

---Calls a specified hook, and all of its hooked functions
---@param key string @Name of the hook to call
---@param ... any @Arguments to pass to the hooked functions
function Hooks:Call(key, ...)
  if not self._registered_hooks[key] then
    return
  end

  for k, v in pairs(self._registered_hooks[key]) do
    if v then
      if type(v.func) == "function" then
        v.func(...)
      end
    end
  end
end

---Calls a specified hook and returns the first non nil value(s) returned by a hooked function
---@param key string @Name of the hook to call
---@param ... any @Arguments to pass to the hooked functions
---@return any ... @The value(s) returned by a hooked function
function Hooks:ReturnCall(key, ...)
  if not self._registered_hooks[key] then
    return
  end

  for k, v in pairs(self._registered_hooks[key]) do
    if v then
      if type(v.func) == "function" then
        local r = { v.func(...) }
        if _next(r) == 1 then
          return unpack(r)
        end
      end
    end
  end
end

---Hooks a function to be called before the specified function on a specified object
---If `pre_call` returns anything, it will be used if neither the original function nor any hooks coming after this one return anything
---@param object any @Object for the hooked function to be called on
---@param func string @Name of the function on `object` to run `pre_call` before
---@param id string @Unique name for this prehook
---@param pre_call function @Function to be called before `func` on `object`
function Hooks:PreHook(object, func, id, pre_call)
  if not object or type(pre_call) ~= "function" then
    self:_PrePostHookError(func, id)
    return
  end

  if not self:_ChkCreateTableStructure(object, func) then
    for k, v in pairs(self._function_hooks[object][func].overrides.pre) do
      if v.id == id then
        return
      end
    end
  end

  local func_tbl = {
    id = id,
    func = pre_call
  }
  table.insert(self._function_hooks[object][func].overrides.pre, func_tbl)
end

---Removes a prehook and prevents it from being run
---@param id string @Name of the prehook to remove
function Hooks:RemovePreHook(id)
  for object_i, object in pairs(self._function_hooks) do
    for func_i, func in pairs(object) do
      for override_i, override in ipairs(func.overrides.pre) do
        if override.id == id then
          table.remove(func.overrides.pre, override_i)
        end
      end
    end
  end
end

---Hooks a function to be called after the specified function on a specified object
---If `post_call` returns anything, it will override the return value(s) of the original function and other hooks coming before this one
---@param object any @Object for the hooked function to be called on
---@param func string @Name of the function on `object` to run `post_call` after
---@param id string @Unique name for this posthook
---@param post_call function @Function to be called after `func` on `object`
function Hooks:PostHook(object, func, id, post_call)
  if not object or type(post_call) ~= "function" then
    self:_PrePostHookError(func, id)
    return
  end

  if not self:_ChkCreateTableStructure(object, func) then
    for k, v in pairs(self._function_hooks[object][func].overrides.post) do
      if v.id == id then
        return
      end
    end
  end

  local func_tbl = {
    id = id,
    func = post_call
  }
  table.insert(self._function_hooks[object][func].overrides.post, func_tbl)
end

---Removes a posthook and prevents it from being run
---@param id string @Name of the posthook to remove
function Hooks:RemovePostHook(id)
  for object_i, object in pairs(self._function_hooks) do
    for func_i, func in pairs(object) do
      for override_i, override in ipairs(func.overrides.post) do
        if override.id == id then
          table.remove(func.overrides.post, override_i)
        end
      end
    end
  end
end

---Overrides a function completely while keeping existing hooks to it intact
---@param object any @Object of the function to override
---@param func string @Name of the function on `object` override
---@param override function @Function to replace the original function `func` with
function Hooks:OverrideFunction(object, func, override)
  if not self._function_hooks[object] or not self._function_hooks[object][func] then
    object[func] = override
  else
    self._function_hooks[object][func].original = override
  end
end

---Returns the current original function of an object
---@param object any @Object of the function to get
---@param func string @Name of the function on `object` to get
---@return function @Original function `func` of `object`
function Hooks:GetFunction(object, func)
  if not self._function_hooks[object] or not self._function_hooks[object][func] then
    return object[func]
  else
    return self._function_hooks[object][func].original
  end
end

---Returns the return value(s) of the currently running hook
---@return any ... @Any amount of return values of the current hook
function Hooks:GetReturn()
  if self._current_function_hook and self._current_function_hook.returns then
    return unpack(Hooks._current_function_hook.returns)
  end
end

-- Shared function to log hook errors
function Hooks:_PrePostHookError(func, id)
  Debug:print(string.format("[Hooks] Could not hook function '%s' (%s)", tostring(func), tostring(id)))
end

-- Helper to create the hooks table structure and function override
function Hooks:_ChkCreateTableStructure(object, func)
  if self._function_hooks[object] == nil then
    self._function_hooks[object] = {}
  end

  if self._function_hooks[object][func] then
    return
  end

  self._function_hooks[object][func] = {
    original = object[func],
    overrides = {
      pre = {},
      post = {}
    }
  }

  object[func] = function(...)
    local function_hook = self._function_hooks[object][func]
    local hook_return

    -- Call prehooks
    for k, v in ipairs(function_hook.overrides.pre) do
      self._current_function_hook = function_hook
      hook_return = { v.func(...) }
      if _next(hook_return) then
        function_hook.returns = hook_return
      end
    end

    -- Call original function
    hook_return = { function_hook.original(...) }
    if _next(hook_return) then
      function_hook.returns = hook_return
    end

    -- Call posthooks
    for k, v in ipairs(function_hook.overrides.post) do
      self._current_function_hook = function_hook
      hook_return = { v.func(...) }
      if _next(hook_return) then
        function_hook.returns = hook_return
      end
    end

    if function_hook.returns then
      hook_return = function_hook.returns
      function_hook.returns = nil

      return unpack(hook_return)
    end
  end

  return true
end

--- Automatically applies post-hooks based on function names and target class.
---@param originalTable table The target class to hook into.
---@param hooksTable table The table containing the functions to be hooked.
---@param idPrefix string The prefix used to generate the hook id (Prefix_FunctionName)
---@param isHooked? boolean defaults to true, set to false for manual hooks toggle
function Hooks:PostHooksFromTable(originalTable, hooksTable, idPrefix, isHooked)
  
  -- Set isHooked to true only if it's nil, not if it's explicitly false
  if isHooked == nil then
    isHooked = true
  end

  local function generateId(key)
    return idPrefix .. "_" .. key
  end

  local function attachHooks()
    for funcName, func in pairs(hooksTable) do
      if type(func) == "function" and type(originalTable[funcName]) == "function" then
        Hooks:PostHook(originalTable, funcName, generateId(funcName), func)
      end
    end
  end

  local function detachHooks()
    for funcName, _ in pairs(hooksTable) do
      if type(hooksTable[funcName]) == "function" and type(hooksTable[funcName]) == "function" then
        local id = generateId(funcName)
        Hooks:RemovePostHook(id)
      end
    end
  end

  ---@param value boolean
  local function toggleHooks(value)
    if value == true then
      attachHooks()
    else
      detachHooks()
    end
  end

  --- Detach hooks if via the debug menu I'm reloading the file
  detachHooks()

  if isHooked then
    attachHooks()
  end


  return toggleHooks
end

return Hooks
