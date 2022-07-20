---
title: "Install Kernel"
draft: false
weight: 10
---
This is a step-by-step guide on how to install kernel for those who are new to kernel development.

## System Setup

- OS: Ubuntu 18.04 (64bit)
- Current kernel: 5.3.0-42-generic
- Installed kernel: 5.4.1

## Step-by-step Instructions

### Preparing Source Code

In this article, I assume that `/usr/src` is a working directory. First of all, change directory to `/usr/src` and download kernel source code with the following command.

```sh
cd /usr/src
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.4.1.tar.gz
```

Decompress the code with `tar` command.

```sh
tar -xvf linux-5.4.1.tar.gz
```

### Compiling

Before compiling you have to install some packages.

```sh
sudo apt install flex bison libssl-dev libelf-dev
```

Then change directory to `linux-5.4.1` and create `.config` file with the following command.

```sh
make olddefconfig
make localmodconfig
```

Finally, compile with the following command. `4` indicate how many thread do you use.

```sh
make -j 4
```

### Installing

Install modules and kernel image with the following command.

```sh
make modules_install && make install
```

### Updating Config for Bootloader

Update grub configuration with the following command.

```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

- Reboot.

### Option: Change Default Kernel Version

If you need to change default kernel, you can select kernel by editting `/etc/default/grub` as follows.

```text
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux x.x.x"
```
