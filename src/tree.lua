local module = {}

function module:MultiplyString(str, n)
    local resp = ""

    for _ = 1,n,1 do
        resp = resp..str
    end
    
    return resp
end

function module:PrintChildren(instance, prefix, depth)
    prefix = prefix or ""
    depth = depth or 0

    depth = depth + 1
    for _,v in ipairs(instance:GetChildren()) do
        print(prefix..v.Name)

        if #v:GetChildren() > 0 then
            module:PrintChildren(v, module:MultiplyString("-", depth), depth)
        end
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