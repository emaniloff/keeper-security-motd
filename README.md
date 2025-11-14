# 🔐 Keeper Security MOTD

A colorful, animated login banner (Message of the Day) themed around Keeper Security with daily rotating security tips!

**Cross-platform support:** Linux • macOS • Windows

![Keeper MOTD](https://img.shields.io/badge/security-keeper-orange)
![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-green)

## Features

- **🎨 Colorful ASCII Art** - Beautiful Keeper-branded vault animation
- **💡 Daily Security Tips** - Rotating security advice with humor and education
- **📊 System Metrics** - Real-time resource monitoring (RAM, Disk, CPU)
- **🐳 Container Tracking** - Shows Docker and Keeper service status
- **⚠️ Smart Alerts** - Warnings when system resources run high
- **🖥️ Cross-Platform** - Works on Linux, macOS, and Windows
- **🎯 Quick Commands** - Helpful command suggestions on login

## Preview

```
    ██╗  ██╗███████╗███████╗██████╗ ███████╗██████╗
    ██║ ██╔╝██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗
    █████╔╝ █████╗  █████╗  ██████╔╝█████╗  ██████╔╝
    ██╔═██╗ ██╔══╝  ██╔══╝  ██╔═══╝ ██╔══╝  ██╔══██╗
    ██║  ██╗███████╗███████╗██║     ███████╗██║  ██║
    ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝
              🔐 SECURITY COMMAND CENTER 🔐

              ╔═══════════════════════════╗
              ║    🔒 VAULT: SECURED 🔒   ║
              ║         [LOCKED]          ║
              ║    ═══════════════════    ║
              ║    ◉  ACCESS GRANTED  ◉   ║
              ╚═══════════════════════════╝

╔════════════════════════════════════════════════════════════════════════════╗
║  🛡️  SECURITY TIP OF THE DAY                                                ║
╠════════════════════════════════════════════════════════════════════════════╣
║
║  Your password is not a vintage wine - it doesn't get better with age!
║
╚════════════════════════════════════════════════════════════════════════════╝
```

## Installation

### 🐧 Linux

#### Quick Install
```bash
curl -fsSL https://raw.githubusercontent.com/jlima8900/keeper-security-motd/main/install.sh | bash
```

#### Manual Installation
```bash
git clone https://github.com/jlima8900/keeper-security-motd.git
cd keeper-security-motd
chmod +x install.sh
./install.sh
```

### 🍎 macOS

#### Quick Install
```bash
curl -fsSL https://raw.githubusercontent.com/jlima8900/keeper-security-motd/main/install_macos.sh | bash
```

#### Manual Installation
```bash
git clone https://github.com/jlima8900/keeper-security-motd.git
cd keeper-security-motd
chmod +x install_macos.sh
./install_macos.sh
```

**Note:** macOS users should install GNU coreutils for best experience:
```bash
brew install coreutils
```

### 🪟 Windows

#### PowerShell Installation

1. Download the repository:
```powershell
git clone https://github.com/jlima8900/keeper-security-motd.git
cd keeper-security-motd
```

2. Run the installer (may require execution policy change):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\install_windows.ps1
```

**Requirements:**
- PowerShell 5.0 or higher
- Windows 10+ (for best ANSI color support)
- Windows Terminal recommended for optimal colors

## Platform-Specific Details

### Linux
- Uses bash/zsh for shell integration
- Supports all major distributions (Ubuntu, Debian, RHEL, Arch, etc.)
- System metrics via standard Linux utilities

### macOS
- Compatible with both bash and zsh (default on macOS Catalina+)
- Uses native macOS system calls for metrics
- Optimized for Terminal.app and iTerm2

### Windows
- PowerShell 5.0+ required
- ANSI color support (Windows 10+)
- Best with Windows Terminal
- SSH login support via PowerShell profile

## Configuration

### Custom Security Tips

Edit the tips file to add your own security advice:

**Linux/macOS:**
```bash
nano ~/.keeper_security_tips.txt
```

**Windows:**
```powershell
notepad $env:USERPROFILE\.keeper_security_tips.txt
```

Each tip should be on a new line. Example:
```
Your custom security tip here!
Another funny security reminder
Pro tip: Keep your secrets in Keeper, not on sticky notes!
```

### Customize Colors

Edit the MOTD script to customize colors:

**Linux/macOS:** `~/.keeper_motd.sh`
**Windows:** `$env:USERPROFILE\.keeper_motd.ps1`

Customize these variables:
- `KEEPER_ORANGE` - Primary brand color
- `KEEPER_BLUE` - Secondary brand color
- Progress bar thresholds

### Disable Specific Sections

Comment out sections you don't need in the script:
- Resource monitoring
- Docker statistics
- System information
- Security tips

## Requirements

### Linux/macOS
- Bash 4.0 or higher / Zsh 5.0+
- Standard Unix utilities (free, df, uptime)
- Docker (optional, for container stats)
- Terminal with 256-color support (recommended)

### Windows
- PowerShell 5.0 or higher
- Windows 10+ (for ANSI color support)
- Docker Desktop (optional, for container stats)
- Windows Terminal (recommended)

## Security Tips Collection

The project includes 25+ security tips covering:
- Password management best practices
- Multi-factor authentication (2FA)
- Phishing awareness
- SSH key security
- IoT device security
- VPN usage
- Zero-trust principles
- Keeper Security features
- And more!

## Uninstallation

### Linux/macOS
```bash
./uninstall.sh
```

### Windows
```powershell
# Remove files manually
Remove-Item $env:USERPROFILE\.keeper_motd.ps1
Remove-Item $env:USERPROFILE\.keeper_security_tips.txt

# Edit PowerShell profile to remove MOTD call
notepad $PROFILE
```

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Contribution Ideas
1. Add new security tips
2. Improve platform compatibility
3. Add new metrics/features
4. Submit bug fixes
5. Improve documentation

## Troubleshooting

### Colors not showing (Windows)
- Use Windows Terminal instead of CMD
- Ensure Windows 10+ with ANSI support
- Check execution policy settings

### Colors not showing (Linux/macOS)
- Verify 256-color terminal support: `echo $TERM`
- Try: `export TERM=xterm-256color`

### MOTD not appearing on login
- Check shell configuration file sourcing
- Verify script is executable: `ls -l ~/.keeper_motd.sh`
- Check for errors: `~/.keeper_motd.sh`

### macOS: Tips not rotating
- Install GNU coreutils: `brew install coreutils`

## License

MIT License - see [LICENSE](LICENSE) file for details

## Credits

Created with love for the Keeper Security community.

## Related Projects

- [Keeper Security](https://www.keepersecurity.com/) - Official Keeper Security website
- [Keeper Commander](https://github.com/Keeper-Security/Commander) - Keeper's command-line tool

## Screenshots

### Linux Terminal
![Linux Preview](https://via.placeholder.com/800x400?text=Linux+Terminal+Preview)

### macOS Terminal
![macOS Preview](https://via.placeholder.com/800x400?text=macOS+Terminal+Preview)

### Windows PowerShell
![Windows Preview](https://via.placeholder.com/800x400?text=Windows+PowerShell+Preview)

## Support

If you find this useful:
- ⭐ Star this repository
- 🐛 Report bugs via [Issues](https://github.com/jlima8900/keeper-security-motd/issues)
- 💡 Suggest new features or security tips
- 🔄 Share with your team!

## Platform Support Matrix

| Feature | Linux | macOS | Windows |
|---------|-------|-------|---------|
| ASCII Art | ✅ | ✅ | ✅ |
| Security Tips | ✅ | ✅ | ✅ |
| RAM Monitoring | ✅ | ✅ | ✅ |
| Disk Monitoring | ✅ | ✅ | ✅ |
| CPU Info | ✅ | ✅ | ✅ |
| Docker Stats | ✅ | ✅ | ✅ |
| Color Support | ✅ | ✅ | ⚠️ (Win10+) |
| Auto-install | ✅ | ✅ | ⚠️ (Manual) |

---

**Stay Secure! 🔐**

Made with ❤️ for better SSH security awareness across all platforms
