---
title: "initramfs の圧縮"
draft: false
weight: 999
---

# initramfs の圧縮

`/boot` のパーティションが小さすぎて initramfs が入り切らない場合があります．この場合，カーネル開発で複数のカーネルをインストールすることができなくなってしまうので，圧縮方法を変えることで解決します．

`/etc/initramfs-tools/initramfs.conf` を編集して，xz で圧縮するように変更します（xz は圧縮率は高いですが，解凍速度は遅くなります）．

```sh
sudo vim /etc/initramfs-tools/initramfs.conf
```

```diff
- MODULES=most
+ MODULES=dep
```

```diff
- COMPRESS=lz4
+ COMPRESS=xz
```

xz-utils をインストールして initramfs をアップデートします．

{{< tabpane "update-initramfs" >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt install xz-utils
sudo update-initramfs -u -k all
```

{{< /tab >}}
{{< /tabpane >}}
