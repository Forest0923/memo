---
title: "GitHub CLI"
draft: false
weight: 10
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

このページでは GitHub CLI のインストール，設定，使い方をまとめます．

## インストール

下記のコマンドでインストールします．

<Tabs groupId="gh" queryString>
  <TabItem value="arch" label="Arch">
  ```sh
sudo pacman -S github-cli
  ```
  </TabItem>
  <TabItem value="ubuntu" label="Ubuntu">
Ubuntu の場合は apt から直接インストールできないので，snap 経由でインストールします．

```sh
sudo apt install snapd
```

```sh
sudo snap install gh
```
  </TabItem>
</Tabs>

## 設定

次のコマンドを実行することでアカウントの認証ができます．

```sh
gh auth login
```

ステップごとにガイドが表示されるので環境に合わせて選択すれば認証できます．

```text
? What account do you want to log into?  [Use arrows to move, type to filter]
> GitHub.com
  GitHub Enterprise Server
```

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

```text
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? SSH
? Upload your SSH public key to your GitHub account? /home/user/.ssh/id_ed25519.pub
? How would you like to authenticate GitHub CLI?  [Use arrows to move, type to filter]
> Login with a web browser
  Paste an authentication token
```

```text
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? SSH
? Upload your SSH public key to your GitHub account? /home/user/.ssh/id_ed25519.pub
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: 51E6-B724
- Press Enter to open github.com in your browser...
```

## 使い方

### **リポジトリ作成**

GitHub に新しいリポジトリを追加したいときは，ブラウザから GUI で作成するか，gh を下記のように使います．

```sh
gh repo create <repo-name> <visibility>
```

例：github-test という名前のプライベートリポジトリを作成する

```sh
gh repo create github-test --private
```

例：github-test という名前のパブリックリポジトリを作成する

```sh
gh repo create github-test --public
```
