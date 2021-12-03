---
title: "Install Curry"
description: ""
lead: ""
date: 2021-11-29T14:58:02+09:00
lastmod: 2021-11-29T14:58:02+09:00
draft: false
images: []
menu: 
  docs:
    parent: "lang"
weight: 80
toc: true
---

## About PAKCS

- PAKCS enables to run programs written in Curry language.
- Curry combines the features of functional and logical programming languages.
- PAKCS converts Curry code to Prolog and execute.

## Install on Ubuntu

- At first, you have to install swi-prolog.

```sh
sudo apt-add-repository ppa:swi-prolog/stable
sudo apt update
sudo apt install swi-prolog
```

- In Ubuntu, you can install PAKCS by following command.

```sh
sudo apt install pakcs
```

- However, due to unknown errors, it is recommended to download from [download site](https://www.informatik.uni-kiel.de/~pakcs/download.html).
- Decompress the downloaded file and run the following command.

```sh
make SWIPROLOG=/usr/bin/swipl
```

- Add `pakcs-version/bin` to PATH.

## Install on Arch

- Commands:

```sh
paru -S pakcs
```

## Basic Usage

- Sample program:

```haskell
-- family.curry
data Person = Alice | Bob | Charlie | Dave

parent Alice	= True
parent Bob	= True
child Charlie	= True
child Dave	= True

parent_child Alice Charlie	= True
parent_child Alice Dave		= True
parent_child Bob Charlie	= True
parent_child Bob Dave		= True

sibling x y = parent_child z x & parent_child z y
	where z free
```

- Enter interactive shell with `pakcs`:

```text
$ pakcs
which: no rlwrap in (/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl)
>>> /home/user/.pakcsrc installed.
 __    _
|_ \  | |            PAKCS - the Portland Aachen Kiel Curry System
  \ \ | |____
  /  \|  ____|       Version 3.3.0 of 2021-02-15 (swi 8.2)
 / /\ \ |
/_/  \_\|            (using Curry Package Manager, version 3.0.0)


Type ":h" for help (contact: pakcs@curry-lang.org)
Prelude>
```

- Load files:

```text
Prelude> :l family
```

- Test:

```text
family> parent Alice
True
family> child Dave
True
family> parent_child Bob Charlie
True
family> sibling Charlie Dave
True
True
family>
```

> Reference:
>
> [Curry - A Tutorial Introduction](https://www.informatik.uni-kiel.de/~curry/tutorial/tutorial.pdf)
