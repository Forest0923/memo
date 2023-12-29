---
title: "fwupd"
draft: false
weight: 50
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Install

<Tabs groupId="fwupd" queryString>
  <TabItem value="arch" label="Arch">
  ```sh
  sudo pacman -S fwupd
  ```
  </TabItem>
  <TabItem value="ubuntu" label="Ubuntu">
  ```sh
  sudo apt install fwupd
  ```
  </TabItem>
</Tabs>

## Usage

- Refresh data from server:

```sh
fwupdmgr refresh
```

- Check device for updates:

```sh
fwupdmgr get-updates
```

- Update and install:

```sh
fwupdmgr update
```

## Troubleshooting

- If the update does not apply, follow the steps below.

1. Download .cab file
2. Install:

```sh
fwupdmgr install [path-to-.cab]
```
