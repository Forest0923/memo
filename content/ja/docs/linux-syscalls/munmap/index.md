+++
title = "munmap"
description = "NR = 11"
tags = [
  "Linux", "System Calls"
]
categories = [
  "Linux Code Reading"
]
weight = 11
draft = false
+++

## Version

- Linux v5.8.13

## Abstract

```c
long sys_munmap(unsigned long addr, size_t len);
```

## Arguments

## Return

## Definitions

### `sys_munmap()`

- mm/mmap.c

```c
SYSCALL_DEFINE2(munmap, unsigned long, addr, size_t, len)
{
	addr = untagged_addr(addr);
	profile_munmap(addr);
	return __vm_munmap(addr, len, true);
}
```

## Examples
