---
title: Tools
date: 2020-02-25
---

## Binary editor
- hexedit
- Install:

```
$ sudo apt install hexedit
```

- ghex
- Install:

```
$ sudo apt install ghex
```

## Assembler
- nasm (or gas)
- Usage:

```
$ nasm input.asm -o output (-l output.lst)
```

## C compiler
- gcc
- Usage:

```
$ gcc -march=i486 -m32 -fno-pie -nostdlib -T [linkerfile] -g *.c *.o -o bootpack.bin
```

## Make OS image
- Merge asmhead.bin and bootpack.bin:

```
$ cat asmhead.bin bootpack.bin > os.sys
```

- mtools
- Usage:

```
$ mformat -f 1440 -C -B ipl.bin -i os.img ::
$ mcopy -i os.img os.sys ::
```

- Meaning of options:

| Option | Meaning |
|:-|:-|
| -f | Filesize |
| -C | Create MS-MOS file system |
| -B | Boot sector |

## Emulator
- qemu
- Installation:

```
$ sudo apt install qemu
```

- Usage:

```
$ qemu-system-i386 -fda os.img
```

- Option "-fda" means use of floppy disk 

