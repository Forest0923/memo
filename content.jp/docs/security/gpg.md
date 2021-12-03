---
title: "GPG Key"
description: ""
lead: ""
date: 2021-11-29T15:00:12+09:00
lastmod: 2021-11-29T15:00:12+09:00
draft: false
images: []
menu: 
  docs:
    parent: "security"
weight: 20
toc: true
---

GPG (GNU Privacy Key)

- [List keys](#list-keys)
- [Add GPG key](#add-gpg-key)
- [Remove GPG key](#remove-gpg-key)
- [Key servers](#key-servers)

## List keys

- List public gpg keys:

```sh
gpg --list-keys
```

- List secret gpg keys:

```sh
gpg --list-secret-keys
```

## Add GPG key

- Receive keys:

```sh
gpg --keyserver keys.gnupg.net --recv-keys [key id]
```

## Remove GPG key

- Remove keys:

```sh
gpg --delete-keys [key id]
```

## Key servers

- [keys.openpgp.org](https://keys.openpgp.org)
- [keys.gnupg.net](http://keys.gnupg.net)
- [keys.mailvelope.com](https://keys.mailvelope.com)
- [pgp.mit.edu](http://pgp.mit.edu)
