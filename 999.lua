local getconstants = getconstants or debug.getconstants
local setconstant = setconstant or debug.setconstant

local islclosure = islclosure or function(Function)
  return not pcall(setfenv, getfenv(Function))
end

for _, Function in getgc(true) do
  if typeof(Function) ~= "function" or not islclosure(Function) then continue end

  local Source = debug.info(Function, "s")
  if not Source or not Source:match("ReplicatedFirst") then continue end

  local Constants = getconstants(Function)
  
  for Index, Constant in next, Constants do
    if type(Constant) ~= "string" then continue end

    if Constant == "gmatch" then
      pcall(setconstant, Function, Index, "TRICK")
    end
  end
end
