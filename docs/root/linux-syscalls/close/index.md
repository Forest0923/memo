---
title: "close"
description: "NR = 3"
tags: [
  "Linux", "System Calls"
]
---

## Version

- Linux v5.8.13

## Abstract

```c
long sys_close(unsigned int fd);
```

## Arguments

## Return

## Definitions

### `sys_close()`

- fs/open.c

```c
/*
 * Careful here! We test whether the file pointer is NULL before
 * releasing the fd. This ensures that one clone task can't release
 * an fd while another clone is opening it.
 */
SYSCALL_DEFINE1(close, unsigned int, fd)
{
	int retval = __close_fd(current->files, fd);

	/* can't restart close syscall because file table entry was cleared */
	if (unlikely(retval == -ERESTARTSYS ||
		     retval == -ERESTARTNOINTR ||
		     retval == -ERESTARTNOHAND ||
		     retval == -ERESTART_RESTARTBLOCK))
		retval = -EINTR;

	return retval;
}
```

### `__close_fd()`

- fs/file.c

```c
/*
 * The same warnings as for __alloc_fd()/__fd_install() apply here...
 */
int __close_fd(struct files_struct *files, unsigned fd)
{
	struct file *file;
	struct fdtable *fdt;

	spin_lock(&files->file_lock);
	fdt = files_fdtable(files);
	if (fd >= fdt->max_fds)
		goto out_unlock;
	file = fdt->fd[fd];
	if (!file)
		goto out_unlock;
	rcu_assign_pointer(fdt->fd[fd], NULL);
	__put_unused_fd(files, fd);
	spin_unlock(&files->file_lock);
	return filp_close(file, files);

out_unlock:
	spin_unlock(&files->file_lock);
	return -EBADF;
}
EXPORT_SYMBOL(__close_fd); /* for ksys_close() */
```

## Examples
