---
title: "Timeshift"
draft: false
weight: 999
---

## Subvolume layout

```text
/
/home
```

## Install

```sh
paru -S timeshift[-bin] timeshift-autosnap
```

## CLI

| Action           | Commands                                                                     |
| ---------------- | ---------------------------------------------------------------------------- |
| Lists snapshots  | `sudo timeshift --list`                                                      |
| Create snapshot  | `sudo timeshift --create [--comment "this is a test"] [--tag {O,B,H,D,W,M}]` |
| Delete snapshot  | `sudo timeshift --delete --snapshot '20xx-xx-xx_xx-xx-xx'`                   |
| Restore snapshot | `sudo timeshift --restore --snapshot '20xx-xx-xx_xx-xx-xx'`                  |
