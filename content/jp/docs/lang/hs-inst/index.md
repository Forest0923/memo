---
title: "Install Haskell"
draft: false
weight: 60
---

# Install Haskell

## Install Stack

- Commands:

```sh
paru -S stack
```

## Basic Usage

- Create new projects:

```sh
stack new proj-name
```

- Main source code is created in the `proj-name/app` as `Main.hs`.

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

- Compile:

```sh
stack build
```

- Run:

```sh
stack exec proj-name-exe
```
