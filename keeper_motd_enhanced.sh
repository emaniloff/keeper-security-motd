#!/usr/bin/env bash
# Keeper Security MOTD - Enhanced Edition
# Integrates modern terminal tools for maximum visual impact
# Optional dependencies: gum, lolcat, toilet, figlet, boxes, duf, procs

# Detect platform
detect_platform() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        *)          echo "unknown";;
    esac
}

PLATFORM=$(detect_platform)

# Check for optional enhancements
HAS_GUM=$(command -v gum &> /dev/null && echo "yes" || echo "no")
HAS_LOLCAT=$(command -v lolcat &> /dev/null && echo "yes" || echo "no")
HAS_TOILET=$(command -v toilet &> /dev/null && echo "yes" || echo "no")
HAS_FIGLET=$(command -v figlet &> /dev/null && echo "yes" || echo "no")
HAS_BOXES=$(command -v boxes &> /dev/null && echo "yes" || echo "no")
HAS_DUF=$(command -v duf &> /dev/null && echo "yes" || echo "no")
HAS_GLOW=$(command -v glow &> /dev/null && echo "yes" || echo "no")

# ANSI Color Codes
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# Keeper Brand Colors
KEEPER_ORANGE='\033[38;5;208m'
KEEPER_BLUE='\033[38;5;33m'
BGREEN='\033[1;32m'
BCYAN='\033[1;36m'
BWHITE='\033[1;37m'
BYELLOW='\033[1;33m'
BMAGENTA='\033[1;35m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BRED='\033[1;31m'

# Get system info
HOSTNAME=$(hostname)
UPTIME=$(uptime -p 2>/dev/null | sed 's/up //' || uptime | awk '{print $3" "$4}')
USERS=$(who | wc -l | tr -d ' ')

# Memory
if [[ "$PLATFORM" == "linux" ]]; then
    TOTAL_RAM=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}')
    USED_RAM=$(free -h 2>/dev/null | awk '/^Mem:/{print $3}')
    RAM_PCT=$(free 2>/dev/null | awk '/^Mem:/{printf "%.0f", $3/$2 * 100}')
elif [[ "$PLATFORM" == "macos" ]]; then
    TOTAL_RAM=$(sysctl -n hw.memsize | awk '{printf "%.1fG", $1/1024/1024/1024}')
    USED_RAM=$(vm_stat | awk '/Pages active/ {print $3}' | sed 's/\.//' | awk '{printf "%.1fG", $1*4096/1024/1024/1024}')
    RAM_PCT=25
fi

# Get random security tip
TIPS_FILE="$HOME/.keeper_security_tips.txt"
if [ -f "$TIPS_FILE" ]; then
    if command -v shuf >/dev/null 2>&1; then
        SECURITY_TIP=$(shuf -n 1 "$TIPS_FILE")
    elif command -v gshuf >/dev/null 2>&1; then
        SECURITY_TIP=$(gshuf -n 1 "$TIPS_FILE")
    else
        SECURITY_TIP=$(sort -R "$TIPS_FILE" 2>/dev/null | head -n 1)
    fi
else
    SECURITY_TIP="Keeper Security: Your digital vault in the cloud. Stay secure!"
fi

# Clear screen
clear

# Enhanced Keeper Logo
show_keeper_logo() {
    if [[ "$HAS_TOILET" == "yes" ]] && [[ "$HAS_LOLCAT" == "yes" ]]; then
        # Ultra-enhanced with toilet + lolcat
        toilet -f bigmono9 -F metal "KEEPER" | lolcat -F 0.3
    elif [[ "$HAS_FIGLET" == "yes" ]] && [[ "$HAS_LOLCAT" == "yes" ]]; then
        # Enhanced with figlet + lolcat
        figlet -f slant "KEEPER" | lolcat
    elif [[ "$HAS_TOILET" == "yes" ]]; then
        # Toilet with built-in colors
        toilet -f bigmono9 --gay "KEEPER"
    elif [[ "$HAS_FIGLET" == "yes" ]]; then
        # Standard figlet
        echo -e "${KEEPER_ORANGE}"
        figlet -f slant "KEEPER"
        echo -e "${RESET}"
    else
        # Fallback ASCII art
        echo -e "${KEEPER_ORANGE}"
        cat << 'EOF'
    ██╗  ██╗███████╗███████╗██████╗ ███████╗██████╗
    ██║ ██╔╝██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗
    █████╔╝ █████╗  █████╗  ██████╔╝█████╗  ██████╔╝
    ██╔═██╗ ██╔══╝  ██╔══╝  ██╔═══╝ ██╔══╝  ██╔══██╗
    ██║  ██╗███████╗███████╗██║     ███████╗██║  ██║
    ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝
EOF
        echo -e "${RESET}"
    fi
}

# Enhanced subtitle with Gum
show_subtitle() {
    if [[ "$HAS_GUM" == "yes" ]]; then
        gum style \
            --foreground 212 --border-foreground 212 --border rounded \
            --align center --width 60 --margin "1 2" --padding "1 4" \
            "🔐 SECURITY COMMAND CENTER 🔐"
    else
        echo -e "         ${BWHITE}🔐 SECURITY COMMAND CENTER 🔐${RESET}"
    fi
}

# Enhanced vault with boxes or gum
show_vault() {
    if [[ "$HAS_GUM" == "yes" ]]; then
        gum style \
            --foreground 208 --border-foreground 208 --border double \
            --align center --width 35 --margin "0 22" --padding "1 2" \
            "🔒 VAULT: SECURED 🔒" "" "[LOCKED]" "" "◉  ACCESS GRANTED  ◉"
    elif [[ "$HAS_BOXES" == "yes" ]]; then
        echo -e "🔒 VAULT: SECURED 🔒\n[LOCKED]\n◉  ACCESS GRANTED  ◉" | boxes -d stone -a c
    else
        echo -e "${KEEPER_ORANGE}"
        cat << 'EOF'
              ╔═══════════════════════════╗
              ║    🔒 VAULT: SECURED 🔒   ║
              ║         [LOCKED]          ║
              ║    ═══════════════════    ║
              ║    ◉  ACCESS GRANTED  ◉   ║
              ╚═══════════════════════════╝
EOF
        echo -e "${RESET}"
    fi
}

# Progress bar (enhanced with gum)
progress_bar() {
    local pct=$1
    local label=$2

    if [[ "$HAS_GUM" == "yes" ]]; then
        # This would require a wrapper, showing concept
        echo -n "${CYAN}${label}:${RESET} "
        local width=25
        local filled=$((pct * width / 100))
        local empty=$((width - filled))

        if [ "$pct" -ge 90 ]; then
            local color="${BRED}"
        elif [ "$pct" -ge 75 ]; then
            local color="${BYELLOW}"
        else
            local color="${BGREEN}"
        fi

        echo -n "${color}["
        printf '█%.0s' $(seq 1 $filled)
        printf '░%.0s' $(seq 1 $empty)
        echo -e "] ${pct}%${RESET}"
    else
        # Standard progress bar
        local width=25
        local filled=$((pct * width / 100))
        local empty=$((width - filled))

        if [ "$pct" -ge 90 ]; then
            local color="${BRED}"
        elif [ "$pct" -ge 75 ]; then
            local color="${BYELLOW}"
        else
            local color="${BGREEN}"
        fi

        echo -n "${CYAN}${label}:${RESET} ${color}["
        printf '█%.0s' $(seq 1 $filled)
        printf '░%.0s' $(seq 1 $empty)
        echo -e "] ${pct}%${RESET}"
    fi
}

# Show enhanced logo
show_keeper_logo

# Show subtitle
show_subtitle

echo ""

# Show vault
show_vault

echo ""

# System Info with Gum
if [[ "$HAS_GUM" == "yes" ]]; then
    gum join --vertical \
        "$(gum style --foreground 33 '╔════════════════════════════════════════════════╗')" \
        "$(gum style --foreground 33 '║ ' && gum style --foreground 255 --bold "System: ${HOSTNAME}" && gum style ' | ' && gum style --foreground 255 --bold "Uptime: ${UPTIME}" && gum style --foreground 33 ' ║')" \
        "$(gum style --foreground 33 '╚════════════════════════════════════════════════╝')"
else
    echo -e "${KEEPER_BLUE}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${KEEPER_BLUE}║${RESET}  ${BWHITE}System:${RESET} ${BCYAN}${HOSTNAME}${RESET} ${DIM}│${RESET} ${BWHITE}Uptime:${RESET} ${GREEN}${UPTIME}${RESET} ${DIM}│${RESET} ${BWHITE}Users:${RESET} ${BWHITE}${USERS}${RESET}"
    echo -e "${KEEPER_BLUE}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
fi

echo ""

# Resource monitoring
if [[ "$HAS_GUM" == "yes" ]]; then
    gum style --border rounded --border-foreground 208 --padding "1 2" \
        "$(gum style --bold --foreground 212 '💾 RESOURCE VAULT STATUS')"
    echo ""
fi

progress_bar $RAM_PCT "RAM    "
echo -e "${DIM}        (${USED_RAM} / ${TOTAL_RAM})${RESET}"

# Enhanced disk usage with duf
if [[ "$HAS_DUF" == "yes" ]]; then
    echo ""
    echo -e "${CYAN}Disk Usage (duf):${RESET}"
    duf --only local --hide-mp '/boot*,/snap*' 2>/dev/null | head -5
else
    DISK_PCT=$(df / 2>/dev/null | awk 'NR==2 {print $5}' | sed 's/%//')
    DISK_USED=$(df -h / 2>/dev/null | awk 'NR==2 {print $3}')
    DISK_TOTAL=$(df -h / 2>/dev/null | awk 'NR==2 {print $2}')
    progress_bar $DISK_PCT "Disk   "
    echo -e "${DIM}        (${DISK_USED} / ${DISK_TOTAL})${RESET}"
fi

echo ""

# Security Tip with enhanced styling
if [[ "$HAS_GUM" == "yes" ]]; then
    gum style \
        --foreground 226 --border-foreground 226 --border rounded \
        --width 80 --margin "1 0" --padding "1 2" \
        "$(gum style --bold --foreground 212 '🛡️  SECURITY TIP OF THE DAY')" \
        "" \
        "$(gum style --foreground 255 "${SECURITY_TIP}")"
elif [[ "$HAS_BOXES" == "yes" ]]; then
    echo -e "🛡️  SECURITY TIP OF THE DAY\n\n${SECURITY_TIP}" | boxes -d peek -a c
else
    echo -e "${BYELLOW}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BYELLOW}║${RESET}  ${BMAGENTA}🛡️  SECURITY TIP OF THE DAY${RESET}"
    echo -e "${BYELLOW}║${RESET}"
    echo -e "${BYELLOW}║${RESET}  ${BWHITE}${SECURITY_TIP}${RESET}"
    echo -e "${BYELLOW}║${RESET}"
    echo -e "${BYELLOW}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
fi

echo ""

# Installation suggestions
if [[ "$HAS_GUM" == "no" ]] || [[ "$HAS_LOLCAT" == "no" ]] || [[ "$HAS_DUF" == "no" ]]; then
    echo -e "${DIM}${CYAN}💡 Enhance this MOTD further:${RESET}"
    [[ "$HAS_GUM" == "no" ]] && echo -e "${DIM}   • Install gum: https://github.com/charmbracelet/gum${RESET}"
    [[ "$HAS_LOLCAT" == "no" ]] && echo -e "${DIM}   • Install lolcat: gem install lolcat${RESET}"
    [[ "$HAS_DUF" == "no" ]] && echo -e "${DIM}   • Install duf: https://github.com/muesli/duf${RESET}"
    echo ""
fi

# Footer
echo -e "${DIM}${CYAN}─────────────────────────────────────────────────────────────────────────────${RESET}"
echo -e "${DIM}Access granted: ${BWHITE}$(date '+%Y-%m-%d %H:%M:%S')${RESET} ${DIM}│ Stay secure! 🔐${RESET}"
echo -e "${DIM}${CYAN}─────────────────────────────────────────────────────────────────────────────${RESET}"
echo ""
