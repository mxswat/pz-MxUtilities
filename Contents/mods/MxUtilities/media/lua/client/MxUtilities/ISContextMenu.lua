require "ISUI/ISContextMenu"

---@class addOptionMxParams
---@field name string
---@field target any?
---@field toolTip ISToolTip?
---@field onSelectParams table<integer>?
---@field onSelect fun(target, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10)?

---comment
---@param params addOptionMxParams
---@return any
function ISContextMenu:addOptionMx(params)
  local option = self:addOption(params.name, params.target, params.onSelect, unpack(params.onSelectParams or {}))
  option.toolTip = params.toolTip

  return option
end

---comment
---@param addOption addOptionMxParams
---@return any, ISContextMenu
function ISContextMenu:addOptionAndSubMenuMx(addOption)
  local option = self:addOptionMx(addOption)
  local subContext = ISContextMenu:getNew(self)
  subContext:addSubMenu(option, subContext)

  return option, subContext
end
