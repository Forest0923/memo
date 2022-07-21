---
title: "SSH"
draft: false
weight: 40
---
SSH は Secure Shell の略で，リモートから安全にコンピュータと通信することができるプロトコルを指します．

## SSH の使い方（クライアント）

### インストール

{{< tabpane >}}
{{< tab header="Arch" lang="sh" >}}

sudo pacman -S openssh

{{< /tab >}}
{{< tab header="Ubuntu" lang="sh" >}}

sudo apt install openssh-client

{{< /tab >}}
{{< /tabpane >}}

### 鍵の生成

ssh-keygen で鍵を生成します．

{{< tabpane >}}
{{< tab header="RSA" lang="sh" >}}

ssh-keygen -t rsa -b 4096

{{< /tab >}}
{{< tab header="ECDSA" lang="sh" >}}

ssh-keygen -t ecdsa -b 521

{{< /tab >}}
{{< tab header="EdDSA" lang="sh" >}}

ssh-keygen -t ed25519

{{< /tab >}}
{{< /tabpane >}}

デフォルトでは `~/.ssh/` に公開鍵 `id_[algorithm].pub` と秘密鍵 `id_[algorithm]` が作られるので，SSH サーバに公開鍵を登録することでパスワード認証せずに通信を行うことができます．
