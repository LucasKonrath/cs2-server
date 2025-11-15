#!/bin/bash

# CS2 Quake Sounds Plugin Installation Script
# This script installs CounterStrikeSharp and the Quake Sounds plugin

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}CS2 Quake Sounds Plugin Installer${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Create directories
echo -e "${YELLOW}Creating plugin directories...${NC}"
mkdir -p addons
mkdir -p configs

# Download CounterStrikeSharp
echo -e "${YELLOW}Downloading CounterStrikeSharp...${NC}"
CSS_VERSION="v270"
CSS_URL="https://github.com/roflmuffin/CounterStrikeSharp/releases/download/${CSS_VERSION}/counterstrikesharp-with-runtime-build-270-linux-e97aba7.zip"

cd addons
if [ -f "counterstrikesharp.zip" ]; then
    rm counterstrikesharp.zip
fi

curl -L -o counterstrikesharp.zip "$CSS_URL"
unzip -o counterstrikesharp.zip
rm counterstrikesharp.zip

echo -e "${GREEN}✓ CounterStrikeSharp installed${NC}"

# Download Quake Sounds plugin
echo -e "${YELLOW}Downloading Quake Sounds plugin...${NC}"
QUAKE_URL="https://github.com/NockyCZ/CS2-QuakeSounds/releases/latest/download/QuakeSounds.zip"

if [ -f "QuakeSounds.zip" ]; then
    rm QuakeSounds.zip
fi

curl -L -o QuakeSounds.zip "$QUAKE_URL"
unzip -o QuakeSounds.zip -d counterstrikesharp/plugins/
rm QuakeSounds.zip

echo -e "${GREEN}✓ Quake Sounds plugin installed${NC}"

cd ..

# Create default configuration
echo -e "${YELLOW}Creating default configuration...${NC}"
cat > addons/counterstrikesharp/configs/plugins/QuakeSounds/QuakeSounds.json << 'EOF'
{
  "KillSound": true,
  "HeadshotKillSound": true,
  "KnifeKillSound": true,
  "FirstKillSound": true,
  "RoundStartSound": false,
  "LastPlayerSound": false,
  "WinSound": false,
  "LoseSound": false,
  "KillSoundVolume": 0.5,
  "HeadshotKillSoundVolume": 0.5,
  "KnifeKillSoundVolume": 0.5,
  "FirstKillSoundVolume": 0.5,
  "RoundStartSoundVolume": 0.5,
  "LastPlayerSoundVolume": 0.5,
  "WinSoundVolume": 0.5,
  "LoseSoundVolume": 0.5,
  "ConfigVersion": 2
}
EOF

echo -e "${GREEN}✓ Configuration file created${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart your CS2 server:"
echo "   ${GREEN}./manage-server.sh restart${NC}"
echo ""
echo "2. The Quake sounds will be active with default settings"
echo ""
echo "3. To customize sounds, edit:"
echo "   ${GREEN}addons/counterstrikesharp/configs/plugins/QuakeSounds/QuakeSounds.json${NC}"
echo ""
echo -e "${YELLOW}Available sound events:${NC}"
echo "  - KillSound: Sounds for kills (Impressive, Excellent, etc.)"
echo "  - HeadshotKillSound: Headshot-specific sounds"
echo "  - KnifeKillSound: Knife kill sounds (Humiliation)"
echo "  - FirstKillSound: First blood sound"
echo "  - RoundStartSound: Sound at round start"
echo "  - LastPlayerSound: Sound when you're the last player alive"
echo "  - WinSound: Victory sound"
echo "  - LoseSound: Defeat sound"
echo ""
echo -e "${GREEN}Enjoy your Quake sounds! 🎮${NC}"
