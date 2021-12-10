---
title: "Dual Booting on Multiple Disks (Windows10 and ArchLinux)"
draft: false
weight: 30
---

# Dual Booting on Multiple Disks (Windows10 and ArchLinux)

## System

- Preinstalled OS: Windows 10 (64 bit Home)
- CPU: Intel
- GPU: Nvidia
- SSD
  - win
  - linux

## Goal

- Dual booting Windows 10 and Arch Linux
- Arch Linux with BTRFS

## Commands

### Keymap

- Set keymaps:

```sh
loadkeys jp106
```

### Mirrorlist

- Optimize mirror list:

```sh
pacman -Syyy
pacman -S reflector
reflector -c Japan --sort rate --save /etc/pacman.d/mirrorlist
```

### Disk Partitioning

- Find windows EFI partition:

```sh
fdisk -l
```

- In my case:

```text
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 931.5G  0 disk
└─sda1   8:1    0 931.5G  0 part /windows_d
sdb      8:16   0 238.5G  0 disk
├─sdb1   8:17   0   100M  0 part /boot/efi
├─sdb2   8:18   0    16M  0 part
├─sdb3   8:19   0 237.4G  0 part /windows_c
└─sdb4   8:20   0   990M  0 part
sdc      8:32   0 476.9G  0 disk
└─sdc1   8:33   0 476.9G  0 part /
sr0     11:0    1  1024M  0 rom
```

- Disk partitioning (Linux File System only):

```sh
fdisk /dev/sdc
```

- Formatting:

```sh
mkfs.btrfs /dev/sdc1
```

- Mount partitions:

```sh
mount /dev/sdc1 /mnt
btrfs su cr /mnt/@
umount /mnt
mount -o compress=lzo,subvol=@ /dev/sdc1 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sdb2 /mnt/boot/efi

mkdir /mnt/windows_c
mount /dev/sdb4 /mnt/windows_c

mkdir /mnt/windows_d
mount /dev/sdb1 /mnt/windows_d
```

### Base Install

- Install base packages:

```sh
pacstrap /mnt base linux linux-firmware vim intel-ucode
```

### fstab

- Generate fstab file:

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### chroot

```sh
arch-chroot /mnt
```

### Localization

- Hardware clock:

```sh
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc
```

- locale:

```sh
vim /etc/locale.gen
```

```udiff
- # en_US.UTF-8 UTF-8
+ en_US.UTF-8 UTF-8
```

```sh
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf
```

### Set hostname and hosts

- Set hostname and hosts:

```sh
vim /etc/hostname
```

```udiff
+ arch
```

```sh
vim /etc/hosts
```

```udiff
+ 127.0.0.1   localhost
+ ::1         localhost
+ 127.0.1.1   arch.localdomain    arch
```

### Root password

- Set root password:

```sh
passwd
```

### Install grub and etc

- Install bootloader, network tools, and etc:

```sh
pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools \
wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers git \
reflector bluez bluez-utils pulseaudio-bluetooth ntfs-3g xdg-utils xdg-user-dirs
```

### Grub install

- Grub install and make config:

```sh
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### Systemd (Network Manager and Bluetooth)

- Activate services:

```sh
systemctl enable NetworkManager
systemctl enable bluetooth
```

### Add user

- Add user:

```sh
useradd -mG wheel mori
passwd mori
```

- Give priviledge:

```sh
EDITOR=vim visudo
```

```udiff
- # %wheel all=(all) all
+ %wheel all=(all) all
```

### Exit chroot

- Reboot:

```sh
exit
umount -a
reboot
```

### Graphic driver

- Graphic card:

```sh
sudo pacman -S nvidia nvidia-utils nvidia-dkms
```

### Font

- Copy fonts from windows:

```sh
sudo mkdir /usr/share/fonts/WindowsFonts
sudo cp /windows/Windows/Fonts/* /usr/share/fonts/WindowsFonts/
sudo chmod 644 /usr/share/fonts/WindowsFonts/*
fc-cache -f
```

### Desktop environment

- Display server:

```sh
sudo pacman -S xorg
```

- Display manager:

```sh
# lightdm
sudo pacman -S lightdm lightdm-gtk-greeter
# gdm
sudo pacman -S gdm
```

- Desktop environment:

```sh
# xfce
sudo pacman -S xfce4 xfce4-goodies
# gnome
sudo pacman -S gnome gnome-tweaks
# budgie
sudo pacman -S budgie-desktop gnome
```

- Activate display manager:

```sh
# lightdm
systemctl enable lightdm
# gdm
systemctl enable gdm
```
