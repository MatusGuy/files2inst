local module = {}

local funcs = rbxmk.runFile(path.expand("$rsd").."/funcs.lua")

function module:ToTable(instance)
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
    for k,v in pairs(funcs.PROP_EXCEPTIONS[instance.ClassName] or {}) do
        out[k] = v
    end

    return out
end

function module:_ToScript(script,out)
    local outpath = out..(funcs.SCRIPT_EXTS[script.ClassName] or ".lua")
    fs.write(outpath, script.Source, "txt")
    return outpath
end

function module:ExportInstance(instance, outdir, exportChildren)
    exportChildren = exportChildren or true

    print("reading "..instance.Name)
    local out
    local isScript = string.match(instance.ClassName, "Script") ~= nil
    if isScript then
        print(instance.Name.." appears to be a script")
        out = instance.Source
    else
        out = module:ToTable(instance)
        out.ClassName = instance.ClassName
    end

    local newpath = outdir..instance.Name

    local outext  = isScript and funcs:GetScriptExt(instance) or ".json"
    local outfile = newpath..outext
    local childrenCount = #instance:GetChildren()
    if childrenCount > 0 and exportChildren then
        print(string.format("%s has %d %s", instance.Name, childrenCount, childrenCount==1 and "child" or "children"))

        local childrenDir = newpath.."/"
        fs.mkdir(childrenDir)

        for _, child in ipairs(instance:GetChildren()) do
            module:ExportInstance(child, childrenDir)
        end
        
        outfile = childrenDir..instance.Name..outext
    end

    print(string.format("writing %s to %s", instance.Name, outfile))
    fs.write(outfile, out, isScript and ".txt" or ".json")

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