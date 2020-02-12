---
title: Installation: PAKCS
date: 2020-02-12
---

## About PAKCS
- PAKCS enables to run programs written in Curry language.
- Curry combines the features of functional and logical programming languages.
- PAKCS converts Curry code to Prolog and execute.

## Installation
- At first, you have to install swi-prolog.

```
$ sudo apt-add-repository ppa:swi-prolog/stable
$ sudo apt update
$ sudo apt install swi-prolog
```

- In Ubuntu, you can install PAKCS by following command.

```
$ sudo apt install pakcs
```

- However, due to unknown errors, it is recommended to download from [download site](https://www.informatik.uni-kiel.de/~pakcs/download.html).
- Decompress the downloaded compressed file and run the following command.

```
$ make SWIPROLOG=/usr/bin/swipl
```

- Add path to `pakcs-version/bin`