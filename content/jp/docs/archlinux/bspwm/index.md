---
title: "BSPWM のインストール"
draft: false
weight: 60
---

# BSPWM のインストール

BSPWM という Tile 型のウィンドウマネージャをインストールして，カスタマイズを行います．

## Install and Configurations

### **Graphics Driver**

グラフィックドライバをインストールします．

{{< tabpane "gpu-driver" >}}
{{< tab "Intel" >}}

```sh
sudo pacman -S xf86-video-intel
sudo pacman -S nvidia nvidia-utils nvidia-dkms
```

{{< /tab >}}
{{< tab "Nvidia" >}}

```sh
sudo pacman -S xf86-video-intel
sudo pacman -S nvidia nvidia-utils nvidia-dkms
```

{{< /tab >}}
{{< /tabpane >}}

### **BSPWM**

ディスプレイサーバや bspwm などをインストールします．

```sh
sudo pacman -S xorg xorg-xinit bspwm picom dmenu sxhkd nitrogen arandr
```

アプリケーションの例としてターミナルエミュレータとブラウザをインストールします

```sh
sudo pacman -S alacritty firefox
```

config ファイルを作成します．sxhkd はホットキーを使用するための daemon です．

```sh
mkdir .config/bspwm
mkdir .config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc .config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc .config/sxhkd/
```

`Super + Return` でターミナルエミュレータとして alacritty を実行するように設定します．

```sh
vim /.config/sxhkd/sxhkdrc
```

```diff
super + Return
-     urxvt
+     alacritty
```

.xinitrc を修正して bspwm などを実行するように設定します．

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

picom はグラフィックの設定に使われます．

```sh
sudo vim /etc/xdg/picom.conf
```

```diff
- vsync = true;
+ #vsync = true;
```

ウィンドウマネージャをスタートします．

```sh
startx
```

## Customize

解像度を変更します．

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

bspwm を終了して（super + alt + q）ウィンドウマネージャを再起動します．

```sh
startx
```

カーソルを変更します．

```sh
vim .xinitrc
```

```diff
setkbmap ch &
$HOME/.screenlayout/display.sh
+ xsetroot -cursor_name left_ptr
picom -f &
```

デスクトップの背景を変更して（Preferences > Add > Pictures > OK > Apply）nitrogen を起動するように xinitrc を修正します．

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
