---
title: "Creating Bootable USB with dd"
draft: false
weight: 80
---

# Creating Bootable USB with dd

## Commands

```sh
dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress && sync
```
