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

function module:Import(dir, out)
    print("read "..dir)

    local content = fs.dir(dir)

    local parentjson = dir..path.split(dir, "base")..".json"
    local parent = module:LoadJsonInstance(parentjson)
    for i, childpath in ipairs(content) do
        local pathname = dir..childpath.Name

        -- if childpath is not parent then
        if path.split(childpath.Name, "fstem")~=parent.Name then

            local instance
            if not childpath.IsDir then
                print("get "..pathname)
                instance = module:LoadJsonInstance(pathname)
            else
                instance = module:Import(pathname.."/", out)
            end
            instance.Parent = parent
        end
    end

    fs.write(out, parent, "rbxmx")
    
    return parent
end

function module:Main(args, config)
    -- args[1] - input dir
    -- args[2] - output model file

    --local mainFile = args[1]..path.split(args[1], "fstem")..".json"
    local instance = module:Import(args[1], args[2])
end

return module