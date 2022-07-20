---
title: "Prolog 環境構築"
draft: false
weight: 10
---
## Install

- Commands:

```sh
sudo pacman -S swi-prolog
```

## Basic Usage

- Sample program:

```prolog
%% family.pl
parent(alice).
parent(bob).
child(charlie).
child(dave).

parent_child(alice, charlie).
parent_child(alice, dave).
parent_child(bob, charlie).
parent_child(bob, dave).

sibling(X,Y) :-
    parent_child(Z, X),
    parent_child(Z, Y).
```

- Start interactive shell with `swipl`.

```text
$ swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 8.2.3)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit https://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

?-
```

- Load files:

```prolog
?- consult('family.pl').
?- reconsult('family.pl').
```

- Test:

```prolog
?- consult('family.pl').
true.

?- parent(X).
X = alice ;
X = bob.

?- parent_child(alice,X).
X = charlie ;
X = dave.

?- parent_child(X,charlie).
X = alice ;
X = bob ;
false.

?- sibling(X,dave).
X = charlie ;
X = dave ;
X = charlie ;
X = dave.
```
