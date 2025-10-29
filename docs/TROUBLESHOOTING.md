# Troubleshooting Guide

Common issues and their solutions for the lofi-rice Hyprland setup.

## 🔍 Quick Diagnostics

### Check Hyprland Status
```bash
echo $XDG_SESSION_TYPE          # Should be 'wayland'
hyprctl version                  # Hyprland version info
cat ~/.hyprland.log | tail -50   # Recent log entries
```

### Check Services
```bash
systemctl --user status pipewire.socket
systemctl --user status wireplumber.service
systemctl --user list-units --state=failed
```

---

## 🪟 Hyprland Issues

### Hyprland Won't Start

**Symptoms:** Black screen, crash on login, returns to login manager

**Diagnosis:**
```bash
# View logs
cat ~/.hyprland.log

# Check for errors
grep -i "error\|critical" ~/.hyprland.log

# Try starting from TTY
Hyprland
```

**Common Causes:**

1. **Invalid Monitor Configuration**
   ```bash
   # Reset to auto-detect
   echo "monitor=,preferred,auto,1" > ~/.config/hypr/monitors.conf
   ```

2. **Missing GPU Drivers**
   ```bash
   # NVIDIA
   sudo pacman -S nvidia nvidia-utils

   # AMD
   sudo pacman -S mesa vulkan-radeon

   # Intel
   sudo pacman -S mesa vulkan-intel
   ```

3. **Syntax Error in Config**
   ```bash
   # Test config syntax
   hyprctl --batch "reload"

   # Restore default config temporarily
   mv ~/.config/hypr ~/.config/hypr.bak
   cp -r /usr/share/hyprland ~/.config/hypr
   ```

### Hyprland Crashes Frequently

**Check crash logs:**
```bash
journalctl --user -u hyprland -n 100
coredumpctl list
```

**Solutions:**
1. Disable problematic features:
   ```bash
   # Edit ~/.config/hypr/hyprland/general.conf
   animations {
       enabled = false
   }
   ```

2. Update to latest version:
   ```bash
   paru -S hyprland-git
   ```

### Window Tiling Behaves Oddly

**Reset workspace layout:**
```bash
hyprctl dispatch exec "hyprctl --batch 'dispatch workspace 1'"
```

**Clear window rules:**
```bash
# Temporarily disable custom rules
mv ~/.config/hypr/custom/rules.conf ~/.config/hypr/custom/rules.conf.bak
hyprctl reload
```

---

## 🖥️ Display Issues

### Monitor Not Detected

**Check connected monitors:**
```bash
hyprctl monitors
wlr-randr  # Alternative tool
```

**Force monitor detection:**
```bash
# In monitors.conf, add:
monitor=DP-1,preferred,auto,1
# Or specific resolution:
monitor=DP-1,1920x1080@60,0x0,1
```

### Wrong Resolution/Refresh Rate

**List available modes:**
```bash
hyprctl monitors | grep -A 20 "Monitor"
```

**Set specific mode:**
```conf
# In ~/.config/hypr/monitors.conf
monitor=DP-1,1920x1080@144,0x0,1
```

### Multi-Monitor Issues

**Monitors in wrong position:**
```conf
# monitors.conf - position monitors
monitor=DP-1,1920x1080,0x0,1       # Primary (left)
monitor=HDMI-A-1,1920x1080,1920x0,1  # Secondary (right)
```

**Scaling issues:**
```conf
# Different scaling per monitor
monitor=eDP-1,1920x1080,0x0,1.5    # Laptop at 150%
monitor=DP-1,2560x1440,1920x0,1    # External at 100%
```

### Fractional Scaling Blurry

**Enable proper scaling:**
```conf
# In general.conf
misc {
    force_hypr_scale = true
}
```

---

## 🔊 Audio Issues

### No Audio Output

**Check audio stack:**
```bash
# Check if services are running
systemctl --user status pipewire.socket
systemctl --user status wireplumber.service

# Restart if needed
systemctl --user restart pipewire.socket
systemctl --user restart wireplumber.service
```

**Check audio devices:**
```bash
wpctl status
pactl list sinks short
```

**Set default sink:**
```bash
wpctl set-default <SINK_ID>
# Example:
wpctl set-default 45
```

### Audio Crackling/Popping

**Increase buffer size:**
```bash
# Edit /etc/pipewire/pipewire.conf
default.clock.allowed-rates = [ 48000 ]
default.clock.quantum = 1024
default.clock.min-quantum = 1024
```

**Or for user:**
```bash
mkdir -p ~/.config/pipewire
cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/
# Edit and restart services
```

### Media Keys Not Working

**Check playerctl:**
```bash
playerctl status
playerctl -a metadata
```

**Bind media keys manually:**
```conf
# In keybinds.conf
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous
```

---

## ⌨️ Input Issues

### Keyboard Not Working

**Check input devices:**
```bash
hyprctl devices
```

**Set keyboard layout:**
```conf
# In ~/.config/hypr/hyprland/general.conf
input {
    kb_layout = us
    kb_variant =
    kb_options = caps:escape  # Optional: caps as escape
}
```

### Touchpad Not Working

**Enable touchpad:**
```conf
input {
    touchpad {
        natural_scroll = true
        tap-to-click = true
        disable_while_typing = true
    }
}
```

**Check libinput:**
```bash
libinput list-devices
```

### Special Keys Not Working

**Map special keys:**
```bash
# Use wev to detect key codes
wev

# Then add to keybinds.conf
bind = , XF86Calculator, exec, gnome-calculator
```

---

## 🎨 Theming Issues

### GTK Apps Look Wrong

**Set GTK theme:**
```bash
# ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Colloid
gtk-cursor-theme-name=Bibata-Modern-Amber
```

**Apply immediately:**
```bash
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface icon-theme "Colloid"
```

### Qt Apps Look Wrong

**Configure Qt:**
```bash
qt5ct  # For Qt5 apps
qt6ct  # For Qt6 apps
```

**Set environment variables:**
```bash
# In ~/.config/hypr/custom/env.conf
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_STYLE_OVERRIDE,kvantum
```

### Cursor Theme Not Applied

**Set cursor theme:**
```bash
# ~/.config/gtk-3.0/settings.ini
gtk-cursor-theme-name=Bibata-Modern-Amber
gtk-cursor-theme-size=24
```

**Also set in Hyprland:**
```conf
# In general.conf
cursor {
    no_hardware_cursors = false
    default_monitor =
    zoom_factor = 1.0
}

env = XCURSOR_THEME,Bibata-Modern-Amber
env = XCURSOR_SIZE,24
```

---

## 📊 Waybar Issues

### Waybar Not Showing

**Start manually:**
```bash
killall waybar
waybar &
```

**Check for errors:**
```bash
waybar -l debug
```

**Verify config:**
```bash
# Test config syntax
waybar --config ~/.config/waybar/config.jsonc --style ~/.config/waybar/style.css
```

### Waybar Modules Not Working

**Common module issues:**

1. **Network module:**
   ```bash
   # Check NetworkManager is running
   systemctl status NetworkManager
   ```

2. **Battery module:**
   ```bash
   # Check battery exists
   ls /sys/class/power_supply/
   ```

3. **Custom modules:**
   ```bash
   # Test script directly
   ~/.config/waybar/scripts/cava.sh
   ```

### Waybar Styling Issues

**Reload styles:**
```bash
killall waybar
waybar &
```

**Check CSS syntax:**
```bash
# Install CSS validator
paru -S csslint

# Validate
csslint ~/.config/waybar/style.css
```

---

## 🖼️ Application Issues

### Apps Won't Launch

**Test from terminal:**
```bash
kitty &          # Terminal
firefox &        # Browser
obsidian &       # Obsidian
```

**Check if installed:**
```bash
which kitty
which firefox
pacman -Qi obsidian
```

**Check desktop entries:**
```bash
ls ~/.local/share/applications/
cat ~/.local/share/applications/obsidian.desktop
```

### Apps Launch on Wrong Workspace

**Fix window rules:**
```conf
# In ~/.config/hypr/custom/rules.conf
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = workspace 3, class:^(obsidian)$
```

**Find window class:**
```bash
hyprctl clients | grep class
```

### Apps Have Wrong Size

**Set initial size:**
```conf
windowrulev2 = size 1200 800, class:^(myapp)$
windowrulev2 = center, class:^(myapp)$
```

### Electron Apps Blank/Broken

**Force Wayland:**
```bash
# Launch with flags
code --enable-features=UseOzonePlatform --ozone-platform=wayland

# Or set permanently in .desktop file
Exec=code --enable-features=UseOzonePlatform --ozone-platform=wayland %U
```

**Common flags needed:**
```bash
--enable-features=UseOzonePlatform,WaylandWindowDecorations
--ozone-platform=wayland
```

---

## 🔄 Performance Issues

### High CPU Usage

**Check what's using CPU:**
```bash
htop
# Or
btop
```

**Common causes:**

1. **Animations:**
   ```conf
   # Reduce in general.conf
   animations {
       enabled = true
       speed = 2  # Faster = less CPU
   }
   ```

2. **Blur effects:**
   ```conf
   # Disable blur
   decoration {
       blur {
           enabled = false
       }
   }
   ```

3. **Background processes:**
   ```bash
   # Check autostart
   nano ~/.config/hypr/custom/execs.conf
   ```

### High Memory Usage

**Check memory:**
```bash
free -h
ps aux --sort=-%mem | head -20
```

**Reduce memory usage:**
1. Close unnecessary workspaces
2. Limit browser tabs
3. Check for memory leaks in custom scripts

### Screen Tearing

**Enable VRR:**
```conf
# In general.conf
misc {
    vrr = 1
    vfr = true
}
```

**NVIDIA specific:**
```conf
env = __GL_GSYNC_ALLOWED,1
env = __GL_VRR_ALLOWED,1
```

---

## 🔐 Permission Issues

### Can't Access Hardware

**Add user to groups:**
```bash
sudo usermod -aG video,input,audio $USER
```

**Log out and back in for changes to take effect.**

### Screen Sharing Not Working

**Install xdg-desktop-portal:**
```bash
sudo pacman -S xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
```

**Configure:**
```bash
# Check portals
xdg-desktop-portal --list-backends
```

---

## 🆘 Emergency Recovery

### Can't Login to Hyprland

**Switch to TTY:**
```
Ctrl + Alt + F2
```

**Start with default config:**
```bash
mv ~/.config/hypr ~/.config/hypr.broken
Hyprland
```

### System Unresponsive

**Force restart Hyprland:**
```
Super + Shift + Q
```

**From TTY:**
```bash
killall Hyprland
```

### Nuclear Option - Full Reset

```bash
# Backup and remove all configs
mv ~/.config/hypr ~/.config/hypr.backup
mv ~/.config/waybar ~/.config/waybar.backup

# Reinstall from dotfiles
cd ~/lofi-rice
./scripts/restore-configs.sh
```

---

## 📞 Getting Help

### Collect Debug Information

```bash
# System info
neofetch

# Hyprland info
hyprctl systeminfo > ~/hyprland-sysinfo.txt

# Logs
cat ~/.hyprland.log > ~/hyprland.log

# Config files
tar -czf ~/hypr-configs.tar.gz ~/.config/hypr/
```

### Where to Ask

1. **GitHub Issues:** https://github.com/YOUR_USERNAME/lofi-rice/issues
2. **Hyprland Discord:** https://discord.gg/hyprland
3. **Arch Linux Forums:** https://bbs.archlinux.org/
4. **Reddit:** r/hyprland, r/unixporn

---

**Last Updated:** 2025-10-29
