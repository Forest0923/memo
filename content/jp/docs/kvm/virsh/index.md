---
title: "virsh の使い方"
draft: false
weight: 20
---

# virsh の使い方

virsh は KVM，Guest VM を CLI で管理するためのツールです．このページでは virsh を用いた一般的な KVM および VM の管理方法をまとめています．

## vCPU のコア数を変更する

```sh
sudo virsh setvcpus [vm_name] [vcpu_num] --config --maximum
sudo virsh setvcpus [vm_name] [vcpu_num] --config
```
