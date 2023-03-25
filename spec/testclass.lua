local MyClass = {}
MyClass.__index = MyClass

function MyClass:new()
    local self = setmetatable({}, MyClass)
    -- self.__index = self
    self._myProperty = "default value"
    return self
end

function MyClass.__newindex(self, key, value)
    if key == "myProperty" then
        print("Property changed to:", value)
        self._myProperty = value
    else
        rawset(self, key, value)
    end
end

local obj = MyClass:new()
print(obj._myProperty) -- prints "default value"
obj.myProperty = "new value" -- prints "Property changed to: new value"
print(obj._myProperty) -- prints "new value"
