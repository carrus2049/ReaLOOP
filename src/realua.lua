local info = debug.getinfo(1,'S');
local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "project.lua")
dofile(script_path .. "tracklist.lua")
-- TODO add is_property to bool value properties
-- ! make strongly oop related stuff first.

-- function open_project(path, in_new_tab=false, make_current_project=true):
--     -- TODO add no prompt
--     local project = reaper.Main_openProject(path)
--     project = Project:new(-1)
--     return project



-- function ReaLuaObject:new()