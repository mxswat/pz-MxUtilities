
---@class AddProfessionMxArgs
---@field type string
---@field name string
---@field IconPath string
---@field points number

function ProfessionFactory.addProfessionMx(args)
  return ProfessionFactory.addProfession(args.type, args.name, args.IconPath, args.points)
end