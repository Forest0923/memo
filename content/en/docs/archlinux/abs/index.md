---
title: "Arch Build System"
draft: false
weight: 90
---
ABS is a system that automates the building of packages from source code; it uses makepkg to build packages based on information in PKGBUILD, and pacman to install them.

## Install

Install asp to use ABS.

```sh
sudo pacman -S asp
```

## Usage (kernel build)

The following is an example of how to build a kernel. Create `build/` as a working directory.

```sh
mkdir build
cd build
```

Download the PKGBUILD for the Linux kernel.

```sh
asp update linux
asp export linux
```

Modify PKGBUILD to rename the package and prevent it from generating documentation.

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

Use the following command to download the source code.

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

Build kernel package with makepkg as shown below, and install it with pacman.

```sh
makepkg -se     # Additionally 'f' option needed when overwrite pkg
sudo pacman -U linux-custom-[version].arch1-1-x86_64.pkg.tar.zst linux-custom-headers-[version].arch1-1-x86_64.pkg.tar.zst
```

> [Kernel/Arch Build System](https://wiki.archlinux.org/index.php/Kernel/Arch_Build_System)
