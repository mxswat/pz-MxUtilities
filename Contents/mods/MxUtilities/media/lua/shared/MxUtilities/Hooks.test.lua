-- Since Im running lua54.exe in this folder, I don't need to respect the zomboid require rules
local Hooks = require("Hooks") -- Import the Hooks utility

-- Test the Hooks utility with pre-hooks and post-hooks
local function myPreHookFunction(...)
    print("Pre-hook function")
end

local function myPostHookFunction(result)
    print("Post-hook function")
end

local TestModule = {} -- Renamed SomeModule to TestModule

function TestModule:testFunction()
    print("Original function called")
    return "Original function result"
end

-- Apply a pre-hook and a post-hook to TestModule:testFunction()
Hooks:applyPreHook(TestModule, "testFunction", myPreHookFunction)
Hooks:applyPostHook(TestModule, "testFunction", myPostHookFunction)

-- Call TestModule:testFunction() to see the pre-hook, original function, and post-hook in action
local result = TestModule:testFunction()
print("Result:", result)

-- Toggle Hooks off
Hooks:toggleHooks(false)

-- Call TestModule:testFunction() after Hooks have been toggled off
TestModule:testFunction()

-- Toggle Hooks off
Hooks:toggleHooks(true)

TestModule:testFunction()