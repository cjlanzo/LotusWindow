local function ConvertTimerToDisplay(timer)
	local hours = math.floor(timer / MINUTES_IN_AN_HOUR)
	local minutes = timer % MINUTES_IN_AN_HOUR
	local ampm = (hours >= 12 and "PM" or "AM")

	if hours >= 12 then
		hours = hours - 12
	end
	if hours == 0 then
		hours = 12
	end

	return string.format("%d:%02d%s", hours, minutes, ampm)
end

function DisplayTimerForZone(zone)
	if timers[zone] ~= nil then

		local timer = timers[zone]
		local open = nil
		local close = nil

		if cache[timer] ~= nil then
			open = cache[timer][1]
			close = cache[timer][2]
		else
			open = (timer + 45) % MINUTES_IN_A_DAY
			close = (timer + 75) % MINUTES_IN_A_DAY

			cache[timer] = { open, close }
		end

		print(zone.." - Picked: "..ConvertTimerToDisplay(timer).." - Opens: "..ConvertTimerToDisplay(open).." - Closes: "..ConvertTimerToDisplay(close))
	else
		print("You do not have the timer for "..zone)
	end
end

function ValidateZone(zone)
	for i = 1, #VALID_ZONES do
		if string.upper(zone) == string.upper(VALID_ZONES[i]) then
			return VALID_ZONES[i]
		end
	end

	print(zone.." is not a valid zone")
	return nil
end

function CalculateTimer(hours, minutes)
	return (hours * 60) + minutes
end

function GetDateAsStr()
	return date("%y-%m-%d-%H-%M-%S")
end

function UpdateTimerForZone(zone, timer)
	local date = GetDateAsStr()

	timers[zone] = timer
	lastUpdated[zone] = date
end

function SendUpdate(prefix, zone)
	local timer = timers[zone] ~= nil and timers[zone] or "_"
	local lastUpdated = lastUpdated[zone] ~= nil and lastUpdated[zone] or "_"
	local exportStr = string.format("%s:%s:%d:%s", ADDON_VERSION, zone, timer, lastUpdated)
	
	C_ChatInfo.SendAddonMessage(prefix, exportStr, "GUILD")
	C_ChatInfo.SendAddonMessage(prefix, exportStr, "PARTY")
end

function SendRequest(zone)
	local requestStr = string.format("%s:%s", ADDON_VERSION, zone)

	C_ChatInfo.SendAddonMessage(REQUEST_PREFIX, requestStr, "GUILD")
	C_ChatInfo.SendAddonMessage(REQUEST_PREFIX, requestStr, "PARTY")
end