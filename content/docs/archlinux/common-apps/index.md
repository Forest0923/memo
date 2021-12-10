---
title: "Installing Common Applications in Arch Linux"
draft: false
weight: 70
---

# Installing Common Applications in Arch Linux

## Package manager

- Yay

```sh
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

- Paru

```sh
git clone https://aur.archlinux.org/paru
cd paru
makepkg -si
```

## Shell

- zsh

```sh
sudo pacman -S zsh zsh-completions
chsh -s $(which zsh) # or chsh -s /bin/zsh
```

## Terminal

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
yay -S gnome-terminal-transparency
```

## Terminal multiplexer

- tmux

```sh
sudo pacman -S tmux
```

## Editor

- VSCode

```sh
yay -S visual-studio-code-bin
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
yay -S timeshift
```

## Browser

- Brave browser

```sh
yay -S brave-bin
```

## Virtual Machine Monitor

- KVM
  - [[kvm-install]]

- VirtualBox

```sh
sudo pacman -S virtualbox virtualbox-host-modules-arch
reboot
```

## Password manager

- Bitwarden

```sh
yay -S bitwarden-bin
```

## Anti virus

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

## Messaging apps

- Discord

```sh
yay -S discord
```

- Slack

```sh
yay -S slack-desktop
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

## Gnome shell

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
yay -S matcha-gtk-theme
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
  yay -S ttf-ms-fonts
  yay -S ttf-windows
  ```

  - Chinese & Hangul:

  ```sh
  sudo pacman -S adobe-source-han-sans-cn-fonts # Chinese
  sudo pacman -S adobe-source-han-sans-tw-fonts # Chinese
  sudo pacman -S adobe-source-han-sans-kr-fonts # hangul
  ```
