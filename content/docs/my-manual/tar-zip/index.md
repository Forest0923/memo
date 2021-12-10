---
title: "File Compression and Decompression (tar, zip, lzh, bz2)"
draft: false
weight: 10
---

# File Compression and Decompression (tar, zip, lzh, bz2)

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
