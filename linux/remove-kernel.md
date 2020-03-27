---
title: Remove compiled kernel
date: 2020-03-28
---
## How to remove kernel
- Remove the following entries.

```
/boot/vmlinuz[version]
/boot/initrd[version]
/boot/System-map[version]
/boot/config-[version]
/lib/modules/[version]/*
/var/lib/initramfs_tools/[version]
```

- Update the grub configuration.

```
update-grub
```

