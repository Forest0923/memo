---
title: "Setup RDP Server"
draft: false
weight: 50
---

- Fedora 37 (workstation edition) x86_64

## Install

```sh
sudo dnf install xrdp
```

## Enable

```sh
sudo systemctl enable --now xrdp
```

## Configure firewalld

```sh
sudo firewall-cmd --permanent --add-service=rdp
sudo systemctl reload firewalld.service
```
