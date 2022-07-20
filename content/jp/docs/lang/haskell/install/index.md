---
title: "Haskell 環境構築"
draft: false
weight: 10
---
Haskell を Stack を用いてインストールするためのメモです．

## Install Stack

Stack は haskell のプロジェクトを管理するためのツールでコンパイラやパッケージのインストール，プロジェクトのビルドなどを行えます．インストールは下記のように行います．

{{< tabpane >}}
{{< tab "Arch" >}}

```sh
sudo pacman -S stack
```

{{< /tab >}}
{{< tab "Ubuntu" >}}

```sh
curl -sSL https://get.haskellstack.org/ | sh
stack upgrade
```

{{< /tab >}}
{{< /tabpane >}}

## Basic Usage

新しいプロジェクトを作成するには `stack new` を実行します．

```sh
stack new hs-proj
```

新しいプロジェクトを作成すると以下のようなディレクトリ構造が作られるので，Main.hs にメインのコードを記述します．

```text
.
├── app
│  └── Main.hs
├── ChangeLog.md
├── LICENSE
├── package.yaml
├── proj-name.cabal
├── README.md
├── Setup.hs
├── src
│  └── Lib.hs
├── stack.yaml
├── stack.yaml.lock
└── test
   └── Spec.hs
```

コンパイルは `stack build` で行います．

```sh
stack build
```

実行する際は `stack exec *-exe` を実行します．

```sh
stack exec hs-proj-exe
```

## Remove stack

`~/.stack` と `/usr/local/bin/stack` を削除します．

## Reference

- [The Haskell Tool Stack](https://docs.haskellstack.org/en/stable/README/)
