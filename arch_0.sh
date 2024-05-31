#!/usr/bin/env bash
# scripg based on arch linux from scrach
# start iso, install git, customize for you, and execute it

# cfdisk /dev/xxx -> partition your disk
mkfs.fat -F 32 /dev/vda1  # 512M  /boot/efi
mkfs.btrfs /dev/vda2   

# create subvolums
mount /dev/vda2 /mnt
btrfs su cr /mnt/@ 
btrfs su cr /mnt/@home
brtfs su cr /mnt/@cache
btrfs su cr /mnt/@log
btrfs su cr /mnt/@.snapshots

# mount the btrfs volums
umount /mnt
mount -o compress=zstd:1,subvol=@ /dev/vda2 /mnt
mount -o compress=zstd:1,subvol=@home /dev/vda2 /mnt/home
mount -o compress=zstd:1,subvol=@cache /dev/vda2 /mnt/var/cache
mount -o compress=zstd:1,subvol=@log /dev/vda2 /mnt/var/log
mount -o compress=zstd:1,subvol=@.snapshots /dev/vda2 /mnt/.snapshots

# mount the efi partition
mkdir -p /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi

# install base and do the arch-chroot
pacstrap /mnt base linux linux-firmware vim nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# set de root password
passwd

# install some packages more
pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant \
dialog os-prober mtools dosfstools base-devel linux-headers reflector cron btrfs-progs

# add an user -- chain argi for the username that you wont
useradd -mG wheel argi
passwd argi

# add new user to sudoers -> uncoment %whell ALL=(ALL:ALL) ALL
EDITOR=nano visudo


# adjust some things
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
echo "arch-argi" >> /etc/hostname
echo -e "127.0.0.1  localhost \n::1  localhost \n127.0.0.1  arh-argi.localdomain arh-argi" >> /etc/hosts
#hwclock —systohc
#nano /etc/locale.gen
#locale-gen
#nano /etc/locale.conf
#LANG=en_US.UTF-8


# install EFI boot and grub config
grub-install —target=x86_64-efi —efi-directory=/boot/efi —bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager


# add btrfs label 
btrfs filesystem label / ARCH

# reboot you system
