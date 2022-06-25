local module = {}

function module:MultiplyString(str, exp)
    for i = 1,exp,1 do
        if i > 1 then
            str = str..str
        end
    end
    return str
end

local depth = 0 -- please don't change
function module:PrintChildren(instance, prefix)
    prefix = prefix or ""

    depth = depth + 1
    for _,v in ipairs(instance:GetChildren()) do
        print(prefix..v.Name)

        local olddepth = depth
        if #v:GetChildren() > 0 then
            module:PrintChildren(v, module:MultiplyString("-", depth))
        end
        depth = olddepth
    end

    depth = 0
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