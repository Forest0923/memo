+++
title = "Raid With Mdadm"
description = ""
date = 2023-06-09T20:06:14+09:00
tags = [

]
categories = [

]
draft = false
+++

## 目的

ラズパイの外付け HDD で RAID を組みたい。

## 背景

RAID は複数のストレージデバイスを組み合わせて信頼性の高い一つのストレージとして使用する技術です。
なんとなくやっていることは知っていたのですが、今回はあらためて原理を調べつつ、実際に RAID を組んでファイルサーバとして使用してみようと思います。

以下は各 RAID レベルの簡単な説明です。
Arch wiki なりなんなり見たほうが詳しく書いてあるしわかりやすいですが、勉強の意味でも一応書いておきます。

### RAID0
### RAID1
### RAID5
### RAID6
### RAID10

## 使うもの

- HDD: 512 GB x 5
- Raspberry Pi 4B
  - OS: Ubuntu 23.04

## コマンド

```text
mmori@ubuntu:~$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0         7:0    0  67.7M  1 loop /snap/core22/637
loop1         7:1    0  46.4M  1 loop /snap/snapd/19127
loop2         7:2    0 161.2M  1 loop /snap/lxd/24922
loop3         7:3    0  68.5M  1 loop /snap/core22/753
loop4         7:4    0 157.6M  1 loop /snap/lxd/24851
loop5         7:5    0  46.4M  1 loop /snap/snapd/19365
sda           8:0    0 465.8G  0 disk
└─sda1        8:1    0 465.8G  0 part
sdb           8:16   0 465.8G  0 disk
└─sdb1        8:17   0 465.8G  0 part
sdc           8:32   0 465.8G  0 disk
└─sdc1        8:33   0 465.8G  0 part
sdd           8:48   0 465.8G  0 disk
└─sdd1        8:49   0 465.8G  0 part
sde           8:64   0 465.8G  0 disk
└─sde1        8:65   0 465.8G  0 part
mmcblk0     179:0    0 116.4G  0 disk
├─mmcblk0p1 179:1    0   256M  0 part /boot/firmware
└─mmcblk0p2 179:2    0 116.1G  0 part /
mmori@ubuntu:~$ sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=5 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: partition table exists on /dev/sda
mdadm: partition table exists on /dev/sda but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdb
mdadm: partition table exists on /dev/sdb but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdc
mdadm: partition table exists on /dev/sdc but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdd
mdadm: partition table exists on /dev/sdd but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sde
mdadm: partition table exists on /dev/sde but will be lost or
       meaningless after creating array
mdadm: size set to 488254464K
mdadm: automatically enabling write-intent bitmap on large array
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
mmori@ubuntu:~$
mmori@ubuntu:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid5 sde[5] sdd[3] sdc[2] sdb[1] sda[0]
      1953017856 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [UUUU_]
      [>....................]  recovery =  0.0% (118588/488254464) finish=1097.6min speed=7411K/sec
      bitmap: 0/4 pages [0KB], 65536KB chunk

unused devices: <none>
mmori@ubuntu:~$ sudo mkfs.ext4 /dev/md0
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 488254464 4k blocks and 122068992 inodes
Filesystem UUID: 65815302-0210-4b7c-8496-a3711f5ccb2a
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000, 214990848

Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done
mmori@ubuntu:~$ sudo mkdir /mnt/raid5
mmori@ubuntu:~$ sudo mount /dev/md0 /mnt/raid5/
mmori@ubuntu:~$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0         7:0    0  67.7M  1 loop  /snap/core22/637
loop1         7:1    0  46.4M  1 loop  /snap/snapd/19127
loop2         7:2    0 161.2M  1 loop  /snap/lxd/24922
loop3         7:3    0  68.5M  1 loop  /snap/core22/753
loop4         7:4    0 157.6M  1 loop  /snap/lxd/24851
loop5         7:5    0  46.4M  1 loop  /snap/snapd/19365
sda           8:0    0 465.8G  0 disk
└─md0         9:0    0   1.8T  0 raid5 /mnt/raid5
sdb           8:16   0 465.8G  0 disk
└─md0         9:0    0   1.8T  0 raid5 /mnt/raid5
sdc           8:32   0 465.8G  0 disk
└─md0         9:0    0   1.8T  0 raid5 /mnt/raid5
sdd           8:48   0 465.8G  0 disk
└─md0         9:0    0   1.8T  0 raid5 /mnt/raid5
sde           8:64   0 465.8G  0 disk
└─md0         9:0    0   1.8T  0 raid5 /mnt/raid5
mmcblk0     179:0    0 116.4G  0 disk
├─mmcblk0p1 179:1    0   256M  0 part  /boot/firmware
└─mmcblk0p2 179:2    0 116.1G  0 part  /
mmori@ubuntu:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           380M  8.3M  371M   3% /run
/dev/mmcblk0p2  115G  6.3G  104G   6% /
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           100M     0  100M   0% /tmp
tmpfs            32M  496K   32M   2% /var/log
/dev/mmcblk0p1  253M  152M  101M  61% /boot/firmware
tmpfs           380M  4.0K  380M   1% /run/user/1000
/dev/md0        1.8T  2.1M  1.7T   1% /mnt/raid5
```


```text
mmori@ubuntu:~$ sudo systemctl enable mnt-raid5.mount
Created symlink /etc/systemd/system/multi-user.target.wants/mnt-raid5.mount → /etc/systemd/system/mnt-raid5.mount.
mmori@ubuntu:~$
mmori@ubuntu:~$ cat /etc/systemd/system/mnt-raid5.mount
[Unit]
Description=Mount RAID Array
After=dev-md0.device
Requires=dev-md0.device

[Mount]
What=/dev/md0
Where=/mnt/raid5
Type=ext4
Options=defaults

[Install]
WantedBy=multi-user.target
```

```sh
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```
