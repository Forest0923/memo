---
title: File compression and decompression
date: 2020-02-24
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

## Meaning of options (tar)

| Option | Meaning |
|:-------|:--------|
| -a     | --auto-compress  |
| -c     | --create         |
| -v     | --verbose        |
| -f     | --file=ARCHIVE   |
| -x     | --extract        |
