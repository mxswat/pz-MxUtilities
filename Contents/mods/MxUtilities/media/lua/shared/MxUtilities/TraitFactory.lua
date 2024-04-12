
---@class AddTraitMxArgs
---@field type string
---@field name string
---@field cost number
---@field desc string
---@field profession boolean

---@param args AddTraitMxArgs
function TraitFactory.addTraitMx(args)
  return TraitFactory.addTrait(args.type, args.name, args.cost, args.desc, args.profession)
end