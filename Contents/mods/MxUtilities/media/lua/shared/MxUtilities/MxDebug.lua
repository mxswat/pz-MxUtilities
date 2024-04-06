local MxDebug = {}

---@param node table|any
function MxDebug:printTable(node)
  if not isDebugEnabled() then
    return
  end

  local cache, stack, output = {}, {}, {}
  local depth = 1
  local output_str = "{\n"

  while true do
    local size = 0
    for k, v in ipairs(node) do
      size = size + 1
    end

    local cur_index = 1
    for k, v in ipairs(node) do
      if (cache[node] == nil) or (cur_index >= cache[node]) then
        if (string.find(output_str, "}", output_str:len())) then
          output_str = output_str .. ",\n"
        elseif not (string.find(output_str, "\n", output_str:len())) then
          output_str = output_str .. "\n"
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output, output_str)
        output_str = ""

        local key
        if (type(k) == "number" or type(k) == "boolean") then
          key = "[" .. tostring(k) .. "]"
        else
          key = "['" .. tostring(k) .. "']"
        end

        if (type(v) == "number" or type(v) == "boolean") then
          output_str = output_str .. string.rep('  ', depth) .. key .. " = " .. tostring(v)
        elseif (type(v) == "table") then
          output_str = output_str .. string.rep('  ', depth) .. key .. " = {\n"
          table.insert(stack, node)
          table.insert(stack, v)
          cache[node] = cur_index + 1
          break
        else
          output_str = output_str .. string.rep('  ', depth) .. key .. " = '" .. tostring(v) .. "'"
        end

        if (cur_index == size) then
          output_str = output_str .. "\n" .. string.rep('  ', depth - 1) .. "}"
        else
          output_str = output_str .. ","
        end
      else
        -- close the table
        if (cur_index == size) then
          output_str = output_str .. "\n" .. string.rep('  ', depth - 1) .. "}"
        end
      end

      cur_index = cur_index + 1
    end

    if (size == 0) then
      output_str = output_str .. "\n" .. string.rep('  ', depth - 1) .. "}"
    end

    if (#stack > 0) then
      node = stack[#stack]
      stack[#stack] = nil
      depth = cache[node] == nil and depth + 1 or depth - 1
    else
      break
    end
  end

  -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
  table.insert(output, output_str)
  output_str = table.concat(output)

  self:print(output_str)
end

function MxDebug:print(...)
  if not isDebugEnabled() then
    return
  end

  local printResult = ''
  -- I'm using `select` instead of `ipairs` or `pairs` because I want to print nil values
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    printResult = printResult .. tostring(v) .. ' '
  end

  local modId = MxDebug:getCurrentModIdAndFileName()
  print('[' .. modId .. '] ' .. printResult)
end

--- It returns the mod id of the file this has been called from
function MxDebug:getCurrentModIdAndFileName()
  local coroutine = getCurrentCoroutine()
  local count = getCallframeTop(coroutine)
  local lastModId
  local lastFilename
  for i = count - 1, 0, -1 do
    local o = getCoroutineCallframeStack(coroutine, i)
    if o ~= nil then
      local modFileFunctionLine = KahluaUtil.rawTostring2(o)
      if modFileFunctionLine then
        local fileName, modId = modFileFunctionLine:match(".* file: (.-) line # %d+ | MOD: (.*)")
        if modId then
          lastModId = modId
          lastFilename = fileName
          if modId ~= "MxUtilities" then
            break
          end
        end
      end
    end
  end

  return tostring(lastModId), tostring(lastFilename)
end

return MxDebug
