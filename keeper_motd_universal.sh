#!/usr/bin/env bash
# Keeper Security MOTD - Universal (Linux, macOS, BSD)
# Cross-platform SSH login banner with security tips

# Detect platform
detect_platform() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        FreeBSD*)   echo "freebsd";;
        *)          echo "unknown";;
    esac
}

PLATFORM=$(detect_platform)

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

# Keeper Brand Colors
KEEPER_ORANGE='\033[38;5;208m'
KEEPER_BLUE='\033[38;5;33m'
KEEPER_DARK='\033[38;5;240m'

# Platform-specific system info functions
get_uptime() {
    case "$PLATFORM" in
        linux)
            uptime -p 2>/dev/null | sed 's/up //' || uptime | awk '{print $3" "$4}'
            ;;
        macos)
            local boot=$(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')
            local now=$(date +%s)
            local uptime_seconds=$((now - boot))
            local days=$((uptime_seconds / 86400))
            local hours=$(( (uptime_seconds % 86400) / 3600 ))
            local minutes=$(( (uptime_seconds % 3600) / 60 ))
            echo "${days}d ${hours}h ${minutes}m"
            ;;
        *)
            uptime | awk '{print $3" "$4}'
            ;;
    esac
}

get_load() {
    case "$PLATFORM" in
        linux|macos)
            uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//'
            ;;
        *)
            echo "N/A"
            ;;
    esac
}

get_memory_info() {
    case "$PLATFORM" in
        linux)
            local total=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}')
            local used=$(free -h 2>/dev/null | awk '/^Mem:/{print $3}')
            local pct=$(free 2>/dev/null | awk '/^Mem:/{printf "%.0f", $3/$2 * 100}')
            echo "$used|$total|$pct"
            ;;
        macos)
            local total=$(sysctl -n hw.memsize | awk '{printf "%.1fG", $1/1024/1024/1024}')
            local used=$(vm_stat | awk '/Pages active/ {print $3}' | sed 's/\.//' | awk '{printf "%.1fG", $1*4096/1024/1024/1024}')
            local pct=$(vm_stat | awk '/Pages active/ {active=$3} /Pages free/ {free=$3} END {printf "%.0f", (active/(active+free))*100}')
            echo "$used|$total|${pct:-25}"
            ;;
        *)
            echo "N/A|N/A|0"
            ;;
    esac
}

get_disk_info() {
    case "$PLATFORM" in
        linux|macos)
            local total=$(df -h / 2>/dev/null | awk 'NR==2 {print $2}')
            local used=$(df -h / 2>/dev/null | awk 'NR==2 {print $3}')
            local pct=$(df / 2>/dev/null | awk 'NR==2 {print $5}' | sed 's/%//')
            echo "$used|$total|$pct"
            ;;
        *)
            echo "N/A|N/A|0"
            ;;
    esac
}

get_cpu_info() {
    case "$PLATFORM" in
        linux)
            local cores=$(nproc 2>/dev/null || echo "N/A")
            local model=$(lscpu 2>/dev/null | grep "Model name" | cut -d: -f2 | xargs | cut -c1-40)
            echo "$cores|${model:-Unknown CPU}"
            ;;
        macos)
            local cores=$(sysctl -n hw.ncpu)
            local model=$(sysctl -n machdep.cpu.brand_string | cut -c1-40)
            echo "$cores|$model"
            ;;
        *)
            echo "N/A|Unknown CPU"
            ;;
    esac
}

get_docker_info() {
    if command -v docker >/dev/null 2>&1; then
        local running=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
        local total=$(docker ps -aq 2>/dev/null | wc -l | tr -d ' ')
        local keeper=$(docker ps 2>/dev/null | grep -i keeper | wc -l | tr -d ' ')
        echo "$running|$total|$keeper"
    else
        echo "0|0|0"
    fi
}

# Get system info
HOSTNAME=$(hostname)
UPTIME=$(get_uptime)
LOAD=$(get_load)
USERS=$(who | wc -l | tr -d ' ')

# Memory
IFS='|' read -r USED_RAM TOTAL_RAM RAM_PCT <<< "$(get_memory_info)"

# Disk
IFS='|' read -r DISK_USED DISK_TOTAL DISK_PCT <<< "$(get_disk_info)"

# CPU
IFS='|' read -r CPU_CORES CPU_MODEL <<< "$(get_cpu_info)"

# Docker
IFS='|' read -r DOCKER_RUNNING DOCKER_TOTAL KEEPER_SERVICES <<< "$(get_docker_info)"

# Get random security tip
TIPS_FILE="$HOME/.keeper_security_tips.txt"
if [ -f "$TIPS_FILE" ]; then
    if command -v shuf >/dev/null 2>&1; then
        SECURITY_TIP=$(shuf -n 1 "$TIPS_FILE")
    elif command -v gshuf >/dev/null 2>&1; then
        # macOS with GNU coreutils
        SECURITY_TIP=$(gshuf -n 1 "$TIPS_FILE")
    else
        # Fallback for systems without shuf
        SECURITY_TIP=$(sort -R "$TIPS_FILE" 2>/dev/null | head -n 1)
    fi
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

# Platform indicator
case "$PLATFORM" in
    linux)   PLATFORM_ICON="🐧" ;;
    macos)   PLATFORM_ICON="🍎" ;;
    freebsd) PLATFORM_ICON="😈" ;;
    *)       PLATFORM_ICON="💻" ;;
esac

# Clear screen for dramatic effect
clear

# Show Keeper logo
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

# Animated subtitle
echo -e "         ${BWHITE}🔐 SECURITY COMMAND CENTER 🔐${RESET}"
echo ""

# Show vault animation
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
echo ""

# System Info Box
echo -e "${KEEPER_BLUE}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_BLUE}║${RESET}  ${BWHITE}System:${RESET} ${BCYAN}${HOSTNAME}${RESET} ${PLATFORM_ICON} ${DIM}│${RESET} ${BWHITE}Uptime:${RESET} ${GREEN}${UPTIME}${RESET} ${DIM}│${RESET} ${BWHITE}Load:${RESET} ${YELLOW}${LOAD}${RESET} ${DIM}│${RESET} ${BWHITE}Users:${RESET} ${BWHITE}${USERS}${RESET}"
echo -e "${KEEPER_BLUE}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Resource Vault Status
echo -e "${KEEPER_ORANGE}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${KEEPER_ORANGE}║${RESET}  ${BMAGENTA}💾 RESOURCE VAULT STATUS${RESET}                                                  ${KEEPER_ORANGE}║${RESET}"
echo -e "${KEEPER_ORANGE}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
echo -e "${KEEPER_ORANGE}║${RESET}  ${CYAN}RAM:${RESET}     $(progress_bar $RAM_PCT) ${DIM}(${USED_RAM} / ${TOTAL_RAM})${RESET}"
echo -e "${KEEPER_ORANGE}║${RESET}  ${CYAN}Disk:${RESET}    $(progress_bar $DISK_PCT) ${DIM}(${DISK_USED} / ${DISK_TOTAL})${RESET}"
echo -e "${KEEPER_ORANGE}║${RESET}  ${CYAN}CPU:${RESET}     ${BWHITE}${CPU_CORES}${RESET} cores ${DIM}│${RESET} ${DIM}${CPU_MODEL}${RESET}"
echo -e "${KEEPER_ORANGE}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""

# Docker Services (if available)
if [ "$DOCKER_RUNNING" != "0" ] || [ "$DOCKER_TOTAL" != "0" ]; then
    echo -e "${BGREEN}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BGREEN}║${RESET}  ${BMAGENTA}🐳 ACTIVE CONTAINERS${RESET}                                                       ${BGREEN}║${RESET}"
    echo -e "${BGREEN}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${BGREEN}║${RESET}  ${CYAN}Docker:${RESET}         ${BWHITE}${DOCKER_RUNNING}${RESET} running / ${DOCKER_TOTAL} total containers"
    if [ "$KEEPER_SERVICES" != "0" ]; then
        echo -e "${BGREEN}║${RESET}  ${CYAN}Keeper Services:${RESET} ${BGREEN}✓${RESET} ${KEEPER_SERVICES} service(s) ${BGREEN}ACTIVE${RESET}"
    fi
    echo -e "${BGREEN}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
fi

# Security Tip of the Day
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

# Footer with timestamp
echo -e "${DIM}${CYAN}─────────────────────────────────────────────────────────────────────────────${RESET}"
echo -e "${DIM}Access granted at: ${BWHITE}$(date '+%Y-%m-%d %H:%M:%S %Z')${RESET} ${DIM}│ Stay secure! 🔐${RESET}"
echo -e "${DIM}${CYAN}─────────────────────────────────────────────────────────────────────────────${RESET}"
echo ""

# Platform-specific quick commands
echo -e "${BCYAN}Quick Commands:${RESET}"
case "$PLATFORM" in
    macos)
        echo -e "${DIM}  top -o cpu       ${RESET}│ ${DIM}System monitor${RESET}"
        echo -e "${DIM}  df -h           ${RESET}│ ${DIM}Disk usage${RESET}"
        echo -e "${DIM}  docker ps       ${RESET}│ ${DIM}List containers${RESET}"
        ;;
    linux)
        echo -e "${DIM}  htop            ${RESET}│ ${DIM}System monitor${RESET}"
        echo -e "${DIM}  docker ps       ${RESET}│ ${DIM}List containers${RESET}"
        echo -e "${DIM}  systemctl status${RESET}│ ${DIM}Service status${RESET}"
        ;;
    *)
        echo -e "${DIM}  top             ${RESET}│ ${DIM}System monitor${RESET}"
        echo -e "${DIM}  df -h           ${RESET}│ ${DIM}Disk usage${RESET}"
        ;;
esac
echo ""
