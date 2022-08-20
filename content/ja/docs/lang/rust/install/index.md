---
title: "Rust 環境構築"
draft: false
weight: 10
---
## Install

rustup を用いて rust のインストールやバージョン管理を行います．
rustup をインストールしたら `$HOME/.cargo/bin` を PATH に追加します．

{{< tabpane >}}
{{< tab header="Arch" lang="sh" >}}

sudo pacman -S rustup

{{< /tab >}}
{{< tab header="Otherwise" lang="sh" >}}

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

{{< /tab >}}
{{< /tabpane >}}

## rustup

rustup を用いて rustc などをアップデートする際には `rustup update` を実行します．

```sh
rustup update
```

rustup 自体をアップデートする場合にはディストリビューションのパケージマネージャでアップデートするか，`rustup self update` でアップデートします．

```sh
rustup self update
```

アンインストールは下記のコマンドで行います．

```sh
rustup self uninstall
```

## cargo

新しいプロジェクトは `cargo new` で作成します．

{{< tabpane >}}
{{< tab header="executable" lang="sh" >}}

cargo new dir_name --bin

{{< /tab >}}
{{< tab header="library" lang="sh" >}}

cargo new dir_name --lib

{{< /tab >}}
{{< /tabpane >}}

git などのバージョン管理を行わない場合は `--vcs none` をつけます．

```sh
cargo new dir_name --bin --vcs none
```

ビルドは `cargo build` で行いますが，実行ファイルを作らなくていい場合は `cargo check` を実行します．

```sh
cargo build # create executable file
cargo check # don't create executable file
```

実行する場合は `cargo run` を使います．

```sh
cargo run
```

nightly 版の rust で実行したい場合は下記のように実行します．

```sh
rustup run nightly cargo run
```

## rustc

rustc は rust のコンパイラで小さなコードであれば cargo を使わなくてもこれだけで対応できます．

```sh
rustc main.rs
./main
```

## rustfmt

```sh
rustfmt main.rs
```
