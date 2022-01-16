---
title: "Install TeX Live"
draft: false
weight: 10
---

# Install TeX Live

This is a startup guide for using LaTeX.

## System Environment

- OS: Linux

## Install

### **TeX Live**

Install texlive and language packages with the following command.

```sh
# Arch
sudo pacman -S texlive-most texlive-langjapanese
```

```sh
# ubuntu
sudo apt install texlive-full
```

### **jListing**

If you want to add source code that contains Japanese, you need to download jlisting from <https://osdn.net/projects/mytexpert/downloads/26068/jlisting.sty.bz2/> and extract it.

```sh
bzip2 -dk jlisting.sty
```

Create a directory for jlisting in `/usr/local/share/texmf/tex/latex/`, add jlisting.sty, and run mktexlsr to reflect the added files.

```sh
sudo mkdir -p /usr/local/share/texmf/tex/latex/jlisting
sudo mv jlisting.sty /usr/local/share/texmf/tex/latex/jlisting/
cd /usr/local/share/texmf/tex/latex/
sudo mktexlsr
```
