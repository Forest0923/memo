---
title: "デスクトップ環境"
draft: false
weight: 50
---

# デスクトップ環境

デスクトップ環境をインストールするチュートリアルです．

## Install

### **Graphics Driver**

グラフィックドライバをインストールします．

{{< tabs "gpu-driver" >}}
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
{{< /tabs >}}

### **Display Server**

ディスプレイサーバとして xorg をインストールします．ディスプレイサーバは Gnome などの GUI を用いた入出力を OS，ハードウェアに受け渡すソフトウェアです．

```sh
sudo pacman -S xorg
```

### **Display Manager**

ログインを GUI で行うためにディスプレイマネージャをインストールします．

{{< tabs "display-manager" >}}
{{< tab "lightdm" >}}

```sh
sudo pacman -S lightdm lightdm-gtk-greeter
```

{{< /tab >}}
{{< tab "gdm" >}}

```sh
sudo pacman -S gdm
```

{{< /tab >}}
{{< /tabs >}}

### **Desktop Environment**

{{< tabs "desktop-environment" >}}
{{< tab "xfce" >}}

```sh
sudo pacman -S xfce4 xfce4-goodies
```

{{< /tab >}}
{{< tab "gnome" >}}

```sh
sudo pacman -S gnome gnome-tweaks
```

{{< /tab >}}
{{< tab "budgie" >}}

```sh
sudo pacman -S budgie-desktop gnome
```

{{< /tab >}}
{{< /tabs >}}

### **Systemd**

ディスプレイマネージャを自動で起動するように systemd を設定します．

{{< tabs "systemd" >}}
{{< tab "lightdm" >}}

```sh
systemctl enable lightdm
```

{{< /tab >}}
{{< tab "gdm" >}}

```sh
systemctl enable gdm
```

{{< /tab >}}
{{< /tabs >}}
