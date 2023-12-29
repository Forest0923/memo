---
title: "SSH"
draft: false
weight: 40
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

SSH stands for Secure Shell, a protocol that allows you to communicate with a computer securely from a remote location.

## How to use SSH (client)

### Install

<Tabs groupId="OS" queryString>
  <TabItem value="arch" label="Arch">

    ```sh
sudo pacman -S openssh
    ```

  </TabItem>
  <TabItem value="ubuntu" label="Ubuntu">

    ```sh
sudo apt install openssh-client
    ```

  </TabItem>
</Tabs>

### Key Generation

Generate a key with ssh-keygen.

<Tabs groupId="algorhism" queryString>
  <TabItem value="EdDSA" label="EdDSA">
  ```sh
ssh-keygen -t ed25519
  ```
  </TabItem>
  <TabItem value="rsa" label="RSA">
  ```sh
ssh-keygen -t rsa -b 4096
  ```
  </TabItem>
  <TabItem value="ecdsa" label="ECDSA">
  ```sh
ssh-keygen -t ecdsa -b 521
  ```
  </TabItem>
</Tabs>

By default, the public key `id_[algorithm].pub` and the private key `id_[algorithm]` are created in `~/.ssh/`. You can communicate without password authentication by registering a public key with the SSH server.
