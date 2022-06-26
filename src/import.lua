local module = {}

function module:LoadJsonInstance(json)
    local data = fs.read(json, "json")

    local instance = Instance.new(data.ClassName)
    for field, property in pairs(instance[sym.Properties]) do
        instance[field] = property
    end
    
    return instance
end

function module:Import(dir, out, parent)
    local content = fs.dir(dir)

    local instance
    for i, childpath in ipairs(content) do
        local pathname = childpath.Name
        if not childpath.IsDir then
            instance = module:LoadJsonInstance(pathname)
            instance.Parent = parent
        else
            local parentInstance = module:LoadJsonInstance(path.split(pathname, "base")..".json")
            module:Import(pathname, out, parentInstance)
        end
    end

    if not parent then
        fs.write(out, instance, "rbxm")
    end
    
    return instance
end

function module:Main(args, config)
    -- args[1] - input dir
    -- args[2] - output model file

    local instance = module:LoadJsonInstance(args[1]..path.split(args[1], "fstem")..".json")
    fs.write(args[2], instance, "rbxmx")
end

return module