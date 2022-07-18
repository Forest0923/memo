---
title: "Install KVM"
draft: false
weight: 10
---
## Install

{{< tabpane "install" >}}
{{< tab "Arch" >}}

```sh
sudo pacman -S virt-manager qemu qemu-arch-extra ovmf vde2 \
               ebtables dnsmasq bridge-utils openbsd-netcat
```

{{< /tab >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt install qemu-kvm libvirt-daemon-system \
                  libvirt-clients bridge-utils virtinst
```

{{< /tab >}}
{{< /tabpane >}}

## Configrations

Configure the systemd service to automatically enable the libvirt daemon.

```sh
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

Create an xml file to configure the port and IP address settings.

```sh
sudo vim br0.xml
```

```xml
<network>
  <name>br0</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='br0' stp='on' delay='0'/>
  <ip address='192.168.30.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.30.50' end='192.168.30.200'/>
    </dhcp>
  </ip>
</network>
```

Register the information of the created network.

```sh
sudo virsh net-define br0.xml
sudo virsh net-start br0
sudo virsh net-autostart br0
```
