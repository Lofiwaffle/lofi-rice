# Automated Backup Guide

Complete guide to automated backups for your lofi-rice configuration.

## 📋 Two Backup Options

### Option 1: Local Backup Only (Basic)

**Script:** `./scripts/setup-auto-backup.sh`

**What it does:**
- ✅ Backs up configs to `/home/lofi/lofi-rice/` daily
- ❌ Does NOT commit to Git
- ❌ Does NOT push to GitHub

**Best for:**
- Testing the backup system
- Local backups only
- Manual Git workflow

### Option 2: Full Auto-Sync (Advanced)

**Script:** `./scripts/setup-full-auto-backup.sh`

**What it does:**
- ✅ Backs up configs to `/home/lofi/lofi-rice/` daily
- ✅ Automatically commits to Git
- ✅ Automatically pushes to GitHub

**Best for:**
- Complete automation
- Always having backups on GitHub
- "Set it and forget it" workflow

---

## 🚀 Setup Instructions

### Option 1: Local Backup Only

```bash
cd ~/lofi-rice
./scripts/setup-auto-backup.sh
```

**What gets scheduled:**
```
Daily at midnight: backup-current-configs.sh
15 min after boot: backup-current-configs.sh
```

**You must manually commit/push:**
```bash
cd ~/lofi-rice
git add .
git commit -m "Update configs"
git push
```

---

### Option 2: Full Auto-Sync to GitHub

**Prerequisites:**
1. Git repository initialized (`./scripts/init-git.sh`)
2. GitHub remote added (`git remote add origin ...`)
3. SSH keys configured for GitHub

**Setup:**
```bash
cd ~/lofi-rice

# Initialize Git if not done
./scripts/init-git.sh

# Add GitHub remote
git remote add origin git@github.com:YOUR_USERNAME/lofi-rice.git

# Push initial commit
git commit -m "Initial commit"
git push -u origin main

# Setup full automation
./scripts/setup-full-auto-backup.sh
```

**What gets scheduled:**
```
Daily at midnight:
  1. backup-current-configs.sh
  2. git add .
  3. git commit -m "Auto-backup: YYYY-MM-DD HH:MM:SS"
  4. git push origin main

15 min after boot: (same as above)
```

---

## ⚙️ How It Works Technically

### Systemd User Timers

Both options use **systemd user timers** (like cron, but better):

**Components:**
1. **Service file** - Defines what to run
2. **Timer file** - Defines when to run it

**Advantages over cron:**
- ✅ Runs even if system was off during scheduled time
- ✅ Better logging with journalctl
- ✅ User-level (no root required)
- ✅ Can depend on network being available

### File Locations

**Option 1 (Local only):**
```
~/.config/systemd/user/dotfiles-backup.service
~/.config/systemd/user/dotfiles-backup.timer
```

**Option 2 (Full sync):**
```
~/.config/systemd/user/dotfiles-backup-git.service
~/.config/systemd/user/dotfiles-backup-git.timer
~/lofi-rice/auto-backup.log  (detailed log file)
```

### Execution Flow (Option 2)

```
Timer triggers
    ↓
Service starts
    ↓
auto-backup-git.sh runs
    ↓
backup-current-configs.sh
    ↓
Updates files in ~/lofi-rice/
    ↓
git add .
    ↓
git commit (if changes exist)
    ↓
git push origin main (if remote exists)
    ↓
Log results to auto-backup.log
```

---

## 🔍 Managing Your Automated Backups

### Check Timer Status

```bash
# List all active timers
systemctl --user list-timers

# Should show:
# dotfiles-backup.timer (Option 1)
# or
# dotfiles-backup-git.timer (Option 2)
```

### View Logs

**Option 1:**
```bash
journalctl --user -u dotfiles-backup.service
```

**Option 2:**
```bash
# Systemd logs
journalctl --user -u dotfiles-backup-git.service

# Detailed backup log
tail -f ~/lofi-rice/auto-backup.log
```

### Trigger Backup Manually

**Option 1:**
```bash
systemctl --user start dotfiles-backup.service
```

**Option 2:**
```bash
systemctl --user start dotfiles-backup-git.service

# Or run script directly
~/lofi-rice/scripts/auto-backup-git.sh
```

### Disable Automated Backups

**Option 1:**
```bash
systemctl --user disable dotfiles-backup.timer
systemctl --user stop dotfiles-backup.timer
```

**Option 2:**
```bash
systemctl --user disable dotfiles-backup-git.timer
systemctl --user stop dotfiles-backup-git.timer
```

### Re-enable

```bash
# Option 1
systemctl --user enable dotfiles-backup.timer
systemctl --user start dotfiles-backup.timer

# Option 2
systemctl --user enable dotfiles-backup-git.timer
systemctl --user start dotfiles-backup-git.timer
```

---

## 🔧 Customizing Backup Schedule

Edit the timer file to change schedule:

**Option 1:**
```bash
nano ~/.config/systemd/user/dotfiles-backup.timer
```

**Option 2:**
```bash
nano ~/.config/systemd/user/dotfiles-backup-git.timer
```

### Common Schedules

**Every hour:**
```ini
[Timer]
OnCalendar=hourly
```

**Twice daily (8 AM and 8 PM):**
```ini
[Timer]
OnCalendar=*-*-* 08,20:00:00
```

**Every 6 hours:**
```ini
[Timer]
OnCalendar=*-*-* 00/6:00:00
```

**Weekly (Sundays at midnight):**
```ini
[Timer]
OnCalendar=Sun *-*-* 00:00:00
```

**After making changes:**
```bash
systemctl --user daemon-reload
systemctl --user restart dotfiles-backup-git.timer
```

---

## 🔐 SSH Key Setup for GitHub

For Option 2 (full auto-sync), you need SSH keys configured:

### Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# Press Enter to accept default location
# Set a passphrase (optional but recommended)
```

### Add to SSH Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Add to GitHub

```bash
# Copy public key
cat ~/.ssh/id_ed25519.pub

# Go to GitHub → Settings → SSH and GPG keys → New SSH key
# Paste the public key
```

### Test Connection

```bash
ssh -T git@github.com
# Should see: "Hi USERNAME! You've successfully authenticated..."
```

---

## 🐛 Troubleshooting

### Backup runs but doesn't push

**Check if remote is configured:**
```bash
cd ~/lofi-rice
git remote -v
```

**If empty, add remote:**
```bash
git remote add origin git@github.com:YOUR_USERNAME/lofi-rice.git
```

### "Permission denied" when pushing

**SSH key issue:**
```bash
# Test SSH
ssh -T git@github.com

# If fails, check SSH agent
ssh-add -l

# Add key if needed
ssh-add ~/.ssh/id_ed25519
```

### Service fails to start

**Check logs:**
```bash
journalctl --user -u dotfiles-backup-git.service -n 50
```

**Common issues:**
- Script not executable: `chmod +x ~/lofi-rice/scripts/auto-backup-git.sh`
- Git not initialized: `cd ~/lofi-rice && git status`
- Wrong path in service file

### No changes being committed

**Check what changed:**
```bash
cd ~/lofi-rice
git status
git diff
```

If no changes, backup is working - it just means configs haven't changed!

### View backup log

```bash
tail -f ~/lofi-rice/auto-backup.log
```

---

## 📊 Comparison Table

| Feature | Local Only | Full Auto-Sync |
|---------|-----------|----------------|
| **Script** | `setup-auto-backup.sh` | `setup-full-auto-backup.sh` |
| **Backs up configs** | ✅ Yes | ✅ Yes |
| **Git commit** | ❌ Manual | ✅ Automatic |
| **GitHub push** | ❌ Manual | ✅ Automatic |
| **Requires SSH keys** | ❌ No | ✅ Yes |
| **Internet required** | ❌ No | ✅ For push |
| **Manual intervention** | ✅ Yes (commit/push) | ❌ None |
| **Best for** | Testing, manual control | Set and forget |

---

## 💡 Best Practices

### For Option 1 (Local Only)

1. Set a reminder to manually commit/push weekly
2. Good for testing before committing to full automation
3. Review changes before pushing

### For Option 2 (Full Auto-Sync)

1. **Monitor initially** - Check logs for first week
2. **Review commits** - Occasionally check GitHub for auto-commits
3. **Set up email notifications** - GitHub can email you on pushes
4. **Keep SSH key secure** - Use passphrase, backup key safely
5. **Test failure scenarios** - Disconnect internet, see what happens

### General

1. **Test manually first:**
   ```bash
   ~/lofi-rice/scripts/auto-backup-git.sh
   ```

2. **Monitor log file:**
   ```bash
   tail -f ~/lofi-rice/auto-backup.log
   ```

3. **Check GitHub periodically** to ensure backups are arriving

4. **Keep a separate backup** - Automated backups are great, but keep a manual backup too!

---

## 🔄 Switching Between Options

### From Local Only → Full Auto-Sync

```bash
# Disable old timer
systemctl --user disable dotfiles-backup.timer
systemctl --user stop dotfiles-backup.timer

# Setup new one
./scripts/setup-full-auto-backup.sh
```

### From Full Auto-Sync → Local Only

```bash
# Disable full sync
systemctl --user disable dotfiles-backup-git.timer
systemctl --user stop dotfiles-backup-git.timer

# Setup local only
./scripts/setup-auto-backup.sh
```

---

## 📅 Backup History

View your automated backup history on GitHub:

```
https://github.com/YOUR_USERNAME/lofi-rice/commits/main
```

Each auto-backup creates a commit with timestamp:
```
Auto-backup: 2025-10-29 00:00:15
Auto-backup: 2025-10-28 00:00:12
Auto-backup: 2025-10-27 00:00:18
```

---

## ✨ Summary

**TL;DR:**

- **Want simple?** → Use Option 1, commit manually when you remember
- **Want complete automation?** → Use Option 2, set up SSH keys once, forget about it
- **Not sure?** → Start with Option 1, upgrade to Option 2 later

**Recommendation:** Option 2 (Full Auto-Sync) for peace of mind! 🌊

---

**Last Updated:** 2025-10-29
