---@class ISTextBoxNewMxParams
---@field x number
---@field y number
---@field width number
---@field height number
---@field text string
---@field playerNum number
---@field defaultEntryText string?
---@field target any?
---@field onclick any?
---@field param1 any?
---@field param2 any?
---@field param3 any?
---@field param4 any?

---@param params ISTextBoxNewMxParams
function ISTextBox:newMx(params)
  ---@type ISTextBox
  return ISTextBox:new(
    params.x,
    params.y,
    params.width,
    params.height,
    params.text,
    params.defaultEntryText,
    params.target,
    params.onclick,
    params.playerNum,
    params.param1,
    params.param2,
    params.param3,
    params.param4
  )
end
