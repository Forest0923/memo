---
title: "Install TeX Live"
draft: false
weight: 10
---

# Install TeX Live

## System

- OS: Arch, Ubuntu

## Install commands

- Install texlive and language package:

```sh
sudo pacman -S texlive-most texlive-langjapanese
sudo apt install texlive-full
```

- Downloads jlisting.sty from <https://osdn.net/projects/mytexpert/downloads/26068/jlisting.sty.bz2/> and decompress:

```sh
bzip2 -dk jlisting.sty
```

- Add jlisting.sty:

```sh
sudo mkdir -p /usr/local/share/texmf/tex/latex/jlisting
sudo mv jlisting.sty /usr/local/share/texmf/tex/latex/jlisting/
cd /usr/local/share/texmf/tex/latex/
sudo mktexlsr
```
