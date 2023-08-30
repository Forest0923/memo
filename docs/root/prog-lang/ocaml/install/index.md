---
title: "OCaml 環境構築"
draft: false
weight: 10
---
## Install

OCaml のパッケージマネージャである opam をインストールします．

```sh
sudo pacman -S opam
```

OCaml のビルドツールである dune は opam を使ってインストールします．

```sh
opam install dune
```

## Basic Usage

REPL は `ocaml` を実行すると使用できます．

```text
% ocaml
        OCaml version 4.13.1

# 1+1;;
- : int = 2
# exit 0;;
```

Dune を使う場合は `dune init` を実行します．

```sh
dune init exe myproj
```

```text
.
├── _build
│  └── log
├── dune
└── myproj.ml
```

`dune build` を実行してビルドします．

```text
.
├── _build
│  ├── default
│  │  ├── dune
│  │  ├── myproj.exe
│  │  └── myproj.ml
│  └── log
├── dune
├── dune-project
└── myproj.ml
```

実行する際は `dune exe` を使用します．

```sh
dune exec ./myproj.exe
```

## Reference

- [Up and Running with OCaml](https://ocaml.org/learn/tutorials/up_and_running.html)
