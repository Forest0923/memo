---
title: "GitHub CLI"
draft: false
weight: 10
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

In this page, I will explain how to install, configure and use the GitHub CLI.

## **Install**

Use the following command to install GitHub CLI.

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

## **Configuration**

You can authenticate your account by executing the following command.

```sh
gh auth login
```

There is a step-by-step guide, so you can choose the one that best suits your environment.

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

## How to Use

### **Create Repository**

If you want to add a new repository to GitHub, you can either create it in the GUI from your browser, or use gh as shown below.

```sh
gh repo create <repo-name> <visibility>
```

Example: Create a private repository named github-test

```sh
gh repo create github-test --private
```

Example: Create a public repository named github-test

```sh
gh repo create github-test --public
```
