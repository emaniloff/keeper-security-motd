#!/bin/bash
# Keeper Security Themed MOTD with Animation
# Because security should be fun too!

# ANSI Color Codes
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
BLINK='\033[5m'

# Standard Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold Colors
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
BMAGENTA='\033[1;35m'
BCYAN='\033[1;36m'
BWHITE='\033[1;37m'

# RGB Colors (for modern terminals)
ORANGE='\033[38;5;208m'
PURPLE='\033[38;5;141m'
LIME='\033[38;5;118m'
PINK='\033[38;5;213m'

# Keeper Brand Colors
KEEPER_ORANGE='\033[38;5;208m'
KEEPER_BLUE='\033[38;5;33m'
KEEPER_DARK='\033[38;5;240m'

# Get system info (with caching to speed up login)
HOSTNAME=$(hostname)
UPTIME=$(uptime -p | sed 's/up //')
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs | cut -d',' -f1)
USERS=$(who | wc -l)

# Memory & Resources
TOTAL_RAM=$(free -h | awk '/^Mem:/{print $2}')
USED_RAM=$(free -h | awk '/^Mem:/{print $3}')
RAM_PCT=$(free | awk '/^Mem:/{printf "%.0f", $3/$2 * 100}')
DISK_PCT=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
CPU_CORES=$(nproc)

# Docker & Services
DOCKER_RUNNING=$(docker ps -q 2>/dev/null | wc -l)
KEEPER_SERVICES=$(docker ps 2>/dev/null | grep -i keeper | wc -l)

# Get random security tip
TIPS_FILE="/root/.keeper_security_tips.txt"
if [ -f "$TIPS_FILE" ]; then
    SECURITY_TIP=$(shuf -n 1 "$TIPS_FILE")
else
    SECURITY_TIP="Keeper Security: Your digital vault in the cloud. Stay secure!"
fi

# Progress bar generator
progress_bar() {
    local pct=$1
    local width=25
    local filled=$((pct * width / 100))
    local empty=$((width - filled))

    # Color based on usage
    if [ "$pct" -ge 90 ]; then
        local color="${BRED}"
    elif [ "$pct" -ge 75 ]; then
        local color="${BYELLOW}"
    else
        local color="${BGREEN}"
    fi

    echo -n "${color}["
    for ((i=0; i<filled; i++)); do echo -n "█"; done
    for ((i=0; i<empty; i++)); do echo -n "░"; done
    echo -n "] ${pct}%${RESET}"
}

# Animated banner function
show_keeper_logo() {
    local colors=("${KEEPER_ORANGE}" "${KEEPER_BLUE}" "${BMAGENTA}" "${BCYAN}" "${BGREEN}" "${BYELLOW}")
    local random_color=${colors[$RANDOM % ${#colors[@]}]}

    echo -e "${random_color}"
    cat << 'EOF'
    ██╗  ██╗███████╗███████╗██████╗ ███████╗██████╗
    ██║ ██╔╝██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗
    █████╔╝ █████╗  █████╗  ██████╔╝█████╗  ██████╔╝
    ██╔═██╗ ██╔══╝  ██╔══╝  ██╔═══╝ ██╔══╝  ██╔══██╗
    ██║  ██╗███████╗███████╗██║     ███████╗██║  ██║
    ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝
EOF
    echo -e "${RESET}"

    # Animated subtitle
    local subtext="🔐 SECURITY COMMAND CENTER 🔐"
    echo -e "         ${BWHITE}${subtext}${RESET}"
    echo ""
}

# Vault animation (fun little ASCII vault)
show_vault() {
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
}

# Clear screen for dramatic effect
clear

# Show animated header
show_keeper_logo

# Show vault animation
show_vault

echo ""

# System Info Box
echo -e "${KEEPER_BLUE}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_BLUE}║${RESET}  ${BWHITE}System:${RESET} ${BCYAN}${HOSTNAME}${RESET} ${DIM}│${RESET} ${BWHITE}Uptime:${RESET} ${GREEN}${UPTIME}${RESET} ${DIM}│${RESET} ${BWHITE}Load:${RESET} ${YELLOW}${LOAD}${RESET} ${DIM}│${RESET} ${BWHITE}Users:${RESET} ${BWHITE}${USERS}${RESET}"
echo -e "${KEEPER_BLUE}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Resource Vault Status
echo -e "${KEEPER_ORANGE}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_ORANGE}║${RESET}  ${BMAGENTA}💾 RESOURCE VAULT STATUS${RESET}                                                  ${KEEPER_ORANGE}║${RESET}"
echo -e "${KEEPER_ORANGE}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${KEEPER_ORANGE}║${RESET}  ${CYAN}RAM:${RESET}     $(progress_bar $RAM_PCT) ${DIM}(${USED_RAM} / ${TOTAL_RAM})${RESET}"
echo -e "${KEEPER_ORANGE}║${RESET}  ${CYAN}Disk:${RESET}    $(progress_bar $DISK_PCT) ${DIM}(/ filesystem)${RESET}"
echo -e "${KEEPER_ORANGE}║${RESET}  ${CYAN}CPU:${RESET}     ${BWHITE}${CPU_CORES}${RESET} cores available ${DIM}│${RESET} Load: ${YELLOW}${LOAD}${RESET}"
echo -e "${KEEPER_ORANGE}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Keeper Services Status
echo -e "${BGREEN}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BGREEN}║${RESET}  ${BMAGENTA}🐳 ACTIVE CONTAINERS${RESET}                                                       ${BGREEN}║${RESET}"
echo -e "${BGREEN}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${BGREEN}║${RESET}  ${CYAN}Docker:${RESET}         ${BWHITE}${DOCKER_RUNNING}${RESET} containers running"
if [ "$KEEPER_SERVICES" -gt 0 ]; then
    echo -e "${BGREEN}║${RESET}  ${CYAN}Keeper Services:${RESET} ${BGREEN}✓${RESET} ${KEEPER_SERVICES} service(s) ${BGREEN}ACTIVE${RESET}"
else
    echo -e "${BGREEN}║${RESET}  ${CYAN}Keeper Services:${RESET} ${DIM}No Keeper containers detected${RESET}"
fi
echo -e "${BGREEN}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Security Tip of the Day (The star of the show!)
echo -e "${BYELLOW}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BYELLOW}║${RESET}  ${BLINK}${BMAGENTA}🛡️  SECURITY TIP OF THE DAY${RESET}                                                ${BYELLOW}║${RESET}"
echo -e "${BYELLOW}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${BYELLOW}║${RESET}"
echo -e "${BYELLOW}║${RESET}  ${BWHITE}${SECURITY_TIP}${RESET}"
echo -e "${BYELLOW}║${RESET}"
echo -e "${BYELLOW}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Warnings if resources are critical
if [ "$RAM_PCT" -ge 85 ] || [ "$DISK_PCT" -ge 85 ]; then
    echo -e "${BRED}⚠️  ${BWHITE}WARNING: System resources running high!${RESET} ${BRED}⚠️${RESET}"
    echo ""
fi

# Fun footer with timestamp
echo -e "${DIM}${CYAN}─────────────────────────────────────────────────────────────────────────────${RESET}"
echo -e "${DIM}Access granted at: ${BWHITE}$(date '+%Y-%m-%d %H:%M:%S %Z')${RESET} ${DIM}│ Stay secure! 🔐${RESET}"
echo -e "${DIM}${CYAN}─────────────────────────────────────────────────────────────────────────────${RESET}"
echo ""

# Quick tips
echo -e "${BCYAN}Quick Commands:${RESET}"
echo -e "${DIM}  keeper-status  ${RESET}│ ${DIM}Check Keeper services${RESET}"
echo -e "${DIM}  docker ps      ${RESET}│ ${DIM}List containers${RESET}"
echo -e "${DIM}  htop           ${RESET}│ ${DIM}System monitor${RESET}"
echo -e "${DIM}  tmux attach    ${RESET}│ ${DIM}Attach to session${RESET}"
echo ""
