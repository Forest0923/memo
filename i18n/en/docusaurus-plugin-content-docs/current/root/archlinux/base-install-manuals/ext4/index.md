---
title: "ext4 + grub"
draft: false
weight: 10
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Install Arch Linux with the following settings.

| Settings        |             |
| --------------- | ----------- |
| Dual Booting    | false       |
| Filesystem      | ext4        |
| Boot Loader     | GRUB        |
| Disk            | single-disk |
| Disk Encryption | false       |

## ISO

[Arch Linux Downloads](https://archlinux.org/download/)

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

Use gdisk to change the partition. In this example, we assume that Arch Linux is installed in `/dev/sda`.

```sh
gdisk /dev/sda
```

Allocate the first partition as an EFI partition of about 300MB. The remaining space will be allocated as a Linux Filesystem.

```text
/dev/sda1: EFI system (300M)
/dev/sda2: Linux filesystem
```

EFI partition is formatted with fat.

```sh
mkfs.fat -F32 /dev/sda1
```

Linux Filesystem is formatted with ext4.

```sh
mkfs.ext4 /dev/sda2
```

Then mount devices like following.

```sh
mount /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot
```

### Base Install

Sometimes updating archlinux-keyring is needed.

```sh
pacman -Syy
pacman -S archlinux-keyring
```

Install packages in `/mnt`.

<Tabs groupId="cpu-vendor" queryString>
  <TabItem value="intel" label="Intel">

  ```sh
pacstrap /mnt base linux linux-firmware vim intel-ucode
  ```

  </TabItem>
  <TabItem value="amd" label="AMD">

  ```sh
pacstrap /mnt base linux linux-firmware vim amd-ucode
  ```

  </TabItem>
</Tabs>

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
