+++
title = "glibc syscall"
description = "glibc における syscall() の実装を調査する"
tags = [
  "glibc"
]
draft = false
+++

## Version

- glibc v2.35

## Definition

- include/unistd.h

```c
#ifndef _UNISTD_H
# include <posix/unistd.h>
...
```

- include/posix/unistd.h

```c
#ifdef __USE_MISC
/* Invoke `system call' number SYSNO, passing it the remaining arguments.
   This is completely system-dependent, and not often useful.

   In Unix, `syscall' sets `errno' for all errors and most calls return -1
   for errors; in many systems you cannot pass arguments or get return
   values for all system calls (`pipe', `fork', and `getppid' typically
   among them).

   In Mach, all system calls take normal arguments and always return an
   error code (zero for success).  */
extern long int syscall (long int __sysno, ...) __THROW;

#endif	/* Use misc.  */
```

- sysdeps/unix/sysv/linux/x86_64/syscall.S

```asm
	.text
ENTRY (syscall)
	movq %rdi, %rax		/* Syscall number -> rax.  */
	movq %rsi, %rdi		/* shift arg1 - arg5.  */
	movq %rdx, %rsi
	movq %rcx, %rdx
	movq %r8, %r10
	movq %r9, %r8
	movq 8(%rsp),%r9	/* arg6 is on the stack.  */
	syscall			/* Do the system call.  */
	cmpq $-4095, %rax	/* Check %rax for error.  */
	jae SYSCALL_ERROR_LABEL	/* Jump to error handler if error.  */
	ret			/* Return to caller.  */

PSEUDO_END (syscall)
```

- sysdeps/unix/sysv/linux/x86_64/sysdep.h

```c
# undef	PSEUDO_END
# define PSEUDO_END(name)						      \
  SYSCALL_ERROR_HANDLER							      \
  END (name)
```
