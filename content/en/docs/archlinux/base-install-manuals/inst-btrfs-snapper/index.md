---
title: "Install Arch Linux (Multi-disks + BTRFS + Snapper)"
draft: true
weight: 20
---
Installation manual for Arch Linux. This article describes how to install Arch Linux on BTRFS filesystem and save snapshots with Snapper.

## System

- Intel CPU
- UEFI Boot
- Disks

```text
/dev/vda
/dev/vdb
/dev/vdc
```

## Install

### **Change Keymaps**

Change the keymap to the one you use for the installation. For a Japanese keyboard, use jp106.

```sh
loadkeys jp106
```

### **Time Settings**

Execute the following command to use the NTP (Network Time Protocol).

```sh
timedatectl set-ntp true
```

### **Optimizing Mirrorlist**

Optimize the mirror list using reflector to access mirror servers with fast access during installation.

```sh
pacman -Syy
pacman -S reflector # `python` might be required
reflector -c Japan --sort rate -a 6 --save /etc/pacman.d/mirrorlist
```

The meaning of the reflector option is as follows.

|Options|Description|
|-|-|
|`-c Japan`|Restrict mirrors to selected countries. |
|`--sort rate`|Sort by download rate.|
|`-a 6`|Restrict to servers synchronized within 6 hours.|
|`--save /etc/pacman.d/mirrorlist`|Save the mirror list to the specified path.|

### **Disk Partitioning and Formatting**

Use gdisk to create partitions. We will create an EFI partition (about 200MB) in `/dev/vda`, and the rest of the space and devices will be Linux Filesystem.

```sh
gdisk /dev/vda
gdisk /dev/vdb
gdisk /dev/vdc
```

```text
/dev/vda1: EFI system (200M)
/dev/vda2: Linux filesystem
/dev/vdb1: Linux filesystem
/dev/vdc1: Linux filesystem
```

EFI partition is formatted as fat, and Linux Filesystem is formatted as BTRFS.

```sh
mkfs.fat -F32 /dev/vda1
mkfs.btrfs /dev/vda2 /dev/vdb1 /dev/vdc1
```

Create subvolume and mount devices.

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

### **Base install**

Install the package in the root directory, `/mnt`.

```sh
pacstrap /mnt base linux linux-firmware intel-ucode vim
```

### **Create fstab File**

Generate the fstab file, which holds the information about which device to mount.

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### **Change the Root Directory**

Use chroot to set `/mnt` as the root directory.

```sh
arch-chroot /mnt
```

### **Localization**

Create a symbolic link to `/etc/localtime` to change the time zone.

```sh
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

Set the hardware clock to the current system clock. The system clock is the clock managed by the OS, and the hardware clock is the clock managed by the motherboard (hardware). when the OS is rebooted, the system clock stored in memory is lost, so the time is obtained from the hardware clock.

```sh
hwclock --systohc
```

To set the locale, first generate the locale. Uncomment the entries you want to use in `/etc/locale.gen` and run `locale-gen`.

```sh
vim /etc/locale.gen
```

```diff
- # en_US.UTF-8 UTF-8
+ en_US.UTF-8 UTF-8
```

```sh
locale-gen
```

Execute the following command to set the locale of the system.

```sh
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf
```

### **Hostname**

Register hostname in `/etc/hostname`.

```sh
vim /etc/hostname
```

```diff
+ arch
```

Edit `/etc/hosts` and set IP address corresponding to hostname.

```sh
vim /etc/hosts
```

```diff
+ 127.0.0.1   localhost
+ ::1         localhost
+ 127.0.1.1   arch.localdomain    arch
```

### **Root Password**

Set the password of root user.

```sh
passwd
```

### **Install Additional Packages**

Install Grub as a bootloader.

```sh
pacman -S grub efibootmgr os-prober
```

Install software for network and wireless tools.

```sh
pacman -S networkmanager network-manager-applet wireless_tools wpa_supplicant dialog
```

Install tools that allow us to access MS-DOS disks.

```sh
pacman -S mtools dosgstools
```

Install basic applications (commands) such as sudo, make and gcc.

```sh
pacman -S base-devel
```

Install kernel headers. Kernel headers is a colection of headers and scripts which are used when building kernel modules.

```sh
pacman -S linux-headers
```

Install tools for Bluetooth and audio configurations.

```sh
pacman -S bluez bluez-utils alsa-utils pulseaudio pulseaudio-bluetooth
```

Install command line tools related to desktop applications.

```sh
pacman -S xdg-utils
```

xdg-user-dirs add directories such as `~/Desktop` and `~/Music`.

```sh
pacman -S xdg-user-dirs
```

Install Git.

```sh
pacman -S git
```

Install cron which is used by Snapper. cron is used to execute the program on a scheduled basis.

```sh
pacman -S cron
```

Install reflector to optimize the mirrorlist.

```sh
pacman -S reflector
```

Install Snapper.

```sh
pacman -S snapper
```

Install the PGP Keyring for Arch Linux.

```sh
sudo pacman -S archlinux-keyring
```

### **Configuring mkinitcpio**

Change the configurations, and reflect the changes with mkinitcpio.

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

### **Bootloader**

Install Grub and create config file.

```sh
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### **Systemd**

Enables NetworkManager.

```sh
systemctl enable NetworkManager
```

Enables Bluetooth.

```sh
systemctl enable bluetooth
```

Enables reflector. The execution options are written in `/etc/xdg/reflector/reflector.conf`.

```sh
systemctl enable reflector.service  # update mirrorlist every boot
```

```sh
systemctl enable reflector.timer    # update mirrorlist weekly
```

### **Add User**

Add user with useradd and set the password.

```sh
useradd -mG wheel mori
passwd mori
```

Give the user priviledges.

```sh
EDITOR=vim visudo
```

```diff
- # %wheel ALL=(ALL) ALL
+ %wheel ALL=(ALL) ALL
```

### **Reboot**

```sh
exit
umount -a
reboot
```

### **Install Desktop Environment**

[Desktop Environment](../desktop-env/)

### **Configuring Snapper**

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
