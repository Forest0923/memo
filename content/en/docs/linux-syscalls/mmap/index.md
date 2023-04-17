+++
title = "mmap"
description = "NR = 9"
tags = [
  "Linux", "System Calls"
]
categories = [
  "Linux Code Reading"
]
weight = 9
draft = false
+++

## Version

- Linux v5.8.13

## Abstract

```c
long sys_mmap(unsigned long addr, unsigned long len,
			unsigned long prot, unsigned long flags,
			unsigned long fd, off_t pgoff);
```

## Arguments

## Return

## Definitions

### `sys_mmap()`

- arch/x86/kernel/sys_x86_64.c

```c
SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
		unsigned long, prot, unsigned long, flags,
		unsigned long, fd, unsigned long, off)
{
	long error;
	error = -EINVAL;
	if (off & ~PAGE_MASK)
		goto out;

	error = ksys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
out:
	return error;
}
```

### `ksys_mmap_pgoff()`

- mm/mmap.c

```c
unsigned long ksys_mmap_pgoff(unsigned long addr, unsigned long len,
			      unsigned long prot, unsigned long flags,
			      unsigned long fd, unsigned long pgoff)
{
	struct file *file = NULL;
	unsigned long retval;

	if (!(flags & MAP_ANONYMOUS)) {
		audit_mmap_fd(fd, flags);
		file = fget(fd);
		if (!file)
			return -EBADF;
		if (is_file_hugepages(file))
			len = ALIGN(len, huge_page_size(hstate_file(file)));
		retval = -EINVAL;
		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
			goto out_fput;
	} else if (flags & MAP_HUGETLB) {
		struct user_struct *user = NULL;
		struct hstate *hs;

		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
		if (!hs)
			return -EINVAL;

		len = ALIGN(len, huge_page_size(hs));
		/*
		 * VM_NORESERVE is used because the reservations will be
		 * taken when vm_ops->mmap() is called
		 * A dummy user value is used because we are not locking
		 * memory so no accounting is necessary
		 */
		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
				VM_NORESERVE,
				&user, HUGETLB_ANONHUGE_INODE,
				(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
		if (IS_ERR(file))
			return PTR_ERR(file);
	}

	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);

	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
out_fput:
	if (file)
		fput(file);
	return retval;
}
```

### `vm_mmap_pgoff()`

- mm/util.c

```c
unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
	unsigned long len, unsigned long prot,
	unsigned long flag, unsigned long pgoff)
{
	unsigned long ret;
	struct mm_struct *mm = current->mm;
	unsigned long populate;
	LIST_HEAD(uf);

	ret = security_mmap_file(file, prot, flag);
	if (!ret) {
		if (mmap_write_lock_killable(mm))
			return -EINTR;
		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
				    &populate, &uf);
		mmap_write_unlock(mm);
		userfaultfd_unmap_complete(mm, &uf);
		if (populate)
			mm_populate(ret, populate);
	}
	return ret;
}
```

### `do_mmap_pgoff()`

- include/linux/mm.h

```c
static inline unsigned long
do_mmap_pgoff(struct file *file, unsigned long addr,
	unsigned long len, unsigned long prot, unsigned long flags,
	unsigned long pgoff, unsigned long *populate,
	struct list_head *uf)
{
	return do_mmap(file, addr, len, prot, flags, 0, pgoff, populate, uf);
}
```

## Examples
