# Comprehensive Dotfiles Configuration Guide
## Arch Linux + Hyprland Multi-Monitor Workstation

**System**: Arch Linux with Hyprland Wayland Compositor
**Hardware**: Intel Arrow Lake-P GPU, 6-display setup (5-6 monitors)
**Philosophy**: Modular, performance-optimized, theme-integrated configuration
**Last Updated**: 2025-12-21

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture & Philosophy](#architecture--philosophy)
3. [Installation & Setup](#installation--setup)
4. [Hyprland Configuration](#hyprland-configuration)
5. [Shell Configuration (Zsh)](#shell-configuration-zsh)
6. [Keybindings](#keybindings)
7. [Terminal Configuration](#terminal-configuration)
8. [System Configuration](#system-configuration)
9. [Theme & Color Schemes](#theme--color-schemes)
10. [Package Management](#package-management)
11. [Customization Guide](#customization-guide)
12. [Troubleshooting](#troubleshooting)

---

## System Overview

This is a highly customized Arch Linux workstation optimized for a multi-monitor display setup with sophisticated keybinding integration and theme management. The configuration prioritizes:

- **Performance**: Disabled blur/shadows for multi-monitor support, VRR enabled
- **Modularity**: Separation of defaults and custom configs for maintainability
- **Integration**: Unified theme system across terminal, Qt, and Wayland apps
- **Extensibility**: Organized keybinding structure for quick additions

### Key Components

| Component | Value |
|-----------|-------|
| **Init System** | systemd |
| **Display Server** | Hyprland (Wayland compositor) |
| **Boot Loader** | Limine (UEFI) |
| **Root Filesystem** | BTRFS (encrypted with LUKS) |
| **Shell** | Zsh (with Zinit plugin manager) |
| **Prompt** | Powerlevel10k (2-line powerline) |
| **Terminal** | Ghostty (primary) |
| **Package Manager** | Pacman + AUR |
| **Theme System** | Omarchy (illogical-impulse) |
| **GPU Driver** | i915 (Intel integrated graphics) |

### Hardware Configuration

```
Monitor Layout:
├── Samsung (Laptop): 1920x1200@60, 1.5x scale, native
├── Dell P2722H (Portrait 1): 1920x1080@60, rotated 90°
├── Dell P2722H (Portrait 2): 1920x1080@60, rotated 270°
├── LG ULTRAGEAR: 3840x1080@119.97
└── MSI MAG401QR: 3440x1440@100, 1.25x scale

GPU: Intel Arc (Arrow Lake-P)
RAM: [configured per system]
Storage: Encrypted BTRFS with snapshot support
```

---

## Architecture & Philosophy

### Hyprland Configuration Structure

The Hyprland configuration uses a **defaults + custom overrides** pattern:

```
~/.config/hypr/
├── hyprland.conf              ← Main entry point (sources all configs)
├── monitors.conf              ← Monitor layout (nwg-displays managed)
├── workspaces.conf            ← Workspace configuration
├── hyprland/                  ← DEFAULT configs (don't modify)
│   ├── env.conf               ← Environment variables
│   ├── execs.conf             ← System autostart
│   ├── general.conf           ← Display/input/animation settings
│   ├── keybinds.conf          ← Default keybindings (269 lines)
│   ├── rules.conf             ← Window/workspace rules
│   ├── colors.conf            ← Color scheme
│   └── scripts/               ← Utility scripts
└── custom/                    ← USER customizations (modify these)
    ├── env.conf               ← Additional environment variables
    ├── execs.conf             ← Custom autostart applications
    ├── general.conf           ← Performance tuning, layout
    ├── keybinds.conf          ← User keybindings (94 lines)
    ├── rules.conf             ← User window rules
    └── scripts/               ← Custom utility scripts
```

**Key Principle**: Custom configs are sourced AFTER defaults, so they override all default settings. Never modify `hyprland/` files—always create overrides in `custom/`.

### Configuration Sourcing Order (in hyprland.conf)

```bash
# Load defaults first
source = hyprland/env.conf
source = hyprland/execs.conf
source = hyprland/general.conf
source = hyprland/rules.conf
source = hyprland/colors.conf
source = hyprland/keybinds.conf

# User overrides (take precedence)
source = custom/env.conf
source = custom/execs.conf
source = custom/general.conf
source = custom/rules.conf
source = custom/keybinds.conf

# Monitor-specific configs
source = workspaces.conf
source = monitors.conf
```

---

## Installation & Setup

### Prerequisites

```bash
# Install base Hyprland and dependencies
sudo pacman -S hyprland hyprlock hypridle hyprpicker

# Install Zsh and plugin manager
sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Install essential CLI tools
sudo pacman -S ghostty bat eza fzf zoxide fd ripgrep

# Install theme/UI components
sudo pacman -S waybar dunst cliphist wl-paste wl-copy
sudo pacman -S qt5-wayland qt6-wayland qt5-platformtheme-kde qt6-platformtheme-kde

# Display management
sudo pacman -S nwg-displays hyprctl

# AUR packages (using yay/paru)
yay -S quickshell vicinae easyeffects
```

### Quick Setup (Minimal)

```bash
# 1. Clone or sync lofi-rice dotfiles
git clone https://github.com/Lofiwaffle/lofi-rice ~/lofi-rice
cd ~/lofi-rice

# 2. Backup existing config
cp -r ~/.config ~/.config.backup

# 3. Install dotfiles (verify paths match your system)
./install.sh  # or manually symlink configs

# 4. Verify Hyprland sources main config
cat ~/.config/hypr/hyprland.conf | grep source

# 5. Reload shell and Hyprland
zsh
exec Hyprland
```

### Detailed Installation Steps

#### Step 1: Install Base System

```bash
# Update package database
sudo pacman -Syu

# Install Hyprland and core components
sudo pacman -S hyprland hyprlock hypridle hyprpicker hyprlandwithdeps
```

#### Step 2: Install Shell Environment

```bash
# Install Zsh
sudo pacman -S zsh
chsh -s /usr/bin/zsh

# Install Zinit (plugin manager)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Install shell tools
sudo pacman -S fzf ripgrep fd bat eza zoxide
```

#### Step 3: Install Terminal & Display Tools

```bash
# Ghostty terminal
sudo pacman -S ghostty

# Display/status bar
sudo pacman -S waybar dunst

# Display management
sudo pacman -S nwg-displays

# Clipboard integration
sudo pacman -S cliphist wl-paste wl-copy
```

#### Step 4: Install Theme & Launcher

```bash
# Quickshell (status bar + dynamic colors)
yay -S quickshell

# Vicinae (application launcher)
yay -S vicinae

# Qt theme
sudo pacman -S qt5-wayland qt6-wayland qt5-platformtheme-kde qt6-platformtheme-kde

# Audio integration
yay -S easyeffects
```

#### Step 5: Deploy Configuration Files

```bash
# Copy Hyprland config
mkdir -p ~/.config/hypr
cp -r lofi-rice/config/hypr/* ~/.config/hypr/

# Copy shell config
cp lofi-rice/config/zshrc ~/.zshrc
mkdir -p ~/.config/zshrc.d
cp lofi-rice/config/zshrc.d/* ~/.config/zshrc.d/

# Copy terminal config
mkdir -p ~/.config/ghostty
cp lofi-rice/config/ghostty/config ~/.config/ghostty/

# Copy waybar config
mkdir -p ~/.config/waybar
cp -r lofi-rice/config/waybar/* ~/.config/waybar/

# Copy application configs
mkdir -p ~/.config/illogical-impulse
cp lofi-rice/config/illogical-impulse/config.json ~/.config/illogical-impulse/
```

#### Step 6: Configure Boot/Kernel

```bash
# Verify GPU driver
lsmod | grep i915

# Copy GPU driver config
sudo cp lofi-rice/system/modprobe.d/intel-graphics.conf /etc/modprobe.d/

# Copy mkinitcpio config (BACKUP FIRST!)
sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup
sudo cp lofi-rice/system/mkinitcpio.conf /etc/

# Rebuild initramfs
sudo mkinitcpio -P
```

#### Step 7: Set Shell & Reload

```bash
# Set Zsh as default shell
chsh -s /usr/bin/zsh

# Start new Zsh session
zsh

# Start Hyprland
Hyprland
```

---

## Hyprland Configuration

### Main Configuration File (`~/.config/hypr/hyprland.conf`)

```bash
# Entry point that sources all configuration
# This file is minimal and only includes other configs

source = hyprland/env.conf
source = hyprland/execs.conf
source = hyprland/general.conf
source = hyprland/rules.conf
source = hyprland/colors.conf
source = hyprland/keybinds.conf

source = custom/env.conf
source = custom/execs.conf
source = custom/general.conf
source = custom/rules.conf
source = custom/keybinds.conf

source = workspaces.conf
source = monitors.conf
```

### Default Environment (`hyprland/env.conf`)

```bash
# Wayland/Qt platform integration
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,kde
env = QT_AUTO_SCREEN_SCALE_FACTOR,1

# KDE/Plasma integration
env = KDE_FULL_SCREEN,1

# Default terminal
env = TERMINAL,ghostty

# GPU drivers (Intel)
env = LIBVA_DRIVER_NAME,iHD
env = MESA_LOADER_DRIVER_OVERRIDE,iris

# Quickshell configuration
env = QUICKSHELL_CONFIG_PATH,ii

# XDG directories
env = XDG_SESSION_TYPE,wayland
```

### Default General Settings (`hyprland/general.conf`)

Key sections include:

```bash
# Monitor layout
monitor = eDP-1, 1920x1200, 1920x2215, 1.0
monitor = DP-2, 1920x1080, 840x1135, 1.0, transform, 1
monitor = DVI-I-1, 1920x1080, 1920x1135, 1.0
monitor = DVI-I-2, 1920x1080, 1920x55, 1.0
monitor = HDMI-A-1, 1920x1080, 3840x1135, 1.0, transform, 3

# Input settings
input {
    kb_layout = us
    follow_mouse = 1
    sensitivity = 0
    touchpad {
        natural_scroll = true
    }
}

# Animations
animations {
    enabled = yes

    bezier = genie, 0.67, 0, 0.33, 1
    bezier = bounce, 0.34, 1.56, 0.64, 1
    bezier = menu_decel, 0.46, 0.46, 0.44, 1.13

    animation = windows, 1, 3, default, popin
    animation = windowsMove, 1, 3, default, popin
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 5, default
}

# Decoration
decoration {
    rounding = 12
    blur = {
        enabled = false
        size = 5
        passes = 2
    }
    drop_shadow = false
    dim_special = 0.2
}

# Layout
layout = master
```

### Custom Performance Tuning (`custom/general.conf`)

```bash
# Optimized for 6-monitor setup
decoration {
    blur {
        enabled = false      # Disabled for multi-monitor performance
    }
    drop_shadow = false      # Shadows disabled for performance
    dim_special = 0.2
}

misc {
    vfr = true              # Variable refresh rate
    vrr = 2                 # Enabled for compatible monitors
}

master {
    new_status = slave
    mfact = 0.5
    orientation = right
}

# Animation curves for interactive feedback
bezier = genie, 0.67, 0, 0.33, 1
bezier = bounce, 0.34, 1.56, 0.64, 1
animation = windows, 1, 3, genie, popin 90%
animation = windowsMove, 1, 3, genie, popin 90%
animation = border, 1, 10, default
animation = fade, 1, 7, default
animation = workspaces, 1, 5, default, slidevert 10%
```

### Autostart Programs (`hyprland/execs.conf`)

```bash
# Executed once at startup
exec-once = quickshell -c ii &
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME
exec-once = /usr/lib/geoclue-2.0/demos/agent

# Authentication daemon
exec-once = gnome-keyring-daemon --start --daemonize

# Lock screen & idle
exec-once = hypridle &

# Audio effects
exec-once = easyeffects --gapplication-service

# Clipboard manager
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store

# Cursor theme
exec-once = hyprctl setcursor Bibata-Modern-Classic 24

# Audio daemon (if using PipeWire)
# exec-once = pipewire &
# exec-once = pipewire-pulse &
```

### Custom Autostart (`custom/execs.conf`)

```bash
# User-defined startup applications
exec-once = waybar &
exec-once = vicinae --listen &
```

### Keybindings (`custom/keybinds.conf` - Notable Binds)

See [Keybindings](#keybindings) section for full list. Key patterns:

```bash
# App launcher
bind = SUPER, Return, exec, ghostty
bind = SUPER, B, exec, vivaldi --new-window
bind = SUPER, M, exec, spotify
bind = SUPER, E, exec, dolphin

# Quick config editing
bind = CTRL SUPER, slash, exec, ghostty -e "$EDITOR" ~/.config/illogical-impulse/config.json
bind = CTRL SUPER ALT, slash, exec, ghostty -e "$EDITOR" ~/.config/hypr/custom/keybinds.conf

# Window management
bind = SUPER, Q, killactive
bind = SUPER SHIFT, J, togglesplit
bind = SUPER SHIFT, V, togglefloating
bind = SHIFT, F11, fullscreen, 1

# Monitor management (reload)
bind = SUPER, F5, exec, hyprctl reload
```

### Monitor Configuration (`monitors.conf`)

Generated by nwg-displays. Structure:

```bash
# Monitor settings
# Format: monitor=NAME,RESOLUTION@REFRESH,POSITION,SCALE[,transform,ROTATION]

monitor = eDP-1, 1920x1200@60, 1920x2215, 1.0
monitor = DP-2, 1920x1080@60, 840x1135, 1.0, transform, 1
monitor = DVI-I-1, 1920x1080@60, 1920x1135, 1.0
monitor = DVI-I-2, 1920x1080@60, 1920x55, 1.0
monitor = HDMI-A-1, 1920x1080@60, 3840x1135, 1.0, transform, 3

# Fallback monitor (if one disconnects)
monitor = , preferred, auto, 1
```

**To regenerate with GUI**:
```bash
nwg-displays
```

---

## Shell Configuration (Zsh)

### Overview

Zsh configuration emphasizes:
- Fast startup through deferred plugin loading
- Completion caching for performance
- Modern CLI tool integration (fzf, zoxide, bat, eza)
- Extensive aliases for common tasks

### Main Configuration (`~/.zshrc`)

The Zsh configuration follows this structure:

```zsh
# 1. Zinit initialization
source $HOME/.local/share/zinit/zinit.git/zinit.zsh

# 2. Load Powerlevel10k prompt theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# 3. Load completion plugin BEFORE compinit
zinit ice as=completion; zinit light zsh-users/zsh-completions

# 4. Initialize completion system
autoload -Uz compinit && compinit -C

# 5. FZF tab completion
zinit ice wait"1" lucid; zinit light Aloxaf/fzf-tab

# 6. Autosuggestions (turbo mode)
zinit ice wait"0" lucid atload'!_zsh_autosuggest_start'; zinit light zsh-users/zsh-autosuggestions

# 7. Syntax highlighting (MUST be last)
zinit ice wait"1" lucid; zinit light zsh-users/zsh-syntax-highlighting

# 8. OMZ snippets (turbo mode)
zinit ice wait"0" lucid as=snippet; zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit ice wait"0" lucid as=snippet; zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
zinit ice wait"0" lucid as=snippet; zinit snippet OMZ::plugins/archlinux/archlinux.plugin.zsh
# ... more OMZ plugins

# 9. Shell configuration files
for config in ~/.config/zshrc.d/*.zsh; do
    source "$config"
done

# 10. Load p10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

### Essential Zsh Options

```zsh
# History management
HISTSIZE=500000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory           # Share between sessions
setopt hist_ignore_space      # Ignore commands starting with space
setopt hist_find_no_dups      # Don't show duplicates in history search

# UI/UX
KEYTIMEOUT=1                  # Responsive keybindings
setopt nocorrect              # Disable auto-correct
setopt notify                 # Notify of background job changes
```

### Zinit Configuration Strategy

**Load Order** (critical for performance):
1. **Load synchronously** (no wait): Prompts, essential plugins
2. **Wait 0-1 seconds**: Completions, autosuggestions
3. **Turbo mode** (`wait` + `lucid`): Defers loading until shell is responsive
4. **Syntax highlighting last**: Must be loaded after all text-manipulating plugins

**Performance Tips**:
```zsh
# Use binary annexes for faster loading
zinit load-snippet OMZ::plugins/git/git.plugin.zsh

# Use turbo mode for non-critical plugins
zinit ice wait"1" lucid atload'_zsh_autosuggest_start'

# Cache completions
compinit -C  # Uses .zcompcache

# Clean old caches periodically
rm -f ~/.zcompcache
```

### Core Plugins

#### 1. Powerlevel10k (Prompt)
```zsh
zinit ice depth=1
zinit light romkatv/powerlevel10k
```

Configuration in `~/.p10k.zsh` (auto-generated):
- 2-line powerline prompt
- Left segments: os_icon, dir, vcs, newline, prompt_char
- Right segments: status, execution_time, virtualenv
- Rainbow colors, powerline font glyphs

#### 2. Zsh Completions
```zsh
zinit ice as=completion
zinit light zsh-users/zsh-completions
```

#### 3. FZF-Tab
```zsh
zinit ice wait"1" lucid
zinit light Aloxaf/fzf-tab
```

Provides fuzzy completion menu for:
- Command options
- Directory navigation
- File selection
- Process/systemd completion with previews

#### 4. Zsh Autosuggestions
```zsh
zinit ice wait"0" lucid atload'!_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
```

#### 5. Syntax Highlighting
```zsh
zinit ice wait"1" lucid
zinit light zsh-users/zsh-syntax-highlighting
```

**Must be loaded last** (after other text-modifying plugins).

### OMZ Plugins (Snippets in Turbo Mode)

```zsh
# Git aliases and functions
zinit ice wait"0" lucid as=snippet
zinit snippet OMZ::plugins/git/git.plugin.zsh

# Sudo prefix toggle (Esc+Esc)
zinit ice wait"0" lucid as=snippet
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

# Arch Linux pacman helpers
zinit ice wait"0" lucid as=snippet
zinit snippet OMZ::plugins/archlinux/archlinux.plugin.zsh

# AWS, Kubernetes, kubectl context helpers
zinit ice wait"0" lucid as=snippet
zinit snippet OMZ::plugins/aws/aws.plugin.zsh
zinit snippet OMZ::plugins/kubectl/kubectl.plugin.zsh
zinit snippet OMZ::plugins/kubectx/kubectx.plugin.zsh

# Auto-install missing commands (pkgfile integration)
zinit ice wait"0" lucid as=snippet
zinit snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh
```

### Shell Configuration Modules (`~/.config/zshrc.d/`)

**dots-hyprland.zsh**: Quickshell color integration
```zsh
# Sources terminal color sequences generated by quickshell
[[ -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt ]] && \
  source ~/.local/state/quickshell/user/generated/terminal/sequences.txt
```

**auto-Hypr.sh**: Hyprland helper functions
```zsh
# Quick Hyprland config reloading
reload-hyprland() {
    hyprctl reload
    echo "Hyprland reloaded"
}

# Monitor management
list-monitors() {
    hyprctl monitors
}
```

**shortcuts.zsh**: Custom keybinds and aliases
```zsh
# Keybindings
bindkey "^H" backward-kill-word
bindkey "^Z" undo

# Function shortcuts
alias hconf="$EDITOR ~/.config/hypr/custom/"
alias dotfiles="cd ~/lofi-rice"
```

### Essential Aliases

```zsh
# System
alias c='clear'
alias h='history'
alias j='jobs'
alias ports='sudo lsof -i -P -n'

# Directory navigation (zoxide)
alias cd='z'
alias cdi='zi'

# Modern CLI tools
alias ls='eza --color=always'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias du='dust'

# Pacman package management
alias pacu='sudo pacman -Syu'           # Update system
alias paci='sudo pacman -S'             # Install
alias pacr='sudo pacman -R'             # Remove
alias pacs='pacman -Ss'                 # Search
alias pacq='pacman -Q'                  # Query installed

# Git workflow
alias gst='git status'
alias gadd='git add'
alias gcm='git commit -m'
alias glog='git log --oneline'
alias gpush='git push origin'
alias gpull='git pull origin'

# Systemd
alias scst='systemctl status'
alias scr='systemctl restart'
alias jctl='journalctl -xe'
alias jlog='journalctl -u'

# Python venv
alias venv='python -m venv venv && source venv/bin/activate'
alias deactivate='deactivate'

# Docker
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dim='docker images'
```

### FZF Configuration

```zsh
# FZF options
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'
export FZF_COMPLETION_TRIGGER='**'

# FZF-tab configuration
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'systemctl status $word'
```

### Zoxide Integration

```zsh
# Initialize zoxide (replaces `cd`)
eval "$(zoxide init zsh)"

# Frecent directory navigation
# z <directory>         - Jump to directory
# z <pattern>           - Fuzzy search with zoxide
# zi <pattern>          - Interactive selection
```

---

## Keybindings

### Structure & Organization

Keybindings are split into two files:

| File | Lines | Purpose |
|------|-------|---------|
| `hyprland/keybinds.conf` | 269 | Default keybindings (system, Quickshell, media) |
| `custom/keybinds.conf` | 94 | User application launcher keybindings |

**Override Pattern**: Custom keybindings override defaults. To modify a keybinding, create an entry in `custom/keybinds.conf` with the same modifier+key combination.

### Default Keybindings (`hyprland/keybinds.conf`)

#### Quickshell Integration
```bash
# Quickshell launcher
bind = SUPER, slash, exec, quickshell -c ii

# Quickshell workspaces
bind = SUPER, 1, exec, qs -c ii:workspaces:selectWorkspace 0
bind = SUPER, 2, exec, qs -c ii:workspaces:selectWorkspace 1
# ... etc for workspaces 1-10

# Quickshell clipboard
bind = SUPER, C, exec, quickshell -c ii:clipboard

# Quickshell emoji
bind = SUPER, E, exec, quickshell -c ii:emoji

# Quickshell search
bind = SUPER, question, exec, quickshell -c ii:search
```

#### Window & Layout Management
```bash
# Window movement (hjkl keys)
bind = SUPER, H, movefocus, l
bind = SUPER, J, movefocus, d
bind = SUPER, K, movefocus, u
bind = SUPER, L, movefocus, r

# Swap windows in master layout
bind = SUPER CTRL, H, swapwindow, l
bind = SUPER CTRL, J, swapwindow, d
bind = SUPER CTRL, K, swapwindow, u
bind = SUPER CTRL, L, swapwindow, r

# Resize windows
bind = SUPER CTRL ALT, H, resizeactive, -5% 0
bind = SUPER CTRL ALT, L, resizeactive, 5% 0
bind = SUPER CTRL ALT, K, resizeactive, 0 -5%
bind = SUPER CTRL ALT, J, resizeactive, 0 5%

# Layout toggles
bind = SUPER SHIFT, J, togglesplit
bind = SUPER SHIFT, V, togglefloating
bind = SUPER, V, togglefloating, active
bind = SHIFT, F11, fullscreen, 1

# Master layout specific
bind = SUPER, M, layoutmsg, mfact +0.05
bind = SUPER SHIFT, M, layoutmsg, mfact -0.05
```

#### Media Controls
```bash
# Volume
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# Brightness
bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

# Media player (mpris)
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous
```

#### Workspace Navigation
```bash
# Switch workspace
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
# ... 1-10

# Move window to workspace
bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
# ... 1-10

# Special workspace
bind = SUPER, S, togglespecialworkspace
bind = SUPER SHIFT, S, movetoworkspace, special
```

### Custom Keybindings (`custom/keybinds.conf`)

#### Application Launchers

**Web & Media**:
```bash
bind = SUPER, B, exec, vivaldi --new-window
bind = SUPER ALT, B, exec, vivaldi --incognito
bind = SUPER, M, exec, spotify
bind = SUPER, Y, exec, vivaldi https://youtube.com
bind = SUPER, N, exec, vivaldi https://notion.so
bind = SUPER ALT, N, exec, vivaldi https://notebooklm.google.com
bind = SUPER, P, exec, vivaldi https://perplexity.ai
bind = SUPER, R, exec, vivaldi https://reddit.com
bind = SUPER, G, exec, vivaldi https://mail.google.com
bind = SUPER ALT, G, exec, vivaldi https://calendar.google.com
```

**Communication**:
```bash
bind = SUPER, D, exec, discord
bind = SUPER, T, exec, telegram-desktop
bind = SUPER, W, exec, element-desktop
```

**Development & Tools**:
```bash
bind = SUPER SHIFT, C, exec, code
bind = SUPER SHIFT ALT, C, exec, cursor
bind = SUPER, O, exec, obsidian
bind = SUPER, U, exec, vivaldi http://10.8.0.50/ui/
bind = SUPER, A, exec, vivaldi https://chatgpt.com
bind = SUPER ALT, A, exec, ghostty -e numbat
bind = SUPER SHIFT ALT, A, exec, vivaldi https://gemini.google.com
bind = SUPER, T, exec, btop
bind = SUPER, E, exec, dolphin
```

**Gaming**:
```bash
bind = SUPER SHIFT, M, exec, moonlight
```

**System**:
```bash
bind = SUPER, Return, exec, ghostty
bind = SUPER SHIFT, Return, exec, waveterm
bind = SUPER ALT, P, exec, scrcpy --server /data/local/tmp/scrcpy-server
```

#### Configuration Management
```bash
# Quick config editing
bind = CTRL SUPER, slash, exec, ghostty -e "$EDITOR" ~/.config/illogical-impulse/config.json
bind = CTRL SUPER ALT, slash, exec, ghostty -e "$EDITOR" ~/.config/hypr/custom/keybinds.conf

# Reload Hyprland
bind = SUPER, F5, exec, hyprctl reload
bind = SUPER SHIFT, F5, exec, hyprctl reload && notify-send "Hyprland config reloaded"
```

#### Additional Window Controls
```bash
# Kill active window
bind = SUPER, Q, killactive

# Resize mode (custom implementation)
bind = SUPER SHIFT, R, submap, resize
submap = resize
    bind = , Right, resizeactive, 30 0
    bind = , Left, resizeactive, -30 0
    bind = , Up, resizeactive, 0 -30
    bind = , Down, resizeactive, 0 30
    bind = , Escape, submap, reset
submap = reset
```

### How to Add Custom Keybindings

1. **Edit the custom keybinds file**:
```bash
nano ~/.config/hypr/custom/keybinds.conf
```

2. **Add your binding**:
```bash
# Application launcher example
bind = SUPER, V, exec, vivaldi --new-window https://example.com

# Window management example
bind = SUPER SHIFT, W, killactive

# Script execution
bind = SUPER, F1, exec, ~/.config/hypr/scripts/my-custom-script.sh
```

3. **Reload Hyprland**:
```bash
hyprctl reload
```

4. **Test the keybinding**:
```bash
# Verify binding was loaded
hyprctl binds | grep "SUPER"
```

**Common Patterns**:
- `bind = MOD, KEY, exec, command` - Execute command
- `bind = MOD, KEY, killactive` - Kill window
- `bind = MOD, KEY, movefocus, direction` - Move focus
- `bind = MOD, KEY, togglefloating` - Toggle floating
- `bind = MOD, KEY, workspace, number` - Switch workspace

---

## Terminal Configuration

### Ghostty (`~/.config/ghostty/config`)

Modern Wayland-native terminal emulator replacing kitty.

```bash
# Theme
theme = vesper
font-family = Source Code Pro Nerd Font
font-size = 14

# Window appearance
window-decoration = false
padding = 12
background-opacity = 0.85
background-blur-radius = 32

# Cursor
cursor-style = block
cursor-style-blink = true
cursor-color = #ffb400

# Terminal features
scrollback-lines = 3023
mouse-hide-while-typing = true
copy-on-select = false

# Shell integration
shell-integration = auto
shell-integration-features = cursor,sudo,title,no-cursor

# Tab configuration
tab-title-style = focused

# Keybindings
keybind = ctrl+shift+n=new_window
keybind = ctrl+t=new_tab
keybind = ctrl+equal=increase_font_size
keybind = ctrl+minus=decrease_font_size
keybind = ctrl+zero=reset_font_size
keybind = shift+enter=send_text:"\n"

# GTK/Wayland
gtk-tabs-location = top
```

**Theme Options**: Vesper, Catppuccin, Tokyo Night, etc.

**Copy-Paste Integration**:
```bash
# Copy to clipboard
Ctrl+Shift+C

# Paste from clipboard
Ctrl+Shift+V
```

### Waybar Status Bar

Configuration at `~/.config/waybar/config` and `~/.config/waybar/style.css`.

**Key Modules**:
- `cava`: Audio visualizer
- `mpris`: Media player controls
- `custom/playerctl-lyrics`: Song info with lyrics
- `workspaces`: Persistent workspace display per monitor
- `clock`: Date/time display

**Configuration Example**:
```json
{
  "layer": "top",
  "position": "top",
  "height": 32,
  "modules-left": ["hyprland/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["mpris", "cava", "tray"]
}
```

**Monitor-Specific Configs**:
For different monitor layouts, create separate configs:
- `config.DP-2` for portrait monitor
- `config.eDP-1` for laptop screen

Waybar automatically loads monitor-specific configs.

### Terminal Color Integration

Colors are generated dynamically by Quickshell and sourced in Zsh:

```zsh
# ~/.config/zshrc.d/dots-hyprland.zsh
[[ -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt ]] && \
  source ~/.local/state/quickshell/user/generated/terminal/sequences.txt
```

This sources generated terminal color sequences matching your theme.

---

## System Configuration

### Boot Configuration (`/boot/limine.conf`)

**Limine Bootloader** - Modern UEFI bootloader with snapshot support.

```bash
TIMEOUT=0
DEFAULT_ENTRY=2

BACKGROUND_COLOR=0x16213e
FOREGROUND_COLOR=0xffa500

# Omarchy entry (current kernel)
PROTOCOL=stivale2
CMDLINE=cryptdevice=PARTUUID=cb14abfd-9033-44ff-838d-527bb03e82cf:root root=/dev/mapper/root rootflags=subvol=@ rootfstype=btrfs zswap.enabled=0 quiet splash
BOOT_VOLUME_UUID=96f5cfabe92341439a41a2aef70885e8
IMAGE_PATH=/vmlinuz-linux
INITRD_PATH=/initramfs-linux.img

# Fallback entry (previous kernel)
PROTOCOL=stivale2
CMDLINE=cryptdevice=PARTUUID=cb14abfd-9033-44ff-838d-527bb03e82cf:root root=/dev/mapper/root rootflags=subvol=@ rootfstype=btrfs zswap.enabled=0 quiet splash
BOOT_VOLUME_UUID=96f5cfabe92341439a41a2aef70885e8
IMAGE_PATH=/vmlinuz-linux-fallback
INITRD_PATH=/initramfs-linux-fallback.img
```

**Parameters Explained**:
- `cryptdevice=`: LUKS encrypted partition mapping
- `root=`: Mount point after LUKS unlock
- `rootflags=subvol=@`: BTRFS subvolume
- `rootfstype=btrfs`: Filesystem type
- `zswap.enabled=0`: Disable compressed memory (save GPU memory)
- `quiet splash`: Minimal boot output with logo

### Initramfs Configuration (`/etc/mkinitcpio.conf`)

Generates the initial RAM filesystem for boot.

```bash
MODULES=(btrfs)

BINARIES=(/usr/bin/btrfs)

FILES=()

HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```

**Hook Order (Critical)**:
1. `base` - Base runtime utilities
2. `udev` - Device manager
3. `autodetect` - Auto-detect loaded modules
4. `microcode` - CPU microcode updates
5. `modconf` - Modprobe configuration
6. `kms` - Kernel mode setting (early GPU init)
7. `keyboard` - Keyboard support
8. `keymap` - Keyboard layout
9. `consolefont` - Console font
10. `block` - Block device support
11. `encrypt` - LUKS encryption (MUST come before filesystems)
12. `filesystems` - Filesystem support
13. `fsck` - Filesystem check

**After Modification**:
```bash
sudo mkinitcpio -P
```

### GPU Driver Configuration (`/etc/modprobe.d/intel-graphics.conf`)

Intel Arrow Lake-P GPU driver configuration.

```bash
# Enable i915 driver (critical for Hyprland stability)
options i915 enable_gvt=1
options i915 force_probe=7d51
```

**Troubleshooting GPU Issues**:
```bash
# Check if i915 is loaded
lsmod | grep i915

# Verify GPU device exists
ls -la /dev/dri/

# Check driver in use
for card in /sys/class/drm/card*/device/driver; do
    echo "$card: $(basename $(readlink $card))"
done

# Emergency fix script
~/fix-hyprland-gpu.sh
```

### Package Manager (`/etc/pacman.conf`)

Arch Linux package manager configuration.

```bash
[options]
Architecture = auto
Color = ILoveCandy
ParallelDownloads = 5
SigLevel = Required DatabaseOptional

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

[warpdotdev]
Server = https://releases.warp.dev/linux/pacman
```

**Update System**:
```bash
sudo pacman -Syu
```

---

## Theme & Color Schemes

### Theme Management System (Omarchy/illogical-impulse)

Centralized configuration in `/home/lofi/.config/illogical-impulse/config.json`.

```json
{
  "theme": {
    "name": "catppuccin",
    "variant": "mocha",
    "dynamicColors": true,
    "wallpaperTheming": true
  },
  "appearance": {
    "fontStack": {
      "main": "Inter",
      "expressive": "Space Grotesk",
      "monospace": "JetBrains Mono Nerd Font"
    },
    "transparency": {
      "background": 0.11,
      "content": 0.57
    },
    "accentColor": "#cba6f7"
  },
  "apps": {
    "terminal": "ghostty",
    "launcher": "vicinae",
    "fileManager": "dolphin"
  }
}
```

### Color Scheme Variants

Available themes:
- `catppuccin` (mocha, latte, frappe, macchiato)
- `gruvbox` (dark, light)
- `everforest` (hard, medium, soft)
- `tokyo-night`
- `kanagawa`
- `flexoki`

### Dynamic Color Generation (Quickshell)

Quickshell generates terminal color sequences at runtime:

```bash
Location: ~/.local/state/quickshell/user/generated/terminal/sequences.txt

# Sourced in Zsh:
[[ -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt ]] && \
  source ~/.local/state/quickshell/user/generated/terminal/sequences.txt
```

**Regenerate Colors**:
```bash
# Restart quickshell
killall quickshell
hyprctl dispatch exec "quickshell -c ii &"

# Or manually in Zsh
source ~/.local/state/quickshell/user/generated/terminal/sequences.txt
```

### Wallpaper Integration

Wallpaper path configured in illogical-impulse:

```json
{
  "wallpaper": "/home/lofi/Pictures/Wallpapers/od_underwater.png",
  "theming": {
    "generateFromWallpaper": true,
    "applyToTerminal": true,
    "applyToQt": true,
    "applyToWayland": true
  }
}
```

**Change Wallpaper**:
```bash
# Update config
nano ~/.config/illogical-impulse/config.json  # Change wallpaper path

# Restart theme system
killall quickshell
hyprctl dispatch exec "quickshell -c ii &"
```

---

## Package Management

### Essential Packages List

**Core System**:
```bash
base linux linux-firmware
efibootmgr limine
btrfs-progs dosfstools
cryptsetup mkinitcpio
```

**Display & Wayland**:
```bash
hyprland hyprlock hypridle hyprpicker hyprlandwithdeps
wayland wayland-protocols wl-clipboard wl-paste
qt5-wayland qt6-wayland
libxcb xcb-util-wm
```

**Shell & Terminal**:
```bash
zsh ghostty
bat eza fzf ripgrep fd zoxide
```

**UI & Status**:
```bash
waybar dunst cliphist
qt5-platformtheme-kde qt6-platformtheme-kde
kde-applications
```

**Audio & Media**:
```bash
pipewire pipewire-pulse wireplumber
easyeffects pulseaudio-utils
mpv vlc
```

**Development**:
```bash
git base-devel
nodejs npm
python python-pip
code
```

**AUR Packages** (using yay/paru):
```bash
quickshell
vicinae
illogical-impulse
nwg-displays
playerctl-spotify-lyrics
```

### Package Installation

**Install from Official Repos**:
```bash
sudo pacman -S package1 package2 package3
```

**Search for Packages**:
```bash
pacman -Ss search-term
```

**Install from AUR**:
```bash
# Using yay
yay -S aur-package

# Using paru
paru -S aur-package
```

**Update System**:
```bash
sudo pacman -Syu
```

**Clean Package Cache**:
```bash
# Remove all cached versions
sudo pacman -Sc

# Remove all cached versions (including uninstalled)
sudo pacman -Scc
```

---

## Customization Guide

### Adding a New Application Launcher

**1. Add keybinding in `~/.config/hypr/custom/keybinds.conf`**:

```bash
# My custom app launcher
bind = SUPER, X, exec, my-app --flag
```

**2. Reload Hyprland**:
```bash
hyprctl reload
```

**3. Test the binding**:
```bash
# Manually run the command
my-app --flag

# Verify in Hyprland binds list
hyprctl binds | grep "SUPER, X"
```

### Modifying Window Rules

Window rules control how specific applications are opened.

**Location**: `~/.config/hypr/custom/rules.conf`

**Examples**:
```bash
# Open Discord floating and centered
windowrulev2 = float, class:^(discord)$
windowrulev2 = center, class:^(discord)$
windowrulev2 = size 800 600, class:^(discord)$

# Spotify in workspace 3
windowrulev2 = workspace 3, class:^(spotify)$

# Games in fullscreen
windowrulev2 = fullscreen, class:^(lutris)$
windowrulev2 = fullscreen, class:^(steam)$

# Notifications layer
windowrulev2 = layer top, class:^(notification)$

# Pin to all workspaces
windowrulev2 = pin, class:^(always-visible-app)$
```

**Test Window Rules**:
```bash
# Get window class
hyprctl activewindow

# Apply rule immediately (without reload)
hyprctl keyword windowrulev2 "float, class:^(myapp)$"
```

### Changing Monitor Layout

**Using GUI**:
```bash
nwg-displays
```

**Manually in `~/.config/hypr/monitors.conf`**:

```bash
# Laptop screen
monitor = eDP-1, 1920x1200@60, 0x0, 1.0

# External monitor (2560x1440)
monitor = DP-1, 2560x1440@60, 1920x0, 1.0

# Fallback
monitor = , preferred, auto, 1
```

**Reload**:
```bash
hyprctl reload
```

### Creating Custom Aliases

**Location**: `~/.config/zshrc.d/shortcuts.zsh`

```bash
# Application aliases
alias openmail='vivaldi https://mail.google.com'
alias opencal='vivaldi https://calendar.google.com'

# Directory aliases
alias dotfiles='cd ~/lofi-rice'
alias projects='cd ~/Projects'

# Function aliases
function serve() {
    python -m http.server $1
}

# Git shortcuts
alias gpushall='git push origin --all'
alias gfetch='git fetch origin'
```

**Reload Shell**:
```bash
source ~/.zshrc
```

### Changing Color Scheme

**1. Edit illogical-impulse config**:
```bash
nano ~/.config/illogical-impulse/config.json
```

**2. Change theme**:
```json
{
  "theme": {
    "name": "gruvbox",
    "variant": "dark"
  }
}
```

**3. Restart theme system**:
```bash
killall quickshell
hyprctl dispatch exec "quickshell -c ii &"
```

**4. Reload terminal colors in Zsh**:
```bash
source ~/.local/state/quickshell/user/generated/terminal/sequences.txt
```

### Adding GPU Optimizations

**Edit GPU driver config** (requires sudo):
```bash
sudo nano /etc/modprobe.d/intel-graphics.conf
```

**Add performance options**:
```bash
# Enable GuC firmware
options i915 enable_guc=3

# Enable PSR (Panel Self-Refresh)
options i915 enable_psr=1

# Force probe GPU
options i915 force_probe=7d51
```

**Rebuild initramfs**:
```bash
sudo mkinitcpio -P
```

**Reboot** to apply changes.

---

## Troubleshooting

### Hyprland Crashes or GPU Issues

**Symptom**: Hyprland crashes or fails to start

**Diagnosis**:
```bash
# Check i915 driver loaded
lsmod | grep i915

# Verify GPU device exists
ls -la /dev/dri/

# Check for GPU-related errors
journalctl -u hyprland -xe

# Check GPU driver in use
for card in /sys/class/drm/card*/device/driver; do
    echo "$card: $(basename $(readlink $card))"
done
```

**Solution**:
```bash
# Run GPU fix script
~/fix-hyprland-gpu.sh

# Or manually re-enable i915
sudo nano /etc/modprobe.d/intel-graphics.conf
# Ensure lines are NOT blacklisting i915

# Rebuild initramfs
sudo mkinitcpio -P

# Reboot
sudo reboot
```

### Shell Startup Slow

**Symptom**: Zsh takes >1 second to start

**Diagnosis**:
```bash
# Time shell startup
time zsh -i -c exit

# Profile startup
zsh -xvs 2>&1 | head -50
```

**Solution**:
```bash
# Clear completion cache
rm -f ~/.zcompcache

# Use turbo mode more aggressively in .zshrc
# Add wait="" to more plugins

# Defer heavy plugins
zinit ice wait"2" lucid
zinit light slow-plugin

# Reload
source ~/.zshrc
```

### Monitor Not Detected

**Symptom**: Monitor doesn't appear in monitor list

**Diagnosis**:
```bash
# List connected monitors
hyprctl monitors

# Check with Wayland tool
wlr-randr

# Check /sys/class/drm/
ls /sys/class/drm/*/status

# Check driver logs
journalctl -xe | grep -i display
```

**Solution**:
```bash
# Use nwg-displays GUI
nwg-displays

# Or manually add to monitors.conf
echo 'monitor = DP-2, preferred, auto, 1' >> ~/.config/hypr/monitors.conf

# Reload
hyprctl reload
```

### Keybinding Not Working

**Symptom**: Keybinding doesn't trigger application

**Diagnosis**:
```bash
# List all bindings
hyprctl binds

# Check if binding exists
hyprctl binds | grep "SUPER"

# Verify application installed
which myapp

# Test command manually
myapp

# Check for syntax errors
cat ~/.config/hypr/custom/keybinds.conf | grep "bind ="
```

**Solution**:
```bash
# Check syntax
# Format: bind = MODIFIERS, KEY, ACTION, COMMAND

# Verify modifiers
# SUPER, SHIFT, CTRL, ALT, ALTGR

# Reload
hyprctl reload

# Manual test
hyprctl keyword bind 'SUPER, X, exec, myapp'
```

### Theme Colors Not Applying

**Symptom**: Colors don't match theme in terminal or apps

**Solution**:
```bash
# Regenerate colors
killall quickshell
hyprctl dispatch exec "quickshell -c ii &"

# Reload terminal colors
source ~/.local/state/quickshell/user/generated/terminal/sequences.txt

# Check color files exist
ls -la ~/.local/state/quickshell/user/generated/terminal/

# Restart terminal
killall ghostty  # or your terminal
ghostty &
```

### Performance Issues with Multiple Monitors

**Symptom**: Stuttering, lag, or high CPU/GPU usage

**Solution - Already Applied in custom/general.conf**:
```bash
# Disable blur (major performance hit)
decoration {
    blur {
        enabled = false
    }
    drop_shadow = false
}

# Enable VRR
misc {
    vfr = true
    vrr = 2
}

# Use simpler animations
animation = windows, 1, 3, default, popin 90%

# Reduce animation passes
animation = border, 1, 5, default
```

**Additional Optimizations**:
```bash
# Disable unused monitors temporarily
hyprctl keyword monitor "HDMI-A-1, disable"

# Reduce refreshrate on some monitors
hyprctl keyword monitor "DP-2, 1920x1080@60, 0x0, 1.0"

# Close resource-heavy apps
pkill chrome
pkill slack
```

### LUKS/Boot Issues

**Symptom**: Can't unlock encrypted partition or boot fails

**Diagnosis**:
```bash
# Check LUKS status
sudo cryptsetup luksDump /dev/nvme0n1p3  # or your partition

# Check kernel logs
sudo journalctl -b | grep -i luks

# Check boot logs
sudo journalctl -b -p err
```

**Solution**:
```bash
# Boot from USB rescue environment

# Open encrypted partition
sudo cryptsetup open /dev/nvme0n1p3 root

# Mount BTRFS
sudo mount -t btrfs /dev/mapper/root /mnt

# Check contents
sudo ls /mnt

# Repair if needed
sudo btrfs check /dev/mapper/root
```

### BTRFS Snapshot Recovery

**Boot from snapshot**:
```bash
# In Limine bootloader, select snapshot entry from boot menu

# Or manually in emergency shell
sudo btrfs subvolume list /
sudo mount -t btrfs -o subvol=@snapshot-date /dev/mapper/root /mnt
```

---

## Best Practices & Maintenance

### Regular Backups

```bash
# Backup configuration
cp -r ~/.config ~/.config.backup.$(date +%Y%m%d)

# Backup dotfiles repo
cd ~/lofi-rice
git add -A
git commit -m "Backup config - $(date)"
git push origin main
```

### System Updates

```bash
# Check for updates
sudo pacman -Syu --download-only

# Apply updates
sudo pacman -Syu

# Clean cache
sudo pacman -Sc

# Check for broken dependencies
sudo pacman -Dk
```

### Monitoring System Health

```bash
# Check disk usage
df -h /
du -sh ~/.config

# Check system resources
btop  # Interactive
htop  # Simpler alternative

# Check GPU
glxinfo | grep -i "opengl.*version"

# Check thermal
sensors
```

### Git Workflow for Dotfiles

```bash
# Check status
cd ~/lofi-rice
git status

# Stage changes
git add .

# Commit with message
git commit -m "Update Hyprland config - improved animations"

# Push to remote
git push origin main

# View history
git log --oneline -10
```

---

## Quick Reference: Common Commands

```bash
# Hyprland management
hyprctl reload                    # Reload configuration
hyprctl monitors                  # List connected monitors
hyprctl binds                     # List all keybindings
hyprctl activewindow              # Get active window info
hyprctl clients                   # List all windows

# Display management
nwg-displays                      # GUI monitor configuration
wlr-randr                         # Command-line monitor info

# Zsh/Shell
source ~/.zshrc                   # Reload shell config
echo $SHELL                       # Check current shell
history                           # View command history

# Package management
sudo pacman -Syu                  # Update system
pacman -Ss term                   # Search packages
sudo pacman -S ghostty            # Install package
yay -S quickshell                 # Install AUR package

# System info
neofetch                          # System information
lsb_release -a                    # Arch info
uname -a                          # Kernel info

# GPU debugging
lsmod | grep i915                 # Check driver
ls /dev/dri/                      # GPU devices
glxinfo | head -20                # OpenGL info

# Troubleshooting
journalctl -xe                    # Recent errors
coredumpctl list                  # Crash dumps
dmesg | tail -20                  # Kernel messages
```

---

## Additional Resources

- **Hyprland Documentation**: https://wiki.hyprland.org/
- **Arch Linux Wiki**: https://wiki.archlinux.org/
- **Zsh Plugin Guide**: https://github.com/zdharma-continuum/zinit
- **Ghostty Terminal**: https://mitchellh.com/posts/ghostty
- **Quickshell**: https://github.com/quickshell
- **Wayland Protocol**: https://wayland.freedesktop.org/

---

**Last Updated**: 2025-12-21
**System**: Arch Linux + Hyprland (lofi-rice)
**Maintainer**: Lofiwaffle

For updates and contributions, see: https://github.com/Lofiwaffle/lofi-rice
