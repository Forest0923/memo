#!/bin/bash

# Blank screen
gsettings set org.gnome.desktop.session idle-delay 3600

# Customize dock
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32

# Resolution
xrandr --output Virtual1 --mode 1440x900

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

# Shutdown
sudo sed -i 's/#DefaultTimeoutStopSec=90s/#DefaultTimeoutStopSec=90s\nDefaultTimeoutStopSec=10s/' /etc/systemd/system.conf

# Mute bell
sudo sed -i 's/# set bell-style none/set bell-style none/' /etc/inputrc

# apt
sudo sed -i.bak -e 's%http://jp.archive.ubuntu.com/ubuntu/%http://ftp.yz.yamagata-u.ac.jp/pub/linux/ubuntu/archives/%g' /etc/apt/sources.list

sudo apt -y update
sudo apt -y upgrade
sudo apt -y install vim-gtk3
sudo apt -y install tmux
sudo apt -y install git
sudo apt -y install build-essential
sudo apt -y install gnome-tweak-tool
sudo apt -y autoremove
