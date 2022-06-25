local module = {}

function module:Main(args, config)
    -- args[1] = input file
    -- args[2] = output dir

    local instance = rbxmk.runFile(config.SRC_DIR.."funcs.lua"):ReadFile(args[1])
    local out = {}

    local properties = instance[sym.Properties]
    for k,v in pairs(properties) do
        print(k..": "..v)
        if k~="Parent" then
            out[k] = v
        end
    end

    fs.write(args[2].."out.json", out, "json")
end

return module