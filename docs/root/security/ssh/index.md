---
title: "SSH"
draft: false
weight: 40
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

SSH は Secure Shell の略で，リモートから安全にコンピュータと通信することができるプロトコルを指します．

## SSH の使い方（クライアント）

### インストール

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

### 鍵の生成

ssh-keygen で鍵を生成します．

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

デフォルトでは `~/.ssh/` に公開鍵 `id_[algorithm].pub` と秘密鍵 `id_[algorithm]` が作られるので，SSH サーバに公開鍵を登録することでパスワード認証せずに通信を行うことができます．
