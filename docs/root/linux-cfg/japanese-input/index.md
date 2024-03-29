---
title: "日本語入力"
draft: false
weight: 999
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

Fcitx（Flexible Input Method Framework）と Mozc を用いた日本語入力の設定のメモです．

## インストール

<Tabs groupId="fcitx" queryString>
  <TabItem value="fcitx5" label="fcitx5">

    ```sh
sudo pacman -S fcitx5-mozc fcitx5-im fcitx5-configtool
    ```

  </TabItem>
  <TabItem value="fcitx" label="fcitx">

    ```sh
sudo pacman -S fcitx-mozc fcitx-im fcitx-configtool
    ```

  </TabItem>
</Tabs>

fcitx5 は fcitx の後継のソフトウェアです．

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
