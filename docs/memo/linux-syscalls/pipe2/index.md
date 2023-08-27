---
title: "pipe2"
description: "NR = 293 <br> cf. [pipe](/memo/ja/docs/linux-syscalls/pipe/)"
tags: [
  "Linux", "System Calls"
]
---

## Version

- Linux v5.8.13

## Abstract

```c
long sys_();
```

## Arguments

## Return

## Definitions

### `sys_pipe2()`

- fs/pipe.c

```c
SYSCALL_DEFINE2(pipe2, int __user *, fildes, int, flags)
{
	return do_pipe2(fildes, flags);
}
```

## Examples
