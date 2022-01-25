---
title: "キーマッピング"
draft: false
weight: 999
---

# キーマッピング

Caps lock などのキーに他のキーを割り当てる方法をメモします．

## Create Custom Key Mapping

キーマップを保存するためのディレクトリを作成します．

```sh
sudo mkdir -p /usr/local/share/kbd/keymaps
```

dumpkeys でオリジナルのキーを取得して保存します．

```sh
sudo dumpkeys | sudo tee /usr/local/share/kbd/keymaps/my-keymaps.map
```

`/usr/local/share/kbd/keymaps/my-keymaps.map` を修正して Caps lock をコントロールに変更します．

```sh
sudo vim /usr/local/share/kbd/keymaps/my-keymaps.map
```

```diff
- keycode  58 = Caps_Lock
+ keycode  58 = Control
```

`/etc/vconsole.conf` を作成して，`my-keymaps.map` を読み込ませます．

```diff
+ KEYMAP=/usr/local/share/kbd/keymaps/my-keymaps.map
```
