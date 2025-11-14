# 🔐 Keeper Security MOTD

A colorful, animated SSH login banner (Message of the Day) themed around Keeper Security with daily rotating security tips!

![Keeper MOTD](https://img.shields.io/badge/security-keeper-orange)
![License](https://img.shields.io/badge/license-MIT-blue)
![Bash](https://img.shields.io/badge/bash-5.0+-green)

## Features

- **🎨 Colorful ASCII Art** - Beautiful Keeper-branded vault animation
- **💡 Daily Security Tips** - Rotating security advice with humor and education
- **📊 System Metrics** - Real-time resource monitoring (RAM, Disk, CPU)
- **🐳 Container Tracking** - Shows Docker and Keeper service status
- **⚠️ Smart Alerts** - Warnings when system resources run high
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

### Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/keeper-security-motd/main/install.sh | bash
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/keeper-security-motd.git
cd keeper-security-motd
```

2. Run the installation script:
```bash
chmod +x install.sh
./install.sh
```

3. Or manually copy files:
```bash
# Copy the script
cp keeper_motd.sh ~/.keeper_motd.sh
chmod +x ~/.keeper_motd.sh

# Copy security tips
cp security_tips.txt ~/.keeper_security_tips.txt

# Add to your shell profile
echo '
# Display Keeper Security MOTD on login
if [ -n "$PS1" ] && [ -f ~/.keeper_motd.sh ]; then
    ~/.keeper_motd.sh
fi' >> ~/.bashrc  # or ~/.zshrc
```

## Configuration

### Custom Security Tips

Edit `~/.keeper_security_tips.txt` to add your own security tips! Each tip should be on a new line.

Example:
```
Your custom security tip here!
Another funny security reminder
Pro tip: Keep your secrets in Keeper, not on sticky notes!
```

### Customize Colors

The script uses ANSI color codes. Edit `keeper_motd.sh` to customize:
- `KEEPER_ORANGE` - Primary brand color
- `KEEPER_BLUE` - Secondary brand color
- `KEEPER_DARK` - Accent color

### Disable Specific Sections

Comment out sections in `keeper_motd.sh` you don't need:
- Resource monitoring
- Docker statistics
- System information
- Security tips

## Requirements

- Bash 4.0 or higher
- Standard Unix utilities (free, df, uptime, docker)
- Terminal with 256-color support (recommended)

## Security Tips Collection

The project includes 25+ security tips covering:
- Password management
- Multi-factor authentication (2FA)
- Phishing awareness
- SSH key security
- IoT device security
- VPN usage
- Zero-trust principles
- And more!

## Contributing

We welcome contributions! Here's how:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-tip`)
3. Add your security tips or improvements
4. Commit your changes (`git commit -m 'Add amazing security tip'`)
5. Push to the branch (`git push origin feature/amazing-tip`)
6. Open a Pull Request

### Adding Security Tips

To add new tips, edit `security_tips.txt` and follow these guidelines:
- Keep it concise (one line per tip)
- Make it memorable (humor helps!)
- Focus on actionable advice
- Reference Keeper when relevant

## License

MIT License - see [LICENSE](LICENSE) file for details

## Credits

Created with love for the Keeper Security community.

## Related Projects

- [Keeper Security](https://www.keepersecurity.com/) - Official Keeper Security website
- [Keeper Commander](https://github.com/Keeper-Security/Commander) - Keeper's command-line tool

## Support

If you find this useful:
- ⭐ Star this repository
- 🐛 Report bugs via [Issues](https://github.com/YOUR_USERNAME/keeper-security-motd/issues)
- 💡 Suggest new features or security tips
- 🔄 Share with your team!

---

**Stay Secure! 🔐**

Made with ❤️ for better SSH security awareness
