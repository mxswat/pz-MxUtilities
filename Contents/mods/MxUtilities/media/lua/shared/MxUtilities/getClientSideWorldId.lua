local function getClientSideWorldId()
  return isClient()
      and getWorld():getWorld() .. "-" .. getClientUsername()
      or getWorld():getWorld();
end

return getClientSideWorldId