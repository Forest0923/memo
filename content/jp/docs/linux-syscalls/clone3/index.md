+++
title = "clone3"
description = "NR = 435"
tags = [
  "Linux", "System Calls"
]
categories = [
  "Linux Code Reading"
]
weight = 0
draft = false
+++

## Version

- Linux v5.8.13

## Abstract

```c
long sys_clone3(struct clone_args __user *uargs, size_t size);
```

## Arguments

### arg1: `struct clone_args __user *uargs`

- kernel/fork.c

```c
struct clone_args {
	__aligned_u64 flags;
	__aligned_u64 pidfd;
	__aligned_u64 child_tid;
	__aligned_u64 parent_tid;
	__aligned_u64 exit_signal;
	__aligned_u64 stack;
	__aligned_u64 stack_size;
	__aligned_u64 tls;
	__aligned_u64 set_tid;
	__aligned_u64 set_tid_size;
	__aligned_u64 cgroup;
};
```

### arg2: `size_t size`

`sizeof(clone_args)`

## Return

返り値は生成されたスレッドの tid．失敗した場合は -1 が返る．

## Definitions

- kernel/fork.c

```c
/**
 * clone3 - create a new process with specific properties
 * @uargs: argument structure
 * @size:  size of @uargs
 *
 * clone3() is the extensible successor to clone()/clone2().
 * It takes a struct as argument that is versioned by its size.
 *
 * Return: On success, a positive PID for the child process.
 *         On error, a negative errno number.
 */
SYSCALL_DEFINE2(clone3, struct clone_args __user *, uargs, size_t, size)
{
	int err;

	struct kernel_clone_args kargs;
	pid_t set_tid[MAX_PID_NS_LEVEL];

	kargs.set_tid = set_tid;

	err = copy_clone_args_from_user(&kargs, uargs, size);
	if (err)
		return err;

	if (!clone3_args_valid(&kargs))
		return -EINVAL;

	return _do_fork(&kargs);
}
```

[see also linux-syscalls/clone](../clone/)

## Examples
