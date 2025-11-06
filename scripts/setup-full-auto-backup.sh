#!/bin/bash
# setup-full-auto-backup.sh
# Sets up FULL automated backup with Git commit and push

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "⏰ Setting up FULL automated dotfiles backup (with Git sync)..."
echo ""

# Check if git is initialized
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "❌ Error: Git repository not initialized!"
    echo "Run ./scripts/init-git.sh first"
    exit 1
fi

# Check if remote is configured
if ! git -C "$REPO_DIR" remote get-url origin &>/dev/null; then
    echo "⚠️  Warning: No Git remote configured"
    echo "The backup will commit locally but cannot push to GitHub"
    echo ""
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled. Add remote with:"
        echo "  git remote add origin git@github.com:USERNAME/lofi-rice.git"
        exit 0
    fi
fi

# Create systemd user directory if it doesn't exist
mkdir -p "$HOME/.config/systemd/user"

# Create the backup service (with Git sync)
cat > "$HOME/.config/systemd/user/dotfiles-backup-git.service" << EOF
[Unit]
Description=Backup dotfiles with Git commit and push
After=network.target

[Service]
Type=oneshot
ExecStart=$REPO_DIR/scripts/auto-backup-git.sh
WorkingDirectory=$REPO_DIR

[Install]
WantedBy=default.target
EOF

# Create the timer
cat > "$HOME/.config/systemd/user/dotfiles-backup-git.timer" << EOF
[Unit]
Description=Daily dotfiles backup with Git sync
Requires=dotfiles-backup-git.service

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
systemctl --user enable dotfiles-backup-git.timer
systemctl --user start dotfiles-backup-git.timer

echo "✅ Full automated backup configured!"
echo ""
echo "📊 Backup schedule:"
echo "   - Daily at midnight"
echo "   - 15 minutes after boot"
echo "   - Automatically commits and pushes to GitHub"
echo ""
echo "📝 Log file: $REPO_DIR/auto-backup.log"
echo ""
echo "🔍 Useful commands:"
echo "   Check timer: systemctl --user list-timers"
echo "   Test backup now: systemctl --user start dotfiles-backup-git.service"
echo "   View logs: journalctl --user -u dotfiles-backup-git.service"
echo "   Check backup log: tail -f $REPO_DIR/auto-backup.log"
echo "   Disable: systemctl --user disable dotfiles-backup-git.timer"
echo ""
echo "⚠️  Important: Make sure you have SSH keys configured for GitHub!"
echo "   Test with: ssh -T git@github.com"
