---
title: "Install Rust"
draft: false
weight: 10
---
## Install

Use rustup to install and version control rust.
After installing rustup, add `$HOME/.cargo/bin` to your PATH.

{{< tabpane >}}
{{< tab header="Arch" lang="sh" >}}

sudo pacman -S rustup

{{< /tab >}}
{{< tab header="Otherwise" lang="sh" >}}

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

{{< /tab >}}
{{< /tabpane >}}

## rustup

To update rustc and other programs using rustup, run `rustup update`.

```sh
rustup update
```

If you want to update rustup itself, you can update it with the package manager of your distribution or run `rustup self update`.

```sh
rustup self update
```

Uninstall rustup with following command.

```sh
rustup self uninstall
```

## cargo

To create new project, run `cargo new`.

{{< tabpane >}}
{{< tab header="executable" lang="sh" >}}

cargo new dir_name --bin

{{< /tab >}}
{{< tab header="library" lang="sh" >}}

cargo new dir_name --lib

{{< /tab >}}
{{< /tabpane >}}

If you don't use version control such as git, add `--vcs none`.

```sh
cargo new dir_name --bin --vcs none
```

Build is done with `cargo build`, but if you don't want to make an executable, run `cargo check`.

```sh
cargo build # create executable file
cargo check # don't create executable file
```

To execute it, use `cargo run`.

```sh
cargo run
```

If you want to run it in the nightly version of rust, you can do the following.

```sh
rustup run nightly cargo run
```

## rustc

rustc is a compiler for rust that can handle small code without using cargo.

```sh
rustc main.rs
./main
```

## rustfmt

```sh
rustfmt main.rs
```