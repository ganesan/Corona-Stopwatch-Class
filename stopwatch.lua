--------
-- Stopwatch Class v1.0
--
-- by Kyle Coburn
-- 9 March 2012
----
-- For the latest updates & support/feedback:
-- http://developer.anscamobile.com/code/stopwatch-timing-class
----
-- Usage:
-- local stopwatch = require "stopwatch"
--
-- stopwatch.new() --Counts up indefinitely
-- stopwatch.new( 60 ) --Counts down from 60 seconds
--------

local stopwatch = {}
local stopwatch_mt = { __index = stopwatch }

local floor, getTime = math.floor, system.getTimer


local function timeFormat(secs)
	if (secs < 1) then
		return "00:00"
	end
	local mins = "00"
	if (secs > 59) then
		mins = floor(secs / 60)
		secs = secs % 60
		if (mins < 10) then
			mins = "0"..mins
		end
	end
	if (secs < 10) then
		secs = "0"..secs
	end
	return mins..":"..secs
end


function stopwatch:getElapsed()
	if (self.pauseStart) then
		return self.pauseStart - self.startTime
	end
	return getTime() - self.startTime
end

function stopwatch:getElapsedSeconds()
	return floor(self:getElapsed() / 1000)
end

function stopwatch:getRemaining()
	if (self.pauseStart) then
		return self.endTime - self.pauseStart
	end
	return self.endTime - getTime()
end

function stopwatch:getRemainingSeconds()
	return floor(self:getRemaining() / 1000)
end

function stopwatch:isElapsed()
	return self.endTime and self.endTime - getTime() <= 0
end

function stopwatch:isPaused()
	return self.pauseStart ~= nil
end

function stopwatch:pause()
	if (not self:isPaused()) then
		self.pauseStart = getTime()
	end
end

function stopwatch:resume()
	if (self:isPaused()) then
		print("Paused for:", getTime() - self.pauseStart)
		if (self.endTime) then
			self.endTime = self.endTime + (getTime() - self.pauseStart)
		else
			self.startTime = self.startTime + (getTime() - self.pauseStart)
		end
		self.pauseStart = nil
	end
end

function stopwatch:toElapsedString()
	return timeFormat(self:getElapsedSeconds())
end

function stopwatch:toRemainingString()
	if (not self.endTime) then
		return "00:00"
	end
	return timeFormat(self:getRemainingSeconds())
end


function stopwatch.new(countdown)
	local newTimer = {}
	local startTime = getTime()

	if (countdown) then
		newTimer.endTime = startTime + countdown * 1000
	end
	newTimer.startTime = startTime

	return setmetatable(newTimer, stopwatch_mt)
end

stopwatch.format = timeFormat


return stopwatch