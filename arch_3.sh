#!/usr/bin/env bash
# this script is optional when you have installed one graphical environment

# if you want yo can install Hyperland from JaKooLit
# git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git

# Install printing support
pacman -Sy --noconfirm cups cups-pdf system-config-printer
systemctl enable cups.service
systemctl enable cups.socket

# Install Snapper and configure snapshots
# pacman -Sy --noconfirm snapper
# for graphical manangment install: btrfs-assistant
pacman -Sy --noconfirm btrfs-assistant


