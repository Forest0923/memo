---
title: "Gnome Configurations"
draft: false
weight: 999
---
## Disable wayland

Edit `/etc/gdm/custom.conf` as follows.

```diff
- #WaylandEnable=false
+ WaylandEnable=false
+ DefaultSession=gnome-xorg.desktop
```

Otherwise run `/usr/lib/gdm-disable-wayland` as root.

```sh
sudo /usr/lib/gdm-disable-wayland
```

## Turn off alert

```sh
dconf write /org/gnome/desktop/sound/event-sounds "false"
```
