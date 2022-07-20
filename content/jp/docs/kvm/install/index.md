---
title: "KVM のインストールと設定"
draft: false
weight: 10
---
## Install

{{< tabpane >}}
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

libvirt の daemon を自動で有効にするように systemd のサービスを設定します．

```sh
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

ネットワークの設定を行います．xml ファイルを作成して，ポートや IP アドレスの設定を行います．

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

作成したネットワークの情報を登録します．

```sh
sudo virsh net-define br0.xml
sudo virsh net-start br0
sudo virsh net-autostart br0
```
