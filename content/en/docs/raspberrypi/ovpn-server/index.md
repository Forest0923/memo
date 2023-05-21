---
title: "Setting Up an OpenVPN Server on a Raspberry Pi 4B"
draft: false
weight: 50
---

This is a note when setting up an Open VPN server on Raspberry Pi 4B.
I tried a few methods, so I will briefly record each one.

## Method 1: pivpn

I think this is the easiest and most reliable method.
You can set it up just by following the instructions after executing the command below.

```sh
curl -L https://install.pivpn.io | bash
```

- [pivpn/pivpn - GitHub](https://github.com/pivpn/pivpn)

## Method 2: Docker

I wanted to implement it this way if it worked properly, but it didn't support arm64, or the container kept restarting and didn't work well.

The images I tried are as follows:

- [mje-nz/rpi-docker-openvpn](https://github.com/mje-nz/rpi-docker-openvpn)
  - Fork of kylemanna/openvpn that supports rpi
  - Fails and enters a restart loop after startup
- [evolvedm/openvpn-rpi](https://hub.docker.com/r/evolvedm/openvpn-rpi/)
  - rpi-supported openvpn server
  - Fails and enters a restart loop after startup
- [linuxserver/openvpn-as](https://hub.docker.com/r/linuxserver/openvpn-as/)
  - Only supports the x86_64 architecture
- [kylemanna/openvpn](https://github.com/kylemanna/docker-openvpn)
  - Only supports the x86_64 architecture

It might work with the first two if I can use them properly.

## Method 3: Steadily working while referring to the Arch wiki

It seems like you can manage by following the URL below.

- [Easy-RSA](https://wiki.archlinux.jp/index.php/Easy-RSA)
- [OpenVPN](https://wiki.archlinux.jp/index.php/OpenVPN)

If you want to understand the mechanism, it might be worth giving it a try, but if you just want to set up a VPN server on a Raspberry Pi, I recommend pivpn.

I also tried creating an Easy RSA client file, but I stopped midway because I thought there would be a better way.
