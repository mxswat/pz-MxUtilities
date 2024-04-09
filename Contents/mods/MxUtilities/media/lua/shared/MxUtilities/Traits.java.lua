---@diagnostic disable: duplicate-set-field

---@type Trait
local TraitClass = __classmetatables[Trait.class].__index

TraitClass.getRightLabel = function(self)
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