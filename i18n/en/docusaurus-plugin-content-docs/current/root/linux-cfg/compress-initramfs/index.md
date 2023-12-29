---
title: "Compress initramfs"
draft: false
weight: 999
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

In some cases, the `/boot` partition is too small for the initramfs to fit. This makes it impossible to install multiple kernels, so the solution is to change the compression method.

Edit `/etc/initramfs-tools/initramfs.conf` and change the compression method to xz (xz has a higher compression ratio, but slows down the decompression speed).

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

Install xz-utils and update initramfs.

<Tabs groupId="initramfs" queryString>
  <TabItem value="ubuntu" label="Ubuntu">

  ```sh
sudo apt install xz-utils
sudo update-initramfs -u -k all
  ```

  </TabItem>
</Tabs>
