#!/bin/sh

# This script sets up Alpine Linux with KDE Plasma, NetworkManager,
# Zsh with Powerlevel10k, syntax highlighting, and autosuggestions.
#
# IMPORTANT:
# - Run this script as root on a fresh Alpine Linux installation.
# - Ensure you have a basic internet connection before running.
# - This script does NOT handle disk partitioning or initial system setup.
# - It assumes a user (non-root) is already created on the system.
# - Review the script carefully before execution.

set -e

# --- Pre-installation Checks and User Guidance ---
echo ""
echo "========================================================================"
echo "Pre-installation Steps Required"
echo "------------------------------------------------------------------------"
echo "Before continuing, please ensure you have addressed the following:"
echo ""
echo "1.  **Doas Setup**: use 'doas' for privileged commands as your user,"
echo "    ensure you have it installed and configured it."
echo "2.  **Graphics Driver Installation**: It's crucial to install the correct graphics drivers for your hardware."
echo "    Make sure to install them as the Alpine Linux Wiki says"
echo ""
read -p "Have you completed the above steps, and are you ready to continue with the KDE Plasma and Zsh installation? (y/N): " READY_TO_PROCEED
if [ "$READY_TO_PROCEED" != "y" ] && [ "$READY_TO_PROCEED" != "Y" ]; then
    echo "Aborting installation. Please perform the necessary pre-installation steps and re-run the script."
    exit 1
fi
echo "Continuing with setup..."
echo "========================================================================"
echo ""



echo "Starting Alpine Linux setup script for KDE Plasma, NetworkManager, and Zsh."
echo

# Step 1: Update system and install necessary packages
echo "Updating system and installing core packages..."
doas apk update
doas apk upgrade

# Install KDE Plasma Desktop Environment and Xorg
echo "Installing KDE Plasma and Xorg..."
doas setup-xorg-base
doas setup-wayland-bse
doas setup-desktop plasma
doas apk add gdm
doas apk add git
doas apk add networkmanager
doas apk add networkmanager-wifi
doas apk add plasma-nm
doas apk add networkmanager-tui

# Add user to Networkmanager

doas adduser $(whoami) plugdev


# Enable and start essential services
echo "Enabling and starting essential services..."
doas rc-update add dbus
doas rc-update add udev
doas rc-update add elogind
doas rc-update del sddm
doas rc-update add gdm
doas rc-update add networkmanager default
doas rc-update del networking boot
doas rc-update del wpa_supplicant boot
# Step 2: Install Zsh and its plugins
