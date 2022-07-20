---
title: "日本語入力"
draft: false
weight: 999
---
Fcitx（Flexible Input Method Framework）と Mozc を用いた日本語入力の設定のメモです．

## インストール

{{< tabpane >}}
{{< tab "fcitx5" >}}

fcitx5 は fcitx の後継のソフトウェアです．

```sh
sudo pacman -S fcitx5-mozc fcitx5-im fcitx5-configtool
```

{{< /tab >}}
{{< tab "fcitx" >}}

```sh
sudo pacman -S fcitx-mozc fcitx-im fcitx-configtool
```

{{< /tab >}}
{{< /tabpane >}}

## 設定

fcitx configuration の入力メソッドに Mozc を追加し，`~/.pam_environment` を作成します．

```sh
vim ~/.pam_environment
```

```diff
+ GTK_IM_MODULE DEFAULT=fcitx
+ QT_IM_MODULE  DEFAULT=fcitx
+ XMODIFIERS    DEFAULT=\@im=fcitx
+ SDL_IM_MODULE DEFAULT=fcitx
```

これで上手く行かない場合は下記のコマンドを実行します．

```sh
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"
```
