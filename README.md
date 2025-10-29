# lofi-rice 🌊

> **Arch Linux + Hyprland desktop environment configuration**
> A complete, reproducible dotfiles repository for restoring my desktop setup from GitHub

<img src="https://img.shields.io/badge/Arch-Linux-1793D1?logo=arch-linux&logoColor=fff" alt="Arch Linux" />
<img src="https://img.shields.io/badge/Hyprland-Wayland-blue" alt="Hyprland" />
<img src="https://img.shields.io/badge/Shell-Zsh-green" alt="Zsh" />

---

## 📖 Overview

This repository contains my personal Arch Linux desktop environment configuration, centered around **Hyprland** (Wayland compositor) with a sophisticated workflow setup. The configuration is based on the **Illogical Impulse** Hyprland distribution with extensive custom modifications.

### Key Features

- 🪟 **Hyprland** - Dynamic tiling Wayland compositor
- 📊 **Waybar** - Customizable status bar with audio visualizer
- 🐱 **Kitty** - GPU-accelerated terminal emulator
- 🔍 **Rofi/Fuzzel** - Application launchers
- 🔔 **Swaync/Dunst** - Notification system
- 🎨 **GTK3/4 + Qt5/6** - Unified theming
- 🔒 **Hyprlock** - Screen locker with custom styling
- 🌐 **Multi-monitor** support (5 displays configured)
- ⚡ **Custom keybindings** for productivity apps

---

## 📸 Screenshots

_TODO: Add screenshots of your desktop_

---

## 🚀 Quick Start

### Prerequisites

- Arch Linux installed
- Internet connection
- Git installed

### Fresh Installation

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice

# Install all packages (requires ~2GB download)
./scripts/install-packages.sh

# Restore configurations
./scripts/restore-configs.sh

# Enable systemd services
./scripts/enable-services.sh

# Log out and log back in (or reboot)
```

### Updating Existing System

```bash
# Pull latest changes
git pull

# Restore updated configs
./scripts/restore-configs.sh
```

---

## 📦 What's Included

### Core Components

| Component | Description | Config Location |
|-----------|-------------|-----------------|
| **Hyprland** | Wayland compositor | `config/hypr/` |
| **Waybar** | Status bar | `config/waybar/` |
| **Kitty** | Terminal emulator | `config/kitty/` |
| **Rofi** | App launcher | `config/rofi/` |
| **Dunst/Swaync** | Notifications | `config/dunst/`, `config/swaync/` |
| **GTK/Qt** | Theme configs | `config/gtk-{3,4}.0/`, `config/qt{5,6}ct/` |

### Package Categories

- **~180** official repository packages
- **~65** AUR packages
- See `packages/categories/` for detailed breakdown by type

---

## 🎮 Keybindings

### Most Important

| Keybind | Action |
|---------|--------|
| `Super + Return` | Terminal (Kitty) |
| `Super + Q` | Close window |
| `Super + O` | Obsidian |
| `Super + W` | Web browser |
| `Super + E` | File manager |
| `Super + Space` | App launcher (Rofi) |
| `Super + L` | Lock screen |
| `Super + Shift + S` | Screenshot (region) |
| `Super + V` | Clipboard history |
| `Super + Period` | Emoji picker |

**📖 Full keybindings reference:** See [docs/KEYBINDS.md](docs/KEYBINDS.md)

---

## 📁 Repository Structure

```
lofi-rice/
├── README.md                    # This file
├── scripts/                     # Installation and maintenance scripts
│   ├── backup-current-configs.sh
│   ├── install-packages.sh
│   ├── restore-configs.sh
│   ├── enable-services.sh
│   ├── setup-auto-backup.sh
│   └── init-git.sh
├── packages/                    # Package lists
│   ├── explicit-packages.txt    # All explicitly installed packages
│   ├── aur-packages.txt         # AUR-only packages
│   └── categories/              # Categorized package lists
├── config/                      # Application configurations
│   ├── hypr/                    # Hyprland configs
│   ├── waybar/                  # Status bar
│   ├── kitty/                   # Terminal
│   ├── gtk-3.0/, gtk-4.0/       # GTK theming
│   └── ...                      # Other app configs
├── shell/                       # Shell configurations
│   ├── .zshrc
│   └── .p10k.zsh
├── local/                       # User-local files
│   ├── bin/                     # Custom scripts/binaries
│   └── share/applications/      # Custom .desktop entries
├── systemd/                     # Systemd configuration
│   └── user/
└── docs/                        # Documentation
    ├── KEYBINDS.md
    ├── INSTALL.md
    └── TROUBLESHOOTING.md
```

---

## 🔧 Customization

### Modifying Keybindings

Edit Hyprland keybindings:
```bash
nano ~/.config/hypr/custom/keybinds.conf
```

Then reload Hyprland:
```bash
hyprctl reload
```

### Adjusting Monitor Setup

Your monitor configuration is in:
```bash
nano ~/.config/hypr/monitors.conf
```

Detect connected monitors:
```bash
hyprctl monitors
```

### Changing Theme Colors

The color scheme is defined in:
```bash
~/.config/hypr/hyprland/colors.conf
```

---

## 🛠️ Maintenance

### Backup Current Configs

```bash
cd ~/lofi-rice
./scripts/backup-current-configs.sh
git add .
git commit -m "Update: $(date +%Y-%m-%d)"
git push
```

### Setup Automated Backups

```bash
./scripts/setup-auto-backup.sh
```

This creates a systemd timer that backs up configs daily.

### Update Package Lists

```bash
pacman -Qe | awk '{print $1}' > packages/explicit-packages.txt
pacman -Qm | awk '{print $1}' > packages/aur-packages.txt
```

---

## 📚 Documentation

- **[INSTALL.md](docs/INSTALL.md)** - Detailed installation guide
- **[KEYBINDS.md](docs/KEYBINDS.md)** - Complete keybinding reference
- **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Common issues and solutions

---

## 🖥️ System Specifications

### Tested On

- **OS:** Arch Linux (kernel 6.17.5-arch1-1)
- **Compositor:** Hyprland (based on Illogical Impulse)
- **Shell:** Zsh with Zinit + Powerlevel10k
- **Terminal:** Kitty
- **Display:** 5-monitor setup (including portrait displays)

### Hardware

- **CPU:** AMD Ryzen 7 3700X
- **RAM:** 128GB
- **GPU:** NVIDIA RTX 3060 (with Wayland support)
- **Storage:** NVMe SSD

---

## 🐛 Troubleshooting

### Hyprland won't start

```bash
# Check Hyprland logs
cat ~/.hyprland.log

# Try starting manually
Hyprland
```

### Monitor configuration issues

```bash
# List connected monitors
hyprctl monitors

# Adjust monitors.conf accordingly
nano ~/.config/hypr/monitors.conf
```

### Audio not working

```bash
# Restart audio services
systemctl --user restart pipewire.socket
systemctl --user restart wireplumber.service

# Check audio status
wpctl status
```

**More solutions:** See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:

- Fork it for your own use
- Open issues for questions
- Submit PRs for improvements

---

## 📄 License

MIT License - Feel free to use and modify for your own setup

---

## 🙏 Acknowledgments

- **[Hyprland](https://hyprland.org/)** - The amazing Wayland compositor
- **[Illogical Impulse](https://github.com/end-4/dots-hyprland)** - Base Hyprland configuration
- **Arch Linux community** - For the incredible documentation
- **r/unixporn** - For inspiration

---

## 📞 Contact

- **GitHub:** [@YOUR_USERNAME](https://github.com/YOUR_USERNAME)
- **Obsidian vault:** See my [mind repository](https://github.com/YOUR_USERNAME/mind) for my second brain

---

<p align="center">Made with ❤️ and ☕ on Arch Linux</p>
