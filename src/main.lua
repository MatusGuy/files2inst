print("!ARGS CANNOT CONTAIN WHITESPACES, USE ; TO SEPERATE ARGS INSTEAD!")
print("ARGS: "..(...))
print("")

local SRC_DIR = path.expand("$rsd").."/"
local CONFIG_FILE = SRC_DIR.."config.json"
local CONFIG = fs.read(CONFIG_FILE, "json")
print("CONFIG:")
for k,v in pairs(CONFIG) do
    print(k..": "..v)
end
print("")

local prg_args = string.split(...,";")
local cmd = prg_args[1] or "help"

local function CloneTable(t)
    local out = {}
    for k,v in pairs(t) do
        out[k] = v
    end
    return out
end

-- get args (and remove command arg)
local args = CloneTable(prg_args)
table.remove(args, 1)

local command_module = rbxmk.runFile(SRC_DIR..cmd..".lua")

command_module:Main(args, CONFIG)