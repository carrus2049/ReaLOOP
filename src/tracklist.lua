-- Container for a project's track list.

TrackList = {}

function TrackList:new(proj)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    self.__newindex = function(table, key, value)
        rawset(table, key, value)
    end
    local track_count = reaper.CountTracks(proj.id)
    for i=0,track_count-1 do
        local track = reaper.GetTrack(proj.id, i)
        table.insert(obj, Track:new(track))
    end
    obj.proj = proj
    obj.count = track_count

    function obj:delitem(index)
        if index < 1 or index > #self then
            error("Invalid index.")
        else
            reaper.DeleteTrack(self[index].track)
            table.remove(self, index)
            self.count = self.count - 1
        end
    end

    function obj:getitem(index)
        if index < 1 or index > #self then
            error("Invalid index.")
        else
            return self[index]
        end
    end

    function obj:iter()
        local i = 0
        return function ()
            i = i + 1
            if i > #self then
                return nil
            else
                return self[i]
            end
        end
    end

    function obj:len()
        return #self
    end

    return obj
end