---
title: "Dual Booting (multi-disk + Windows10 and Arch Linux)"
draft: false
weight: 30
---
## System

- Preinstalled OS: Windows 10 (64 bit Home)
- CPU: Intel
- GPU: Nvidia
- Storage:
  - `/dev/sda`: Windows sub
  - `/dev/sdb`: Windows main
  - `/dev/sdc`: Linux

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

First, find the EFI partition in Windows. Use the following command to find the devices allocated as an EFI partition.

```sh
fdisk -l
```

In this example, we assume that `/dev/sdb1` is the EFI partition. The size of the partition is a bit small (100MB), but it is no problem for now. We will use `/dev/sdc` as the Linux Filesystem.

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

```sh
fdisk /dev/sdc
```

Format with BTRFS.

```sh
mkfs.btrfs /dev/sdc1
```

Create subvolume and mount devices.

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

### **Base install**

Install the package in the root directory, `/mnt`.

```sh
pacstrap /mnt base linux linux-firmware vim intel-ucode
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

```sh
pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools \
wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers git \
reflector bluez bluez-utils pulseaudio-bluetooth ntfs-3g xdg-utils xdg-user-dirs
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

### **Graphic Driver**

{{< tabpane >}}
{{< tab header="Nvidia" lang="sh" >}}

sudo pacman -S nvidia nvidia-utils nvidia-dkms

{{< /tab >}}
{{< /tabpane >}}

### **Fonts**

Copy fonts from windows partition.

```sh
sudo mkdir /usr/share/fonts/WindowsFonts
sudo cp /windows/Windows/Fonts/* /usr/share/fonts/WindowsFonts/
sudo chmod 644 /usr/share/fonts/WindowsFonts/*
fc-cache -f
```

### **Install Desktop Environment**

[Desktop Environment](../desktop-env/)
