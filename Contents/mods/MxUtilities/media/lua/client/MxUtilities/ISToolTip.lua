---@param description string
function ISToolTip:newMx(description)
  local toolTip = ISToolTip:new()
  toolTip.description = description

  ---@type ISToolTip
  return toolTip
end