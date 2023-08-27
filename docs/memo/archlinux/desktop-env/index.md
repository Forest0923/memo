---
title: "デスクトップ環境"
draft: false
weight: 50
---
デスクトップ環境をインストールするチュートリアルです．

## Install

### **Graphics Driver**

グラフィックドライバをインストールします．

{{< tabpane >}}
{{< tab header="Intel" lang="sh" >}}

sudo pacman -S xf86-video-intel

{{< /tab >}}
{{< tab header="Nvidia" lang="sh" >}}

sudo pacman -S nvidia nvidia-utils nvidia-dkms

{{< /tab >}}
{{< /tabpane >}}

### **Display Server**

ディスプレイサーバとして xorg をインストールします．ディスプレイサーバは Gnome などの GUI を用いた入出力を OS，ハードウェアに受け渡すソフトウェアです．

```sh
sudo pacman -S xorg
```

### **Display Manager**

ログインを GUI で行うためにディスプレイマネージャをインストールします．

{{< tabpane >}}
{{< tab header="lightdm" lang="sh" >}}

sudo pacman -S lightdm lightdm-gtk-greeter

{{< /tab >}}
{{< tab header="gdm" lang="sh" >}}

sudo pacman -S gdm

{{< /tab >}}
{{< /tabpane >}}

### **Desktop Environment**

{{< tabpane >}}
{{< tab header="xfce" lang="sh" >}}

sudo pacman -S xfce4 xfce4-goodies

{{< /tab >}}
{{< tab header="gnome" lang="sh" >}}

sudo pacman -S gnome gnome-tweaks

{{< /tab >}}
{{< tab header="budgie" lang="sh" >}}

sudo pacman -S budgie-desktop gnome

{{< /tab >}}
{{< /tabpane >}}

### **Systemd**

ディスプレイマネージャを自動で起動するように systemd を設定します．

{{< tabpane >}}
{{< tab header="lightdm" lang="sh" >}}

systemctl enable lightdm

{{< /tab >}}
{{< tab header="gdm" lang="sh" >}}

systemctl enable gdm

{{< /tab >}}
{{< /tabpane >}}
