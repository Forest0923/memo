---
title: "Desktop Environment"
draft: false
weight: 50
---

# Desktop Environment

## Comands

### Graphic driver

- Graphic card:

```sh
# Intel
sudo pacman -S xf86-video-intel
# nvidia
sudo pacman -S nvidia nvidia-utils nvidia-dkms
```

### Display server

- xorg:

```sh
sudo pacman -S xorg
```

### Display manager

- lightdm:

```sh
sudo pacman -S lightdm lightdm-gtk-greeter
```

- gdm:

```sh
sudo pacman -S gdm
```

### Desktop environment

- xfce:

```sh
sudo pacman -S xfce4 xfce4-goodies
```

- gnome:

```sh
sudo pacman -S gnome gnome-tweaks
```

- budgie:

```sh
sudo pacman -S budgie-desktop gnome
```

### Activate display manager

- lightdm:

```sh
systemctl enable lightdm
```

- gdm:

```sh
systemctl enable gdm
```
