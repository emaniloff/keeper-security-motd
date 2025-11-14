#!/bin/bash
# Keeper Security MOTD - Uninstallation Script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║   Keeper Security MOTD - Uninstaller                  ║${RESET}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${RESET}"
echo ""

# Confirmation
read -p "Are you sure you want to uninstall Keeper Security MOTD? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstall cancelled.${RESET}"
    exit 0
fi

echo ""
echo -e "${YELLOW}Uninstalling Keeper Security MOTD...${RESET}"

# Remove files
if [ -f "$HOME/.keeper_motd.sh" ]; then
    echo -e "${GREEN}Removing MOTD script...${RESET}"
    rm "$HOME/.keeper_motd.sh"
fi

if [ -f "$HOME/.keeper_security_tips.txt" ]; then
    echo -e "${GREEN}Removing security tips file...${RESET}"
    rm "$HOME/.keeper_security_tips.txt"
fi

# Remove from shell configs
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc" ]; then
        if grep -q "keeper_motd.sh" "$rc"; then
            echo -e "${GREEN}Removing from $rc...${RESET}"
            # Create a backup
            cp "$rc" "$rc.backup.$(date +%Y%m%d_%H%M%S)"
            # Remove the MOTD section
            sed -i '/# Display Keeper Security MOTD/,/fi/d' "$rc"
        fi
    fi
done

echo ""
echo -e "${GREEN}✅ Keeper Security MOTD has been uninstalled${RESET}"
echo -e "${CYAN}Backups of configuration files have been saved${RESET}"
echo ""
