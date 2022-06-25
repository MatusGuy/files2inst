local module = {}

module.ART = [[
  __ _ _           ___  _           _         **##__
 / _(_) |         |__ \(_)         | |       ##     *##__
| |_ _| | ___  ___   ) |_ _ __  ___| |_     ##   __     ##
|  _| | |/ _ \/ __| / /| | '_ \/ __| __|   ##    *#    ##
| | | | |  __/\__ \/ /_| | | | \__ \ |_    #___       ## 
|_| |_|_|\___||___/____|_|_| |_|___/\__|      ***#▃_##
                                                    ▔
]]

module.MSG = [[
FILES2INST
files2inst is a tool that creates an rbxm file from lua scripts and json files.

Usage:
    rbxmk run main.lua command;[arguments];[options]

Commands:
    tree file - output all instances of a roblox model file organized in a tree
    - file    - target model file

    help        - output basic information about the program and how to use it

    export file output_dir - export roblox model file organized in folders and json files
    - file                 - target model file
    - output_dir           - target export directory (where to put exported files in)

About configuration:
files2inst/src contains a file called config.json, where all the settings live on
for now, there are no settings
]]

function module:Main()
    print(module.ART)
    print(module.MSG)
end

return module