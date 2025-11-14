#!/bin/bash
# Keeper Security MOTD - macOS Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${CYAN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║    Keeper Security MOTD - macOS Installer             ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${RESET}"

echo ""
echo -e "${BLUE}Installing Keeper Security MOTD for macOS...${RESET}"
echo ""

# Check if we're on macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo -e "${RED}❌ This installer is for macOS only!${RESET}"
    echo -e "${YELLOW}For Linux, use: ./install.sh${RESET}"
    echo -e "${YELLOW}For Windows, use: install_windows.ps1${RESET}"
    exit 1
fi

# Installation directory
INSTALL_DIR="$HOME"
MOTD_SCRIPT=".keeper_motd.sh"
TIPS_FILE=".keeper_security_tips.txt"

# Backup existing files
if [ -f "$INSTALL_DIR/$MOTD_SCRIPT" ]; then
    echo -e "${YELLOW}Backing up existing MOTD script...${RESET}"
    mv "$INSTALL_DIR/$MOTD_SCRIPT" "$INSTALL_DIR/$MOTD_SCRIPT.backup.$(date +%Y%m%d_%H%M%S)"
fi

if [ -f "$INSTALL_DIR/$TIPS_FILE" ]; then
    echo -e "${YELLOW}Backing up existing tips file...${RESET}"
    mv "$INSTALL_DIR/$TIPS_FILE" "$INSTALL_DIR/$TIPS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Copy files
echo -e "${GREEN}Installing universal MOTD script...${RESET}"
cp keeper_motd_universal.sh "$INSTALL_DIR/$MOTD_SCRIPT"
chmod +x "$INSTALL_DIR/$MOTD_SCRIPT"

echo -e "${GREEN}Installing security tips...${RESET}"
cp security_tips.txt "$INSTALL_DIR/$TIPS_FILE"
chmod 644 "$INSTALL_DIR/$TIPS_FILE"

# Detect shell
SHELL_RC=""
CURRENT_SHELL=$(basename "$SHELL")

case "$CURRENT_SHELL" in
    zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;
    bash)
        # macOS uses .bash_profile for login shells
        if [ -f "$HOME/.bash_profile" ]; then
            SHELL_RC="$HOME/.bash_profile"
        else
            SHELL_RC="$HOME/.bashrc"
        fi
        ;;
    *)
        echo -e "${YELLOW}⚠️  Unknown shell: $CURRENT_SHELL${RESET}"
        SHELL_RC="$HOME/.profile"
        ;;
esac

echo ""
echo -e "${CYAN}Detected shell: $CURRENT_SHELL${RESET}"
echo -e "${CYAN}Configuration file: $SHELL_RC${RESET}"

# Check if already configured
if grep -q "keeper_motd.sh" "$SHELL_RC" 2>/dev/null; then
    echo -e "${YELLOW}MOTD already configured in $SHELL_RC${RESET}"
else
    echo -e "${GREEN}Adding MOTD to $SHELL_RC${RESET}"

    # Create shell RC if it doesn't exist
    touch "$SHELL_RC"

    cat >> "$SHELL_RC" << 'SHELLRC'

# Display Keeper Security MOTD on login (only for interactive shells)
if [ -n "$PS1" ] && [ -f ~/.keeper_motd.sh ]; then
    ~/.keeper_motd.sh
fi
SHELLRC
fi

# macOS-specific: Check if GNU coreutils are installed
echo ""
echo -e "${CYAN}Checking for GNU coreutils...${RESET}"
if ! command -v gshuf &> /dev/null; then
    echo -e "${YELLOW}⚠️  GNU coreutils not found. Installing via Homebrew (recommended)...${RESET}"
    if command -v brew &> /dev/null; then
        echo -e "${GREEN}Installing GNU coreutils via Homebrew...${RESET}"
        brew install coreutils 2>/dev/null || echo -e "${YELLOW}Please install manually: brew install coreutils${RESET}"
    else
        echo -e "${YELLOW}Homebrew not found. Please install it from: https://brew.sh${RESET}"
        echo -e "${YELLOW}Then run: brew install coreutils${RESET}"
        echo -e "${YELLOW}(MOTD will still work, but tips will not rotate)${RESET}"
    fi
else
    echo -e "${GREEN}✅ GNU coreutils already installed${RESET}"
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
echo -e "  1. Open a new terminal to see the MOTD"
echo -e "  2. Or run: ${YELLOW}source $SHELL_RC${RESET}"
echo -e "  3. Customize tips: ${YELLOW}nano ~/.keeper_security_tips.txt${RESET}"
echo ""
echo -e "${MAGENTA}Stay Secure! 🔐${RESET}"
echo ""
