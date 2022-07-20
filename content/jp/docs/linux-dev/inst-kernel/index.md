---
title: "カーネルのインストール"
draft: false
weight: 10
---
初心者用のカーネルインストールのチュートリアルです．

## 環境

- OS: Ubuntu 18.04 (64bit)
- Current kernel: 5.3.0-42-generic
- Installed kernel: 5.4.1

## チュートリアル

### カーネルコードの準備

ここでは`/usr/src`を作業ディレクトリとしています．まず`/usr/src`に移動してソースコードをダウンロードします．

```sh
cd /usr/src
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.4.1.tar.gz
```

圧縮されているのでtarコマンドで解凍します．

```sh
tar -xvf linux-5.4.1.tar.gz
```

### コンパイル

コンパイルにあたっていくつかのパッケージをインストールする必要があります．

```sh
sudo apt install flex bison libssl-dev libelf-dev
```

`linux-5.4.1` に移動して`.config`ファイルを作成します．

```sh
make olddefconfig
make localmodconfig
```

最後にmake でコンパイルを行います．`-j4`はスレッド数でマシンのCPUによってスレッド数を増やすと高速にコンパイルを行うことができます．

```sh
make -j4
```

### インストール

コンパイルして生成されたイメージをインストールします．

```sh
make modules_install && make install
```

### ブートローダの設定

GRUBの設定を更新します．Ubuntuの場合は`update-grub`でもできるらしいですが，やっていることは下のコマンドと同じです．

```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

再起動してGRUBのメニューからインストールしたバージョンのカーネルを選択します．

### オプション：デフォルトのカーネル変更

デフォルトカーネルを変更して自動的に任意のカーネルを起動したい場合は`/etc/default/grub` を以下のように修正します．

```text
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux x.x.x"
```
