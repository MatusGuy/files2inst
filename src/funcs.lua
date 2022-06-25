local module = {}

-- autodetects file format, reads file and returns it
function module:ReadFile(file)
    local split  = string.split(file,".")
    local format = split[#split]
    return fs.read(file, format)
end

-- switch case: convert roblox datatypes to json types in some way
module.JSON_FC = {}
module.JSON_FC.Axes = function(a)
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
module.JSON_FC.BrickColor = function(bc)
    return "(BrickColor) "..bc.Name
end
module.JSON_FC.Color3 = function(c)
    return {
        R = c.R,
        B = c.B,
        G = c.G
    }
end
module.JSON_FC.Instance = function(i)
    return i[sym.Properties]
end
module.JSON_FC.Vector3 = function(v)
    return {
        X = v.X,
        Y = v.Y,
        Z = v.Z
    }
end
module.JSON_FC.CFrame = function(cf)
    return {
        Position = module.JSON_FC.Vector3(cf.Position),
        XVector  = module.JSON_FC.Vector3(cf.XVector),
        YVector  = module.JSON_FC.Vector3(cf.YVector),
        ZVector  = module.JSON_FC.Vector3(cf.ZVector),
    }
end
module.JSON_FC.ColorSequenceKeypoint = function(csk)
    return {
        Time = csk.Time,
        Value = csk.Value
    }
end
module.JSON_FC.ColorSequence = function(cs)
    local kps = {}
    for _,kp in ipairs(cs.Keypoints) do
        table.insert(kps, module.JSON_FC.ColorSequenceKeypoint(kp))
    end
    return kps
end
module.JSON_FC.EnumItem = function(ei)
    return string.format("Enum.%s.%s",ei.EnumType,ei.Name)
end
module.JSON_FC.Faces = function(f)
    return {
        Top = f.Top,
        Bottom = f.Bottom,
        Left = f.Left,
        Right = f.Right,
        Back = f.Back,
        Front = f.Front,
    }
end
module.JSON_FC.NumberRange = function(nr)
    return {
        Min = nr.Min,
        Max = nr.Max
    }
end
module.JSON_FC.NumberSequence = module.JSON_FC.ColorSequence
module.JSON_FC.UDim = function(ud)
    return {
        Scale = ud.Scale,
        Offset = ud.Offset
    }
end
module.JSON_FC.UDim2 = function(ud2)
    return {
        X = ud2.X,
        Y = ud2.Y,
        Scale = ud2.Scale,
        Offset = ud2.Offset
    }
end
module.JSON_FC.Vector2 = function(v)
    return {
        X = v.X,
        Y = v.Y
    }
end

-- convert intlike to string, parse it and then convert it to number and return that number
module.JSON_FC.Intlike = function(il)
    local str = tostring(il)
    local str_num = string.gsub(str, typeof(il)..": ", "")
    return tonumber(str_num)
end


-- all of these are intlikes

module.JSON_FC.int    = module.JSON_FC.Intlike
module.JSON_FC.int64  = module.JSON_FC.Intlike
module.JSON_FC.float  = module.JSON_FC.Intlike
module.JSON_FC.token  = module.JSON_FC.Intlike
module.JSON_FC.double = module.JSON_FC.Intlike

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