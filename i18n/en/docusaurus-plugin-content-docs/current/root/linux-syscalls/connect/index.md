---
title: "connect"
description: "NR = 42"
tags: [
  "Linux", "System Calls"
]
---

## Version

- Linux v5.8.13

## Abstract

```c
long sys_connect(int fd, struct sockaddr __user *uservaddr, int addrlen);
```

## Arguments

## Return

## Definitions

### `sys_connect()`

- net/socket.c

```c
SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
		int, addrlen)
{
	return __sys_connect(fd, uservaddr, addrlen);
}
```

### `__sys_connect()`

- net/socket.c

```c
int __sys_connect(int fd, struct sockaddr __user *uservaddr, int addrlen)
{
	int ret = -EBADF;
	struct fd f;

	f = fdget(fd);
	if (f.file) {
		struct sockaddr_storage address;

		ret = move_addr_to_kernel(uservaddr, addrlen, &address);
		if (!ret)
			ret = __sys_connect_file(f.file, &address, addrlen, 0);
		if (f.flags)
			fput(f.file);
	}

	return ret;
}
```

## Examples
