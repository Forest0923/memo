---
title: "How to Use virsh"
draft: false
weight: 20
---

# How to Use virsh

virsh is a tool for managing KVM and Guest VMs via the CLI. This page describes how to use virsh to manage KVM and VMs.

## Change the Number of vCPU Cores

```sh
sudo virsh setvcpus [vm_name] [vcpu_num] --config --maximum
sudo virsh setvcpus [vm_name] [vcpu_num] --config
```
