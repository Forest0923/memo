---
title: "Custom Kernel"
draft: true
weight: 999
---

# Custom Kernel

## Download Source Code

```sh
curl -O  https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.17.tar.gz
```

```sh
tar xf linux-5.17.tar.gz
```

## Install Neccesary Packages

```sh
sudo pacman -S bc
```

## Build

### Generate .config file

```sh
make olddefconfig && make localmodconfig
```

### Compile & Install

```sh
make -j5 && make modules_install
```

```sh
cp arch/x86/boot/bzImage /boot/vmlinuz-5.17.0
mkinitcpio -k 5.17.0 -g /boot/initramfs-linux-5.17.0.img
cp System.map /boot/System.map-5.17.0
grub-mkconfig -o /boot/grub/grub.cfg
```

```sh
cp /etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux-5.17.0.preset
mkinitcpio -p linux-5.17.0
cp System.map /boot/System.map-5.17.0
grub-mkconfig -o /boot/grub/grub.cfg
```
