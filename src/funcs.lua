local module = {}

-- autodetects file format, reads file and returns it
function module:ReadFile(file)
    local split  = string.split(file,".")
    local format = split[#split]
    return fs.read(file, format)
end

-- displayed when user tries to run "rbxmk run main.lua funcs"
module.MSG = [[
funcs is a module with various functions globaly used by files2inst commands.

To import functions from this module in an rbxmk script:
"local funcs = rbxmk.runFile('funcs.lua')"
]]

function module:Main()
    print(module.MSG)
end

return module