print("!ARGS CANNOT CONTAIN WHITESPACES, USE ; TO SEPERATE ARGS INSTEAD!")
print("ARGS: "..(... or "<nothing>"))
print("")

local SRC_DIR = path.expand("$rsd").."/"
local CONFIG_FILE = SRC_DIR.."config.json"
local CONFIG = fs.read(CONFIG_FILE, "json")
print("CONFIG: <nothing>")
--[[
for k,v in pairs(CONFIG) do
    print(k..": "..v)
end
]]
print("")

local cmd = "help"
local args = {}
if ... then
    local prg_args = string.split(...,";")
    cmd = prg_args[1]

    local function CloneTable(t)
        local out = {}
        for k,v in pairs(t) do
            out[k] = v
        end
        return out
    end

    -- get args (and remove command arg)
    args = CloneTable(prg_args)
    table.remove(args, 1)
end

local command_module = rbxmk.runFile(SRC_DIR..cmd..".lua")

command_module:Main(args, CONFIG)