---
title: "Configurtions for BSPWM"
description: ""
lead: ""
date: 2021-11-29T12:44:10+09:00
lastmod: 2021-11-29T12:44:10+09:00
draft: false
images: []
menu: 
  docs:
    parent: "archlinux"
weight: 60
toc: true
---

## Commands

### Graphic driver

- Graphic card:

```sh
sudo pacman -S nvidia nvidia-utils nvidia-dkms
```

### BSPWM

- Display server, window manager and etc.:

```sh
sudo pacman -S xorg xorg-xinit bspwm picom dmenu sxhkd nitrogen arandr
```

- Terminal emulator and brawser:

```sh
sudo pacman -S alacritty firefox
```

- Create config files:

```sh
mkdir .config/bspwm
mkdir .config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc .config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc .config/sxhkd/
```

- Change terminal emulator:

```sh
vim /.config/sxhkd/sxhkdrc
```

```diff
super + Return
-     urxvt
+     alacritty
```

- xinitrc:

```sh
cp /etc/X11/xinit/xinitrc .xinitrc
vim .xinitrc
```

```diff
- twm &
- xclock -geometry 50x50-1+1 &
- xterm -geometry 80x50+494+51 &
- xterm -geometry 80x20+494+0 &
- exec xterm -geometry 80x66+0+0 -name login
+ setxkbmap jp &
+ picom -f &
+ exec bspwm
```

- picom:

```sh
sudo vim /etc/xdg/picom.conf
```

```diff
- vsync = true;
+ #vsync = true;
```

- Start window manager:

```sh
startx
```

### Customize

- Change resolution:

```sh
arandr  # choose resolution and save as a shell script
chmod +x .screenlayout/dislay.sh
vim .xinitrc
```

```diff
setkbmap ch &
+ $HOME/.screenlayout/display.sh
picom -f &
```

- Restart window manager after leave bspwm (super + alt + q):

```sh
startx
```

- Cursor:

```sh
vim .xinitrc
```

```diff
setkbmap ch &
$HOME/.screenlayout/display.sh
+ xsetroot -cursor_name left_ptr
picom -f &
```

- Nitrogen
  - Preferences > Add > Pictures > OK > Apply

```sh
vim .xinitrc
```

```diff
+ setkbmap ch &
+ $HOME/.screenlayout/display.sh
+ nitrogen --restore &
+ xsetroot -cursor_name left_ptr
+ picom -f &
```
