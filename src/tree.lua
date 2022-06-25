local module = {}

function module:MultiplyString(str, n, last)
    last = last or str

    local resp = ""

    for i = 1,n,1 do
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
            module:PrintChildren(v, module:MultiplyString("│", depth), depth)
        end
    end

    depth = 0
end

function module:Main(file, config)
    local loaded = rbxmk.runFile(config.SRC_DIR.."funcs.lua"):ReadFile(file)

    module:PrintChildren(loaded)
end

return module