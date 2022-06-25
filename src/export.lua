local module = {}

function module:Main(file, config)
    local instance = rbxmk.runFile(config.SRC_DIR.."funcs.lua"):ReadFile(file)
    local out = {}

    local properties = instance[sym.Properties]
    for k,v in pairs(properties) do
        print(k..": "..v)
        if k~="Parent" then
            out[k] = v
        end
    end

    fs.write("out.json", out, "json")
end

return module