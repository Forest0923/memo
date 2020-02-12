---
title: Installation and basic usage
date: 2020-01-12
---

## Installation
- Access to [Install Rust](https://www.rust-lang.org/tools/install).
- You will get command below, if you use linux or Mac.

```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

- This command create `/home/username/.cargo/` and you can use rust by adding path to `$HOME/.cargo/bin`.

## `rustup`
- Update:

```
$ rustup update
```

- Update rustup:

```
$ rustup self update
```

- Uninstall:

```
$ rustup self uninstall
```

## `cargo`
- Create new project (executable):

```
$ cargo new dir_name --bin
```

- Create new library:

```
$ cargo new dir_name --lib
```

- By default, cargo add .git/ and .gitignore. If you don't want to use VCS:

```
$ cargo new dir_name --bin --vcs none
```

- If you want to use other VCS, you can use the following command:

```
$ cargo new dir_name --bin --vcs hg
$ cargo new dir_name --bin --vcs pijul
$ cargo new dir_name --bin --vcs fossil
```

- Build:

```
$ cargo build # create executable file
$ cargo check # don't create executable file
```

- Run:

```
$ cargo run
```

## `rustc`
- `rustc` is a Rust compiler. This is enough if the source code is small like `hello world`.

```
$ rustc main.rs
$ ./main
```

## `rustfmt`
- `rustfmt` formats source code.

```
$ rustfmt main.rs
```
