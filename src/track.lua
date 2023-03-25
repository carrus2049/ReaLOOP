local info = debug.getinfo(1,'S');
local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. "item.lua")
dofile(script_path .. "project.lua")
dofile(script_path .. 'fx.lua')

Track = {}
Track.__index = Track
function Track:new(id)
    local self = setmetatable({}, Track)
    
    self._id = id
    
    -- TODO 改为传入ReaLua project.id, 支持通过轨道名获取
    -- if type(id) == "number" then
    --     id = reaper.GetTrack(project.id, id)
    --     if string.sub(id, -18) == "0x0000000000000000" then
    --         error("Track index out of range")
    --     end
    --     self.project=project
        
    --     else if type(id) == "string" and not string.match(id, "^%(MediaTrack%*%)") then
    --         -- id is a track name
    --         name = id
    --         id = project:_get_track_by_name(name).id
    --         if string.sub(id, -18) == "0x0000000000000000" then
    --             error(name .. " not found in project.")
    --         end
    --         self.project = project
    --     end
    -- end

    self.__index = self
    -- reaper.ShowConsoleMsg(tostring(id) .. "\n")
    ret, self._name = reaper.GetTrackName(self._id)
    self._mute = reaper.GetMediaTrackInfo_Value(self._id, "B_MUTE") == 1
    self._solo = reaper.GetMediaTrackInfo_Value(self._id, "I_SOLO") == 2
    self._solo_defeat = reaper.GetMediaTrackInfo_Value(self._id, "B_SOLO_DEFEAT") -- bool
    self._pan = reaper.GetMediaTrackInfo_Value(self._id, "D_PAN")
    self._volume = reaper.GetMediaTrackInfo_Value(self._id, "D_VOL")
    self._height = reaper.GetMediaTrackInfo_Value(self._id, "I_HEIGHTOVERRIDE")
    self._color_native = reaper.GetTrackColor(self._id)
    local r, g, b = reaper.ColorFromNative(self._color_native)
    self._color = {r, g, b}

    self._n_items = reaper.CountTrackMediaItems(self._id)
    self._items = {}
    for i = 0, self._n_items -1 do
        self._items[i+1] = Item:new(reaper.GetTrackMediaItem(self._id, i))
    end
    self._project = Project:new(reaper.GetMediaTrackInfo_Value(self._id, "P_PROJECT"))
    
    

    return self
end

function Track:__newindex(key, value)
    if key == "name" then
        self._name = value
        reaper.GetSetMediaTrackInfo_String(self._id, "P_NAME", value, true)
    elseif key == "mute" then
        self._mute = value
        reaper.SetMediaTrackInfo_Value(self._id, "B_MUTE", value and 1 or 0)
        self._mute = value
    elseif key == "solo" then
        self._solo = value
        reaper.SetMediaTrackInfo_Value(self._id, "I_SOLO", value and 2 or 0)
    elseif key == "solo_defeat" then
        self._solo_defeat = value
        reaper.SetMediaTrackInfo_Value(self._id, "B_SOLO_DEFEAT", value)
    elseif key == "pan" then
        self._pan = value
        reaper.SetMediaTrackInfo_Value(self._id, "D_PAN", value)
    elseif key == "volume" then
        self._volume = value
        reaper.SetMediaTrackInfo_Value(self._id, "D_VOL", value)
    elseif key == "height" then
        self._height = value
        reaper.SetMediaTrackInfo_Value(self._id, "I_HEIGHTOVERRIDE", value)
    elseif key == "color" then
        self._color = value
        self._color_native = reaper.ColorToNative(value[1], value[2], value[3])
        reaper.SetTrackColor(self._id, self._color_native)
    else
        rawset(self, key, value)
    end
end

function Track:add_item(sta_sec, dur_sec, label, color)
    item = Item:new(reaper.AddMediaItemToTrack(self._id))
    item.position = sta_sec
    item.length = dur_sec
    item.notes = label
    item.color = color
    return item
end

function Track:add_midi_item(sta, end, quantize)
    item = Item:new(reaper.AddMediaItemToTrack(self._id, sta, end, quantize))
    item.position = sta_sec
    item.length = dur_sec
    return item
end

function Track:make_only_selected_track()
    reaper.SetOnlyTrackSelected(self._id)
    -- TODO update other tracks' selected status?
end

function Track:add_fx(fx_name)
    reaper.TrackFX_AddByName(self._id, fx_name, false, 0)
    return FX:new(self._id, reaper.TrackFX_GetCount(self._id) - 1)
end

function test_track()
    proj = reaper.EnumProjects(-1)
    -- local projinst = Project:new(nil, -1)
    projname = reaper.GetProjectName(proj)
    trkinst = Track:new(1, proj)
    trkinst.name = 'test1'
    trkinst.mute = false
end


-- test_track()

-- TODO test make_only_selected_track and other tracks selected status
