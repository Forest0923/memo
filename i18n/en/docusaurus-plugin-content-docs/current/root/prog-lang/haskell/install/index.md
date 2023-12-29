---
title: "Install Haskell"
draft: false
weight: 10
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

This is a guide to installing Haskell using Stack.

## Install Stack

Stack is a tool for managing haskell projects, installing compilers and packages, and building projects. The installation is done as follows.

<Tabs groupId="OS" queryString>
  <TabItem value="arch" label="Arch">

    ```sh
sudo pacman -S stack
    ```

  </TabItem>
  <TabItem value="ubuntu" label="Ubuntu">

    ```sh
curl -sSL https://get.haskellstack.org/ | sh
stack upgrade
    ```

  </TabItem>
</Tabs>

## Basic Usage

To create a new project, run `stack new`.

```sh
stack new hs-proj
```

When you create a new project, the following directory structure will be created, and you can write the main code in Main.hs.

```text
.
├── app
│  └── Main.hs
├── ChangeLog.md
├── LICENSE
├── package.yaml
├── proj-name.cabal
├── README.md
├── Setup.hs
├── src
│  └── Lib.hs
├── stack.yaml
├── stack.yaml.lock
└── test
   └── Spec.hs
```

To compile, run `stack build`.

```sh
stack build
```

To execute code, run `stack exec *-exe`.

```sh
stack exec hs-proj-exe
```

## Remove stack

Remove `~/.stack` and `/usr/local/bin/stack`.

## Reference

- [The Haskell Tool Stack](https://docs.haskellstack.org/en/stable/README/)
