repeat task.wait() until game:IsLoaded()
if shared.baya then shared.baya:Uninject() end

-- why do exploits fail to implement anything correctly? Is it really that hard?
if identifyexecutor then
	if table.find({'Argon', 'Wave'}, ({identifyexecutor()})[1]) then
		getgenv().setthreadidentity = nil
	end
end

local baya
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and baya then
		baya:CreateNotification('Baya', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))

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

local function finishLoading()
	baya.Init = nil
	baya:Load()
	task.spawn(function()
		repeat
			baya:Save()
			task.wait(10)
		until not baya.Loaded
	end)

	local teleportedServers
	baya:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
		if (not teleportedServers) and (not shared.BayaIndependent) then
			teleportedServers = true
			local teleportScript = [[
				shared.bayareload = true
				if shared.BayaDeveloper then
					loadstring(readfile('BayaUI/loader.lua'), 'loader')()
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/fisiaque/BayaForRobloxTest/'..readfile('BayaUI/profiles/commit.txt')..'/loader.lua', true), 'loader')()
				end
			]]
			if shared.BayaDeveloper then
				teleportScript = 'shared.BayaDeveloper = true\n'..teleportScript
			end
			if shared.BayaCustomProfile then
				teleportScript = 'shared.BayaCustomProfile = "'..shared.BayaCustomProfile..'"\n'..teleportScript
			end
			baya:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.bayareload then
		if not baya.Categories then return end
		if baya.Categories.Main.Options['GUI bind indicator'].Enabled then
			baya:CreateNotification('Finished Loading', baya.BayaButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(baya.Keybind, ' + '):upper()..' to open GUI', 5)
		end
	end
end

if not isfile('BayaUI/profiles/gui.txt') then
	writefile('BayaUI/profiles/gui.txt', 'new')
end
local gui = readfile('BayaUI/profiles/gui.txt')

if not isfolder('BayaUI/assets/'..gui) then
	makefolder('BayaUI/assets/'..gui)
end
baya = loadstring(downloadFile('BayaUI/guis/'..gui..'.lua'), 'gui')()
shared.baya = baya

if not shared.BayaIndependent then
	loadstring(downloadFile('BayaUI/games/universal.lua'), 'universal')()
	if isfile('BayaUI/games/'..game.PlaceId..'.lua') then
		loadstring(readfile('BayaUI/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
	else
		if not shared.BayaDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/fisiaque/BayaForRobloxTest/'..readfile('BayaUI/profiles/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				loadstring(downloadFile('BayaUI/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
			end
		end
	end
	finishLoading()
else
	baya.Init = finishLoading
	return baya
end