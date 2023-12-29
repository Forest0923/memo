---
title: "Desktop Environment"
draft: false
weight: 50
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

This is a tutorial for installing desktop environment.

## Install

### Graphics Driver

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

### Display Server

Install xorg as a display server. A display server is software that passes input and output using a GUI such as Gnome to the OS and hardware.

```sh
sudo pacman -S xorg
```

### Display Manager

Install the Display Manager to use the GUI for login.

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
  <TabItem value="sddm" label="sddm">

  ```sh
sudo pacman -S sddm
  ```

  </TabItem>
</Tabs>

### Desktop Environment

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
  <TabItem value="kde" label="KDE">

  ```sh
sudo pacman -S plasma kde-applications
  ```

  </TabItem>
</Tabs>

### Systemd

Set systemd to start the display manager automatically.

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
  <TabItem value="sddm" label="sddm">

  ```sh
systemctl enable sddm
  ```

  </TabItem>
</Tabs>
