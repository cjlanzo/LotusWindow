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
    local prefix, payload, _, sender = args
    local addonPrefix, version = string.match(prefix, "([%a-]+):([%d.]+)")
    local major, minor, patch = string.match(version, "(%d+).(%d+).(%d+)")
    local currentMajor, currentMinor, currentPatch = string.match(ADDON_VERSION, "(%d+).(%d+).(%d+)")

    if major > currentMajor then
        print("Incoming addon message uses an incompatible version of LotusWindow")
    else 
        if minor > currentMinor then
            print("An update for LotusWindow is available")
        end

        if addonPrefix == MAIN_PREFIX then
            local zone, timer, updated = string.match(payload, "(%a+%s*%a*):([%d-]+):(%d+)")
            
            if updated > lastUpdated[zone] then
                timers[zone] = timer
                lastUpdated[zone] = updated
    
                DisplayTimerForZone(zone)
                print("Lotus timer updated by "..sender)
            end
        elseif addonPrefix == REQUEST_PREFIX then
            local zone = payload

            SendUpdate(zone)
            print("Update for "..zone.." requested by "..sender)
        end
    end
end