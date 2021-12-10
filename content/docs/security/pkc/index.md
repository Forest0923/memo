---
title: "Public Key Cryptography"
draft: false
weight: 10
---

# Public Key Cryptography

## Type of keys

- RSA
  - <https://ocw.kyoto-u.ac.jp/ja/graduate-school-of-informatics-jp/06/video02/08>
  - <http://herb.h.kobe-u.ac.jp/RSA.html>
  - <https://tools.ietf.org/html/rfc8017>
- DSA
  - <https://tools.ietf.org/html/rfc6605>
- ECDSA
  - <https://tools.ietf.org/html/rfc6979>
- EdDSA
  - <https://tools.ietf.org/html/rfc8032>

## SSH key

- [Comparing SSH Keys - RSA, DSA, ECDSA, or EdDSA?](https://goteleport.com/blog/comparing-ssh-keys/)
- [SSHの公開鍵暗号には「RSA」「DSA」「ECDSA」「EdDSA」のどれを使えばよいのか？](https://gigazine.net/news/20200828-ssh-encryption-algorithm/)

## Key generation

- RSA:

```sh
ssh-keygen -t rsa -b 4096
```

- ECDSA:

```sh
ssh-keygen -t ecdsa -b 521
```

- EdDSA:

```sh
ssh-keygen -t ed25519
```
