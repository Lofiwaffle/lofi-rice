# Scripts Documentation

Overview of all installation and maintenance scripts in the lofi-rice repository.

## 🎯 Main Installer

### `install.sh` (Master Installer)

**Location:** Repository root
**Purpose:** Interactive installation orchestrator
**Usage:**
```bash
./install.sh              # Interactive mode with options
./install.sh --auto       # Fully automated installation
./install.sh --help       # Show help
```

**Features:**
- ✅ Interactive installation with choices
- ✅ Pre-installation checks (Arch Linux, internet)
- ✅ Automatic backup of existing configs
- ✅ Component selection (full/packages/configs/custom)
- ✅ Monitor configuration assistance
- ✅ Optional automated backup setup
- ✅ Comprehensive summary and next steps
- ✅ Detailed logging to `install-YYYYMMDD-HHMMSS.log`

**Options:**
1. **Full installation** - Everything (recommended)
2. **Packages only** - Just install system packages
3. **Configurations only** - Restore configs (requires packages)
4. **Custom** - Pick individual components

---

## 📦 Individual Scripts

### `backup-current-configs.sh`

**Purpose:** Backs up current system configuration to repository
**Usage:**
```bash
./scripts/backup-current-configs.sh
```

**What it backs up:**
- Package lists (official + AUR)
- Hyprland configuration
- Application configs (Waybar, Kitty, Dunst, etc.)
- Shell configurations (.zshrc, .p10k.zsh)
- Custom scripts and desktop entries
- Systemd service list

**Output:**
- Updates files in `packages/`, `config/`, `shell/`, etc.
- Creates categorized package lists

**When to run:**
- After making configuration changes
- Before pushing to GitHub
- Periodically to keep backup updated

---

### `install-packages.sh`

**Purpose:** Installs all required system packages
**Usage:**
```bash
./scripts/install-packages.sh
```

**What it does:**
1. Checks for Arch Linux
2. Installs `base-devel` if missing
3. Installs Paru (AUR helper) if not present
4. Updates system with `pacman -Syu`
5. Installs all official repo packages (~127)
6. Installs all AUR packages (~113)

**Package sources:**
- `packages/explicit-packages.txt` - All packages
- `packages/aur-packages.txt` - AUR-only packages

**Duration:** 15-30 minutes (depends on internet speed)

**Requirements:**
- Root/sudo access
- Active internet connection
- ~2-3GB free disk space

---

### `restore-configs.sh`

**Purpose:** Restores all configuration files from repository
**Usage:**
```bash
./scripts/restore-configs.sh
```

**What it does:**
1. Creates backup of existing configs
2. Restores Hyprland configuration
3. Restores application configs
4. Copies shell configurations
5. Installs custom scripts to `~/.local/bin`
6. Adds custom desktop entries

**Backup location:**
- `~/.config-backup-YYYYMMDD-HHMMSS/`

**Restored directories:**
- `~/.config/hypr/`
- `~/.config/waybar/`
- `~/.config/kitty/`
- And 15+ other application configs

**Important:**
- Run this AFTER installing packages
- Monitor config may need adjustment
- Review backup location before reboot

---

### `enable-services.sh`

**Purpose:** Enables required systemd user services
**Usage:**
```bash
./scripts/enable-services.sh
```

**Services enabled:**
- **Audio:** pipewire, wireplumber
- **Docker:** Docker Desktop (if installed)
- **System:** XDG user directories, ydotool
- **Security:** GNOME Keyring
- **Optional:** Battery monitor

**Notes:**
- Some services may not exist (non-critical)
- Audio services are started immediately
- Others start on next login

---

### `setup-auto-backup.sh`

**Purpose:** Sets up automated daily backup (local only, no Git commit/push)
**Usage:**
```bash
./scripts/setup-auto-backup.sh
```

**What it creates:**
- `~/.config/systemd/user/dotfiles-backup.service`
- `~/.config/systemd/user/dotfiles-backup.timer`

**What it does:**
- ✅ Backs up configs daily
- ❌ Does NOT commit to Git
- ❌ Does NOT push to GitHub

**Schedule:**
- Daily at midnight
- 15 minutes after boot

**Note:** You must manually commit and push changes to GitHub.

---

### `setup-full-auto-backup.sh` 🆕

**Purpose:** Sets up FULL automated backup with Git commit and push
**Usage:**
```bash
./scripts/setup-full-auto-backup.sh
```

**Prerequisites:**
- Git repository initialized
- GitHub remote configured
- SSH keys setup for GitHub

**What it creates:**
- `~/.config/systemd/user/dotfiles-backup-git.service`
- `~/.config/systemd/user/dotfiles-backup-git.timer`
- `~/lofi-rice/auto-backup.log`

**What it does:**
- ✅ Backs up configs daily
- ✅ Commits changes to Git automatically
- ✅ Pushes to GitHub automatically

**Schedule:**
- Daily at midnight
- 15 minutes after boot

**Useful commands:**
```bash
# Check timer status
systemctl --user list-timers

# Run backup manually
systemctl --user start dotfiles-backup-git.service

# View systemd logs
journalctl --user -u dotfiles-backup-git.service

# View detailed backup log
tail -f ~/lofi-rice/auto-backup.log

# Disable automated backups
systemctl --user disable dotfiles-backup-git.timer
```

**See:** `../docs/AUTO-BACKUP.md` for complete guide

---

### `auto-backup-git.sh` 🆕

**Purpose:** Core script for full automated backup with Git sync
**Usage:**
```bash
./scripts/auto-backup-git.sh
```

**What it does:**
1. Runs `backup-current-configs.sh`
2. Checks for changes
3. Commits changes (if any)
4. Pushes to GitHub (if remote configured)
5. Logs all activity to `auto-backup.log`

**Note:** Usually called by systemd timer, not manually

---

### `init-git.sh`

**Purpose:** Initializes Git repository with proper configuration
**Usage:**
```bash
./scripts/init-git.sh
```

**What it does:**
1. Initializes Git repository
2. Creates `.gitignore` file
3. Sets up commit message template
4. Stages all files
5. Shows status and next steps

**After running:**
1. Review staged files
2. Create initial commit
3. Add GitHub remote
4. Push to GitHub

**Example workflow:**
```bash
./scripts/init-git.sh
git commit -m "Initial commit: lofi-rice dotfiles"
git remote add origin git@github.com:USERNAME/lofi-rice.git
git push -u origin main
```

---

## 🔄 Typical Workflows

### First-Time Setup

```bash
# 1. Clone repository
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice

# 2. Run master installer
./install.sh

# 3. Follow prompts, reboot when done
```

### Updating Configuration

```bash
# 1. Make changes to your system
# 2. Backup changes to repository
./scripts/backup-current-configs.sh

# 3. Commit and push
git add .
git commit -m "Update: description"
git push
```

### Restoring on Another Machine

```bash
# Option 1: Interactive
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice
./install.sh

# Option 2: Automated
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice
./install.sh --auto
```

### Manual Installation

```bash
# If you prefer to run scripts individually
./scripts/install-packages.sh
./scripts/restore-configs.sh
./scripts/enable-services.sh
```

---

## 🐛 Troubleshooting

### Script won't execute

```bash
# Make script executable
chmod +x ./scripts/script-name.sh

# Or run with bash
bash ./scripts/script-name.sh
```

### Package installation fails

```bash
# Update package lists first
pacman -Syu

# Check internet connection
ping archlinux.org

# Try running individually
./scripts/install-packages.sh
```

### Services fail to enable

```bash
# Check if service exists
systemctl --user list-unit-files | grep pipewire

# Enable manually
systemctl --user enable pipewire.socket

# Check status
systemctl --user status pipewire.socket
```

---

## 📝 Script Dependencies

```
install.sh (master)
    ├── backup-current-configs.sh (optional)
    ├── install-packages.sh
    ├── restore-configs.sh
    ├── enable-services.sh
    └── setup-auto-backup.sh (optional)
```

**Independent scripts:**
- `backup-current-configs.sh` - Can run anytime
- `init-git.sh` - Run once to initialize Git

---

## 🔒 Safety Features

All scripts include:
- ✅ Error checking (`set -e`)
- ✅ Backup creation before overwriting
- ✅ User confirmation prompts (interactive mode)
- ✅ Detailed logging
- ✅ Status messages and progress indicators

---

## 📚 Additional Resources

- **Main README:** `../README.md`
- **Installation Guide:** `../docs/INSTALL.md`
- **Quick Start:** `../INSTALL-QUICK.md`
- **Setup Guide:** `../SETUP.md`
- **Troubleshooting:** `../docs/TROUBLESHOOTING.md`

---

**Last Updated:** 2025-10-29
