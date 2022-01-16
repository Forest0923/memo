---
title: "Install KVM"
draft: false
weight: 10
---

# Install KVM

## Commands

- Install:

```sh
# Arch
sudo pacman -S virt-manager qemu qemu-arch-extra ovmf vde2 \
               ebtables dnsmasq bridge-utils openbsd-netcat
# Ubuntu server
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
```

- Systemd:

```sh
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

- Configuring bridge:

```sh
sudo vim br10.xml
```

```xml
<network>
  <name>br10</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='br10' stp='on' delay='0'/>
  <ip address='192.168.30.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.30.50' end='192.168.30.200'/>
    </dhcp>
  </ip>
</network>
```

- Activate network:

```sh
sudo virsh net-define br10.xml
sudo virsh net-start br10
sudo virsh net-autostart br10
```
