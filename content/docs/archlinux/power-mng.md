---
title: "Power Management"
description: ""
lead: ""
date: 2021-11-29T12:45:05+09:00
lastmod: 2021-11-29T12:45:05+09:00
draft: false
images: []
menu: 
  docs:
    parent: "archlinux"
weight: 80
toc: true
---

## Install

- Install tlp:

```sh
sudo pacman -S tlp
```

- Check dependencies (Thinkpad only?):

```sh
tlp-stat -b
```

- Install recommended package (e.g. acpi_call).

## Setting

- When using btrfs as a file system:

```sh
sudo vim /etc/default/tlp
```

```sh
# /etc/default/tlp
SATA_LINKPWR_ON_BAT=max_performance
```

## Start

- Start tlp:

```sh
sudo tlp start
```

- Systemctl:

```sh
sudo systemctl enable tlp
```
