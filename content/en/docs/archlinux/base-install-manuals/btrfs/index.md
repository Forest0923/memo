---
title: "btrfs + grub"
draft: false
weight: 11
---

Install Arch Linux with the following settings.

| Settings        |             |
| --------------- | ----------- |
| Dual Booting    | false       |
| Filesystem      | Btrfs       |
| Boot Loader     | GRUB        |
| Disk            | single-disk |
| Disk Encryption | false       |

## ISO

[Arch Linux Downloads](https://archlinux.org/download/)

## Install

```sh
loadkeys jp106
timedatectl set-ntp true

gdisk /dev/sda

mkfs.fat -F32 /dev/sda1
mkfs.btrfs /dev/sda2

mount /dev/sda2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var_log
umount /mnt
mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/sda2 /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/sda2 /mnt/.snapshots
mount -o noatime,compress=zstd,space_cache=v2,subvol=@var_log /dev/sda2 /mnt/var/log

mount /dev/sda1 /mnt/boot

pacman -Syy
pacman -S archlinux-keyring
pacstrap /mnt base linux linux-firmware vim intel-ucode # or amd-ucode

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf
echo arch > /etc/hostname
echo -e "127.0.0.1\tlocalhost
::1\t\tlocalhost
127.0.1.1\tarch.localdomain\tarch" >> /etc/hosts

passwd

pacman -S grub efibootmgr networkmanager network-manager-applet \
dialog os-prober mtools dosfstools base-devel linux-headers \
reflector git xdg-utils xdg-user-dirs bluez bluez-utils

sed -i 's/MODULES=()/MODULES=(btrfs)/' /etc/mkinitcpio.conf
mkinitcpio -p linux

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable reflector.service
systemctl enable reflector.timer

useradd -mG wheel mori
passwd mori

EDITOR=vim visudo

exit
umount -a
reboot
```
