# Keeper Security MOTD - Windows PowerShell Installation Script
# Run this script in PowerShell as Administrator (optional) or regular user

# Enable strict mode
$ErrorActionPreference = "Stop"

# Colors
$CYAN = "`e[0;36m"
$GREEN = "`e[0;32m"
$YELLOW = "`e[1;33m"
$RED = "`e[0;31m"
$MAGENTA = "`e[0;35m"
$BWHITE = "`e[1;37m"
$RESET = "`e[0m"

Write-Host "${CYAN}"
Write-Host @"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║    Keeper Security MOTD - Windows Installer           ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
"@
Write-Host "${RESET}"
Write-Host ""

Write-Host "${GREEN}Installing Keeper Security MOTD for Windows...${RESET}"
Write-Host ""

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "${RED}❌ PowerShell 5.0 or higher required!${RESET}"
    Write-Host "${YELLOW}Please upgrade PowerShell: https://aka.ms/powershell${RESET}"
    exit 1
}

# Installation directory
$installDir = $env:USERPROFILE
$motdScript = ".keeper_motd.ps1"
$tipsFile = ".keeper_security_tips.txt"

# Backup existing files
if (Test-Path "$installDir\$motdScript") {
    Write-Host "${YELLOW}Backing up existing MOTD script...${RESET}"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Move-Item "$installDir\$motdScript" "$installDir\$motdScript.backup.$timestamp" -Force
}

if (Test-Path "$installDir\$tipsFile") {
    Write-Host "${YELLOW}Backing up existing tips file...${RESET}"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Move-Item "$installDir\$tipsFile" "$installDir\$tipsFile.backup.$timestamp" -Force
}

# Copy files
Write-Host "${GREEN}Installing MOTD script...${RESET}"
Copy-Item "keeper_motd.ps1" "$installDir\$motdScript" -Force

Write-Host "${GREEN}Installing security tips...${RESET}"
Copy-Item "security_tips.txt" "$installDir\$tipsFile" -Force

# Configure PowerShell profile
$profilePath = $PROFILE.CurrentUserAllHosts
if (-not $profilePath) {
    $profilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}

# Create profile directory if it doesn't exist
$profileDir = Split-Path -Parent $profilePath
if (-not (Test-Path $profileDir)) {
    Write-Host "${GREEN}Creating PowerShell profile directory...${RESET}"
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

Write-Host ""
Write-Host "${CYAN}PowerShell profile: $profilePath${RESET}"

# Check if already configured
if (Test-Path $profilePath) {
    $profileContent = Get-Content $profilePath -Raw
    if ($profileContent -match "keeper_motd") {
        Write-Host "${YELLOW}MOTD already configured in PowerShell profile${RESET}"
    } else {
        Write-Host "${GREEN}Adding MOTD to PowerShell profile...${RESET}"
        Add-Content -Path $profilePath -Value @"

# Display Keeper Security MOTD on login
if (Test-Path "`$env:USERPROFILE\.keeper_motd.ps1") {
    & "`$env:USERPROFILE\.keeper_motd.ps1"
}
"@
    }
} else {
    Write-Host "${GREEN}Creating PowerShell profile with MOTD...${RESET}"
    Set-Content -Path $profilePath -Value @"
# Display Keeper Security MOTD on login
if (Test-Path "`$env:USERPROFILE\.keeper_motd.ps1") {
    & "`$env:USERPROFILE\.keeper_motd.ps1"
}
"@
}

# Check execution policy
Write-Host ""
Write-Host "${CYAN}Checking PowerShell execution policy...${RESET}"
$executionPolicy = Get-ExecutionPolicy -Scope CurrentUser

if ($executionPolicy -eq "Restricted" -or $executionPolicy -eq "AllSigned") {
    Write-Host "${YELLOW}⚠️  Current execution policy: $executionPolicy${RESET}"
    Write-Host "${YELLOW}MOTD requires RemoteSigned or Unrestricted policy${RESET}"
    Write-Host ""

    $response = Read-Host "Would you like to set ExecutionPolicy to RemoteSigned for current user? (Y/N)"
    if ($response -eq "Y" -or $response -eq "y") {
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Host "${GREEN}✅ Execution policy updated to RemoteSigned${RESET}"
        } catch {
            Write-Host "${RED}❌ Failed to update execution policy. Please run manually:${RESET}"
            Write-Host "${YELLOW}Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser${RESET}"
        }
    } else {
        Write-Host "${YELLOW}Please update execution policy manually:${RESET}"
        Write-Host "${YELLOW}Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser${RESET}"
    }
} else {
    Write-Host "${GREEN}✅ Execution policy is compatible: $executionPolicy${RESET}"
}

# Enable ANSI colors in Windows Terminal (Windows 10+)
Write-Host ""
Write-Host "${CYAN}Enabling ANSI color support...${RESET}"
try {
    # Set registry key for ANSI color support
    $registryPath = "HKCU:\Console"
    if (Test-Path $registryPath) {
        Set-ItemProperty -Path $registryPath -Name "VirtualTerminalLevel" -Value 1 -Type DWord -ErrorAction SilentlyContinue
        Write-Host "${GREEN}✅ ANSI colors enabled${RESET}"
    }
} catch {
    Write-Host "${YELLOW}⚠️  Could not enable ANSI colors automatically${RESET}"
    Write-Host "${YELLOW}Use Windows Terminal for best color support${RESET}"
}

# Test installation
Write-Host ""
Write-Host "${MAGENTA}Testing installation...${RESET}"
if (Test-Path "$installDir\$motdScript") {
    Write-Host "${GREEN}✅ Installation successful!${RESET}"
} else {
    Write-Host "${RED}❌ Installation failed${RESET}"
    exit 1
}

# Show preview
Write-Host ""
Write-Host "${CYAN}Preview of your new MOTD:${RESET}"
Write-Host "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
& "$installDir\$motdScript"

Write-Host ""
Write-Host "${GREEN}╔═══════════════════════════════════════════════════════╗${RESET}"
Write-Host "${GREEN}║                                                       ║${RESET}"
Write-Host "${GREEN}║         Installation Complete! 🎉                     ║${RESET}"
Write-Host "${GREEN}║                                                       ║${RESET}"
Write-Host "${GREEN}╚═══════════════════════════════════════════════════════╝${RESET}"
Write-Host ""
Write-Host "${CYAN}Next steps:${RESET}"
Write-Host "  1. Open a new PowerShell window to see the MOTD"
Write-Host "  2. Or run: ${YELLOW}. `$PROFILE${RESET}"
Write-Host "  3. Customize tips: ${YELLOW}notepad `$env:USERPROFILE\.keeper_security_tips.txt${RESET}"
Write-Host "  4. Use Windows Terminal for best color support"
Write-Host ""
Write-Host "${MAGENTA}Stay Secure! 🔐${RESET}"
Write-Host ""
