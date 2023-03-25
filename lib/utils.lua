function getOS()
	-- ask LuaJIT first
	if jit then
		return jit.os
	end

	-- Unix, Linux variants
	local fh,err = assert(io.popen("uname -o 2>/dev/null","r"))
	if fh then
		osname = fh:read()
	end

	return osname or "Windows"
end

function get_filename_without_ext(full_path)
    local filename = string.match(full_path, "[^/\\\\]*$")
    return string.gsub(filename, "%..+$", "")
end

function get_folder_filelist(folder_path)
    t = {}
    local os = ""
    os = getOS()
    if os == "Windows" then
        local i, popen = 0, io.popen
        -- local pfile = popen('dir "'..folder_path..'" /b /ad')
        local pfile = popen('WHERE "'.. folder_path ..'\\:*.*"')
        -- local pfile = popen('ls -a "'..directory..'"')
        for filename in pfile:lines() do
            i = i + 1
            t[i] = filename
        end
        pfile:close()
    else
        for file in io.popen("cd " .. folder_path .. ' && find "$(pwd -P)" -type f | grep .json'):lines() do
            table.insert(t, file)
        end
    end
    return t


end

-- get_folder_filelist('C:\\Users\\wanji\\Downloads\\0A2BC507F12901BF98D45EDBA9A37FAA\\track_item')