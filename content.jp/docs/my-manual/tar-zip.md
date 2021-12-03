---
title: "File Compression and Decompression (tar, zip, lzh, bz2)"
description: ""
lead: ""
date: 2021-11-29T12:36:33+09:00
lastmod: 2021-11-29T12:36:33+09:00
draft: false
images: []
menu: 
  docs:
    parent: "my-manual"
weight: 10
toc: true
---

## Usage

| Extension | Compression | Decompression |
| :-------- | :---------- | :------------ |
| zip       | `zip -r output.zip dir`           | `unzip input.zip`         |
| tar       | `tar -cvf output.tar dir`         | `tar -xvf input.tar`      |
| tar.gz    | `tar -acvf output.tar.gz dir`     | `tar -xvf input.tar.gz`   |
| tar.bz2   | `tar -acvf output.tar.bz2 dir`    | `tar -xvf input.tar.bz2`  |
| tar.xz    | `tar -acvf output.tar.xz dir`     | `tar -xvf input.tar.xz`   |
| lzh       | `lha -c output.lzh dir`           | `lha -x input.lzh`        |
| bz2       | `bzip2 -z input.file`             | `bzip2 -dk input.bz2`     |

## Meaning of options (tar)

| Option | Meaning |
|:-------|:--------|
| -a     | --auto-compress  |
| -c     | --create         |
| -v     | --verbose        |
| -f     | --file=ARCHIVE   |
| -x     | --extract        |
