#!/bin/bash
# Keeper Security MOTD - Installation Script
# Installs the Keeper-themed MOTD for SSH login banners

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Configuration
INSTALL_DIR="$HOME"
MOTD_SCRIPT=".keeper_motd.sh"
TIPS_FILE=".keeper_security_tips.txt"

echo -e "${CYAN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║       Keeper Security MOTD - Installer                ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${RESET}"

echo ""
echo -e "${BLUE}Installing Keeper Security MOTD...${RESET}"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Running as root. MOTD will be installed to /root${RESET}"
fi

# Backup existing files if they exist
if [ -f "$INSTALL_DIR/$MOTD_SCRIPT" ]; then
    echo -e "${YELLOW}Backing up existing MOTD script...${RESET}"
    mv "$INSTALL_DIR/$MOTD_SCRIPT" "$INSTALL_DIR/$MOTD_SCRIPT.backup.$(date +%Y%m%d_%H%M%S)"
fi

if [ -f "$INSTALL_DIR/$TIPS_FILE" ]; then
    echo -e "${YELLOW}Backing up existing tips file...${RESET}"
    mv "$INSTALL_DIR/$TIPS_FILE" "$INSTALL_DIR/$TIPS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Copy files
echo -e "${GREEN}Installing MOTD script to $INSTALL_DIR/$MOTD_SCRIPT${RESET}"
cp keeper_motd.sh "$INSTALL_DIR/$MOTD_SCRIPT"
chmod +x "$INSTALL_DIR/$MOTD_SCRIPT"

echo -e "${GREEN}Installing security tips to $INSTALL_DIR/$TIPS_FILE${RESET}"
cp security_tips.txt "$INSTALL_DIR/$TIPS_FILE"
chmod 644 "$INSTALL_DIR/$TIPS_FILE"

# Detect shell and configure
SHELL_RC=""
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "$(which zsh 2>/dev/null)" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ "$SHELL" = "$(which bash 2>/dev/null)" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    echo ""
    echo -e "${CYAN}Detected shell configuration: $SHELL_RC${RESET}"

    # Check if already configured
    if grep -q "keeper_motd.sh" "$SHELL_RC" 2>/dev/null; then
        echo -e "${YELLOW}MOTD already configured in $SHELL_RC${RESET}"
    else
        echo -e "${GREEN}Adding MOTD to $SHELL_RC${RESET}"
        cat >> "$SHELL_RC" << 'SHELLRC'

# Display Keeper Security MOTD on login (only for interactive shells)
if [ -n "$PS1" ] && [ -f ~/.keeper_motd.sh ]; then
    ~/.keeper_motd.sh
fi
SHELLRC
    fi
else
    echo -e "${YELLOW}⚠️  Could not detect shell. Please manually add the following to your shell RC file:${RESET}"
    echo ""
    echo -e "${CYAN}if [ -n \"\$PS1\" ] && [ -f ~/.keeper_motd.sh ]; then${RESET}"
    echo -e "${CYAN}    ~/.keeper_motd.sh${RESET}"
    echo -e "${CYAN}fi${RESET}"
    echo ""
fi

# Test installation
echo ""
echo -e "${MAGENTA}Testing installation...${RESET}"
if [ -x "$INSTALL_DIR/$MOTD_SCRIPT" ]; then
    echo -e "${GREEN}✅ Installation successful!${RESET}"
else
    echo -e "${RED}❌ Installation failed - script not executable${RESET}"
    exit 1
fi

# Show preview
echo ""
echo -e "${CYAN}Preview of your new MOTD:${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
"$INSTALL_DIR/$MOTD_SCRIPT"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║                                                       ║${RESET}"
echo -e "${GREEN}║         Installation Complete! 🎉                     ║${RESET}"
echo -e "${GREEN}║                                                       ║${RESET}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${CYAN}Next steps:${RESET}"
echo -e "  1. Log out and log back in to see the MOTD"
echo -e "  2. Or run: ${YELLOW}source $SHELL_RC${RESET}"
echo -e "  3. Customize tips: ${YELLOW}nano ~/.keeper_security_tips.txt${RESET}"
echo ""
echo -e "${MAGENTA}Stay Secure! 🔐${RESET}"
echo ""
