function HandlePlayerLogin()
    for i = 1, #ADDON_PREFIXES do
        C_ChatInfo.RegisterAddonMessagePrefix(ADDON_PREFIXES[i])
    end
end

function HandleChatMsgLoot(args)
    if string.find(args, "Black Lotus") then
        local zone = GetRealZoneText()
        local timer = CalculateTimer(GetGameTime())

        UpdateTimerForZone(zone, timer)
        SendUpdate(zone)
        DisplayTimerForZone(zone)
    end
end

function HandleChatMsgAddon(args)
    local prefix, importStr, _, sender = args
    if prefix == MAIN_PREFIX then
        local zone, timer = string.match(importStr, "(%a+%s*%a*):([%d-]+)")
        
        if timers[zone] ~= timer then
            timers[zone] = timer

            DisplayTimerForZone(zone)
            print("Lotus timer updated by "..sender)
        end
    end
end