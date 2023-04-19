+++
title = "[Solved] GRUBをアップグレード後にArch Linuxが起動しなくなった (August 27, 2022)"
description = ""
date = 2022-08-27
tags = [

]
categories = [

]
draft = false
+++

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

## Issue

GRUBをアップグレードした後に再起動すると "Welcome to GRUB!"というメッセージが表示され、ブートメニューが表示されなくなってしまいました。

## 環境

- GRUBバージョン
  - 2:2.06.r322.gd9b4638c5-1
- 私のマシンはデュアルブートで、パーティションのレイアウトは以下のようになっています。

```text
nvme0n1     259:0    0 476.9G  0 disk
├─nvme0n1p1 259:1    0   100M  0 part <- EFIパーティション
├─nvme0n1p2 259:2    0    16M  0 part
├─nvme0n1p3 259:3    0 220.3G  0 part <- Windows Cドライブ
├─nvme0n1p4 259:4    0   548M  0 part
└─nvme0n1p5 259:5    0   256G  0 part <- Linuxファイルシステム
```

## 解決策

以下の手順でGRUBを再インストールすることで問題を解決できます。

1. Arch ISO（USB）からブートします。
2. パーティションをマウントします。

```sh
mkdir /mnt/boot
mount /dev/nvme0n1p5 /mnt
mount /dev/nvme0n1p1 /mnt/boot
```

3. chrootします。

```sh
arch-chroot /mnt
```

4. GRUBを再インストールします。

```sh
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

5. 設定を更新します。

```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

6. 終了して、マウントを解除して再起動します。

```sh
exit
umount /mnt/boot
umount /mnt
reboot
```
