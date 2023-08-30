---
title: "Gnome の設定"
draft: false
weight: 999
---
## Wayland の無効化

`/etc/gdm/custom.conf` を下記のように編集します．

```diff
- #WaylandEnable=false
+ WaylandEnable=false
+ DefaultSession=gnome-xorg.desktop
```

`/usr/lib/gdm-disable-wayland` を root 権限で実行してもOKです．

```sh
sudo /usr/lib/gdm-disable-wayland
```

## アラート音を消す

```sh
dconf write /org/gnome/desktop/sound/event-sounds "false"
```

or

```sh
gsettings set org.gnome.desktop.sound event-sounds false
```
