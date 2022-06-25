print("!ARGS CANNOT CONTAIN WHITESPACES, USE ; TO SEPERATE ARGS INSTEAD!")
print("ARGS: "..(...))
print("")

local CONFIG_FILE = "src/config.json"
local CONFIG = fs.read(CONFIG_FILE, "json")
print("CONFIG:")
for k,v in pairs(CONFIG) do
    print(k..": "..v)
end
print("")

local args = string.split(...,";")
local cmd = args[1] or "help"
local file = args[2]

local command_module = rbxmk.runFile(CONFIG.SRC_DIR..cmd..".lua")

command_module:Main(file, CONFIG)