---
title: "Snapper"
draft: false
weight: 999
---

## Setup

### Subvolume layout

```text
/
/home
/.snapshots
/var/log
```

### Config

```sh
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs su delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
sudo vim /etc/snapper/configs/root
```

```diff
+ TIMELINE_LIMIT_HOURLY="5"
+ TIMELINE_LIMIT_DAILY="7"
+ TIMELINE_LIMIT_WEEKLY="0"
+ TIMELINE_LIMIT_MONTHLY="0"
+ TIMELINE_LIMIT_YEARLY="0"
```

```sh
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
paru -S snap-pac-grub snapper-gui-git
sudo mkdir /etc/pacman.d/hooks
sudo vim /etc/pacman.d/hooks/50-bootbackup.hook
```

```diff
+ [Trigger]
+ Operation = Upgrade
+ Operation = Install
+ Operation = Remove
+ Type = Path
+ Target = boot/*
+ 
+ [Action]
+ Depends = rsync
+ Description = Backing up /boot...
+ When = PreTransaction
+ Exec = /usr/bin/rsync -a --delete /boot /.bootbackup
```

```sh
sudo pacman -S rsync
sudo chmod a+rx /.snapshots
sudo chown :mori /.snapshots
```
