---
title: "Arch Linux のインストール（BTRFS + Timeshift）"
draft: false
weight: 10
---

# Arch Linux のインストール（BTRFS + Timeshift）

Arch Linux のインストールマニュアルです．ファイルシステムとして BTRFS を選択し，Timeshift でスナップショットを保存する方法を紹介します．

## 環境

- Intel CPU
- UEFI Boot

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

gdisk を用いてパーティションを変更します．ここでは `/dev/vda` にインストールするものとします．

```sh
gdisk /dev/vda
```

1つ目のパーティションは EFI パーティションで 200MB 程度割り当てます．残りの領域を Linux Filesystem として割り当てます．メモリが十分にあると仮定して swap 領域は割り当てない方針で進めます．

```text
/dev/vda1: EFI system (200M)
/dev/vda2: Linux filesystem
```

EFI パーティションは fat でフォーマットします．

```sh
mkfs.fat -F32 /dev/vda1
```

Linux Filesystem は BTRFS でフォーマットします．

```sh
mkfs.btrfs /dev/vda2
```

BTRFS のサブボリュームを作成して，マウントします．

```sh
mount /dev/vda2 /mnt
btrfs su cr /mnt/@
umount /mnt
mount -o compress=lzo,subvol=@ /dev/vda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi
```

### **ベースのインストール**

Root ディレクトリとなる `/mnt` にパッケージをインストールします．

```sh
pacstrap /mnt base linux linux-firmware vim
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

### **追加のパッケージインストール**

ブートローダとして grub をインストールします．

```sh
pacman -S grub efibootmgr os-prober
```

ネットワークとワイヤレスデバイス用のソフトウェアをインストールします．

```sh
pacman -S networkmanager network-manager-applet wireless_tools wpa_supplicant dialog
```

MS-DOS ディスクにアクセスするためのツールをインストールします．

```sh
pacman -S mtools dosgstools
```

sudo や make，gcc などの基本的なアプリケーション（コマンド）をインストールします．

```sh
pacman -S base-devel
```

カーネルヘッダをインストールします．カーネルヘッダはカーネルモジュールをビルドするときに用いられるヘッダやスクリプトです．

```sh
pacman -S linux-headers
```

Bluetooth やオーディオ設定のツールをインストールします．

```sh
pacman -S bluez bluez-utils alsa-utils pulseaudio pulseaudio-bluetooth
```

デスクトップアプリケーションに関係するコマンドラインツールをインストールします．

```sh
pacman -S xdg-utils
```

home ディレクトリの `~/Desktop/`，`~/Music/` などを追加します．

```sh
pacman -S xdg-user-dirs
```

Git をインストールします．

```sh
pacman -S git
```

Timeshift で使用する cron をインストールします．cron はプログラムの定期実行を行うために使用されます．

```sh
pacman -S cron
```

mirrorlist を最適化するツールをインストールします．

```sh
pacman -S reflector
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

### **デスクトップ環境のインストール**

[デスクトップ環境](../desktop-env/)

### **Timeshift のインストール**

AUR ヘルパーを用いて timeshift をインストールします．

{{< tabpane "aurhelper" >}}
{{< tab "paru" >}}

```sh
git clone https://aur.archlinux.org/paru
cd paru
makepkg -si
```

{{< /tab >}}
{{< tab "yay" >}}

```sh
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
```

{{< /tab >}}
{{< /tabpane >}}

```sh
paru -S timeshift
```
