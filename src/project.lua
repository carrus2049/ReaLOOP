local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "track.lua")
dofile(script_path .. "tracklist.lua")

Project = {}
Project.__index = Project
function Project:new(index)
    local self = setmetatable({}, Project)

    id, proj_fp = reaper.EnumProjects(index)

    self._id = id
    -- self.__index = self
    self._proj_fp = proj_fp
    self._proj_dir = proj_fp:match('(.*[/\\\\])')

    self._name = reaper.GetProjectName(self._id, "")
    -- self._path = reaper.GetProjectPath()
    self._length = reaper.GetProjectLength(self._id)
    self._n_tracks = reaper.CountTracks(self._id)
    
    -- TODO use Tracklist object
    self._tracks = {}
    for i = 0, self._n_tracks -1 do
        -- reaper.ShowConsoleMsg(tostring(i)..'\n')
        trackinst = Track:new(i, self._id)
        self._tracks[i+1] = Track:new(i, self._id)
    end
    
    return self
end

function Project:add_track(idx, name, height)
    height = height or 40
    local index = math.max(-self._n_tracks, math.min(idx, self._n_tracks))
    if index < 0 then
        -- index = index % self._n_tracks
        index = self._n_tracks
    end
    -- reaper.ShowConsoleMsg(tostring(index) .. name .. '\n')
    reaper.InsertTrackAtIndex(index, true)
    local trackinst = reaper.GetTrack(self._id, index)

    -- update n_tracks
    self._n_tracks = reaper.CountTracks(self._id)
    track = Track:new(trackinst)
    track.name = name
    track.height = height
    return track
end
    


function test_project()
    proj = reaper.EnumProjects(-1)
    -- local projinst = Project:new(nil, -1)
    -- projname = reaper.GetProjectName(proj)
    -- trkinst = Track:new(1, proj)
    projinst = Project:new(-1)
   -- reaper.ShowConsoleMsg(projinst.name)
end
test_project()
