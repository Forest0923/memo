---
title: "Extending SD Card Lifespan Using RAM Disk (tmpfs)"
draft: false
weight: 10
---

When writing to an SD card repeatedly, it eventually becomes impossible to write due to degradation of the flash memory. I heard that the same thing happens on Raspberry Pi due to frequent writing to `/var/log`, so this is a note when I took measures against it.

## tmpfs

Edit `/etc/fstab` and remount.

```text
tmpfs   /tmp            tmpfs   defaults,size=100m,noatime 0 0
tmpfs   /var/log        tmpfs   defaults,size=32m,noatime 0 0
```

```sh
sudo mount -a
sudo systemctl daemon-reload
```

Result:

```text
mmori@ubuntu:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           380M  8.4M  371M   3% /run
/dev/mmcblk0p2  115G  5.5G  105G   5% /
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs            32M  348K   32M   2% /var/log
tmpfs           100M     0  100M   0% /tmp
/dev/mmcblk0p1  253M  151M  102M  60% /boot/firmware
tmpfs           380M  4.0K  380M   1% /run/user/1000
```
