local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "Track.lua")


proj = reaper.EnumProjects(-1)
-- local projinst = Project:new(nil, -1)
projname = reaper.GetProjectName(proj)
trkinst = Track:new(1, proj)
