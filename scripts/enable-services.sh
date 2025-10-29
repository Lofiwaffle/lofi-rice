#!/bin/bash
# enable-services.sh
# Enables required systemd user services

set -e

echo "⚙️  Enabling systemd user services..."
echo ""

# Core audio services
echo "🔊 Enabling audio services..."
systemctl --user enable pipewire.socket 2>/dev/null || echo "   ⚠️  pipewire.socket not found (may already be enabled)"
systemctl --user enable pipewire-pulse.socket 2>/dev/null || echo "   ⚠️  pipewire-pulse.socket not found"
systemctl --user enable wireplumber.service 2>/dev/null || echo "   ⚠️  wireplumber.service not found"

# Start audio services immediately
systemctl --user start pipewire.socket 2>/dev/null || true
systemctl --user start pipewire-pulse.socket 2>/dev/null || true
systemctl --user start wireplumber.service 2>/dev/null || true

# Docker Desktop (if installed)
if systemctl --user list-unit-files docker-desktop.service &>/dev/null; then
    echo ""
    echo "🐳 Enabling Docker Desktop..."
    systemctl --user enable docker-desktop.service
fi

# XDG user directories
echo ""
echo "📁 Enabling XDG user directories..."
systemctl --user enable xdg-user-dirs.service 2>/dev/null || echo "   ⚠️  xdg-user-dirs.service not found"

# ydotool (input automation)
if systemctl --user list-unit-files ydotool.service &>/dev/null; then
    echo ""
    echo "⌨️  Enabling ydotool (input automation)..."
    systemctl --user enable ydotool.service
fi

# GNOME Keyring
echo ""
echo "🔐 Enabling GNOME Keyring..."
systemctl --user enable gnome-keyring-daemon.socket 2>/dev/null || echo "   ⚠️  gnome-keyring-daemon.socket not found"

# Battery monitoring (if available)
if systemctl --user list-unit-files omarchy-battery-monitor.timer &>/dev/null; then
    echo ""
    echo "🔋 Enabling battery monitor..."
    systemctl --user enable omarchy-battery-monitor.timer
fi

echo ""
echo "✅ Service enablement completed!"
echo ""
echo "📊 Enabled services:"
systemctl --user list-unit-files --state=enabled --no-pager | grep -E "pipewire|wireplumber|docker|xdg|ydotool|keyring|battery" || echo "   (checking...)"
echo ""
echo "💡 Services will start automatically on next login"
echo "   To start services now: systemctl --user start <service-name>"
echo ""
echo "🔍 To check service status:"
echo "   systemctl --user status pipewire.socket"
echo "   systemctl --user status wireplumber.service"
