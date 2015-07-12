local win = require("win");
local server = require("server");
local timer = require("timer");
local utf8 = require("utf8");
local kb = require("keyboard");
local title = "";
local tid = -1;

events.detect = function ()
	return 
		libs.fs.exists("C:\\Program Files (x86)\\TIDAL") or
		libs.fs.exists("C:\\Program Files\\TIDAL");
end

--@help Focus Tidal application
actions.switch = function()
	if OS_WINDOWS then
		local hwnd = win.window("tidal.exe");
		win.switchtowait("tidal.exe");
	end
end

--@help Launch Tidal application
actions.launch = function()
	if OS_WINDOWS then
		local hwnd = win.window("tidal.exe");
		if (hwnd == 0) then
			os.start("%programfiles(x86)%/TIDAL/TIDAL.exe");
		end
	end
	win.switchtowait("tidal.exe");
end

--@help Update status information
actions.update = function ()
	local hwnd = win.window("tidal.exe");
	local _title = win.title(hwnd);
	if (_title == "") then
		_title = "Tap to launch Tidal";
	elseif (_title == "TIDAL") then
		_title = "Launching Tidal...";
	elseif (_title == "What's New - TIDAL") then
		_title = "Tidal";
	end
	if (_title ~= title) then
		title = _title;
		title = utf8.replace(title, " - TIDAL", "");
		server.update({ id = "info", text = title });
	end
end

events.focus = function ()
	tid = timer.interval(actions.update, 500);
end

events.blur = function ()
	timer.cancel(tid);
end

--@help Lower system volume
actions.volume_down = function()
	kb.press("volumedown");
end

--@help Raise system volume
actions.volume_up = function()
	kb.press("volumeup");
end

--@help Mute system volume
actions.volume_mute = function()
	kb.press("volumemute");
end

--@help Previous track
actions.previous = function()
	kb.press("mediaprevious"); 
end

--@help Next track
actions.next = function()
	kb.press("medianext");
end

--@help Toggle playback state
actions.play_pause = function()
	kb.press("mediaplaypause");
end

--@help Toggle repeat
actions.toggle_repeat = function()
	actions.switch();
	kb.stroke("ctrl", "r");
end

--@help Shuffle repeat
actions.toggle_shuffle = function()
	actions.switch();
	kb.stroke("ctrl", "s");
end