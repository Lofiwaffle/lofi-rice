# Installation Guide

Complete step-by-step installation guide for lofi-rice Hyprland setup.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Methods](#installation-methods)
3. [Fresh Arch Linux Installation](#fresh-arch-linux-installation)
4. [Existing Arch Linux System](#existing-arch-linux-system)
5. [Post-Installation](#post-installation)
6. [Verification](#verification)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required

- **Arch Linux** installed (or Arch-based distro)
- **Internet connection** (packages require ~2-3GB download)
- **Git** installed: `sudo pacman -S git`
- **Base-devel** group: `sudo pacman -S base-devel`

### Recommended

- **GPU drivers** installed (NVIDIA/AMD/Intel)
- **Network manager** configured
- At least **20GB free disk space**

---

## Installation Methods

Choose your installation path:

### Method 1: Fresh Installation (Recommended)

Best for new Arch Linux installations or when you want to start clean.

```bash
git clone https://github.com/YOUR_USERNAME/lofi-rice.git ~/lofi-rice
cd ~/lofi-rice
./scripts/install-packages.sh
./scripts/restore-configs.sh
./scripts/enable-services.sh
reboot
```

### Method 2: Selective Installation

Install specific components only (for existing setups).

---

## Fresh Arch Linux Installation

### Step 1: Install Base System

If starting from scratch, install Arch Linux first:
- Follow the [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
- Or use [archinstall](https://wiki.archlinux.org/title/Archinstall) for automated installation

Minimal requirements:
- Base system
- Bootloader (GRUB/systemd-boot)
- Network connectivity
- User account with sudo access

### Step 2: Clone Repository

```bash
# Install git if not present
sudo pacman -S git

# Clone the dotfiles repository
git clone https://github.com/YOUR_USERNAME/lofi-rice.git ~/lofi-rice
cd ~/lofi-rice
```

### Step 3: Install Packages

This installs ~240 packages including Hyprland ecosystem and dependencies.

```bash
./scripts/install-packages.sh
```

**What this does:**
1. Installs `base-devel` if missing
2. Installs Paru (AUR helper) if not present
3. Updates system with `pacman -Syu`
4. Installs all official repo packages
5. Installs all AUR packages

⏱️ **Estimated time:** 20-45 minutes depending on internet speed and CPU

### Step 4: Restore Configurations

```bash
./scripts/restore-configs.sh
```

**What this does:**
1. Creates backup of existing configs
2. Copies Hyprland configuration
3. Restores application configs (waybar, kitty, rofi, etc.)
4. Copies shell configurations (.zshrc, .p10k.zsh)
5. Installs custom scripts to `~/.local/bin`
6. Adds custom desktop entries

### Step 5: Enable Services

```bash
./scripts/enable-services.sh
```

**What this does:**
1. Enables audio services (pipewire, wireplumber)
2. Enables Docker Desktop (if installed)
3. Enables XDG user directories
4. Enables other user services

### Step 6: Configure Display Manager (Optional)

If you want to use a display manager instead of starting Hyprland from TTY:

**Option A: SDDM (Recommended)**
```bash
sudo pacman -S sddm
sudo systemctl enable sddm
```

**Option B: GDM**
```bash
sudo pacman -S gdm
sudo systemctl enable gdm
```

**Option C: Start from TTY**

Add to `~/.bash_profile` or `~/.zprofile`:
```bash
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec Hyprland
fi
```

### Step 7: Reboot

```bash
reboot
```

After reboot:
1. Select Hyprland from display manager (if using one)
2. Or login to TTY and type `Hyprland`

---

## Existing Arch Linux System

If you already have Arch Linux with a desktop environment:

### Backup First!

```bash
# Backup your current configs
mkdir -p ~/config-backup-$(date +%Y%m%d)
cp -r ~/.config ~/config-backup-$(date +%Y%m%d)/
cp ~/.zshrc ~/config-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp ~/.bashrc ~/config-backup-$(date +%Y%m%d)/ 2>/dev/null || true
```

### Selective Installation

You can choose what to install:

#### Only Hyprland Packages
```bash
cd ~/lofi-rice
sudo pacman -S --needed - < packages/categories/hyprland.txt
sudo pacman -S --needed - < packages/categories/wayland-tools.txt
```

#### Only Hyprland Configs
```bash
cd ~/lofi-rice
cp -r config/hypr ~/.config/
```

#### Full Installation
```bash
cd ~/lofi-rice
./scripts/restore-configs.sh
```

The restore script automatically creates backups before overwriting.

---

## Post-Installation

### 1. Adjust Monitor Configuration

Your monitor setup will likely differ from mine. Edit:

```bash
nano ~/.config/hypr/monitors.conf
```

Find your monitor names:
```bash
hyprctl monitors
```

Example configuration:
```conf
monitor=DP-1,1920x1080@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1
```

### 2. Review Custom Keybinds

Check and modify custom keybinds if needed:

```bash
nano ~/.config/hypr/custom/keybinds.conf
```

### 3. Configure Startup Applications

Edit autostart programs:

```bash
nano ~/.config/hypr/custom/execs.conf
```

### 4. Set Default Applications

Update default apps:

```bash
nano ~/.config/mimeapps.list
```

### 5. Setup Automated Backups (Optional)

```bash
cd ~/lofi-rice
./scripts/setup-auto-backup.sh
```

This creates a systemd timer for daily automated backups.

---

## Verification

### Check Hyprland is Running

```bash
echo $XDG_SESSION_TYPE  # Should output: wayland
hyprctl version         # Shows Hyprland version
```

### Check Audio

```bash
wpctl status           # Show audio status
wpctl get-volume @DEFAULT_SINK@  # Get current volume
```

### Check Services

```bash
systemctl --user status pipewire.socket
systemctl --user status wireplumber.service
```

### Test Keybinds

Try these:
- `Super + Return` → Terminal should open
- `Super + Space` → Launcher should appear
- `Super + Q` → Close window

### Verify Waybar

Waybar should appear at the top of your screen. If not:

```bash
waybar &
```

Check waybar config:
```bash
nano ~/.config/waybar/config.jsonc
```

---

## Troubleshooting

### Hyprland Won't Start

**Check logs:**
```bash
cat ~/.hyprland.log
```

**Common issues:**
- Missing GPU drivers
- Monitor configuration error
- Missing dependencies

**Try starting with default config:**
```bash
Hyprland --config /usr/share/hyprland/hyprland.conf
```

### Black Screen After Login

**Possible causes:**
1. Monitor configuration invalid
2. GPU drivers not loaded
3. Wayland not supported by GPU

**Quick fix:**
```bash
# Switch to TTY (Ctrl+Alt+F2)
# Edit monitors.conf to use default
echo "monitor=,preferred,auto,1" > ~/.config/hypr/monitors.conf
# Try starting again
Hyprland
```

### Audio Not Working

```bash
# Restart audio services
systemctl --user restart pipewire.socket
systemctl --user restart wireplumber.service

# Check if running
systemctl --user status pipewire.socket
```

### Applications Not Launching

**Check if installed:**
```bash
which kitty    # Check if kitty is installed
which rofi     # Check if rofi is installed
```

**Reinstall if missing:**
```bash
sudo pacman -S kitty rofi
```

### Waybar Not Showing

```bash
# Kill existing waybar
killall waybar

# Start with debug output
waybar -l debug

# Check config syntax
waybar --bar=bar-0 --config ~/.config/waybar/config.jsonc --style ~/.config/waybar/style.css
```

### Performance Issues

**Check Hyprland performance:**
```bash
hyprctl version  # Check version
hyprctl systeminfo  # System information
```

**Reduce animations:**
Edit `~/.config/hypr/hyprland/general.conf`:
```conf
animations {
    enabled = false  # Disable animations
}
```

Or reduce animation speed:
```conf
animation = global, 1, 2, default  # Faster animations
```

---

## Additional Resources

- **Hyprland Wiki:** https://wiki.hyprland.org/
- **Arch Wiki:** https://wiki.archlinux.org/
- **Waybar Documentation:** https://github.com/Alexays/Waybar/wiki
- **Repository Issues:** https://github.com/YOUR_USERNAME/lofi-rice/issues

---

## Updating the Configuration

### Pull Latest Changes

```bash
cd ~/lofi-rice
git pull origin main
./scripts/restore-configs.sh
hyprctl reload  # Or Super + Shift + R
```

### Update Packages

```bash
cd ~/lofi-rice

# Update package lists first (from backup script)
pacman -Qe | awk '{print $1}' > packages/explicit-packages.txt
pacman -Qm | awk '{print $1}' > packages/aur-packages.txt

# Then reinstall
./scripts/install-packages.sh
```

---

**Last Updated:** 2025-10-29

**Need Help?** Open an issue at https://github.com/YOUR_USERNAME/lofi-rice/issues
