local info = debug.getinfo(1,'S');
local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "take.lua")
dofile(script_path .. "track.lua")
dofile(script_path .. "project.lua")
Item = {}
Item.__index = Item
function Item:new(id)
    self._id = id
    -- TODO what if the track instance is already accessed from elsewhere?
    self._track = Track:new(reaper.GetMediaItem_Track(self._id))
    self._project = self._track.project
    
    -- self._project = self._track.project
    self._position = reaper.GetMediaItemInfo_Value(self._id, "D_POSITION")
    self._length = reaper.GetMediaItemInfo_Value(self._id, "D_LENGTH")
    self._end_position = self._position + self._length
    self._sta_beat = reaper.TimeMap2_timeToQN(self._project._id, self._position)
    self._end_beat = reaper.TimeMap2_timeToQN(self._project._id, self._position + self._length)
    local color_native = tonumber(reaper.GetMediaItemInfo_Value(self._id, "I_CUSTOMCOLOR"))
    self._color = reaper.ColorFromNative(color_native)
    self._notes = reaper.GetSetMediaItemInfo_String(self._id, 'P_NOTES', "", false)
    self._locked = reaper.GetMediaItemInfo_Value(self._id, 'C_LOCK')
    self._beat_attach_mode = reaper.GetMediaItemInfo_Value(self._id, "C_BEATATTACHMODE")
    self._takes = {}
    for i = 0, reaper.CountTakes(self._id) - 1 do
        self._takes[i] = Take:new(reaper.GetTake(self._id, i))
        if self._takes[i].active then
            self._active_take = self._takes[i]
        end
    end
    local self = setmetatable({}, Item)
    return self
end

function Item:__newindex(key, value)
    if key == "position" then
        self._position = value
        reaper.SetMediaItemPosition(self._id, value, false)
    elseif key == "length" then
        self._length = value
        reaper.SetMediaItemLength(self._id, value, true)
    elseif key == "color" then
        self._color = value
        local r, g, b = tonumber(value[1]), tonumber(value[2]), tonumber(value[3])
        local color2native = reaper.ColorToNative(r, g, b)|0x1000000
        reaper.SetMediaItemInfo_Value(self._id, "I_CUSTOMCOLOR", color2native)
    elseif key == "notes" then
        self._notes = value
        reaper.GetSetMediaItemInfo_String(self._id, "P_NOTES", value, true)
    elseif key == 'locked' then
        self._locked = value
        reaper.SetMediaItemInfo_Value(self._id, "C_LOCK", value)
    elseif key == 'beat_attach_mode' then
        self._beat_attach_mode = value
        reaper.SetMediaItemInfo_Value(self._id, "C_BEATATTACHMODE", value)
    elseif key == 'active_take' then
        self._active_take = value
        reaper.SetActiveTake(self._id, value)
    end
    reaper.UpdateItemInProject(self._id)
end

function Item:add_take()
    take_id = reaper.AddTakeToMediaItem(self._id)
    take = Take:new(take_id)
    return take
-- proj = reaper.EnumProjects(-1)
-- track = reaper.GetTrack(proj, 0)
-- item = reaper.AddMediaItemToTrack(track)
-- reaper.SetMediaItemPosition(item, 1, true)
-- reaper.SetMediaItemLength(item, 2, true)
-- i = Item:new(item)
-- reaper.ShowConsoleMsg(i._position .. '\n')
-- testi = 1


