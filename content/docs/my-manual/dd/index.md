---
title: "Creating Bootable USB with dd"
description: ""
lead: ""
date: 2021-11-29T12:39:06+09:00
lastmod: 2021-11-29T12:39:06+09:00
draft: false
images: []
menu: 
  docs:
    parent: "my-manual"
weight: 80
toc: true
---

## Commands

```sh
dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress && sync
```
