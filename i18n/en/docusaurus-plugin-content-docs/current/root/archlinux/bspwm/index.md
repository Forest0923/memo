---
title: "Installing BSPWM"
draft: false
weight: 60
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Install and customize a Tile-type window manager called BSPWM.

## Install and Configurations

### **Graphics Driver**

Install graphics driver.

<Tabs groupId="gpu-vendor" queryString>
  <TabItem value="intel" label="Intel">

  ```sh
sudo pacman -S xf86-video-intel
  ```

  </TabItem>
  <TabItem value="amd" label="AMD">

  ```sh
sudo pacman -S nvidia nvidia-utils nvidia-dkms
  ```

  </TabItem>
</Tabs>

### **BSPWM**

Install display server, bspwm and etc.

```sh
sudo pacman -S xorg xorg-xinit bspwm picom dmenu sxhkd nitrogen arandr
```

Install a terminal emulator and a browser.

```sh
sudo pacman -S alacritty firefox
```

Create a config file. sxhkd is a daemon for using hotkeys.

```sh
mkdir .config/bspwm
mkdir .config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc .config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc .config/sxhkd/
```

Configure `Super + Return` to run alacritty as a terminal emulator.

```sh
vim /.config/sxhkd/sxhkdrc
```

```diff
super + Return
-     urxvt
+     alacritty
```

Modify .xinitrc and set it to run bspwm, etc.

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

picom is used for graphic settings.

```sh
sudo vim /etc/xdg/picom.conf
```

```diff
- vsync = true;
+ #vsync = true;
```

Start window manager.

```sh
startx
```

## Customize

Change the resolution

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

Quit bspwm (`super + alt + q`) and restart the window manager.

```sh
startx
```

Change cursor theme.

```sh
vim .xinitrc
```

```diff
setkbmap ch &
$HOME/.screenlayout/display.sh
+ xsetroot -cursor_name left_ptr
picom -f &
```

Change the desktop background (Preferences > Add > Pictures > OK > Apply) and modify xinitrc to start nitrogen.

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
