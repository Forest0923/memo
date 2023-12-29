---
title: "GitHub への SSH 接続"
draft: false
weight: 20
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## SSH Key の生成

ssh-keygen を用いて下記のようにコマンドを実行すると選択したアルゴリズムで鍵が生成されます．

<Tabs groupId="algorhism" queryString>
  <TabItem value="EdDSA" label="EdDSA">
  ```sh
ssh-keygen -t ed25519
  ```
  </TabItem>
  <TabItem value="rsa" label="RSA">
  ```sh
ssh-keygen -t rsa -b 4096
  ```
  </TabItem>
  <TabItem value="ecdsa" label="ECDSA">
  ```sh
ssh-keygen -t ecdsa -b 521
  ```
  </TabItem>
</Tabs>

生成時に特に変更を加えなければ `~/.ssh` に秘密鍵の `id_[algorithm]` と公開鍵の `id_[algorithm].pub` が生成されます．

## SSH Agent への秘密鍵の登録

SSH Agent に鍵を登録することで，毎回パスフレーズを求められることがなくなります．

```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_[algorithm]
```

## GitHub への公開鍵の登録

### ブラウザから登録する場合

GitHub で自分のアカウントページから `Settings > SSH and GPG keys` と進み，`New SSH key` を押して `id_[algorithm].pub` の内容をコピペして登録します．

### GitHub CLI を用いる場合

GitHub CLI の初期設定で実行する下記コマンドでも鍵を登録できます．

```sh
gh auth login
```

接続プロトコルで SSH を選んだ場合に公開鍵をアップロードするか選択することができます．

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

## 接続テスト

下記のコマンドを実行して接続テストを行います．

```sh
ssh git@github.com
```

フィンガープリントが表示されるので，[GitHub の SSH キーフィンガープリント](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints) と比較して github.com であることを確認したら yes を選択します．

> Reference:
>
> [GitHubにSSHで接続する](https://help.github.com/ja/github/authenticating-to-github/connecting-to-github-with-ssh)
