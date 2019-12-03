SlashCmdList["SLASH_LotusWindow"] = function(flag) end

WINTERSPRING = "Winterspring"
BURNING_STEPPES = "Burning Steppes"
EASTERN_PLAGUELANDS = "Eastern Plaguelands"
SILITHUS = "Silithus"
ALL = "All"

lotuses = {}
lotuses[WINTERSPRING] = { timer = -1, win_open = -1, win_close = -1 }
lotuses[BURNING_STEPPES] = { timer = -1, win_open = -1, win_close = -1 }
lotuses[EASTERN_PLAGUELANDS] = { timer = -1, win_open = -1, win_close = -1 }
lotuses[SILITHUS] = { timer = -1, win_open = -1, win_close = -1 }

SLASH_LotusWindow1 = "/lw"

function SlashCmdList.LotusWindow(args)	
	if pcall(HandleSlashCommands,args) == false then
		print("An error has occurred")
	end
end

function PrintUsage()
	print("Welcome to LotusWindow! Try the following commands:")
	print("/lw all - Prints all timers")
	print("/lw timer - Prints the timer for the current zone")
	print("/lw update - Updates the timer for the current zone to the current time")
	print("/lw set [zone] [time] - Sets the timer for the specified zone. Timer in format of hh:mmPM")
	print("/lw adjust [zone] [min] - Adjust the timer for the specified zone. Time in minutes and can be negative")
	print("/lw broadcast - Broadcasts all timers to the guild and part")
	print("/lw clear [all|zone] - Clears the timer for the specified zone")
end

function HandleSlashCommands(args)
	if args == "all" then
		PrintTimer(BURNING_STEPPES)
		PrintTimer(WINTERSPRING)
		PrintTimer(EASTERN_PLAGUELANDS)
		PrintTimer(SILITHUS)
	elseif args == "timer" then
		local zone = ValidateZone(GetRealZoneText())
		
		if zone then
			PrintTimer(zone)
		else
			print("Could not display timer - You must be in a zone that contains lotuses")
		end		
	elseif args == "update" then
		local zone = ValidateZone(GetRealZoneText())
		
		if zone then
			UpdateZoneTimer(zone)
			SendUpdate(zone)
			PrintTimer(zone)
		else			
			print("Could not update - You must be in a zone that contains lotuses")
		end
	
	elseif string.find(args, "set") then
		local zone, timeStr = ParseSetArgs(args)
		zone = ValidateZone(zone)
		if zone then
			local t = ParseTimerStr(timeStr)
			lotuses[zone] = CreateTimer(t)
			SendUpdate(zone)
			PrintTimer(zone)
		else
			print("Invalid zone")
		end
	elseif string.find(args, "adjust") then
		local zone, m = ParseAdjustArgs(args)
		zone = ValidateZone(zone)
		if zone then
			local t = AddTime(lotuses[zone]["timer"],m)
			lotuses[zone] = CreateTimer(t)
			SendUpdate(zone)
			PrintTimer(zone)
		else
			print("Invalid zone")
		end
	elseif string.find(args, "broadcast") then
		SendUpdate(WINTERSPRING)
		SendUpdate(BURNING_STEPPES)
		SendUpdate(EASTERN_PLAGUELANDS)
		SendUpdate(SILITHUS)
		
		print("Broadcasting timers to all party and guild members")
	elseif string.find(args, "clear") then
		local zone = ParseClearArgs(args)
		zone = ValidateZone(zone)
		if zone then
			if zone == ALL then
				lotuses[WINTERSPRING] = CreateTimer(-1)
				lotuses[BURNING_STEPPES] = CreateTimer(-1)
				lotuses[EASTERN_PLAGUELANDS] = CreateTimer(-1)
				lotuses[SILITHUS] = CreateTimer(-1)
				
				print("Cleared timers for all zones!")
			else
				lotuses[zone] = CreateTimer(-1)
				
				print("Cleared timer for "..zone)
			end
		else
			print("Could not clear zone - The zone must contain lotuses")
		end
	else
		PrintUsage()
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_LOOT")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_LOOT" then
		if string.find(..., "Black Lotus") then
			local zone = GetRealZoneText()
			UpdateZoneTimer(zone)
			SendUpdate(zone)
			PrintTimer(zone)
		end
	elseif event == "ADDON_LOADED" then
		if burning_steppes_t ~= nil then
			lotuses[BURNING_STEPPES] = burning_steppes_t
		end
		if winterspring_t ~= nil then
			lotuses[WINTERSPRING] = winterspring_t
		end
		if eastern_plaguelands_t ~= nil then
			lotuses[EASTERN_PLAGUELANDS] = eastern_plaguelands_t
		end
		if silithus_t ~= nil then
			lotuses[SILITHUS] = silithus_t
		end
	elseif event == "PLAYER_LOGIN" then
		C_ChatInfo.RegisterAddonMessagePrefix("lw")
	elseif event == "PLAYER_LOGOUT" then
		burning_steppes_t = lotuses[BURNING_STEPPES]
		winterspring_t = lotuses[WINTERSPRING]
		eastern_plaguelands_t = lotuses[EASTERN_PLAGUELANDS]
		silithus_t = lotuses[SILITHUS]
	elseif event == "CHAT_MSG_ADDON" then
		local prefix, importStr, _, sender = ...
		if prefix == "lw" then
			local zone,t = ImportTimer(importStr)
			local existingTimer = lotuses[zone]
			local newTimer = CreateTimer(t)
			
			if newTimer["timer"] ~= existingTimer["timer"] then
				lotuses[zone] = newTimer
				print("Lotus timer updated by "..sender)
				PrintTimer(zone)
			end
		end
	end
end)

function MapTimer(t)
	local timer = t["timer"]
	local win_open = t["win_open"]
	local win_close = t["win_close"]
	
	return timer, win_open, win_close
end

function SendUpdate(zone)
	local exportStr = CreateExportString(zone, lotuses[zone]["timer"])
	C_ChatInfo.SendAddonMessage("lw", exportStr, "GUILD")
	C_ChatInfo.SendAddonMessage("lw", exportStr, "PARTY")
end

function UpdateZoneTimer(zone)
	lotuses[zone] = CreateTimer(GetCurrentTime())
end

function CalculateWindow(t)
	if t == -1 then
		return -1, -1
	else 
		return AddTime(t,45), AddTime(t,75)
	end
end

function CreateTimer(timer)
	local win_open, win_close = CalculateWindow(timer)
	
	local t = {}
	t["timer"] = timer
	t["win_open"] = win_open
	t["win_close"] = win_close
	
	return t
end

function PrintTimer(zone)
	local t = lotuses[zone]
	
	if (IsWindowDefined(t)) then
		local timer, win_open, win_close = MapTimer(t)
		
		print(zone.." - Picked: "..DisplayAsTime(timer).." - Opens: "..DisplayAsTime(win_open).." - Closes: "..DisplayAsTime(win_close))
	else 
		print("You don't have the lotus window in "..zone)
	end
end
