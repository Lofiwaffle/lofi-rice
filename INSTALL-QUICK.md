# Quick Installation Guide

One-page guide to install lofi-rice on a fresh Arch Linux system.

## 🚀 TL;DR - Fastest Installation

```bash
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice
./install.sh
# Follow prompts → Reboot → Done!
```

---

## 📋 Prerequisites

- ✅ Fresh Arch Linux installation
- ✅ Internet connection
- ✅ Git installed (`sudo pacman -S git`)
- ⏱️ 20-45 minutes available
- 💾 ~3GB free disk space

---

## 🎯 Installation Methods

### Method 1: Interactive (Recommended)

**Best for:** First-time installation, customizing what gets installed

```bash
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice
./install.sh
```

**What happens:**
1. ✅ Checks prerequisites
2. 🎨 Offers installation options:
   - Full installation
   - Packages only
   - Configs only
   - Custom selection
3. 💾 Creates backup of existing configs
4. 📦 Installs 240 packages
5. ⚙️ Restores configurations
6. 🔧 Enables services
7. 📝 Provides next steps

**Interactive Options:**
- Choose full or partial installation
- Edit monitor config during install
- Setup automated backups
- Review summary before finishing

---

### Method 2: Automated (No Prompts)

**Best for:** Scripted deployments, VMs, testing

```bash
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice
./install.sh --auto
```

**What happens:**
- Runs full installation with no user input
- Installs everything automatically
- Creates log file for review
- Faster but less control

---

### Method 3: Manual (Individual Scripts)

**Best for:** Advanced users, troubleshooting, selective updates

```bash
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice

# Run scripts individually
./scripts/install-packages.sh      # Install packages
./scripts/restore-configs.sh       # Restore configs
./scripts/enable-services.sh       # Enable services
```

---

## 📊 What Gets Installed

### Packages (240 total)
- **Hyprland ecosystem** (compositor, idle, lock, etc.)
- **Applications** (Kitty, Waybar, Rofi, Dunst, etc.)
- **Themes** (GTK, Qt, icons, cursors)
- **Utilities** (audio, clipboard, screenshot tools)
- **113 AUR packages** (requires Paru, auto-installed)

### Configurations
- **Hyprland** - Complete setup with custom keybinds
- **Waybar** - Status bar with audio visualizer
- **Kitty** - Terminal configuration
- **Applications** - All app configs (15+ apps)
- **Shell** - Zsh with Powerlevel10k
- **Themes** - GTK3/4 + Qt5/6

### Services
- **Pipewire** - Audio system
- **Wireplumber** - Audio session manager
- **Docker Desktop** (if applicable)
- **User services** - Various user-level services

---

## ⚙️ Post-Installation

### 1. Adjust Monitor Configuration

Your monitor setup will differ from the backup:

```bash
nano ~/.config/hypr/monitors.conf
```

Find your monitors:
```bash
hyprctl monitors
```

Example config:
```conf
monitor=DP-1,1920x1080@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1
```

### 2. First Login

**If using display manager (SDDM/GDM):**
- Log out
- Select "Hyprland" from sessions
- Log in

**If using TTY:**
```bash
# Add to ~/.bash_profile or ~/.zprofile
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec Hyprland
fi
```

Or simply:
```bash
sudo reboot
```

### 3. Test Key Features

After login, test these:

| Keybind | Action | Expected Result |
|---------|--------|-----------------|
| `Super + Return` | Terminal | Kitty opens |
| `Super + Space` | Launcher | Rofi/Fuzzel appears |
| `Super + Q` | Close window | Window closes |
| `Super + O` | Obsidian | Obsidian launches |
| `Super + W` | Browser | Browser opens |

Full keybinds: `cat ~/lofi-rice/docs/KEYBINDS.md`

---

## 🐛 Common Issues

### Issue: Hyprland won't start

```bash
# Check logs
cat ~/.hyprland.log

# Reset monitor config to auto
echo "monitor=,preferred,auto,1" > ~/.config/hypr/monitors.conf

# Try starting manually
Hyprland
```

### Issue: No audio

```bash
# Restart audio services
systemctl --user restart pipewire.socket
systemctl --user restart wireplumber.service

# Check status
wpctl status
```

### Issue: Black screen

```bash
# Switch to TTY (Ctrl+Alt+F2)
# Edit monitors.conf
nano ~/.config/hypr/monitors.conf

# Set to auto-detect
monitor=,preferred,auto,1
```

**More solutions:** See `docs/TROUBLESHOOTING.md`

---

## 📁 Important Files

| File | Purpose |
|------|---------|
| `~/.config/hypr/monitors.conf` | Display configuration |
| `~/.config/hypr/custom/keybinds.conf` | Custom keybindings |
| `~/.config/hypr/custom/execs.conf` | Startup applications |
| `~/.config/waybar/config.jsonc` | Status bar config |
| `~/.zshrc` | Shell configuration |

---

## 🔄 Updating Configuration

### Pull Latest Changes

```bash
cd ~/lofi-rice
git pull
./scripts/restore-configs.sh
hyprctl reload  # Or Super + Shift + R
```

### Backup Your Changes

```bash
cd ~/lofi-rice
./scripts/backup-current-configs.sh
git add .
git commit -m "Update: $(date +%Y-%m-%d)"
git push
```

---

## 📚 Full Documentation

- **Complete install guide:** `docs/INSTALL.md`
- **All keybindings:** `docs/KEYBINDS.md`
- **Troubleshooting:** `docs/TROUBLESHOOTING.md`
- **Project README:** `README.md`

---

## ⏱️ Installation Timeline

```
┌─────────────────────────────────────────┐
│ Clone repo                     │ 1 min  │
├─────────────────────────────────────────┤
│ Install packages (240)         │ 15-30m │
├─────────────────────────────────────────┤
│ Restore configurations         │ 2 min  │
├─────────────────────────────────────────┤
│ Enable services                │ 1 min  │
├─────────────────────────────────────────┤
│ Configure monitors             │ 2 min  │
├─────────────────────────────────────────┤
│ Reboot and test                │ 5 min  │
├─────────────────────────────────────────┤
│ TOTAL                          │ 25-40m │
└─────────────────────────────────────────┘
```

---

## ✅ Installation Checklist

- [ ] Fresh Arch Linux installed
- [ ] Internet connected
- [ ] Git installed
- [ ] Repository cloned
- [ ] `./install.sh` completed successfully
- [ ] Monitor config adjusted
- [ ] Rebooted/logged into Hyprland
- [ ] Keybindings tested
- [ ] Audio working
- [ ] Applications launching

**All checked?** You're done! Enjoy your lofi-rice setup! 🌊

---

**Need Help?**
- 📖 Read `docs/TROUBLESHOOTING.md`
- 🐛 Open issue: https://github.com/YOUR_USERNAME/lofi-rice/issues
- 💬 Check Hyprland Discord

**Last Updated:** 2025-10-29
