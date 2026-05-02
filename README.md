# Alarm Siren Mod for Luanti/Minetest

A simple mod that adds an alarm siren block that can be manually activated by double-clicking.

## Features

- Placeable alarm siren node
- Double-click to toggle on/off
- Tooltip shows current status (active/inactive)
- Plays siren sound when active
- Uses provided texture and sound files

## Requirements

- Luanti/Minetest 5.0+

## Installation

1. Extract or clone this folder into your `mods` directory
2. The folder should be named `alarm_siren`
3. Enable the mod in your world's `mod.conf` or through the game menu

## Usage

1. Craft or obtain the alarm siren node (creative inventory or `/give alarm_siren:siren`)
2. Place the siren block in the world
3. **Double-click** (punch twice quickly) on the placed block to toggle it on/off
4. When active, the siren will play a sound and show "Active" in the tooltip
5. When inactive, the tooltip will show "Inactive"

## Files Included

- `init.lua` - Main mod code
- `mod.conf` - Mod configuration
- `README.md` - This file
- `sounds/sirene.ogg` - Siren sound effect (provided)
- `textures/siren.png` - Siren texture (provided)

## License

Please check the license of the provided sound and texture files.
The code itself is licensed under MIT License.

## Changelog

### v1.0.0
- Initial release
- Basic siren functionality
- Double-click activation
- Tooltip status display
