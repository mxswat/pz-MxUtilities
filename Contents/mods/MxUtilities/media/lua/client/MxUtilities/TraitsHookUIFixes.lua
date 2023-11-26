local MxClientEvents = require "MxUtilities/MxClientEvents"
local DebugUtils = require "MxUtilities/DebugUtils"

local function updateTraits()
  DebugUtils:print('TraitsHookUIFixes - updateTraits')

  TraitFactory.sortList()

  local ccpSelf = MainScreen.instance.charCreationProfession

  ccpSelf.pointToSpend = 0

  ---@type ISScrollingListBox
  local listboxGoodTrait = ccpSelf.listboxTrait
  listboxGoodTrait:clear()
  ccpSelf:populateTraitList(listboxGoodTrait);
  CharacterCreationMain.sort(listboxGoodTrait.items);

  local listboxBadTrait = ccpSelf.listboxBadTrait
  listboxBadTrait:clear()
  ccpSelf:populateBadTraitList(listboxBadTrait);
  CharacterCreationMain.invertSort(listboxBadTrait.items);

  local selectedTraits = ccpSelf.listboxTraitSelected.items

  ccpSelf.listboxTraitSelected:clear()
  CharacterCreationMain.sort(ccpSelf.listboxTraitSelected.items)

  for _, traitItem in ipairs(selectedTraits) do
    for listboxI, item in ipairs(listboxGoodTrait.items) do
      if item.item == traitItem.item then
        listboxGoodTrait.selected = listboxI
        ccpSelf:onDblClickTrait()
      end
    end
  end

  for _, traitItem in ipairs(selectedTraits) do
    for listboxI, item in ipairs(listboxBadTrait.items) do
      if item.item == traitItem.item then
        listboxBadTrait.selected = listboxI
        ccpSelf:onDblClickBadTrait()
      end
    end
  end
end

Events.OnConnected.Add(updateTraits)

MxClientEvents.onSetSandboxVars.Add(function()
  updateTraits()
end)

MxClientEvents.onCharacterCreationProfessionVisible.Add(function()
  updateTraits()
end)
