local module = {}

-- autodetects file format, reads file and returns it
function module:ReadFile(file)
    local split  = string.split(file,".")
    local format = split[#split]
    return fs.read(file, format)
end

-- switch case: convert roblox datatypes to json types in some way
module.JSON_FC = {
    EXPORT = {},
    IMPORT = {}
}
module.JSON_FC.EXPORT.Axes = function(a)
    return {
        X = a.X,
        Y = a.Y,
        Z = a.Z,
        Top = a.Top,
        Bottom = a.Bottom,
        Left = a.Left,
        Right = a.Right,
        Back = a.Back,
        Front = a.Front,
    }
end
module.JSON_FC.EXPORT.BrickColor = function(bc)
    return "(BrickColor) "..bc.Name
end
module.JSON_FC.EXPORT.Color3 = function(c)
    return {
        R = c.R,
        B = c.B,
        G = c.G
    }
end
module.JSON_FC.EXPORT.Instance = function(i)
    return i[sym.Properties]
end
module.JSON_FC.EXPORT.Vector3 = function(v)
    return {
        X = v.X,
        Y = v.Y,
        Z = v.Z
    }
end
module.JSON_FC.EXPORT.CFrame = function(cf)
    return {
        Position = module.JSON_FC.EXPORT.Vector3(cf.Position),
        XVector  = module.JSON_FC.EXPORT.Vector3(cf.XVector),
        YVector  = module.JSON_FC.EXPORT.Vector3(cf.YVector),
        ZVector  = module.JSON_FC.EXPORT.Vector3(cf.ZVector),
    }
end
module.JSON_FC.EXPORT.ColorSequenceKeypoint = function(csk)
    return {
        Time = csk.Time,
        Value = csk.Value
    }
end
module.JSON_FC.EXPORT.ColorSequence = function(cs)
    local kps = {}
    for _,kp in ipairs(cs.Keypoints) do
        table.insert(kps, module.JSON_FC.EXPORT.ColorSequenceKeypoint(kp))
    end
    return kps
end
module.JSON_FC.EXPORT.EnumItem = function(ei)
    return string.format("Enum.%s.%s",ei.EnumType,ei.Name)
end
module.JSON_FC.EXPORT.Faces = function(f)
    return {
        Top = f.Top,
        Bottom = f.Bottom,
        Left = f.Left,
        Right = f.Right,
        Back = f.Back,
        Front = f.Front,
    }
end
module.JSON_FC.EXPORT.NumberRange = function(nr)
    return {
        Min = nr.Min,
        Max = nr.Max
    }
end
module.JSON_FC.EXPORT.NumberSequence = module.JSON_FC.EXPORT.ColorSequence
module.JSON_FC.EXPORT.UDim = function(ud)
    return {
        Scale = ud.Scale,
        Offset = ud.Offset
    }
end
module.JSON_FC.EXPORT.UDim2 = function(ud2)
    return {
        X = module.JSON_FC.EXPORT.UDim(ud2.X),
        Y = module.JSON_FC.EXPORT.UDim(ud2.Y),
    }
end
module.JSON_FC.EXPORT.Vector2 = function(v)
    return {
        X = v.X,
        Y = v.Y
    }
end

-- convert intlike to string, parse it and then convert it to number and return that number
module.JSON_FC.EXPORT.Intlike = function(il)
    local str = tostring(il)
    local str_num = string.gsub(str, typeof(il)..": ", "")
    return tonumber(str_num)
end


-- all of these are intlikes

module.JSON_FC.EXPORT.int    = module.JSON_FC.EXPORT.Intlike
module.JSON_FC.EXPORT.int64  = module.JSON_FC.EXPORT.Intlike
module.JSON_FC.EXPORT.float  = module.JSON_FC.EXPORT.Intlike
module.JSON_FC.EXPORT.token  = module.JSON_FC.EXPORT.Intlike
module.JSON_FC.EXPORT.double = module.JSON_FC.EXPORT.Intlike

-- displayed when user tries to run "rbxmk run main.lua funcs"
module.MSG = [[
funcs is a module with various functions globaly used by files2inst commands.

To import functions from this module in an rbxmk script:
"local funcs = rbxmk.runFile('funcs.lua')"
]]

function module:Main()
    print(module.MSG)
end

return module