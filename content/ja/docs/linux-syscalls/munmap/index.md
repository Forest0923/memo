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

### `__vm_munmap()`

- mm/mmap.c

```c
static int __vm_munmap(unsigned long start, size_t len, bool downgrade)
{
	int ret;
	struct mm_struct *mm = current->mm;
	LIST_HEAD(uf);

	if (mmap_write_lock_killable(mm))
		return -EINTR;

	ret = __do_munmap(mm, start, len, &uf, downgrade);
	/*
	 * Returning 1 indicates mmap_lock is downgraded.
	 * But 1 is not legal return value of vm_munmap() and munmap(), reset
	 * it to 0 before return.
	 */
	if (ret == 1) {
		mmap_read_unlock(mm);
		ret = 0;
	} else
		mmap_write_unlock(mm);

	userfaultfd_unmap_complete(mm, &uf);
	return ret;
}
```

mm/mmap.c の外から呼び出したい場合には `vm_munmap()` を使用する．

プロトタイプは `include/linux/mm.h` に宣言されている．

```c
int vm_munmap(unsigned long start, size_t len)
{
	return __vm_munmap(start, len, false);
}
EXPORT_SYMBOL(vm_munmap);
```

## Examples
