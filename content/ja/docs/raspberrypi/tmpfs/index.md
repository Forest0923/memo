---
title: "RAM disk（tmpfs）を使った SD カードの延命"
draft: false
weight: 10
---

SD カードに何度も書き込みを行うと最終的にフラッシュメモリの劣化で書き込みができなくなるのですが、ラズパイでも `/var/log` の頻繁な書き込みが原因で同じことが起こると聞いたので対策をしたときのメモです。

## tmpfs

`/etc/fstab` を編集してマウントし直します。

```text
tmpfs   /tmp            tmpfs   defaults,size=100m,noatime 0 0
tmpfs   /var/log        tmpfs   defaults,size=32m,noatime 0 0
```

```sh
sudo mount -a
sudo systemctl daemon-reload
```

結果:

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
