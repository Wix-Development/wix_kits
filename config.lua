-- __          _________   __    _____                 _                                  _   
-- \ \        / /_   _\ \ / /   |  __ \               | |                                | |  
--  \ \  /\  / /  | |  \ V /    | |  | | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_ 
--   \ \/  \/ /   | |   > <     | |  | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
--    \  /\  /   _| |_ / . \    | |__| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_ 
--     \/  \/   |_____/_/ \_\   |_____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__|
--                                                            | |                             
--                                                            |_|                             
Config = {}

--[[ DATABASE CONFIGURATION ]]--
Config.AutoSQL = true -- Enable automatic database table creation on resource start

--[[ GENERAL SETTINGS ]]--
Config.UserIdentifier = 'license' -- Type of identifier to use (license, steam, discord, etc.)
Config.Command = 'kit' -- Command that players will use to claim kits
Config.Keybind = 'F5' -- Key to open kit menu (only works with UI enabled)
Config.UI = 'input' -- UI mode: false = command only, 'input' = ox_lib dialog

--[[ COOLDOWN SETTINGS ]]--
Config.Cooldowns = {
    default = 3600, -- Default kit cooldown in seconds (1 hour)
    vip = 86400    -- VIP kit cooldown in seconds (24 hours)
}

--[[ ACCESS CONTROL ]]--
Config.AllowedIdentifiers = {
    -- List of identifiers that can access specific kits
    -- Format: kitName = {list of allowed identifiers}
    vip = {'discord:1140024208097824820', 'license:000000000000'}
}

--[[ KIT DEFINITIONS ]]--
Config.Kits = {
    default = {
        money = {
            { account = 'bank', amount = 1000 },
            { account = 'money', amount = 500 },
        },
        items = {
            { name = 'burger', amount = 5 },
            { name = 'water', amount = 5 },
        }
    },
    vip = {
        items = {
            { name = 'weapon_pistol', amount = 1 },
            { name = 'ammo-9', amount = 50 },
        }
    }
}

--[[ LOCALIZATION ]]--
Config.Locales = {
    kits = 'Kits',
    kit_given = 'You have received your kit: %s',
    kit_not_found = 'Kit not found.',
    kit_on_cooldown = 'You need to wait %s seconds before using this kit again.',
    kit_no_permission = 'You are not allowed to use this kit.',
    kit_invalid_identifier = 'Could not find valid identifier.',
    kit_name = 'Name of the kit you want to claim.',
    kit_name_title = 'KitName',
    kit_claim = 'Claim your kit.'
}