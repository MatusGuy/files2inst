local file = ...

local loaded = fs.read(file, "rbxm")

for _,v in ipairs(loaded:GetChildren()) do
    print(v)
end