---
title: "Japanese Input"
draft: false
weight: 999
---
This is a memo on how to set up Japanese input using Fcitx (Flexible Input Method Framework) and Mozc.

## Install

{{< tabpane "japanese-input" >}}
{{< tab "fcitx5" >}}

fcitx5 is a successor to fcitx.

```sh
sudo pacman -S fcitx5-mozc fcitx5-im fcitx5-configtool
```

{{< /tab >}}
{{< tab "fcitx" >}}

```sh
sudo pacman -S fcitx-mozc fcitx-im fcitx-configtool
```

{{< /tab >}}
{{< /tabpane >}}

## Configurations

Add Mozc to the input method in fcitx configuration tool. Then, create `~/.pam_environment`.

```sh
vim ~/.pam_environment
```

```diff
+ GTK_IM_MODULE DEFAULT=fcitx
+ QT_IM_MODULE  DEFAULT=fcitx
+ XMODIFIERS    DEFAULT=\@im=fcitx
+ SDL_IM_MODULE DEFAULT=fcitx
```

If this does not work, execute the following command.

```sh
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"
```
