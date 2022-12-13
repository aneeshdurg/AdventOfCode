function load_list(list_str)
    return load("return " .. list_str:gsub("%[", "{"):gsub("%]", "}"))()
end

function is_ordered(list1, list2)
  for i = 1, #list1
  do
    if i > #list2
    then
      return 1
    end

    local var1 = list1[i]
    local var2 = list2[i]
    if type(var1) == "number" and type(var2) == "number"
    then
      if var1 < var2
      then
        return -1
      elseif var1 > var2
      then
        return 1
      end
    else
      local table1 = var1
      local table2 = var2
      if type(var1) == "number"
      then
        table1 = {var1}
      elseif type(var2) == "number"
      then
        table2 = {var2}
      end

      local ord = is_ordered(table1, table2)
      if not (ord == 0)
      then
        return ord
      end
    end
  end

  if #list1 < #list2
  then
    return -1
  end
  return 0
end


local out_of_order = 0

local f = io.open("input.txt")
local idx = 1
local idx_sum = 0

local packets = {}
while true
do
  local line1 = f:read("l")
  if line1 == nil
  then
    break
  end

  local line2 = f:read("l")
  if line2 == nil
  then
    break
  end

  local list1 = load_list(line1)
  packets[#packets + 1] = list1
  local list2 = load_list(line2)
  packets[#packets + 1] = list2

  ord = is_ordered(list1, list2)
  if ord > 0
  then
    out_of_order = out_of_order + 1
  else
    idx_sum = idx_sum + idx
  end


  -- there might be an empty line to throw away
  f:read("l")
  idx = idx + 1
end

packets[#packets + 1] = {{2}}
packets[#packets + 1] = {{6}}

function sort_key(list1, list2)
  return is_ordered(list1, list2) < 0
end

-- part 1

print("In order sum", idx_sum)

-- part 2

function is_eq(list1, list2)
  if not (#list1 == #list2)
  then
    return false
  end

  for i = 1, #list1
  do
    local var1 = list1[i]
    local var2 = list2[i]
    if not (type(var1) == type(var2))
    then
      return false
    end

    if type(var1) == "number"
    then
      if not(var1 == var2)
      then
        return false
      end
    else
      if not is_eq(var1, var2)
      then
        return false
      end
    end
  end

  return true
end

table.sort(packets, sort_key)

local decoder_key = 1;
for i = 1, #packets
do
  if is_eq(packets[i], {{2}})
  then
    decoder_key = decoder_key * i
  end

  if is_eq(packets[i], {{6}})
  then
    decoder_key = decoder_key * i
  end
end

print("Decoder key", decoder_key)
