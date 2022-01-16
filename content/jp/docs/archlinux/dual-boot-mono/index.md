---
title: "Dual Booting (mono disk + Windows10 and Arch Linux)"
draft: false
weight: 30
---

# Dual Booting (mono disk + Windows10 and Arch Linux)

## 環境

- Preinstalled OS: Windows 10 (64 bit Home)
- CPU: Intel
- Storage: `/dev/sda`

## Windows 10 での準備

最初に Windows 10 をインストールします．Disk Management を起動して Linux をインストールするための空き領域を作成します．空きパーティション作成前後のレイアウトは次のようになります．

- Before:
![disk-layout-before](dual-boot-disk-before.png)
- After:
![disk-layout-after](dual-boot-disk-after.png)

Arch Linux のブータブル USB でブートしてインストールします．

## インストール

### **キーマップの変更**

インストールに使うキーボードに合わせてキーマップを変更します．日本語キーボードの場合は jp106 です．

```sh
loadkeys jp106
```

### **時間設定**

NTP（Network Time Protocol）を使用するために次のコマンドを実行します．

```sh
timedatectl set-ntp true
```

### **ミラーリストの最適化**

インストール時にアクセスが速いミラーサーバにアクセスするために reflector を用いてミラーリストを最適化します．

```sh
pacman -Syy
pacman -S reflector # `python` might be required
reflector -c Japan --sort rate -a 6 --save /etc/pacman.d/mirrorlist
```

reflector のオプションの意味は次のようになっています．

|Options|Description|
|-|-|
|`-c Japan`|日本のミラーサーバのみに制限する|
|`--sort rate`|ダウンロード速度でソートする|
|`-a 6`|6時間以内に同期したサーバに制限する|
|`--save /etc/pacman.d/mirrorlist`|ミラーリストを指定したパスに保存する|

### **ディスクパーティショニングとフォーマット**

`/dev/sda` 内のパーティションが次のようになっていると仮定して，話を進めます．

```text
sda
├─sda1 <-- EFI Partition
├─sda2
├─sda3
├─sda4
└─sda5 <-- Empty Partition for Linux Filesystem
```

まずは作成した空のパーティションを Linux Filesystem として使用するようにパーティションテーブルを更新します．

```sh
cfdisk /dev/sda
```

Linux filesystem のパーティションを BTRFS でフォーマットし，サブボリュームを作成してマウントします．

```sh
mkfs.btrfs /dev/sda5
mount /dev/sda5 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log
umount /mnt
mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/sda5 /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=lzo,space_cache=v2,subvol=@home /dev/sda5 /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots /dev/sda5 /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,subvol=@var_log /dev/sda5 /mnt/var/log
mount /dev/sda5 /mnt/boot
```

### **ベースのインストール**

Root ディレクトリとなる `/mnt` にパッケージをインストールします．

```sh
pacstrap /mnt base linux linux-firmware vim intel-ucode
```

### **fstab**

fstab ファイルを生成します．fstab ファイルはどのデバイスをマウントするかという情報を保持するファイルです．

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### **Root ディレクトリの変更**

chroot で root ディレクトリを `/mnt` に変更します．

```sh
arch-chroot /mnt
```

### **ローカライズ**

`/etc/localtime` にシンボリックリンクを作成してタイムゾーンを変更します．

```sh
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

ハードウェアクロックを現在のシステムクロックに合わせます．システムクロックは OS が管理する時計のことで，ハードウェアクロックはマザーボード（ハードウェア）が管理する時計のことです．OS が再起動されたときは，メモリに展開されたシステムクロックが失われるのでハードウェアクロックから時刻を取得します．

```sh
hwclock --systohc
```

locale を設定するためにまずは locale を生成します．`/etc/locale.gen` の使用するエントリをアンコメントして `locale-gen` を実行します．

```sh
vim /etc/locale.gen
```

```diff
- # en_US.UTF-8 UTF-8
+ en_US.UTF-8 UTF-8
```

```sh
locale-gen
```

システムの locale を設定するために次のコマンドを実行します．

```sh
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf
```

### **ホスト名**

ホスト名を `/etc/hostname` に登録します．

```sh
vim /etc/hostname
```

```diff
+ arch
```

`/etc/hosts` を編集してホスト名に対応する IP アドレスを設定します．

```sh
vim /etc/hosts
```

```diff
+ 127.0.0.1   localhost
+ ::1         localhost
+ 127.0.1.1   arch.localdomain    arch
```

### **Root のパスワード**

Root ユーザのパスワードを設定します．

```sh
passwd
```

### **追加パッケージのインストール**

```sh
pacman -S grub efibootmgr networkmanager network-manager-applet \
 dialog os-prober mtools dosfstools base-devel linux-headers snapper \
reflector cron git xdg-utils xdg-user-dirs ntfs-3g
```

### mkinitcpio の設定

設定を変更し，mkinitcpio で変更を反映します．

```sh
vim /etc/mkinitcpio.conf
```

```diff
- MODULES=()
+ MODULES=(btrfs)
```

```sh
mkinitcpio -p linux
```

### **ブートローダ**

Grub をインストールして設定ファイルを生成します．

```sh
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### **Systemd**

NetworkManager を有効化．

```sh
systemctl enable NetworkManager
```

Bluetooth を有効化．

```sh
systemctl enable bluetooth
```

reflector の有効化．実行オプションは `/etc/xdg/reflector/reflector.conf` に記述します．

```sh
systemctl enable reflector.service  # update mirrorlist every boot
```

```sh
systemctl enable reflector.timer    # update mirrorlist weekly
```

### **ユーザの追加**

useradd で追加してパスワードを設定します．

```sh
useradd -mG wheel mori
passwd mori
```

ユーザに特権を追加します．

```sh
EDITOR=vim visudo
```

```diff
- # %wheel ALL=(ALL) ALL
+ %wheel ALL=(ALL) ALL
```

### **Reboot**

```sh
exit
umount -a
reboot
```

## Trouble shooting

- Boot entry of windows disappears from grub boot loader
  - Add `GRUB_DISABLE_OS_PROBER=false` to `/etc/default/grub` and recreate grub.cfg
  - The problem is deactivated os-prober. os-prober automatically finds operating systems and adds their boot entry, but sometimes it is deactivated. The option reactivate os-prober.
