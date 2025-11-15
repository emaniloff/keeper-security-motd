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

# Keeper Brand Colors - Golden Yellow and Black
KEEPER_GOLD='\033[38;5;220m'      # Golden yellow primary
KEEPER_BLACK='\033[38;5;232m'     # Black secondary
KEEPER_DARK='\033[38;5;240m'      # Dark gray for subtle elements

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

# Animated typing effect
type_text() {
    local text="$1"
    local delay="${2:-0.01}"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# Animated progress spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Animated Keeper logo with gradient effect
show_keeper_logo() {
    # Keeper signature orange to blue gradient
    local line1="${KEEPER_GOLD}"
    local line2="${KEEPER_GOLD}"
    local line3="\033[38;5;214m"  # Orange-yellow transition
    local line4="${KEEPER_BLACK}"
    local line5="${KEEPER_BLACK}"
    local line6="${BBLUE}"

    echo -e "${line1}    ██╗  ██╗███████╗███████╗██████╗ ███████╗██████╗${RESET}"
    sleep 0.03
    echo -e "${line2}    ██║ ██╔╝██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗${RESET}"
    sleep 0.03
    echo -e "${line3}    █████╔╝ █████╗  █████╗  ██████╔╝█████╗  ██████╔╝${RESET}"
    sleep 0.03
    echo -e "${line4}    ██╔═██╗ ██╔══╝  ██╔══╝  ██╔═══╝ ██╔══╝  ██╔══██╗${RESET}"
    sleep 0.03
    echo -e "${line5}    ██║  ██╗███████╗███████╗██║     ███████╗██║  ██║${RESET}"
    sleep 0.03
    echo -e "${line6}    ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝${RESET}"

    echo ""

    # Animated subtitle with pulsing effect
    for i in {1..2}; do
        echo -ne "\r         ${BWHITE}${BLINK}🔐 SECURITY COMMAND CENTER 🔐${RESET}"
        sleep 0.3
        echo -ne "\r         ${KEEPER_GOLD}🔐 SECURITY COMMAND CENTER 🔐${RESET}"
        sleep 0.3
    done
    echo -e "\r         ${BWHITE}🔐 SECURITY COMMAND CENTER 🔐${RESET}"
    echo ""
}

# Animated vault with unlocking sequence
show_vault() {
    # Show vault locked
    echo -e "${KEEPER_DARK}"
    echo "              ╔═══════════════════════════╗"
    echo -e "              ║    ${BRED}🔒 VAULT: LOCKED 🔒${KEEPER_DARK}    ║"
    echo "              ║         [LOCKED]          ║"
    echo "              ║    ═══════════════════    ║"
    echo -e "              ║    ${DIM}◉  AUTHENTICATING  ◉${KEEPER_DARK}   ║"
    echo "              ╚═══════════════════════════╝"
    echo -e "${RESET}"

    sleep 0.2

    # Unlocking animation
    for i in {1..3}; do
        echo -ne "\r              ${KEEPER_GOLD}>>> ${BYELLOW}Verifying credentials${RESET}"
        for dot in {1..3}; do
            echo -n "."
            sleep 0.1
        done
        echo -ne "   \r"
    done

    # Clear and show unlocked vault
    tput cuu 7  # Move cursor up 7 lines
    echo -e "${KEEPER_GOLD}"
    echo "              ╔═══════════════════════════╗"
    echo -e "              ║   ${BGREEN}🔓 VAULT: UNLOCKED 🔓${KEEPER_GOLD}  ║"
    echo "              ║         [SECURED]         ║"
    echo "              ║    ═══════════════════    ║"
    echo -e "              ║   ${BGREEN}◉  ACCESS GRANTED  ◉${KEEPER_GOLD}   ║"
    echo "              ╚═══════════════════════════╝"
    echo -e "${RESET}"
}

# Clear screen for dramatic effect
clear

# Show animated header
show_keeper_logo

# Show vault animation
show_vault

echo ""

# Animated loading effect
echo -ne "${KEEPER_GOLD}>>> ${RESET}Loading system information"
for i in {1..3}; do echo -n "."; sleep 0.05; done
echo -e " ${BGREEN}✓${RESET}"
sleep 0.1

# System Info Box with Keeper colors
echo -e "${KEEPER_BLACK}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_BLACK}║${RESET}  ${KEEPER_GOLD}⚡ SYSTEM STATUS${RESET}                                                           ${KEEPER_BLACK}║${RESET}"
echo -e "${KEEPER_BLACK}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}System:${RESET} ${BWHITE}${HOSTNAME}${RESET} ${DIM}│${RESET} ${CYAN}Uptime:${RESET} ${KEEPER_GOLD}${UPTIME}${RESET} ${DIM}│${RESET} ${CYAN}Load:${RESET} ${BYELLOW}${LOAD}${RESET} ${DIM}│${RESET} ${CYAN}Users:${RESET} ${BWHITE}${USERS}${RESET}"
echo -e "${KEEPER_BLACK}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Loading animation for resources
echo -ne "${KEEPER_GOLD}>>> ${RESET}Analyzing resources"
for i in {1..3}; do echo -n "."; sleep 0.05; done
echo -e " ${BGREEN}✓${RESET}"
sleep 0.1

# Resource Vault Status with Keeper branding
echo -e "${KEEPER_GOLD}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}  ${BWHITE}💾 RESOURCE VAULT STATUS${RESET}                                                  ${KEEPER_GOLD}║${RESET}"
echo -e "${KEEPER_GOLD}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}RAM:${RESET}     $(progress_bar $RAM_PCT) ${DIM}(${USED_RAM} / ${TOTAL_RAM})${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Disk:${RESET}    $(progress_bar $DISK_PCT) ${DIM}(/ filesystem)${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}CPU:${RESET}     ${KEEPER_GOLD}${CPU_CORES}${RESET} cores ${DIM}│${RESET} Load: ${BYELLOW}${LOAD}${RESET}"
echo -e "${KEEPER_GOLD}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Loading animation for containers
echo -ne "${KEEPER_GOLD}>>> ${RESET}Checking containers"
for i in {1..3}; do echo -n "."; sleep 0.05; done
echo -e " ${BGREEN}✓${RESET}"
sleep 0.1

# Container Status with Keeper branding
echo -e "${KEEPER_BLACK}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_BLACK}║${RESET}  ${KEEPER_GOLD}🐳 ACTIVE CONTAINERS${RESET}                                                       ${KEEPER_BLACK}║${RESET}"
echo -e "${KEEPER_BLACK}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}Docker:${RESET}         ${KEEPER_GOLD}${DOCKER_RUNNING}${RESET} containers running"
if [ "$KEEPER_SERVICES" -gt 0 ]; then
    echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}Keeper Services:${RESET} ${BGREEN}✓${RESET} ${KEEPER_GOLD}${KEEPER_SERVICES}${RESET} service(s) ${BGREEN}ACTIVE${RESET}"
else
    echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}Keeper Services:${RESET} ${DIM}No Keeper containers detected${RESET}"
fi
echo -e "${KEEPER_BLACK}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Warnings if resources are critical
if [ "$RAM_PCT" -ge 85 ] || [ "$DISK_PCT" -ge 85 ]; then
    echo -e "${BRED}⚠️  ${BWHITE}WARNING: System resources running high!${RESET} ${BRED}⚠️${RESET}"
    echo ""
fi

# Keeper-branded footer with timestamp
echo -e "${KEEPER_GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${KEEPER_BLACK}⚡ Access granted: ${BWHITE}$(date '+%Y-%m-%d %H:%M:%S %Z')${RESET} ${KEEPER_BLACK}│ ${KEEPER_GOLD}Stay secure! 🔐${RESET}"
echo -e "${KEEPER_GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Loading animation for projects
echo -ne "${KEEPER_GOLD}>>> ${RESET}Scanning projects"
for i in {1..3}; do echo -n "."; sleep 0.05; done
echo -e " ${BGREEN}✓${RESET}"
sleep 0.1

# Project & Automation Status with Keeper colors
echo -e "${KEEPER_GOLD}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}  ${BWHITE}🚀 ACTIVE PROJECTS & AUTOMATION${RESET}                                           ${KEEPER_GOLD}║${RESET}"
echo -e "${KEEPER_GOLD}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"

# Check for active projects
CURRENT_PROJECT=""
if [ -f "$HOME/.current_automation_project" ]; then
    CURRENT_PROJECT=$(cat "$HOME/.current_automation_project" 2>/dev/null)
fi

if [ -n "$CURRENT_PROJECT" ]; then
    echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Current Project:${RESET} ${BGREEN}✓${RESET} ${BWHITE}${CURRENT_PROJECT}${RESET}"
else
    echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Current Project:${RESET} ${DIM}No active project${RESET}"
fi

# Git status for current directory
if [ -d ".git" ]; then
    GIT_BRANCH=$(git branch --show-current 2>/dev/null)
    GIT_STATUS=$(git status --porcelain 2>/dev/null | wc -l)
    if [ "$GIT_STATUS" -gt 0 ]; then
        echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Git Branch:${RESET}      ${BYELLOW}${GIT_BRANCH}${RESET} ${DIM}│${RESET} ${YELLOW}${GIT_STATUS} uncommitted changes${RESET}"
    else
        echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Git Branch:${RESET}      ${BGREEN}${GIT_BRANCH}${RESET} ${DIM}│${RESET} ${BGREEN}✓ Clean${RESET}"
    fi
fi

# Check for automation database
if [ -f "$HOME/.automation_context.db" ]; then
    WORKFLOW_COUNT=$(sqlite3 "$HOME/.automation_context.db" "SELECT COUNT(*) FROM workflows WHERE status='running'" 2>/dev/null || echo "0")
    if [ "$WORKFLOW_COUNT" -gt 0 ]; then
        echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Workflows:${RESET}       ${BGREEN}✓${RESET} ${KEEPER_GOLD}${WORKFLOW_COUNT}${RESET} workflow(s) ${BGREEN}RUNNING${RESET}"
    else
        echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Workflows:${RESET}       ${DIM}No active workflows${RESET}"
    fi
fi

echo -e "${KEEPER_GOLD}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Loading animation for security check
echo -ne "${KEEPER_GOLD}>>> ${RESET}Security scan"
for i in {1..3}; do echo -n "."; sleep 0.05; done
echo -e " ${BGREEN}✓${RESET}"
sleep 0.1

# SSH & Connection Security with Keeper branding
echo -e "${KEEPER_BLACK}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_BLACK}║${RESET}  ${KEEPER_GOLD}🔌 CONNECTION & SECURITY STATUS${RESET}                                           ${KEEPER_BLACK}║${RESET}"
echo -e "${KEEPER_BLACK}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"

# SSH connections
SSH_CONNECTIONS=$(who | wc -l)
TMUX_SESSIONS=$(tmux list-sessions 2>/dev/null | wc -l)

echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}Active SSH:${RESET}      ${KEEPER_GOLD}${SSH_CONNECTIONS}${RESET} connection(s) ${DIM}│${RESET} ${CYAN}Tmux:${RESET} ${KEEPER_GOLD}${TMUX_SESSIONS}${RESET} session(s)"

# Last login info
LAST_LOGIN=$(last -1 -w 2>/dev/null | head -n 1 | awk '{print $1, $3, $4, $5, $6, $7}')
if [ -n "$LAST_LOGIN" ]; then
    echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}Last Login:${RESET}      ${DIM}${LAST_LOGIN}${RESET}"
fi

# Network interfaces
ACTIVE_IPS=$(ip -4 addr show 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | wc -l)
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}Network IPs:${RESET}     ${KEEPER_GOLD}${ACTIVE_IPS}${RESET} active interface(s)"

echo -e "${KEEPER_BLACK}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Loading animation for activity
echo -ne "${KEEPER_GOLD}>>> ${RESET}Analyzing activity"
for i in {1..3}; do echo -n "."; sleep 0.05; done
echo -e " ${BGREEN}✓${RESET}"
sleep 0.1

# Recent Activity with Keeper branding
echo -e "${KEEPER_GOLD}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}  ${BWHITE}📊 RECENT ACTIVITY${RESET}                                                        ${KEEPER_GOLD}║${RESET}"
echo -e "${KEEPER_GOLD}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"

# Recent commands (from history)
RECENT_CMD_COUNT=$(history 2>/dev/null | wc -l || echo "0")
echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Shell History:${RESET}   ${KEEPER_GOLD}${RECENT_CMD_COUNT}${RESET} commands recorded"

# Git commits today
if [ -d ".git" ]; then
    TODAY=$(date +%Y-%m-%d)
    COMMITS_TODAY=$(git log --since="$TODAY 00:00:00" --oneline 2>/dev/null | wc -l)
    if [ "$COMMITS_TODAY" -gt 0 ]; then
        echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Commits Today:${RESET}   ${BGREEN}✓${RESET} ${KEEPER_GOLD}${COMMITS_TODAY}${RESET} commit(s)"
    else
        echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Commits Today:${RESET}   ${DIM}No commits yet${RESET}"
    fi
fi

# Docker events
DOCKER_EVENTS=$(docker events --since 1h --until 0s 2>/dev/null | wc -l)
if [ "$DOCKER_EVENTS" -gt 0 ]; then
    echo -e "${KEEPER_GOLD}║${RESET}  ${KEEPER_BLACK}Docker Events:${RESET}   ${KEEPER_GOLD}${DOCKER_EVENTS}${RESET} events in last hour"
fi

echo -e "${KEEPER_GOLD}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Quick Commands with Keeper branding
echo -e "${KEEPER_BLACK}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_BLACK}║${RESET}  ${KEEPER_GOLD}⚡ QUICK COMMANDS${RESET}                                                             ${KEEPER_BLACK}║${RESET}"
echo -e "${KEEPER_BLACK}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}keeper-status${RESET}  ${DIM}│${RESET} Check Keeper services"
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}docker ps${RESET}      ${DIM}│${RESET} List containers"
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}htop${RESET}           ${DIM}│${RESET} System monitor"
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}tmux attach${RESET}    ${DIM}│${RESET} Attach to session"
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}git status${RESET}     ${DIM}│${RESET} Check repository status"
echo -e "${KEEPER_BLACK}║${RESET}  ${CYAN}claude${RESET}         ${DIM}│${RESET} Launch Claude Code"
echo -e "${KEEPER_BLACK}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Easter egg - random motivational quote with animation
QUOTES=(
    "\"Lock it down, keep it secure!\" - Keeper Security"
    "\"Zero-knowledge architecture: What we don't know can't hurt you.\""
    "\"Your vault, your rules, your security.\""
    "\"Passwords are like underwear: change them often and don't share them.\""
    "\"Security is not a product, but a process.\""
    "\"In cryptography we trust.\""
    "\"The best password is the one you don't have to remember.\""
    "\"Encrypted today, secure tomorrow.\""
)
RANDOM_QUOTE=${QUOTES[$RANDOM % ${#QUOTES[@]}]}
echo -e "${KEEPER_GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${KEEPER_BLACK}💡 ${BWHITE}${RANDOM_QUOTE}${RESET}"
echo -e "${KEEPER_GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Security Tip of the Day at the bottom with dynamic box sizing
# Calculate the width needed for the security tip
TIP_LENGTH=${#SECURITY_TIP}
# Minimum width of 50, add padding of 6 (4 for borders and spaces, 2 for padding)
BOX_WIDTH=$((TIP_LENGTH + 6))
# Ensure minimum width of 56 for the header
[ $BOX_WIDTH -lt 56 ] && BOX_WIDTH=56

# Generate dynamic borders
BORDER_LINE=$(printf '═%.0s' $(seq 1 $((BOX_WIDTH - 2))))

# Header width calculation
HEADER_TEXT="  🛡️  SECURITY TIP OF THE DAY"
HEADER_LENGTH=$((${#HEADER_TEXT} + 2))  # +2 for color codes padding
HEADER_PADDING=$((BOX_WIDTH - HEADER_LENGTH - 2))
HEADER_SPACES=$(printf ' %.0s' $(seq 1 $HEADER_PADDING))

# Tip content padding
TIP_PADDING=$((BOX_WIDTH - TIP_LENGTH - 4))
TIP_SPACES=$(printf ' %.0s' $(seq 1 $TIP_PADDING))

echo -e "${KEEPER_GOLD}╔${BORDER_LINE}╗${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}${BWHITE}${HEADER_TEXT}${RESET}${HEADER_SPACES}${KEEPER_GOLD}║${RESET}"
echo -e "${KEEPER_GOLD}╠${BORDER_LINE}╣${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}  ${BCYAN}${SECURITY_TIP}${RESET}${TIP_SPACES}${KEEPER_GOLD}║${RESET}"
echo -e "${KEEPER_GOLD}║${RESET}"
echo -e "${KEEPER_GOLD}╚${BORDER_LINE}╝${RESET}"
echo ""
