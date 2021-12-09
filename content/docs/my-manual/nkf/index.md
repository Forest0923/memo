---
title: "File Encoding with nkf"
description: ""
lead: ""
date: 2021-11-29T12:36:44+09:00
lastmod: 2021-11-29T12:36:44+09:00
draft: false
images: []
menu: 
  docs:
    parent: "my-manual"
weight: 20
toc: true
---

## Installation

```sh
sudo apt install nkf
```

## Usage

- To convert any file to UTF-8 + LF:

```sh
nkf -w -Lu --overwrite input_file
```

- To convert C files in current directory to UTF-8 + LF:

```sh
find . -iname "*.c" -type f -print0 | xargs -0 nkf -w -LF --overwrite
```
