---
title: "read"
description: "NR = 0"
tags: [
  "Linux", "System Calls"
]
---

## Version

- Linux v5.8.13

## Abstract

```c
long sys_read(unsigned int fd, char __user *buf, size_t count);
```

## Arguments

## Return

## Definitions

### `sys_read()`

- file: fs/read_write.c

```c
SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
{
	return ksys_read(fd, buf, count);
}
```

### `ksys_read()`

```c
ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count)
{
	struct fd f = fdget_pos(fd);
	ssize_t ret = -EBADF;

	if (f.file) {
		loff_t pos, *ppos = file_ppos(f.file);
		if (ppos) {
			pos = *ppos;
			ppos = &pos;
		}
		ret = vfs_read(f.file, buf, count, ppos);
		if (ret >= 0 && ppos)
			f.file->f_pos = pos;
		fdput_pos(f);
	}
	return ret;
}
```

## Examples
