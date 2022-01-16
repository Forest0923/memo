---
title: "電源管理"
draft: false
weight: 80
---

# 電源管理

電源管理に関するメモです．

## TLP

TLP は Linux の電源管理ツールです．インストールして有効化すれば特に細かい設定はせずに使用できます．

### **Install**

```sh
sudo pacman -S tlp
```

### **Settings**

ファイルシステムとして BTRFS を使っている場合はファイルシステムが破壊される可能性があるので以下の設定をしたほうが良いそうです．

```sh
sudo vim /etc/default/tlp
```

```sh
SATA_LINKPWR_ON_BAT=max_performance
```

### **Enable TLP**

以下のコマンドで TLP をスタートします．

```sh
sudo tlp start
```

自動でスタートさせるために systemd で tlp のサービスを有効化します．

```sh
sudo systemctl enable tlp
```

## Powertop

Powertop は Intel が提供する省電力化ツールです．

### **Install**

```sh
sudo pacman -S powertop
```

### **Auto tune**

下記のコマンドを実行すると自動で省電力化が行われます．

```sh
sudo powertop --auto-tune
```

systemd でこのコマンドを実行するようにサービスを作成すると自動で省電力化されるようになります．

[Powertop - Arch Wiki](https://wiki.archlinux.jp/index.php/Powertop)
