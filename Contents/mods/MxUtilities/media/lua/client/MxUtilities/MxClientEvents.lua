---@diagnostic disable: duplicate-set-field

local function addSimpleEvent(name)
  LuaEventManager.AddEvent(name);

  return {
    ---@type function
    Add = Events[name].Add,
    ---@type function
    Remove = Events[name].Remove,
  }
end

local MxEvents = {
  onSetSandboxVars = addSimpleEvent("onSetSandboxVars"),
  onCharacterCreationProfessionVisible = addSimpleEvent("onCharacterCreationProfessionVisible")
}

local old_setSandboxVars = SandboxOptionsScreen.setSandboxVars
SandboxOptionsScreen.setSandboxVars = function(self)
  old_setSandboxVars(self)
  triggerEvent('onSetSandboxVars')
end

local old_setVisible = CharacterCreationProfession.setVisible
CharacterCreationProfession.setVisible = function(self, visible, joypadData)
  old_setVisible(self, visible, joypadData)
  if visible then
    triggerEvent('onCharacterCreationProfessionVisible')
  end
end


return MxEvents