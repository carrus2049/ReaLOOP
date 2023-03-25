function get_parent_directory(filepath)
    local path_sep = package.config:sub(1,1) -- get the path separator for the current platform
    local parent_dir = filepath:match("(.*".. path_sep ..")") -- match the parent directory path
    return parent_dir
end

local function compare(a, b)
    return a < b
end

local info = debug.getinfo(1,'S');
script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
script_parent_path = get_parent_directory(script_path)
dofile(script_path .. "/lib/json.lua")

testjsonfp = '/Users/carrus/Documents/Data/krakenote_data/mirannot/pl_3957557/output/06A511AAB8C0DAEBF5E70E8A3C7DFB84/track_item/style_discogs_effnet_top5.json'
local file = io.open(testjsonfp, "r")
local json_data = file:read("*all")
file:close()

local data = json.parse(json_data)
local data_sort = {}
for key, value in pairs(data) do
    data_sort[tonumber(key)] = value
end

for i = 1, #data_sort do
    local item = data_sort[i]
    print(i, item['color'][0], item['sta_beat'])
end
testi = 1