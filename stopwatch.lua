local stopwatch = {};
local stopwatch_mt = { __index = stopwatch };

local floor, getTime = math.floor, system.getTimer;


local function timeFormat(secs)
	if (secs < 1) then
		return "00:00";
	end
	local mins = "00";
	if (secs > 59) then
		mins = floor(secs / 60);
		secs = secs % 60;
		if (mins < 10) then
			mins = "0"..mins;
		end
	end
	if (secs < 10) then
		secs = "0"..secs;
	end
	return mins..":"..secs;
end


function stopwatch:getElapsedSeconds()
	return floor((getTime() - self.startTime) / 1000);
end

function stopwatch:getTimeToCompletion()
	return floor((self.endTime - getTime()) / 1000);
end

function stopwatch:isElapsed()
	return not self:isRunning();
end

function stopwatch:isRunning()
	if (self.endTime) then
		return self.endTime - getTime() > 0;
	end
	return true;
end

function stopwatch:toElapsedString()
	return timeFormat(self:getElapsedSeconds());
end

function stopwatch:toRemainingString()
	if (self.endTime) then
		return timeFormat(self:getTimeToCompletion());
	end
end

function stopwatch.new(countdown)
	local newTimer = {};
	local startTime = getTime();

	if (countdown) then
		newTimer.endTime = startTime + countdown * 1000;
	end
	newTimer.startTime = startTime;

	return setmetatable(newTimer, stopwatch_mt);
end

stopwatch.format = timeFormat;


return stopwatch;