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

local function GetMajorVersion(version)
    return string.match(version, "(%d+).")
end

function HandleChatMsgAddon(...)
    local prefix, payload, _, sender = ...

    if string.find(prefix, "lw") then
        local version = string.match(payload, "([%d%.]+):")

        if (displayedUpdateMessage == false) and (version > ADDON_VERSION) then
            displayedUpdateMessage = true
            print("An update for LotusWindow is available")
        end

        if prefix == UPDATE_PREFIX then
            if GetMajorVersion(version) > GetMajorVersion(ADDON_VERSION) then
                print(string.format("Incoming addon message from %s uses an incompatible version of LotusWindow. Please update!", sender))
            else 
                local zone, timer, updated = string.match(payload, "[%d%.]+:(%a+%s*%a*):([%d-_]+):([%d-_]+)")
                timer = timer ~= "_" and timer or nil
                updated = updated ~= "_" and updated or GetDateAsStr()

                if lastUpdated[zone] == nil or updated > lastUpdated[zone] then
                    timers[zone] = timer
                    lastUpdated[zone] = updated

                    DisplayTimerForZone(zone)
                    print("Lotus timer updated by "..sender)
                end
            end
        elseif prefix == REQUEST_PREFIX then
            local zone = string.match(payload, "[%d%.]+:(%a+%s*%a*)")

            SendUpdate(zone)
            print("Update for "..zone.." requested by "..sender)
        end
    end
end