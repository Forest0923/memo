---
title: "Dual boot (with Windows 11) + btrfs + systemd-boot"
draft: false
weight: 30
---

Install Arch Linux with the following settings.

| Settings        |              |
| --------------- | ------------ |
| Dual Booting    | Windows 11   |
| Filesystem      | Btrfs        |
| Boot Loader     | Systemd-boot |
| Disk            | single-disk  |
| Disk Encryption | false        |

## Install flow

- Install Windows 11
- shrink disk for linux
- boot from live usb
- install arch linux

## ISO

[Arch Linux Downloads](https://archlinux.org/download/)

## Install

```sh
loadkeys jp106
fdisk /dev/sda
cryptsetup luksFormat /dev/sda4
cryptsetup liksOpen /dev/sda4 luksroot
mkfs.btrfs /dev/mapper/luksroot
mount /dev/mapper/luksroot /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log
umount /mnt
mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/mapper/luksroot /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=lzo,space_cache=v2,subvol=@home /dev/mapper/luksroot /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots /dev/mapper/luksroot /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,subvol=@var_log /dev/mapper/luksroot /mnt/var/log
mount /dev/sda1 /mnt/boot
pacman -Syy
pacman -S archlinux-keyring
pacstrap /mnt base linux linux-firmware vim intel-ucode # or amd-ucode

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc

vim /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf
echo arch > /etc/hostname
vim /etc/hosts
passwd

pacman -S grub efibootmgr networkmanager network-manager-applet \
dialog os-prober mtools dosfstools base-devel linux-headers \
reflector git xdg-utils xdg-user-dirs bluez bluez-utils

bootctl --path=/boot install
vim /boot/loader/loader.conf

vim /etc/mkinitcpio.conf
# btrfs, encrypt
mkinitcpio -p linux

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
