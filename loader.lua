local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/fisiaque/BayaForRobloxTest/'..readfile('BayaUI/profiles/commit.txt')..'/'..select(1, path:gsub('BayaUI/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after baya updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after baya updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'BayaUI', 'BayaUI/games', 'BayaUI/profiles', 'BayaUI/assets', 'BayaUI/libraries', 'BayaUI/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.BayaDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/fisiaque/BayaForRobloxTest')
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('BayaUI/profiles/commit.txt') and readfile('BayaUI/profiles/commit.txt') or '') ~= commit then
		wipeFolder('BayaUI')
		wipeFolder('BayaUI/games')
		wipeFolder('BayaUI/guis')
		wipeFolder('BayaUI/libraries')
	end
	writefile('BayaUI/profiles/commit.txt', commit)
end

return loadstring(downloadFile('BayaUI/main.lua'), 'main')()