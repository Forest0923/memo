---
title: "pipe"
description: "NR = 22 <br> cf. [pipe2](/memo/ja/docs/linux-syscalls/pipe2/)"
tags: [
  "Linux", "System Calls"
]
---

## Version

- Linux v5.8.13

## Abstract

```c
long sys_pipe(int __user *fildes);
```

## Arguments

## Return

## Definitions

### `sys_pipe()`

- fs/pipe.c

```c
SYSCALL_DEFINE1(pipe, int __user *, fildes)
{
	return do_pipe2(fildes, 0);
}
```

### `do_pipe2()`

- fs/pipe.c

```c
/*
 * sys_pipe() is the normal C calling standard for creating
 * a pipe. It's not the way Unix traditionally does this, though.
 */
static int do_pipe2(int __user *fildes, int flags)
{
	struct file *files[2];
	int fd[2];
	int error;

	error = __do_pipe_flags(fd, files, flags);
	if (!error) {
		if (unlikely(copy_to_user(fildes, fd, sizeof(fd)))) {
			fput(files[0]);
			fput(files[1]);
			put_unused_fd(fd[0]);
			put_unused_fd(fd[1]);
			error = -EFAULT;
		} else {
			fd_install(fd[0], files[0]);
			fd_install(fd[1], files[1]);
		}
	}
	return error;
}
```

## Examples
