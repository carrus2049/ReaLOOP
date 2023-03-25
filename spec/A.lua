path = ({reaper.get_action_context()})[2]:match('^.+[\\//]')
package.path = path .. "B.lua"
print(package.path)
-- Define class A
local A = {}
function A:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    -- Create a B instance in the constructor of A
    o.bInstance = B:new()
    return o
end

function A:sayHelloFromB()
    -- Call the sayHello function of the B instance
    self.bInstance:sayHello()
end
ainst = A:new()
ainst:sayHelloFromB()
return A
