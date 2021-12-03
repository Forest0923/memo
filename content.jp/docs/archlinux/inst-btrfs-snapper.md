---
title: "Install Arch Linux with BTRFS (and Backup with Snapper)"
description: ""
lead: ""
date: 2021-11-29T12:42:43+09:00
lastmod: 2021-11-29T12:42:43+09:00
draft: false
images: []
menu: 
  docs:
    parent: "archlinux"
weight: 20
toc: true
---

## System

- CPU: Intel
- UEFI Boot
- Multi-disk support with btrfs
  - Devices:

  ```text
  /dev/vda
  /dev/vdb
  /dev/vdc
  ```

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
pacman -S reflector # `python` might be required
reflector -c Japan --sort rate -a 6 --save /etc/pacman.d/mirrorlist
```

### Disk formatting

- Partitioning:

```sh
gdisk /dev/vda
```

```text
/dev/vda1: EFI system (200M)
/dev/vda2: Linux filesystem
```

```sh
gdisk /dev/vdb
```

```text
/dev/vdb1: Linux filesystem
```

```sh
gdisk /dev/vdc
```

```text
/dev/vdc1: Linux filesystem
```

- Formattiong:

```sh
mkfs.fat -F32 /dev/vda1
mkfs.btrfs /dev/vda2 /dev/vdb1 /dev/vdc1
```

- Mount:

```sh
mount /dev/vda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log

umount /mnt

mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/vda2 /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=lzo,space_cache=v2,subvol=@home /dev/vda2 /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots /dev/vda2 /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,subvol=@var_log /dev/vda2 /mnt/var/log

mount /dev/vda1 /mnt/boot
```

### Base install

- Install base package:

```sh
pacstrap /mnt base linux linux-firmware intel-ucode vim
```

### Create fstab file

- Generate fstab:

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### Chroot

```sh
arch-chroot /mnt
```

### Localization

- Hardware clock:

```sh
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc
```

- Set locale and input method:

```sh
vim /etc/locale.gen
```

```diff
- # en_US.UTF-8 UTF-8
+ en_US.UTF-8 UTF-8
```

```sh
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf
```

### Hostname and hosts

- Hostname:

```sh
vim /etc/hostname
```

```diff
+ arch
```

- Hosts:

```sh
vim /etc/hosts
```

```diff
+ 127.0.0.1   localhost
+ ::1         localhost
+ 127.0.1.1   arch.localdomain    arch
```

### Root password

- passwd

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

- snapper:

```sh
pacman -S snapper
```

- Keyring:

```sh
sudo pacman -S archlinux-keyring
```

### mkinitcpio

```sh
vim /etc/mkinitcpio.conf
```

```diff
- MODULES=()
+ MODULES=(btrfs)
```

```sh
mkinitcpio -p linux
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

### Install and configure snapper

```sh
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs su delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
sudo vim /etc/snapper/configs/root
```

```diff
+ TIMELINE_LIMIT_HOURLY="5"
+ TIMELINE_LIMIT_DAILY="7"
+ TIMELINE_LIMIT_WEEKLY="0"
+ TIMELINE_LIMIT_MONTHLY="0"
+ TIMELINE_LIMIT_YEARLY="0"
```

```sh
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
paru -S snap-pac-grub snapper-gui-git
sudo mkdir /etc/pacman.d/hooks
sudo vim /etc/pacman.d/hooks/50-bootbackup.hook
```

```diff
+ [Trigger]
+ Operation = Upgrade
+ Operation = Install
+ Operation = Remove
+ Type = Path
+ Target = boot/*
+ 
+ [Action]
+ Depends = rsync
+ Description = Backing up /boot...
+ When = PreTransaction
+ Exec = /usr/bin/rsync -a --delete /boot /.bootbackup
```

```sh
sudo pacman -S rsync
sudo chmod a+rx /.snapshots
sudo chown :mori /.snapshots
```
