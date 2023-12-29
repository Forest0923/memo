---
title: "nkf"
draft: false
weight: 20
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Install

<Tabs groupId="nkf" queryString>
  <TabItem value="arch" label="Arch">

  ```sh
paru -S nkf
  ```

  </TabItem>
  <TabItem value="ubuntu" label="Ubuntu">

  ```sh
sudo apt install nkf
  ```

  </TabItem>
</Tabs>

## Usage

- To convert any file to UTF-8 + LF:

```sh
nkf -w -Lu --overwrite input_file
```

- To convert C files in current directory to UTF-8 + LF:

```sh
find . -iname "*.c" -type f -print0 | xargs -0 nkf -w -LF --overwrite
```
