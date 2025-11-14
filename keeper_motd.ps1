# Keeper Security MOTD - PowerShell Version (Windows)
# Cross-platform SSH/PowerShell login banner with security tips

# ANSI Color Codes (requires Windows 10+ with ANSI support enabled)
function Enable-AnsiColors {
    # Enable ANSI escape sequences in Windows Console
    if ($PSVersionTable.PSVersion.Major -ge 5) {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    }
}

Enable-AnsiColors

# Color definitions
$RESET = "`e[0m"
$BOLD = "`e[1m"
$DIM = "`e[2m"
$BLINK = "`e[5m"

# Standard Colors
$RED = "`e[0;31m"
$GREEN = "`e[0;32m"
$YELLOW = "`e[0;33m"
$BLUE = "`e[0;34m"
$MAGENTA = "`e[0;35m"
$CYAN = "`e[0;36m"
$WHITE = "`e[0;37m"

# Bold Colors
$BRED = "`e[1;31m"
$BGREEN = "`e[1;32m"
$BYELLOW = "`e[1;33m"
$BBLUE = "`e[1;34m"
$BMAGENTA = "`e[1;35m"
$BCYAN = "`e[1;36m"
$BWHITE = "`e[1;37m"

# Keeper Brand Colors
$KEEPER_ORANGE = "`e[38;5;208m"
$KEEPER_BLUE = "`e[38;5;33m"

# Get system information
$hostname = $env:COMPUTERNAME
$uptime = (Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime
$uptimeStr = "{0}d {1}h {2}m" -f $uptime.Days, $uptime.Hours, $uptime.Minutes
$users = (quser 2>$null | Measure-Object -Line).Lines - 1
if ($users -lt 0) { $users = 1 }

# Memory info
$memory = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 1)
$freeRAM = [math]::Round($memory.FreePhysicalMemory / 1MB, 1)
$usedRAM = [math]::Round($totalRAM - $freeRAM, 1)
$ramPct = [math]::Round(($usedRAM / $totalRAM) * 100)

# Disk info
$disk = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -eq 'C' } | Select-Object Used, Free
$totalDisk = [math]::Round(($disk.Used + $disk.Free) / 1GB, 1)
$usedDisk = [math]::Round($disk.Used / 1GB, 1)
$diskPct = [math]::Round(($usedDisk / $totalDisk) * 100)

# CPU info
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$cpuCores = $cpu.NumberOfLogicalProcessors
$cpuModel = $cpu.Name.Trim().Substring(0, [Math]::Min(40, $cpu.Name.Length))

# Docker info (if available)
$dockerRunning = 0
$dockerTotal = 0
$keeperServices = 0
if (Get-Command docker -ErrorAction SilentlyContinue) {
    try {
        $dockerRunning = (docker ps -q 2>$null | Measure-Object).Count
        $dockerTotal = (docker ps -aq 2>$null | Measure-Object).Count
        $keeperServices = (docker ps 2>$null | Select-String -Pattern "keeper" -CaseSensitive:$false | Measure-Object).Count
    } catch {
        # Docker not running
    }
}

# Get random security tip
$tipsFile = "$env:USERPROFILE\.keeper_security_tips.txt"
if (Test-Path $tipsFile) {
    $tips = Get-Content $tipsFile
    $securityTip = $tips | Get-Random
} else {
    $securityTip = "Keeper Security: Your digital vault in the cloud. Stay secure!"
}

# Progress bar function
function Get-ProgressBar {
    param(
        [int]$percentage,
        [int]$width = 25
    )

    $filled = [math]::Floor($percentage * $width / 100)
    $empty = $width - $filled

    # Color based on usage
    if ($percentage -ge 90) {
        $color = $BRED
    } elseif ($percentage -ge 75) {
        $color = $BYELLOW
    } else {
        $color = $BGREEN
    }

    $bar = $color + "[" + ("█" * $filled) + ("░" * $empty) + "] $percentage%$RESET"
    return $bar
}

# Clear screen
Clear-Host

# Show Keeper logo
Write-Host "${KEEPER_ORANGE}"
Write-Host @"
    ██╗  ██╗███████╗███████╗██████╗ ███████╗██████╗
    ██║ ██╔╝██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗
    █████╔╝ █████╗  █████╗  ██████╔╝█████╗  ██████╔╝
    ██╔═██╗ ██╔══╝  ██╔══╝  ██╔═══╝ ██╔══╝  ██╔══██╗
    ██║  ██╗███████╗███████╗██║     ███████╗██║  ██║
    ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝
"@
Write-Host "${RESET}"

Write-Host "         ${BWHITE}🔐 SECURITY COMMAND CENTER 🔐${RESET}"
Write-Host ""

# Show vault
Write-Host "${KEEPER_ORANGE}"
Write-Host @"
              ╔═══════════════════════════╗
              ║    🔒 VAULT: SECURED 🔒   ║
              ║         [LOCKED]          ║
              ║    ═══════════════════    ║
              ║    ◉  ACCESS GRANTED  ◉   ║
              ╚═══════════════════════════╝
"@
Write-Host "${RESET}"
Write-Host ""

# System Info Box
Write-Host "${KEEPER_BLUE}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${KEEPER_BLUE}║${RESET}  ${BWHITE}System:${RESET} ${BCYAN}${hostname}${RESET} 🪟 ${DIM}│${RESET} ${BWHITE}Uptime:${RESET} ${GREEN}${uptimeStr}${RESET} ${DIM}│${RESET} ${BWHITE}Users:${RESET} ${BWHITE}${users}${RESET}"
Write-Host "${KEEPER_BLUE}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

# Resource Vault Status
Write-Host "${KEEPER_ORANGE}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${KEEPER_ORANGE}║${RESET}  ${BMAGENTA}💾 RESOURCE VAULT STATUS${RESET}                                                  ${KEEPER_ORANGE}║${RESET}"
Write-Host "${KEEPER_ORANGE}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
Write-Host "${KEEPER_ORANGE}║${RESET}  ${CYAN}RAM:${RESET}     $(Get-ProgressBar $ramPct) ${DIM}(${usedRAM}GB / ${totalRAM}GB)${RESET}"
Write-Host "${KEEPER_ORANGE}║${RESET}  ${CYAN}Disk:${RESET}    $(Get-ProgressBar $diskPct) ${DIM}(${usedDisk}GB / ${totalDisk}GB)${RESET}"
Write-Host "${KEEPER_ORANGE}║${RESET}  ${CYAN}CPU:${RESET}     ${BWHITE}${cpuCores}${RESET} cores ${DIM}│${RESET} ${DIM}${cpuModel}${RESET}"
Write-Host "${KEEPER_ORANGE}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

# Docker Services (if available)
if ($dockerRunning -gt 0 -or $dockerTotal -gt 0) {
    Write-Host "${BGREEN}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
    Write-Host "${BGREEN}║${RESET}  ${BMAGENTA}🐳 ACTIVE CONTAINERS${RESET}                                                       ${BGREEN}║${RESET}"
    Write-Host "${BGREEN}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
    Write-Host "${BGREEN}║${RESET}  ${CYAN}Docker:${RESET}         ${BWHITE}${dockerRunning}${RESET} running / ${dockerTotal} total containers"
    if ($keeperServices -gt 0) {
        Write-Host "${BGREEN}║${RESET}  ${CYAN}Keeper Services:${RESET} ${BGREEN}✓${RESET} ${keeperServices} service(s) ${BGREEN}ACTIVE${RESET}"
    }
    Write-Host "${BGREEN}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
    Write-Host ""
}

# Security Tip of the Day
Write-Host "${BYELLOW}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BYELLOW}║${RESET}  ${BLINK}${BMAGENTA}🛡️  SECURITY TIP OF THE DAY${RESET}                                                ${BYELLOW}║${RESET}"
Write-Host "${BYELLOW}╠════════════════════════════════════════════════════════════════════════════╣${RESET}"
Write-Host "${BYELLOW}║${RESET}"
Write-Host "${BYELLOW}║${RESET}  ${BWHITE}${securityTip}${RESET}"
Write-Host "${BYELLOW}║${RESET}"
Write-Host "${BYELLOW}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

# Warnings if resources are critical
if ($ramPct -ge 85 -or $diskPct -ge 85) {
    Write-Host "${BRED}⚠️  ${BWHITE}WARNING: System resources running high!${RESET} ${BRED}⚠️${RESET}"
    Write-Host ""
}

# Footer with timestamp
Write-Host "${DIM}${CYAN}─────────────────────────────────────────────────────────────────────────────${RESET}"
Write-Host "${DIM}Access granted at: ${BWHITE}$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')${RESET} ${DIM}│ Stay secure! 🔐${RESET}"
Write-Host "${DIM}${CYAN}─────────────────────────────────────────────────────────────────────────────${RESET}"
Write-Host ""

# Quick Commands
Write-Host "${BCYAN}Quick Commands:${RESET}"
Write-Host "${DIM}  Get-Process | Sort-Object CPU -Descending | Select-Object -First 10${RESET}"
Write-Host "${DIM}  Get-PSDrive -PSProvider FileSystem${RESET}"
Write-Host "${DIM}  docker ps${RESET}"
Write-Host ""
