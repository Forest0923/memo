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

## Objective

I want to set up RAID on an external HDD with Raspberry Pi.

## Background

RAID is a technology that combines multiple storage devices to use as a single, highly reliable storage.
I had a vague idea of what it does, but this time I try to research the principles and set up RAID to use as a file server.

Below is a simple explanation of each RAID level.
You can find more detailed and comprehensible information by looking at sources like the Arch wiki, but I will write it here for the sake of learning as well.

### RAID 0

RAID 0 is a RAID that does not employ any redundancy.
Data is distributed and saved, and since the bandwidth is large, read and write operations can be performed quickly if things go well.

Since it does not improve reliability through redundancy, I was not sure about its practical use cases.
But upon reading the Arch wiki, it says that it can be used for swap partitions and other scenarios where "the speed increase is worth the possibility of data loss".
As large capacity memory is used these days, I really don't know the practical use cases as swap areas are often not created.

![](raid0.svg)

### RAID 1

RAID 1 is a RAID that improves reliability by writing exactly the same data to multiple disks.
Redundancy is provided, but there is a problem with the inefficient use of storage.
Basically, when setting up RAID 1 using two storages, the usable capacity becomes half of the total.

![](raid1.svg)

Since there is no problem if either of the storages is alive, it is overwhelmingly reassuring compared to RAID 0.

![](raid1_recovery.svg)

### RAID 1+0 (RAID 10)

In RAID 10, RAID 1 is combined with RAID 0 to improve performance while providing redundancy.
The redundancy method is the same as RAID 1, so the storage usage efficiency remains poor.

![](raid10.svg)

It has improved fault tolerance compared to RAID 1, and there is no problem if two fail simultaneously, as long as they are from different RAID 1 groups.
Of course, if two from the same RAID 1 group fail at the same time, it's over.

![](raid10_recovery.svg)

### RAID 5

RAID 5 distributes and stores data, and creates parity blocks for redundancy.
The capacity of parity is at most one storage, so if you set up RAID 5 with N storage devices, the usable capacity becomes (N - 1) / N.

![](raid5.svg)

Parity is calculated using XOR, so if only one storage fails, you can restore it.
However, if two or more fail simultaneously, restoration is not possible, so depending on the reliability of the storage, the number and size of combinations, it is not recommended.
If a disk fails, you add a new disk and perform restoration, but a large amount of reading and writing is performed during restoration, so there is a possibility of failure at that time.
Again, according to the Arch wiki, it is not recommended in the recent storage industry.

![](raid5_recovery.svg)

### RAID 6

RAID 6 is designed to allow for restoration even if up to two storage devices fail simultaneously by increasing the parity of RAID 5.
A minimum of 4 storage devices is required, and the usage efficiency of capacity becomes (N - 2) / N.

![](raid6.svg)

It seems that parity is done in two ways, XOR and Reed-Solomon codes.
To be honest, I don’t really understand Reed-Solomon codes.
However, they are used for a specific reason.
For example, in the case below, if the data of C1 and C2 is lost, XOR calculations alone cannot determine the values of C1 and C2.
Reed-Solomon codes are introduced to address this issue and help in recovering the lost values.

![](raid6_recovery.svg)

## My environment

Now that we understand the basic principles of RAID, let’s write about the environment for this time.

- HDD: 512 GB x 5
- Raspberry Pi 4B
  - OS: Ubuntu 23.04

For the RAID level, I will go with RAID 5.
It is said that it is not recommended these days, but I believe it will be fine since the disk capacity is not that large.

## RAID Configuration

I will use mdadm, which seems to be a standard for configuring RAID on Linux.

First, the state of the devices in the initial state looked like this.

```sh
lsblk
```

```text
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
```

`/dev/sda` through `/dev/sde` are the target HDDs, so we create a RAID device with mdadm.

```sh
sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=5 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

```text
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
```

You should see something like this when you look at `/proc/mdstat`.

```sh
cat /proc/mdstat
```

```text
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid5 sde[5] sdd[3] sdc[2] sda[0] sdb[1]
      1953017856 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      bitmap: 1/4 pages [4KB], 65536KB chunk

unused devices: <none>
```

Format `/dev/md0` as ext4.

```sh
sudo mkfs.ext4 /dev/md0
```

```text
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
```

The mount position will be `/mnt/raid5`.

```sh
sudo mkdir /mnt/raid5
sudo mount /dev/md0 /mnt/raid5/
lsblk
```

```text
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
```

```sh
df -h
```

```text
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

After rebooting, sometimes the device name becomes `/dev/md127` instead of `/dev/md0`, so after a little research, it seems to be good to modify `/etc/mdadm/mdadm.conf` as follows.

```sh
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
```

```diff
+ ARRAY /dev/md/ubuntu:0 metadata=1.2 name=ubuntu:0 UUID=098f8892:ef715a43:dd38085d:46fb97c3
```

Update initramfs. (I don't know if it's necessary as the Boot partition is not on RAID, but just in case)

```sh
sudo update-initramfs -u
```

## Trouble Shooting: Auto-mount

Initially, I had added an entry for /mnt/raid5 in /etc/fstab, but there was a problem where it tried to mount before the external HDD was started and the device was recognized.

As a solution, I used systemd mount.
With systemd mount, you can set detailed execution timing, so I configured it to execute after /dev/md0 is recognized.

```sh
sudo vim /etc/systemd/system/mnt-raid5.mount
```

```ini
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
sudo systemctl enable mnt-raid5.mount
```
