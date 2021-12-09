---
title: "Initial Settings for Ubuntu"
description: ""
lead: ""
date: 2021-11-29T12:45:50+09:00
lastmod: 2021-11-29T12:45:50+09:00
draft: false
images: []
menu: 
  docs:
    parent: "ubuntu"
weight: 10
toc: true
---

## Systems

- Ubuntu 18.04 LTS (minimal install)
- Ubuntu 20.04 LTS (minimal install)

## Settings for Ubuntu 18.04 on VirtualBox

```sh
wget https://github.com/Forest0923/memo/blob/master/scripts/settings_ubuntu_18_20.sh
chmod 755 settings_ubuntu_18_20.sh
sudo ./settings_ubuntu_18_20.sh
```

## Initial settings

### Update and upgrade

- At first, upgrade apt with following commands.

```sh
sudo apt update
sudo apt upgrade
```

### Change language of home directory

- English name is easier to operate on the command line than Japanese name.

```sh
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update
```

- Select `Update names`.

### Blank screen after an hour

```sh
gsettings set org.gnome.desktop.session idle-delay 3600
```

### Change apt server

- Yamagata university:

```sh
sudo sed -i.bak -e 's%http://jp.archive.ubuntu.com/ubuntu/%http://ftp.yz.yamagata-u.ac.jp/pub/linux/ubuntu/archives/%g' /etc/apt/sources.list
```

### Make shutdown time short

```sh
sudo sed -i 's/#DefaultTimeoutStopSec=90s/#DefaultTimeoutStopSec=90s\nDefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
```

> Reference:
>
> [systemd](https://www.freedesktop.org/software/systemd/man/systemd.service.html)

### Change resolution

- Add the following command as a startup application.
- Selectable [monitor name] and [resolution] can be shown by `xrandr`.

```sh
xrandr --output [monitor name] --mode [resolution]
```

- GUI: run `gnome-session-properties`
- CUI: run the following command at `~/.config/autostart`

```sh
cat <<EOF > xrandr.desktop
[Desktop Entry]
Type=Application
Exec=xrandr --output Virtual1 --mode 1440x900
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=monitor_resolution
Comment=Change builtin monitor resolution
EOF
```

### Mute sounds at terminal

```sh
sudo sed -i 's/# set bell-style none/set bell-style none/' /etc/inputrc
```

### Customize dock

- Register favorite apps:

```sh
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"
```

- Change icon size:

```sh
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
```
