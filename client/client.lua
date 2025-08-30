local function Locale(key, ...)
    return string.format(Config.Locales[key] or key, ...)
end

RegisterCommand(Config.Command, function(source, args, rawCommand)
    if Config.UI == false then
        local kitName = args[1] or 'default'
        exports['wix_core']:Debug('RESOURCES', 'Requesting kit: ' .. kitName)
        TriggerServerEvent('wix_kits:requestKit', kitName)
    elseif Config.UI == 'input' then
        exports['wix_core']:Debug('RESOURCES', 'Openning input dialog menu.')
        local input = lib.inputDialog(Locale('kits'), {
            {
                type = 'input',
                label = Locale('kit_name'),
                placeholder = Locale('kit_name_title'),
                required = false,
                autosize = true,
                default = 'default'
            }
        })
        if input then
            exports['wix_core']:Debug('RESOURCES', 'Requesting kit: ' .. input[1])
            TriggerServerEvent('wix_kits:requestKit', input[1])
        end
    end
end, false)

if Config.UI == false then
    TriggerEvent('chat:addSuggestion', '/' .. Config.Command, Locale('kit_claim'), {
        { name = Locale('kit_name_title'), help = Locale('kit_name') }
    })
else
    TriggerEvent('chat:addSuggestion', '/' .. Config.Command, Locale('kit_claim'), {})
end

if Config.Keybind and Config.UI ~= false then
    RegisterKeyMapping(Config.Command, Locale('kit_claim'), 'keyboard', Config.Keybind)
end