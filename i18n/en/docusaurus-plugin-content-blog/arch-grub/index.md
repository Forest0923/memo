---
title: "[Solved] Arch Linux will not boot after upgrading GRUB (August 27, 2022)"
description: ""
date: 2022-08-27
tags: []
---

## Issue

After upgrading grub, Arch Linux will not boot.
All I get is "Welcome to GRUB!" message and no boot menu.

### Systems

- GRUB version
  - 2:2.06.r322.gd9b4638c5-1
- My machine is dual boot and the partition layout is as follows:

```text
nvme0n1     259:0    0 476.9G  0 disk
├─nvme0n1p1 259:1    0   100M  0 part <- EFI partition
├─nvme0n1p2 259:2    0    16M  0 part
├─nvme0n1p3 259:3    0 220.3G  0 part <- Windows C drive
├─nvme0n1p4 259:4    0   548M  0 part
└─nvme0n1p5 259:5    0   256G  0 part <- Linux filesystem
```

## Solution

To solve the problem, I reinstalled GRUB with the following.

1. Boot from Arch ISO (USB)
2. Mount partitions

```sh
mkdir /mnt/boot
mount /dev/nvme0n1p5 /mnt
mount /dev/nvme0n1p1 /mnt/boot
```

3. chroot

```sh
arch-chroot /mnt
```

4. Reinstall GRUB

```sh
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

5. Update config

```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

6. exit, unmount and reboot

```sh
exit
umount /mnt/boot
umount /mnt
reboot
```
