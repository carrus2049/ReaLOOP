Take = {}
Take.__index = Take

function Take:new(id)
    self._id = id
    self._name = reaper.GetTakeName(self._id)
    self._source = reaper.GetMediaItemTake_Source(self._id)
    self._start_offset = reaper.GetMediaItemTakeInfo_Value(self._id, "D_STARTOFFS")
    self._track = reaper.GetMediaItemTake_Track(self._id)
    self._item = reaper.GetMediaItemTake_Item(self._id)
    self._active = reaper.GetMediaItemTakeInfo_Value(self._id, "B_ACTIVE")

    local self = setmetatable({}, Take)
    return self
end

function Take:__newindex(key, value)
end

