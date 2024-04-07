---@param description string
function ISInventoryPaneContextMenu.addToolTipMx(description)
  local tootTip = ISInventoryPaneContextMenu.addToolTip()
  tootTip.description = description

  ---@type ISToolTip
  return tootTip
end