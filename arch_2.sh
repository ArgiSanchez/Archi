#!/usr/bin/env bash

set -euo pipefail

# Function to print an error message and exit
error_exit() {
    echo "$1" >&2
    exit 1
}

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    error_exit "This script must be run as root"
fi

# Set password for the root
echo "Set password for the root user:"
passwd

# Install required packages
pacman -Sy --noconfirm grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant \
    dialog os-prober mtools dosfstools base-devel linux-headers reflector cron btrfs-progs git iwd

# Prompt for username
read -rp "Enter the username for the new user: " USERNAME

# Add the user
echo "Set password for the user '$USERNAME':"
useradd -mG wheel "$USERNAME"
passwd "$USERNAME"

# Add new user to sudoers
echo "Uncomment the '%wheel ALL=(ALL:ALL) ALL' line to grant sudo privileges."
EDITOR=nano visudo

# Adjust system settings
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
echo "arch-argi" > /etc/hostname
{
    echo "127.0.0.1  localhost"
    echo "::1        localhost"
    echo "127.0.0.1  arch-argi.localdomain arch-argi"
} >> /etc/hosts
hwclock --systohc

# Configure locales
nano /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Install EFI boot and GRUB configuration
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager

# Label the Btrfs filesystem
btrfs filesystem label / ARCH

# Install Snapper and configure snapshots
pacman -Sy --noconfirm snapper

echo "Installation complete. Please review the output for any errors."

# if you wont yo can install Hyperland from JaKooLit
# git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git
