local module = {}

module.MSG = [[
FILES2INST
files2inst is a tool that creates an rbxm file from lua scripts and json files.

Usage:
    rbxmk run main.lua command;[file];[options (seperated by semicolons)]

Commands:
    tree - output all instances of a rbxm/rbxl file organized in a tree
    help - output basic information about the program and how to use it

Arguments:
    [file] - target file
]]

function module:Main()
    print(module.MSG)
end

return module