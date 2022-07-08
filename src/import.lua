local module = {}
local funcs = rbxmk.runFile(path.expand("$rsd").."/funcs.lua")

function module:LoadJsonInstance(json)
    local data = fs.read(json, "json")

    local instance = Instance.new(data.ClassName)
    for field, property in pairs(data) do
        if type(property) == "table" then
            local convert = funcs.JSON_FC.IMPORT[property._Type]
            
            if convert then
                instance[field] = convert(property)
            else
                instance[field] = string.format("files2inst WARN: could not convert %s to Roblox datatype", property._Type)
            end
        else
            instance[field] = property
        end
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
        fs.write(out, instance, "rbxmx")
    end
    
    return instance
end

function module:Main(args, config)
    -- args[1] - input dir
    -- args[2] - output model file

    local mainFile = args[1]..path.split(args[1], "fstem")..".json"
    local instance = module:LoadJsonInstance(mainFile)
    fs.write(args[2], instance, "rbxmx")
end

return module