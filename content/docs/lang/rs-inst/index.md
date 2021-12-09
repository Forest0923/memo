---
title: "Install Rust"
description: ""
lead: ""
date: 2021-11-29T14:56:27+09:00
lastmod: 2021-11-29T14:56:27+09:00
draft: false
images: []
menu: 
  docs:
    parent: "lang"
weight: 10
toc: true
---

## Installation

- Access to [Install Rust](https://www.rust-lang.org/tools/install).
- You will get command below, if you use linux or Mac.

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

- The command above create `/home/username/.cargo/` and you can use rust by adding path of `$HOME/.cargo/bin` to $PATH.

## `rustup`

- Update:

```sh
rustup update
```

- Update rustup:

```sh
rustup self update
```

- Uninstall:

```sh
rustup self uninstall
```

## `cargo`

- Create new project (executable):

```sh
cargo new dir_name --bin
```

- Create new library:

```sh
cargo new dir_name --lib
```

- By default, cargo add .git/ and .gitignore. If you don't want to use VCS:

```sh
cargo new dir_name --bin --vcs none
```

- If you want to use other VCS, you can use the following command:

```sh
cargo new dir_name --bin --vcs hg
cargo new dir_name --bin --vcs pijul
cargo new dir_name --bin --vcs fossil
```

- Build:

```sh
cargo build # create executable file
cargo check # don't create executable file
```

- Run:

```sh
cargo run
```

- Run with rust nightly:

```sh
rustup run nightly cargo run
```

## `rustc`

- `rustc` is a Rust compiler. This is enough if the source code is small like `hello world`.

```sh
rustc main.rs
./main
```

## `rustfmt`

- `rustfmt` formats source code.

```sh
rustfmt main.rs
```
