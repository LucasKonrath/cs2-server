# Quake Sounds Plugin

This directory contains the Quake Sounds plugin configuration and sound files.

## Installation

Run the installation script from the project root:
```bash
./install-plugins.sh
```

## Configuration

The configuration file will be located at:
```
addons/counterstrikesharp/configs/plugins/QuakeSounds/QuakeSounds.json
```

### Available Settings

#### Sound Toggles
- `KillSound`: Enable/disable kill sounds (Impressive, Excellent, etc.)
- `HeadshotKillSound`: Enable/disable headshot-specific sounds
- `KnifeKillSound`: Enable/disable knife kill sounds (Humiliation)
- `FirstKillSound`: Enable/disable first blood sound
- `RoundStartSound`: Enable/disable sound at round start
- `LastPlayerSound`: Enable/disable sound when last player alive
- `WinSound`: Enable/disable victory sound
- `LoseSound`: Enable/disable defeat sound

#### Volume Controls
Each sound type has its own volume control (0.0 to 1.0):
- `KillSoundVolume`: 0.5 (50%)
- `HeadshotKillSoundVolume`: 0.5 (50%)
- `KnifeKillSoundVolume`: 0.5 (50%)
- `FirstKillSoundVolume`: 0.5 (50%)
- `RoundStartSoundVolume`: 0.5 (50%)
- `LastPlayerSoundVolume`: 0.5 (50%)
- `WinSoundVolume`: 0.5 (50%)
- `LoseSoundVolume`: 0.5 (50%)

### Kill Streak Sounds

The plugin automatically plays different sounds based on kill streaks:
- 1 kill: No sound
- 2 kills: "Double Kill"
- 3 kills: "Multi Kill"
- 4 kills: "Ultra Kill"
- 5 kills: "Rampage"
- 6 kills: "Killing Spree"
- 7 kills: "Monster Kill"
- 8 kills: "Unstoppable"
- 9 kills: "God Like"
- 10+ kills: "Wicked Sick"

## Customization

After modifying the configuration, restart your server:
```bash
./manage-server.sh restart
```

## Troubleshooting

### Sounds not playing
1. Verify the plugin is installed: `ls addons/counterstrikesharp/plugins/`
2. Check the configuration file exists and is valid JSON
3. Restart the server after making changes
4. Check server logs for errors: `./manage-server.sh logs`

### Volume too loud/quiet
Adjust the volume values in the config file (0.0 = silent, 1.0 = max):
```json
{
  "KillSoundVolume": 0.3,
  "HeadshotKillSoundVolume": 0.4
}
```

## Resources

- [Quake Sounds Plugin GitHub](https://github.com/NockyCZ/CS2-QuakeSounds)
- [CounterStrikeSharp Documentation](https://docs.cssharp.dev/)
