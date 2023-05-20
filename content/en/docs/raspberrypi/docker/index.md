---
title: "Docker"
draft: false
weight: 40
---

## Install

```sh
curl -sSL https://get.docker.com | sh
```

```sh
sudo usermod -aG docker $USER
```

```sh
sudo systemctl status docker
# sudo systemctl start docker
```

## Test

```sh
sudo docker run hello-world
```
