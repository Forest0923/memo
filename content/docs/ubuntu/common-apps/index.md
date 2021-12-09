---
title: "Installing Common Apps in Ubuntu"
description: ""
lead: ""
date: 2021-11-29T12:46:01+09:00
lastmod: 2021-11-29T12:46:01+09:00
draft: false
images: []
menu: 
  docs:
    parent: "ubuntu"
weight: 20
toc: true
---

## Applications

### vim

```sh
sudo apt install vim-gtk3
```

### emacs

- Add ppa:

```sh
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt upgrade
```

- If only need CUI:

```sh
sudo apt install emacs26-nox
```

- GUI:

```sh
sudo apt install emacs26
```

### vscode

```sh
sudo snap install code --classic
```

### git

```sh
sudo apt install git
```

### tmux

```sh
sudo apt install tmux
```

### build essential

```sh
sudo apt install build-essential
```

### tweaks

```sh
sudo apt install gnome-tweak-tool
```

### LibreOffice

```sh
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt update
sudo apt upgrade
sudo apt install libreoffice
```

### Google Chrome

```sh
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt update
sudo apt install google-chrome-stable
```

### Firewall

```sh
sudo apt install gufw
sudo ufw enable
sudo ufw default DENY
```
