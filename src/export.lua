local module = {}

local funcs = rbxmk.runFile(path.expand("$rsd").."/funcs.lua")

function module:ExportInstance(instance, outdir, exportChildren)
    exportChildren = exportChildren or true

    local out = {}

    for k,v in pairs(instance[sym.Properties]) do
        if type(v) == "userdata" then
            local convert = funcs.JSON_FC.EXPORT[typeof(v)]
            
            if convert then
                out[k] = convert(v)
            else
                out[k] = string.format("files2inst WARN: could not convert %s to JSON type", typeof(v))
            end
        else
            out[k] = v
        end
    end
    out.ClassName = instance.ClassName

    local newpath = outdir..instance.Name

    local outfile = newpath..".json"
    if #instance:GetChildren() > 0 and exportChildren then
        local childrenDir = newpath.."/"
        fs.mkdir(childrenDir)

        for _, child in ipairs(instance:GetChildren()) do
            module:ExportInstance(child, childrenDir)
        end
        
        outfile = childrenDir..instance.Name..".json"
    end

    fs.write(outfile, out, "json")

    return out
end

function module:Main(args, config)
    -- args[1] = input file
    -- args[2] = output dir

    local instance = funcs:ReadFile(args[1])

    local dir = args[2]..instance.Name.."/"
    fs.mkdir(dir)
    for _,obj in pairs(instance:GetChildren()) do
        module:ExportInstance(obj, dir)
    end
end

return module