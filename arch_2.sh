#!/usr/bin/env bash
echo "set password for the root"
passwd

# install some packages more
pacman -Sy grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant \
dialog os-prober mtools dosfstools base-devel linux-headers reflector cron btrfs-progs

# add an user -- chain argi for the username that you wont
echo "set password for the user"
useradd -mG wheel argi
passwd argi

# add new user to sudoers -> uncoment %whell ALL=(ALL:ALL) ALL
EDITOR=nano visudo

# adjust some things
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
echo "arch-argi" >> /etc/hostname
echo -e "127.0.0.1  localhost \n::1  localhost \n127.0.0.1  arch-argi.localdomain arch-argi" >> /etc/hosts
hwclock --systohc
nano /etc/locale.gen
locale-gen
#nano /etc/locale.conf
#LANG=en_US.UTF-8

# install EFI boot and grub config
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager

# add btrfs label 
btrfs filesystem label / ARCH

# install snapper and config snapshots
pacman -Sy snapper
