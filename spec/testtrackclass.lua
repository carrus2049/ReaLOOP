local Track = {}
Track.__index = Track

function Track:new()
    local self = setmetatable({}, Track)
    self.name = 'default value'
    print(self.name)
    return self
end

function Track.__newindex(self, key, value)
    if key == "name" then
        print('name changed to:', value)
        self._name = value
    else
        rawset(self, key, value)
    end
end
trkinst = Track:new()
trkinst.name = 'test'
print(trkinst._name)