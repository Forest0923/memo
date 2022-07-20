---
title: "自作 OS 入門 with Ubuntu"
draft: false
weight: 30
---
「自作 OS 入門」を Ubuntu で行う際の Tips をまとめました．

> [My HariboteOS](https://github.com/Forest0923/my-haribote-os)


## 環境

- OS: Ubuntu 18.04

## 使用したツール

### **Binary editor**

- hexedit

```sh
sudo apt install hexedit
```

- ghex

```sh
sudo apt install ghex
```

### Assembler

- nasm

```sh
sudo apt install nasm
```

```sh
nasm input.asm -o output (-l output.lst)
```

### C Compiler

- gcc

```sh
gcc -march=i486 -m32 -fno-pie -nostdlib -T [linkerfile] -g *.c *.o -o bootpack.bin
```

### Make OS Image

asmhead.bin と bootpack.bin は cat でテキストとしてつなげることでマージできます．

```sh
cat asmhead.bin bootpack.bin > os.sys
```

OS のイメージを生成するために mtools を使用します．

```sh
mformat -f 1440 -C -B ipl.bin -i os.img ::
mcopy -i os.img os.sys ::
```

mtools のオプションの意味は次のようになっています．

| Options | Descriptions |
|:-|:-|
| -f | ファイルサイズ |
| -C | MS-MOS ファイルシステムを指定 |
| -B | ブートセクタ |

### Emulator

エミュレータは QEMU と VirtualBox を使用しました．途中から QEMU でうまく動作しない問題があったため，以降は VirtualBox で実験を行いました．
QEMU で実行する場合は下記のコマンドでブートしました．`-fda` はフロッピーディスクを使用しているという意味です．

```sh
qemu-system-i386 -fda os.img
```
