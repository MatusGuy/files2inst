local module = {}

function module:ExportInstance(instance, exportChildren)
    exportChildren = exportChildren or true

    local out = {}

    for k,v in pairs(instance[sym.Properties]) do
        out[k] = v
    end

    if #instance:GetChildren() > 0 then
        fs.mkdir()
        for i, child in ipairs(instance:GetChildren()) do
            
        end
    end

    return out
end

function module:Main(args, config)
    -- args[1] = input file
    -- args[2] = output dir

    local instance = rbxmk.runFile(path.expand("$rsd").."/funcs.lua"):ReadFile(args[1])
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