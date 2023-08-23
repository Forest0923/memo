---
title: "GPG Key"
draft: false
weight: 20
---
GnuPG is the OpenPGP standard for encrypting and signing data and communications.

## How to Use GnuPG

### **List registered keys**

List public keys：

```sh
gpg --list-keys
```

List private keys:

```sh
gpg --list-secret-keys
```

### **Add Keys**

```sh
gpg --keyserver keys.gnupg.net --recv-keys [key id]
```

### **Remove Keys**

```sh
gpg --delete-keys [key id]
```

## Key Servers

- [keys.openpgp.org](https://keys.openpgp.org)
- [keys.gnupg.net](http://keys.gnupg.net)
- [keys.mailvelope.com](https://keys.mailvelope.com)
- [pgp.mit.edu](http://pgp.mit.edu)
