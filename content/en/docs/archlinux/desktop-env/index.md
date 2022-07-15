---
title: "Desktop Environment"
draft: false
weight: 50
---

# Desktop Environment

This is a tutorial for installing desktop environment.

## Install

### **Graphics Driver**

Install graphics driver.

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

### **Display Server**

Install xorg as a display server. A display server is software that passes input and output using a GUI such as Gnome to the OS and hardware.

```sh
sudo pacman -S xorg
```

### **Display Manager**

Install the Display Manager to use the GUI for login.

{{< tabpane "display-manager" >}}
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
{{< /tabpane >}}

### **Desktop Environment**

{{< tabpane "desktop-environment" >}}
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
{{< /tabpane >}}

### **Systemd**

Set systemd to start the display manager automatically.

{{< tabpane "systemd" >}}
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
{{< /tabpane >}}
