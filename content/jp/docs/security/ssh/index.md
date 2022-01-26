---
title: "SSH"
draft: false
weight: 40
---

# SSH

SSH は Secure Shell の略で，リモートから安全にコンピュータと通信することができるプロトコルを指します．

## SSH の使い方（クライアント）

### インストール

{{< tabs "install" >}}
{{< tab "Arch" >}}

```sh
sudo pacman -S openssh
```

{{< /tab >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt install openssh-client
```

{{< /tab >}}
{{< /tabs >}}

### 鍵の生成

ssh-keygen で鍵を生成します．

{{< tabs "ssh-keygen" >}}
{{< tab "RSA" >}}

```sh
ssh-keygen -t rsa -b 4096
```

{{< /tab >}}
{{< tab "ECDSA" >}}

```sh
ssh-keygen -t ecdsa -b 521
```

{{< /tab >}}
{{< tab "EdDSA" >}}

```sh
ssh-keygen -t ed25519
```

{{< /tab >}}
{{< /tabs >}}

デフォルトでは `~/.ssh/` に公開鍵 `id_[algorithm].pub` と秘密鍵 `id_[algorithm]` が作られるので，SSH サーバに公開鍵を登録することでパスワード認証せずに通信を行うことができます．