FXParam = {}
FXParam.__index = FXParam

function FXParam:new(id, param_idx)
    local self = setmetatable({}, FXParam)
    self._id = id
    self._param_idx = param_idx
    self._name = reaper.TrackFX_GetParamName(self._id, 0, self._param_idx, "")
    self._value = reaper.TrackFX_GetParam(self._id, 0, self._param_idx)
    return self
end




