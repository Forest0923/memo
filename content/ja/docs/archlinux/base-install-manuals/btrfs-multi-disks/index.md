---
title: "multi-disks + btrfs + grub"
draft: false
weight: 30
---

Install Arch Linux with the following settings.

| Settings        |             |
| --------------- | ----------- |
| Dual Booting    | false       |
| Filesystem      | Btrfs       |
| Boot Loader     | GRUB        |
| Disk            | multi-disks |
| Disk Encryption | false       |

## System

- Storages:
  - `/dev/sda`
  - `/dev/sdb`
  - `/dev/sdc`

## Install

### Keymaps

Change the keymap to the one you use for the installation. For a Japanese keyboard, use jp106.

```sh
loadkeys jp106
```

### Time Settings

Execute the following command to use the NTP (Network Time Protocol).

```sh
timedatectl set-ntp true
```

### Optimizing Mirrorlist

Optimize the mirror list using reflector to access mirror servers with fast access during installation.

```sh
pacman -Syy
pacman -S reflector
reflector -c Japan --sort rate -a 6 --save /etc/pacman.d/mirrorlist
```

The meaning of the reflector option is as follows.

|Options|Description|
|-|-|
|`-c Japan`|Restrict mirrors to selected countries. |
|`--sort rate`|Sort by download rate.|
|`-a 6`|Restrict to servers synchronized within 6 hours.|
|`--save /etc/pacman.d/mirrorlist`|Save the mirror list to the specified path.|

### Disk Partitioning and Formatting

Use gdisk to create partitions. We will create an EFI partition (about 200MB) in `/dev/sda`, and the rest of the space and devices will be Linux Filesystem.

```sh
gdisk /dev/sda
gdisk /dev/sdb
gdisk /dev/sdc
```

```text
/dev/sda1: EFI system (200M)
/dev/sda2: Linux filesystem
/dev/sdb1: Linux filesystem
/dev/sdc1: Linux filesystem
```

EFI partition is formatted as fat, and Linux Filesystem is formatted as BTRFS.

```sh
mkfs.fat -F32 /dev/sda1
mkfs.btrfs /dev/sda2 /dev/vdb1 /dev/vdc1
```

Create subvolume and mount devices.

```sh
mount /dev/sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log

umount /mnt

mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=lzo,space_cache=v2,subvol=@home /dev/sda2 /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots /dev/sda2 /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,subvol=@var_log /dev/sda2 /mnt/var/log

mount /dev/sda1 /mnt/boot
```

### Base Install

Sometimes updating archlinux-keyring is needed.

```sh
pacman -Syy
pacman -S archlinux-keyring
```

Install packages in `/mnt`.

{{< tabpane >}}
{{< tab header="Intel" lang="sh" >}}

pacstrap /mnt base linux linux-firmware vim intel-ucode

{{< /tab >}}
{{< tab header="AMD" lang="sh" >}}

pacstrap /mnt base linux linux-firmware vim amd-ucode

{{< /tab >}}
{{< /tabpane >}}

### fstab

Generate the fstab file, which holds the information about which device to mount.

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### Change the Root Directory

Use chroot to set `/mnt` as the root directory.

```sh
arch-chroot /mnt
```

### Localization

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
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
```

Execute the following command to set the locale of the system.

```sh
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf
```

### Hostname

Register hostname in `/etc/hostname`.

```sh
echo arch > /etc/hostname
```

Edit `/etc/hosts` and set IP address corresponding to hostname.

```sh
echo -e "127.0.0.1\tlocalhost
::1\t\tlocalhost
127.0.1.1\tarch.localdomain\tarch" >> /etc/hosts
```

### Root Password

Set the password of root user.

```sh
passwd
```

### Install Additional Packages

```sh
pacman -S grub efibootmgr networkmanager network-manager-applet \
  dialog os-prober mtools dosfstools base-devel linux-headers reflector \
  git xdg-utils xdg-user-dirs bluez bluez-utils
```

### Configuring mkinitcpio

Change the configurations, and reflect the changes with mkinitcpio.

```sh
sed -i 's/MODULES=()/MODULES=(btrfs)/' /etc/mkinitcpio.conf
mkinitcpio -p linux
```

### Bootloader

Install Grub and create config file.

```sh
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### Systemd

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

### Add User

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

### Reboot

```sh
exit
umount -a
reboot
```

### **Fonts**

Copy fonts from windows partition.

```sh
sudo mkdir /usr/share/fonts/WindowsFonts
sudo cp /windows/Windows/Fonts/* /usr/share/fonts/WindowsFonts/
sudo chmod 644 /usr/share/fonts/WindowsFonts/*
fc-cache -f
```

### **Install Desktop Environment**

[Desktop Environment](../../desktop-env/)
