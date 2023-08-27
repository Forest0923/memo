---
title: "Introduction to Creating Your Own OS with Ubuntu"
draft: false
weight: 30
---
This article is tips for creating HariboteOS.

> [My HariboteOS](https://github.com/Forest0923/my-haribote-os)

## System Setup

- OS: Ubuntu 18.04

## Tools Used

### **Binary editor**

- hexedit

```sh
sudo apt install hexedit
```

- ghex

```sh
sudo apt install ghex
```

### **Assembler**

- nasm

```sh
sudo apt install nasm
```

```sh
nasm input.asm -o output (-l output.lst)
```

### **C Compiler**

- gcc

```sh
gcc -march=i486 -m32 -fno-pie -nostdlib -T [linkerfile] -g *.c *.o -o bootpack.bin
```

### **Make OS Image**

You can merge asmhead.bin and bootpack.bin by using cat to connect them as text.

```sh
cat asmhead.bin bootpack.bin > os.sys
```

Use mtools to export the OS image.

```sh
mformat -f 1440 -C -B ipl.bin -i os.img ::
mcopy -i os.img os.sys ::
```

The meaning of the options in mtools is as follows.

| Options | Descriptions |
|:-|:-|
| -f | Filesize |
| -C | Create MS-MOS file system |
| -B | Boot sector |

### **Emulator**

I used QEMU and VirtualBox as emulators. Since there was a problem that QEMU did not work well, I used VirtualBox after I faced the problem.

When using QEMU, you can boot OS with the following command. `-fda` means image uses floppy disk format.

```sh
qemu-system-i386 -fda os.img
```
