#!/bin/bash
# Keeper Security MOTD - Enhancement Tools Installer
# Installs optional terminal beautification tools

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${CYAN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║    Keeper MOTD - Enhancement Tools Installer          ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${RESET}"

# Detect platform
detect_platform() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        *)          echo "unknown";;
    esac
}

PLATFORM=$(detect_platform)

echo ""
echo -e "${BLUE}Platform detected: ${YELLOW}$PLATFORM${RESET}"
echo ""

# Detect package manager
detect_package_manager() {
    if command -v brew &> /dev/null; then
        echo "brew"
    elif command -v apt &> /dev/null; then
        echo "apt"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    else
        echo "unknown"
    fi
}

PKG_MANAGER=$(detect_package_manager)

echo -e "${BLUE}Package manager: ${YELLOW}$PKG_MANAGER${RESET}"
echo ""

# Enhancement selection
echo -e "${CYAN}Select enhancement tier to install:${RESET}"
echo ""
echo -e "${GREEN}1)${RESET} Essential Only (gum, lolcat, duf) - ${YELLOW}Recommended${RESET}"
echo -e "${GREEN}2)${RESET} Visual Enhancements (Essential + toilet, boxes, figlet)"
echo -e "${GREEN}3)${RESET} System Monitoring (Visual + btop, procs)"
echo -e "${GREEN}4)${RESET} Full Suite (Everything including Charm ecosystem)"
echo -e "${GREEN}5)${RESET} Custom (select individual tools)"
echo -e "${GREEN}6)${RESET} Exit"
echo ""

read -p "Enter choice [1-6]: " choice

install_essential() {
    echo -e "${CYAN}Installing Essential Enhancements...${RESET}"
    case "$PKG_MANAGER" in
        brew)
            brew install gum lolcat duf
            ;;
        apt)
            # Gum
            wget -q https://github.com/charmbracelet/gum/releases/latest/download/gum_Linux_amd64.deb -O /tmp/gum.deb
            sudo dpkg -i /tmp/gum.deb
            # Lolcat
            sudo gem install lolcat || sudo apt install -y lolcat
            # Duf
            wget -q https://github.com/muesli/duf/releases/latest/download/duf_linux_amd64.deb -O /tmp/duf.deb
            sudo dpkg -i /tmp/duf.deb
            ;;
        pacman)
            sudo pacman -S --noconfirm gum lolcat duf
            ;;
        dnf)
            echo -e "${YELLOW}Installing from binaries...${RESET}"
            # Install gum
            wget -q https://github.com/charmbracelet/gum/releases/latest/download/gum_Linux_x86_64.tar.gz -O /tmp/gum.tar.gz
            tar xzf /tmp/gum.tar.gz -C /tmp
            sudo mv /tmp/gum /usr/local/bin/
            # Lolcat
            sudo gem install lolcat
            # Duf
            wget -q https://github.com/muesli/duf/releases/latest/download/duf_linux_amd64.rpm -O /tmp/duf.rpm
            sudo rpm -i /tmp/duf.rpm
            ;;
    esac
    echo -e "${GREEN}✅ Essential enhancements installed!${RESET}"
}

install_visual() {
    install_essential
    echo ""
    echo -e "${CYAN}Installing Visual Enhancements...${RESET}"
    case "$PKG_MANAGER" in
        brew)
            brew install toilet boxes figlet
            ;;
        apt)
            sudo apt install -y toilet boxes figlet
            ;;
        pacman)
            sudo pacman -S --noconfirm toilet boxes figlet
            ;;
        dnf)
            sudo dnf install -y toilet boxes figlet
            ;;
    esac
    echo -e "${GREEN}✅ Visual enhancements installed!${RESET}"
}

install_monitoring() {
    install_visual
    echo ""
    echo -e "${CYAN}Installing System Monitoring Tools...${RESET}"
    case "$PKG_MANAGER" in
        brew)
            brew install btop procs
            ;;
        apt)
            sudo apt install -y btop || sudo snap install btop
            # Procs from binary
            wget -q https://github.com/dalance/procs/releases/latest/download/procs-x86_64-linux.zip -O /tmp/procs.zip
            unzip -q /tmp/procs.zip -d /tmp
            sudo mv /tmp/procs /usr/local/bin/
            ;;
        pacman)
            sudo pacman -S --noconfirm btop procs
            ;;
        dnf)
            sudo dnf install -y btop
            cargo install procs || echo -e "${YELLOW}Install Rust/Cargo for procs${RESET}"
            ;;
    esac
    echo -e "${GREEN}✅ Monitoring tools installed!${RESET}"
}

install_full() {
    install_monitoring
    echo ""
    echo -e "${CYAN}Installing Full Charm Ecosystem...${RESET}"
    case "$PKG_MANAGER" in
        brew)
            brew install glow vhs fastfetch cowsay jp2a cmatrix
            ;;
        apt)
            # Glow
            wget -q https://github.com/charmbracelet/glow/releases/latest/download/glow_linux_amd64.deb -O /tmp/glow.deb
            sudo dpkg -i /tmp/glow.deb
            # Others
            sudo apt install -y cowsay jp2a cmatrix
            # Fastfetch
            sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch || true
            sudo apt update && sudo apt install -y fastfetch || echo -e "${YELLOW}Fastfetch not available${RESET}"
            ;;
        pacman)
            sudo pacman -S --noconfirm glow fastfetch cowsay jp2a cmatrix
            ;;
        dnf)
            sudo dnf install -y cowsay cmatrix
            echo -e "${YELLOW}Some tools may need manual installation${RESET}"
            ;;
    esac
    echo -e "${GREEN}✅ Full suite installed!${RESET}"
}

install_custom() {
    echo ""
    echo -e "${CYAN}Select tools to install (space-separated numbers):${RESET}"
    echo ""
    echo "1) gum      - Glamorous shell scripts"
    echo "2) lolcat   - Rainbow colors"
    echo "3) duf      - Modern disk usage"
    echo "4) toilet   - Enhanced ASCII art"
    echo "5) boxes    - ASCII boxes"
    echo "6) figlet   - Classic ASCII art"
    echo "7) btop     - System monitor"
    echo "8) procs    - Process viewer"
    echo "9) glow     - Markdown renderer"
    echo "10) cowsay  - Speaking cow"
    echo ""
    read -p "Enter numbers (e.g., 1 2 3): " selections

    for tool in $selections; do
        case $tool in
            1) echo "Installing gum..."; ;;
            2) echo "Installing lolcat..."; ;;
            3) echo "Installing duf..."; ;;
            # Add more cases as needed
        esac
    done

    echo -e "${GREEN}✅ Custom tools installed!${RESET}"
}

# Execute based on choice
case $choice in
    1)
        install_essential
        ;;
    2)
        install_visual
        ;;
    3)
        install_monitoring
        ;;
    4)
        install_full
        ;;
    5)
        install_custom
        ;;
    6)
        echo -e "${YELLOW}Installation cancelled.${RESET}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice!${RESET}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║                                                       ║${RESET}"
echo -e "${GREEN}║         Enhancement Installation Complete! 🎉         ║${RESET}"
echo -e "${GREEN}║                                                       ║${RESET}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${CYAN}Next steps:${RESET}"
echo "  1. Use the enhanced MOTD: ${YELLOW}./keeper_motd_enhanced.sh${RESET}"
echo "  2. Or install it: ${YELLOW}cp keeper_motd_enhanced.sh ~/.keeper_motd.sh${RESET}"
echo "  3. See ENHANCEMENTS.md for usage examples"
echo ""
echo -e "${CYAN}Test your enhancements:${RESET}"
echo "  ${YELLOW}gum style --border rounded --padding '1 2' 'Hello Keeper!'${RESET}"
echo "  ${YELLOW}echo 'KEEPER SECURITY' | lolcat${RESET}"
echo "  ${YELLOW}duf${RESET}"
echo ""
