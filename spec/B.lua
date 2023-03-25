local B = {}
function B:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function B:sayHello()
    print("Hello from B!")
end
return B