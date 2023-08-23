---
title: "Arch Build System"
draft: false
weight: 90
---
ABS はソースコードからパッケージのビルドを自動化するシステムです．PKGBUILD に記述された情報をもとに makepkg でパッケージをビルドし，pacman を用いてインストールを行います．

## Install

ABS を用いるために asp をインストールします．

```sh
sudo pacman -S asp
```

## Usage (kernel build)

使い方の例としてカーネルのビルドを行う方法を紹介します．作業用ディレクトリとして build を作成します．

```sh
mkdir build
cd build
```

Linux kernel の PKGBUILD をダウンロードします．

```sh
asp update linux
asp export linux
```

PKGBUILD を修正してパッケージの名前変更したり，ドキュメントを生成させないように修正します．

```sh
cd linux
vim PKGBUILD
```

```diff
3c3
< pkgbase=linux
---
> pkgbase=linux-custom
64d63
<   make htmldocs
191c190
< pkgname=("$pkgbase" "$pkgbase-headers" "$pkgbase-docs")
---
> pkgname=("$pkgbase" "$pkgbase-headers")
```

下記のコマンドでソースコードをダウンロードします．

```sh
makepkg -so
```

```text
.
├── archlinux-linux
│   ├── branches
│   ├── config
│   ├── description
│   ├── FETCH_HEAD
│   ├── HEAD
│   ├── hooks
│   ├── info
│   ├── objects
│   ├── packed-refs
│   └── refs
├── config
├── PKGBUILD
├── sphinx-workaround.patch
└── src
    ├── archlinux-linux <- Kernel source code here
    ├── config -> /home/mori/kernelbuild/linux/config
    └── sphinx-workaround.patch -> /home/mori/kernelbuild/linux/sphinx-workaround.patch
```

makepkg で下記のようにビルドして，pacman でインストールします．

```sh
makepkg -se     # Additionally 'f' option needed when overwrite pkg
sudo pacman -U linux-custom-[version].arch1-1-x86_64.pkg.tar.zst linux-custom-headers-[version].arch1-1-x86_64.pkg.tar.zst
```

> [Kernel/Arch Build System](https://wiki.archlinux.org/index.php/Kernel/Arch_Build_System)
