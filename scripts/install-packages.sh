#!/bin/bash
# install-packages.sh
# Installs all required packages for the lofi-rice setup

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "📦 Installing packages for lofi-rice setup..."
echo ""

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo "❌ Error: This script is designed for Arch Linux!"
    exit 1
fi

# Install base-devel if not present
if ! pacman -Qg base-devel &>/dev/null; then
    echo "🔧 Installing base-devel..."
    sudo pacman -S --needed --noconfirm base-devel git
fi

# Install Paru (AUR helper) if not present
if ! command -v paru &> /dev/null; then
    echo "📥 Installing Paru (AUR helper)..."

    # Clone and build paru
    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$TEMP_DIR/paru"
    pushd "$TEMP_DIR/paru"
    makepkg -si --noconfirm
    popd
    rm -rf "$TEMP_DIR"

    echo "✅ Paru installed successfully!"
fi

# Update system
echo "🔄 Updating system..."
sudo pacman -Syu --noconfirm

# Install official repository packages
if [ -f "$REPO_DIR/packages/explicit-packages.txt" ]; then
    echo ""
    echo "📦 Installing official repository packages..."
    echo "   This may take a while..."

    # Filter out AUR packages
    if [ -f "$REPO_DIR/packages/aur-packages.txt" ]; then
        comm -23 \
            <(sort "$REPO_DIR/packages/explicit-packages.txt") \
            <(sort "$REPO_DIR/packages/aur-packages.txt") \
            > /tmp/official-packages.txt

        sudo pacman -S --needed --noconfirm - < /tmp/official-packages.txt || {
            echo "⚠️  Some official packages failed to install"
            echo "   Continuing with AUR packages..."
        }
    else
        sudo pacman -S --needed --noconfirm - < "$REPO_DIR/packages/explicit-packages.txt" || {
            echo "⚠️  Some packages failed to install"
            echo "   Continuing anyway..."
        }
    fi
fi

# Install AUR packages
if [ -f "$REPO_DIR/packages/aur-packages.txt" ]; then
    echo ""
    echo "📦 Installing AUR packages..."
    echo "   This will take significantly longer..."

    paru -S --needed --noconfirm - < "$REPO_DIR/packages/aur-packages.txt" || {
        echo "⚠️  Some AUR packages failed to install"
        echo "   You may need to install them manually"
    }
fi

echo ""
echo "✅ Package installation completed!"
echo ""
echo "📊 Installed packages:"
echo "   - Official: $(comm -23 <(sort "$REPO_DIR/packages/explicit-packages.txt") <(sort "$REPO_DIR/packages/aur-packages.txt" 2>/dev/null || echo "") | wc -l 2>/dev/null || echo "?")"
echo "   - AUR: $(wc -l < "$REPO_DIR/packages/aur-packages.txt" 2>/dev/null || echo "0")"
echo ""
echo "Next step: Run ./scripts/restore-configs.sh to restore configurations"
