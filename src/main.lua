print("!ARGS CANNOT CONTAIN WHITESPACES, USE ; TO SEPERATE ARGS INSTEAD!")
print("ARGS: "..(...))

local CONFIG = {
    ["SRC_DIR"] = "src/"
}

local args = string.split(...,";")
local cmd = args[1] or "help"
local file = args[2]

local command_module = rbxmk.runFile(CONFIG.SRC_DIR..cmd..".lua")

command_module:Main(file)