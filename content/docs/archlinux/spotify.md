---
title: "Configurations for Spotify"
description: ""
lead: ""
date: 2021-11-29T12:45:25+09:00
lastmod: 2021-11-29T12:45:25+09:00
draft: false
images: []
menu: 
  docs:
    parent: "archlinux"
weight: 100
toc: true
---

## HiDPI

- Edit `/usr/share/applications/spotify.desktop`

```diff
-Exec=spotify %U
+Exec=spotify --force-device-scale-factor=1.5 %U
```

## Download error

```text
==> ERROR: Failure while downloading http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.1.56.595.g2d2da0de_amd64.deb
```

- Solution:

```sh
cd ~/.cache/paru/clone/spotify/
wget --continue http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.1.56.595.g2d2da0de_amd64.deb
mv spotify-client_1.1.56.595.g2d2da0de_amd64.deb spotify-1.1.56.595-x86_64.deb
paru -Syu
```
