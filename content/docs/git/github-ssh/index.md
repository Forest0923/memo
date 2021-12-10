---
title: "Connect to GitHub with SSH"
draft: false
weight: 40
---

# Connect to GitHub with SSH

## Add new SSH key to github

### System

- Ubuntu 18.04
- git version 2.17.1
- xclip version 0.12

### Generating SSH key

- Set key name as `id_rsa_github`.

```sh
ssh-keygen -t rsa -b 4096
```

### Adding to ssh-agent

```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_github
```

### Adding to GitHub account

```sh
xclip -sel clip < ~/.ssh/id_rsa_github.pub
```

> Reference:
>
> [GitHubにSSHで接続する](https://help.github.com/ja/github/authenticating-to-github/connecting-to-github-with-ssh)
