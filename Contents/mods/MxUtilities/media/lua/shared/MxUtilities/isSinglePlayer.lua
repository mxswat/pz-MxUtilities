local function isSinglePlayer()
  return (not isClient() and not isServer())
end

return isSinglePlayer