---
title: "Remove Kernel"
draft: false
weight: 20
---
If the installed kernel no longer in use, you may want to remove it. This is introduction to remove kernel.

## How to remove kernel

To remove the kernel, you have to remove the following entries.

```text
/boot/vmlinuz-[version]
/boot/initrd.img-[version]
/boot/System.map-[version]
/boot/config-[version]
/lib/modules/[version]/*
/var/lib/initramfs_tools/[version]
```

```sh
rm /boot/vmlinuz-[version]
rm /boot/initrd.img-[version]
rm /boot/System.map-[version]
rm /boot/config-[version]
rm -rf /lib/modules/[version]/*
rm /var/lib/initramfs_tools/[version]
```

Then don't forget to update the grub configuration.

```sh
grub-mkconfig -o /boot/grub/grub.cfg
```

or

```sh
update-grub
```

## References

- How can I remove compiled kernel
  - https://askubuntu.com/questions/594443/how-can-i-remove-compiled-kernel
- Kernel/Removal
  - https://wiki.gentoo.org/wiki/Kernel/Removal
