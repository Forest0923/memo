---
title: "Keymaps"
description: ""
lead: ""
date: 2021-11-29T12:40:20+09:00
lastmod: 2021-11-29T12:40:20+09:00
draft: false
images: []
menu: 
  docs:
    parent: "linux-cfg"
weight: 999
toc: true
---

## System

- Arch Linux

## Create custom key mapping

- Get original key maps:

```sh
sudo mkdir -p /usr/local/share/kbd/keymaps
sudo dumpkeys | sudo tee /usr/local/share/kbd/keymaps/my-keymaps.map
```

- Change caps-lock into ctrl:

```diff
- keycode  58 = Caps_Lock
+ keycode  58 = Control
```

- Create /etc/vconsole.conf:

```diff
+ KEYMAP=/usr/local/share/kbd/keymaps/my-keymaps.map
```
