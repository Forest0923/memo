---
title: "GNU Privacy Guard"
draft: false
weight: 20
---
GnuPG は OpenPGP 標準の暗号化規格でデータや通信に暗号化を行ったり署名をしたりすることができます．

## GnuPG の使い方

### **登録されている鍵の表示**

公開鍵の表示：

```sh
gpg --list-keys
```

秘密鍵の表示：

```sh
gpg --list-secret-keys
```

### **新しい公開鍵の追加**

```sh
gpg --keyserver keys.gnupg.net --recv-keys [key id]
```

### **鍵の削除**

```sh
gpg --delete-keys [key id]
```

## Key Servers

- [keys.openpgp.org](https://keys.openpgp.org)
- [keys.gnupg.net](http://keys.gnupg.net)
- [keys.mailvelope.com](https://keys.mailvelope.com)
- [pgp.mit.edu](http://pgp.mit.edu)
