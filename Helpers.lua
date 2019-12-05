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

		print(zone.." - Picked "..ConvertTimerToDisplay(timer).." - Opens "..ConvertTimerToDisplay(open).." - Closes "..ConvertTimerToDisplay(close))
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

function UpdateTimerForZone(zone, timer)
	local date = date("%y-%m-%d-%H-%M-%S")

	timers[zone] = timer
	lastUpdated[zone] = date
end

function SendUpdate(zone)
	local exportStr = string.format("%s:%s:%d:%s", ADDON_VERSION, zone, timers[zone], lastUpdated[zone])
	
	C_ChatInfo.SendAddonMessage(MAIN_PREFIX, exportStr, "GUILD")
	C_ChatInfo.SendAddonMessage(MAIN_PREFIX, exportStr, "PARTY")
end

function SendRequest(zone)
	local requestStr = string.format("%s:%s", ADDON_VERSION, zone)

	C_ChatInfo.SendAddonMessage(REQUEST_PREFIX, requestStr, "GUILD")
	C_ChatInfo.SendAddonMessage(REQUEST_PREFIX, requestStr, "PARTY")
end

function IsMoreRecent(date1, date2)

	local function CompareDate(date1, date2)
		if #date1 ~= #date2 then
			return false
		end
		if #date1 == 0 then 
			return false
		end
		
		local val1 = tonumber(string.sub(date1, 1, 2))
		local val2 = tonumber(string.sub(date2, 1, 2))

		if val1 > val2 then
			return true
		elseif val2 > val1 then
			return false
		else
			if #date1 < 4 then
				return false
			end

			local rem1 = string.sub(date1, 4, #date1)
			local rem2 = string.sub(date2, 4, #date2)

			return CompareDate(rem1, rem2)
		end

	end
	
	return CompareDate(date1, date2)
end