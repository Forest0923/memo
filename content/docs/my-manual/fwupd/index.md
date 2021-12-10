---
title: "Filmware Update with fwupd"
draft: false
weight: 50
---

# Filmware Update with fwupd

## System

- OS: Ubuntu 18.04 (64bit), Arch
- Device: Thinkpad X1 Carbon (6th)

## Install

- Install `fwupd` with:

```sh
# Ubuntu
sudo apt install fwupd
# Arch
sudo pacman -S fwupd
```

## Usage

- Refresh data from server:

```sh
fwupdmgr refresh
```

- Check device for updates:

```sh
fwupdmgr get-updates
```

- Update and install:

```sh
fwupdmgr update
```

## Tips

- If the update does not apply, follow the steps below.

1. Download .cab file
2. Install:

```sh
fwupdmgr install [path-to-.cab]
```
