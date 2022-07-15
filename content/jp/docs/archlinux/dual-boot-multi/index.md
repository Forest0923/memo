---
title: "Dual Booting (multi-disk + Windows10 and Arch Linux)"
draft: false
weight: 30
---

# Dual Booting (multi-disk + Windows10 and Arch Linux)

## 環境

- Preinstalled OS: Windows 10 (64 bit Home)
- CPU: Intel
- GPU: Nvidia
- Storage:
  - `/dev/sda`: Windows sub
  - `/dev/sdb`: Windows main
  - `/dev/sdc`: Linux

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

最初にWindows の EFI パーティションを見つけます．下記のコマンドで EFI パーティションとして割り当てられたデバイスを探します．

```sh
fdisk -l
```

ここでは，`/dev/sdb1` が EFI パーティションとします．サイズが 100MB と若干小さめですが，とりあえず問題はないです．`/dev/sdc` を Linux Filesystem として使用します．

```text
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 931.5G  0 disk
└─sda1   8:1    0 931.5G  0 part /windows_d
sdb      8:16   0 238.5G  0 disk
├─sdb1   8:17   0   100M  0 part /boot/efi
├─sdb2   8:18   0    16M  0 part
├─sdb3   8:19   0 237.4G  0 part /windows_c
└─sdb4   8:20   0   990M  0 part
sdc      8:32   0 476.9G  0 disk
└─sdc1   8:33   0 476.9G  0 part /
sr0     11:0    1  1024M  0 rom
```

```sh
fdisk /dev/sdc
```

BTRFS でフォーマットします．

```sh
mkfs.btrfs /dev/sdc1
```

BTRFS のサブボリュームを作成して，マウントします．

```sh
mount /dev/sdc1 /mnt
btrfs su cr /mnt/@
umount /mnt
mount -o compress=lzo,subvol=@ /dev/sdc1 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sdb2 /mnt/boot/efi

mkdir /mnt/windows_c
mount /dev/sdb4 /mnt/windows_c

mkdir /mnt/windows_d
mount /dev/sdb1 /mnt/windows_d
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
pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools \
wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers git \
reflector bluez bluez-utils pulseaudio-bluetooth ntfs-3g xdg-utils xdg-user-dirs
```

### **ブートローダ**

Grub をインストールして設定ファイルを生成します．

```sh
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
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

### **グラフィックドライバ**

{{< tabpane "gpu-driver" >}}
{{< tab "Nvidia" >}}

```sh
sudo pacman -S nvidia nvidia-utils nvidia-dkms
```

{{< /tab >}}
{{< /tabpane >}}

### **フォント**

Windows のパーティションからフォントをコピーします．

```sh
sudo mkdir /usr/share/fonts/WindowsFonts
sudo cp /windows/Windows/Fonts/* /usr/share/fonts/WindowsFonts/
sudo chmod 644 /usr/share/fonts/WindowsFonts/*
fc-cache -f
```

### **デスクトップ環境のインストール**

[デスクトップ環境](../desktop-env/)
