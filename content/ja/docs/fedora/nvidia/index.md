---
title: "Install Nvidia Driver"
draft: false
weight: 30
---

## System setup

- OS: Fedora 37 (workstation edition) x86_64
- GPU: NVIDIA RTX2060

## Install

### Add repository

CUDA リポジトリを追加します。

```sh
sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/fedora37/x86_64/cuda-fedora37.repo
```

### Clean DNF reository cache

公式のマニュアルに従えばキャッシュのクリアをしたほうが良いらしいですが、私の環境では特に何も起こりませんでした。

```sh
sudo dnf clean expire-cache
```

### install CUDA SDK

CUDA ドライバと関連するソフトウェアをインストールします。

```sh
sudo dnf module install nvidia-driver:latest-dkms
sudo dnf install cuda
```

### Reboot

```sh
sudo reboot
```

## Check current driver

再起動後に現在使っているドライバを確認します。

```sh
sudo lspci -v
```

私の環境では下記の出力が得られました。
nouveauなどのモジュールも削除していないので残っていますが、nvidia のドライバが使われてることが確認できます。

```text
...
01:00.0 VGA compatible controller: NVIDIA Corporation TU106 [GeForce RTX 2060 Rev. A] (rev a1) (prog-if 00 [VGA controller])
        Subsystem: NVIDIA Corporation TU106 [GeForce RTX 2060 Rev. A]
        Flags: bus master, fast devsel, latency 0, IRQ 134
        Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
        Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Memory at f0000000 (64-bit, prefetchable) [size=32M]
        I/O ports at e000 [size=128]
        Expansion ROM at f7000000 [virtual] [disabled] [size=512K]
        Capabilities: <access denied>
        Kernel driver in use: nvidia
        Kernel modules: nouveau, nvidia_drm, nvidia
...
```

## Reference

[NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#fedora)