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
Arch wiki などを見たほうが詳しく書いてあるしわかりやすいですが、勉強の意味でも一応書いておきます。

### RAID 0

RAID 0 は冗長化を全く施していない RAID です。
データを分散して保存しており、帯域幅が大きくなるのでうまく行けば高速に読み書きができます。
（ちょうどアクセスしたいデータが一つのストレージに保存されていた場合などは高速なアクセスは期待できないでしょうが）

冗長化による信頼性の向上は行われていないので使用用途はいまいちよくわからなかったのですが、Arch wiki を読んでみるとスワップパーティションなどの「データが消失する可能性を差し引いても速度を上げる価値がある場合」に使えるとのことでした。
大容量なメモリが使える最近ではわざわざスワップ領域を作らないことも多いと思うので本当に使いみちがわからないです。

![](raid0.svg)

### RAID 1

RAID 1 は複数のディスクに全く同じデータを書き込むことで信頼性を向上させたRAID です。
冗長化はされていますが、ストレージの使用効率が悪いという問題があります。
基本的に RAID 1 を組む場合は2つのストレージを使いますが、この場合使用できるのは全体の 1/2 になってしまいます。

![](raid1.svg)

どちらかのストレージが生きていれば問題ないので RAID 0 に比べて圧倒的に安心ではあります。

![](raid1_recovery.svg)

### RAID 1+0 (RAID 10)

RAID 10 では RAID 1 で冗長化をしながら RAID 0 と組み合わせてパフォーマンスの向上を目指しています。
冗長化の仕方は RAID 1 と同じなのでストレージの使用効率は悪いままです。

![](raid10.svg)

障害耐性については RAID 1 よりも向上していて、異なる RAID 1 のグループであれば同時に二つ故障しても問題ありません。
当然ですが、同じ RAID 1 のグループで同時に二つが故障したら終わりです。

![](raid10_recovery.svg)

### RAID 5

RAID 5 はデータを分散して保存し、それに加えてパリティブロックも作成することで冗長化を行っています。
パリティの容量は最大でストレージ一つ分なので N 個のストレージで RAID 5 を組むと使える容量は (N - 1) / N になります。

![](raid5.svg)

パリティは XOR で計算されるので、ストレージが一つ故障しただけであれば復元ができます。
しかし、同時に二つ以上故障すると復元はできないため、ストレージの信頼性や組み合わせる数、サイズによってはあまり推奨されないとのこと。
ディスクが一つ故障した場合には新しいディスクを追加して復元を行いますが、復元時に大量に読み書きを行うのでそのときに障害が発生する可能性があるためです。
これまた Arch wiki 情報ですが、最近のストレージ界隈では非推奨だとか。

![](raid5_recovery.svg)

### RAID 6

RAID 6 は RAID 5 のパリティをさらに増やして二つまで同時にストレージが故障しても復元できるように設計された RAID です。
ストレージは最小で4つ必要で容量の使用効率は (N - 2) / N になります。

![](raid6.svg)

パリティは XOR と Reed-Solomon 符号の二種類で行っているそうです。
Reed-Solomon 符号については正直良くわかっていないですが、例えば下の例で C1 と C2 のデータが失われたときに XOR の計算結果だけでは C1 と C2 の値を特定できないのでそれを解消するために導入しています。

![](raid6_recovery.svg)

## 使うもの

さて、基本的な RAID の原理がわかったところで今回の環境について書いておきます。

- HDD: 512 GB x 5
- Raspberry Pi 4B
  - OS: Ubuntu 23.04

RAID レベルですが、今回は RAID 5 にします。
最近ではあまり推奨されないという話でしたが、ディスク容量もそこまで大きくないので大丈夫だと信じて使います。
ちなみにソフトウェア RAID です。

## RAID 設定

Linux で RAID を組む上では定番らしい mdadm を使って RAID の設定を行います。

まず、初期状態のデバイスを確認するとこんな感じでした。

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

`/dev/sda` から `/dev/sde` までが対象の HDD なので mdadm で RAID のデバイスを作成します。

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

`/proc/mdstat` を見るとこんな内容になっているはずです。

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

`/dev/md0` を ext4 でフォーマットします。

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

マウントポジションは `/mnt/raid5` とします。

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

再起動したときにデバイス名が `/dev/md0` でなく `/dev/md127` になることがあったので少し調べてみると以下のように /etc/mdadm/mdadm.conf を修正すると良いようです。

```sh
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
```

```diff
+ ARRAY /dev/md/ubuntu:0 metadata=1.2 name=ubuntu:0 UUID=098f8892:ef715a43:dd38085d:46fb97c3
```

initramfs を更新します。（Boot パーティションはRAID 上にはないですし必要なのかわかりませんが一応）

```sh
sudo update-initramfs -u
```

## Trouble Shooting: 自動マウント

最初は /etc/fstab に /mnt/raid5 のエントリを追加していたのですが、外付け HDD が起動されてデバイスが認識される前にマウントをしようとしてしまう問題がありました。

解決策として systemd の mount を使いました。
systemd mount では実行タイミングの詳細な設定ができるので /dev/md0 が認識されてから事項するように設定します。

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
