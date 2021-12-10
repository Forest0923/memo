---
title: "Power Management"
draft: false
weight: 80
---

# Power Management

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
