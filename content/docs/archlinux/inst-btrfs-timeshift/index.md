---
title: "Install Arch Linux with BTRFS (and Backup with Timeshift)"
description: ""
lead: ""
date: 2021-11-29T12:42:30+09:00
lastmod: 2021-11-29T12:42:30+09:00
draft: false
images: []
menu: 
  docs:
    parent: "archlinux"
weight: 10
toc: true
---

## System

- CPU: Intel
- UEFI Boot

## Commands

### Keymap

- Change keymap:

```sh
loadkeys jp106
```

### Time

- Timedatectl:

```sh
timedatectl set-ntp true
```

### Mirrorlist

- Optimize mirror list:

```sh
pacman -Syy
pacman -S reflector
reflector -c Japan --sort rate -a 6 --save /etc/pacman.d/mirrorlist
```

### Disk Partitioning

- Disk partitioning:

```sh
gdisk /dev/vda
```

```text
/dev/vda1: EFI system (200M)
/dev/vda2: Linux filesystem
```

- Format partitions:

```sh
mkfs.fat -F32 /dev/vda1
mkfs.btrfs /dev/vda2
```

- Create subvolume and mount devices:

```sh
mount /dev/vda2 /mnt
btrfs su cr /mnt/@
umount /mnt
mount -o compress=lzo,subvol=@ /dev/vda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi
```

### Base Install

- Install base package:

```sh
pacstrap /mnt base linux linux-firmware vim
```

### fstab

- Generate fstab file:

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### chroot

- chroot:

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

- Hostname:

```sh
vim /etc/hostname
```

```udiff
+ arch
```

- Hosts:

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

### Install necessary softwares

- Bootloader:

```sh
pacman -S grub efibootmgr os-prober
```

- Network and wireless tools:

```sh
pacman -S networkmanager network-manager-applet wireless_tools wpa_supplicant dialog
```

- Disk:

```sh
pacman -S mtools dosgstools
```

- Basic apps (bison, make, gcc, sudo, and etc.):

```sh
pacman -S base-devel
```

- Kernel header files:

```sh
pacman -S linux-headers
```

- Bluetooth and audio:

```sh
pacman -S bluez bluez-utils alsa-utils pulseaudio pulseaudio-bluetooth
```

- Desktop:

```sh
pacman -S xdg-utils xdg-user-dirs
```

- Git:

```sh
pacman -S git
```

- cron:

```sh
pacman -S cron
```

- reflector:

```sh
pacman -S reflector
```

### Grub install

- Grub install and make config:

```sh
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### Systemd

- Activate network:

```sh
systemctl enable NetworkManager
```

- Bluetooth:

```sh
systemctl enable bluetooth
```

- Refresh mirrorlist with reflector
  - Exec options    : `/etc/xdg/reflector/reflector.conf`
  - Weekly setting  : `/usr/lib/systemd/system/reflector.timer`

```sh
systemctl enable reflector.service  # update mirrorlist every boot
# or
systemctl enable reflector.timer    # update mirrorlist weekly
```

### Add user

- Add user:

```sh
useradd -mG wheel mori
passwd mori
```

- Give the user priviledge:

```sh
EDITOR=vim visudo
```

```udiff
- # %wheel ALL=(ALL) ALL
+ %wheel ALL=(ALL) ALL
```

### Finish base installation

- Reboot

```sh
exit
umount -a
reboot
```

### Install desktop environment

- [Stacking window manager](arch-desktop)
- [Tiling window manager](arch-bspwm)

### Install timeshift

- Install AUR helper:

```sh
# yay
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
# paru
git clone https://aur.archlinux.org/paru
cd paru
makepkg -si
```

- Install timeshift:

```sh
paru -S timeshift
```
