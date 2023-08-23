---
title: "Keymaps"
draft: false
weight: 999
---
This is a note on how to assign other keys to keys such as Caps lock.

## Create Custom Key Mapping

Create a directory to store the keymap.

```sh
sudo mkdir -p /usr/local/share/kbd/keymaps
```

Use dumpkeys to get the original keymaps and save it in my-keymaps.map.

```sh
sudo dumpkeys | sudo tee /usr/local/share/kbd/keymaps/my-keymaps.map
```

Modify `/usr/local/share/kbd/keymaps/my-keymaps.map` to change Caps lock to control.

```sh
sudo vim /usr/local/share/kbd/keymaps/my-keymaps.map
```

```diff
- keycode  58 = Caps_Lock
+ keycode  58 = Control
```

Create `/etc/vconsole.conf` and load `my-keymaps.map`.

```diff
+ KEYMAP=/usr/local/share/kbd/keymaps/my-keymaps.map
```
