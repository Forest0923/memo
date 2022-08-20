+++
title = "Manipulating FS/GS Segment Registers"
description = ""
date = 2022-07-01T13:12:18+09:00
tags = [
  "Segment", "Thread Local Storage", "x86"
]
categories = [
  "Linux Code Reading", "x86"
]
draft = false
+++

## Systems

- Linux v5.8.13
- x86-64

## Read

- File: arch/x86/kernel/process_64.c

```c
long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2)
{
	int ret = 0;

	switch (option) {
    ...
	case ARCH_GET_FS: {
		unsigned long base = x86_fsbase_read_task(task);

		ret = put_user(base, (unsigned long __user *)arg2);
		break;
	}
	case ARCH_GET_GS: {
		unsigned long base = x86_gsbase_read_task(task);

		ret = put_user(base, (unsigned long __user *)arg2);
		break;
	}
	...
	default:
		ret = -EINVAL;
		break;
	}

	return ret;
}
```

- File: arch/x86/kernel/process_64.c

```c
static unsigned long x86_fsgsbase_read_task(struct task_struct *task,
					    unsigned short selector)
{
	unsigned short idx = selector >> 3;
	unsigned long base;

	if (likely((selector & SEGMENT_TI_MASK) == 0)) {
		if (unlikely(idx >= GDT_ENTRIES))
			return 0;

		/*
		 * There are no user segments in the GDT with nonzero bases
		 * other than the TLS segments.
		 */
		if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
			return 0;

		idx -= GDT_ENTRY_TLS_MIN;
		base = get_desc_base(&task->thread.tls_array[idx]);
	} else {
#ifdef CONFIG_MODIFY_LDT_SYSCALL
		struct ldt_struct *ldt;

		/*
		 * If performance here mattered, we could protect the LDT
		 * with RCU.  This is a slow path, though, so we can just
		 * take the mutex.
		 */
		mutex_lock(&task->mm->context.lock);
		ldt = task->mm->context.ldt;
		if (unlikely(!ldt || idx >= ldt->nr_entries))
			base = 0;
		else
			base = get_desc_base(ldt->entries + idx);
		mutex_unlock(&task->mm->context.lock);
#else
		base = 0;
#endif
	}

	return base;
}

unsigned long x86_fsbase_read_task(struct task_struct *task)
{
	unsigned long fsbase;

	if (task == current)
		fsbase = x86_fsbase_read_cpu();
	else if (task->thread.fsindex == 0)
		fsbase = task->thread.fsbase;
	else
		fsbase = x86_fsgsbase_read_task(task, task->thread.fsindex);

	return fsbase;
}

unsigned long x86_gsbase_read_task(struct task_struct *task)
{
	unsigned long gsbase;

	if (task == current)
		gsbase = x86_gsbase_read_cpu_inactive();
	else if (task->thread.gsindex == 0)
		gsbase = task->thread.gsbase;
	else
		gsbase = x86_fsgsbase_read_task(task, task->thread.gsindex);

	return gsbase;
}
```

- File: arch/x86/include/asm/fsgsbase.h

```c
#include <asm/msr-index.h>

/*
 * Read/write a task's FSBASE or GSBASE. This returns the value that
 * the FS/GS base would have (if the task were to be resumed). These
 * work on the current task or on a non-running (typically stopped
 * ptrace child) task.
 */
extern unsigned long x86_fsbase_read_task(struct task_struct *task);
extern unsigned long x86_gsbase_read_task(struct task_struct *task);

/* Helper functions for reading/writing FS/GS base */

static inline unsigned long x86_fsbase_read_cpu(void)
{
	unsigned long fsbase;

	rdmsrl(MSR_FS_BASE, fsbase);

	return fsbase;
}

static inline unsigned long x86_gsbase_read_cpu_inactive(void)
{
	unsigned long gsbase;

	rdmsrl(MSR_KERNEL_GS_BASE, gsbase);

	return gsbase;
}
```

## Write

File: arch/x86/kernel/process_64.c

```c
long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2)
{
	int ret = 0;

	switch (option) {
	case ARCH_SET_GS: {
		if (unlikely(arg2 >= TASK_SIZE_MAX))
			return -EPERM;

		preempt_disable();
		/*
		 * ARCH_SET_GS has always overwritten the index
		 * and the base. Zero is the most sensible value
		 * to put in the index, and is the only value that
		 * makes any sense if FSGSBASE is unavailable.
		 */
		if (task == current) {
			loadseg(GS, 0);
			x86_gsbase_write_cpu_inactive(arg2);

			/*
			 * On non-FSGSBASE systems, save_base_legacy() expects
			 * that we also fill in thread.gsbase.
			 */
			task->thread.gsbase = arg2;

		} else {
			task->thread.gsindex = 0;
			x86_gsbase_write_task(task, arg2);
		}
		preempt_enable();
		break;
	}
	case ARCH_SET_FS: {
		/*
		 * Not strictly needed for %fs, but do it for symmetry
		 * with %gs
		 */
		if (unlikely(arg2 >= TASK_SIZE_MAX))
			return -EPERM;

		preempt_disable();
		/*
		 * Set the selector to 0 for the same reason
		 * as %gs above.
		 */
		if (task == current) {
			loadseg(FS, 0);
			x86_fsbase_write_cpu(arg2);

			/*
			 * On non-FSGSBASE systems, save_base_legacy() expects
			 * that we also fill in thread.fsbase.
			 */
			task->thread.fsbase = arg2;
		} else {
			task->thread.fsindex = 0;
			x86_fsbase_write_task(task, arg2);
		}
		preempt_enable();
		break;
	}
	...
	default:
		ret = -EINVAL;
		break;
	}

	return ret;
}
```

File: arch/x86/include/asm/fsgsbase.h

```c
#include <asm/msr-index.h>

/*
 * Read/write a task's FSBASE or GSBASE. This returns the value that
 * the FS/GS base would have (if the task were to be resumed). These
 * work on the current task or on a non-running (typically stopped
 * ptrace child) task.
 */
extern void x86_fsbase_write_task(struct task_struct *task, unsigned long fsbase);
extern void x86_gsbase_write_task(struct task_struct *task, unsigned long gsbase);

/* Helper functions for reading/writing FS/GS base */

static inline void x86_fsbase_write_cpu(unsigned long fsbase)
{
	wrmsrl(MSR_FS_BASE, fsbase);
}

static inline void x86_gsbase_write_cpu_inactive(unsigned long gsbase)
{
	wrmsrl(MSR_KERNEL_GS_BASE, gsbase);
}
```

File: arch/x86/kernel/process_64.c

```c
void x86_fsbase_write_task(struct task_struct *task, unsigned long fsbase)
{
	WARN_ON_ONCE(task == current);

	task->thread.fsbase = fsbase;
}

void x86_gsbase_write_task(struct task_struct *task, unsigned long gsbase)
{
	WARN_ON_ONCE(task == current);

	task->thread.gsbase = gsbase;
}
```
