---
title: "SSH"
draft: false
weight: 40
---
SSH stands for Secure Shell, a protocol that allows you to communicate with a computer securely from a remote location.

## How to use SSH (client)

### Install

{{< tabpane >}}
{{< tab header="Arch" lang="sh">}}

sudo pacman -S openssh

{{< /tab >}}
{{< tab header="Ubuntu" lang="sh" >}}

sudo apt install openssh-client

{{< /tab >}}
{{< /tabpane >}}

### Key Generation

Generate a key with ssh-keygen.

{{< tabpane >}}
{{< tab header="RSA" lang="sh" >}}

ssh-keygen -t rsa -b 4096

{{< /tab >}}
{{< tab head="ECDSA" lang="sh" >}}

ssh-keygen -t ecdsa -b 521

{{< /tab >}}
{{< tab head="EdDSA" lang="sh" >}}

ssh-keygen -t ed25519

{{< /tab >}}
{{< /tabpane >}}

By default, the public key `id_[algorithm].pub` and the private key `id_[algorithm]` are created in `~/.ssh/`. You can communicate without password authentication by registering a public key with the SSH server.
