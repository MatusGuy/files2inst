local module = {}

function module:ExportInstance(instance, outdir, exportChildren)
    exportChildren = exportChildren or true

    local out = {}

    for k,v in pairs(instance[sym.Properties]) do
        out[k] = v
    end

    if #instance:GetChildren() > 0 and exportChildren then
        local childrenDir = outdir..instance.Name.."/"
        fs.mkdir(childrenDir)

        for _, child in ipairs(instance:GetChildren()) do
            module:ExportInstance(child, childrenDir)
        end
    end

    local outfile = outdir..instance.Name..".json"
    fs.write(outfile, out, "json")

    return out
end

function module:Main(args, config)
    -- args[1] = input file
    -- args[2] = output dir

    local instance = rbxmk.runFile(path.expand("$rsd").."/funcs.lua"):ReadFile(args[1])

    local dir = args[2]..instance.Name.."/"
    fs.mkdir(dir)
    for _,obj in pairs(instance:GetChildren()) do
        module:ExportInstance(obj, dir)
    end
end

return module