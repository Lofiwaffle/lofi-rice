#!/bin/bash
# setup-auto-backup.sh
# Sets up automated daily backup of dotfiles using systemd timer

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "⏰ Setting up automated dotfiles backup..."
echo ""

# Create systemd user directory if it doesn't exist
mkdir -p "$HOME/.config/systemd/user"

# Create the backup service
cat > "$HOME/.config/systemd/user/dotfiles-backup.service" << EOF
[Unit]
Description=Backup dotfiles to lofi-rice repository
After=network.target

[Service]
Type=oneshot
ExecStart=$REPO_DIR/scripts/backup-current-configs.sh
WorkingDirectory=$REPO_DIR

[Install]
WantedBy=default.target
EOF

# Create the timer
cat > "$HOME/.config/systemd/user/dotfiles-backup.timer" << EOF
[Unit]
Description=Daily dotfiles backup timer
Requires=dotfiles-backup.service

[Timer]
OnCalendar=daily
OnBootSec=15min
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Reload systemd
systemctl --user daemon-reload

# Enable and start the timer
systemctl --user enable dotfiles-backup.timer
systemctl --user start dotfiles-backup.timer

echo "✅ Automated backup configured!"
echo ""
echo "📊 Timer status:"
systemctl --user status dotfiles-backup.timer --no-pager || true
echo ""
echo "💡 Backup schedule:"
echo "   - Daily at midnight"
echo "   - 15 minutes after boot"
echo ""
echo "🔍 Useful commands:"
echo "   Check timer: systemctl --user list-timers"
echo "   Run backup now: systemctl --user start dotfiles-backup.service"
echo "   View logs: journalctl --user -u dotfiles-backup.service"
echo "   Disable: systemctl --user disable dotfiles-backup.timer"
