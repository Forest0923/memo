---
title: "SSH"
draft: false
weight: 40
---

# SSH

SSH stands for Secure Shell, a protocol that allows you to communicate with a computer securely from a remote location.

## How to use SSH (client)

### Install

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

### Key Generation

Generate a key with ssh-keygen.

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

By default, the public key `id_[algorithm].pub` and the private key `id_[algorithm]` are created in `~/.ssh/`. You can communicate without password authentication by registering a public key with the SSH server.
