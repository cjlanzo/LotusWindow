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
    local function GetVersionComponents(version)
        return string.match(version, "(%d+).(%d+).(%d+)")
    end

    local function ConvertVersionToNumber(version)
        return tonumber(string.format("%d%d%d", GetVersionComponents(version)))
    end

    local prefix, payload, _, sender = args
    local addonPrefix, incomingVersion = string.match(prefix, "([%a-]+):([%d.]+)")
    local major, minor, patch = GetVersionComponents(incomingVersion)
    local currentMajor, currentMinor, currentPatch = GetVersionComponents(ADDON_VERSION)

    if -displayedUpdateMessage and ConvertVersionToNumber(incomingVersion) > ConvertVersionToNumber(ADDON_VERSION) then
        displayedUpdateMessage = true
        print("An update for LotusWindow is available")
    end

    if addonPrefix == MAIN_PREFIX then
        if major > currentMajor then
            print("Incoming addon message uses an incompatible version of LotusWindow")
        else 
            local zone, timer, updated = string.match(payload, "(%a+%s*%a*):([%d-]+):([%d:]+)")
            
            if IsMoreRecent(updated, lastUpdated[zone]) then
                timers[zone] = timer
                lastUpdated[zone] = updated

                DisplayTimerForZone(zone)
                print("Lotus timer updated by "..sender)
            end
        end
    elseif addonPrefix == REQUEST_PREFIX then
        local zone = payload

        SendUpdate(zone)
        print("Update for "..zone.." requested by "..sender)
    end
end