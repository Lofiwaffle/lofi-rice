# Quick Setup Guide

Fast-track guide to get your lofi-rice backup ready for GitHub.

## ✅ What's Been Done

Your Arch Linux + Hyprland configuration has been backed up to:
**`/home/lofi/lofi-rice/`**

### Backed Up Components

- ✅ **240 packages** (113 from AUR)
- ✅ **Hyprland configuration** (complete with custom keybinds)
- ✅ **Waybar** status bar config
- ✅ **Kitty** terminal config
- ✅ **Application configs** (dunst, rofi, wlogout, swayosd, etc.)
- ✅ **GTK/Qt theming**
- ✅ **Shell configs** (.zshrc, .p10k.zsh)
- ✅ **86 total files** organized and ready

### Created Scripts

| Script | Purpose |
|--------|---------|
| `backup-current-configs.sh` | Backup current system to repo |
| `install-packages.sh` | Install all packages on fresh system |
| `restore-configs.sh` | Restore configurations |
| `enable-services.sh` | Enable systemd services |
| `setup-auto-backup.sh` | Setup automated daily backups |
| `init-git.sh` | Initialize Git repository |

### Created Documentation

- ✅ **README.md** - Complete project overview
- ✅ **INSTALL.md** - Step-by-step installation guide
- ✅ **KEYBINDS.md** - Full keybinding reference
- ✅ **TROUBLESHOOTING.md** - Common issues and solutions

---

## 🚀 Next Steps

### 1. Initialize Git Repository

```bash
cd ~/lofi-rice
./scripts/init-git.sh
```

This will:
- Initialize git
- Create .gitignore
- Stage all files
- Set up commit template

### 2. Create Initial Commit

```bash
cd ~/lofi-rice
git commit -m "Initial commit: Complete Arch + Hyprland dotfiles backup"
```

### 3. Create GitHub Repository

Go to: https://github.com/new

- **Repository name:** `lofi-rice`
- **Description:** "Arch Linux + Hyprland desktop environment configuration"
- **Visibility:** Choose Public or Private
- **Do NOT** initialize with README (you already have one)

### 4. Push to GitHub

```bash
cd ~/lofi-rice

# Add your GitHub remote (replace YOUR_USERNAME)
git remote add origin git@github.com:YOUR_USERNAME/lofi-rice.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 5. Update Obsidian Project

Your project note at:
`/home/lofi/mind/mind/02 Projects/lofi-rice.md`

Add this information:
```markdown
## Repository Information

- **Local Path:** `/home/lofi/lofi-rice/`
- **GitHub URL:** https://github.com/YOUR_USERNAME/lofi-rice
- **Files Backed Up:** 86 configuration files
- **Packages:** 240 total (113 AUR)

## Quick Commands

Update backup:
\`\`\`bash
cd ~/lofi-rice
./scripts/backup-current-configs.sh
git add .
git commit -m "Update: $(date +%Y-%m-%d)"
git push
\`\`\`

Restore on new system:
\`\`\`bash
git clone https://github.com/YOUR_USERNAME/lofi-rice.git
cd lofi-rice
./scripts/install-packages.sh
./scripts/restore-configs.sh
./scripts/enable-services.sh
reboot
\`\`\`
```

---

## 🔄 Maintaining Your Backup

### Daily/Weekly Updates

```bash
cd ~/lofi-rice
./scripts/backup-current-configs.sh
git add .
git commit -m "Update configs: $(date +%Y-%m-%d)"
git push
```

### Automated Backups

Setup daily automatic backups:

```bash
cd ~/lofi-rice
./scripts/setup-auto-backup.sh
```

This creates a systemd timer that backs up daily at midnight.

---

## 📦 What Gets Backed Up

### Configuration Directories

```
config/
├── hypr/               # Hyprland + Hypridle + Hyprlock
├── waybar/             # Status bar
├── kitty/              # Terminal
├── dunst/              # Notifications
├── wlogout/            # Logout menu
├── gtk-3.0/gtk-4.0/    # GTK theming
├── qt5ct/qt6ct/        # Qt theming
├── alacritty/          # Alt terminal
├── foot/               # Alt terminal
├── swayosd/            # OSD
├── cava/               # Audio visualizer
├── fastfetch/          # System info
└── fontconfig/         # Font config
```

### Key Files

- **Package lists** - All installed packages
- **Shell configs** - .zshrc, .p10k.zsh
- **Custom scripts** - ~/.local/bin/*
- **Desktop entries** - Custom .desktop files
- **Systemd services** - Enabled user services

### What's NOT Backed Up

- Personal data (Documents, Pictures, etc.)
- Browser profiles
- SSH/GPG keys
- Application data (except configs)
- Cache files

---

## 🧪 Testing Your Backup

### Test in VM (Recommended)

Before relying on your backup:

1. Create Arch Linux VM
2. Clone your repo
3. Run installation scripts
4. Verify everything works

### Quick Test Commands

```bash
# Verify package list
wc -l ~/lofi-rice/packages/explicit-packages.txt

# Verify Hyprland config exists
ls ~/lofi-rice/config/hypr/hyprland.conf

# Test install script (dry run)
cd ~/lofi-rice
bash -n scripts/install-packages.sh

# Test restore script (dry run)
bash -n scripts/restore-configs.sh
```

---

## 📝 Customization Tips

### Before Publishing

1. **Update README.md:**
   - Replace `YOUR_USERNAME` with your GitHub username
   - Add screenshots of your desktop
   - Update hardware specs

2. **Review configs for sensitive data:**
   ```bash
   # Check for API keys, tokens, etc.
   grep -r "API_KEY\|TOKEN\|PASSWORD" ~/lofi-rice/config/
   ```

3. **Test restoration:**
   - Try restoring in VM before publishing

### Optional Additions

- Add LICENSE file (MIT recommended)
- Add .github/workflows/ for CI/CD
- Add screenshots/ directory
- Create CHANGELOG.md

---

## 🎯 Repository Statistics

```
Total Files: 86
Configuration Files: ~70
Scripts: 6
Documentation: 4 (README, INSTALL, KEYBINDS, TROUBLESHOOTING)
Package Count: 240 (113 AUR)
Repository Size: ~500KB
```

---

## ✨ You're Done!

Your complete Arch Linux + Hyprland setup is now:

- ✅ **Backed up** to local repository
- ✅ **Documented** with comprehensive guides
- ✅ **Scriptable** for automated restoration
- ✅ **Ready** to push to GitHub

Just follow the "Next Steps" above to publish to GitHub!

---

**Created:** 2025-10-29
**Location:** `/home/lofi/lofi-rice/`
