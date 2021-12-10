---
title: "Arch Build System"
draft: false
weight: 90
---

# Arch Build System

## Install

- Install asp:

```sh
sudo pacman -S asp
```

## Usage (kernel build)

- Create directory for build kernel:

```sh
mkdir build
cd build
```

- Download PKGBUILD via asp:

```sh
asp update linux
asp export linux
```

- Edit PKGBUILD:

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

- Downloads source code:

```sh
makepkg -so
```

```text
user@host linux % tree -C -L 2
.
├── archlinux-linux
│   ├── branches
│   ├── config
│   ├── description
│   ├── FETCH_HEAD
│   ├── HEAD
│   ├── hooks
│   ├── info
│   ├── objects
│   ├── packed-refs
│   └── refs
├── config
├── PKGBUILD
├── sphinx-workaround.patch
└── src
    ├── archlinux-linux <- Kernel source code here
    ├── config -> /home/mori/kernelbuild/linux/config
    └── sphinx-workaround.patch -> /home/mori/kernelbuild/linux/sphinx-workaround.patch
```

- Build and install custom kernel:

```sh
makepkg -se     # Additionally 'f' option needed when overwrite pkg
sudo pacman -U linux-custom-[version].arch1-1-x86_64.pkg.tar.zst linux-custom-headers-[version].arch1-1-x86_64.pkg.tar.zst
```

> [Kernel/Arch Build System](https://wiki.archlinux.org/index.php/Kernel/Arch_Build_System)
