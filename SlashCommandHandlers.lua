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
    SendUpdate(zone)
    DisplayTimerForZone(zone)
end

function HandleCmdAdjust(args)
    local zone, minutes = string.match(args, "adjust (%a+%s*%a*) ([%d-]+)")
    zone = ValidateZone(zone)
    timers[zone] = timers[zone] + minutes
    SendUpdate(zone)
    DisplayTimerForZone(zone)
end

function HandleCmdBroadcast(args)
    SendUpdate(WINTERSPRING)
    SendUpdate(BURNING_STEPPES)
    SendUpdate(EASTERN_PLAGUELANDS)
    SendUpdate(SILITHUS)
    
    print("Broadcasting timers to all party and guild members")
end

function HandleCmdClear(args)
    local zone = string.match(args, "clear (%a+%s*%a*)")
    zone = ValidateZone(zone)

    if zone == ALL then
        timers[WINTERSPRING] = nil
        timers[BURNING_STEPPES] = nil
        timers[EASTERN_PLAGUELANDS] = nil
        timers[SILITHUS] = nil

        print("Cleared timers for all zones!")
    else
        timers[zone] = nil

        print("Cleared timer for "..zone)
    end
end