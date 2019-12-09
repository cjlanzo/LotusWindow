function HandleCmdTimers()    
    for i = 1, #VALID_ZONES do
        if VALID_ZONES[i] ~= ALL then
            DisplayTimerForZone(VALID_ZONES[i])
        end
    end
end

function HandleCmdUpdate(args)
    local zone = nil
    local timer = nil

    if args == "update" then
        zone = ValidateZone(GetRealZoneText())
        timer = CalculateTimer(GetGameTime())
    else 
        local z, timeStr = string.match(args, "update (%a+%s*%a*) (%d+:%d+%a+)")
        local hours, minutes, ampm = string.match(timeStr, "(%d+):(%d+)(%a+)")

        hours = tonumber(hours)
        minutes = tonumber(minutes)

        if hours == 12 then
            hours = 0
        end

        if string.upper(ampm) == "PM" then
            hours = hours + 12
        end

        zone = ValidateZone(z)
        timer = CalculateTimer(hours,minutes)
    end

    UpdateTimerForZone(zone, timer)
    SendUpdate(UPDATE_PREFIX, zone)
    DisplayTimerForZone(zone)
end

function HandleCmdAdjust(args)
    local zone, minutes = string.match(args, "adjust (%a+%s*%a*) ([%d-]+)")
    zone = ValidateZone(zone)
    UpdateTimerForZone(zone, (timers[zone] + minutes))
    SendUpdate(UPDATE_PREFIX, zone)
    DisplayTimerForZone(zone)
end

function HandleCmdClear(args)
    local zone = string.match(args, "clear (%a+%s*%a*)")
    zone = ValidateZone(zone)

    if zone == ALL then
        UpdateTimerForZone(WINTERSPRING, nil)
        UpdateTimerForZone(BURNING_STEPPES, nil)
        UpdateTimerForZone(EASTERN_PLAGUELANDS, nil)
        UpdateTimerForZone(SILITHUS, nil)

        print("Cleared timers for all zones!")
    else
        UpdateTimerForZone(zone, nil)

        print("Cleared timer for "..zone)
    end
end

function HandleCmdBroadcast(args)
    SendUpdate(UPDATE_PREFIX, WINTERSPRING)
    SendUpdate(UPDATE_PREFIX, BURNING_STEPPES)
    SendUpdate(UPDATE_PREFIX, EASTERN_PLAGUELANDS)
    SendUpdate(UPDATE_PREFIX, SILITHUS)
    
    print("Broadcasting timers to all party and guild members")
end

function HandleCmdRequest(args)
    local zone = string.match(args, "request (%a+%s*%a*)")
    zone = ValidateZone(zone)

    if zone == ALL then
        SendRequest(WINTERSPRING)
        SendRequest(BURNING_STEPPES)
        SendRequest(EASTERN_PLAGUELANDS)
        SendRequest(SILITHUS)

        print("Requesting all timers from guild/party")
    else
        SendRequest(zone)

        print("Requesting timer for "..zone.." from guild/party")
    end
end

function HandleCmdVersion()
    print(string.format("LW Version: %s", ADDON_VERSION))
end