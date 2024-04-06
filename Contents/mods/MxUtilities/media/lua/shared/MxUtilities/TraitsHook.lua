local Hooks = require "MxUtilities/Hooks"
local TraitsHook = {}

local traitMetatable = __classmetatables[Trait.class].__index
for funcName, originalFunc in ipairs(traitMetatable) do
  Hooks:_ChkCreateTableStructure(traitMetatable, funcName)
end

---@param func string @Name of the function on `object` to run `post_call` after
---@param id string @Unique name for this posthook
---@param post_call function @Function to be called after `func` on `object`
function TraitsHook:PostHook(func, id, post_call)
  Hooks:PostHook(traitMetatable, func, id, post_call)
end

---@param hooksTable table The table containing the functions to be hooked.
---@param idPrefix string The prefix used to generate the hook id (Prefix_FunctionName)
---@param isHooked? boolean defaults to true, set to false for manual hooks toggle
function TraitsHook:PostHooksFromTable(hooksTable, idPrefix, isHooked)
  return Hooks:PostHooksFromTable(traitMetatable, hooksTable, idPrefix, isHooked)
end

function TraitsHook:GetReturn()
  return Hooks:GetReturn()
end

---@param self Trait
local function getRightLabelFix(self)
  local cost = self:getCost()
  local label = ""

  if cost == 0 then
    return label
  end

  if cost > 0 then
    label = "-"
  else
    label = "+"
  end

  if cost < 0 then cost = cost * -1 end

  return label .. cost
end

Hooks:PostHook(traitMetatable, 'getRightLabel', 'TraitsHook_getRightLabelFix', getRightLabelFix)

return TraitsHook
