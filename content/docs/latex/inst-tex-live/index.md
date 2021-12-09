---
title: "Install TeX Live"
description: ""
lead: ""
date: 2021-11-29T14:58:34+09:00
lastmod: 2021-11-29T14:58:34+09:00
draft: false
images: []
menu: 
  docs:
    parent: "latex"
weight: 10
toc: true
---

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
