---
title: "Remove Kernel"
description: ""
lead: ""
date: 2021-11-29T12:35:14+09:00
lastmod: 2021-11-29T12:35:14+09:00
draft: false
images: []
menu: 
  docs:
    parent: "linux-dev"
weight: 20
toc: true
---

## How to remove kernel

- Remove the following entries.

```text
/boot/vmlinuz-[version]
/boot/initrd.img-[version]
/boot/System.map-[version]
/boot/config-[version]
/lib/modules/[version]/*
/var/lib/initramfs_tools/[version]
```

- Update the grub configuration.

```sh
update-grub
```

## Reference

- How can I remove compiled kernel
  - https://askubuntu.com/questions/594443/how-can-i-remove-compiled-kernel
- Kernel/Removal
  - https://wiki.gentoo.org/wiki/Kernel/Removal
