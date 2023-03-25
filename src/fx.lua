FX = {}
FX.__index = FX

function FX:new(id)
    local self = setmetatable({}, FX)
    self._id = id
    self._name = reaper.TrackFX_GetFXName(self._id, 0, "")
    self._n_params = reaper.TrackFX_GetNumParams(self._id, 0)
    self._params = {}
    for i = 0, self._n_params -1 do
        self._params[i+1] = reaper.TrackFX_GetParam(self._id, 0, i)
    end
    return self
end

function FX:__newindex(key, value)
    if key == "name" then
        self._name = value
        reaper.TrackFX_SetFXName(self._id, 0, value)
    elseif key == "enabled" then
        self._enabled = value
        reaper.TrackFX_SetEnabled(self._id, 0, value)
    elseif key == "bypass" then
        self._bypass = value
        reaper.TrackFX_SetEnabled(self._id, 0, not value)
    -- elseif key == "params" then
    --     for i = 1, self._n_params do
    --         reaper.TrackFX_SetParam(self._id, 0, i-1, value[i])
    --     end
    -- elseif key == "param" then
    --     reaper.TrackFX_SetParam(self._id, 0, value[1], value[2])
    end
end