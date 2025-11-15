# 🔐 Keeper Security MOTD

An animated, colorful Message of the Day (MOTD) system themed around Keeper Security with daily rotating security tips featuring dad-joke style humor!

![Keeper MOTD](https://img.shields.io/badge/security-keeper-orange)
![Platform](https://img.shields.io/badge/platform-Linux-green)
![Tips](https://img.shields.io/badge/security_tips-251-blue)
![Shell](https://img.shields.io/badge/shell-bash-brightgreen)

## ✨ Features

- **🎨 Animated ASCII Logo** - Gradient color animation with Keeper golden yellow and black
- **🔓 Vault Unlocking Animation** - Dynamic credential verification sequence
- **💡 251 Security Tips** - Keeper-themed dad jokes and security awareness
- **📊 Real-Time System Metrics** - RAM, Disk, CPU, and Uptime monitoring
- **🐳 Docker Container Tracking** - Live container and Keeper service status
- **🔌 Connection Status** - SSH sessions, tmux, network interfaces
- **📈 Activity Dashboard** - Git commits, shell history, docker events
- **🎯 Quick Commands** - Helpful shortcuts displayed on every login
- **🎨 Keeper Brand Colors** - Golden yellow (#220) and black (#232) throughout
- **⚡ Loading Animations** - Smooth transitions between sections

## 🎬 What It Looks Like

When you SSH into your server, you'll see:

1. **Animated Keeper Logo** with gradient color transition (golden yellow → black)
2. **Vault Unlocking Sequence** with credential verification animation
3. **System Status** - Hostname, uptime, load average, active users
4. **Resource Vault Status** - RAM/Disk/CPU with visual progress bars
5. **Active Containers** - Docker and Keeper service counts
6. **Projects & Automation** - Current git project, branch status
7. **Connection & Security Status** - SSH sessions, last login, network info
8. **Recent Activity** - Shell commands, git commits, docker events
9. **Quick Commands** - Handy shortcuts for keeper-status, docker, git, etc.
10. **Motivational Quote** - Security-focused inspiration
11. **Security Tip of the Day** - One of 251 Keeper-themed dad jokes!

## 📦 Installation

### Linux (Bash/Zsh)

1. **Clone the repository:**
```bash
git clone https://github.com/jlima8900/keeper-security-motd.git
cd keeper-security-motd
```

2. **Copy files to home directory:**
```bash
cp keeper_motd_enhanced.sh ~/.keeper_motd.sh
cp security_tips.txt ~/.keeper_security_tips.txt
chmod +x ~/.keeper_motd.sh
```

3. **Add to your shell login:**

For **Bash** users (add to `~/.bashrc` or `~/.bash_profile`):
```bash
if [ -f "$HOME/.keeper_motd.sh" ]; then
    bash "$HOME/.keeper_motd.sh"
fi
```

For **Zsh** users (add to `~/.zshrc` or `~/.zlogin`):
```bash
if [ -f "$HOME/.keeper_motd.sh" ]; then
    bash "$HOME/.keeper_motd.sh"
fi
```

For **Zsh with custom ZDOTDIR** (add to `~/.config/zsh/.zlogin`):
```bash
if [ -f "$HOME/.keeper_motd.sh" ]; then
    bash "$HOME/.keeper_motd.sh"
fi
```

4. **(Optional) Disable system MOTD:**
```bash
sudo cp /etc/motd /etc/motd.backup
sudo truncate -s 0 /etc/motd
```

5. **Test it:**
```bash
bash ~/.keeper_motd.sh
```

## 🎨 Customization

### Add Your Own Security Tips

Edit the tips file:
```bash
nano ~/.keeper_security_tips.txt
```

Each tip should be on a new line. Keep them Keeper-themed and family-friendly!

Example:
```
Why did the password manager go to therapy? It had too many secrets to keep!
Keeper's vault is like Fort Knox, but with better UI and zero-knowledge encryption!
```

### Modify Colors

Edit `~/.keeper_motd.sh` and adjust these color codes:

```bash
KEEPER_GOLD="\033[38;5;220m"    # Keeper primary golden yellow
KEEPER_BLACK="\033[38;5;232m"   # Keeper secondary black
BGREEN="\033[1;32m"             # Bright green for success
BYELLOW="\033[1;33m"            # Bright yellow for warnings
```

### Customize Sections

Comment out sections you don't need in `~/.keeper_motd.sh`:
- System status
- Resource monitoring
- Container tracking
- Projects & automation
- Activity dashboard
- Quick commands
- Security tips

## 📁 File Structure

```
keeper-security-motd/
├── keeper_motd_enhanced.sh    # Main MOTD script with animations
├── security_tips.txt          # 251 Keeper-themed security tips
└── README.md                  # This file
```

## 🛡️ Security Tips Collection

The project includes **251 security tips** covering:

- **Password Management** - Best practices with Keeper
- **Zero-Knowledge Architecture** - How Keeper protects your data
- **Keeper Products** - Commander, KeeperChat, KeeperFill, Secrets Manager
- **PAM & Privileged Access** - Enterprise security features
- **Breach Watch** - Dark web monitoring
- **2FA/MFA** - Multi-factor authentication
- **Phishing Awareness** - Social engineering protection
- **Compliance** - HIPAA, SOC 2, GDPR
- **DevOps Security** - Secrets management for developers

All tips feature **dad-joke style humor** while delivering security awareness!

## 💻 Requirements

- **Linux** - Any distribution (tested on CentOS/RHEL)
- **Bash** 4.0+ or **Zsh** 5.0+
- **256-color terminal** support (most modern terminals)
- **Docker** (optional - for container stats)
- **Git** (optional - for project tracking)
- Standard utilities: `free`, `df`, `uptime`, `awk`, `grep`

## 🎯 Tested On

- CentOS/RHEL 9
- SSH login via Zsh
- Docker environments
- Tmux sessions
- Multiple concurrent SSH connections

## 🐛 Troubleshooting

### MOTD not showing on SSH login

1. Check your shell configuration:
```bash
# For bash
cat ~/.bashrc | grep keeper_motd

# For zsh (if ZDOTDIR is set)
cat ~/.config/zsh/.zlogin | grep keeper_motd
```

2. Verify script is executable:
```bash
ls -l ~/.keeper_motd.sh
chmod +x ~/.keeper_motd.sh
```

3. Test manually:
```bash
bash ~/.keeper_motd.sh
```

### Colors not displaying

1. Check terminal color support:
```bash
echo $TERM
# Should show something like: xterm-256color
```

2. Set terminal to 256-color mode:
```bash
export TERM=xterm-256color
```

### System MOTD still showing

Disable the system MOTD:
```bash
sudo truncate -s 0 /etc/motd
```

### Tips not rotating

Check the tips file exists and is readable:
```bash
ls -l ~/.keeper_security_tips.txt
cat ~/.keeper_security_tips.txt | wc -l  # Should show 251
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Add more security tips** - Submit PRs with new Keeper-themed jokes
2. **Improve animations** - Enhance visual effects
3. **Add features** - New metrics, dashboards, or integrations
4. **Bug fixes** - Report and fix issues
5. **Documentation** - Improve installation guides

## 📝 Recent Changes

- **v1.2** - Moved Security Tip to bottom of MOTD
- **v1.1** - Expanded to 251 security tips with dad-joke style humor
- **v1.0** - Added animations: gradient logo, vault unlocking, loading effects
- **v0.9** - Initial release with basic MOTD and 25 tips

## 📜 License

MIT License - Feel free to use and modify for your own systems!

## 🙏 Credits

- **Keeper Security** - Inspiration and branding
- **ASCII Art** - Custom Keeper logo design
- **Security Tips** - Community-contributed humor and awareness

## 🔗 Related Projects

- [Keeper Security](https://www.keepersecurity.com/) - Official Keeper Security website
- [Keeper Commander](https://github.com/Keeper-Security/Commander) - CLI tool for Keeper

## 💬 Support

- ⭐ **Star this repo** if you find it useful!
- 🐛 **Report bugs** via [GitHub Issues](https://github.com/jlima8900/keeper-security-motd/issues)
- 💡 **Suggest features** or submit new security tips
- 🔄 **Share** with your team and security community

## 📊 Statistics

- **251** security tips and counting
- **~400 lines** of bash animation code
- **10+ sections** of system information
- **3 animations**: logo gradient, vault unlock, loading sequences
- **2 brand colors**: Keeper golden yellow (#220) and black (#232)

---

**Stay Secure! 🔐**

*Making SSH logins more secure and entertaining, one dad joke at a time.*
