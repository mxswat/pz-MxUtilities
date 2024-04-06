local HookableToolTip = require "MxUtilities/HookableTooltip"

---@param moveProps ISMoveableSpriteProps
---@param useDefaultRender? boolean
local function createHightlightToolTip(moveProps, useDefaultRender)
  local color = getCore():getGoodHighlitedColor()

  local function onRenderTooltip()
    moveProps.object:setHighlightColor(color)
    moveProps.object:setHighlighted(true, false)
    return useDefaultRender
  end

  local function onRemoveTooltip()
    moveProps.object:setHighlighted(false)
  end

  return HookableToolTip:new(onRenderTooltip, onRemoveTooltip)
end

return createHightlightToolTip