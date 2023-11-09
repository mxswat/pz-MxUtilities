-- local Hooks = require "MxUtilities/Hooks"

-- ---@class HookedClassFactory
-- local HookedClassFactory = {}

-- ---@param classId string The ID of the class used to generate the hook ID (Id_FunctionName).
-- ---@param key string The method key to generate the hook ID.
-- ---@return string The generated hook ID.
-- function HookedClassFactory.generateId(classId, key)
--   return classId .. "_" .. key
-- end

-- --- Attaches post hooks to the provided class based on the target class.
-- ---@param class table The class to attach hooks to.
-- ---@param classId string The ID of the class used to generate hook IDs.
-- ---@param targetClass table The target class to hook into.
-- function HookedClassFactory.attachHooks(class, classId, targetClass)
--   for funcName, func in pairs(class) do
--     if type(func) == "function" and type(targetClass[funcName]) == "function" then
--       local id = HookedClassFactory.generateId(classId, funcName)
--       Hooks:PostHook(targetClass, funcName, id, func)
--     end
--   end
-- end

-- --- Detaches post hooks from the provided class based on the target class.
-- ---@param class table The class to detach hooks from.
-- ---@param classId string The ID of the class used to generate hook IDs.
-- ---@param targetClass table The target class to unhook from.
-- function HookedClassFactory.detachHooks(class, classId, targetClass)
--   for funcName, _ in pairs(class) do
--     if type(class[funcName]) == "function" and type(targetClass[funcName]) == "function" then
--       local id = HookedClassFactory.generateId(classId, funcName)
--       Hooks:RemovePostHook(id)
--     end
--   end
-- end

-- --- Creates a new class/table with the given name.
-- ---@param classId string The ID of the class used to generate the hook ID (Id_FunctionName).
-- ---@param targetClass table The target class to hook into.
-- ---@return table The created class with hooks functionality.
-- ---@return function The enableHooks function to toggle hooks in the class.
-- function HookedClassFactory:new(classId, targetClass)
--   ---@class HookedClass
--   local class = {}
--   local hooksEnabled = true

--   --- Enables or disables hooks in this class.
--   ---@param enable boolean Whether to enable (true) or disable (false) hooks.
--   local function enableHooks(enable)
--     hooksEnabled = enable
--     if hooksEnabled then
--       HookedClassFactory.attachHooks(class, classId, targetClass)
--     else
--       HookedClassFactory.detachHooks(class, classId, targetClass)
--     end
--   end

--   return class, enableHooks
-- end

-- return HookedClassFactory
