---
title: "Install Arch Linux (BTRFS + Timeshift)"
draft: false
weight: 10
---
Installation manual for Arch Linux. This article describes how to install Arch Linux on BTRFS filesystem and save snapshots with Timeshift.

## System

- Intel CPU
- UEFI Boot

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

Use gdisk to change the partition. In this example, we assume that Arch Linux is installed in `/dev/vda`.

```sh
gdisk /dev/vda
```

Allocate the first partition as an EFI partition of about 200MB. The remaining space will be allocated as a Linux Filesystem. Assuming that there is enough memory, we will not allocate the swap space.

```text
/dev/vda1: EFI system (200M)
/dev/vda2: Linux filesystem
```

EFI partition is formatted with fat.

```sh
mkfs.fat -F32 /dev/vda1
```

Linux Filesystem is formatted with BTRFS.

```sh
mkfs.btrfs /dev/vda2
```

Create subvolume and mount devices.

```sh
mount /dev/vda2 /mnt
btrfs su cr /mnt/@
umount /mnt
mount -o compress=lzo,subvol=@ /dev/vda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi
```

### **Base Install**

Install the package in the root directory, `/mnt`.

```sh
pacstrap /mnt base linux linux-firmware vim
```

### **fstab**

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

```udiff
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

```udiff
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

Install cron which is used by Timeshift. cron is used to execute the program on a scheduled basis.

```sh
pacman -S cron
```

Install reflector to optimize the mirrorlist.

```sh
pacman -S reflector
```

### **Bootloader**

Install Grub and create config file.

```sh
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
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

### **Install Timeshift**

Install Timeshift with AUR helper.

{{< tabpane >}}
{{< tab header="paru" lang="sh" >}}

git clone https://aur.archlinux.org/paru
cd paru
makepkg -si

{{< /tab >}}
{{< tab header="yay" lang="sh" >}}

git clone https://aur.archlinux.org/yay
cd yay
makepkg -si

{{< /tab >}}
{{< /tabpane >}}

```sh
paru -S timeshift
```
