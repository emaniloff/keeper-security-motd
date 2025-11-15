# Terminal Enhancements for Keeper MOTD

Optional open-source tools to supercharge your Keeper Security MOTD experience!

## 🎨 Quick Enhancement Guide

### Tier 1: Essential Enhancements (Highly Recommended)

#### 1. **Gum** - Glamorous Shell Scripts
The best way to enhance your MOTD with modern styling!

**Install:**
```bash
# macOS
brew install gum

# Linux (from binary)
curl -sL https://github.com/charmbracelet/gum/releases/latest/download/gum_Linux_x86_64.tar.gz | tar xz
sudo mv gum /usr/local/bin/

# Arch Linux
sudo pacman -S gum

# Ubuntu/Debian (via deb package)
wget https://github.com/charmbracelet/gum/releases/latest/download/gum_Linux_amd64.deb
sudo dpkg -i gum_Linux_amd64.deb
```

**Features:**
- Beautiful borders and boxes
- Styled text with gradients
- Interactive menus
- Progress indicators
- Input prompts

#### 2. **Lolcat** - Rainbow Text
Add beautiful rainbow gradients to any text!

**Install:**
```bash
# macOS
brew install lolcat

# Linux
gem install lolcat
# Or: sudo apt install lolcat (Ubuntu/Debian)
# Or: sudo pacman -S lolcat (Arch)

# Without Ruby (Rust version - faster!)
cargo install lolcat
```

**Usage in MOTD:**
```bash
figlet "KEEPER" | lolcat
echo "Security matters!" | lolcat
```

#### 3. **Duf** - Modern Disk Usage
Beautiful disk usage display (better than df)

**Install:**
```bash
# macOS
brew install duf

# Linux
wget https://github.com/muesli/duf/releases/latest/download/duf_linux_amd64.deb
sudo dpkg -i duf_linux_amd64.deb

# Arch
sudo pacman -S duf
```

### Tier 2: Visual Enhancements

#### 4. **Toilet** - Enhanced Figlet
ASCII art with colors and filters

**Install:**
```bash
# macOS
brew install toilet

# Linux
sudo apt install toilet        # Ubuntu/Debian
sudo pacman -S toilet          # Arch
sudo dnf install toilet        # Fedora/RHEL
```

**Usage:**
```bash
toilet -f bigmono9 "KEEPER" --gay      # Rainbow
toilet -f bigmono9 "KEEPER" --metal    # Metal effect
toilet -f future "SECURITY"            # Different font
```

#### 5. **Boxes** - ASCII Art Boxes
Draw boxes around text

**Install:**
```bash
# macOS
brew install boxes

# Linux
sudo apt install boxes         # Ubuntu/Debian
sudo pacman -S boxes          # Arch
```

**Usage:**
```bash
echo "Important message" | boxes -d stone
echo "Security tip" | boxes -d peek
```

#### 6. **Figlet** - Classic ASCII Text
Standard ASCII art text generator

**Install:**
```bash
# macOS
brew install figlet

# Linux (usually pre-installed)
sudo apt install figlet        # Ubuntu/Debian
sudo pacman -S figlet         # Arch
```

**Advanced Usage:**
```bash
# List available fonts
figlet -l

# Use different fonts
figlet -f slant "KEEPER"
figlet -f banner "SECURITY"
```

### Tier 3: System Monitoring Upgrades

#### 7. **btop++** - Beautiful System Monitor
Modern, colorful system monitor

**Install:**
```bash
# macOS
brew install btop

# Linux
sudo apt install btop          # Ubuntu 22.04+
# Or from snap:
sudo snap install btop

# Arch
sudo pacman -S btop
```

#### 8. **Procs** - Modern Process Viewer
Colored process viewer (better than ps)

**Install:**
```bash
# macOS
brew install procs

# Linux
cargo install procs
# Or download binary from: https://github.com/dalance/procs/releases
```

#### 9. **Fastfetch** - Fast System Info
Faster alternative to neofetch

**Install:**
```bash
# macOS
brew install fastfetch

# Linux
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update && sudo apt install fastfetch
```

### Tier 4: Charm.sh Full Ecosystem

#### 10. **Glow** - Markdown Renderer
Render markdown files beautifully in terminal

**Install:**
```bash
# macOS
brew install glow

# Linux
wget https://github.com/charmbracelet/glow/releases/latest/download/glow_linux_x86_64.tar.gz
tar xzf glow_linux_x86_64.tar.gz
sudo mv glow /usr/local/bin/
```

**Usage:**
```bash
# Display security tips from markdown
glow security_tips.md

# Pipe markdown
echo "# Keeper Security" | glow -
```

#### 11. **VHS** - Terminal Recorder
Record terminal sessions as GIFs

**Install:**
```bash
# macOS
brew install vhs

# Linux
go install github.com/charmbracelet/vhs@latest
```

#### 12. **Soft Serve** - Git Server in Terminal
Self-hosted Git server with TUI

**Install:**
```bash
# macOS
brew install soft-serve

# Linux
go install github.com/charmbracelet/soft-serve/cmd/soft@latest
```

### Tier 5: Fun Extras

#### 13. **Cowsay/Ponysay**
ASCII animals with speech bubbles

**Install:**
```bash
# macOS
brew install cowsay

# Linux
sudo apt install cowsay
sudo apt install ponysay  # Ponies version!
```

**Usage:**
```bash
echo "Keep your secrets safe!" | cowsay
fortune | ponysay
```

#### 14. **jp2a** - Image to ASCII
Convert images to ASCII art

**Install:**
```bash
# macOS
brew install jp2a

# Linux
sudo apt install jp2a
```

**Usage:**
```bash
jp2a --colors keeper_logo.png
```

#### 15. **cmatrix** - Matrix Effect
The Matrix screensaver

**Install:**
```bash
# macOS
brew install cmatrix

# Linux
sudo apt install cmatrix
```

## 📦 Quick Install Scripts

### Install All Enhancements (macOS)
```bash
#!/bin/bash
brew install gum lolcat duf toilet boxes figlet btop procs fastfetch glow cowsay jp2a cmatrix
echo "✅ All enhancements installed!"
```

### Install Essential (Linux - Ubuntu/Debian)
```bash
#!/bin/bash
# Essential tools
curl -sL https://github.com/charmbracelet/gum/releases/latest/download/gum_Linux_amd64.deb -o gum.deb
sudo dpkg -i gum.deb
sudo gem install lolcat
wget https://github.com/muesli/duf/releases/latest/download/duf_linux_amd64.deb
sudo dpkg -i duf_linux_amd64.deb

# Visual tools
sudo apt install -y toilet boxes figlet

echo "✅ Essential enhancements installed!"
```

### Install Essential (Arch Linux)
```bash
#!/bin/bash
sudo pacman -S gum lolcat duf toilet boxes figlet btop procs
echo "✅ Essential enhancements installed!"
```

## 🎨 Enhancement Examples

### Rainbow Keeper Logo
```bash
#!/bin/bash
toilet -f bigmono9 "KEEPER" | lolcat -F 0.3
```

### Styled Security Tip
```bash
#!/bin/bash
gum style \
  --foreground 212 --border-foreground 212 --border rounded \
  --width 60 --padding "1 2" \
  "🛡️ Security Tip" "" \
  "Your password is not a vintage wine!"
```

### Interactive Tip Selection
```bash
#!/bin/bash
TIP=$(cat ~/.keeper_security_tips.txt | gum choose --height 10)
gum style --border double --padding "1 2" "$TIP"
```

### Beautiful Resource Display
```bash
#!/bin/bash
gum join --vertical \
  "$(gum style --foreground 33 --bold 'System Resources')" \
  "$(duf --only local)" \
  "$(free -h | gum table)"
```

## 🚀 Use Enhanced MOTD

```bash
# Copy the enhanced version
cp keeper_motd_enhanced.sh ~/.keeper_motd.sh

# The script auto-detects which enhancements are installed
# and uses them automatically!
```

## 📊 Feature Matrix

| Tool | Purpose | Size | Speed | Colors | Interactive |
|------|---------|------|-------|--------|-------------|
| Gum | Styling | 5MB | Fast | ✅ | ✅ |
| Lolcat | Rainbows | <1MB | Fast | ✅ | ❌ |
| Duf | Disk Usage | 2MB | Fast | ✅ | ❌ |
| Toilet | ASCII Art | <1MB | Fast | ✅ | ❌ |
| Boxes | Borders | <1MB | Fast | ❌ | ❌ |
| Figlet | ASCII Text | <1MB | Fast | ❌ | ❌ |
| Btop | Monitoring | 3MB | Medium | ✅ | ✅ |
| Glow | Markdown | 5MB | Fast | ✅ | ✅ |

## 🎯 Recommended Combination

**For Maximum Visual Impact:**
```bash
brew install gum lolcat duf toilet
# or
sudo apt install gum lolcat duf toilet
```

**For Interactive Experience:**
```bash
brew install gum glow
```

**For System Admins:**
```bash
brew install btop procs duf
```

## 📝 Notes

- **Gum** is the most impactful single enhancement
- **Lolcat** adds fun but may not suit professional environments
- **Duf** is a strict upgrade over standard `df`
- **Toilet** is better than figlet for colored output
- All tools are open source and actively maintained
- Most tools are cross-platform (Linux, macOS, some Windows)

## 🔗 Resources

- [Charm.sh](https://charm.sh) - Full Charm ecosystem
- [Gum GitHub](https://github.com/charmbracelet/gum)
- [Awesome CLI Apps](https://github.com/agarrharr/awesome-cli-apps)
- [Terminals Are Sexy](https://terminalsare.sexy/)

---

**Enhance your terminal experience! 🎨**
