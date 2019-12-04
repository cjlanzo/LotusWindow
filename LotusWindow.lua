SlashCmdList["SLASH_LotusWindow"] = function(flag) end

SLASH_LotusWindow1 = "/lw"

local function PrintUsage()
	print("Welcome to LotusWindow! Try the following commands:")
	print("/lw timers - Prints all timers")
	print("/lw update [zone] [time] - Updates timer for the specified zone. Time in format of hh:mmPM")
	print("/lw adjust [zone] [min] - Adjust the timer for the specified zone. Time in minutes and can be negative")
	print("/lw clear [all|zone] - Clears the timer for the specified zone")
	print("/lw broadcast - Broadcasts all timers to the guild and party")
end

local function HandleSlashCommands(args)
	if args == "timers" then
		HandleCmdTimers()
	elseif string.find(args, "update") then
		HandleCmdUpdate(args)
	elseif string.find(args, "adjust") then
		HandleCmdAdjust(args)
	elseif string.find(args, "broadcast") then
		HandleCmdBroadcast(args)
	elseif string.find(args, "clear") then
		HandleCmdClear(args)
	else
		PrintUsage()
	end
end

function SlashCmdList.LotusWindow(args)	
	if pcall(HandleSlashCommands, args) == false then
	end
end

local function HandleEvents(self, event, ...)
	if event == "PLAYER_LOGIN" then
		HandlePlayerLogin()
	elseif event == "CHAT_MSG_LOOT" then
		HandleChatMsgLoot(...)
	elseif event == "CHAT_MSG_ADDON" then
        HandleChatMsgAddon(...)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("CHAT_MSG_LOOT")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", HandleEvents)