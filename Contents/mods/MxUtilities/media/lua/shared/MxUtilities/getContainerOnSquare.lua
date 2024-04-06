-- This function retrieves the container on a specific square in the game world.
-- It takes in a table of arguments including the x, y, and z coordinates of the square,
-- the index of the object on the square, and the index of the container within the object.
---@param args {x:number, y:number, z:number, objectIndex:number, containerIndex:number}
---@return ItemContainer?
local function getContainerOnSquare(args)
  local sq = getCell():getGridSquare(args.x, args.y, args.z)
  if not sq then
    return
  end

  local objectIndex, containerIndex = args.objectIndex, args.containerIndex;
  if objectIndex < 0 or objectIndex >= sq:getObjects():size() then
    return
  end

  ---@type IsoObject?
  local o = sq:getObjects():get(objectIndex)
  if not o then
    return
  end

  local container = containerIndex == -1 and o:getContainer() or o:getContainerByIndex(containerIndex)

  return container
end


return getContainerOnSquare