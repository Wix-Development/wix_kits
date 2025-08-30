exports['wix_core']:UpdateChecker(GetResourceMetadata(GetCurrentResourceName(), 'version', 0))

if Config.AutoSQL == true then
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        exports['wix_core']:Debug('RESOURCES', 'AutoSQL enabled, creating database table if not exists.')
        exports.oxmysql:execute([[CREATE TABLE IF NOT EXISTS wix_kits (
            identifier VARCHAR(64) PRIMARY KEY,
            data VARCHAR(64)
        )]])
    end)
end

local function GetKitData(identifier)
    exports['wix_core']:Debug('RESOURCES', 'Getting data... Identifier: ' .. identifier)
    local result = exports.oxmysql:executeSync('SELECT data FROM wix_kits WHERE identifier = ?', {identifier})
    if result and result[1] then
        local decoded = json.decode(result[1].data) or {}
        exports['wix_core']:Debug('RESOURCES', 'Data successfully retrieved. Data: '.. json.encode(decoded))
        return decoded
    end
    return {}
end

local function SaveKitData(identifier, data)
    local encoded = json.encode(data)
    exports['wix_core']:Debug('RESOURCES', 'Saving data... Identifier: ' .. identifier .. ', Data: ' .. json.encode(data))
    exports.oxmysql:execute('INSERT INTO wix_kits (identifier, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = ?',
        {identifier, encoded, encoded})
end

local function GetUserIdentifier(source)
    exports['wix_core']:Debug('RESOURCES', 'Getting user identifier for source: ' .. source)
    local identifiers = GetPlayerIdentifiers(source)
    exports['wix_core']:Debug('RESOURCES', 'Found identifiers: ' .. json.encode(identifiers))

    for _, identifier in pairs(identifiers) do
        exports['wix_core']:Debug('RESOURCES', 'Checking identifier: ' .. identifier .. ' against type: ' .. Config.UserIdentifier)
        if string.match(identifier, Config.UserIdentifier .. ':') then
            exports['wix_core']:Debug('RESOURCES', 'Found matching identifier: ' .. identifier)
            return identifier
        end
    end
    exports['wix_core']:Debug('RESOURCES', 'No matching identifier found for type: ' .. Config.UserIdentifier)
    return nil
end

function hasAllowedIdentifier(identifiers, allowedIdentifiers)
    exports['wix_core']:Debug('RESOURCES', 'Checking identifiers against allowed list (Uncomment line 50, 51 and 55 to see details)')
    --exports['wix_core']:Debug('RESOURCES', 'Player identifiers: ' .. json.encode(identifiers))
    --exports['wix_core']:Debug('RESOURCES', 'Allowed identifiers: ' .. json.encode(allowedIdentifiers))

    for _, identifier in ipairs(identifiers) do
        for _, allowedIdentifier in ipairs(allowedIdentifiers) do
            --exports['wix_core']:Debug('RESOURCES', 'Comparing ' .. identifier .. ' with ' .. allowedIdentifier)
            if identifier == allowedIdentifier then
                exports['wix_core']:Debug('RESOURCES', 'Found matching identifier: ' .. identifier)
                return true
            end
        end
    end
    exports['wix_core']:Debug('RESOURCES', 'No matching identifiers found')
    return false
end

local function Locale(key, ...)
    return string.format(Config.Locales[key] or key, ...)
end

RegisterServerEvent('wix_kits:requestKit')
AddEventHandler('wix_kits:requestKit', function(kitName)
    local source = source
    exports['wix_core']:Debug('RESOURCES', 'Kit requested by source: ' .. source .. ', Kit: ' .. kitName)

    local kit = Config.Kits[kitName]
    local identifiers = GetPlayerIdentifiers(source)
    local identifier = GetUserIdentifier(source)

    if not identifier then
        exports['wix_core']:Debug('RESOURCES', 'No valid identifier found for source: ' .. source)
        exports['wix_core']:Notify(source, Locale('kits'), Locale('kit_invalid_identifier'), 'error')
        return
    end

    if not kit then
        exports['wix_core']:Debug('RESOURCES', 'Kit not found: ' .. kitName)
        exports['wix_core']:Notify(source, Locale('kits'), Locale('kit_not_found'), 'error')
        return
    end

    if Config.AllowedIdentifiers[kitName] then
        exports['wix_core']:Debug('RESOURCES', 'Checking allowed identifiers for kit: ' .. kitName)
        if not hasAllowedIdentifier(identifiers, Config.AllowedIdentifiers[kitName]) then
            exports['wix_core']:Debug('RESOURCES', 'Access denied for kit: ' .. kitName)
            exports['wix_core']:Notify(source, Locale('kits'), Locale('kit_no_permission'), 'error')
            return
        end
        exports['wix_core']:Debug('RESOURCES', 'Access granted for kit: ' .. kitName)
    end

    local kitData = GetKitData(identifier)
    local currentTime = os.time()

    if kitData[kitName] and kitData[kitName] > currentTime then
        local remaining = kitData[kitName] - currentTime
        exports['wix_core']:Debug('RESOURCES', 'Kit on cooldown. Remaining time: ' .. remaining)
        exports['wix_core']:Notify(source, Locale('kits'), Locale('kit_on_cooldown', remaining), 'info')
        return
    end

    exports['wix_core']:Debug('RESOURCES', 'Giving kit items to player. Kit: ' .. kitName)
    for _, item in pairs(kit.items) do
        exports['wix_core']:Debug('RESOURCES', 'Adding item: ' .. item.name .. ' x' .. item.amount)
        exports['wix_core']:AddItem(source, item.name, item.amount)
    end

    if kit.money then
        for _, money in pairs(kit.money) do
            exports['wix_core']:Debug('RESOURCES', 'Adding money: ' .. money.account .. ' $' .. money.amount)
            exports['wix_core']:AddMoney(source, money.account, money.amount)
        end
    end

    kitData[kitName] = currentTime + (Config.Cooldowns[kitName] or Config.Cooldowns.default or 0)
    exports['wix_core']:Debug('RESOURCES', 'Setting cooldown until: ' .. kitData[kitName])
    SaveKitData(identifier, kitData)

    exports['wix_core']:Debug('RESOURCES', 'Kit successfully given: ' .. kitName)
    exports['wix_core']:Notify(source, Locale('kits'), Locale('kit_given', kitName), 'success')
end)