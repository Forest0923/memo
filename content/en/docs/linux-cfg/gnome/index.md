---
title: "Gnome Configurations"
draft: false
weight: 999
---

# Gnome Configurations

## Disable wayland

- Edit `/etc/gdm/custom.conf`:

```diff
- #WaylandEnable=false
+ WaylandEnable=false
+ DefaultSession=gnome-xorg.desktop
```

- Otherwise run `/usr/lib/gdm-disable-wayland` as root:

```sh
sudo /usr/lib/gdm-disable-wayland
```

- `WaylandEnable=false` will be written into `/run/gdm/custom.conf` and it overrides `/etc/gdm/custom.conf`.

## Turn off alert

```sh
dconf write /org/gnome/desktop/sound/event-sounds "false"
```
