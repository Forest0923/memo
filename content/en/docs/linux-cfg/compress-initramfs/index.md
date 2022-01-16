---
title: "Compress initramfs"
draft: false
weight: 999
---

# Compress initramfs

## Commands

```sh
sudo vim /etc/initramfs-tools/initramfs.conf
```

```diff
- MODULES=most
+ MODULES=dep
```

```diff
- COMPRESS=lz4
+ COMPRESS=xz
```

```sh
sudo apt install xz-utils
sudo update-initramfs -u -k all
```
