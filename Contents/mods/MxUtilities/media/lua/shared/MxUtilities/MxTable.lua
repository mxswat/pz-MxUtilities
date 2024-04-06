local MxTable = {}

---Reduces an array
---@generic R
---@generic T
---@param list T[] # An array
---@param fn fun(aggr:R,item:T):R # The reduction predicate
---@param init R # The initial accumulator value
---@return R # generic type is returned
function MxTable.reduce(list, fn, init)
  local acc = init
  for k, v in ipairs(list) do
    if 1 == k and not init then
      acc = v
    else
      acc = fn(acc, v)
    end
  end

  return acc
end

---Filters an array (JavaScript Array::filter equivalent)
---@generic T
---@param t T[] # An array
---@param filterIter fun(v:T,i:number,t:T[]):boolean
---@return T
function MxTable.filter(t, filterIter)
  local out = {}

  for i, v in ipairs(t) do
    if filterIter(v, i, t) then
      table.insert(out,v)
    end
  end

  return out
end

return MxTable
