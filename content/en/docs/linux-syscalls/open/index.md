+++
title = "open"
description = "NR = 2 <br> cf. [openat](/memo/ja/docs/linux-syscalls/openat/)"
tags = [
  "Linux", "System Calls"
]
categories = [
  "Linux Code Reading"
]
weight = 2
draft = false
+++

## Version

- Linux v5.8.13

## Abstract

## Arguments

## Return

## Definitions

### `sys_open()`

- fs/open.c

```c
SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
{
	return ksys_open(filename, flags, mode);
}
```

### `ksys_open()`

- include/linux/syscalls.h

```c
static inline long ksys_open(const char __user *filename, int flags,
			     umode_t mode)
{
	if (force_o_largefile())
		flags |= O_LARGEFILE;
	return do_sys_open(AT_FDCWD, filename, flags, mode);
}
```

### `do_sys_open()`

- fs/open.c

```c
long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
{
	struct open_how how = build_open_how(flags, mode);
	return do_sys_openat2(dfd, filename, &how);
}
```

### `do_sys_openat2()`

- fs/open.c

```c
static long do_sys_openat2(int dfd, const char __user *filename,
			   struct open_how *how)
{
	struct open_flags op;
	int fd = build_open_flags(how, &op);
	struct filename *tmp;

	if (fd)
		return fd;

	tmp = getname(filename);
	if (IS_ERR(tmp))
		return PTR_ERR(tmp);

	fd = get_unused_fd_flags(how->flags);
	if (fd >= 0) {
		struct file *f = do_filp_open(dfd, tmp, &op);
		if (IS_ERR(f)) {
			put_unused_fd(fd);
			fd = PTR_ERR(f);
		} else {
			fsnotify_open(f);
			fd_install(fd, f);
		}
	}
	putname(tmp);
	return fd;
}
```

## Examples
