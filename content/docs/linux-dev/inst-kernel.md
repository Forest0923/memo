---
title: "Install Kernel"
description: ""
lead: ""
date: 2021-11-29T12:33:46+09:00
lastmod: 2021-11-29T12:33:46+09:00
draft: false
images: []
menu: 
  docs:
    parent: "linux-dev"
weight: 10
toc: true
---

## System

- OS: Ubuntu 18.04 (64bit)
- Current kernel: 5.3.0-42-generic

## Compile

- Change directory to `/usr/src`.
- Get kernel source code with the following command (ver.5.4.1).

```sh
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.4.1.tar.gz
```

- Decompress with tar.

```sh
tar -xvf linux-5.4.1.tar.gz
```

- Change directory to `linux-5.4.1`.
- Before compiling you have to install some packages via apt. Run the following command.

```sh
sudo apt install flex bison libssl-dev libelf-dev
```

- Make .config with the following command.

```sh
make olddefconfig
```

- Compile with the following command. `4` indicate how many thread do you use.

```sh
make -j 4
```

## Install

- Install modules and kernel image with the following command.

```sh
make modules_install && make install
```

## Boot

- Setting bootloader (grub).

```sh
grub-mkconfig
```

- Reboot.

## Change kernel version

- You can choose kernel by selecting `Advanced options for Ubuntu`.
- You can also change default kernel by editing `/etc/default/grub`.

```text
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux x.x.x"
```
