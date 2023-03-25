local fakeTable = {}
local realTable = {
    gaming = true
}
setmetatable(fakeTable, {
     __newindex = function(table, index, value)
       realTable[index] = value
       print('triggering newindex')
       -- Do what you need to do when current position changes --
    end,
    __index = function(table, index)
        return realTable[index]
    end
})
fakeTable.gamin = false
