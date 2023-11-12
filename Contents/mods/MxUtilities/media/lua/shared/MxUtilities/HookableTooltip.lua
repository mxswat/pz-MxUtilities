local HookableToolTip = {}

--- HookableToolTip extends `ISToolTip` and provides a customizable tooltip with hooks for rendering and removal.
---@param onRender function The function to be called when rendering the tooltip. If it returns true, the original render function is also called.
---@param onRemove function The function to be called when removing the tooltip from the UI.
---@return ISToolTip
function HookableToolTip:new(onRender, onRemove)
  local toolTip = ISToolTip:new()
  toolTip.description = ""

  local originalRender = toolTip.render
  ---@diagnostic disable-next-line: duplicate-set-field
  toolTip.render = function(self)
    -- Call the provided onRender function
    local customRenderResult = onRender(self)
    if customRenderResult == true then
      originalRender(self)
    end
  end

  local old_removeFromUIManager = toolTip.removeFromUIManager
  ---@diagnostic disable-next-line: duplicate-set-field
  toolTip.removeFromUIManager = function(self)
    onRemove()
    old_removeFromUIManager(self)
  end

  return toolTip
end

return HookableToolTip