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

# Ensure the disk is specified as an argument
if [[ $# -ne 1 ]]; then
    error_exit "Usage: $0 /dev/sdX"
fi

DISK="$1"

# Verify the disk exists
if [[ ! -b $DISK ]]; then
    error_exit "Disk $DISK does not exist"
fi

# Unmount all partitions of the specified disk
umount -R /mnt 2>/dev/null || true

# Customize the partitions to format
mkfs.fat -F32 "${DISK}1" -I > /dev/null
mkfs.btrfs "${DISK}2" -f > /dev/null

# Create subvolumes
mount "${DISK}2" /mnt
for subvol in @ @tmp @home @cache @log @spool @snapshots; do
    btrfs su cr "/mnt/$subvol"
done

# Mount the btrfs subvolumes
umount /mnt
mount -o compress=zstd:1,subvol=@ "${DISK}2" /mnt
mkdir -p /mnt/{var/tmp,home,var/cache,var/log,var/spool,.snapshots}
mount -o compress=zstd:1,subvol=@tmp "${DISK}2" /mnt/var/tmp
mount -o compress=zstd:1,subvol=@home "${DISK}2" /mnt/home
mount -o compress=zstd:1,subvol=@cache "${DISK}2" /mnt/var/cache
mount -o compress=zstd:1,subvol=@log "${DISK}2" /mnt/var/log
mount -o compress=zstd:1,subvol=@spool "${DISK}2" /mnt/var/spool
mount -o compress=zstd:1,subvol=@snapshots "${DISK}2" /mnt/.snapshots

# Mount the EFI partition
mkdir -p /mnt/boot/efi
mount "${DISK}1" /mnt/boot/efi

# Copy part2 of installation
cp arch_2.sh /mnt/home/arch_2.sh
chmod +x /mnt/home/arch_2.sh

# Install base and do the arch-chroot
pacstrap /mnt base linux linux-firmware vim nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /home/arch_2.sh

# Clean up
rm /mnt/home/arch_2.sh

# Print completion message
echo -e "\n---------------------------------------\n"
echo -e " ... Remove the ISO and REBOOT your system ..."
echo -e "\n--------------------------------------\n"
