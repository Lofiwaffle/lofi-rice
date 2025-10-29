#!/bin/bash
# backup-current-configs.sh
# Backs up current system configurations to the dotfiles repository

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "🔄 Starting backup of current configurations..."
echo "Repository location: $REPO_DIR"
echo ""

# Backup package lists
echo "📦 Backing up package lists..."
pacman -Qe | awk '{print $1}' > "$REPO_DIR/packages/explicit-packages.txt"
pacman -Qm | awk '{print $1}' > "$REPO_DIR/packages/aur-packages.txt"

# Extract Hyprland ecosystem packages
echo "🪟 Extracting Hyprland ecosystem packages..."
grep -E "^hypr|^xdg-desktop-portal-hyprland|^illogical-impulse" "$REPO_DIR/packages/explicit-packages.txt" \
    > "$REPO_DIR/packages/categories/hyprland.txt" || true

# Extract Wayland tools
echo "🌊 Extracting Wayland tools..."
grep -E "wl-|waybar|rofi|fuzzel|wlogout|swayosd|swaync|dunst|mako|slurp|grim" "$REPO_DIR/packages/explicit-packages.txt" \
    > "$REPO_DIR/packages/categories/wayland-tools.txt" || true

# Extract terminals
echo "💻 Extracting terminal packages..."
grep -E "kitty|alacritty|foot|warp-terminal|ghostty" "$REPO_DIR/packages/explicit-packages.txt" \
    > "$REPO_DIR/packages/categories/terminals.txt" || true

# Extract fonts
echo "🔤 Extracting font packages..."
grep -E "font|noto-|ttf-|otf-" "$REPO_DIR/packages/explicit-packages.txt" \
    > "$REPO_DIR/packages/categories/fonts.txt" || true

# Extract theming packages
echo "🎨 Extracting theming packages..."
grep -E "gtk|qt5|qt6|theme|icon" "$REPO_DIR/packages/explicit-packages.txt" \
    > "$REPO_DIR/packages/categories/theming.txt" || true

# Backup Hyprland configuration
echo "⚙️  Backing up Hyprland configuration..."
mkdir -p "$REPO_DIR/config/hypr"
if [ -d "$HOME/.config/hypr" ]; then
    rsync -av --delete \
        --exclude="hypridle.log" \
        --exclude="*.log" \
        "$HOME/.config/hypr/" "$REPO_DIR/config/hypr/"
fi

# Backup Waybar (check if symlinked from Windwaker-Dotfiles)
echo "📊 Backing up Waybar..."
if [ -L "$HOME/.config/waybar" ]; then
    WAYBAR_TARGET=$(readlink -f "$HOME/.config/waybar")
    echo "   Waybar is symlinked to: $WAYBAR_TARGET"
    rsync -av --delete "$WAYBAR_TARGET/" "$REPO_DIR/config/waybar/"
elif [ -d "$HOME/.config/waybar" ]; then
    rsync -av --delete "$HOME/.config/waybar/" "$REPO_DIR/config/waybar/"
fi

# Backup Kitty
echo "🐱 Backing up Kitty..."
if [ -L "$HOME/.config/kitty" ]; then
    KITTY_TARGET=$(readlink -f "$HOME/.config/kitty")
    rsync -av --delete "$KITTY_TARGET/" "$REPO_DIR/config/kitty/"
elif [ -d "$HOME/.config/kitty" ]; then
    rsync -av --delete "$HOME/.config/kitty/" "$REPO_DIR/config/kitty/"
fi

# Backup other application configs
echo "🔧 Backing up application configs..."
for app in dunst wlogout swayosd alacritty foot qt5ct qt6ct gtk-3.0 gtk-4.0 \
           fastfetch cava fontconfig rofi swaync; do
    if [ -L "$HOME/.config/$app" ]; then
        APP_TARGET=$(readlink -f "$HOME/.config/$app")
        echo "   $app (symlinked)"
        rsync -av --delete "$APP_TARGET/" "$REPO_DIR/config/$app/"
    elif [ -d "$HOME/.config/$app" ]; then
        echo "   $app"
        rsync -av --delete "$HOME/.config/$app/" "$REPO_DIR/config/$app/"
    fi
done

# Backup misc config files
echo "📄 Backing up misc config files..."
[ -f "$HOME/.config/mimeapps.list" ] && cp "$HOME/.config/mimeapps.list" "$REPO_DIR/config/"
[ -f "$HOME/.config/user-dirs.dirs" ] && cp "$HOME/.config/user-dirs.dirs" "$REPO_DIR/config/"
[ -f "$HOME/.gtkrc" ] && cp "$HOME/.gtkrc" "$REPO_DIR/config/"
[ -f "$HOME/.gtkrc-2.0" ] && cp "$HOME/.gtkrc-2.0" "$REPO_DIR/config/"

# Backup shell configs
echo "🐚 Backing up shell configurations..."
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$REPO_DIR/shell/"
[ -f "$HOME/.p10k.zsh" ] && cp "$HOME/.p10k.zsh" "$REPO_DIR/shell/"
[ -f "$HOME/.bash_profile" ] && cp "$HOME/.bash_profile" "$REPO_DIR/shell/"

# Backup user binaries
echo "🔨 Backing up user binaries..."
if [ -d "$HOME/.local/bin" ]; then
    mkdir -p "$REPO_DIR/local/bin"
    # Only backup specific known binaries, not everything
    for binary in matugen oh-my-posh omarchy-launch-webapp omarchy-menu; do
        [ -f "$HOME/.local/bin/$binary" ] && cp "$HOME/.local/bin/$binary" "$REPO_DIR/local/bin/"
    done
fi

# Backup custom desktop entries
echo "🖥️  Backing up custom desktop entries..."
if [ -d "$HOME/.local/share/applications" ]; then
    mkdir -p "$REPO_DIR/local/share/applications"
    # Only backup custom entries (typically web apps)
    for desktop in "$HOME/.local/share/applications/"*.desktop; do
        if [ -f "$desktop" ]; then
            # Check if it's a custom entry (contains specific patterns)
            if grep -q "StartupWMClass=\|omarchy-launch-webapp" "$desktop" 2>/dev/null; then
                cp "$desktop" "$REPO_DIR/local/share/applications/"
            fi
        fi
    done
fi

# List enabled systemd user services
echo "⚙️  Recording enabled systemd user services..."
systemctl --user list-unit-files --state=enabled --no-pager \
    > "$REPO_DIR/systemd/user/enabled-services.txt"

# Backup system configs (optional, requires review)
echo "🖥️  Recording system configurations..."
echo "# System configurations - review before applying!" > "$REPO_DIR/system/etc/README.md"
echo "" >> "$REPO_DIR/system/etc/README.md"
echo "These are system-level configs that require root/sudo to modify." >> "$REPO_DIR/system/etc/README.md"
echo "Review carefully before overwriting system files!" >> "$REPO_DIR/system/etc/README.md"

# Note about pacman.conf without copying (needs manual review)
if [ -f /etc/pacman.conf ]; then
    echo "" >> "$REPO_DIR/system/etc/README.md"
    echo "## pacman.conf changes:" >> "$REPO_DIR/system/etc/README.md"
    echo "" >> "$REPO_DIR/system/etc/README.md"
    grep -v "^#\|^$" /etc/pacman.conf | head -20 >> "$REPO_DIR/system/etc/README.md"
fi

echo ""
echo "✅ Backup completed successfully!"
echo ""
echo "📊 Summary:"
echo "   - Packages: $(wc -l < "$REPO_DIR/packages/explicit-packages.txt") explicit, $(wc -l < "$REPO_DIR/packages/aur-packages.txt") AUR"
echo "   - Configs: Check $REPO_DIR/config/"
echo "   - Shell: Check $REPO_DIR/shell/"
echo ""
echo "Next steps:"
echo "   1. Review backed up files"
echo "   2. Initialize git: cd $REPO_DIR && git init"
echo "   3. Commit: git add . && git commit -m 'Initial backup'"
echo "   4. Push to GitHub: git remote add origin <your-repo-url> && git push -u origin main"
