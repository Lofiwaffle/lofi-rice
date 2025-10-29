#!/bin/bash
# init-git.sh
# Initializes git repository and prepares for GitHub

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "🌱 Initializing git repository..."
echo "Repository directory: $REPO_DIR"
echo ""

# Change to repo directory
cd "$REPO_DIR"

# Check if git is already initialized
if [ -d ".git" ]; then
    echo "⚠️  Git repository already initialized!"
    echo ""
    git status
    exit 0
fi

# Initialize git
git init
echo "✅ Git initialized"

# Create .gitignore
cat > .gitignore << 'EOF'
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Editor files
*.swp
*.swo
*~
.vscode/
.idea/

# Log files
*.log

# Backup files
*.bak
*.backup
*-backup-*

# Sensitive files (adjust as needed)
# Uncomment if you don't want to track these:
# config/hypr/hyprland/scripts/ai/*
# local/bin/omarchy-*

# Temporary files
*.tmp
.cache/
EOF

echo "✅ .gitignore created"

# Create initial commit message template
cat > .gitmessage << 'EOF'
# Commit message template for lofi-rice
#
# Format:
# <type>: <subject>
#
# Types:
#   config: Configuration changes
#   pkg: Package list updates
#   script: Script additions/modifications
#   docs: Documentation updates
#   fix: Bug fixes
#   feat: New features
#
# Example:
#   config: Update Hyprland keybindings for new apps
#   pkg: Add rofi and dunst to package list
EOF

# Set commit template
git config commit.template .gitmessage
echo "✅ Commit template configured"

# Add all files
git add .

# Show status
echo ""
echo "📊 Repository status:"
git status

echo ""
echo "✅ Git repository initialized!"
echo ""
echo "📝 Next steps:"
echo "   1. Review staged files: git status"
echo "   2. Create initial commit: git commit -m 'Initial commit: lofi-rice dotfiles'"
echo "   3. Create GitHub repository at https://github.com/new"
echo "   4. Add remote: git remote add origin git@github.com:YOUR_USERNAME/lofi-rice.git"
echo "   5. Push to GitHub: git push -u origin main"
echo ""
echo "💡 Useful commands:"
echo "   git log --oneline --graph --all"
echo "   git diff"
echo "   git commit -am 'Update configs'"
