---
title: "HariboteOS with Ubuntu"
description: ""
lead: ""
date: 2021-11-29T12:46:19+09:00
lastmod: 2021-11-29T12:46:19+09:00
draft: false
images: []
menu: 
  docs:
    parent: "ubuntu"
weight: 30
toc: true
---

## Binary editor

- hexedit
- Install:

```sh
sudo apt install hexedit
```

- ghex
- Install:

```sh
sudo apt install ghex
```

## Assembler

- nasm (or gas)
- Usage:

```sh
nasm input.asm -o output (-l output.lst)
```

## C compiler

- gcc
- Usage:

```sh
gcc -march=i486 -m32 -fno-pie -nostdlib -T [linkerfile] -g *.c *.o -o bootpack.bin
```

## Make OS image

- Merge asmhead.bin and bootpack.bin:

```sh
cat asmhead.bin bootpack.bin > os.sys
```

- mtools
- Usage:

```sh
mformat -f 1440 -C -B ipl.bin -i os.img ::
mcopy -i os.img os.sys ::
```

- Meaning of options:

| Option | Meaning |
|:-|:-|
| -f | Filesize |
| -C | Create MS-MOS file system |
| -B | Boot sector |

## Emulator

- qemu (or VirtualBox)
- Installation:

```sh
sudo apt install qemu
```

- Usage:

```sh
qemu-system-i386 -fda os.img
```

- Option "-fda" means use of floppy disk
