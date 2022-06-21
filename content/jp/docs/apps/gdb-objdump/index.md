---
title: "Debugging with gdb and objdump"
draft: false
weight: 999
---

# Debugging with gdb and objdump

## gdb

### LD_PRELOAD

```sh
gdb ./a.out
```

```text
(gdb) set envirnment LD_PRELOAD ./hook.so
(gdb) start
```

### Memory Dump

```text
(gdb) x/[size]s [address]
```

## objdump

```sh
objdump [option] [executable file]
```

|Options|Descriptions|
|-------|------------|
|-f||
|-p||
