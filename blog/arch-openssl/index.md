---
title: "[Solved] paru (AUR helper) が動かない (November 7, 2022)"
description: ""
date: 2022-11-07T08:21:51+09:00
tags: []
---

## Issue

今朝、paruを使用してアプリケーションをアップグレードできませんでした。以下のエラーメッセージが表示されました。

```text
$ paru -Syu
paru: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory
```

問題は、opensslのバージョンが1.1から3に更新され、paruが使用していたライブラリのバージョンがなくなったことでした。

## Solution

pacmanを使用してopenssl v1.1をインストールしました。幸いにも、今回はpacmanが利用可能でした。

```sh
sudo pacman -S openssl-1.1
```
