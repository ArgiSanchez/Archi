# Arch Linux Auto Install with EFI and Btrfs Subvolumes

This script allows you to install Arch Linux from scratch in just a few seconds, with EFI and Btrfs subvolumes configured.

## How to Use

1. **Download the Arch Linux ISO**  
   Download the latest Arch Linux ISO from the official website:  
   [Arch Linux Download](https://archlinux.org/download/)

2. **Boot from the ISO**  
   Boot your system using the downloaded Arch Linux ISO.

3. **Install Git and Clone the Repository**  
   Just in the first screen terminal run the following commands to install Git and clone this repository:
   ```bash
   pacman -Sy git
   git clone https://github.com/ArgiSanchez/Archi.git

If you're installing from a wireless connection, you must use the `iwctl` command to establish the internet connection to proceed:
 
   ```bash 
   device list
   station wlan0 get-networks
   station wlan0 connect
```

4. **Customize the Scripts**
   Modify the *run.sh* and *arch_2.sh* scripts according to your needs. \
   *-> the most important thing is to define the disk to use and set the two partitions to be used for the installation at the begin of run.sh script*
   ![imagen](https://github.com/ArgiSanchez/Archi/assets/2486668/3a17a4e5-11f2-4971-ab92-57add42feb9a)


6. **Execute the Script**
   Run the installation script with:
   ```sh run.sh``` 

## Continue with a Hyprland Desktop Environment

After the initial setup, you can proceed with the excellent script from [Ja.KooLit](https://github.com/JaKooLit/Arch-Hyprland) to get a fully functional and beautiful Arch Linux desktop with Hyprland in just in a few minutes.

