---
title: "Japanese Input"
description: ""
lead: ""
date: 2021-11-29T12:40:03+09:00
lastmod: 2021-11-29T12:40:03+09:00
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
- Gnome

## Commands

- Case 1: fcitx + mozc

```sh
sudo pacman -S fcitx-mozc fcitx-im fcitx-configtool
```

- Case 2: fcitx5 + mozc

```sh
sudo pacman -S fcitx5-mozc fcitx5-im fcitx5-configtool
```

- Create `.pam_environment` in user home directory:

```diff
+ GTK_IM_MODULE DEFAULT=fcitx
+ QT_IM_MODULE  DEFAULT=fcitx
+ XMODIFIERS    DEFAULT=\@im=fcitx
+ SDL_IM_MODULE DEFAULT=fcitx
```

- If mozc does not work, try the following command:

```sh
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"
```
