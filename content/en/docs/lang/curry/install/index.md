---
title: "Install Curry"
draft: false
weight: 10
---

# Install Curry

Curry is a language that has features of both functional and logic programming languages. PAKCS is an interpreter that can execute programs written in Curry. PAKCS converts Curry code into Prolog and executes it.

## Install

{{< tabpane "install" >}}
{{< tab "Arch" >}}

```sh
paru -S pakcs
```

{{< /tab >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt-add-repository ppa:swi-prolog/stable
sudo apt update
sudo apt install swi-prolog
sudo apt install pakcs
```

{{< /tab >}}
{{< /tabpane >}}

[download site](https://www.informatik.uni-kiel.de/~pakcs/download.html)

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
