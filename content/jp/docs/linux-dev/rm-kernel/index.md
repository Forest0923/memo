---
title: "カーネルの削除"
draft: false
weight: 20
---

# カーネルの削除

Linuxカーネルの開発で必要なくなったカーネルを削除するためのチュートリアルです．

## 方法

カーネルを削除する場合は，以下のファイルやディレクトリを削除すればOKです．

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

削除したあとはブートローダの設定を更新しましょう．

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
