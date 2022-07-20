---
title: "Connect to GitHub with SSH"
draft: false
weight: 20
---
## SSH Key Generation

Executing ssh-keygen as follows will generate a key using the algorithm you have selected.

{{< tabpane >}}
{{< tab "EdDSA" >}}

```sh
ssh-keygen -t ed25519
```

{{< /tab >}}
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
{{< /tabpane >}}

If you do not make any changes during the generation, the private key `id_[algorithm]` and the public key `id_[algorithm].pub` will be generated in `~/.ssh`.

## Registering a Private Key to SSH Agent

By registering your key with SSH Agent, you will not be asked for your passphrase every time.

```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_[algorithm]
```

## Registering a Public Key to GitHub

### Registering from Browser

From your account page on GitHub, go to `Settings > SSH and GPG keys`, click `New SSH key`, and copy and paste the contents of `id_[algorithm].pub` to register it.

### Registering with GitHub CLI

You can also use the following command to register a key.

```sh
gh auth login
```

When you choose SSH as the connection protocol, you can choose whether to upload the public key or not.

```text
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations?  [Use arrows to move, type to filter]
  HTTPS
> SSH
```

```text
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? SSH
? Upload your SSH public key to your GitHub account?  [Use arrows to move, type to filter]
> /home/user/.ssh/id_ed25519.pub
  Skip
```

## Connection Test

Execute the following command to test the connection.

```sh
ssh git@github.com
```

When the fingerprint is displayed, compare it with <https://docs.github.com/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints> and confirm that it is github.com, then select yes.

> Reference:
>
> [Connecting to GitHub with SSH](https://help.github.com/github/authenticating-to-github/connecting-to-github-with-ssh)
