---
title: "Keymaps"
draft: false
weight: 999
---

# Keymaps

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
