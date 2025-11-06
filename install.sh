#!/bin/bash
# lofi-rice Master Installation Script
# Complete Arch Linux + Hyprland desktop environment installer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Log file
LOG_FILE="$REPO_DIR/install-$(date +%Y%m%d-%H%M%S).log"

# Functions
print_header() {
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║              🌊 lofi-rice Installer 🌊                     ║"
    echo "║                                                            ║"
    echo "║        Arch Linux + Hyprland Desktop Environment          ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "\n${CYAN}==>${NC} ${BLUE}$1${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

check_arch() {
    if [ ! -f /etc/arch-release ]; then
        print_error "This script is designed for Arch Linux only!"
        exit 1
    fi
    print_success "Running on Arch Linux"
}

check_internet() {
    print_step "Checking internet connection..."
    if ping -c 1 archlinux.org &> /dev/null; then
        print_success "Internet connection available"
    else
        print_error "No internet connection detected!"
        exit 1
    fi
}

backup_existing() {
    print_step "Backing up existing configurations..."

    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    local backed_up=false

    # Backup important configs
    for dir in hypr waybar kitty dunst rofi swaync; do
        if [ -d "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ]; then
            print_success "Backing up $dir"
            cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
            backed_up=true
        fi
    done

    # Backup shell configs
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/" && backed_up=true
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$BACKUP_DIR/" && backed_up=true

    if [ "$backed_up" = true ]; then
        print_success "Backup created at: $BACKUP_DIR"
        log "Backup created at: $BACKUP_DIR"
    else
        print_warning "No existing configurations to backup"
        rmdir "$BACKUP_DIR" 2>/dev/null || true
    fi
}

install_packages() {
    print_step "Installing system packages..."

    if [ ! -f "$REPO_DIR/scripts/install-packages.sh" ]; then
        print_error "install-packages.sh not found!"
        exit 1
    fi

    chmod +x "$REPO_DIR/scripts/install-packages.sh"

    if "$REPO_DIR/scripts/install-packages.sh" 2>&1 | tee -a "$LOG_FILE"; then
        print_success "Packages installed successfully"
    else
        print_error "Package installation failed! Check $LOG_FILE for details"
        exit 1
    fi
}

restore_configs() {
    print_step "Restoring configurations..."

    if [ ! -f "$REPO_DIR/scripts/restore-configs.sh" ]; then
        print_error "restore-configs.sh not found!"
        exit 1
    fi

    chmod +x "$REPO_DIR/scripts/restore-configs.sh"

    if "$REPO_DIR/scripts/restore-configs.sh" 2>&1 | tee -a "$LOG_FILE"; then
        print_success "Configurations restored successfully"
    else
        print_error "Configuration restoration failed! Check $LOG_FILE for details"
        exit 1
    fi
}

enable_services() {
    print_step "Enabling system services..."

    if [ ! -f "$REPO_DIR/scripts/enable-services.sh" ]; then
        print_error "enable-services.sh not found!"
        exit 1
    fi

    chmod +x "$REPO_DIR/scripts/enable-services.sh"

    if "$REPO_DIR/scripts/enable-services.sh" 2>&1 | tee -a "$LOG_FILE"; then
        print_success "Services enabled successfully"
    else
        print_warning "Some services may not have been enabled (this is usually okay)"
    fi
}

configure_monitors() {
    print_step "Monitor Configuration"

    echo -e "${YELLOW}Your monitor configuration has been restored from backup.${NC}"
    echo -e "${YELLOW}You may need to adjust it for your current hardware.${NC}"
    echo ""
    echo "Monitor config file: ~/.config/hypr/monitors.conf"
    echo ""
    read -p "Would you like to edit monitor configuration now? [y/N] " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ${EDITOR:-nano} "$HOME/.config/hypr/monitors.conf"
        print_success "Monitor configuration updated"
    else
        print_warning "Remember to adjust monitors.conf before first login"
    fi
}

setup_auto_backup() {
    print_step "Automated Backup Setup (Optional)"

    echo "Would you like to set up automated daily backups of your dotfiles?"
    echo "This will create a systemd timer that backs up configs daily at midnight."
    echo ""
    read -p "Setup automated backups? [y/N] " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "$REPO_DIR/scripts/setup-auto-backup.sh" ]; then
            chmod +x "$REPO_DIR/scripts/setup-auto-backup.sh"
            "$REPO_DIR/scripts/setup-auto-backup.sh"
            print_success "Automated backups configured"
        else
            print_warning "setup-auto-backup.sh not found, skipping"
        fi
    else
        print_warning "Skipping automated backup setup"
    fi
}

show_summary() {
    print_step "Installation Summary"

    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║              ✓ Installation Complete! ✓                   ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    print_success "System packages installed"
    print_success "Configurations restored"
    print_success "Services enabled"

    echo ""
    echo -e "${CYAN}📊 Installation Statistics:${NC}"
    echo "   - Packages: 240 (113 AUR)"
    echo "   - Config files: 86"
    echo "   - Log file: $LOG_FILE"

    echo ""
    echo -e "${YELLOW}⚠️  Important Next Steps:${NC}"
    echo ""
    echo "1. ${CYAN}Review monitor configuration:${NC}"
    echo "   nano ~/.config/hypr/monitors.conf"
    echo ""
    echo "2. ${CYAN}Logout and login to Hyprland:${NC}"
    echo "   - If using display manager: Select 'Hyprland' from session menu"
    echo "   - If using TTY: Type 'Hyprland' after login"
    echo "   - Or simply reboot: sudo reboot"
    echo ""
    echo "3. ${CYAN}Test keybindings:${NC}"
    echo "   - Super + Return → Terminal"
    echo "   - Super + Space → Launcher"
    echo "   - Super + Q → Close window"
    echo ""
    echo "4. ${CYAN}Full keybinding reference:${NC}"
    echo "   cat $REPO_DIR/docs/KEYBINDS.md"
    echo ""

    echo -e "${PURPLE}📚 Documentation:${NC}"
    echo "   - README: $REPO_DIR/README.md"
    echo "   - Install Guide: $REPO_DIR/docs/INSTALL.md"
    echo "   - Troubleshooting: $REPO_DIR/docs/TROUBLESHOOTING.md"
    echo ""

    echo -e "${GREEN}Enjoy your lofi-rice setup! 🌊${NC}"
    echo ""
}

interactive_mode() {
    print_header

    echo "This script will install the complete lofi-rice Hyprland configuration."
    echo ""
    echo -e "${YELLOW}What will be installed:${NC}"
    echo "  • 240 system packages (including 113 AUR packages)"
    echo "  • Complete Hyprland configuration"
    echo "  • Waybar, Kitty, and all application configs"
    echo "  • GTK/Qt theming"
    echo "  • Shell configurations"
    echo "  • Systemd services"
    echo ""
    echo -e "${YELLOW}Estimated time:${NC} 20-45 minutes (depending on internet speed)"
    echo -e "${YELLOW}Disk space required:${NC} ~2-3GB"
    echo ""

    read -p "Continue with installation? [y/N] " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Installation cancelled by user"
        exit 0
    fi

    # Offer installation options
    echo ""
    echo -e "${CYAN}Installation Options:${NC}"
    echo "  1) Full installation (recommended)"
    echo "  2) Packages only"
    echo "  3) Configurations only (packages must be installed)"
    echo "  4) Custom (select components)"
    echo ""
    read -p "Select option [1-4]: " -n 1 -r option
    echo

    case $option in
        1)
            INSTALL_PACKAGES=true
            INSTALL_CONFIGS=true
            ENABLE_SERVICES=true
            ;;
        2)
            INSTALL_PACKAGES=true
            INSTALL_CONFIGS=false
            ENABLE_SERVICES=false
            ;;
        3)
            INSTALL_PACKAGES=false
            INSTALL_CONFIGS=true
            ENABLE_SERVICES=true
            ;;
        4)
            echo ""
            read -p "Install packages? [Y/n] " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Nn]$ ]] && INSTALL_PACKAGES=true || INSTALL_PACKAGES=false

            read -p "Restore configurations? [Y/n] " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Nn]$ ]] && INSTALL_CONFIGS=true || INSTALL_CONFIGS=false

            read -p "Enable services? [Y/n] " -n 1 -r
            echo
            [[ ! $REPLY =~ ^[Nn]$ ]] && ENABLE_SERVICES=true || ENABLE_SERVICES=false
            ;;
        *)
            print_error "Invalid option"
            exit 1
            ;;
    esac

    log "Installation started - Option: $option"

    # Pre-installation checks
    check_arch
    check_internet

    # Backup existing configs if restoring
    if [ "$INSTALL_CONFIGS" = true ]; then
        backup_existing
    fi

    # Execute selected components
    if [ "$INSTALL_PACKAGES" = true ]; then
        install_packages
    else
        print_warning "Skipping package installation"
    fi

    if [ "$INSTALL_CONFIGS" = true ]; then
        restore_configs
        configure_monitors
    else
        print_warning "Skipping configuration restoration"
    fi

    if [ "$ENABLE_SERVICES" = true ]; then
        enable_services
    else
        print_warning "Skipping service enablement"
    fi

    # Optional features
    setup_auto_backup

    # Show summary
    show_summary

    log "Installation completed successfully"
}

automated_mode() {
    print_header

    print_step "Running in automated mode (full installation)"

    log "Automated installation started"

    check_arch
    check_internet
    backup_existing
    install_packages
    restore_configs
    enable_services

    show_summary

    log "Automated installation completed"
}

# Main execution
main() {
    # Check for flags
    case "${1:-}" in
        --auto|--automated|-a)
            automated_mode
            ;;
        --help|-h)
            echo "lofi-rice Installation Script"
            echo ""
            echo "Usage:"
            echo "  ./install.sh           Interactive mode (recommended)"
            echo "  ./install.sh --auto    Automated full installation"
            echo "  ./install.sh --help    Show this help message"
            echo ""
            echo "Installation includes:"
            echo "  - 240 system packages (113 AUR)"
            echo "  - Hyprland + Waybar + applications"
            echo "  - Complete configuration restoration"
            echo "  - Systemd service enablement"
            echo ""
            exit 0
            ;;
        "")
            interactive_mode
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
