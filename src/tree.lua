local module = {}

function module:PrintChildren(instance, prefix)
    prefix = prefix or ""

    for i,v in ipairs(instance:GetChildren()) do
        print(prefix..v.Name)
        if #v:GetChildren() > 0 then
            module:PrintChildren(v, "-")
        end
    end
end

-- autodetects file format, reads file and returns it
function module:ReadFile(file)
    local split  = string.split(file,".")
    local format = split[#split]
    return fs.read(file, format)
end

function module:Main(file)
    local loaded = module:ReadFile(file)

    module:PrintChildren(loaded)
end

return module