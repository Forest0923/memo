#!/bin/bash
# Blank screen
gsettings set org.gnome.desktop.session idle-delay 3600
# apt
sed -i.bak -e 's%http://jp.archive.ubuntu.com/ubuntu/%http://ftp.yz.yamagata-u.ac.jp/pub/linux/ubuntu/archives/%g' /etc/apt/sources.list
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
wget -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
apt -y update
apt -y upgrade
apt -y install vim-gtk3
apt -y install git
apt -y install tmux
apt -y install build-essential
apt -y install google-chrome-stable
# Firewall
apt -y install gufw
ufw enable
ufw default DENY
apt -y autoremove
# Shutdown
sed -i 's/#DefaultTimeoutStopSec=90s/#DefaultTimeoutStopSec=90s\nDefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
# Resolution
if [ ! -d /home/$SUDO_USER/.config/autostart ]; then
    mkdir /home/$SUDO_USER/.config/autostart
fi
xrandr --output Virtual1 --mode 1440x900
cat <<EOF > /home/$SUDO_USER/.config/autostart/xrandr.desktop
[Desktop Entry]
Type=Application
Exec=xrandr --output Virtual1 --mode 1440x900
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=monitor_resolution
Comment=Change builtin monitor resolution
EOF
# Mute bell
sed -i 's/# set bell-style none/set bell-style none/' /etc/inputrc
# Customize dock
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
# Rename directories in $HOME
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

