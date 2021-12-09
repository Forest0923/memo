---
title: "Compress initramfs"
description: ""
lead: ""
date: 2021-11-29T12:40:47+09:00
lastmod: 2021-11-29T12:40:47+09:00
draft: false
images: []
menu: 
  docs:
    parent: "linux-cfg"
weight: 999
toc: true
---

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
