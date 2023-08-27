---
title: "Install Applications"
draft: false
weight: 70
---
## Package Manager

- Paru

```sh
git clone https://aur.archlinux.org/paru
cd paru
makepkg -si
```

- Yay

```sh
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Shell

- zsh

```sh
sudo pacman -S zsh zsh-completions
chsh -s $(which zsh) # or chsh -s /bin/zsh
```

## Terminal Emulator

- Alacritty

```sh
sudo pacman -S alacritty
```

- Xfce4 terminal

```sh
sudo pacman -S xfce4-terminal
```

- Gnome terminal

```sh
paru -S gnome-terminal-transparency
```

## Terminal multiplexer

- tmux

```sh
sudo pacman -S tmux
```

## Editor

- VSCode

```sh
paru -S visual-studio-code-bin
```

- vim

```sh
sudo pacman -S gvim
```

- emacs

```sh
sudo pacman -S emacs-nox
```

## Backup

- Timeshift

```sh
paru -S timeshift
```

## zram

- zramd

```sh
paru -S zramd
```

```sh
sudo systemctl enable --now zramd.service
```

## Browser

- Brave browser

```sh
paru -S brave-bin
```

## Virtual Machine Monitor

- KVM

- VirtualBox

```sh
sudo pacman -S virtualbox virtualbox-host-modules-arch
reboot
```

## Password Manager

- Bitwarden

```sh
yay -S bitwarden-bin
```

## Anti Virus

- clamav

```sh
sudo pacman -S clamav clamtk
sudo freshclam
sudo systemctl start clamav-freshclam.service
sudo systemctl enable clamav-freshclam.service
sudo systemctl start clamav-daemon.service
sudo systemctl enable clamav-daemon.service
```

## Firewall

- gufw

```sh
sudo pacman -S gufw
sudo systemctl start ufw
sudo systemctl enable ufw
sudo ufw enable
```

- firewalld

```sh
sudo pacman -S firewalld
```

## Messaging Apps

- Discord

```sh
paru -S discord
```

- Slack

```sh
paru -S slack-desktop
```

- Quill

```sh
sudo pacman -S quill-chat
```

## Office

- LibreOffice

```sh
sudo pacman -S libreoffice
```

## rclone-browser

- rclone brawser

```sh
sudo pacman -S rclone
```

## Gnome Shell

- CPU power manager

```sh
sudo pacman -S gnome-shell-extension-cpupower-git
```

- CPU temperature

```sh
sudo pacman -S gnome-shell-extension-freon-git
```

## Preferences

- Gnome shell theme

```sh
paru -S matcha-gtk-theme
```

- Icon theme

```sh
sudo pacman -S papirus-icon-theme breeze
```

- Power line

```sh
sudo pacman -S powerline powerline-fonts
```

- Fonts
  - Japanese:

  ```sh
  sudo pacman -S otf-ipaexfont
  paru -S ttf-ms-fonts
  ```

  - Chinese & Hangul:

  ```sh
  sudo pacman -S adobe-source-han-sans-cn-fonts # Chinese
  sudo pacman -S adobe-source-han-sans-tw-fonts # Chinese
  sudo pacman -S adobe-source-han-sans-kr-fonts # hangul
  ```
  
  - For KDE:

  ```sh
  sudo pacman -S ttf-dejvu ttf-liberation
  ```
  
