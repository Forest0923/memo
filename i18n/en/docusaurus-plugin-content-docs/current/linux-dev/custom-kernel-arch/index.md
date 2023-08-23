---
title: "Install Kernel (Arch Linux ver.)"
draft: false
weight: 11
---
This is a note of my development of a Linux kernel on Arch Linux. Basically, I use Ubuntu for my research, but when I tried to install a custom kernel on Arch Linux, I found that the same procedure as on Ubuntu did not work. I will show you how to compile and install without using PKGBUILD.

## Download Source Code

The kernel source code was downloaded from the following URL.

<https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.17.tar.gz>

```sh
curl -O  https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.17.tar.gz
```

```sh
tar xf linux-5.17.tar.gz
```

## Install Neccesary Packages

Install packages necessary for compilation. Without installing cpio, generation of kernel headers failed.

```sh
sudo pacman -S bc cpio
```

## Build

### Generate .config file

The .config file is not created by `make olddefconfig`, but uses the Arch default settings.

```sh
zcat /proc/config.gz > .config
```

### Compile & Install

Compile kernel images and modules, and install modules.

```sh
make -j5 && make modules_install
```

Move the created image to /boot.

```sh
cp arch/x86/boot/bzImage /boot/vmlinuz-linux517
```

### initramfs

Two configuration files are needed to generate the initramfs image. The first is a copy of /etc/mkinitcpio.conf, which contains additional modules and compression format changes.

I added vfat because the FAT32 formatted EFI partition, /boot failed to mount when vfat was not included. Also, the /boot partition was not allocated a very large space, and the disk space was insufficient, so I specified xz compression, which has a high compression ratio.

```sh
cp /etc/mkinitcpio.conf /etc/mkinitcpio-linux517.conf
```

```diff
- MODULES=()
+ MODULES=(vfat)
...
- #COMPRESSION="xz"
+ COMPRESSION="xz"
```

The second configuration file is /etc/mkinitcpio.d/linux517.preset. This is like a template for creating initramfs with mkinitcpio, and is used by modifying the original linux.preset file. The only changes are to the kernel image file path and the /etc/mkinitcpio-linux517.conf file path.

```sh
cp /etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux517.preset
```

```text
# mkinitcpio preset file for the 'linux' package

ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux517"

PRESETS=('default')

default_config="/etc/mkinitcpio-linux517.conf"
default_image="/boot/initramfs-linux517.img"
#default_options=""

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux517-fallback.img"
fallback_options="-S autodetect"
```

Finally, generate initramfs by following command.

```sh
mkinitcpio -p linux517
```

### GRUB Config & Reboot

Update the GRUB configuration and reboot.

```sh
grub-mkconfig -o /boot/grub/grub.cfg
reboot
```
