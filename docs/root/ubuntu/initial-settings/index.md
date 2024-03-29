---
title: "Ubuntu の初期設定"
draft: false
weight: 10
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

VirtualBox にデスクトップ版の Ubuntu を入れたときに初期設定をすぐにできるようにまとめたものです．GUI なしで設定できるようにしているので，Ubuntu インストール後にターミナルで下記のコマンドを実行すればすべて設定可能です．インストール時の言語設定は English を選択し，Minimal Install を選択した場合を想定しています．

```sh
wget http://forest0923.github.io/memo/docs/ubuntu/initial-settings/ubuntu-initial-settings.sh
chmod +x ubuntu-initial-settings.sh
./ubuntu-initial-settings.sh
```

## 環境

- Ubuntu 18.04 LTS (minimal install)
- Ubuntu 20.04 LTS (minimal install)

## 設定

### **スリープまでの時間設定**

次のコマンドで時間を設定します．

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

### **DOCK のカスタマイズ**

お気に入りのアプリケーションを追加します．

```sh
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"
```

アイコンのサイズを変更します．

```sh
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36
```

### **パッケージインストール時のサーバ変更**

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

### **シャットダウンにかかる時間の短縮**

```sh
sudo sed -i 's/#DefaultTimeoutStopSec=90s/#DefaultTimeoutStopSec=90s\nDefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
```

> Reference:
>
> [systemd](https://www.freedesktop.org/software/systemd/man/systemd.service.html)

### **解像度の設定**

xrandr を用いて解像度を設定します．

```sh
xrandr --output Virtual1 --mode 1440x900
```

このコマンドを OS 起動時に実行させれば良いのでオートスタートに追加します．

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

### **ターミナルのエラー音を消す**

```sh
sudo sed -i 's/# set bell-style none/set bell-style none/' /etc/inputrc
```

## アプリケーションのインストール

### **エディタ**

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

### **ターミナルマルチプレクサ**

```sh
sudo apt install tmux
```

### **Git**

```sh
sudo apt install git
```

### **コンパイラなど**

```sh
sudo apt install build-essential
```

### **設定ツール**

```sh
sudo apt install gnome-tweak-tool
```
