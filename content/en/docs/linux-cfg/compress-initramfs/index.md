---
title: "Compress initramfs"
draft: false
weight: 999
---

# Compress initramfs

In some cases, the `/boot` partition is too small for the initramfs to fit. This makes it impossible to install multiple kernels, so the solution is to change the compression method.

Edit `/etc/initramfs-tools/initramfs.conf` and change the compression method to xz (xz has a higher compression ratio, but slows down the decompression speed).

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

Install xz-utils and update initramfs.

{{< tabs "update-initramfs" >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt install xz-utils
sudo update-initramfs -u -k all
```

{{< /tab >}}
{{< /tabs >}}
