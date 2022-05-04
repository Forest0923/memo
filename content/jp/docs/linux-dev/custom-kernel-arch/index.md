---
title: "カーネルのインストール（Arch Linux 版）"
draft: false
weight: 11
---

# カーネルのインストール（Arch Linux 版）

Arch Linux で Linux カーネルの開発をしたときのメモです．基本的に研究では無難に Ubuntu を使用していますが，なんとなく Arch Linux にカスタムカーネルをインストールしようとしたら Ubuntu と同じ手順ではうまく行かないことがわかりました．Arch Build System を使う方法もありますが，ここでは PKGBUILD などは使わずにコンパイル，インストールする方法を紹介します．

## Download Source Code

ソースコードは下記のページからダウンロードしました．

<https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.17.tar.gz>

```sh
curl -O  https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.17.tar.gz
```

```sh
tar xf linux-5.17.tar.gz
```

## Install Neccesary Packages

コンパイルに必要なパッケージをインストールします．

```sh
sudo pacman -S bc cpio
```

## Build

### Generate .config file

.config ファイルは `make olddefconfig` などで作るのではなく Arch のデフォルト設定を使用します．

```sh
zcat /proc/config.gz > .config
```

### Compile & Install

カーネルイメージとモジュールのコンパイル，モジュールのインストールを行います．

```sh
make -j5 && make modules_install
```

作成したイメージを /boot に移動しておきます．

```sh
cp arch/x86/boot/bzImage /boot/vmlinuz-linux517
```

### initramfs

initramfs のイメージを作成するために設定ファイルを 2 つ作成します．1 つ目は /etc/mkinitcpio.conf をコピーして作ったファイルで，モジュールや圧縮形式の変更をします．

vfat を入れなかったときに FAT32 でフォーマットした EFI パーティション /boot のマウントが失敗したので vfat を追加しています．また，/boot のパーティションにあまり大きな領域を割り当てておらず，ディスク容量が足りなくなってしまったため圧縮率の高い xz で圧縮するように指定しています．

```sh
cp /etc/mkinitcpio.conf /etc/mkinitcpio-linux517.conf
```

```diff
- MODULES=()
+ MODULES=(vfat)
...
- #COMPRESSION="xz"
+ COMPRESSION="xz"
```

2 つ目の設定ファイルとして /etc/mkinitcpio.d/linux517.preset を作成します．これは mkinitcpio で initramfs を作成するときのテンプレートのようなもので，もともとある linux.preset を修正して使います．変更点はカーネルイメージのファイルパスや /etc/mkinitcpio-linux517.conf のファイルパスを変える点です．

```sh
cp /etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux517.preset
```

```text
# mkinitcpio preset file for the 'linux' package

ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux517"

PRESETS=('default')

default_config="/etc/mkinitcpio-linux517.conf"
default_image="/boot/initramfs-linux517.img"
#default_options=""

#fallback_config="/etc/mkinitcpio.conf"
fallback_image="/boot/initramfs-linux517-fallback.img"
fallback_options="-S autodetect"
```

initramfs を下記のコマンドで作成します．

```sh
mkinitcpio -p linux517
```

### GRUB Config & Reboot

最後に GRUB の設定を更新して再起動します．

```sh
grub-mkconfig -o /boot/grub/grub.cfg
reboot
```
