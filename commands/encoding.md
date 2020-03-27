---
title: File encoding
date: 2020-02-24
---

## Installation

```
$ sudo apt install nkf
```

## Usage
- To convert any file to (UTF-8 + LF):

```
nkf -w -Lu --overwrite input_file
```

- To convert C files in current directory to (UTF-8 + LF):

```
find . -iname "*.c" -type f -print0 | xargs -0 nkf -w -LF --overwrite
```
