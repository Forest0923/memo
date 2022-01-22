---
title: "Install OCaml"
draft: false
weight: 10
---

# Install OCaml

## Install

Install opam, the package manager for OCaml.

```sh
sudo pacman -S opam
```

Dune, the OCaml build tool, is installed using opam.

```sh
opam install dune
```

## Basic Usage

REPL can be used by running `ocaml`.

```text
% ocaml
        OCaml version 4.13.1

# 1+1;;
- : int = 2
# exit 0;;
```

To create a new project using Dune, run `dune init`.

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

To build a project, run `dune build`.

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

To execute, run `dune exe`.

```sh
dune exec ./myproj.exe
```

## Reference

- [Up and Running with OCaml](https://ocaml.org/learn/tutorials/up_and_running.html)
