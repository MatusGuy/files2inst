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
        _Type = "Axes",
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
        _Type = "Color3",
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
        _Type = "Vector3",
        X = v.X,
        Y = v.Y,
        Z = v.Z
    }
end
module.JSON_FC.EXPORT.CFrame = function(cf)
    return {
        _Type = "CFrame",
        Position = module.JSON_FC.EXPORT.Vector3(cf.Position),
        XVector  = module.JSON_FC.EXPORT.Vector3(cf.XVector),
        YVector  = module.JSON_FC.EXPORT.Vector3(cf.YVector),
        ZVector  = module.JSON_FC.EXPORT.Vector3(cf.ZVector),
    }
end
module.JSON_FC.EXPORT.SequenceKeypoint = function(csk, _type)
    return {
        --_Type = _type,
        Time = csk.Time,
        Value = csk.Value
    }
end
module.JSON_FC.EXPORT.ColorSequence = function(cs, _type)
    _type = _type or "ColorSequence"

    local kps = {_Type = _type,}
    for _,kp in ipairs(cs.Keypoints) do
        table.insert(kps, module.JSON_FC.EXPORT.SequenceKeypoint(kp, _type.."Keypoint"))
    end
    return kps
end
module.JSON_FC.EXPORT.NumberSequence = function(ns)
    module.JSON_FC.EXPORT.ColorSequence(ns,"NumberSequence")
end
module.JSON_FC.EXPORT.EnumItem = function(ei)
    return string.format("Enum.%s.%s",ei.EnumType,ei.Name)
end
module.JSON_FC.EXPORT.Faces = function(f)
    return {
        _Type = "Faces",
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
        _Type = "NumberRange",
        Min = nr.Min,
        Max = nr.Max
    }
end
module.JSON_FC.EXPORT.UDim = function(ud)
    return {
        _Type = "UDim",
        Scale = ud.Scale,
        Offset = ud.Offset
    }
end
module.JSON_FC.EXPORT.UDim2 = function(ud2)
    return {
        _Type = "UDim2",
        X = module.JSON_FC.EXPORT.UDim(ud2.X),
        Y = module.JSON_FC.EXPORT.UDim(ud2.Y),
    }
end
module.JSON_FC.EXPORT.Vector2 = function(v)
    return {
        _Type = "Vector2",
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

module.JSON_FC.IMPORT.BrickColor = function(bc)
    return BrickColor.new(string.gsub(bc,"(BrickColor) ",""))
end
module.JSON_FC.IMPORT.CFrame = function(cf)
    return CFrame.fromMatrix(
        module.JSON_FC.IMPORT.Vector3(cf.Position),
        module.JSON_FC.IMPORT.Vector3(cf.XVector),
        module.JSON_FC.IMPORT.Vector3(cf.YVector),
        module.JSON_FC.IMPORT.Vector3(cf.ZVector)
    )
end
module.JSON_FC.IMPORT.ColorSequenceKeypoint = function(csk)
    return ColorSequenceKeypoint.new(csk.Time, csk.Color)
end
module.JSON_FC.IMPORT.ColorSequence = function(cs)
    local keypoints = {}
    for i,keypoint in ipairs(cs) do
        ---@diagnostic disable-next-line: redundant-parameter
        keypoints[i] = module.JSON_FC.IMPORT:ColorSequenceKeypoint(keypoint)
    end
    return ColorSequence.new(keypoints)
end
module.JSON_FC.IMPORT.NumberSequenceKeypoint = function(nsk)
    return NumberSequenceKeypoint.new(nsk.Time, nsk.Color)
end
module.JSON_FC.IMPORT.NumberSequence = function(ns)
    local keypoints = {}
    for i,keypoint in ipairs(ns) do
        ---@diagnostic disable-next-line: redundant-parameter
        keypoints[i] = module.JSON_FC.IMPORT:NumberSequenceKeypoint(keypoint)
    end
    return NumberSequence.new(keypoints)
end
module.JSON_FC.IMPORT.EnumItem = function(ei)
    local keys = string.split(ei, ".")
    return Enum[keys[2]][keys[1]]
end
module.JSON_FC.IMPORT.Instance = function(i)
    local instance = Instance.new(i.ClassName)
    for k,v in pairs(i) do
        instance[k] = v
    end
    return instance
end
module.JSON_FC.IMPORT.UDim = function(ud)
    return UDim.new(ud.Scale, ud.Offset)
end
module.JSON_FC.IMPORT.UDim2 = function(ud2)
    return UDim2.new(ud2.X.Scale, ud2.X.Offset, ud2.Y.Scale, ud2.Y.Offset)
end

module.JSON_FC.IMPORT.Vector2 = function(v2)
    return Vector2.new(v2.X, v2.Y)
end

module.JSON_FC.IMPORT.Vector3 = function(v3)
    return Vector3.new(v3.X, v3.Y, v3.Z)
end

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