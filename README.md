# Wix Kits
![banner_small](https://github.com/user-attachments/assets/b7ac06ab-aee0-41ea-b7c0-d0b3c2cc18b2)

## Table of Contents
- [Description](#description)
- [Installation](#installation)
- [License](#license)

## Description
Wix Kits is a flexible reward and kit management system for FiveM servers. It provides a complete solution for creating and managing customizable reward packages that can include items, weapons, and money.

### Features
- **Customizable Kits**: Create unlimited reward packages with items and currency
- **Cooldown System**: Configurable time-based restrictions per kit
- **Permission System**: Control access through identifiers (license, discord, steam)
- **Multiple Currencies**: Support for different money accounts (bank, cash)
- **Command & UI**: Flexible claiming through commands or ox_lib interface
- **Debug Mode**: Detailed logging for troubleshooting

### Key Benefits
- Seamless integration with Wix Core framework
- Simple configuration through config.lua
- Support for multiple inventory systems
- Optimized database storage
- Lightweight and performant

### Use Cases
- VIP reward packages
- Starter kits for new players
- Timed promotional rewards
- Role-specific equipment sets
- Donation perks management

**Dependencies:**
- [wix_core](https://github.com/Wix-Development/wix_core)
- [oxmysql](https://github.com/communityox/oxmysql)
- [ox_lib](https://github.com/CommunityOx/ox_lib) (optional)

## Installation
To install Wix Kits, follow these steps:
1. Download the latest release from the [releases page](https://github.com/Wix-Development/wix_kits/releases).
2. Make sure you have [wix_core](https://github.com/Wix-Development/wix_core) installed.
3. Extract the downloaded files into your resources folder.
4. Import the [SQL](https://github.com/Wix-Development/wix_kits/blob/main/IMPORT.sql).
5. Make sure the resource is called `wix_kits`.
6. Add `ensure wix_kits` to your `server.cfg` file.
7. Create the items for the vehicles

## License
- This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
- You may **not** sell this script or redistribute it without providing the source code.  
- Modifications must retain original credits and use the same license (GPLv3).
