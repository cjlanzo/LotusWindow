function ParseSetArgs(args)
	return string.match(args, "set (%a+%s*%a*) (%d+:%d+%a+)")
end

function ParseAdjustArgs(args)
	return string.match(args, "adjust (%a+%s*%a*) ([%d-]+)")
end

function ParseClearArgs(args)
	return string.match(args, "clear (%a+%s*%a*)")
end

function ParseTimerStr(str)
	local h,m,q = string.match(str, "(%d+):(%d+)(%a+)")
	
	local t = (h*100) + m
	
	if (t >= 1200) then
		t = t - 1200
	end
	
	if (string.upper(q) == "PM") then
		t = t + 1200
	end
	
	return t
end

function DisplayAsTime(t)
	local t_m = math.fmod(t,100)
	local t_h = t - t_m
	local ampm = "AM"
	
	if t_h >= 1200 then
		if (t_h < 2400) then
			ampm = "PM"
		end
		
		t_h = t_h - 1200
	end
	
	if t_h < 100 then
		t_h = t_h + 1200
	end
	
	t_h = t_h / 100
	
	return string.format("%d:%02d%s", t_h, t_m, ampm)
end

function AddTime(t,m)
	local t_m = math.fmod(t,100)
	
	if t_m + m >= 60 then
		t = t + m + 40
		
		t_m = math.fmod(t,100)
		
		if t_m >= 60 then
			t = t + 40
		end
	else
		t = t + m
	end
	
	return t
end

function CreateExportString(zone,t)
	return string.format("%s:%d", zone, t)
end

function ImportTimer(importStr)
	local zone, timer = string.match(importStr, "(%a+%s*%a*):([%d-]+)")
	return zone, tonumber(timer)
end

function GetCurrentTime()
	local h,m = GetGameTime()
	
	return (h*100) + m
end

function ValidateZone(zone)
	local upper_zone = string.upper(zone)
	
	if (upper_zone == string.upper(BURNING_STEPPES)) then
		return BURNING_STEPPES
	elseif (upper_zone == string.upper(WINTERSPRING)) then
		return WINTERSPRING
	elseif (upper_zone == string.upper(EASTERN_PLAGUELANDS)) then
		return EASTERN_PLAGUELANDS
	elseif (upper_zone == string.upper(SILITHUS)) then
		return SILITHUS
	elseif (upper_zone == string.upper(ALL)) then
		return ALL
	else
		return false
	end
end

function IsWindowDefined(t)
	if t["timer"] == -1 then
		return false
	else
		return true
	end
end