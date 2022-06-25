local module = {}

function module:Import(dir, parent)
    local content = fs.dir(dir)

    for i, path in ipairs(content) do
        local pathname = path.Name
        local data = fs.read(pathname, "json")

        local instance = Instance.new(data.ClassName, parent)
        for k,v in pairs(instance[sym.Properties]) do
            instance[k] = v
        end
    end
end

function module:Main(args, config)
    -- args[1] - input dir
    -- args[2] - output model file

    module:Import(args[2])
end

return module