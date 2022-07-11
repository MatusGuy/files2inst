local module = {}
local funcs = rbxmk.runFile(path.expand("$rsd").."/funcs.lua")

function module:LoadTableInstance(data)
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

function module:LoadJsonInstance(json)
    return module:LoadTableInstance(fs.read(json, "json"))
end

function module:LoadFileInstance(p)
    local ext = path.split(p, "ext") 
    if ext == ".lua" then
        local content = fs.read(p, "txt")

        return module:LoadTableInstance({
            ClassName = funcs:SwitchDict(funcs.SCRIPT_EXTS)[path.split(p, "fext")] or "ModuleScript",
            Source = content,
            Disabled = false
        })
    elseif ext == ".json" then
        return module:LoadJsonInstance(p)
    end

    return nil
end

function module:GetFileWithSameName(dir,ext)
    return dir..path.split(dir, "base")..ext
end

function module:GetMainFile(dir)
    return funcs:DoOneOfThePathsExist({
        module:GetFileWithSameName(dir, ".lua"),
        module:GetFileWithSameName(dir, ".server.lua"),
        module:GetFileWithSameName(dir, ".client.lua"),
        module:GetFileWithSameName(dir, ".json")
    })
end

function module:Import(dir, out)
    print("read "..dir)

    local content = fs.dir(dir)

    local parentjson = module:GetMainFile(dir)
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