---
title: "デスクトップ環境"
draft: false
weight: 50
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

デスクトップ環境をインストールするチュートリアルです．

## Install

### **Graphics Driver**

グラフィックドライバをインストールします．

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

### **Display Server**

ディスプレイサーバとして xorg をインストールします．ディスプレイサーバは Gnome などの GUI を用いた入出力を OS，ハードウェアに受け渡すソフトウェアです．

```sh
sudo pacman -S xorg
```

### **Display Manager**

ログインを GUI で行うためにディスプレイマネージャをインストールします．

<Tabs groupId="gui" queryString>
  <TabItem value="lightdm" label="lightdm">

  ```sh
sudo pacman -S lightdm lightdm-gtk-greeter
  ```

  </TabItem>
  <TabItem value="gdm" label="gdm">

  ```sh
sudo pacman -S gdm
  ```

  </TabItem>
</Tabs>

### **Desktop Environment**

<Tabs groupId="gui" queryString>
  <TabItem value="xfce" label="xfce">

  ```sh
sudo pacman -S xfce4 xfce4-goodies
  ```

  </TabItem>
  <TabItem value="gnome" label="gnome">

  ```sh
sudo pacman -S gnome gnome-tweaks
  ```

  </TabItem>
  <TabItem value="budgie" label="budgie">

  ```sh
sudo pacman -S budgie-desktop gnome
  ```

  </TabItem>
</Tabs>

### **Systemd**

ディスプレイマネージャを自動で起動するように systemd を設定します．

<Tabs groupId="gui" queryString>
  <TabItem value="lightdm" label="lightdm">

  ```sh
systemctl enable lightdm
  ```

  </TabItem>
  <TabItem value="gdm" label="gdm">

  ```sh
systemctl enable gdm
  ```

  </TabItem>
</Tabs>
