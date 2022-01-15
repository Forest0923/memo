---
title: "Power Management"
draft: false
weight: 80
---

# Power Management

This is a memo about power management.

## TLP

TLP is a power management tool for Linux. Once installed and activated, it can be used without any special configuration.

### **Install**

```sh
sudo pacman -S tlp
```

### **Settings**

If you are using BTRFS as a file system, you should make the following settings because the file system may be corrupted.

```sh
sudo vim /etc/default/tlp
```

```sh
SATA_LINKPWR_ON_BAT=max_performance
```

### **Enable TLP**

Enable TLP by running following commands.

```sh
sudo tlp start
```

Enable the tlp service in systemd to start it automatically.

```sh
sudo systemctl enable tlp
```

## Powertop

Powertop is a power saving tool provided by Intel.

### **Install**

```sh
sudo pacman -S powertop
```

### **Auto tune**

Execute the following command to automatically save power.

```sh
sudo powertop --auto-tune
```

If you create a service to run this command in systemd, it will automatically reduce the power consumption.

[Powertop - Arch Wiki](https://wiki.archlinux.jp/index.php/Powertop)
