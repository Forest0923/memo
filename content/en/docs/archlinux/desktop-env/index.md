---
title: "Desktop Environment"
draft: false
weight: 50
---
This is a tutorial for installing desktop environment.

## Install

### **Graphics Driver**

Install graphics driver.

{{< tabpane >}}
{{< tab header="Intel" lang="sh" >}}

sudo pacman -S xf86-video-intel
sudo pacman -S nvidia nvidia-utils nvidia-dkms

{{< /tab >}}
{{< tab header="Nvidia" lang="sh" >}}

sudo pacman -S xf86-video-intel
sudo pacman -S nvidia nvidia-utils nvidia-dkms

{{< /tab >}}
{{< /tabpane >}}

### **Display Server**

Install xorg as a display server. A display server is software that passes input and output using a GUI such as Gnome to the OS and hardware.

```sh
sudo pacman -S xorg
```

### **Display Manager**

Install the Display Manager to use the GUI for login.

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

Set systemd to start the display manager automatically.

{{< tabpane >}}
{{< tab header="lightdm" lang="sh" >}}

systemctl enable lightdm

{{< /tab >}}
{{< tab header="gdm" lang="sh" >}}

systemctl enable gdm

{{< /tab >}}
{{< /tabpane >}}
