+++
title = "Data Structures Related to File I/O in Linux"
description = "ファイルのオープンなどを行ったときのカーネル空間のデータ構造について調査する"
date = 2022-07-04T13:18:29+09:00
tags = [
  "Linux", "File I/O"
]
categories = [
  "Linux Code Reading"
]
menu = "main"
draft = false
+++

## Data Structures

- File: include/linux/sched.h

```c
struct task_struct {
	...
	/* Open file information: */
	struct files_struct		*files;
	...
};
```

- File: include/linux/fdtable.h

```c
/*
 * #ifdef CONFIG_64BIT
 * #define BITS_PER_LONG 64
 * #else
 * #define BITS_PER_LONG 32
 * #endif
 */

/*
 * The default fd array needs to be at least BITS_PER_LONG,
 * as this is the granularity returned by copy_fdset().
 */
#define NR_OPEN_DEFAULT BITS_PER_LONG

struct fdtable {
	unsigned int max_fds;
	struct file __rcu **fd;      /* current fd array */
	unsigned long *close_on_exec;
	unsigned long *open_fds;
	unsigned long *full_fds_bits;
	struct rcu_head rcu;
};

...

/*
 * Open file table structure
 */
struct files_struct {
  /*
   * read mostly part
   */
	atomic_t count;
	bool resize_in_progress;
	wait_queue_head_t resize_wait;

	struct fdtable __rcu *fdt;
	struct fdtable fdtab;
  /*
   * written part on a separate cache line in SMP
   */
	spinlock_t file_lock ____cacheline_aligned_in_smp;
	unsigned int next_fd;
	unsigned long close_on_exec_init[1];
	unsigned long open_fds_init[1];
	unsigned long full_fds_bits_init[1];

	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
};
```
