#!/usr/bin/env bash
# First use fdisk or cfdisk /dev/xxx -> and do partitions for your disk
umount -a > /dev/null
# Customize the partitions to format
mkfs.fat -F32 /dev/vda1 -I > /dev/null
mkfs.btrfs /dev/vda2 -f > /dev/null  

# Create subvolums
mount /dev/vda2 /mnt
btrfs su cr /mnt/@ 
btrfs su cr /mnt/@home
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@log
btrfs su cr /mnt/@snapshots

# mount the btrfs volums
umount /mnt
mount -o compress=zstd:1,subvol=@ /dev/vda2 /mnt
mkdir /mnt/home
mount -o compress=zstd:1,subvol=@home /dev/vda2 /mnt/home
mkdir -p /mnt/var/cache
mount -o compress=zstd:1,subvol=@cache /dev/vda2 /mnt/var/cache
mkdir /mnt/var/log
mount -o compress=zstd:1,subvol=@log /dev/vda2 /mnt/var/log
mkdir /mnt/.snapshots
mount -o compress=zstd:1,subvol=@snapshots /dev/vda2 /mnt/.snapshots

# mount the efi partition
mkdir -p /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi

#copy part2 of installation
cp arch_2.sh /mnt/home/arch_2.sh
chmod +x /mnt/home/arch_2.sh

# install base and do the arch-chroot
pacstrap /mnt base linux linux-firmware vim nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash /home/arch_2.sh

# end
rm /mnt/home/arch_2.sh
echo -e "\n---------------------------------------\n"
echo -e " ... Remov de ISO and REBOOT your system ..."
echo -e "\n--------------------------------------\n "
