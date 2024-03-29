---
title: "Initial Settings for Ubuntu"
draft: false
weight: 10
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

This article is a guide to help you quickly configure the initial settings when you install the desktop version of Ubuntu in VirtualBox. It is assumed that English is selected as the language setting during installation, and Minimal Install is selected.

```sh
wget http://forest0923.github.io/memo/docs/ubuntu/initial-settings/ubuntu-initial-settings.sh
chmod +x ubuntu-initial-settings.sh
./ubuntu-initial-settings.sh
```

## Systems Setup

- Ubuntu 18.04 LTS (minimal install)
- Ubuntu 20.04 LTS (minimal install)

## Initial Settings

### **Set the Time to Sleep**

Set the time as follows.

<Tabs groupId="idle-delay" queryString>
  <TabItem value="never" label="Never">

    ```sh
gsettings set org.gnome.desktop.session idle-delay 0
    ```

  </TabItem>
  <TabItem value="an_hour" label="An hour">

    ```sh
gsettings set org.gnome.desktop.session idle-delay 3600
    ```

  </TabItem>
</Tabs>

### **Customize Dock**

Add favorite applications to dock.

```sh
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"
```

Change the icon size.

```sh
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
```

### **Change Server for apt**

<Tabs groupId="mirror-server" queryString>
  <TabItem value="jaist" label="JAIST">

    ```sh
sudo sed -i.bak -e 's%http://jp.archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/archives/%g' /etc/apt/sources.list
    ```

  </TabItem>
  <TabItem value="yamagata" label="Yamagata Univ.">

    ```sh
sudo sed -i.bak -e 's%http://jp.archive.ubuntu.com/ubuntu/%http://ftp.yz.yamagata-u.ac.jp/pub/linux/ubuntu/archives/%g' /etc/apt/sources.list
    ```

  </TabItem>
</Tabs>

### **Reduce the Time to Shutdown**

```sh
sudo sed -i 's/#DefaultTimeoutStopSec=90s/#DefaultTimeoutStopSec=90s\nDefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
```

> Reference:
>
> [systemd](https://www.freedesktop.org/software/systemd/man/systemd.service.html)

### **Settings of Resolution**

Use xrandr to set the resolution.

```sh
xrandr --output Virtual1 --mode 1440x900
```

To run the command above at OS startup, add it to the autostart as follows.

```sh
if [ ! -d /home/$USER/.config/autostart ]; then
    mkdir /home/$USER/.config/autostart
fi
cat <<EOF > /home/$USER/.config/autostart/xrandr.desktop
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

### **Mute Error Sounds in Terminal**

```sh
sudo sed -i 's/# set bell-style none/set bell-style none/' /etc/inputrc
```

## Install Common Applications

### **Editor**

<Tabs groupId="editor" queryString>
  <TabItem value="vim" label="Vim">

    ```sh
sudo apt install vim-gtk3
    ```

  </TabItem>
  <TabItem value="vscode" label="VS Code">

    ```sh
sudo apt install snapd
sudo snap install code
    ```

  </TabItem>
  <TabItem value="emacs" label="Emacs">

    ```sh
sudo apt install emacs-nox
    ```

  </TabItem>
</Tabs>
### **Terminal Multiplexer**

```sh
sudo apt install tmux
```

### **Git**

```sh
sudo apt install git
```

### **Compiler and etc.**

```sh
sudo apt install build-essential
```

### **Tweak Tool**

```sh
sudo apt install gnome-tweak-tool
```
