#!/bin/bash
# restore-configs.sh
# Restores configurations from the dotfiles repository

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$HOME/.config"
LOCAL_DIR="$HOME/.local"

echo "🔄 Restoring configurations from dotfiles..."
echo "Repository: $REPO_DIR"
echo "Target: $HOME"
echo ""

# Create backup of existing configs
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
echo "📦 Creating backup of existing configs at: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup existing important configs
for dir in hypr waybar kitty dunst wlogout swayosd rofi swaync; do
    if [ -d "$CONFIG_DIR/$dir" ] && [ ! -L "$CONFIG_DIR/$dir" ]; then
        echo "   Backing up $dir"
        cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
    fi
done

# Backup shell configs
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/"
[ -f "$HOME/.p10k.zsh" ] && cp "$HOME/.p10k.zsh" "$BACKUP_DIR/"
[ -f "$HOME/.bash_profile" ] && cp "$HOME/.bash_profile" "$BACKUP_DIR/"

echo ""
echo "⚙️  Restoring Hyprland configuration..."
mkdir -p "$CONFIG_DIR"
if [ -d "$REPO_DIR/config/hypr" ]; then
    rm -rf "$CONFIG_DIR/hypr"
    cp -r "$REPO_DIR/config/hypr" "$CONFIG_DIR/"
    echo "   ✅ Hyprland configs restored"
fi

echo ""
echo "📊 Restoring application configurations..."
for app in waybar kitty dunst wlogout swayosd alacritty foot \
           qt5ct qt6ct gtk-3.0 gtk-4.0 fastfetch cava fontconfig \
           rofi swaync; do
    if [ -d "$REPO_DIR/config/$app" ]; then
        echo "   Restoring $app"
        rm -rf "$CONFIG_DIR/$app"
        cp -r "$REPO_DIR/config/$app" "$CONFIG_DIR/"
    fi
done

echo ""
echo "📄 Restoring misc config files..."
[ -f "$REPO_DIR/config/mimeapps.list" ] && cp "$REPO_DIR/config/mimeapps.list" "$CONFIG_DIR/"
[ -f "$REPO_DIR/config/user-dirs.dirs" ] && cp "$REPO_DIR/config/user-dirs.dirs" "$CONFIG_DIR/"
[ -f "$REPO_DIR/config/gtkrc" ] && cp "$REPO_DIR/config/gtkrc" "$HOME/.gtkrc"
[ -f "$REPO_DIR/config/gtkrc-2.0" ] && cp "$REPO_DIR/config/gtkrc-2.0" "$HOME/.gtkrc-2.0"

echo ""
echo "🐚 Restoring shell configurations..."
[ -f "$REPO_DIR/shell/.zshrc" ] && cp "$REPO_DIR/shell/.zshrc" "$HOME/"
[ -f "$REPO_DIR/shell/.p10k.zsh" ] && cp "$REPO_DIR/shell/.p10k.zsh" "$HOME/"
[ -f "$REPO_DIR/shell/.bash_profile" ] && cp "$REPO_DIR/shell/.bash_profile" "$HOME/"

echo ""
echo "🔨 Restoring user binaries..."
if [ -d "$REPO_DIR/local/bin" ]; then
    mkdir -p "$LOCAL_DIR/bin"
    cp -r "$REPO_DIR/local/bin/"* "$LOCAL_DIR/bin/" 2>/dev/null || true
    chmod +x "$LOCAL_DIR/bin/"* 2>/dev/null || true
    echo "   ✅ User binaries restored and made executable"
fi

echo ""
echo "🖥️  Restoring custom desktop entries..."
if [ -d "$REPO_DIR/local/share/applications" ]; then
    mkdir -p "$LOCAL_DIR/share/applications"
    cp -r "$REPO_DIR/local/share/applications/"*.desktop "$LOCAL_DIR/share/applications/" 2>/dev/null || true
    echo "   ✅ Desktop entries restored"
fi

echo ""
echo "✅ Configuration restoration completed!"
echo ""
echo "📊 Summary:"
echo "   - Backup saved to: $BACKUP_DIR"
echo "   - Configs restored to: $CONFIG_DIR"
echo "   - Shell configs restored to: $HOME"
echo ""
echo "⚠️  Important next steps:"
echo "   1. Review monitor configuration in ~/.config/hypr/monitors.conf"
echo "   2. Adjust display settings for your hardware"
echo "   3. Run ./scripts/enable-services.sh to enable systemd services"
echo "   4. Log out and log back in (or reboot) for changes to take effect"
echo ""
echo "💡 To test Hyprland without logging out:"
echo "   Hyprland  (or: uwsm start hyprland.desktop)"
